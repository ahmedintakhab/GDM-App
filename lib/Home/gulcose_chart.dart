// weekly_glucose_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';

class WeeklyGlucoseChart extends StatelessWidget {
  final Map<String, double> weeklyData;

  const WeeklyGlucoseChart({Key? key, required this.weeklyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    // Convert weekly data to spots
    final spots = weekDays.asMap().entries.map((entry) {
      final index = entry.key;
      final day = entry.value;
      return FlSpot(
        index.toDouble(),
        weeklyData[day] ?? 0,
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final dayIndex = value.toInt();
                if (dayIndex >= 0 && dayIndex < weekDays.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weekDays[dayIndex][0], // Show just first letter
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
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
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: _calculateMaxY(weeklyData.values),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _getLineColor(spots),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: _getDotColor(spot.y),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: _getAreaColor(spots),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxY(Iterable<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2 ).ceilToDouble();
  }

  Color _getLineColor(List<FlSpot> spots) {
    final avg = spots.map((s) => s.y).reduce((a, b) => a + b) / spots.length;
    if (avg < 80) return Colors.blue;
    if (avg <= 120) return Colors.green;
    if (avg <= 180) return Colors.amber;
    return Colors.red;
  }

  Color _getDotColor(double value) {
    if (value < 80) return Colors.blue;
    if (value <= 120) return Colors.green;
    if (value <= 180) return Colors.amber;
    return Colors.red;
  }

  Color _getAreaColor(List<FlSpot> spots) {
    final avg = spots.map((s) => s.y).reduce((a, b) => a + b) / spots.length;
    if (avg < 80) return Colors.blue.withOpacity(0.1);
    if (avg <= 120) return Colors.green.withOpacity(0.1);
    if (avg <= 180) return Colors.amber.withOpacity(0.1);
    return Colors.red.withOpacity(0.1);
  }
}