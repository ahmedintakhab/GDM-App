import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/reminder/all_reminders_screen.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../Register/login_screen.dart';
import '../Register/logout_dialog_widget.dart';
import '../reminder/add_reminders_screen.dart';
import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_text_form_field.dart';
import 'package:gdm_app/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final  _nameController = TextEditingController();
  final  _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final reminderService = ReminderService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData();
      if (mounted) {
        setState(() {
          _nameController.text = userProvider.name;
          _emailController.text = userProvider.email;
          _ageController.text = userProvider.age;
          _weightController.text = userProvider.weight;
          _heightController.text = userProvider.height;
          _ethnicityController.text = userProvider.ethnicity;
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ethnicityController.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: () async {
          try {
            await _auth.signOut();
            userProvider.resetUserData();
            Navigator.of(context, rootNavigator: true).pop();
            Utils().toastMessage('User successfully Logout!');
            await Future.delayed(Duration.zero);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } catch (e) {
            Navigator.of(context, rootNavigator: true).pop();
            Utils().toastMessage('Failed to logout: $e');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator(color: Color(0XFF5AA189)))
        : SafeArea(
    child: SingleChildScrollView(
    // Make sure it can scroll through the entire content area
    physics: AlwaysScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: ConstrainedBox(
    constraints: BoxConstraints(
    minHeight: MediaQuery.of(context).size.height -
    AppBar().preferredSize.height -
    MediaQuery.of(context).padding.top,
    ),

          child: Column(
            children: [
              SizedBox(height: 30.h),
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 60.r,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30.h),
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
                hintText: 'Email',
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
              // Other Fields
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Age',
                      validator: (value) => null,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _weightController,
                      hintText: 'Weight (kg)',
                      keyboardType: TextInputType.phone,
                      validator: (value) => null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Height and Ethnicity in one row
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _heightController,
                      hintText: 'Height (cm)',
                      keyboardType: TextInputType.phone,
                      validator: (value) => null,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _ethnicityController,
                      hintText: 'Ethnicity',
                      validator: (value) => null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              CustomButton(
                onTap: () => _updateProfile(context),
                buttonText: 'Update Profile',
              ),
              SizedBox(height: 30.h),
              CustomButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllReminders(
                              reminderService: reminderService)));
                },
                buttonText: 'All Reminders',
              ),
              SizedBox(height: 30.h),
              CustomButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddReminders(reminderService: ReminderService())),
                  );
                },
                buttonText: 'Set Reminder',
              )
            ],
          ),
        ),
      ),
      )
    );
  }

  Future<void> _updateProfile(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      bool success = await userProvider.updateUserProfile(
        _nameController.text,
        _emailController.text,
        _ageController.text,
        _weightController.text,
        _heightController.text,
        _ethnicityController.text,
      );
      if (!mounted) return;
      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${userProvider.errorMessage}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
