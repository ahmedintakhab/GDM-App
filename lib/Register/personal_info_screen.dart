import 'package:flutter/material.dart';
import 'package:gdm_app/Register/Diabetes_type_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import '../widgets/custom_button.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  String? _selectedGender; // To store selected gender
  final TextEditingController _weightController = TextEditingController(); // To store weight
  final TextEditingController _ageController = TextEditingController(); // To store age

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 1, totalSteps: 6),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tell us about yourself',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your individual parameters are important for\nthe in-depth personalization.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Gender Selection
                  _buildGenderField(),
                  const SizedBox(height: 16),
                  // Weight Input
                  _buildWeightField(),
                  const SizedBox(height: 16),
                  // Age Input
                  _buildAgeField(),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                // Validate inputs before navigating
                if (_selectedGender == null || _weightController.text.isEmpty || _ageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiabetesTypeScreen()),
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

  // Gender Selection Widget
  Widget _buildGenderField() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedGender,
              hint: const Text('Select your gender'),
              isExpanded: true,
              underline: const SizedBox(), // Remove the default underline
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Weight Input Widget
  Widget _buildWeightField() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.monitor_weight, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter your weight (kg)',
                border: InputBorder.none, // Remove the default border
                // contentPadding: EdgeInsets.zero, // Reduce internal padding
              ),
              style: const TextStyle(fontSize: 16), // Adjust text size
            ),
          ),
        ],
      ),
    );
  }

  // Age Input Widget
  Widget _buildAgeField() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.pink),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter your age',
                border: InputBorder.none, // Remove the default border
                contentPadding: EdgeInsets.zero, // Reduce internal padding
              ),
              style: const TextStyle(fontSize: 16), // Adjust text size
            ),
          ),
        ],
      ),
    );
  }
}