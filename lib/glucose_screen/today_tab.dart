import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/glucose_screen/add_glucose.dart';
import 'package:gdm_app/glucose_screen/view_glucose_summary.dart';
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
          return Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAverageGlucoseCard(userProvider),
                  SizedBox(height: 24),
                  _buildGlucoseLevelsCard(userProvider),

                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddGlucoseScreen()),
                    ).then((_) {
                      Utils().toastMessage('Glucose data added');
                      _fetchDataWithRetry();
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Glucose',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFF5AA189),
                  tooltip: 'Add Glucose',
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewGlucoseSummary()),
                    );
                  },
                  icon: const Icon(Icons.summarize, color: Colors.white),
                  label: const Text(
                    'Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFF5AA189),
                  tooltip: 'View Glucose Summary',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  String _getMoodForValue(double value) {
    if (value < 80) return 'low';
    if (value <= 120) return 'happy';
    if (value <= 180) return 'neutral';
    return 'sad';
  }

  Widget _buildAverageGlucoseCard(UserProvider userProvider) {
    final glucoseValues = userProvider.glucoseData
        .where((data) => data['value'] != null)
        .map((data) => data['value'] as int)
        .toList();

    final units = userProvider.glucoseData
        .where((data) => data['unit'] != null)
        .map((data) => data['unit'] as String)
        .toList();

    final averageGlucose = glucoseValues.isNotEmpty
        ? glucoseValues.reduce((a, b) => a + b) / glucoseValues.length
        : 0;
    // Use the most recent unit if available, otherwise default to 'mg/dl'
    final unit = units.isNotEmpty ? units.first : 'mg/dl';

    final mood = _getMoodForValue(averageGlucose.toDouble());

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
            'Today\'s Avg Blood Glucose',
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
                '${averageGlucose.toInt()}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: moodColor,
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

  Widget _buildGlucoseLevelsCard(UserProvider userProvider) {
    final validGlucoseData = userProvider.glucoseData
        .where((data) => data['value'] != null && data['timestamp'] != null && data['mealOption'] != null)        .toList();

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
                'TODAY\'S GLUCOSE LEVELS',
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
      padding: EdgeInsets.all(16),
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
            'TODAY\'S GLUCOSE LEVELS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 1,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 3,
                    );
                  },
                  drawHorizontalLine: true,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= validGlucoseData.length) return SizedBox();
                        final mealOption = validGlucoseData[value.toInt()]['mealOption'] as String;
                        // Shorten mealOption for display
                        final shortLabel = mealOption
                            .replaceAll('Before ', 'Pre ')
                            .replaceAll('After ', 'Post ')
                            .replaceAll('Breakfast', 'B')
                            .replaceAll('Lunch', 'L')
                            .replaceAll('Dinner', 'D');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            shortLabel,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
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
                maxX: validGlucoseData.length > 0 ? validGlucoseData.length - 1 : 4,
                minY: 0,
                maxY: _calculateMaxY(validGlucoseData),
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
                    color: _getLineColor(validGlucoseData),
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
                      color: _getAreaColor(validGlucoseData),
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

  double _calculateMaxY(List<dynamic> glucoseData) {
    final maxValue = glucoseData
        .map((data) => data['value'] as int)
        .reduce((a, b) => a > b ? a : b);
    return (maxValue * 1).ceilToDouble();
  }

  Color _getLineColor(List<dynamic> glucoseData) {
    final avg = glucoseData
        .map((data) => data['value'] as int)
        .reduce((a, b) => a + b) /
        glucoseData.length;
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

  Color _getAreaColor(List<dynamic> glucoseData) {
    final avg = glucoseData
        .map((data) => data['value'] as int)
        .reduce((a, b) => a + b) /
        glucoseData.length;
    if (avg < 80) return Colors.blue.withOpacity(0.1);
    if (avg <= 120) return Colors.green.withOpacity(0.1);
    if (avg <= 180) return Colors.amber.withOpacity(0.1);
    return Colors.red.withOpacity(0.1);
  }
}