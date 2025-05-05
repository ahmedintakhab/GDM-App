import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _age = '';
  String _weight = '';
  String _height = '';
  String _ethnicity = '';
  String _gender = '';
  String _waist = '';
  String _diabetes = '';
  String _childrenAlive = '';
  String _deliveries = '';
  String _pregnancies = '';
  String _diabetesTestDate = '';
  String _miscarriages = '';
  String _stillbirths = '';
  String _familytHistory = '';
  String _hypertension = '';
  String _userType = ''; // Added userType field
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false; // Add this flag
  String _lmp = '';
  String _dueDate = '';
  String? _personalInfoDocId; // To store the document ID
  String? _lastVisit;
  String? _nextVisit;

  // Getters
  String get name => _name;
  String get email => _email;
  String get age => _age;
  String get gender => _gender;
  String get waist => _waist;
  String get weight => _weight;
  String get height => _height;
  String get diabetes => _diabetes;
  String get childrenAlive => _childrenAlive;
  String get deliveries => _deliveries;
  String get pregnancies => _pregnancies;
  String get diabetesTestDate => _diabetesTestDate;
  String get miscarriages => _miscarriages;
  String get stillbirths => _stillbirths;
  String get familyHistory => _familytHistory;
  String get hypertension => _hypertension;
  String get ethnicity => _ethnicity;
  String get userType => _userType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get lmp => _lmp;
  String get dueDate => _dueDate;
  String? get lastVisit => _lastVisit;
  String? get nextVisit => _nextVisit;


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
    _age = '';
    _gender = '';
    _waist = '';
    _weight = '';
    _height = '';
    _ethnicity = '';
    _diabetes = '';
    _childrenAlive = '';
    _deliveries = '';
    _pregnancies = '';
    _diabetesTestDate = '';
    _miscarriages = '';
    _stillbirths = '';
    _familytHistory = '';
    _hypertension= '';
    _userType = '';
    _isLoading = false;
    _errorMessage = null;
    _personalInfoDocId = null;
    _lmp = '';
    _dueDate = '';
    _lastVisit = null;
    _nextVisit = null;
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

      // If user document exists, populate name, email, and userType
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        _name = userData['name'] ?? '';
        _email = userData['email'] ?? '';
        _userType = userData['userType'] ?? ''; // Fetch userType
      } else {
        _errorMessage = "User data not found in Users collection";
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }

      // Fetch age, weight, height, ethnicity from 'Personal Information' subcollection
      if (_personalInfoDocId == null) {
        final snapshot = await _firestore
            .collection('Users')
            .doc(uid)
            .collection('Personal Information')
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _personalInfoDocId = snapshot.docs.first.id;
        }
      }

      // Fetch data from Personal Information document
      if (_personalInfoDocId != null) {
        final personalInfoDoc = await _firestore
            .collection('Users')
            .doc(uid)
            .collection('Personal Information')
            .doc(_personalInfoDocId)
            .get();

        if (personalInfoDoc.exists) {
          final personalData = personalInfoDoc.data() as Map<String, dynamic>;
          _age = personalData['age'] ?? '';
          _weight = personalData['weight'] ?? '';
          _height = personalData['height'] ?? '';
          _gender = personalData['gender'] ?? '';
          _waist = personalData['waist'] ?? '';
          _ethnicity = personalData['ethnicity'] ?? '';
          _diabetes = personalData['diabetes'] ?? '';
          _stillbirths = personalData['stillbirths'] ?? '';
          _miscarriages = personalData['miscarriages'] ?? '';
          _pregnancies = personalData['pregnancies'] ?? '';
          _diabetesTestDate = personalData['diabetesTestDate'] ?? '';
          _childrenAlive = personalData['childrenAlive'] ?? '';
          _deliveries = personalData['deliveries'] ?? '';
          _familytHistory = personalData['familyHistory'] ?? '';
          _hypertension = personalData['hypertension'] ?? '';
          _lmp = personalData['lmp'] ?? '';
          _dueDate = personalData['lmp dueDate'] ?? '';
          _lastVisit = personalData['lastVisit'] as String?;
          _nextVisit = personalData['nextVisit'] as String?;
        }
      }

      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _errorMessage = "Error fetching user data: $e";
      _isLoading = false;
      _safeNotifyListeners();
      print("Error fetching user data: $e");
    }
  }
  Future<bool> updateUserProfile(
      String name,
      String email,
      String age,
      String weight,
      String height,
      String ethnicity,
      // Include other fields to update
          {String gender = '',
        String waist = '',
        String diabetes = '',
        String hypertension = '',
        String deliveries = '',
        String childrenAlive = '',
        String pregnancies = '',
        String diabetesTestDate = '',
        String miscarriages = '',
        String stillbirths = '',
        String familyHistory = ''}) async {
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

      // Update name and email in 'Users' collection
      await _firestore.collection('Users').doc(uid).update({
        'name': name,
        'email': email,
      });

      // Ensure we have the document ID for Personal Information
      if (_personalInfoDocId == null) {
        final snapshot = await _firestore
            .collection('Users')
            .doc(uid)
            .collection('Personal Information')
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _personalInfoDocId = snapshot.docs.first.id;
        } else {
          // Create a new document if none exists
          final newDoc = await _firestore
              .collection('Users')
              .doc(uid)
              .collection('Personal Information')
              .add({});
          _personalInfoDocId = newDoc.id;
        }
      }

      // Update age, weight, height, ethnicity in 'Personal Information' subcollection
      await _firestore
          .collection('Users')
          .doc(uid)
          .collection('Personal Information')
          .doc(_personalInfoDocId)
          .set({
        'age': age,
        'weight': weight,
        'height': height,
        'ethnicity': ethnicity,
        'gender': gender,
        'waist': waist,
        'diabetes': diabetes,
        'hypertension': hypertension,
        'deliveries': deliveries,
        'childrenAlive': childrenAlive,
        'pregnancies': pregnancies,
        'diabetesTestDate': diabetesTestDate,
        'miscarriages': miscarriages,
        'stillbirths': stillbirths,
        'familyHistory': familyHistory,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local state
      _name = name;
      _email = email;
      _age = age;
      _weight = weight;
      _gender = gender;
      _waist = waist;
      _height = height;
      _ethnicity = ethnicity;
      _diabetes = diabetes;
      _deliveries = deliveries;
      _childrenAlive = childrenAlive;
      _pregnancies = pregnancies;
      _diabetesTestDate = diabetesTestDate;
      _stillbirths = stillbirths;
      _miscarriages = miscarriages;
      _familytHistory = familyHistory;
      _hypertension = hypertension;
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
  }  // Add this method to update visits
  // Add this to your initialization or fetch method
  Future<void> fetchDoctorVisits() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // First try to get the document ID if we don't have it
      if (_personalInfoDocId == null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Personal Information')
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _personalInfoDocId = snapshot.docs.first.id;
        }
      }

      // Now fetch the visits data
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Personal Information')
          .doc(_personalInfoDocId ?? 'default_doc')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _lastVisit = data['lastVisit'] as String?;
          _nextVisit = data['nextVisit'] as String?;
        });
      }
    } catch (e) {
      print("Error fetching doctor visits: $e");
    }
  }

