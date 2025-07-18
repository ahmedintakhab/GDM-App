import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'add_calories.dialogbox.dart';
import 'meals_data_provider.dart';
import 'meals_tabbar_screen.dart';
import 'meal_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealsMainScreen extends StatefulWidget {
  const MealsMainScreen({Key? key}) : super(key: key);

  @override
  _MealsMainScreenState createState() => _MealsMainScreenState();
}

class _MealsMainScreenState extends State<MealsMainScreen> {
  final GlobalKey<_MealsMainScreenState> _mealsMainScreenKey = GlobalKey<_MealsMainScreenState>();

  // Map localized meal names to English keys
  String _getEnglishMealType(String localizedMealType, AppLocalizations l10n) {
    if (localizedMealType == l10n.breakfast) return 'Breakfast';
    if (localizedMealType == l10n.lunch) return 'Lunch';
    if (localizedMealType == l10n.dinner) return 'Dinner';
    if (localizedMealType == l10n.snacks) return 'Snacks';
    return localizedMealType; // Fallback
  }

  int _calculateCalories(String mealType) {
    final mealsProvider = Provider.of<MealsProvider>(context, listen: false);
    return mealsProvider.mealItems[mealType]?.fold<int>(0, (sum, item) => sum + (item['calories'] as num).toInt()) ?? 0;
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
    final l10n = AppLocalizations.of(context)!;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF5AA189),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      key: _mealsMainScreenKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<MealsProvider>(
        builder: (context, mealsProvider, child) {
          return Column(
            children: [
              Container(
                color: const Color(0xFF5AA189),
                child: SafeArea(
                  child: AppBar(
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      l10n.meals_plan,
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
                          mainText: l10n.breakfast,
                          subText: '${_calculateCalories('Breakfast')} ${l10n.calories}',
                          items: mealsProvider.mealItems['Breakfast'] ?? [],
                          onTap: (mainText, subText) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealsTabBarScreen(
                                  mealType: _getEnglishMealType(mainText, l10n),
                                  recommendedCalories: _calculateCalories(_getEnglishMealType(mainText, l10n)),
                                  onAddItem: (item) {
                                    mealsProvider.addMealItem(_getEnglishMealType(mainText, l10n), item);
                                  },
                                ),
                              ),
                            );
                          },
                          onRemoveItem: (mainText, item) async {
                            await mealsProvider.removeMealItem(_getEnglishMealType(mainText, l10n), {
                              'foodName': item['foodName'],
                              'calories': item['calories'] ~/ (item['count'] as int),
                              'quantity': item['quantity'],
                              'timestamp': item['timestamp'],
                            });
                          },
                        ),
                        MealContainer(
                          mainText: l10n.lunch,
                          subText: '${_calculateCalories('Lunch')} ${l10n.calories}',
                          items: mealsProvider.mealItems['Lunch'] ?? [],
                          onTap: (mainText, subText) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealsTabBarScreen(
                                  mealType: _getEnglishMealType(mainText, l10n),
                                  recommendedCalories: _calculateCalories(_getEnglishMealType(mainText, l10n)),
                                  onAddItem: (item) {
                                    mealsProvider.addMealItem(_getEnglishMealType(mainText, l10n), item);
                                  },
                                ),
                              ),
                            );
                          },
                          onRemoveItem: (mainText, item) async {
                            await mealsProvider.removeMealItem(_getEnglishMealType(mainText, l10n), {
                              'foodName': item['foodName'],
                              'calories': item['calories'] ~/ (item['count'] as int),
                              'quantity': item['quantity'],
                              'timestamp': item['timestamp'],
                            });
                          },
                        ),
                        MealContainer(
                          mainText: l10n.dinner,
                          subText: '${_calculateCalories('Dinner')} ${l10n.calories}',
                          items: mealsProvider.mealItems['Dinner'] ?? [],
                          onTap: (mainText, subText) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealsTabBarScreen(
                                  mealType: _getEnglishMealType(mainText, l10n),
                                  recommendedCalories: _calculateCalories(_getEnglishMealType(mainText, l10n)),
                                  onAddItem: (item) {
                                    mealsProvider.addMealItem(_getEnglishMealType(mainText, l10n), item);
                                  },
                                ),
                              ),
                            );
                          },
                          onRemoveItem: (mainText, item) async {
                            await mealsProvider.removeMealItem(_getEnglishMealType(mainText, l10n), {
                              'foodName': item['foodName'],
                              'calories': item['calories'] ~/ (item['count'] as int),
                              'quantity': item['quantity'],
                              'timestamp': item['timestamp'],
                            });
                          },
                        ),
                        MealContainer(
                          mainText: l10n.snacks,
                          subText: '${_calculateCalories('Snacks')} ${l10n.calories}',
                          items: mealsProvider.mealItems['Snacks'] ?? [],
                          onTap: (mainText, subText) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealsTabBarScreen(
                                  mealType: _getEnglishMealType(mainText, l10n),
                                  recommendedCalories: _calculateCalories(_getEnglishMealType(mainText, l10n)),
                                  onAddItem: (item) {
                                    mealsProvider.addMealItem(_getEnglishMealType(mainText, l10n), item);
                                  },
                                ),
                              ),
                            );
                          },
                          onRemoveItem: (mainText, item) async {
                            await mealsProvider.removeMealItem(_getEnglishMealType(mainText, l10n), {
                              'foodName': item['foodName'],
                              'calories': item['calories'] ~/ (item['count'] as int),
                              'quantity': item['quantity'],
                              'timestamp': item['timestamp'],
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MealHeaderContainer extends StatelessWidget {
  final GlobalKey<_MealsMainScreenState> mealsMainScreenKey;

  const MealHeaderContainer({Key? key, required this.mealsMainScreenKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, child) {
        final eatenCalories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'].fold(0, (sum, mealType) {
          return sum + (mealsProvider.mealItems[mealType]?.fold(0, (s, item) => s! + (item['calories'] as num).toInt()) ?? 0);
        });
        final remainingCalories = mealsProvider.dailyCalories - eatenCalories;
        final containerColor = eatenCalories > mealsProvider.dailyCalories ? Colors.red : const Color(0xFF5AA189);
        return Container(
          color: containerColor,
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
                        l10n.eaten_label,
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      Text(
                        '$eatenCalories ${l10n.calories}',
                        style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.remaining,
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      Text(
                        '$remainingCalories ${l10n.calories}',
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
                  children: [
                    Text(
                      '${l10n.dailyCalories}: ${mealsProvider.dailyCalories}',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddCaloriesDialogBox(),
                        );
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