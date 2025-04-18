import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepsCountContainer extends StatefulWidget {
  const StepsCountContainer({Key? key}) : super(key: key);

  @override
  _StepsCountContainerState createState() => _StepsCountContainerState();
}

class _StepsCountContainerState extends State<StepsCountContainer> {
  int steps = 0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  List<double> _magnitudeHistory = [];
  final int _historySize = 20;
  bool _isWalking = false;
  final double _walkingThreshold = 2.0;
  final double _peakThreshold = 3.0;
  DateTime _lastStepTime = DateTime.now();
  final Duration _minStepInterval = Duration(milliseconds: 300);
  final Duration _walkingTimeout = Duration(seconds: 2);
  DateTime _lastWalkingTime = DateTime.now();
  String _debugText = "Initializing...";
  double _varianceValue = 0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadStepsFromFirestore();
    _startStepCounting();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadStepsFromFirestore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Check in which collection the user exists
      DocumentSnapshot userDoc = await _firestore.collection('Users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        // Safely access the 'steps' field
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('steps')) {
          setState(() {
            steps = data['steps'] ?? 0; // Use the steps value or default to 0
          });
        } else {
          setState(() {
            steps = 0; // Default value if 'steps' field is missing
          });
        }
      } else {
        setState(() {
          steps = 0; // Default value if document does not exist
        });
      }
    }
  }

  Future<void> _updateFirestoreSteps() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      // Update or create steps in Users collection only
        await _firestore.collection('Users').doc(uid).set({'steps': steps},
        SetOptions(merge: true));

    }
  }

  void _startStepCounting() {
    _accelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((AccelerometerEvent event) {
      if (mounted) {
        final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        _processAccelerometerReading(magnitude);
      }
    }, onError: (e) {
      debugPrint('Sensor error: $e');
    }, cancelOnError: false);
  }

  void _processAccelerometerReading(double magnitude) {
    _magnitudeHistory.add(magnitude);
    if (_magnitudeHistory.length > _historySize) {
      _magnitudeHistory.removeAt(0);
    }

    if (_magnitudeHistory.length < _historySize) {
      return;
    }

    double mean = _magnitudeHistory.reduce((a, b) => a + b) / _magnitudeHistory.length;
    double variance = _magnitudeHistory.fold(0.0, (sum, item) =>
    sum + pow(item - mean, 2)) / _magnitudeHistory.length;

    _varianceValue = variance;

    bool previousWalkingState = _isWalking;
    _isWalking = variance > _walkingThreshold;

    if (_isWalking) {
      _lastWalkingTime = DateTime.now();
    } else if (DateTime.now().difference(_lastWalkingTime) < _walkingTimeout) {
      _isWalking = true;
    }

    if (_isWalking) {
      List<double> recentReadings = _magnitudeHistory.sublist(
          max(0, _magnitudeHistory.length - 5), _magnitudeHistory.length);

      if (recentReadings.length >= 3) {
        double current = recentReadings.last;
        double previous = recentReadings[recentReadings.length - 2];
        double beforePrevious = recentReadings[recentReadings.length - 3];

        bool isPeak = previous > current &&
            previous > beforePrevious &&
            previous > mean + _peakThreshold;

        DateTime now = DateTime.now();
        if (isPeak && now.difference(_lastStepTime) > _minStepInterval) {
          if (mounted) {
            setState(() {
              steps++;
              _debugText = "Step detected! Variance: ${variance.toStringAsFixed(2)}";
            });
          }
          _lastStepTime = now;

          if (steps % 2 == 0) {
            _updateFirestoreSteps(); // Save steps to Firestore periodically
          }
        }
      }
    }

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
        height: 150,
        padding: const EdgeInsets.all(8),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Circular Progress Indicator with Icon
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130, // Increased size
                  height: 130, // Increased size
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      value: steps / 1000, // Range of 10,000 steps
                      strokeWidth: 15,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5AA189)),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ),
                Positioned(
                  top: 30, // Adjusted for larger circle
                  child: Icon(
                    Icons.directions_walk,
                    color: _isWalking ? Colors.green : Colors.grey,
                    size: 50, // Slightly larger icon to match scale
                  ),
                ),
              ],
            ),
            SizedBox(width: 40.w,),
            // Right side: Steps, Walking Indicator, and Debug Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        steps.toString(),
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5AA189),
                        ),
                      ),
                      SizedBox(width: 4),
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
                  Text(
                    'steps',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5AA189),
                    ),
                  ),
                  SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }
}