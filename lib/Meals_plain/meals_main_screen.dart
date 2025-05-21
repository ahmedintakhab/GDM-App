import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'meals_tabbar_screen.dart';
import 'meal_container.dart';

class MealsMainScreen extends StatefulWidget {
  @override
  _MealsMainScreenState createState() => _MealsMainScreenState();
}

class _MealsMainScreenState extends State<MealsMainScreen> {
  Map<String, List<Map<String, dynamic>>> mealItems = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF5AA189),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
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
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MealHeaderContainer(),
                    MealContainer(
                      mainText: 'Breakfast',
                      subText: 'Recommended 424 Cal',
                      items: mealItems['Breakfast']!,
                      onTap: (mainText, subText) {
                        int calories = int.parse(subText.split(' ')[1]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                              onAddItem: (item) {
                                setState(() {
                                  mealItems[mainText]!.add(item);
                                });
                              },
                            ),
                          ),
                        );
                        print('Breakfast tapped');
                      },
                      onRemoveItem: (mainText, item) {
                        setState(() {
                          mealItems[mainText]!.remove(item);
                        });
                      },
                    ),
                    MealContainer(
                      mainText: 'Lunch',
                      subText: 'Recommended 495 Cal',
                      items: mealItems['Lunch']!,
                      onTap: (mainText, subText) {
                        int calories = int.parse(subText.split(' ')[1]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                              onAddItem: (item) {
                                setState(() {
                                  mealItems[mainText]!.add(item);
                                });
                              },
                            ),
                          ),
                        );
                        print('Lunch tapped');
                      },
                      onRemoveItem: (mainText, item) {
                        setState(() {
                          mealItems[mainText]!.remove(item);
                        });
                      },
                    ),
                    MealContainer(
                      mainText: 'Dinner',
                      subText: 'Recommended 354 Cal',
                      items: mealItems['Dinner']!,
                      onTap: (mainText, subText) {
                        int calories = int.parse(subText.split(' ')[1]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                              onAddItem: (item) {
                                setState(() {
                                  mealItems[mainText]!.add(item);
                                });
                              },
                            ),
                          ),
                        );
                        print('Dinner tapped');
                      },
                      onRemoveItem: (mainText, item) {
                        setState(() {
                          mealItems[mainText]!.remove(item);
                        });
                      },
                    ),
                    MealContainer(
                      mainText: 'Snacks',
                      subText: 'Recommended 254 Cal',
                      items: mealItems['Snacks']!,
                      onTap: (mainText, subText) {
                        int calories = int.parse(subText.split(' ')[1]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: calories,
                              onAddItem: (item) {
                                setState(() {
                                  mealItems[mainText]!.add(item);
                                });
                              },
                            ),
                          ),
                        );
                        print('Snacks tapped');
                      },
                      onRemoveItem: (mainText, item) {
                        setState(() {
                          mealItems[mainText]!.remove(item);
                        });
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

class MealHeaderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5AA189),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
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
                'assets/images/apple1.png',
                height: 150.h,
                width: 150.w,
              ),
            ],
          ),
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
        ],
      ),
    );
  }
}