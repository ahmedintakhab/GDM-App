// tabs/weekly_tab.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAverageGlucoseCard(108, 'happy'),
          SizedBox(height: 24),
          _buildGlucoseLevelsCard(),
        ],
      ),
    );
  }

  Widget _buildAverageGlucoseCard(int value, String mood) {
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
            'Avg Blood Glucose',
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
                mood == 'happy' ? Icons.sentiment_satisfied : Icons.sentiment_dissatisfied,
                color: Colors.amber,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: value > 120 ? Colors.red : Colors.green,
                ),
              ),
              Text(
                ' mg/dl',
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

  Widget _buildGlucoseLevelsCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEK GLUCOSE LEVELS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.list, color: Colors.grey),
                  SizedBox(width: 16),
                  Icon(Icons.bar_chart, color: Colors.grey),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 200,
                barTouchData: BarTouchData(enabled: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
                        return Text(titles[value.toInt()]);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 100, color: Colors.indigo.withOpacity(0.3))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 140, color: Colors.indigo)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 110, color: Colors.indigo.withOpacity(0.3))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 180, color: Colors.indigo.withOpacity(0.3))]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 160, color: Colors.indigo.withOpacity(0.3))]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 140, color: Colors.indigo.withOpacity(0.3))]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 180, color: Colors.indigo.withOpacity(0.3))]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}