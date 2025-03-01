import 'package:flutter/material.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/pregnancy_register_screen.dart';
import 'package:gdm_app/Register/without_pregnancy_signup.dart';

void main() {
  runApp(MaterialApp(
    home: SelectionScreen(),
  ));
}

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? _selectedOption; // To store the selected option

  // Function to handle navigation based on the selected option
  void _navigateToNextScreen() {
    if (_selectedOption == null) {
      // Show an error if no option is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option')),
      );
      return;
    }

    // Navigate to the respective screen based on the selected option
    switch (_selectedOption) {
      case 'Pregnant':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PregnancyRegistrationScreen()),
        );
        break;
      case 'Not Pregnant':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WithoutPregnancySignup()),
        );
        break;
      case 'Doctor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please Select One'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold Text "I am"
            const Text(
              'I am',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Custom Radio Button Box for "I am pregnant"
            _buildRadioButtonBox('Pregnant'),
            const SizedBox(height: 16),
            // Custom Radio Button Box for "I am not pregnant"
            _buildRadioButtonBox('Not Pregnant'),
            const SizedBox(height: 16),
            // Custom Radio Button Box for "I am a doctor"
            _buildRadioButtonBox('Doctor'),
            const SizedBox(height: 30),
            // Show Next Button only if a radio button is selected
            if (_selectedOption != null)
              Center(
                child: ElevatedButton(
                  onPressed: _navigateToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF5AA189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a custom radio button box
  Widget _buildRadioButtonBox(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option; // Update the selected option
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedOption == option ? const Color(0xFFE8F5E9) : Colors.transparent,
          border: Border.all(
            color: _selectedOption == option ? const Color(0xFF4CAF50) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _selectedOption == option ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: _selectedOption == option ? const Color(0xFF4CAF50) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: _selectedOption == option ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}