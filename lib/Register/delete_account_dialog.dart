import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:gdm_app/utils/utils.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../Meals_plain/meals_data_provider.dart';

class DeleteAccountDialog extends StatefulWidget {
  final ReminderService reminderService;
  const DeleteAccountDialog({Key? key, required this.reminderService})
      : super(key: key);

  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isReauthRequired = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteUserAccount(BuildContext context, UserProvider userProvider, MealsProvider mealsProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(l10n.noUserSignedIn);
    }

    // Delete subcollections first
    // 1. Delete Personal Information subcollection
    final personalInfoSnapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Personal Information')
        .get();
    for (var doc in personalInfoSnapshot.docs) {
      await doc.reference.delete();
    }

    // 2. Delete glucoseEntries subcollection
    final glucoseEntriesSnapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('glucoseEntries')
        .get();
    for (var doc in glucoseEntriesSnapshot.docs) {
      await doc.reference.delete();
    }

    // 3. Delete Meals Plain subcollection and its nested collections
    final mealsPlainSnapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Meals Plain')
        .get();
    for (var mealDoc in mealsPlainSnapshot.docs) {
      // Delete nested Foods collection
      final foodsSnapshot = await mealDoc.reference.collection('Foods').get();
      for (var foodDoc in foodsSnapshot.docs) {
        await foodDoc.reference.delete();
      }
      // Delete nested MealItems collection
      final mealItemsSnapshot = await mealDoc.reference.collection('MealItems').get();
      for (var itemDoc in mealItemsSnapshot.docs) {
        await itemDoc.reference.delete();
      }
      // Delete the meal document itself
      await mealDoc.reference.delete();
    }

    // Delete main user document from Users collection
    await _firestore.collection('Users').doc(user.uid).delete();

    // Delete user account from Firebase Authentication
    await user.delete();

    // Reset local state in providers
    userProvider.resetUserData();
    mealsProvider.resetUserData();
  }

  Future<void> _reauthenticateUser(BuildContext context, String password) async {
    final l10n = AppLocalizations.of(context)!;
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(l10n.noUserSignedIn);
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> _handleDeleteAccount(BuildContext context, UserProvider userProvider, MealsProvider mealsProvider) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await _deleteUserAccount(context, userProvider, mealsProvider);
      Navigator.of(context).pop(); // Close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginScreen(reminderService: widget.reminderService)),
      );
      Utils().toastMessage(l10n.deleteAccountSuccess);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        setState(() {
          _isReauthRequired = true;
        });
      } else {
        Navigator.of(context).pop(); // Close dialog
        Utils().toastMessage('${l10n.failedToDeleteAccount}: $e');
      }
    }
  }

  Future<void> _handleReauthentication(
      BuildContext context, UserProvider userProvider, MealsProvider mealsProvider) async {
    final l10n = AppLocalizations.of(context)!;

    if (_passwordController.text.isEmpty) {
      Utils().toastMessage(l10n.invalidCredentials);
      return;
    }

    try {
      await _reauthenticateUser(context, _passwordController.text.trim());
      Navigator.of(context).pop(); // Close re-auth dialog
      await _deleteUserAccount(context, userProvider, mealsProvider);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginScreen(reminderService: widget.reminderService)),
      );
      Utils().toastMessage(l10n.deleteAccountSuccess);
    } catch (e) {
      Utils().toastMessage('${l10n.reauthenticationFailed}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final mealsProvider = Provider.of<MealsProvider>(context, listen: false);

    return AlertDialog(
      title: Text(_isReauthRequired ? l10n.reauthenticate : l10n.deleteAccount),
      content: _isReauthRequired
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.reauthenticatePrompt),
          SizedBox(height: 10.h),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: l10n.passwordLabel,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      )
          : Text(l10n.deleteAccountConfirmation),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_isReauthRequired) {
                  await _handleReauthentication(context, userProvider, mealsProvider);
                } else {
                  await _handleDeleteAccount(context, userProvider, mealsProvider);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isReauthRequired ? Color(0xFF5AA189) : Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                _isReauthRequired ? l10n.submit : l10n.delete,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}