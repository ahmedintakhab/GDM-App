// screen_4.dart
import 'package:flutter/material.dart';
import 'package:gdm_app/Register/bloodsugar_goal_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';

import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';

class MeasurementUnitsScreen extends StatefulWidget {
  final ReminderService reminderService;
  const MeasurementUnitsScreen({Key? key,required this.reminderService}) : super(key: key);

  @override
  State<MeasurementUnitsScreen> createState() => _MeasurementUnitsScreenState();
}

class _MeasurementUnitsScreenState extends State<MeasurementUnitsScreen> {
  String? _selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 4, totalSteps: 6),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What measurement units do you use?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildUnitOption('mg/dl', _selectedType == 'mg/dl'),
                  const SizedBox(height: 16),
                  _buildUnitOption('mmol/l',_selectedType == 'mmol/l' ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                if (_selectedType == null) {
                  // Show a message if no option is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a unit')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BloodSugarGoalScreen(reminderService: widget.reminderService)),
                  );
                }
              },
              buttonText: 'Next',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitOption(String unit, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = unit; // Update the selected type
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F5E9) : Colors.transparent,
          border: Border.all(
            color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? const Color(0xFF4CAF50) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              unit,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
