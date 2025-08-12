import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Register/weight_input_field.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';
import '../l10n/app_localizations.dart';


class WithoutPregnancySignup extends StatefulWidget {
  final String selectedOption;
  final ReminderService reminderService;

  const WithoutPregnancySignup({Key? key, required this.selectedOption, required this.reminderService}): super (key: key);

  @override
  State<WithoutPregnancySignup> createState() => _WithoutPregnancySignupState();
}
final _formKey = GlobalKey<FormState>();

class _WithoutPregnancySignupState extends State<WithoutPregnancySignup> {
  bool loading =false;
  final  _ageController = TextEditingController();
  final  _heightController = TextEditingController();
  final  _ethnicityController = TextEditingController();
  final  _diabetesController = TextEditingController();
  final  _waistController = TextEditingController();
  final  _hypertensionController = TextEditingController();
  final _weightController = TextEditingController();
  final ValueNotifier<String> _selectedUnit = ValueNotifier<String>('kg');
  AppLocalizations? _l10n; // Store AppLocalizations instance

  // String phoneNumber = '';
  String? _selectedGender; // To store selected gender (Male or Female)
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _ethnicityController.dispose();
    _diabetesController.dispose();
    _waistController.dispose();
    _hypertensionController.dispose();
    _weightController.dispose();
    _selectedUnit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _l10n = AppLocalizations.of(context); // Initialize _l10n
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
                children:  [
                  Text(
                    _l10n!.tellUsAboutYourself,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _l10n!.personalizationMessage,
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

                      // Gender Selection (Radio Buttons)
                       Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          _l10n!.genderLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1, right: 70),
                        child: Row(
                          children: [
                            Flexible(
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                title: Text(_l10n!.maleOption),
                                value: 'Male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                title: Text(_l10n!.femaleOption),
                                value: 'Female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Weight Input
                      WeightInputField(
                        weightController: _weightController,
                        selectedUnit: _selectedUnit,
                      ),
                      const SizedBox(height: 16),
                      // Age Input
                      CustomTextFormField(
                        controller: _ageController,
                        hintText: _l10n!.ageLabel,
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
                        hintText: _l10n!.heightLabel,
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
                        hintText: _l10n!.ethnicityLabel,
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
                        hintText: _l10n!.diabetesLabel,
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
                        hintText: _l10n!.waistLabel,
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
                        hintText: _l10n!.hypertensionLabel,
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
                        'gender': _selectedGender,
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
                      _ageController.clear();
                      _heightController.clear();
                      _ethnicityController.clear();
                      _diabetesController.clear();
                      _waistController.clear();
                      _hypertensionController.clear();
                      setState(() {
                        _selectedGender = null; // Clear gender selection
                      });

                      //Show success toast
                      Utils().toastMessage(_l10n!.personalInfoSaved);
                      // Navigate only if validation is successful
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(reminderService: widget.reminderService)),
                      );
                    }
                    else {
                      Utils().toastMessage(_l10n!.noUserLoggedIn);
                    }
                  } catch (error) {
                    String errorMessage = _l10n!.firestoreGenericError;

                    // Handle specific Firestore errors
                    if (error is FirebaseException) {
                      switch (error.code) {
                        case 'permission-denied':
                          errorMessage = _l10n!.permissionDenied;
                          break;
                        case 'unavailable':
                          errorMessage = _l10n!.firestoreUnavailable;
                          break;
                        case 'not-found':
                          errorMessage = _l10n!.notFound;
                          break;
                        case 'cancelled':
                          errorMessage = _l10n!.operationCancelled;
                          break;
                        case 'deadline-exceeded':
                          errorMessage = _l10n!.deadlineExceeded;
                          break;
                        default:
                          errorMessage = _l10n!.firestoreGenericError;
                      }
                    }

                    Utils().toastMessage(errorMessage);
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
              buttonText: _l10n!.submit,
              loading: loading,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}