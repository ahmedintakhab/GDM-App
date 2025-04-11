import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'information_card.dart'; // Import the second file

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive design
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Help Center Title
              Text(
                "Help Center",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search by topics",
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.red[300],
                    size: 20.w,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Two GDM Containers in a Row
              Row(
                children: [
                  Expanded(
                    child: _buildGDMContainer(
                      title: "Understanding Gestational Diabetes (GDM)",
                      description: "A comprehensive overview of GDM, its causes, risk factors, and how it affects pregnancy.",
                      onTap: () {
                        // Add navigation or action for Paytee Line
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildGDMContainer(
                      title: "GDM and Pregnancy",
                      description: "Key facts about GDM, screening processes, and long-term health implications.",
                      onTap: () {
                        // Add navigation or action for Live Chat
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Financial Assistance Hub Container
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "GDM Assistance + HUB",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),

                    // List of Information Cards (5 times)
                    const InformationCard(
                      title: "Credit Cards",
                      onTap: null, // Will be updated in the loop below
                    ),
                    SizedBox(height: 8.h),
                    const InformationCard(
                      title: "Payments",
                      onTap: null,
                    ),
                    SizedBox(height: 8.h),
                    const InformationCard(
                      title: "Billing Issues",
                      onTap: null,
                    ),
                    SizedBox(height: 8.h),
                    const InformationCard(
                      title: "Refunds",
                      onTap: null,
                    ),
                    SizedBox(height: 8.h),
                    const InformationCard(
                      title: "Account Support",
                      onTap: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build GDM containers
  Widget _buildGDMContainer({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}