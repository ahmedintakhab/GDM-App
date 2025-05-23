import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:gdm_app/Onboarding/onboarding_screen.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:get/get.dart';
import '../Home/home_main_screen.dart';
import '../reminder/reminder_service_implementation.dart';
import '../utils/screen_size.dart';
import '../utils/pref_data.dart';

class SplashScreen extends StatefulWidget {
  final ReminderService reminderService;

  const SplashScreen({Key? key, required this.reminderService}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  @override
  void initState() {
    super.initState();
    getIntro();
  }

  getIntro() async {
    bool isIntro = await PrefData.getIntro();
    bool isLogin = await PrefData.getLogin();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Check if the user is already logged in
      User? user = _auth.currentUser;

      if (user != null) {
        // User is already logged in, navigate to HomeScreen
        Get.off( HomeScreen(reminderService: widget.reminderService));
      } else {
        // User is not logged in, navigate based on intro and login status
        if (isIntro == false) {
          Get.off( OnboardingScreen(reminderService: widget.reminderService));
        } else if (isLogin == false) {
          Get.off(LoginScreen(reminderService: widget.reminderService));
        } else {
          Get.off( HomeScreen(reminderService: widget.reminderService));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      backgroundColor: Color(0XFF5AA189),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  "assets/images/gdm_Logos.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "GDM",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontFamily: 'AvenirLTPro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}