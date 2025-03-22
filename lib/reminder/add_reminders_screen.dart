import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class AddReminders extends StatefulWidget {
  @override
  _AddRemindersState createState() => _AddRemindersState();
}

class _AddRemindersState extends State<AddReminders> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedDropdownValue; // NEW: For storing dropdown value
  bool _showDiabetesTestDate = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime() async {
    // Show the time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Set the initial time to the current time
    );

    // If the user selects a time, update the text field
    if (pickedTime != null) {
      setState(() {
        // Format the time as HH:mm
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        _timeController.text = '$hour:$minute';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0XFF5AA189),
        title: Text('Add Reminder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Widget
            DropdownWidget(
              onChanged: (value) {
                setState(() {
                  _selectedDropdownValue = value; // Save selected value here

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
                onPressed: _selectTime, // Open the time picker when the icon is clicked
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
            SizedBox(height: 24),

            // Set Reminder Button
            CustomButton(
              onTap: () {
                // Handle the "Set Reminder" button tap
                if (_timeController.text.isEmpty || _dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select both time and date')),
                  );
                } else {
                  // Add your logic to set the reminder
                  print('Reminder add for ${_dateController.text} at ${_timeController.text}');
                }
              },
              buttonText: 'Add Reminder',
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Dropdown Widget
class DropdownWidget extends StatefulWidget {
  final Function(String?) onChanged;
  final bool showDiabetesTestDate;
  final TextEditingController diabetesTestDateController;
  final List<String> items;
  final String label;

  const DropdownWidget({
    Key? key,
    required this.onChanged,
    required this.showDiabetesTestDate,
    required this.diabetesTestDateController,
    required this.items,
    required this.label,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Select Option',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: widget.items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedValue,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(value);
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
                color: const Color(0xFFF5F5F5),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
        if (widget.showDiabetesTestDate) ...[
          SizedBox(height: 16),
          CustomTextFormField(
            controller: widget.diabetesTestDateController,
            hintText: 'When was the diabetes test done?',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter test date' : null,
          ),
        ],
      ],
    );
  }
}

