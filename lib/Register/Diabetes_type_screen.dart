import 'package:flutter/material.dart';
import 'package:gdm_app/Register/pregnancy_question_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'diagnosis_option.dart';
import 'package:gdm_app/utils/utils.dart';


class DiabetesTypeScreen extends StatefulWidget {
  final Map<String, dynamic> pregnancyData;
  const DiabetesTypeScreen({Key? key, required this.pregnancyData}) : super(key: key);

  @override
  State<DiabetesTypeScreen> createState() => _DiabetesTypeScreenState();
}

class _DiabetesTypeScreenState extends State<DiabetesTypeScreen> {
  // Diagnosis options
  final List<String> _diagnosisOptions = [
    'Diabetes (Type 2)',
    'Diabetes (Type 1)',
    'Prediabetes',
    'Hypertension',
    'Heart disease',
    'Obesity',
    'Lipid/ Cholesterol disorders',
    'Other', // Added "Other"
  ];

  final Set<String> _selectedDiagnoses = {};
  final TextEditingController _otherController = TextEditingController(); // Controller for Other
  bool isOtherSelected = false; // Track if Other is selected

  @override
  void dispose() {
    _otherController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }

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
                      // Diagnosis Options
                      ..._diagnosisOptions.map((option) {
                        return Column(
                          children: [
                            DiagnosisOption(
                              title: option,
                              isSelected: _selectedDiagnoses.contains(option),
                              onTap: () {
                                setState(() {
                                  if (_selectedDiagnoses.contains(option)) {
                                    _selectedDiagnoses.remove(option);
                                    if (option == 'Other') {
                                      isOtherSelected = false;
                                      _otherController.clear(); // Clear text if deselected
                                    }
                                  } else {
                                    _selectedDiagnoses.add(option);
                                    if (option == 'Other') {
                                      isOtherSelected = true;
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Show CustomTextFormField if "Other" selected
                            if (option == 'Other' && isOtherSelected)
                              CustomTextFormField(
                                controller: _otherController,
                                hintText: 'Please specify',
                                validator: (value) {
                                  if (isOtherSelected && (value == null || value.isEmpty)) {
                                    return 'Please enter diagnosis';
                                  }
                                  return null;
                                },
                              ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Row(
                children: [
                  // Back Button
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Back',
                    ),
                  ),
                  // Next Button
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (_selectedDiagnoses.isEmpty) {
                          Utils().toastMessage('Please select at least one option');

                        } else if (isOtherSelected && _otherController.text.isEmpty) {

                          // Validation for Other field
                          Utils().toastMessage('Please specify the "Other" diagnosis');

                        } else {
                          // Add custom input to selectedDiagnoses if provided
                          final Set<String> finalDiagnoses = {..._selectedDiagnoses};
                          if (isOtherSelected) {
                            finalDiagnoses.add(_otherController.text.trim());
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PregnancyQuestionScreen1(
                                pregnancyData: widget.pregnancyData,
                                selectedDiagnoses: finalDiagnoses,
                              ),
                            ),
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
