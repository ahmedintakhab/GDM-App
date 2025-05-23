import 'package:flutter/material.dart';
import 'package:gdm_app/Register/users_signup_screen.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/onboarding_data_model.dart';
import '../utils/pref_data.dart';
import '../utils/screen_size.dart';

class OnboardingScreen extends StatefulWidget {
  final ReminderService reminderService;
  const OnboardingScreen({Key? key, required this.reminderService}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Sliders> pages = [];
  int currentpage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    pages = Utils.getSliderPages(); // Use Utils class here
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeScreenSize(context); // Move it here
    preloadImages(); // Preload images

  }
  // Function to preload images
  void preloadImages() {
    for (var page in pages) {
      if (page.image != null) {
        precacheImage(AssetImage(page.image!), context);
      }
    }
  }

  _onchanged(index) {
    setState(() {
      currentpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            generatepage(),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 42),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        indicator(),
                        button(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                skipbutton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget indicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pages.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 10,
            width: 10,
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: (index == currentpage)
                    ? const Color(0XFF5AA189)
                    : const Color(0XFFDEDEDE)),
          );
        }));
  }

  Widget button() {
    return InkWell(
      onTap: () {
        setState(() {
          if (currentpage == pages.length - 1) {
            PrefData.setIntro(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  UsersSignupScreen(reminderService: widget.reminderService)),
            );
          } else {
            controller.nextPage(
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn);
          }
        });
      },
      child: Container(
        height: 56,
        width: 177,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0XFF5AA189)),
        child: (currentpage == pages.length - 1)
            ? Center(
          child: Text(
            "Get Started",
            style: TextStyle(color: const Color(0XFFFFFFFF), fontSize: 18,
                fontFamily: 'Gilroy', fontWeight: FontWeight.w700),
          ),
        )
            : Center(
          child: Text(
            "Next",
            style: TextStyle(color: const Color(0XFFFFFFFF), fontSize: 18, fontFamily: 'Gilroy', fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget skipbutton() {
    return currentpage == pages.length - 1
        ? const SizedBox()
        : Padding(
      padding: const EdgeInsets.only(top: 25, right: 20),
      child: GestureDetector(
          onTap: () {
            Get.to(UsersSignupScreen(reminderService: widget.reminderService));
            // setState(() {
            //   controller.nextPage(
            //       duration: const Duration(milliseconds: 100),
            //       curve: Curves.bounceIn);
            // });
          },
          child: Container(
              height: 32,
              width: 68,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0XFFFFFFFF)),
              child: Center(
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        color: Color(0xFF000000)),
                  )))),
    );
  }

  Widget generatepage() {
    return PageView.builder(
        itemCount: pages.length,
        scrollDirection: Axis.horizontal,
        controller: controller,
        onPageChanged: _onchanged,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Image(image: AssetImage(pages[index].image!),
                  height: 350, width: 350, fit: BoxFit.cover),
              SizedBox(height: 30),
              Text(
                pages[index].name!,
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                    color: Color(0XFF000000),
                    fontSize: 22),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  pages[index].title!,
                  style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      color: Color(0XFF000000),
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        });
  }
}



