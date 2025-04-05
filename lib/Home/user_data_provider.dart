import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _userType = ''; // Added userType field
  bool _isLoading = true;
  String? _errorMessage;
  bool _isDisposed = false; // Add this flag

  // Getters
  String get name => _name;
  String get email => _email;
  String get userType => _userType; // Added getter
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider() {
    // fetchUserData();
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark the provider as disposed
    super.dispose();
  }

  // Helper method to safely call notifyListeners
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
  // Reset user data
  void resetUserData() {
    _name = '';
    _email = '';
    _userType = '';
    _isLoading = true;
    _errorMessage = null;
    _glucoseData = [];
    _safeNotifyListeners();
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Get current user ID
      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }

      // Fetch user data from 'Users' collection
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();

      // If user document exists, populate the data
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        _name = userData['name'] ?? '';
        _email = userData['email'] ?? '';
        _userType = userData['userType'] ?? ''; // Fetch userType

        _isLoading = false;

        _safeNotifyListeners();
      } else {
        _errorMessage = "User data not found in Users collection";
      }
        _isLoading = false;
        _safeNotifyListeners();
      }
     catch (e) {
      _errorMessage = "Error fetching user data: $e";
      _isLoading = false;
      _safeNotifyListeners();
      print("Error fetching user data: $e");
    }
  }

  Future<bool> updateUserProfile(String name, String email) async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _isLoading = false;
        _safeNotifyListeners();
        return false;
      }

      // Update in 'Users' collection only
      await _firestore.collection('Users').doc(uid).update({
        'name': name,
        'email': email,
      });


      // // Update user data in the appropriate collection
      // await _firestore.collection(collection).doc(uid).update({
      //   'name': name,
      //   'email': email,
      // });

      // Update local state
      _name = name;
      _email = email;
      _isLoading = false;
      _safeNotifyListeners();

      return true;
    } catch (e) {
      _errorMessage = "Error updating profile: $e";
      _isLoading = false;
      _safeNotifyListeners();
      print("Error updating profile: $e");
      return false;
    }
  }

  // Code for fetching glucose data
  List<Map<String, dynamic>> _glucoseData = [];

  List<Map<String, dynamic>> get glucoseData => _glucoseData;

  Future<void> fetchGlucoseData() async {
    _isLoading = true;
    _errorMessage = null;
    print('Fetching glucose data...'); // Debugging

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }
      // Check if user exists in 'Users' collection
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();


      if (userDoc.exists) {
        final QuerySnapshot glucoseSnapshot = await _firestore
            .collection('Users')
            .doc(uid)
            .collection('glucoseEntries')
            .orderBy('dateTime', descending: true)
            .get();

        _glucoseData = glucoseSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'value': data['glucoseLevel'],
            'timestamp': data['dateTime'],
          };
        }).toList();
      }else {
        _errorMessage = "User not found in Users collection";
      }


      // Use addPostFrameCallback to defer notifyListeners
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _isLoading = false;
          _safeNotifyListeners();
        });
      }
     catch (e) {
      _errorMessage = "Error fetching glucose data: $e";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoading = false;
        _safeNotifyListeners();
      });
        print("Error fetching glucose data: $e");
    }
  }
  // Add this to your UserProvider class
  Map<String, double> getWeeklyAverages() {
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final weeklyAverages = <String, double>{};

    // Initialize with empty values
    for (var day in weekDays) {
      weeklyAverages[day] = 0;
    }

    // Group data by day of week
    final dailyValues = <int, List<int>>{};
    for (var data in _glucoseData) {
      if (data['timestamp'] != null && data['value'] != null) {
        final date = data['timestamp'].toDate();
        final dayOfWeek = date.weekday % 7; // Sunday = 0, Monday = 1, etc.
        final value = data['value'] as int;

        dailyValues.putIfAbsent(dayOfWeek, () => []).add(value);
      }
    }

    // Calculate averages
    dailyValues.forEach((day, values) {
      weeklyAverages[weekDays[day]] = values.reduce((a, b) => a + b) / values.length;
    });

    return weeklyAverages;
  }

  double getWeeklyAverage() {
    final weeklyData = getWeeklyAverages();
    final values = weeklyData.values.where((value) => value > 0);

    return values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;
  }

  String getWeeklyMood() {
    final average = getWeeklyAverage();
    if (average < 80) return 'low';
    if (average <= 120) return 'happy';
    if (average <= 180) return 'neutral';
    return 'sad';
  }
}