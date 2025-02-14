// weekly_glucose_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyGlucoseChart extends StatelessWidget {
  const WeeklyGlucoseChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('S');
                  case 1:
                    return Text('S');
                  case 2:
                    return Text('M');
                  case 3:
                    return Text('T');
                  case 4:
                    return Text('W');
                  case 5:
                    return Text('T');
                  case 6:
                    return Text('F');
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
        maxX: 6,
        minY: 0,
        maxY: 200,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 120),
              FlSpot(1, 140),
              FlSpot(2, 90),
              FlSpot(3, 80),
              FlSpot(4, 110),
              FlSpot(5, 140),
              FlSpot(6, 160),
            ],
            isCurved: true,
            color: Color(0xFF4CAF50),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Color(0xFF4CAF50).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}