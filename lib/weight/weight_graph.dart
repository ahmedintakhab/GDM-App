import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightGraph extends StatelessWidget {
  final double maxWidth; // Dynamic width based on screen size
  final double barWidth; // Dynamic bar width based on screen size

  // Data for each day: single weight value in kg
  final List<double> weeklyData = [
    55, // Saturday
    28, // Sunday
    63, // Monday
    57, // Tuesday
    100, // Wednesday
    40, // Thursday
    70, // Friday
  ];

   WeightGraph({
    Key? key,
    required this.maxWidth,
    required this.barWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      height: 250, // Adjusted height to fit inside the container
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 150, // Increased to ensure space for text above bars
          barTouchData: BarTouchData(
            enabled: true, // Enable touch interactions
            touchTooltipData: BarTouchTooltipData(
              tooltipBorder: const BorderSide(
                color: Colors.transparent, // Remove the tooltip border
                width: 0,
              ),
              tooltipPadding: const EdgeInsets.all(0), // Remove padding
              tooltipMargin: -1, // Position the text closer to the bar top
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${weeklyData[groupIndex].toInt()} kg', // Display weight in kg
                  const TextStyle(
                    color: Colors.white, // Changed to white for contrast
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
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Sat', style: style);
                    case 1:
                      return const Text('Sun', style: style);
                    case 2:
                      return const Text('Mon', style: style);
                    case 3:
                      return const Text('Tue', style: style);
                    case 4:
                      return const Text('Wed', style: style);
                    case 5:
                      return const Text('Thu', style: style);
                    case 6:
                      return const Text('Fri', style: style);
                    default:
                      return const Text('', style: style);
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Hide left titles
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Hide top titles
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Hide right titles
            ),
          ),
          gridData: FlGridData(show: false), // Hide grid
          borderData: FlBorderData(show: false), // Hide border
          barGroups: List.generate(7, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: weeklyData[index], // Single bar height (weight in kg)
                  color: const Color(0xFF5AA189), // Set to your desired color
                  width: barWidth,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(barWidth / 2),
                    topRight: Radius.circular(barWidth / 2),
                  ),
                  rodStackItems: [
                    BarChartRodStackItem(
                      0,
                      weeklyData[index],
                      const Color(0xFF5AA189), // Updated to match bar color
                    ),
                  ],
                ),
              ],
              showingTooltipIndicators: [0], // Show tooltip for the single bar
            );
          }),
          extraLinesData: ExtraLinesData(
            extraLinesOnTop: false,
          ),
        ),
      ),
    );
  }
}