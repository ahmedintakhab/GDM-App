import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class StepsCountContainer extends StatefulWidget {
  const StepsCountContainer({Key? key}) : super(key: key);

  @override
  _StepsCountContainerState createState() => _StepsCountContainerState();
}

class _StepsCountContainerState extends State<StepsCountContainer> {
  // Step counting
  int steps = 0;
  final String _stepsKey = "steps_count";

  // Stream subscription
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Step detection algorithm
  List<double> _magnitudeHistory = [];
  final int _historySize = 20;
  bool _isWalking = false;

  // Calibrated thresholds for walking detection
  final double _walkingThreshold = 2.0;  // Minimum variation needed for walking
  final double _peakThreshold = 3.0;     // Threshold for detecting a step

  // Timing for step detection
  DateTime _lastStepTime = DateTime.now();
  final Duration _minStepInterval = Duration(milliseconds: 300);
  final Duration _walkingTimeout = Duration(seconds: 2);
  DateTime _lastWalkingTime = DateTime.now();

  // Debugging
  String _debugText = "Initializing...";
  double _varianceValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedSteps();
    _startStepCounting();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedSteps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          steps = prefs.getInt(_stepsKey) ?? 0;
        });
      }
    } catch (e) {
      debugPrint('Error loading steps: $e');
    }
  }

  Future<void> _saveSteps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_stepsKey, steps);
    } catch (e) {
      debugPrint('Error saving steps: $e');
    }
  }

  void _startStepCounting() {
    _accelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((AccelerometerEvent event) {
      if (mounted) {
        // Calculate the magnitude of acceleration
        final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

        // Process the new reading
        _processAccelerometerReading(magnitude);
      }
    }, onError: (e) {
      debugPrint('Sensor error: $e');
    }, cancelOnError: false);
  }

  void _processAccelerometerReading(double magnitude) {
    // Add to history
    _magnitudeHistory.add(magnitude);
    if (_magnitudeHistory.length > _historySize) {
      _magnitudeHistory.removeAt(0);
    }

    if (_magnitudeHistory.length < _historySize) {
      return; // Wait until we have enough data
    }

    // Calculate variance (how much the readings are changing)
    double mean = _magnitudeHistory.reduce((a, b) => a + b) / _magnitudeHistory.length;
    double variance = _magnitudeHistory.fold(0.0, (sum, item) =>
    sum + pow(item - mean, 2)) / _magnitudeHistory.length;

    // Store for debugging
    _varianceValue = variance;

    // Check if we're walking based on variance (a measure of how much acceleration is changing)
    bool previousWalkingState = _isWalking;
    _isWalking = variance > _walkingThreshold;

    if (_isWalking) {
      _lastWalkingTime = DateTime.now();
    } else if (DateTime.now().difference(_lastWalkingTime) < _walkingTimeout) {
      // Still consider walking for a brief period after motion stops
      // This prevents losing steps during natural pauses in walking
      _isWalking = true;
    }

    // Look for step pattern in the signal
    if (_isWalking) {
      // Get recent readings
      List<double> recentReadings = _magnitudeHistory.sublist(
          max(0, _magnitudeHistory.length - 5), _magnitudeHistory.length);

      // Check for typical walking pattern - a peak followed by a trough
      if (recentReadings.length >= 3) {
        double current = recentReadings.last;
        double previous = recentReadings[recentReadings.length - 2];
        double beforePrevious = recentReadings[recentReadings.length - 3];

        // Pattern: first rising then falling (peak)
        bool isPeak = previous > current &&
            previous > beforePrevious &&
            previous > mean + _peakThreshold;

        // Respect minimum time between steps
        DateTime now = DateTime.now();
        if (isPeak && now.difference(_lastStepTime) > _minStepInterval) {
          if (mounted) {
            setState(() {
              steps++;
              _debugText = "Step detected! Variance: ${variance.toStringAsFixed(2)}";
            });
          }
          _lastStepTime = now;

          // Save steps periodically
          if (steps % 10 == 0) {
            _saveSteps();
          }
        }
      }
    }

    // Update debug info
    if (mounted && (_isWalking != previousWalkingState || steps % 5 == 0)) {
      setState(() {
        if (!_isWalking) {
          _debugText = "Not walking. Variance: ${variance.toStringAsFixed(2)}";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: _isWalking ? const Color(0xFF5AA189) : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Steps Count',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                // Walking indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isWalking ? Colors.green : Colors.grey[300],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              steps.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'steps',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            // Debug text
            const SizedBox(height: 4),
            Text(
              _debugText,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}