import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'create_food_screen.dart';
import 'meals_data_provider.dart';

class MyFoodTabScreen extends StatefulWidget {
  final String mealType;
  final Function(Map<String, dynamic>) onAddItem;

  const MyFoodTabScreen({
    Key? key,
    required this.mealType,
    required this.onAddItem,
  }) : super(key: key);

  @override
  _MyFoodTabScreenState createState() => _MyFoodTabScreenState();
}

class _MyFoodTabScreenState extends State<MyFoodTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealsProvider>(context, listen: false).fetchMealsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Food',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateFoodScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      color: const Color(0xFF5AA189),
                      size: 20.sp,
                    ),
                    label: Text(
                      'Create Food',
                      style: TextStyle(
                        color: const Color(0xFF5AA189),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Consumer<MealsProvider>(
                builder: (context, mealsProvider, child) {
                  if (mealsProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (mealsProvider.errorMessage != null) {
                    return Center(child: Text(mealsProvider.errorMessage!));
                  }
                  if (mealsProvider.foodsData.isEmpty) {
                    return const Center(child: Text('No foods available'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mealsProvider.foodsData.length,
                    itemBuilder: (context, index) {
                      final food = mealsProvider.foodsData[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          title: Text(
                            food['foodName'],
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Quantity: ${food['quantity']}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${food['foodCalories']} Cal',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () async {
                                  final foodItem = {
                                    'foodName': food['foodName'],
                                    'calories': food['foodCalories'],
                                    'quantity': food['quantity'],
                                  };
                                  await Provider.of<MealsProvider>(context, listen: false)
                                      .addMealItem(widget.mealType, foodItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${food['foodName']} added to ${widget.mealType}')),
                                  );
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: const Color(0xFF5AA189),
                                  child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}