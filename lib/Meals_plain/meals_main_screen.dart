import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'meals_tabbar_screen.dart';
import 'meal_container.dart';

class MealsMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set the status bar color to match the AppBar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF5AA189), // Match AppBar color
        statusBarIconBrightness: Brightness.light, // White icons for visibility
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Background color for the entire screen
      body: Column(
        children: [
          // AppBar with extended color
          Container(
            color: Color(0xFF5AA189),
            child: SafeArea(
              child: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Meals Plan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.sp),
                ),
                flexibleSpace: Container(
                  color: Color(0xFF5AA189),
                ),
              ),
            ),
          ),
          // Scrollable Content wrapped in SafeArea to avoid status bar overlap
          Expanded(
            child: SafeArea(
              top: false, // Allow content to start right below the AppBar
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Container with Eaten/Remaining, Apple Image, and Indicators
                    MealHeaderContainer(),
                    // Reusable Meal Containers
                    MealContainer(
                      mainText: 'Breakfast',
                      subText: 'Recommended 424 Cal',
                      onTap: () {
                        final mainText = 'Breakfast'; // Capture the mainText
                        final subText = 'Recommended 424 Cal'; // Capture the subText
                        int calories = int.parse(subText.split(' ')[1]); // Extract 424 from "Recommended 424 Cal"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                            ),
                          ),
                        );
                        print('Breakfast tapped');
                      },
                    ),
                    MealContainer(
                      mainText: 'Lunch',
                      subText: 'Recommended 495 Cal',
                      onTap: () {
                        final mainText = 'Lunch'; // Capture the mainText
                        final subText = 'Recommended 495 Cal'; // Capture the subText
                        int calories = int.parse(subText.split(' ')[1]); // Extract 495 from "Recommended 495 Cal"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                            ),
                          ),
                        );
                        print('Lunch tapped');
                      },
                    ),
                    MealContainer(
                      mainText: 'Dinner',
                      subText: 'Recommended 354 Cal',
                      onTap: () {
                        final mainText = 'Dinner'; // Capture the mainText
                        final subText = 'Recommended 354 Cal'; // Capture the subText
                        int calories = int.parse(subText.split(' ')[1]); // Extract 354 from "Recommended 354 Cal"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                            ),
                          ),
                        );
                        print('Dinner tapped');
                      },
                    ),
                    MealContainer(
                      mainText: 'Snacks',
                      subText: 'Recommended 254 Cal',
                      onTap: () {
                        final mainText = 'Snacks'; // Capture the mainText
                        final subText = 'Recommended 254 Cal'; // Capture the subText
                        int calories = int.parse(subText.split(' ')[1]); // Extract 254 from "Recommended 254 Cal"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                            ),
                          ),
                        );
                        print('Snacks tapped');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Separate Widget for the Header Container
class MealHeaderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5AA189),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row with Eaten/Remaining and Apple Image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eaten',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  Text(
                    '0 Cal',
                    style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Remaining',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  Text(
                    '1415 Cal',
                    style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/apple1.png', // Ensure you have an apple image in assets
                height: 170.h,
                width: 170.w,
              ),
            ],
          ),
          // Macronutrient Indicators
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.yellow, size: 12.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'Carbs',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '0 / 141g',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.blue, size: 12.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'Protein',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '0 / 106g',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.orange, size: 12.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'Fat',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '0 / 47g',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Circular background (placeholder for the design)
          // Container(
          //   margin: EdgeInsets.only(top: 8.h),
          //   height: 100.h,
          //   width: 100.w,
          //   decoration: BoxDecoration(
          //     color: Color(0xFF5AA189).withOpacity(0.3),
          //     shape: BoxShape.circle,
          //   ),
          // ),
        ],
      ),
    );
  }
}