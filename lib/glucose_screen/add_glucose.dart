import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Home/user_data_provider.dart';
import '../widgets/time_picker.dart';
import 'meal_selection_widget.dart'; // Import your UserProvider

class AddGlucoseScreen extends StatefulWidget {
  const AddGlucoseScreen({Key? key}) : super(key: key);

  @override
  State<AddGlucoseScreen> createState() => _AddGlucoseScreenState();
}

class _AddGlucoseScreenState extends State<AddGlucoseScreen> {
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedMealOption = 'Before Breakfast';
  bool _isLoading = false; // Track loading state
  String? _selectedUnit;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    // Initialize _selectedUnit after context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedUnit = AppLocalizations.of(context)!.mgDlUnit;
        _selectedMealOption = AppLocalizations.of(context)!.beforeBreakfast;
      });
    });
  }

  @override
  void dispose() {
    _glucoseController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Function to save glucose data to Firestore
  Future<void> _saveGlucoseData() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Get the current user's UID
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        Utils().toastMessage(l10n.noUserLoggedIn);
        return;
      }

      // Check in which collection the user exists
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        // Parse the date and time from the controllers
        final date = _dateController.text;
        final time = _timeController.text;

        // Parse and validate glucose value
        final glucoseValue = double.tryParse(_glucoseController.text);
        if (glucoseValue == null) {
          Utils().toastMessage(l10n.invalidGlucoseValue);
          setState(() {
            _isLoading = false;
          });
          return;
        }
        // Combine glucose value and unit
        final glucoseWithUnit = '${glucoseValue.toStringAsFixed(2)} $_selectedUnit';
        print('Check new glucose:$glucoseWithUnit');

        // Combine date and time into a single DateTime object
        final dateTime = DateFormat('yyyy-MM-dd HH:mm').parse('$date $time');

        // Prepare the glucose data
        final glucoseData = {
          'dateTime': Timestamp.fromDate(dateTime), // Save as Timestamp
          'glucoseLevel': glucoseWithUnit,
          'glucoseValue': glucoseValue, // Store raw value for easier fetching
          'mealOption': _selectedMealOption,
        };

        // Add the glucose data to the user's document in the 'glucoseEntries' subcollection
        await _firestore
            .collection('Users') // Use the correct collection
            .doc(uid)
            .collection('glucoseEntries') // Subcollection for glucose entries
            .add(glucoseData);

        // Show success toast message
        Utils().toastMessage(l10n.glucoseDataAdded);

        // Fetch updated glucose data in the UserProvider after the current frame
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await userProvider.fetchGlucoseData();
        });


        // Navigate back to the previous screen
        Navigator.pop(context);
      } else {
        Utils().toastMessage(l10n.userNotFound);
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

// Updated method to use TimePicker
  Future<void> _selectTime() async {
    await showTimePickerDialog(
      context,
          (selectedTime) {
        setState(() {
          _timeController.text = selectedTime;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          l10n.glucose,
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
              SizedBox(height: 16),
              CustomTextFormField(
                controller: _timeController,
                hintText: l10n.selectTimeHint,
                validator: (value) => value?.isEmpty ?? true ? l10n.pleaseSelectTime : null,
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time,),
                  color: Color(0XFF5AA189),
                  onPressed: _selectTime, // Open the time picker when the icon is clicked
                ),
              ),

              SizedBox(height: 16),
              CustomTextFormField(
                controller: _dateController,
                hintText: l10n.selectDateHint,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Color(0XFF5AA189),
                  onPressed: () => _selectDate(context),
                ),
                validator: (value) => value?.isEmpty ?? true ? l10n.pleaseSelectDate : null,
              ),

              const SizedBox(height: 16),

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
                     Text(
                      l10n.glucoseLevel,
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
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration:  InputDecoration(
                                hintText: l10n.valueHint,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              value: _selectedUnit,
                              items: [l10n.mgDlUnit, l10n.mmolLUnit].map((String unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(
                                    unit,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedUnit = newValue;
                                  });
                                }
                              },
                              underline: SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Meal Selection Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:  Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MealSelection(
                          onTap: () {
                            setState(() {
                              _selectedMealOption = l10n.beforeBreakfast;
                            });
                          },
                          icon: Icons.free_breakfast,
                          label: l10n.beforeBreakfast,
                          selectedMealOption: _selectedMealOption,
                        ),
                        const SizedBox(width: 10),
                        MealSelection(
                          onTap: () {
                            setState(() {
                              _selectedMealOption = l10n.afterBreakfast;
                            });
                          },
                          icon: Icons.restaurant,
                          label: l10n.afterBreakfast,
                          selectedMealOption: _selectedMealOption,
                        ),
                      ],
                       ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          MealSelection(
                            onTap: () {
                              setState(() {
                                _selectedMealOption = l10n.beforeLunch;
                              });
                            },
                            icon: Icons.lunch_dining,
                            label: l10n.beforeLunch,
                            selectedMealOption: _selectedMealOption,
                          ),
                          const SizedBox(width: 10),
                          MealSelection(
                            onTap: () {
                              setState(() {
                                _selectedMealOption = l10n.afterLunch;
                              });
                            },
                            icon: Icons.restaurant,
                            label: l10n.afterLunch,
                            selectedMealOption: _selectedMealOption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          MealSelection(
                            onTap: () {
                              setState(() {
                                _selectedMealOption = l10n.beforeDinner;
                              });
                            },
                            icon: Icons.dinner_dining,
                            label: l10n.beforeDinner,
                            selectedMealOption: _selectedMealOption,
                          ),
                          const SizedBox(width: 10),
                          MealSelection(
                            onTap: () {
                              setState(() {
                                _selectedMealOption = l10n.afterDinner;
                              });
                            },
                            icon: Icons.restaurant,
                            label: l10n.afterDinner,
                            selectedMealOption: _selectedMealOption,
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomButton(
                    onTap: _saveGlucoseData, // Call _savePillsData on button tap
                    buttonText: _isLoading ? '' : l10n.save, // Hide text when loading
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
    );
  }
}