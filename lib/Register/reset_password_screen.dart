// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:get/get.dart';
import '../utils/screen_size.dart';
import '../widgets/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool ispassHiden = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;


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
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // back_button(),
                SizedBox(height: 20.h),
                Center(
                  child: Text("Reset Password",
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: 'Gilroy',
                          color: Color(0XFF000000),
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            "Enter password which are different from the previous paswords.",
                            style: TextStyle(
                                color: Color(0XFF000000),
                                fontSize: 15.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 20.h),
                     //Confirm Password Field with Eye Icon Toggle
                      CustomTextFormField(
                        controller: confirmpasswordController,
                        hintText: "Confirm Password",
                        isPasswordField: true,
                        obscureText: isPasswordHidden,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter the confirm password';
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: toggleConfirmPasswordVisibility,
                          child: Icon(
                            isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                            color:  isConfirmPasswordHidden ? Colors.grey : Color(0xFF5AA189),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      done_button(),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  toggle() {
    setState(() {
      ispassHiden = !ispassHiden;
    });
  }

  Widget back_button() {
    return TextButton(
        onPressed: () {
          Get.back();
        },
        child:Image(
          image: const AssetImage("assets/back_arrow.png"),
          height: 24.h,
          width: 24.w,
        ));
  }

  Widget done_button() {
    return Center(
      child: GestureDetector(
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: const Color(0XFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Image(image:const  AssetImage("assets/images/lock2.png"),
                          height: 100.13.h,width: 76.33.w,),
                        SizedBox(height: 20.h),
                        Text(
                          "Changed !",
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 20.h),
                        Align(
                          //alignment: Alignment.centerRight,
                          child: Text(
                            "Your password has been changed sucessfully ! ",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ok_button(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ); // Navigator.push(context,//     MaterialPageRoute(builder: (context) => const()));
        },
        child: Container(
          height: 56.h,
          width: 374.w,
          //color: Color(0XFF23408F),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF5AA189),
          ),
          child:  Center(
            child: Text("Done",
                style: TextStyle(
                    color: const Color(0XFFFFFFFF),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy')),
          ),
        ),
      ),
    );
  }

  Widget ok_button() {
    return Padding(
      padding:  EdgeInsets.only(top: 10.h, bottom: 20.h),
      child: Center(
        child: GestureDetector(
          onTap: () {

            Get.off(LoginScreen());
          },
          child: Container(
            height: 56.h,
            width: 334.w,
            //color: Color(0XFF23408F),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFF5AA189),
            ),
            child:  Center(
              child: Text("Ok",
                  style: TextStyle(
                      color: const Color(0XFFFFFFFF),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy')),
            ),
          ),
        ),
      ),
    );
  }
}


