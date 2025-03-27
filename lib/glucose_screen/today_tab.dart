import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gdm_app/glucose_screen/add_glucose.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gdm_app/utils/utils.dart';

import '../Home/user_data_provider.dart';

class TodayTab extends StatefulWidget {
  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  bool _isRetrying = false;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDataWithRetry();
  }

  Future<void> _fetchDataWithRetry() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Check connectivity first
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Utils().toastMessage('No internet connection');
      return;
    }

    setState(() {
      _isRetrying = true;
      _retryCount++;
    });

    try {
      await userProvider.fetchUserData();
      await userProvider.fetchGlucoseData();
      Utils().toastMessage('Data loaded successfully');
    } catch (e) {
      if (_retryCount < 3) {
        // Exponential backoff
        await Future.delayed(Duration(seconds: 1 * _retryCount));
        await _fetchDataWithRetry();
        return;
      }
      Utils().toastMessage('Failed to load data after $_retryCount attempts');
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (_isRetrying) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Retrying... (Attempt $_retryCount/3)'),
              ],
            ),
          );
        } else if (userProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${userProvider.errorMessage}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchDataWithRetry,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        } else if (userProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
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
                    ).then((_) {
                      Utils().toastMessage('Glucose data added');
                      _fetchDataWithRetry();
                    });
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
    final glucoseValues = userProvider.glucoseData
        .where((data) => data['value'] != null)
        .map((data) => data['value'] as int)
        .toList();

    final averageGlucose = glucoseValues.isNotEmpty
        ? glucoseValues.reduce((a, b) => a + b) / glucoseValues.length
        : 0;

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
    final validGlucoseData = userProvider.glucoseData
        .where((data) => data['value'] != null && data['timestamp'] != null)
        .toList();

    if (validGlucoseData.isEmpty) {
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
        child: Center(
          child: Column(
            children: [
              Text(
                'DAY GLUCOSE LEVELS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text('No glucose data available'),
            ],
          ),
        ),
      );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAY GLUCOSE LEVELS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
                        final date = validGlucoseData[value.toInt()]['timestamp'].toDate();
                        final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
                        final minute = date.minute.toString().padLeft(2, '0');
                        final period = date.hour >= 12 ? 'pm' : 'am';

                        return SizedBox(
                          width: 50, // Adjust width as needed
                          child: Text(
                            '$hour:$minute $period',
                            textAlign: TextAlign.center, // Keeps text within bounds
                            style: TextStyle(fontSize: 10), // Adjust font size as needed
                          ),
                        );

                      },

                      // switch (value.toInt()) {
                        // case 0:
                        // return Text('6am');
                        // case 1:
                        // return Text('8am');
                        // case 2:
                        // return Text('12pm');
                        // case 3:
                        // return Text('2pm');
                        // case 4:
                        // return Text('8pm');
                        // case 5:
                        // return Text('10pm');
                        // default:
                        // return Text('');
                        // }
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      reservedSize: 30, // Space for Y-axis labels
                      getTitlesWidget: (value, meta) {
                        double fontSize = 10; // Define fontSize

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              fontSize: fontSize.clamp(8, 12),
                            ),
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
                maxX: validGlucoseData.length > 0 ? validGlucoseData.length - 1 : 4,
                minY: 0,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: validGlucoseData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return FlSpot(
                        index.toDouble(),
                        (data['value'] as int).toDouble(),
                      );
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