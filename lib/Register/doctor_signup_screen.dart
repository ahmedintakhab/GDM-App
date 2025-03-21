import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:get/get.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/intl_phone_field.dart';

class DoctorSignupScreen extends StatefulWidget {
  @override
  _DoctorSignupScreenState createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false ;
  final  _nameController = TextEditingController();
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  bool isPasswordHidden = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumber = '';

  void togglePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  void Signup() async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),);

      //Save user data to firestore
      await _firestore.collection('doctor').doc(
          userCredential.user!.uid).set({
        'name' : _nameController.text,
        'email': _emailController.text,
        // 'phone Number': phoneNumber,
        'password': _passwordController.text

      });
      //Clear all fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      // phoneNumber.trim();
      //Show success toast
      Utils().toastMessage('User successfully Regitered!');
      // Navigate only if validation is successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }catch (error){
      Utils().toastMessage(error.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          "Sign Up",
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
                 child:Text("Create an Account!",style: TextStyle(fontSize: 22,
                     fontWeight: FontWeight.w500),)
                
                // Image.asset(
                //   "assets/images/splash.png",
                //   height: 120.h,
                // ),
              ),

              SizedBox(height: 30.h),

              Form(
                key: formkey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: 'Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    CustomTextFormField(
                      controller: _emailController,
                      hintText: "Email",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter the email';
                        } else {
                          if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(val)) {
                            return 'Please enter a valid email address';
                          }
                        }
                        return null;
                      },
                    ),
                     SizedBox(height: 16.h),

                    // phone_number_field(
                    //   onPhoneNumberChanged: (String phone) {
                    //     setState(() {
                    //       phoneNumber = phone; // Store the phone number
                    //     });
                    //   },
                    //   validator: (String? value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter phone number';
                    //     }
                    //     return null;
                    //   },
                    // ),

                    // Password Field with Eye Icon Toggle
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                      obscureText: isPasswordHidden,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter the password';
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

                    SizedBox(height: 30.h),

                    CustomButton(
                      onTap: Signup,
                      buttonText: "Sign Up",
                      loading: loading,
                    ),

                    SizedBox(height: 25.h),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account?  ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontFamily: 'Gilroy'),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to( LoginScreen());
                                },
                              text: 'Login',
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
