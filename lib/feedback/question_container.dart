import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';


class QuestionContainer extends StatefulWidget {
  final int questionNumber;
  final String question;
  final Function(String) onSelection;

  const QuestionContainer({
    Key? key,
    required this.questionNumber,
    required this.question,
    required this.onSelection,
  }) : super(key: key);

  @override
  _QuestionContainerState createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.question} ${widget.questionNumber}',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              widget.question,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildOptionContainer(
                  context,
                  l10n.agree,
                  Colors.green,
                  Colors.green.withOpacity(0.1),
                ),
                SizedBox(width: screenWidth * 0.04),
                _buildOptionContainer(
                  context,
                  l10n.disagree,
                  Colors.red,
                  Colors.red.withOpacity(0.1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionContainer(
      BuildContext context, String option, Color activeColor, Color bgColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isSelected = _selectedOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
        widget.onSelection(option);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                widget.onSelection(value!);
              },
              activeColor: activeColor,
              fillColor: isSelected
                  ? MaterialStateProperty.all(activeColor)
                  : MaterialStateProperty.all(Colors.grey),
            ),
            Text(
              option,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: isSelected ? activeColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}