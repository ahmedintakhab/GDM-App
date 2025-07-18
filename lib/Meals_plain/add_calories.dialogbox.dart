import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:gdm_app/utils/utils.dart';
import 'meals_data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCaloriesDialogBox extends StatefulWidget {
  const AddCaloriesDialogBox({Key? key}) : super(key: key);

  @override
  _AddCaloriesDialogBoxState createState() => _AddCaloriesDialogBoxState();
}

class _AddCaloriesDialogBoxState extends State<AddCaloriesDialogBox> {
  final TextEditingController _caloriesController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentCalories();
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentCalories() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final mealsSnapshot = await _firestore
          .collection('Users')
          .doc(uid)
          .collection('Meals Plain')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (mealsSnapshot.docs.isNotEmpty) {
        final data = mealsSnapshot.docs.first.data();
        final currentCalories = data['Daily Calories'] ?? 0;
        if (mounted) {
          setState(() {
            _caloriesController.text = currentCalories.toString();
          });
        }
      }
    } catch (e) {
      print('Error fetching current calories: $e');
    }
  }

  Future<void> _saveCaloriesData() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        Utils().toastMessage(l10n.noUserLoggedIn);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        final calories = int.tryParse(_caloriesController.text);
        if (calories == null || calories <= 0) {
          Utils().toastMessage(l10n.please_enter_valid_calorie_value);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final calorieData = {
          'Daily Calories': calories,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await _firestore
            .collection('Users')
            .doc(uid)
            .collection('Meals Plain')
            .add(calorieData);

        Utils().toastMessage(l10n.successfully_added_daily_calories);

        // Refresh meals data
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Provider.of<MealsProvider>(context, listen: false).fetchMealsData();
        });

        Navigator.pop(context);
      } else {
        Utils().toastMessage(l10n.user_not_found_in_collection);
      }
    } catch (e) {
      Utils().toastMessage('${l10n.error_adding_calories} $e');
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Center(
        child: Text(
          l10n.set_calories,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: l10n.set_daily_cal,
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF5AA189), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF5AA189), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveCaloriesData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(l10n.add_cal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}