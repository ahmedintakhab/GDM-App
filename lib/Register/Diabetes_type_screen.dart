import 'package:flutter/material.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import 'package:gdm_app/Register/therapy_screen.dart';
import '../widgets/custom_button.dart';

class DiabetesTypeScreen extends StatefulWidget {
  const DiabetesTypeScreen({Key? key}) : super(key: key);

  @override
  State<DiabetesTypeScreen> createState() => _DiabetesTypeScreenState();
}

class _DiabetesTypeScreenState extends State<DiabetesTypeScreen> {
  String? _selectedType; // To store the selected diabetes type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 2, totalSteps: 6),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What diabetes type do you have?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildTypeOption('Type 1', _selectedType == 'Type 1'),
                  const SizedBox(height: 16),
                  _buildTypeOption('Type 2', _selectedType == 'Type 2'),
                  const SizedBox(height: 16),
                  _buildTypeOption('Gestational', _selectedType == 'Gestational'),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                if (_selectedType == null) {
                  // Show a message if no option is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a diabetes type')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TherapyScreen()),
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

  // Build a selectable diabetes type option
  Widget _buildTypeOption(String type, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type; // Update the selected type
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
              type,
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