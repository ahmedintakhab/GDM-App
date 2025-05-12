import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:gdm_app/utils/utils.dart';

class PregnancyQuestionScreen1 extends StatefulWidget {
  final Map<String, dynamic> pregnancyData;
  final Set<String> selectedDiagnoses;
  const PregnancyQuestionScreen1({Key? key, required this.pregnancyData, required this.selectedDiagnoses}) : super(key: key);

  @override
  State<PregnancyQuestionScreen1> createState() => _PregnancyQuestionScreen1State();
}

class _PregnancyQuestionScreen1State extends State<PregnancyQuestionScreen1> {
  String? _q1Value; // For question 1
  String? _q2Value; // For question 2
  String? _q3Value; // For question 3
  String? _q4Value; // For question 4
  String? _q5Value; // For question 5
  String? _q6Value; // For question 6
  bool _isSubmitting = false; // To track if the form is being submitted
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitData() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      // Validate if all questions are answered
      // if (_q1Value == null || _q2Value == null || _q3Value == null || _q4Value == null || _q5Value == null || _q6Value == null) {
      //   Utils().toastMessage('Please answer all questions before submitting.');
      //   return;
      // }

      // Create user with email and password
      // UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      //   email: widget.pregnancyData['email'],
      //   password: widget.pregnancyData['password'],
      // );

      // Get current user
      User? user = _auth.currentUser;
      if (user == null) {
        Utils().toastMessage('No user is currently logged in');
        return;
      }


      // Combine all data from the three screens
      Map<String, dynamic> pregnancyInfo  = {
        ...widget.pregnancyData, // Data from PregnancyRegistrationScreen
        'selectedDiagnoses': widget.selectedDiagnoses.toList(), // Data from DiabetesTypeScreen
        'pregnancyQuestions': {
          'q1': _q1Value,
          'q2': _q2Value,
          'q3': _q3Value,
          'q4': _q4Value,
          'q5': _q5Value,
          'q6': _q6Value,
        },
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the combined data to Firestore
      await _firestore.collection('Users').doc(user.uid).
      collection('Personal Information').doc().set(pregnancyInfo );

      // Show success message
      Utils().toastMessage('Pregnancy information saved successfully!');

      // Navigate to the LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Handle other errors
      Utils().toastMessage('Error: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildDropdown(String question, String? value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Select Option',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: ['Yes', 'No']
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: value,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(
                  color: Colors.grey.shade400, // Border color
                  width: 1, // Border width
                ),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 3, totalSteps: 3),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: const Text(
                'Pregnancy Diagnosis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Expanded to make sure scroll works for dropdowns
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdown(
                      '1. Have you been diagnosed with GDM during this pregnancy?',
                      _q1Value,
                          (value) {
                        setState(() {
                          _q1Value = value;
                        });
                      },
                    ),
                    _buildDropdown(
                      '2. Have you been diagnosed with hypertension during this pregnancy?',
                      _q2Value,
                          (value) {
                        setState(() {
                          _q2Value = value;
                        });
                      },
                    ),
                    _buildDropdown(
                      '3. Have you been diagnosed with GDM during previous pregnancies?',
                      _q3Value,
                          (value) {
                        setState(() {
                          _q3Value = value;
                        });
                      },
                    ),
                    _buildDropdown(
                      '4. Have you been diagnosed with hypertension during previous pregnancies?',
                      _q4Value,
                          (value) {
                        setState(() {
                          _q4Value = value;
                        });
                      },
                    ),
                    _buildDropdown(
                      '5. Have you had a baby that weighed 4kg or more?',
                      _q5Value,
                          (value) {
                        setState(() {
                          _q5Value = value;
                        });
                      },
                    ),
                    _buildDropdown(
                      '6. Have you had Caesarean Section (CS) before?',
                      _q6Value,
                          (value) {
                        setState(() {
                          _q6Value = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Buttons outside the scroll view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Back',
                    ),
                  ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomButton(
                          onTap: _submitData,
                          buttonText: 'Submit',
                        ),
                        if (_isSubmitting)
                             SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 4,
                            ),
                          ),
                      ],
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