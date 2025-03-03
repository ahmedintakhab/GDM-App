import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:gdm_app/utils/utils.dart';
import 'question_radio_widget.dart'; // Import the reusable widget

class PregnancyQuestionScreen1 extends StatefulWidget {
  final Map<String, dynamic> pregnancyData;
  final Set<String> selectedDiagnoses;
  const PregnancyQuestionScreen1({Key? key, required this.pregnancyData,
  required this.selectedDiagnoses}) : super(key: key);

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitData() async {
    try {
      // Validate if all questions are answered
      if (_q1Value == null || _q2Value == null || _q3Value == null || _q4Value == null || _q5Value == null || _q6Value == null) {
        Utils().toastMessage('Please answer all questions before submitting.');
        return;
      }

      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: widget.pregnancyData['email'],
        password: widget.pregnancyData['password'],
      );

      // Combine all data from the three screens
      Map<String, dynamic> userData = {
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
      };

      // Save the combined data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set(userData);

      // Show success message
      Utils().toastMessage('User successfully registered!');

      // Navigate to the LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      Utils().toastMessage('Error: ${e.message}');
    } catch (e) {
      // Handle other errors
      Utils().toastMessage('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('Check first: ${widget.pregnancyData}');
    // print('Check second: ${widget.selectedDiagnoses}');
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionRadioWidget(
                        question: '1. Have you been diagnosed with GDM during this pregnancy?',
                        selectedValue: _q1Value,
                        onChanged: (value) {
                          setState(() {
                            _q1Value = value;
                          });
                        },
                      ),
                      QuestionRadioWidget(
                        question: '2. Have you been diagnosed with hypertension during this pregnancy?',
                        selectedValue: _q2Value,
                        onChanged: (value) {
                          setState(() {
                            _q2Value = value;
                          });
                        },
                      ),
                      QuestionRadioWidget(
                        question: '3. Have you been diagnosed with GDM during previous pregnancies?',
                        selectedValue: _q3Value,
                        onChanged: (value) {
                          setState(() {
                            _q3Value = value;
                          });
                        },
                      ),
                      QuestionRadioWidget(
                        question: '4. Have you been diagnosed with hypertension during previous pregnancies?',
                        selectedValue: _q4Value,
                        onChanged: (value) {
                          setState(() {
                            _q4Value = value;
                          });
                        },
                      ),
                      QuestionRadioWidget(
                        question: '5. Have you had a baby that weighed 4kg or more?',
                        selectedValue: _q5Value,
                        onChanged: (value) {
                          setState(() {
                            _q5Value = value;
                          });
                        },
                      ),
                      QuestionRadioWidget(
                        question: '6. Have you had Caesarean Section (CS) before?',
                        selectedValue: _q6Value,
                        onChanged: (value) {
                          setState(() {
                            _q6Value = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(onTap: _submitData,
                buttonText: 'Submit'),
            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}
