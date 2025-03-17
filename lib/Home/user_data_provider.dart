import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider() {
    // fetchUserData();
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Get current user ID
      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Check in which collection the user exists
      DocumentSnapshot? userDoc;

      // Check 'user' collection
      userDoc = await _firestore.collection('user').doc(uid).get();

      // If not found, check 'users' collection
      if (!userDoc.exists) {
        userDoc = await _firestore.collection('users').doc(uid).get();

        // If still not found, check 'doctor' collection
        if (!userDoc.exists) {
          userDoc = await _firestore.collection('doctor').doc(uid).get();
        }
      }

      // If user document exists, populate the data
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        _name = userData['name'] ?? '';
        _email = userData['email'] ?? '';
        _phoneNumber = userData['phone'] ?? '';
        _isLoading = false;

        notifyListeners();
      } else {
        _errorMessage = "User data not found";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error fetching user data: $e";
      _isLoading = false;
      notifyListeners();
      print("Error fetching user data: $e");
    }
  }

  Future<bool> updateUserProfile(String name, String email, String phone) async {
    _isLoading = true;
    // notifyListeners();

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "No user logged in";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Determine which collection the user is in
      String collection = 'user';
      DocumentSnapshot doc = await _firestore.collection(collection).doc(uid).get();

      if (!doc.exists) {
        collection = 'users';
        doc = await _firestore.collection(collection).doc(uid).get();

        if (!doc.exists) {
          collection = 'doctor';
          doc = await _firestore.collection(collection).doc(uid).get();

          if (!doc.exists) {
            _errorMessage = "User not found in any collection";
            _isLoading = false;
            notifyListeners();
            return false;
          }
        }
      }

      // Update user data in the appropriate collection
      await _firestore.collection(collection).doc(uid).update({
        'name': name,
        'email': email,
        'phone': phone,
      });

      // Update local state
      _name = name;
      _email = email;
      _phoneNumber = phone;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = "Error updating profile: $e";
      _isLoading = false;
      notifyListeners();
      print("Error updating profile: $e");
      return false;
    }
  }

  //Code for fetch glucose data
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
  notifyListeners();
  return;
  }

  // Check in which collection the user exists
  DocumentSnapshot? userDoc;

  userDoc = await _firestore.collection('user').doc(uid).get();
  if (!userDoc.exists) {
  userDoc = await _firestore.collection('users').doc(uid).get();
  if (!userDoc.exists) {
  userDoc = await _firestore.collection('doctor').doc(uid).get();
  }
  }

  if (userDoc.exists) {
  // Fetch glucose data from the 'glucoseEntries' subcollection
  final QuerySnapshot glucoseSnapshot = await _firestore
      .collection(userDoc.reference.parent.id) // Use the correct collection
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

  _isLoading = false;
  notifyListeners();
  } else {
  _errorMessage = "User not found in any collection";
  _isLoading = false;
  notifyListeners();
  }
  } catch (e) {
  _errorMessage = "Error fetching glucose data: $e";
  _isLoading = false;
  notifyListeners();
  print("Error fetching glucose data: $e");
  }
  }
  }

