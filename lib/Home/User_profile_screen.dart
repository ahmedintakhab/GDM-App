
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/change_password_screen.dart';
import 'package:gdm_app/Home/update_profile_screen.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/reminder/all_reminders_screen.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:gdm_app/weight/add_weight_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../Register/delete_account_dialog.dart';
import '../Register/login_screen.dart';
import '../Register/logout_dialog_widget.dart';
import '../controller/language_change_controller.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final ReminderService reminderService;
  ProfileScreen({super.key, required this.reminderService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
enum Language {English, Arabic}

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
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: () async {
          try {
            await _auth.signOut();
            userProvider.resetUserData();
            Navigator.of(context, rootNavigator: true).pop();
            Utils().toastMessage(l10n.logoutSuccess);
            await Future.delayed(Duration.zero);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen(reminderService: widget.reminderService)),
            );
          } catch (e) {
            Navigator.of(context, rootNavigator: true).pop();
            Utils().toastMessage('${l10n.failedToLogout}$e');
          }
        },
      ),
    );
  }
  void _handleDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(
        reminderService: widget.reminderService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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

                    Consumer<LanguageChangeController>(builder: (context, provider, child) {
                      print('Current locale: ${provider.appLocale}');
                      print('Available translations: ${AppLocalizations.supportedLocales}');
                      print('Current translations: ${AppLocalizations.of(context)?.logout}');
                      print('Current translations: ${AppLocalizations.of(context)!.logout}');
                      bool isArabic = provider.appLocale == Locale('ar');

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start, // Changed to start alignment
                        children: [
                          Text(
                            'EN',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isArabic ? Colors.grey : Color(0xFF5AA189),
                              fontWeight: isArabic ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isArabic) {
                                provider.changeLanguage(Locale('en'));
                              } else {
                                provider.changeLanguage(Locale('ar'));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Container(
                                width: 60.w, // Width of the toggle button
                                height: 30.h, // Height of the toggle button
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      isArabic ? 'assets/images/UAE_flag2.jpg' : 'assets/images/US_flag.webp',
                                    ),
                                    fit: BoxFit.cover, // Ensures the flag fills the container
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedAlign(
                                      duration: Duration(milliseconds: 200),
                                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        width: 26.w, // Thumb size
                                        height: 26.h,
                                        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'AR',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isArabic ? Color(0xFF5AA189) : Colors.grey,
                              fontWeight: isArabic ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          Spacer(), // Pushes the IconButton to the end
                          IconButton(
                            icon: Icon(Icons.logout, color: Colors.black),
                            onPressed: () => _handleLogout(context),
                          ),
                        ],
                      );
                    }),
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
                      userProvider.email.isNotEmpty ? userProvider.email : '',
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
                          MaterialPageRoute(builder: (context) =>
                              UpdateProfile(reminderService: widget.reminderService)),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 100.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFF5AA189), width: 1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          l10n.editProfile,
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
                            icon: Icons.list,
                            text: l10n.reminders,
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
                            text: l10n.weightManagement,
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
                            text: l10n.changePassword,
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
                            text: l10n.logout,
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            onTap: () => _handleLogout(context),
                          ),
                          CustomMenuItem(
                            icon: Icons.delete,
                            text: l10n.deleteAccount,
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            onTap: () => _handleDeleteAccount(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            )
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