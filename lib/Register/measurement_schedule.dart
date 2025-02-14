import 'package:flutter/material.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/progress_bar.dart';
import '../widgets/custom_button.dart';

class MeasurementScheduleScreen extends StatefulWidget {
  const MeasurementScheduleScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementScheduleScreen> createState() => _MeasurementScheduleScreenState();
}

class _MeasurementScheduleScreenState extends State<MeasurementScheduleScreen> {
  final List<TextEditingController> _reminderControllers = []; // To store reminder text controllers
  final List<FocusNode> _reminderFocusNodes = []; // To manage focus for each TextField

  @override
  void initState() {
    super.initState();
    // Add an initial empty reminder
    _addReminder();
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    for (var controller in _reminderControllers) {
      controller.dispose();
    }
    for (var focusNode in _reminderFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _addReminder() {
    // Add a new TextEditingController and FocusNode
    _reminderControllers.add(TextEditingController());
    _reminderFocusNodes.add(FocusNode());
    setState(() {});
  }

  void _removeReminder(int index) {
    // Remove the reminder at the specified index
    _reminderControllers.removeAt(index);
    _reminderFocusNodes.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressBar(currentStep: 6, totalSteps: 6),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'When do you measure glucose level?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We will remind you to take measurements at the same time to get accurate statistics',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildReminderList(),
                  const SizedBox(height: 24),
                  _buildAddReminderButton(),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              buttonText: 'Submit',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderList() {
    return Column(
      children: List.generate(_reminderControllers.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildReminderItem(index),
        );
      }),
    );
  }

  Widget _buildReminderItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: _reminderFocusNodes[index].hasFocus ? const Color(0xFF4CAF50) : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _reminderControllers[index],
              focusNode: _reminderFocusNodes[index],
              decoration: const InputDecoration(
                hintText: 'Enter time (e.g., 9:00 AM)',
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              _removeReminder(index); // Remove the reminder
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddReminderButton() {
    return GestureDetector(
      onTap: _addReminder, // Add a new reminder
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4CAF50)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(width: 8),
            Text(
              'Add a reminder',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}