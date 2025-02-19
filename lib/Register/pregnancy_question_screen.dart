import 'package:flutter/material.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'question_radio_widget.dart'; // Import the reusable widget

class PregnancyQuestionScreen1 extends StatefulWidget {
  const PregnancyQuestionScreen1({Key? key}) : super(key: key);

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
            CustomButton(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            }, buttonText: 'Submit'),
            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}
