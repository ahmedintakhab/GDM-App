import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Update',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            // Circle Avatar
            CircleAvatar(
              radius: 60.r, // Slightly larger than normal
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 60.r,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30.h),
            // Name Text Field
            CustomTextFormField(
              controller: nameController,
              hintText: 'Enter your name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            // Email Text Field
            CustomTextFormField(
              controller: emailController,
              hintText: 'Enter your email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            CustomTextFormField(
              controller: phoneController,
              hintText: 'Enter phone number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 30.h),
            CustomButton(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            }, buttonText: 'Update Profile')

          ],
        ),
      ),
    );
  }
}