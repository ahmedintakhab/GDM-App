import 'package:flutter/material.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import 'package:gdm_app/Register/therapy_screen.dart';
import 'package:gdm_app/Register/weight_input_field.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
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
  final TextEditingController _genderController = TextEditingController(); // To store gender
  final TextEditingController _heightController = TextEditingController(); // To store height


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 1, totalSteps: 3),
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
                  // _buildGenderField(),
                  CustomTextFormField(
                    controller: _genderController,
                    hintText: 'Male or Female', validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },),
                  const SizedBox(height: 16),
                  // Weight Input
                  WeightInputField(),
                  // _buildWeightField(),
                  const SizedBox(height: 16),
                  // Age Input
                  CustomTextFormField(
                    controller: _ageController,
                    hintText: 'Enter your age', validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },),
                  const SizedBox(height: 16),
                  // Age Input
                  CustomTextFormField(
                    controller: _heightController,
                    hintText: 'Enter your height', validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },),
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


}