import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/dropdown_widget.dart';
import 'all_reminders_screen.dart'; // Import the AllReminders screen

class AddReminders extends StatefulWidget {
  @override
  _AddRemindersState createState() => _AddRemindersState();
}

class _AddRemindersState extends State<AddReminders> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedDropdownValue;
  String _selectedFrequency = 'Everyday'; // Default frequency
  bool _showDiabetesTestDate = false;

  // Add a list of frequency options
  final List<String> _frequencyOptions = [
    'Everyday',
    'Weekdays',
    'Weekends',
    'Mon, Wed, Fri',
    'Tue, Thu',
    'Once',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100), // Allow future dates for reminders
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        _timeController.text = '$hour:$minute';
      });
    }
  }

  void _showFrequencyPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Select Frequency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _frequencyOptions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_frequencyOptions[index]),
                      onTap: () {
                        setState(() {
                          _selectedFrequency = _frequencyOptions[index];
                        });
                        Navigator.pop(context);
                      },
                      trailing: _selectedFrequency == _frequencyOptions[index]
                          ? Icon(Icons.check, color: Color(0XFF5AA189))
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0XFF5AA189),
        title: Text(
          'Add Reminder',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Widget
            DropdownWidget(
              onChanged: (value) {
                setState(() {
                  _selectedDropdownValue = value;
                });
              },
              showDiabetesTestDate: false,
              diabetesTestDateController: TextEditingController(),
              items: [
                'Glucose Reading',
                'Log Calories',
                'Weight Check',
                'Step Count',
                'GDM Facts'
              ],
              label: 'Select an option',
            ),
            SizedBox(height: 16),

            // Time Picker Text Field
            CustomTextFormField(
              controller: _timeController,
              hintText: 'Select time (HH:mm)',
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please select time' : null,
              suffixIcon: IconButton(
                icon: Icon(Icons.access_time),
                color: Color(0XFF5AA189),
                onPressed: _selectTime,
              ),
            ),
            SizedBox(height: 16),

            // Date Picker Text Field
            CustomTextFormField(
              controller: _dateController,
              hintText: 'Select date (yyyy-MM-dd)',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                color: Color(0XFF5AA189),
                onPressed: () => _selectDate(context),
              ),
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please select date' : null,
            ),
            SizedBox(height: 16),

            // Frequency Selector
            Text(
              'Repeat Frequency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _showFrequencyPicker,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  color: const Color(0xFFF5F5F5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedFrequency,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Set Reminder Button
            CustomButton(
              onTap: () {
                // Validate inputs
                if (_timeController.text.isEmpty ||
                    _dateController.text.isEmpty ||
                    _selectedDropdownValue == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                  return;
                }

                // Create a new reminder
                final newReminder = Reminder(
                  id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate unique ID
                  time: _timeController.text,
                  frequency: _selectedFrequency,
                  date: _dateController.text,
                  type: _selectedDropdownValue!,
                );

                // Navigate directly to AllReminders screen instead of going back
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllReminders(),
                  ),
                );

                // You might want to add the reminder to a database or state management solution here
                // For example, if using Provider:
                // Provider.of<ReminderProvider>(context, listen: false).addReminder(newReminder);
              },
              buttonText: 'Add Reminder',
            ),
          ],
        ),
      ),
    );
  }
}