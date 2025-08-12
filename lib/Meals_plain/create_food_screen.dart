import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import 'meals_data_provider.dart';
import '../l10n/app_localizations.dart';


class CreateFoodScreen extends StatefulWidget {
  const CreateFoodScreen({Key? key}) : super(key: key);

  @override
  _CreateFoodScreenState createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveFoodData() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

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
        String foodName = _nameController.text.trim();
        final foodData = {
          'foodName': foodName,
          'Food Calories': int.parse(_caloriesController.text.trim()),
          'quantity': _quantityController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Check if foodName already exists in Foods sub-collection
        DocumentReference foodDocRef = _firestore
            .collection('Users')
            .doc(uid)
            .collection('Meals Plain')
            .doc('data')
            .collection('Foods')
            .doc(foodName);

        DocumentSnapshot foodDoc = await foodDocRef.get();
        String finalDocId = foodName;

        if (foodDoc.exists) {
          // Append a counter to avoid duplicates
          int counter = 1;
          while (true) {
            finalDocId = '$foodName-$counter';
            foodDoc = await _firestore
                .collection('Users')
                .doc(uid)
                .collection('Meals Plain')
                .doc('data')
                .collection('Foods')
                .doc(finalDocId)
                .get();
            if (!foodDoc.exists) break;
            counter++;
          }
        }

        // Save food data with specific document ID
        await _firestore
            .collection('Users')
            .doc(uid)
            .collection('Meals Plain')
            .doc('data')
            .collection('Foods')
            .doc(finalDocId)
            .set(foodData);

        Utils().toastMessage(l10n.successfully_added_food);

        // Refresh meals data
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Provider.of<MealsProvider>(context, listen: false).fetchMealsData();
        });

        Navigator.pop(context);
      } else {
        Utils().toastMessage(l10n.user_not_found_in_collection);
      }
    } catch (e) {
      Utils().toastMessage('${l10n.error_adding_food} $e');
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5AA189),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.create_food,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  hintText: l10n.food_name_label,
                  labelText: l10n.food_name_label,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.please_enter_food_name;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: _caloriesController,
                  hintText: l10n.enter_calories,
                  labelText: l10n.calories_label,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.please_enter_calories;
                    }
                    if (int.tryParse(value.trim()) == null || int.parse(value.trim()) <= 0) {
                      return l10n.please_enter_valid_calorie_value;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: _quantityController,
                  hintText: l10n.enter_quantity,
                  labelText: l10n.quantity_label,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.please_enter_quantity;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  onTap: _saveFoodData,
                  buttonText: l10n.save_food,
                  loading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}