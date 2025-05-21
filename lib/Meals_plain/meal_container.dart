import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealContainer extends StatelessWidget {
  final String mainText;
  final String subText;
  final List<Map<String, dynamic>> items;
  final Function(String, String) onTap;
  final Function(String, Map<String, dynamic>) onRemoveItem;

  const MealContainer({
    required this.mainText,
    required this.subText,
    required this.items,
    required this.onTap,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(mainText, subText), // Navigate to MealsTabBarScreen on tap
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              title: Text(
                mainText,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '$subText eaten',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_circle, color: Color(0xFF5AA189)),
                onPressed: () {
                  // Optional: Add additional logic for the add button if needed
                  onTap(mainText, subText); // This will also trigger navigation
                },
              ),
            ),
            if (items.isNotEmpty)
              Column(
                children: [
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item['name'],
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              item['quantity'],
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item['calories']} Cal',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(width: 8.w),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.grey),
                                onPressed: () => onRemoveItem(mainText, item),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}