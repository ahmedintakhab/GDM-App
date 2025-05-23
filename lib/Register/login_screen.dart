import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/forgot_password_screen.dart';
import 'package:gdm_app/Register/users_signup_screen.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Home/home_main_screen.dart';
import '../Home/user_data_provider.dart';
import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  final ReminderService reminderService;

  const LoginScreen({super.key, required this.reminderService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false ;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;
   final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await Provider.of<ReminderService>(context, listen: false).init();
        await regenerateFcmToken(context); // Regenerate FCM token after auth state change
      }
    });
  }

     regenerateFcmToken(BuildContext context) async {
    print('Regenerating FCM token');
    await FirebaseMessaging.instance.deleteToken();
    await Provider.of<ReminderService>(context, listen: false).updateFCMToken();
    print('FCM token regeneration completed');
  }



  void togglePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  void Login() async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Utils().toastMessage('User Login Successfully!');

      // Fetch new user data after successful login
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen(reminderService: widget.reminderService)));
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        Utils().toastMessage('No user found for this email.');

      } else if (e.code == 'wrong-password') {
        Utils().toastMessage('Incorrect password. Please try again.');
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      Utils().toastMessage(errorMessage);
    } catch (e) {
      Utils().toastMessage('Something went wrong. Please try again.');
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
                          "Login",
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

              SizedBox(height: 20.h),

              // Added Image Above Email Field
              Center(
                child: Image.asset(
                  "assets/images/splash.png",
                  height: 120.h,
                ),
              ),

              SizedBox(height: 20.h),

              Form(
                key: formkey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: emailController,
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
                    SizedBox(height: 15.h),

                    // Password Field with Eye Icon Toggle
                    CustomTextFormField(
                      controller: passwordController,
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

                    SizedBox(height: 15.h),
                    forgotpassword(),
                    SizedBox(height: 20.h),

                    CustomButton(
                      onTap: Login,
                      buttonText: "Login",
                      loading: loading,
                    ),

                    SizedBox(height: 20.h),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontFamily: 'Gilroy'),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(UsersSignupScreen(reminderService: widget.reminderService));
                                },
                              text: 'Sign up',
                              style: TextStyle(
                                color: Color(0XFF000000),
                                fontSize: 15.sp,
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

  Widget forgotpassword() {
    return GestureDetector(
      onTap: () {
        Get.to( ForgotPassword(reminderService: widget.reminderService));
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          "Forgot password?",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Color(0XFF5AA189),
          ),
        ),
      ),
    );
  }
}
