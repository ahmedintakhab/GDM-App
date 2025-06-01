import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'add_calories.dialogbox.dart';
import 'meals_data_provider.dart';
import 'meals_tabbar_screen.dart';
import 'meal_container.dart';

class MealsMainScreen extends StatefulWidget {
  const MealsMainScreen({Key? key}) : super(key: key);

  @override
  _MealsMainScreenState createState() => _MealsMainScreenState();
}

class _MealsMainScreenState extends State<MealsMainScreen> {
  final GlobalKey<_MealsMainScreenState> _mealsMainScreenKey = GlobalKey<_MealsMainScreenState>();
  Map<String, List<Map<String, dynamic>>> mealItems = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  int _calculateCalories(String mealType) {
    return mealItems[mealType]!.fold<int>(0, (sum, item) => sum + (item['calories'] as num).toInt());
  }

  void addFoodItem(String mealType, Map<String, dynamic> foodItem) {
    setState(() {
      mealItems[mealType]!.add(foodItem);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealsProvider>(context, listen: false).fetchMealsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF5AA189),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      key: _mealsMainScreenKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF5AA189),
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
                  color: const Color(0xFF5AA189),
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
                    MealHeaderContainer(mealsMainScreenKey: _mealsMainScreenKey),
                    MealContainer(
                      mainText: 'Breakfast',
                      subText: '${_calculateCalories('Breakfast')} Cal',
                      items: mealItems['Breakfast']!,
                      onTap: (mainText, subText) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: _calculateCalories(mainText),
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
                      subText: '${_calculateCalories('Lunch')} Cal',
                      items: mealItems['Lunch']!,
                      onTap: (mainText, subText) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: _calculateCalories(mainText),
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
                      subText: '${_calculateCalories('Dinner')} Cal',
                      items: mealItems['Dinner']!,
                      onTap: (mainText, subText) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: _calculateCalories(mainText),
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
                      subText: '${_calculateCalories('Snacks')} Cal',
                      items: mealItems['Snacks']!,
                      onTap: (mainText, subText) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealsTabBarScreen(
                              mealType: mainText,
                              recommendedCalories: _calculateCalories(mainText),
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
  final GlobalKey<_MealsMainScreenState> mealsMainScreenKey;

  const MealHeaderContainer({Key? key, required this.mealsMainScreenKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, child) {
        final mealsState = mealsMainScreenKey.currentState;
        final eatenCalories = mealsState != null
            ? ['Breakfast', 'Lunch', 'Dinner', 'Snacks'].fold(0, (sum, mealType) {
          return sum + mealsState.mealItems[mealType]!.fold(0, (s, item) => s + (item['calories'] as num).toInt());
        })
            : 0;
        final remainingCalories = mealsProvider.dailyCalories - eatenCalories;
        return Container(
          color: const Color(0xFF5AA189),
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
                        '$eatenCalories Cal',
                        style: TextStyle(color: Colors.white,
                            fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Remaining',
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      Text(
                        '$remainingCalories Cal',
                        style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
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
                  // mainAxisAlignment: mainAxisAlignment.start,
                  children: [
                    Text(
                      'Total Cal: ${mealsProvider.dailyCalories}',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => {
                      showDialog(
                      context: context,
                      builder: (context) => const AddCaloriesDialogBox(),
                      )
                    },
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 26.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}