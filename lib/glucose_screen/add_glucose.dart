import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/glucose_screen/glucose_details_screen.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AddGlucoseScreen extends StatefulWidget {
  const AddGlucoseScreen({Key? key}) : super(key: key);

  @override
  State<AddGlucoseScreen> createState() => _AddGlucoseScreenState();
}

class _AddGlucoseScreenState extends State<AddGlucoseScreen> {
  final TextEditingController _glucoseController = TextEditingController();
  String _selectedMealOption = 'Before Meal';
  DateTime _selectedDateTime = DateTime.now();
  bool _isLoading = false; // Track loading state


  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }
  // Function to save glucose data to Firestore
  Future<void> _saveGlucoseData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Get the current user's UID
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        Utils().toastMessage('User not logged in!');
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

      // If the user exists in one of the collections, save the glucose data
      if (userDoc.exists) {
        // Prepare the glucose data
        final glucoseData = {
          'dateTime': _selectedDateTime,
          'glucoseLevel': int.parse(_glucoseController.text),
          'mealOption': _selectedMealOption,
        };

        // Add the glucose data to the user's document
        await _firestore
            .collection(userDoc.reference.parent.id) // Use the correct collection
            .doc(uid)
            .collection('glucoseEntries') // Subcollection for glucose entries
            .add(glucoseData);

        // // Add the glucose data to the user's document
        // await _firestore
        //     .collection(userDoc.reference.parent.id) // Use the correct collection
        //     .doc(uid)
        //     .update({
        //   'glucoseEntries': FieldValue.arrayUnion([glucoseData]), // Add to existing array
        // });

        // Show success toast message
        Utils().toastMessage('Successfully added glucose data!');

        // Navigate to the GlucoseDetailsScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GlucoseDetailsScreen(),
          ),
        );
      } else {
        Utils().toastMessage('User not found in any collection!');
      }
    } catch (e) {
      // Handle errors
      Utils().toastMessage('Error: $e');
    } finally{
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GLUCOSE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFF5AA189),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // Date & Time Selector
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date & time',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Today, ${DateFormat('HH:mm').format(DateTime.now())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Glucose Level Input Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Glucose level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _glucoseController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Value',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Text(
                              'mg/dl',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Meal Selection Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:  Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMealOption = 'Before Meal';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedMealOption == 'Before Meal'
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: _selectedMealOption == 'Before Meal'
                                ? Border.all(color: Colors.green, width: 1)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apple,
                                color: Colors.green,
                                size: 30,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Before Meal',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMealOption = 'After Meal';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedMealOption == 'After Meal'
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: _selectedMealOption == 'After Meal'
                                ? Border.all(color: Colors.green, width: 1)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant,
                                color: Colors.green,
                                size: 30,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'After Meal',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  : CustomButton(
                onTap: _saveGlucoseData, // Call _saveGlucoseData on button tap
                buttonText: 'Save',
              ),

            ],
          ),
        ),
      ),
    );
  }
}