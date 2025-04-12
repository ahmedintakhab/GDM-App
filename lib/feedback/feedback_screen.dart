import 'package:flutter/material.dart';
import 'package:gdm_app/feedback/success_dialog.dart';
import '../widgets/custom_button.dart';
import 'question_container.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> questions = [
    {
      'heading': 'Impact',
      'questions': [
        'I think the App would be a positive addition for UAE population/ pregnant women/ Physicians.',
        'I think this App would improve the Quality of Life of GDM patients.',
        'This App is an important part of meeting my information needs related to GDM.',
      ],
    },
    {
      'heading': 'Perceived Usefulness',
      'questions': [
        'Using this App makes it easier to get info on GDM.',
        'Using this App enables me to self-assess my GDM risk.',
        'Using this App makes it more likely that I get screened for GDM on time.',
        'I am satisfied with this App for gaining GDM knowledge.',
        'I am satisfied with this App for self-management of GDM or GDM risk factors.',
        'Using this App increases my ability to monitor my dietary intake.',
        'Using this App increases my ability to maintain physical activity.',
        'I am able to do self-monitoring of blood sugar using this App.',
        'As a physician I find the App’s info on GDM Screening and Diagnosis useful.',
      ],
    },
    {
      'heading': 'Perceived Ease of Use',
      'questions': [
        'I am comfortable with my ability to use this App.',
        'Learning to operate this App is easy for me.',
        'It is easy for me to become skillful at using this App.',
        'I find this App easy to use.',
        'I can always remember how to log on to and use this App.',
      ],
    },
    {
      'heading': 'User Control',
      'questions': [
        'The app rarely crashes or causes problems on my phone.',
        'Whenever I make a mistake using this App, I recover easily and quickly.',
        'The information (such as on-line help, on-screen messages and other documentation) provided with this App is clear.',
      ],
    },
  ];

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          onContinue: () {
            Navigator.of(context).pop(); // Close the dialog
            // Add navigation or other actions after clicking "Continue"
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback Survey',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF5AA189),
      ),
      body: Stack(
        children: [
          // Scrollable content (questions)
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildQuestionWidgets(context),
                  SizedBox(height: screenHeight * 0.1), // Extra padding to avoid overlap
                ],
              ),
            ),
          ),
          // Fixed Submit Feedback button at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
              ),
              color: Colors.white, // Background color to match the scaffold
              child: CustomButton(
                onTap: () {
                  _showSuccessDialog(context);
                },
                buttonText: 'Submit Feedback',
                buttonColor: const Color(0xFF5AA189),
                textColor: Colors.white,
                borderRadius: 8,
                loading: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionWidgets(BuildContext context) {
    List<Widget> widgets = [];
    int questionNumber = 1;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    for (var section in questions) {
      // Add heading
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          child: Text(
            section['heading'],
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5AA189),
            ),
          ),
        ),
      );

      // Add questions under the heading
      for (var question in section['questions']) {
        widgets.add(
          QuestionContainer(
            questionNumber: questionNumber,
            question: question,
            onSelection: (value) {
              // Handle selection (e.g., store response)
              print('Question $questionNumber: $value');
            },
          ),
        );
        questionNumber++;
      }
    }

    return widgets;
  }
}