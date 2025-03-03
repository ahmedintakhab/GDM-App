import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gdm_app/Onboarding/onboarding_screen.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:get/get.dart';
import '../Home/home_main_screen.dart';
import '../utils/screen_size.dart';
import '../utils/pref_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
      if (isIntro == false) {
        Get.off(const OnboardingScreen());
      } else if (isLogin == false) {
        Get.off( LoginScreen());
      } else {
        Get.off(const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {  // ✅ Add this build method
    initializeScreenSize(context);
    return Scaffold(
      backgroundColor: Color(0XFF5AA189),
      body: SafeArea(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 95,
                width: 95,
                child: Image.asset(
                  "assets/images/splash.png",
                  fit: BoxFit.cover,
                   // color: const Color(0XFF5AA189),
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
