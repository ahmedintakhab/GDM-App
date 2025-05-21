import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems;
  final Function(Map<String, dynamic>) onAdd;

  FoodListScreen({required this.foodItems, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final food = foodItems[index];
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'],
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${food['calories']} Cal',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                food['quantity'],
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
            trailing: GestureDetector(
              onTap: () => onAdd(food),
              child: CircleAvatar(
                radius: 12.r,
                backgroundColor: Color(0xFF5AA189),
                child: Icon(Icons.add, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        );
      },
    );
  }
}