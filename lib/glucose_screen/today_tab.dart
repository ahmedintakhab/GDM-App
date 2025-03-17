import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gdm_app/glucose_screen/add_glucose.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../Home/user_data_provider.dart';

class TodayTab extends StatefulWidget {
  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  @override
  void initState() {
    super.initState();
    // Fetch glucose data when the widget is first created
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData();
    userProvider.fetchGlucoseData();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (userProvider.errorMessage != null) {
          return Center(child: Text('Error: ${userProvider.errorMessage}'));
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAverageGlucoseCard(userProvider),
                SizedBox(height: 24),
                _buildGlucoseLevelsCard(userProvider),
                SizedBox(height: 25),
                CustomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddGlucoseScreen()),
                    );
                  },
                  buttonText: 'Add Glucose',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildAverageGlucoseCard(UserProvider userProvider) {
    final averageGlucose = userProvider.glucoseData.isNotEmpty
        ? userProvider.glucoseData
        .map((data) => data['value'] as int)
        .reduce((a, b) => a + b) /
        userProvider.glucoseData.length
        : 0;
    print("Average Glucose: $averageGlucose");

    final mood = averageGlucose > 120 ? 'sad' : 'happy';

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
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                mood == 'sad' ? Icons.sentiment_dissatisfied : Icons.sentiment_satisfied,
                color: Colors.amber,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                '${averageGlucose.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: averageGlucose > 120 ? Colors.red : Colors.green,
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

  Widget _buildGlucoseLevelsCard(UserProvider userProvider) {
    print("Glucose Data for Chart: ${userProvider.glucoseData}");
    final glucoseData = userProvider.glucoseData;

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
                'DAY GLUCOSE LEVELS',
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
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text('6h');
                          case 1:
                            return Text('12h');
                          case 2:
                            return Text('18h');
                          case 3:
                            return Text('24h');
                          default:
                            return Text('');
                        }
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
                minX: 0,
                maxX: glucoseData.length > 0 ? glucoseData.length - 1 : 4,
                minY: 0,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: glucoseData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return FlSpot(index.toDouble(), data['value'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.indigo,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.indigo,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}