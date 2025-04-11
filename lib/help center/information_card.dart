import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Placeholder for the details screen
class InformationDetailsScreen extends StatelessWidget {
  final String title;

  const InformationDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text("Details for $title"),
      ),
    );
  }
}

class InformationCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const InformationCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
              () {
            // Default navigation to InformationDetailsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformationDetailsScreen(title: title),
              ),
            );
          },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.credit_card, // Placeholder icon, adjust as needed
                  color: Colors.grey[600],
                  size: 20.w,
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.red[300],
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}