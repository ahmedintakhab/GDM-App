// tabs/weekly_tab.dart
import 'package:flutter/material.dart';
import 'package:gdm_app/Home/gulcose_chart.dart';
import 'package:provider/provider.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WeeklyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAverageGlucoseCard(
            userProvider.getWeeklyAverage(),
            userProvider.getWeeklyMood(),
            userProvider,context,
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.glucoseWeekAvg,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: WeeklyGlucoseChart(
                    weeklyData: userProvider.getWeeklyAverages(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageGlucoseCard(double value, String mood, UserProvider userProvider,context) {
    final l10n = AppLocalizations.of(context)!;
    final displayValue = value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
    final unit = userProvider.glucoseData.isNotEmpty ? userProvider.glucoseData.first['unit'] : 'mg/dl'; // Line ~50: Fetch unit

    IconData moodIcon;
    Color moodColor;

    switch (mood) {
      case 'happy':
        moodIcon = Icons.sentiment_satisfied;
        moodColor = Colors.green;
        break;
      case 'neutral':
        moodIcon = Icons.sentiment_neutral;
        moodColor = Colors.amber;
        break;
      case 'sad':
        moodIcon = Icons.sentiment_dissatisfied;
        moodColor = Colors.red;
        break;
      case 'low':
        moodIcon = Icons.sentiment_very_dissatisfied;
        moodColor = Colors.blue;
        break;
      default:
        moodIcon = Icons.sentiment_neutral;
        moodColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.weeklyAvgBloodGlucose,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                moodIcon,
                color: moodColor,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: value > 120 ? Colors.red : Colors.green,
                ),
              ),
              Text(
                '$unit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}