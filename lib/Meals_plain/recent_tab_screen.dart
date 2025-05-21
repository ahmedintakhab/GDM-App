import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentTabScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recentItems;
  final Function(Map<String, dynamic>) onRemove;

  RecentTabScreen({required this.recentItems, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return recentItems.isEmpty
        ? Center(child: Text('No recent items', style: TextStyle(fontSize: 18.sp)))
        : ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: recentItems.length,
      itemBuilder: (context, index) {
        final food = recentItems[index];
        return Dismissible(
          key: Key(food['name'] + food['quantity']),
          onDismissed: (direction) => onRemove(food),
          child: Container(
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
                onTap: () => onRemove(food),
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}