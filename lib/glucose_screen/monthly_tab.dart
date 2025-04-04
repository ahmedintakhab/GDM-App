// tabs/monthly_tab.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../Home/user_data_provider.dart';

class MonthlyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final monthlyData = _processMonthlyData(userProvider.glucoseData);
    final monthlyAverage = _calculateMonthlyAverage(monthlyData);
    final mood = _getMoodForValue(monthlyAverage);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAverageGlucoseCard(monthlyAverage.round(), mood),
          SizedBox(height: 24),
          _buildGlucoseLevelsCard(monthlyData),
        ],
      ),
    );
  }

  Map<int, double> _processMonthlyData(List<Map<String, dynamic>> glucoseData) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final monthlyAverages = <int, double>{};

    // Initialize with empty values
    for (var day = 1; day <= daysInMonth; day++) {
      monthlyAverages[day] = 0;
    }

    // Group data by day of month
    final dailyValues = <int, List<int>>{};
    for (var data in glucoseData) {
      if (data['timestamp'] != null && data['value'] != null) {
        final date = data['timestamp'].toDate();
        // Only process data for current month
        if (date.month == now.month && date.year == now.year) {
          final day = date.day;
          final value = data['value'] as int;

          dailyValues.putIfAbsent(day, () => []).add(value);
        }
      }
    }

    // Calculate averages
    dailyValues.forEach((day, values) {
      monthlyAverages[day] = values.reduce((a, b) => a + b) / values.length;
    });

    return monthlyAverages;
  }

  double _calculateMonthlyAverage(Map<int, double> monthlyData) {
    final values = monthlyData.values.where((value) => value > 0);
    return values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;
  }

  String _getMoodForValue(double value) {
    if (value < 80) return 'low';
    if (value <= 120) return 'happy';
    if (value <= 180) return 'neutral';
    return 'sad';
  }

  Widget _buildAverageGlucoseCard(int value, String mood) {
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
            'Monthly Avg Blood Glucose',
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
                '$value',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: moodColor,
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

  Widget _buildGlucoseLevelsCard(Map<int, double> monthlyData) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final hasData = monthlyData.values.any((value) => value > 0);

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
                'MONTH GLUCOSE LEVELS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: hasData
                ? Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: daysInMonth * 16.0, // Adjust width based on days in month
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceEvenly,
                        maxY: _calculateMaxY(monthlyData),
                        barTouchData: BarTouchData(enabled: false),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${(value + 1).toInt()}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 50,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                );
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
                        barGroups: List.generate(
                          daysInMonth,
                              (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: monthlyData[index + 1] ?? 0,
                                color: _getBarColor(monthlyData[index + 1] ?? 0),
                                width: 10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 4,
                    width: 4,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF5AA189),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            )
                : Center(child: Text('No glucose data available')),
          ),
        ],
      ),
    );
  }

  double _calculateMaxY(Map<int, double> monthlyData) {
    final maxValue = monthlyData.values.reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceilToDouble().clamp(100, 300).toDouble();
  }

  Color _getBarColor(double value) {
    if (value < 80) return Colors.blue.withOpacity(0.6);
    if (value <= 120) return Colors.green.withOpacity(0.6);
    if (value <= 180) return Colors.amber.withOpacity(0.6);
    return Colors.red.withOpacity(0.6);
  }
}