// Update this method to ensure proper persistence
  Future<void> updateDoctorVisits(String newNextVisit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Ensure we have the document ID
      if (_personalInfoDocId == null) {
        await fetchDoctorVisits();
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Personal Information')
          .doc(_personalInfoDocId ?? 'default_doc')
          .set({
        'lastVisit': _nextVisit, // Current next becomes last
        'nextVisit': newNextVisit,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local state
      setState(() {
        _lastVisit = _nextVisit;
        _nextVisit = newNextVisit;
      });
    } catch (e) {
      print("Error updating doctor visits: $e");
    }
  }

// Helper method to safely update state
  void setState(VoidCallback fn) {
    if (!_isDisposed) {
      fn();
      _safeNotifyListeners();
    }
  }


  //Code for fetching LMP
  // Fetch pregnancy information
  Future<void> fetchPregnancyInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Personal Information')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        _lmp = data['lmp'] ?? '';
        _dueDate = data['lmp dueDate'] ?? '';
        _personalInfoDocId = doc.id; // Store document ID
        _safeNotifyListeners();
      }
    } catch (e) {
      print("Error fetching pregnancy info: $e");
    }
  }

  // Update pregnancy information (simplified without if-else)
  Future<bool> updatePregnancyInfo(String lmp, String dueDate) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // Always use the same document reference
      final docRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Personal Information')
          .doc(_personalInfoDocId ?? 'default_doc'); // Fallback ID

      await docRef.set({
        'lmp': lmp,
        'lmp dueDate': dueDate,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _lmp = lmp;
      _dueDate = dueDate;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      print("Error updating pregnancy info: $e");
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
          // Parse glucoseLevel string (e.g., "99 mmol/L")
          final glucoseLevel = data['glucoseLevel'] as String;
          final parts = glucoseLevel.split(' ');
          final value = int.parse(parts[0]); // Extract number
          final unit = parts[1]; // Extract unit
          return {
            'value': value,
            'unit': unit,
            'timestamp': data['dateTime'],
            'mealOption': data['mealOption'] ?? 'Unknown', // Include mealOption
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

    // Calculate averages and truncate decimals
    dailyValues.forEach((day, values) {
      if (values.isNotEmpty) {
        final average = values.reduce((a, b) => a + b) / values.length;
        weeklyAverages[weekDays[day]] = average.floor().toDouble(); // Truncate decimals
      }
    });

    return weeklyAverages;
  }

  double getWeeklyAverage() {
    final weeklyData = getWeeklyAverages();
    final values = weeklyData.values.where((value) => value > 0);

    if (values.isEmpty) return 0;
    final average = values.reduce((a, b) => a + b) / values.length;
    return average.floor().toDouble(); // Truncate decimals
     }

  String getWeeklyMood() {
    final average = getWeeklyAverage();
    if (average < 80) return 'low';
    if (average <= 120) return 'happy';
    if (average <= 180) return 'neutral';
    return 'sad';
  }
}