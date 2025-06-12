import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'meals_data_provider.dart';

class RecentTabScreen extends StatelessWidget {
  final String mealType;

  const RecentTabScreen({required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, child) {
        final recentItems = mealsProvider.mealItems[mealType] ?? [];
        return recentItems.isEmpty
            ? Center(child: Text('No recent items',
            style: TextStyle(fontSize: 18.sp)))
            : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: recentItems.length,
          itemBuilder: (context, index) {
            final food = recentItems[index];
            return Dismissible(
              key: Key(food['foodName'] + food['quantity']),
              onDismissed: (direction) {
                Provider.of<MealsProvider>(context, listen: false).removeMealItem(mealType, food);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    food['foodName'],
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      food['quantity'],
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${food['calories']} Cal',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          Provider.of<MealsProvider>(context, listen: false).removeMealItem(mealType, food);
                        },
                        child: CircleAvatar(
                          radius: 12.r,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}