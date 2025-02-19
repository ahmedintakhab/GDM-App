import 'package:flutter/material.dart';
import 'package:gdm_app/Register/pregnancy_question_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import '../widgets/custom_button.dart';
import 'diagnosis_option.dart'; // Import the reusable widget

class DiabetesTypeScreen extends StatefulWidget {
  const DiabetesTypeScreen({Key? key}) : super(key: key);

  @override
  State<DiabetesTypeScreen> createState() => _DiabetesTypeScreenState();
}

class _DiabetesTypeScreenState extends State<DiabetesTypeScreen> {
  // List of all diagnosis options
  final List<String> _diagnosisOptions = [
    'Diabetes (Type 2)',
    'Diabetes (Type 1)',
    'Prediabetes',
    'Hypertension',
    'Heart disease',
    'Obesity',
    'Lipid/ Cholesterol disorders',
  ];

  // Set to store selected diagnoses
  final Set<String> _selectedDiagnoses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 2, totalSteps: 3),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Outside pregnancy, I have been diagnosed with',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Display all diagnosis options
                      ..._diagnosisOptions.map((option) {
                        return Column(
                          children: [
                            DiagnosisOption(
                              title: option,
                              isSelected: _selectedDiagnoses.contains(option),
                              onTap: () {
                                setState(() {
                                  if (_selectedDiagnoses.contains(option)) {
                                    _selectedDiagnoses.remove(option); // Deselect
                                  } else {
                                    _selectedDiagnoses.add(option); // Select
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            // Back and Next Buttons in a Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Row(
                children: [
                  // Back Button
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        // Navigate back
                        Navigator.pop(context);
                      },
                      buttonText: 'Back',
                      // backgroundColor: Colors.grey, // Custom color for Back button
                    ),
                  ),
                  // const SizedBox(width: 6), // Spacing between buttons
                  // Next Button
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (_selectedDiagnoses.isEmpty) {
                          // Show a message if no option is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select at least one option')),
                          );
                        } else {
                          // Navigate to the next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PregnancyQuestionScreen1()),
                          );
                        }
                      },
                      buttonText: 'Next',
                    ),
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