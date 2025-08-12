import 'package:flutter/material.dart';
import 'package:gdm_app/feedback/success_dialog.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_button.dart';
import 'question_container.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> questions = [
    {
      'heading': 'impact',
      'questions': [
        'feedbackQ1',
        'feedbackQ2',
        'feedbackQ3',
      ],
    },
    {
      'heading': 'perceivedUsefulness',
      'questions': [
        'feedbackQ4',
        'feedbackQ5',
        'feedbackQ6',
        'feedbackQ7',
        'feedbackQ8',
        'feedbackQ9',
        'feedbackQ10',
        'feedbackQ11',
        'feedbackQ12',
      ],
    },
    {
      'heading': 'perceivedEaseOfUse',
      'questions': [
        'feedbackQ13',
        'feedbackQ14',
        'feedbackQ15',
        'feedbackQ16',
        'feedbackQ17',
      ],
    },
    {
      'heading': 'userControl',
      'questions': [
        'feedbackQ18',
        'feedbackQ19',
        'feedbackQ20',
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
  // Helper method to map ARB keys to AppLocalizations properties
  String _getLocalizedString(AppLocalizations l10n, String key) {
    switch (key) {
      case 'impact':
        return l10n.impact;
      case 'perceivedUsefulness':
        return l10n.perceivedUsefulness;
      case 'perceivedEaseOfUse':
        return l10n.perceivedEaseOfUse;
      case 'userControl':
        return l10n.userControl;
      case 'feedbackQ1':
        return l10n.feedbackQ1;
      case 'feedbackQ2':
        return l10n.feedbackQ2;
      case 'feedbackQ3':
        return l10n.feedbackQ3;
      case 'feedbackQ4':
        return l10n.feedbackQ4;
      case 'feedbackQ5':
        return l10n.feedbackQ5;
      case 'feedbackQ6':
        return l10n.feedbackQ6;
      case 'feedbackQ7':
        return l10n.feedbackQ7;
      case 'feedbackQ8':
        return l10n.feedbackQ8;
      case 'feedbackQ9':
        return l10n.feedbackQ9;
      case 'feedbackQ10':
        return l10n.feedbackQ10;
      case 'feedbackQ11':
        return l10n.feedbackQ11;
      case 'feedbackQ12':
        return l10n.feedbackQ12;
      case 'feedbackQ13':
        return l10n.feedbackQ13;
      case 'feedbackQ14':
        return l10n.feedbackQ14;
      case 'feedbackQ15':
        return l10n.feedbackQ15;
      case 'feedbackQ16':
        return l10n.feedbackQ16;
      case 'feedbackQ17':
        return l10n.feedbackQ17;
      case 'feedbackQ18':
        return l10n.feedbackQ18;
      case 'feedbackQ19':
        return l10n.feedbackQ19;
      case 'feedbackQ20':
        return l10n.feedbackQ20;
      default:
        return key; // Fallback to the key itself if not found
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          l10n.feedbackSurvey,
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
                buttonText: l10n.submitFeedback,
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
    final l10n = AppLocalizations.of(context)!;
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
            _getLocalizedString(l10n, section['heading'] as String),
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5AA189),
            ),
          ),
        ),
      );

      // Add questions under the heading
      for (var questionKey in section['questions']) {
        widgets.add(
          QuestionContainer(
            questionNumber: questionNumber,
            question: _getLocalizedString(l10n, questionKey as String),
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