import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/change_password_screen.dart';
import 'package:gdm_app/Home/update_profile_screen.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/reminder/all_reminders_screen.dart';
import 'package:gdm_app/reminder/add_reminders_screen.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:gdm_app/weight/add_weight_screen.dart';
import 'package:provider/provider.dart';
import '../Register/login_screen.dart';
import '../Register/logout_dialog_widget.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final ReminderService reminderService;
  ProfileScreen({super.key, required this.reminderService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final reminderService = ReminderService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData();
    });
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
              MaterialPageRoute(builder: (context) => LoginScreen(reminderService: widget.reminderService)),
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
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0XFF5AA189)))
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: SingleChildScrollView(

                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.logout, color: Colors.black),
                          onPressed: () => _handleLogout(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50.r,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      userProvider.name.isNotEmpty ? userProvider.name : 'User Name',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      userProvider.email.isNotEmpty ? userProvider.email : '@username',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdateProfile(reminderService: widget.reminderService)),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 100.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFF5AA189), width: 1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Color(0XFF5AA189),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: [
                          CustomMenuItem(
                            icon: Icons.add_alarm,
                            text: 'Set Reminder',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReminders(reminderService: ReminderService()),
                                ),
                              );
                            },
                          ),
                          CustomMenuItem(
                            icon: Icons.list,
                            text: 'All Reminders',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllReminders(reminderService: reminderService),
                                ),
                              );
                            },
                          ),
                          CustomMenuItem(
                            icon: Icons.list,
                            text: 'Add Weight',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddWeightScreen(),
                                ),
                              );
                            },
                          ),

                          CustomMenuItem(
                            icon: Icons.lock,
                            text: 'Change Password',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen(),
                                ),
                              );

                            },
                          ),
                          CustomMenuItem(
                            icon: Icons.logout,
                            text: 'Logout',
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            onTap: () => _handleLogout(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback onTap;

  const CustomMenuItem({
    required this.icon,
    required this.text,
    this.textColor,
    this.iconColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? Color(0XFF5AA189), size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Color(0XFF5AA189),
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}