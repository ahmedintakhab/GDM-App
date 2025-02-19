import 'package:flutter/material.dart';
import 'question_radio_widget.dart'; // Import the reusable widget

class PregnancyQuestionScreen2 extends StatefulWidget {
  const  PregnancyQuestionScreen2({Key? key}) : super(key: key);

  @override
  State< PregnancyQuestionScreen2> createState() => _PregnancyQuestionScreen2State();
}

class _PregnancyQuestionScreen2State extends State< PregnancyQuestionScreen2> {
  String? _q18Value; // For question 18
  String? _q19Value; // For question 19
  String? _q20Value; // For question 20

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Pregnancy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question 18
            QuestionRadioWidget(
              question: '18. Have you been diagnosed with hypertension during previous pregnancies?',
              selectedValue: _q18Value,
              onChanged: (value) {
                setState(() {
                  _q18Value = value;
                });
              },
            ),
            // Question 19
            QuestionRadioWidget(
              question: '19. Have you had a baby that weighed 4kg or more?',
              selectedValue: _q19Value,
              onChanged: (value) {
                setState(() {
                  _q19Value = value;
                });
              },
            ),
            // Question 20
            QuestionRadioWidget(
              question: '20. Have you had Caesarean Section (CS) before?',
              selectedValue: _q20Value,
              onChanged: (value) {
                setState(() {
                  _q20Value = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}