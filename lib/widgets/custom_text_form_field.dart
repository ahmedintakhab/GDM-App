import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CustomTextFormField({
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?) validator,
  bool isPasswordField = false,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordField && obscureText,
    cursorColor: const Color(0xFF5AA189),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15.sp,
        fontFamily: 'Gilroy',
        color: const Color(0XFF9B9B9B),
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0XFF5AA189), width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      ),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
    ),
    validator: validator,
  );
}