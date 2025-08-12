// question_radio_widget.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';


class QuestionRadioWidget extends StatelessWidget {
  final String question;
  final String? selectedValue;
  final Function(String?) onChanged;

  const QuestionRadioWidget({
    Key? key,
    required this.question,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Yes Radio Button
            _buildRadioButton(l10n.yes, selectedValue == l10n.yes),
            const SizedBox(width: 20),
            // No Radio Button
            _buildRadioButton(l10n.no, selectedValue == l10n.no),
          ],
        ),
        const SizedBox(height: 20), // Spacing between questions
      ],
    );
  }

  // Helper method to build a decorated radio button
  Widget _buildRadioButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onChanged(label); // Update the selected value
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}