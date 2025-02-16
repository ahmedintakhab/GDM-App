// glucose_details_screen.dart
import 'package:flutter/material.dart';
import 'package:gdm_app/glucose_screen/monthly_tab.dart';
import 'package:gdm_app/glucose_screen/today_tab.dart';
import 'package:gdm_app/glucose_screen/weekly_tab.dart';

class GlucoseDetailsScreen extends StatelessWidget {
  const GlucoseDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your glucose',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.share, color: Colors.black),
          //     onPressed: () {
          //       // Handle share action
          //     },
          //   ),
          // ],
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0XFF5AA189),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodayTab(),
            WeeklyTab(),
            MonthlyTab(),
          ],
        ),
      ),
    );
  }
}