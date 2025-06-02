import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeightGraph extends StatelessWidget {
  final double maxWidth; // Dynamic width based on screen size
  final double barWidth; // Dynamic bar width based on screen size
  final List<Map<String, dynamic>> weightData; // Pre-fetched data

  const WeightGraph({
    Key? key,
    required this.maxWidth,
    required this.barWidth,
    required this.weightData,
  }) : super(key: key);

  Color _getBarColor(double weight) {
    if (weight < 50) return Colors.yellow;
    if (weight >= 50 && weight <= 80) return Colors.green;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Calculate maxY and latest weight details
    double maxY = 150; // Default maxY
    String? latestWeight = l10n.notApplicable;
    String? latestUnit = '';
    Color? latestWeightColor = Colors.black87;

    if (weightData.isNotEmpty) {
      maxY = weightData
          .map((data) => data['weight'] as double)
          .reduce((a, b) => a > b ? a : b); // Find max weight
      maxY = (maxY * 1.2).ceilToDouble(); // Add 20% padding and round up
      maxY = maxY < 50 ? 50 : maxY; // Ensure minimum maxY
      latestWeight = weightData.last['weight'].toStringAsFixed(1);
      latestUnit = weightData.last['unit'];
      latestWeightColor = _getBarColor(weightData.last['weight']);
    }

    return Stack(
      children: [
        // Current Weight Text
        Positioned(
          top: 0,
          left: 0,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              '${l10n.currentWeight} $latestWeight $latestUnit',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: latestWeightColor,
              ),
            ),
          ),
        ),
        // Graph or Empty State
        weightData.isEmpty
            ?  Center(child: Text(l10n.noWeightDataPastWeek))
            : Padding(
          padding: EdgeInsets.only(top: 28.h),
          child: SizedBox(
            width: maxWidth,
            height: 250.h - 28.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBorder: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipMargin: -1,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${weightData[groupIndex]['weight'].toInt()} ${weightData[groupIndex]['unit']}',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        );
                        if (value.toInt() >= weightData.length) {
                          return const Text('', style: style);
                        }
                        String dateStr = weightData[value.toInt()]['date'];
                        DateTime date = DateFormat('dd MMM yyyy').parse(dateStr);
                        String day = DateFormat('E').format(date).substring(0, 3);
                        return Text(day, style: style);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(weightData.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: weightData[index]['weight'],
                        color: _getBarColor(weightData[index]['weight']),
                        width: barWidth,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(barWidth / 2),
                          topRight: Radius.circular(barWidth / 2),
                        ),
                        rodStackItems: [
                          BarChartRodStackItem(
                            0,
                            weightData[index]['weight'],
                            _getBarColor(weightData[index]['weight']),
                          ),
                        ],
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }),
                extraLinesData: ExtraLinesData(
                  extraLinesOnTop: false,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}