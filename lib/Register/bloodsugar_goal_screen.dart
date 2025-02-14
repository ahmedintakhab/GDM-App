import 'package:flutter/material.dart';
import 'package:gdm_app/Register/measurement_schedule.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import '../widgets/custom_button.dart';

class BloodSugarGoalScreen extends StatefulWidget {
  const BloodSugarGoalScreen({Key? key}) : super(key: key);

  @override
  State<BloodSugarGoalScreen> createState() => _BloodSugarGoalScreenState();
}

class _BloodSugarGoalScreenState extends State<BloodSugarGoalScreen> {
  final TextEditingController _lowestValueController = TextEditingController(); // For lowest value
  final TextEditingController _highestValueController = TextEditingController(); // For highest value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 5, totalSteps: 6),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Your blood sugar goal ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'before',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      Text(
                        ' meal',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildValueInput('Lowest Value', _lowestValueController),
                  const SizedBox(height: 16),
                  _buildValueInput('Highest Value', _highestValueController),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {
                // Validate inputs
                if (_lowestValueController.text.isEmpty || _highestValueController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter both lowest and highest values')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MeasurementScheduleScreen()),
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

  // Build a TextField for value input
  Widget _buildValueInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number, // Allow only numeric input
                  decoration: const InputDecoration(
                    hintText: '0', // Hint text
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.zero, // Reduce internal padding
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Text(
                'mg/dl',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}