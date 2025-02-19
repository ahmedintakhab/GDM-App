import 'package:flutter/material.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Register/weight_input_field.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';

class WithoutPregnancySignup extends StatefulWidget {
  const WithoutPregnancySignup({Key? key}) : super(key: key);

  @override
  State<WithoutPregnancySignup> createState() => _WithoutPregnancySignupState();
}

class _WithoutPregnancySignupState extends State<WithoutPregnancySignup> {
  final TextEditingController _weightController = TextEditingController(); // To store weight
  final TextEditingController _ageController = TextEditingController(); // To store age
  final TextEditingController _genderController = TextEditingController(); // To store gender
  final TextEditingController _heightController = TextEditingController(); // To store height
  final TextEditingController _ethnicityController = TextEditingController(); // To store height
  final TextEditingController _diabetesController = TextEditingController(); // To store height
  final TextEditingController _waistController = TextEditingController(); // To store height
  final TextEditingController _hypertensionController = TextEditingController(); // To store height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Text Widgets
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tell us about yourself',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your individual parameters are important for\nthe in-depth personalization.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender Selection
                    CustomTextFormField(
                      controller: _genderController,
                      hintText: 'Male or Female',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Weight Input
                    WeightInputField(),
                    const SizedBox(height: 16),
                    // Age Input
                    CustomTextFormField(
                      controller: _ageController,
                      hintText: 'Enter your age',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Height Input
                    CustomTextFormField(
                      controller: _heightController,
                      hintText: 'Enter your height',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your height';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Ethnicity
                    CustomTextFormField(
                      controller: _ethnicityController,
                      hintText: 'Enter your Ethnicity',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Ethnicity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Diabetes
                    CustomTextFormField(
                      controller: _diabetesController,
                      hintText: 'Enter your Diabetes',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your diabetes';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Waist field
                    CustomTextFormField(
                      controller: _waistController,
                      hintText: 'Enter your waist',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your waist';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Hypertension
                    CustomTextFormField(
                      controller: _hypertensionController,
                      hintText: 'History of hypertension',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your hypertension';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Next Button
            CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
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