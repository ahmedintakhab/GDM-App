import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/weight_input_field.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';

class WithoutPregnancySignup extends StatefulWidget {
  final String selectedOption;
  const WithoutPregnancySignup({Key? key, required this.selectedOption}): super (key: key);

  @override
  State<WithoutPregnancySignup> createState() => _WithoutPregnancySignupState();
}
final _formKey = GlobalKey<FormState>();

class _WithoutPregnancySignupState extends State<WithoutPregnancySignup> {
  bool loading =false;
  // final _nameController = TextEditingController();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  final  _ageController = TextEditingController();
  final  _genderController = TextEditingController();
  final  _heightController = TextEditingController();
  final  _ethnicityController = TextEditingController();
  final  _diabetesController = TextEditingController();
  final  _waistController = TextEditingController();
  final  _hypertensionController = TextEditingController();
  // String phoneNumber = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print("Check the selected option: ${widget.selectedOption}");
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Text Widgets
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tell us about yourself',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your individual parameters are important for\nthe in-depth personalization.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child:Form(
                  key: _formKey, // Set Form key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CustomTextFormField(
                      //   controller: _nameController,
                      //   hintText: 'Enter your name',
                      //   validator: (value) => value?.isEmpty ?? true ? 'Please enter name' : null,
                      // ),
                      // SizedBox(height: 16),
                      //
                      // CustomTextFormField(
                      //   controller: _emailController,
                      //   hintText: 'Enter your email',
                      //   validator: (value) => value?.isEmpty ?? true ? 'Please enter email' : null,
                      // ),
                      // SizedBox(height: 16),
                      // CustomTextFormField(
                      //   controller: _passwordController,
                      //   hintText: 'Enter your password',
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter password';
                      //     } else if (value.length < 6) {
                      //       return 'Password must be at least 6 characters';
                      //     }
                      //     return null;
                      //   },
                      // ),

                      SizedBox(height: 16),
                      // Gender Selection
                      CustomTextFormField(
                        controller: _genderController,
                        hintText: 'Male or Female',
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your gender';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Weight Input
                      WeightInputField(),
                      const SizedBox(height: 16),
                      // Age Input
                      CustomTextFormField(
                        controller: _ageController,
                        hintText: 'Enter your age',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your age';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Height Input
                      CustomTextFormField(
                        controller: _heightController,
                        hintText: 'Enter your height',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your height';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Ethnicity
                      CustomTextFormField(
                        controller: _ethnicityController,
                        hintText: 'Enter your Ethnicity',
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your Ethnicity';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Diabetes
                      CustomTextFormField(
                        controller: _diabetesController,
                        hintText: 'Enter your Diabetes',
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your diabetes';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Waist field
                      CustomTextFormField(
                        controller: _waistController,
                        hintText: 'Enter your waist',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your waist';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Hypertension
                      CustomTextFormField(
                        controller: _hypertensionController,
                        hintText: 'History of hypertension',
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter your hypertension';
                          // }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Next Button with Validation
            CustomButton(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  try {
                    // UserCredential userCredential = await _auth
                    //     .createUserWithEmailAndPassword(
                    //   email: _emailController.text.toString(),
                    //   password: _passwordController.text.toString(),);
                    User? user = _auth.currentUser;
                    if(user!= null) {
                      // Save personal information under the current user's document
                      await _firestore.collection('Users').
                      doc(user.uid).collection('Personal Information').doc().set({

                        'selectedOption': widget.selectedOption,
                        // 'name': _nameController.text,
                        // 'email': _emailController.text,
                        // 'phone Number': phoneNumber,
                        'gender': _genderController.text,
                        'age': _ageController.text,
                        'height': _heightController.text,
                        'ethnicity': _ethnicityController.text,
                        'diabetes': _diabetesController.text,
                        'waist': _waistController.text,
                        'hypertension': _hypertensionController.text,
                        'timestamp': FieldValue.serverTimestamp(),

                      });
                      //Clear all fields
                      // _nameController.clear();
                      // _emailController.clear();
                      // _passwordController.clear();
                      _genderController.clear();
                      _ageController.clear();
                      _heightController.clear();
                      _ethnicityController.clear();
                      _diabetesController.clear();
                      _waistController.clear();
                      _hypertensionController.clear();

                      //Show success toast
                      Utils().toastMessage('Personal information saved successfully!');
                      // Navigate only if validation is successful
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                    else {
                      Utils().toastMessage('No user is currently logged in');
                    }
                  } catch (error){
                    Utils().toastMessage(error.toString());
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
              buttonText: 'Submit',
              loading: loading,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}