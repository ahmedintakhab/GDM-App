import 'package:flutter/material.dart';
import 'package:gdm_app/Register/pregnancy_question_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'diagnosis_option.dart';
import 'package:gdm_app/utils/utils.dart';
import '../l10n/app_localizations.dart';


class DiabetesTypeScreen extends StatefulWidget {
  final Map<String, dynamic> pregnancyData;
  final ReminderService reminderService;

  const DiabetesTypeScreen({Key? key, required this.pregnancyData, required this.reminderService}) : super(key: key);

  @override
  State<DiabetesTypeScreen> createState() => _DiabetesTypeScreenState();
}

class _DiabetesTypeScreenState extends State<DiabetesTypeScreen> {
  // Diagnosis options
  List<String> _getDiagnosisOptions(AppLocalizations l10n) => [
     l10n.diagnosisType2Diabetes,
     l10n.diagnosisType1Diabetes,
     l10n.diagnosisPrediabetes,
     l10n.diagnosisHypertension,
     l10n.diagnosisHeartDisease,
     l10n.diagnosisObesity,
     l10n.diagnosisLipidDisorders,
     l10n.diagnosisOther,
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
    final l10n = AppLocalizations.of(context)!;
    final diagnosisOptions = _getDiagnosisOptions(l10n);
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
                       Text(
                        l10n.outsidePregnancyDiagnosis,
                         style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Diagnosis Options
                      ...diagnosisOptions.map((option) {
                        return Column(
                          children: [
                            DiagnosisOption(
                              title: option,
                              isSelected: _selectedDiagnoses.contains(option),
                              onTap: () {
                                setState(() {
                                  if (_selectedDiagnoses.contains(option)) {
                                    _selectedDiagnoses.remove(option);
                                    if (option == l10n.diagnosisOther) {
                                      isOtherSelected = false;
                                      _otherController.clear(); // Clear text if deselected
                                    }
                                  } else {
                                    _selectedDiagnoses.add(option);
                                    if (option == l10n.diagnosisOther) {
                                      isOtherSelected = true;
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Show CustomTextFormField if "Other" selected
                            if (option == l10n.diagnosisOther && isOtherSelected)
                              CustomTextFormField(
                                controller: _otherController,
                                hintText: l10n.pleaseSpecify,
                                validator: (value) {
                                  if (isOtherSelected && (value == null || value.isEmpty)) {
                                    return l10n.pleaseEnterDiagnosis;
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
                      buttonText: l10n.back,
                    ),
                  ),
                  // Next Button
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (_selectedDiagnoses.isEmpty) {
                          Utils().toastMessage(l10n.pleaseSelectAtLeastOneOption);
                        } else if (isOtherSelected && _otherController.text.isEmpty) {

                          // Validation for Other field
                          Utils().toastMessage(l10n.pleaseSpecifyOtherDiagnosis);
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
                                selectedDiagnoses: finalDiagnoses,reminderService: widget.reminderService
                              ),
                            ),
                          );
                        }
                      },
                      buttonText: l10n.next,
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
