import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/reminder/all_reminders_screen.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:provider/provider.dart'; // Add this import
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final reminderService = ReminderService();



  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if(mounted) {
        setState(() {
          nameController.text = userProvider.name;
          emailController.text = userProvider.email;
        });
      }
        userProvider.fetchUserData();

    });
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Function to handle logout
  void _handleLogout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: () async {
          try {
            await _auth.signOut(); // Sign out the user
            userProvider.resetUserData(); // Reset user data in the provider
            Navigator.of(context, rootNavigator: true).pop(); // Close the dialog using rootNavigator
            Utils().toastMessage('User successfully Logout!');

            // Add a small delay to ensure the dialog is fully dismissed
            await Future.delayed(Duration.zero);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
            );
          } catch (e) {
            Navigator.of(context, rootNavigator: true).pop(); // Close the dialog in case of error
            print('Failed to logout: $e');
            Utils().toastMessage('Failed to logout: $e');
          }
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) {
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
              actions: [
                // Logout Icon with Text

                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.black),
                      onPressed: () => _handleLogout(context), // Show logout dialog
                    ),
          ]
          ),
            body: userProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0XFF5AA189),))
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    // Circle Avatar
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

                    SizedBox(height: 30.h),
                    CustomButton(
                      onTap: () => _updateProfile(context, userProvider),
                      buttonText: 'Update Profile',
                    ),
                    // Spacer(),
                    SizedBox(height: 30.h),
                    CustomButton(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context)=>AllReminders(reminderService: reminderService)));
                      },
                      buttonText: 'All Reminders',
                    ),
                    SizedBox(height: 30.h),
                    CustomButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddReminders(reminderService: ReminderService())),
                        );
                      },
                      buttonText: 'Set Reminder',
                    )

                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Future<void> _updateProfile(BuildContext context, UserProvider userProvider) async {
    // Show loading indicator
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
      // Update profile using provider
      bool success = await userProvider.updateUserProfile(
          nameController.text,
          emailController.text
      );
      if (!mounted) return; // Ensure widget is still in the tree
      // Close loading dialog
      Navigator.pop(context);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        // Navigate back to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${userProvider.errorMessage}')),
        );
      }
    } catch (e) {
      if (!mounted) return; // Ensure widget is still in the tree
      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}