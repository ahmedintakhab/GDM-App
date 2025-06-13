import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class MealsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _mealsData = [];
  List<Map<String, dynamic>> _foodsData = [];
  Map<String, List<Map<String, dynamic>>> _mealItems = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };
  int _dailyCalories = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<Map<String, dynamic>> get mealsData => _mealsData;
  List<Map<String, dynamic>> get foodsData => _foodsData;
  Map<String, List<Map<String, dynamic>>> get mealItems => _mealItems;
  int get dailyCalories => _dailyCalories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMealsData() async {
    if (_isDisposed) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? uid = auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }

      DocumentSnapshot userDoc = await firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        // Fetch Daily Calories
        final QuerySnapshot mealsSnapshot = await firestore
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

        // Fetch Foods
        final QuerySnapshot foodsSnapshot = await firestore
            .collection('Users')
            .doc(uid)
            .collection('Meals Plain')
            .doc('data')
            .collection

          ('Foods')
            .orderBy('timestamp', descending: true)
            .get();

        _foodsData = foodsSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'foodName': data['foodName'] ?? 'Unnamed',
            'foodCalories': data['Food Calories'] ?? 0,
            'quantity': data['quantity'] ?? '',
            'timestamp': data['timestamp'],
          };
        }).toList();

        // Fetch Meal Items for today
        String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final QuerySnapshot mealItemsSnapshot = await firestore
            .collection('Users')
            .doc(uid)
            .collection('Meals Plain')
            .doc(today)
            .collection('MealItems')
            .orderBy('timestamp', descending: true)
            .get();

        // Reset meal items
        _mealItems = {
          'Breakfast': [],
          'Lunch': [],
          'Dinner': [],
          'Snacks': [],
        };

        for (var doc in mealItemsSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          String mealType = data['mealType'];
          if (_mealItems.containsKey(mealType)) {
            _mealItems[mealType]!.add({
              'foodName': data['foodName'],
              'calories': data['calories'],
              'quantity': data['quantity'],
              'timestamp': data['timestamp'],
            });
          }
        }
      } else {
        _errorMessage = "User not found in Users collection";
      }

      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _errorMessage = "Error fetching meals data: $e";
      _isLoading = false;
      _safeNotifyListeners();
      print("Error fetching meals data: $e");
    }
  }

  Future<void> addMealItem(String mealType, Map<String, dynamic> foodItem) async {
    if (_isDisposed) return;

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? uid = auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _safeNotifyListeners();
        return;
      }

      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final mealData = {
        'foodName': foodItem['foodName'],
        'calories': foodItem['calories'],
        'quantity': foodItem['quantity'],
        'mealType': mealType,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('Users')
          .doc(uid)
          .collection('Meals Plain')
          .doc(today)
          .collection('MealItems')
          .add(mealData);

      // Refresh data
      await fetchMealsData();
      // Show toast message on successful addition
      Utils().toastMessage('Food added successfully');
    } catch (e) {
      _errorMessage = "Error adding meal item: $e";
      Utils().toastMessage('Error adding food: $e');
      _safeNotifyListeners();
      print("Error adding meal item: $e");
    }
  }

  Future<void> removeMealItem(String mealType, Map<String, dynamic> foodItem) async {
    if (_isDisposed) return;

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? uid = auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _safeNotifyListeners();
        return;
      }

      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // Find one document matching the foodName and mealType
      final QuerySnapshot snapshot = await firestore
          .collection('Users')
          .doc(uid)
          .collection('Meals Plain')
          .doc(today)
          .collection('MealItems')
          .where('foodName', isEqualTo: foodItem['foodName'])
          .where('mealType', isEqualTo: mealType)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Delete the first matching document
        await snapshot.docs.first.reference.delete();
        // Refresh data to update the UI
        await fetchMealsData();
        // Show toast message on successful deletion
        Utils().toastMessage('Food deleted successfully');
      } else {
        _errorMessage = "Item not found in Firestore";
        Utils().toastMessage('Item not found');
        _safeNotifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error removing meal item: $e";
      Utils().toastMessage('Error deleting food: $e');
      _safeNotifyListeners();
      print("Error removing meal item: $e");
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