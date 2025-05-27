import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _mealsData = [];
  int _dailyCalories = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<Map<String, dynamic>> get mealsData => _mealsData;
  int get dailyCalories => _dailyCalories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMealsData() async {
    _isLoading = true;
    _errorMessage = null;
    print('Fetching meals data...');

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

      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        final QuerySnapshot mealsSnapshot = await _firestore
            .collection('Users')
            .doc(uid)
            .collection('Meals Plain')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        _mealsData = mealsSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'dailyCalories': data['Daily Calories'] ?? 0,
            'timestamp': data['timestamp'],
          };
        }).toList();

        _dailyCalories = _mealsData.isNotEmpty ? _mealsData.first['dailyCalories'] as int : 0;
      } else {
        _errorMessage = "User not found in Users collection";
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoading = false;
        _safeNotifyListeners();
      });
    } catch (e) {
      _errorMessage = "Error fetching meals data: $e";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoading = false;
        _safeNotifyListeners();
      });
      print("Error fetching meals data: $e");
    }
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}