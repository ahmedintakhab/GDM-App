import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../l10n/app_localizations.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import 'package:gdm_app/utils/utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isOldPasswordHidden = true; // Default to hidden
  bool isNewPasswordHidden = true; // Default to hidden
  bool isConfirmPasswordHidden = true; // Default to hidden
  bool isLoading = false;

  void toggleOldPasswordVisibility() {
    setState(() {
      isOldPasswordHidden = !isOldPasswordHidden;
      print('Old Password Hidden: $isOldPasswordHidden');
    });
  }

  void toggleNewPasswordVisibility() {
    setState(() {
      isNewPasswordHidden = !isNewPasswordHidden;
      print('New Password Hidden: $isNewPasswordHidden');
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
      print('Confirm Password Hidden: $isConfirmPasswordHidden');
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (_passwordController.text != _confirmPasswordController.text) {
      Utils().toastMessage(l10n.newPasswordsDoNotMatch);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        Utils().toastMessage(l10n.noUserLoggedIn);
        setState(() {
          isLoading = false;
        });
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_passwordController.text);

      Utils().toastMessage(l10n.passwordUpdated);
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = l10n.updateFailed;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'wrong-password':
            errorMessage = l10n.oldPasswordIncorrect;
            break;
          case 'weak-password':
            errorMessage = l10n.weakPassword;
            break;
          case 'requires-recent-login':
            errorMessage = l10n.loginRequired;
            break;
          default:
            errorMessage = l10n.updateFailed;
        }
      }
      Utils().toastMessage(errorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.changePassword,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5AA189),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            CustomTextFormField(
              controller: _oldPasswordController,
              hintText: l10n.oldPassword,
              labelText: l10n.oldPassword,
              isPasswordField: true,
              obscureText: isOldPasswordHidden,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterOldPassword;
                }
                return null;
              },
              suffixIcon: GestureDetector(
                onTap: toggleOldPasswordVisibility,
                child: Icon(
                  isOldPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: isOldPasswordHidden ? Colors.grey : Color(0xFF5AA189),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              controller: _passwordController,
              hintText: l10n.newPassword,
              labelText: l10n.newPassword,
              isPasswordField: true,
              obscureText: isNewPasswordHidden,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterNewPassword;
                }
                if (value.length < 6) {
                  return l10n.passwordMinLength;
                }
                return null;
              },
              suffixIcon: GestureDetector(
                onTap: toggleNewPasswordVisibility,
                child: Icon(
                  isNewPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: isNewPasswordHidden ? Colors.grey : Color(0xFF5AA189),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hintText: l10n.confirmNewPassword,
              labelText: l10n.confirmNewPassword,
              isPasswordField: true,
              obscureText: isConfirmPasswordHidden,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseConfirmNewPassword;
                }
                return null;
              },
              suffixIcon: GestureDetector(
                onTap: toggleConfirmPasswordVisibility,
                child: Icon(
                  isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: isConfirmPasswordHidden ? Colors.grey : Color(0xFF5AA189),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            CustomButton(
              onTap: () => _changePassword(context),
              buttonText: l10n.changePassword,
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}