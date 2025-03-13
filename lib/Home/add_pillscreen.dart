import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_text_form_field.dart';

class AddPillScreen extends StatefulWidget {
  const AddPillScreen({Key? key}) : super(key: key);

  @override
  State<AddPillScreen> createState() => _AddPillScreenState();
}

class _AddPillScreenState extends State<AddPillScreen> {
  final TextEditingController _pillController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int pillCount = 1;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false; // Track loading state

  @override
  void dispose() {
    _pillController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  // Function to save pills data to Firestore
  Future<void> _savePillsData() async {
    if (_pillController.text.isEmpty || _dateController.text.isEmpty || _timeController.text.isEmpty) {
      Utils().toastMessage('Please fill all fields');
      return;
    }
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
        // Parse the date and time from the controllers
        final date = _dateController.text;
        final time = _timeController.text;

        // Combine date and time into a single DateTime object
        final dateTime = DateFormat('yyyy-MM-dd HH:mm').parse('$date $time');

        // Prepare the glucose data
        final pillsData = {
          'dateTime': Timestamp.fromDate(dateTime), // Save as Timestamp
          'pill': _pillController.text,
          'pills_quantity': pillCount
        };

        // Add the pills data to the user's document
        await _firestore
            .collection(userDoc.reference.parent.id) // Use the correct collection
            .doc(uid)
            .collection('PillsEntries') // Subcollection for pills entries
            .add(pillsData);

        // Show success toast message
        Utils().toastMessage('Successfully added pills data!');

        // Navigate to the GlucoseDetailsScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        Utils().toastMessage('User not found in any collection!');
      }
    } catch (e) {
      // Handle errors
      Utils().toastMessage('Error: $e');
      print('error:$e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  Future<void> _selectTime() async {
    // Show the time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Set the initial time to the current time
    );

    // If the user selects a time, update the text field
    if (pickedTime != null) {
      setState(() {
        // Format the time as HH:mm
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        _timeController.text = '$hour:$minute';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pills',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 34),
              CustomTextFormField(
                controller: _timeController,
                hintText: 'Select time (HH:mm)',
                validator: (value) => value?.isEmpty ?? true ? 'Please select time' : null,
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time,),
                  color: Color(0XFF5AA189),
                  onPressed: _selectTime, // Open the time picker when the icon is clicked
                ),
              ),
            
                SizedBox(height: 16),
                CustomTextFormField(
                  controller: _dateController,
                  hintText: 'Select date (yyyy-MM-dd)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    color: Color(0XFF5AA189),
                    onPressed: () => _selectDate(context),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Please select date' : null,
                ),
            
                SizedBox(height: 16),
            
                // Pill Search Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pill name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _pillController,
                        hintText: 'E.g.: Metronidazol',
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter pill' : null,
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 16),
            
                // Pill Count Selector
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (pillCount > 1) {
                            setState(() {
                              pillCount--;
                            });
                          }
                        },
                        color: Color(0XFF5AA189),
                      ),
                      Text(
                        '$pillCount pill${pillCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {
                          setState(() {
                            pillCount++;
                          });
                        },
                        color: Color(0XFF5AA189),
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 16),
            
                // Save Button with Circular Progress Indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomButton(
                      onTap: _savePillsData, // Call _savePillsData on button tap
                      buttonText: _isLoading ? '' : 'Save', // Hide text when loading
                    ),
                    if (_isLoading)
                      Positioned(
                        child: CircularProgressIndicator(
                          color: Colors.white, // White color for the indicator
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}