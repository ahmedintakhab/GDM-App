// glucose_details_screen.dart
import 'package:flutter/material.dart';
import 'package:gdm_app/glucose_screen/monthly_tab.dart';
import 'package:gdm_app/glucose_screen/today_tab.dart';
import 'package:gdm_app/glucose_screen/weekly_tab.dart';
import '../l10n/app_localizations.dart';


class GlucoseDetailsScreen extends StatelessWidget {
  const GlucoseDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back when pressed
            },
          ),
          title: Text(
            l10n.yourGlucose,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0XFF5AA189),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 7.0,
            labelStyle: TextStyle(fontSize: 16,
            fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: l10n.daily),
              Tab(text: l10n.weekly),
              Tab(text: l10n.monthly),
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