import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/selection_screen.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';

import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class UsersSignupScreen extends StatefulWidget {
  final ReminderService reminderService;
  const UsersSignupScreen({Key? key, required this.reminderService}) : super(key: key);

  @override
  _UsersSignupScreenState createState() => _UsersSignupScreenState();
}

class _UsersSignupScreenState extends State<UsersSignupScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false ;
  final  _nameController = TextEditingController();
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  final  _confirmpasswordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumber = '';
  AppLocalizations? _l10n; // Store AppLocalizations instance


  void togglePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }
  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
    });
  }

  void Signup() async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmpasswordController.text) {
      Utils().toastMessage(_l10n!.passwordsDoNotMatch);
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user data to Firestore
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        // Avoid storing passwords in Firestore for security reasons
        // 'password': _passwordController.text,
        // 'confirm password': _confirmpasswordController.text
      });

      // Clear all fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmpasswordController.clear();

      // Show success toast
      Utils().toastMessage(_l10n!.signUpSuccess);

      // Navigate to SelectionScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionScreen(reminderService: widget.reminderService),
        ),
      );
    } catch (error) {
      String errorMessage = _l10n!.genericError;

      // Handle specific Firebase Auth errors
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = _l10n!.emailAlreadyInUse;
            break;
          case 'invalid-email':
            errorMessage = _l10n!.invalidEmail;
            break;
          case 'weak-password':
            errorMessage = _l10n!.weakPassword;
            break;
          case 'operation-not-allowed':
            errorMessage = _l10n!.operationNotAllowed;
            break;
          case 'too-many-requests':
            errorMessage = _l10n!.tooManyRequests;
            break;
          default:
            errorMessage = _l10n!.genericError;
        }
      }

      Utils().toastMessage(errorMessage);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    _l10n = AppLocalizations.of(context); // Initialize _l10n
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 26.h),

              // Back Arrow and Centered Login Text
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.h),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 38.0),
                        child: Text(
                          _l10n!.signUp,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28.sp,
                            fontFamily: 'Gilroy',
                            color: Color(0XFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Added Image Above Email Field
              Center(
                  child:Text(_l10n!.createAccount,style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.w500),)

              ),

              SizedBox(height: 30.h),

              Form(
                key: formkey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: _l10n!.nameLabel,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _l10n!.pleaseEnterName;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    CustomTextFormField(
                      controller: _emailController,
                      hintText: _l10n!.emailLabel,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return _l10n!.pleaseEnterEmail;
                        } else {
                          if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(val)) {
                            return _l10n!.invalidEmail;
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Password Field with Eye Icon Toggle
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: _l10n!.passwordLabel,
                      isPasswordField: true,
                      obscureText: isPasswordHidden,
                      validator: (val) {
                        if (val == null || val.isEmpty) return _l10n!.pleaseEnterPassword;
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: togglePasswordVisibility,
                        child: Icon(
                          isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                          color: isPasswordHidden ? Colors.grey : Color(0xFF5AA189),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Confirm Password Field with Eye Icon Toggle
                    CustomTextFormField(
                      controller: _confirmpasswordController,
                      hintText: _l10n!.confirmPasswordLabel,
                      isPasswordField: true,
                      obscureText: isConfirmPasswordHidden,
                      validator: (val) {
                        if (val == null || val.isEmpty) return _l10n!.pleaseEnterConfirmPassword;
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
                      onTap: Signup,
                      buttonText: _l10n!.signUp,
                      loading: loading,
                    ),

                    SizedBox(height: 25.h),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: _l10n!.signUpPrompt,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontFamily: 'Gilroy'),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.off( LoginScreen(reminderService: widget.reminderService));
                                },
                          // ..onTap = () {
                          //         Get.to( SelectionScreen(reminderService: widget.reminderService));
                          //       },
                              text: _l10n!.login,
                              style: TextStyle(
                                color: Color(0XFF000000),
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
