import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationDetailsScreen extends StatelessWidget {
  final String title;
  final String details;

  const InformationDetailsScreen({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red[300]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the details at the start
              Text(
                details,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[800],
                  height: 1.5, // Line spacing for readability
                ),
              ),
              // Add more widgets here if needed (e.g., additional content, buttons)
            ],
          ),
        ),
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
      onTap: onTap, // Use the provided onTap directly
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline, // Updated icon for better context
                    color: Colors.grey[600],
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
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