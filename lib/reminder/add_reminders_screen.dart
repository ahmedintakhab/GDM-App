import 'package:flutter/material.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/dropdown_widget.dart';
import 'all_reminders_screen.dart';
import 'dart:math';
import 'package:gdm_app/utils/utils.dart';


class AddReminders extends StatefulWidget {
  final ReminderService reminderService;

  AddReminders({required this.reminderService});

  @override
  _AddRemindersState createState() => _AddRemindersState();
}

class _AddRemindersState extends State<AddReminders> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedDropdownValue;
  String _selectedFrequency = '';
  bool _showDatePicker = false;
  List<bool> _selectedDays = List<bool>.filled(7, false);
  bool _isLoading = false;
  bool _reminderAddedSuccessfully = false;
  bool _showCustomFrequencySection = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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

  void _toggleDay(int index) {
    setState(() {
      _selectedDays[index] = !_selectedDays[index];
      _updateFrequency();
    });
  }

  void _updateFrequency() {
    final selectedDayCount = _selectedDays.where((day) => day).length;
    final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final selectedDaysList = days.asMap().entries
        .where((entry) => _selectedDays[entry.key])
        .map((entry) => entry.value)
        .toList();

    if (selectedDayCount == 0) {
      _selectedFrequency = 'Custom';
    } else if (selectedDayCount == 7) {
      _selectedFrequency = 'Everyday';
    } else {
      // Check for consecutive days from Monday to Friday (weekdays)
      bool isWeekdays = _selectedDays[1] && _selectedDays[2] && _selectedDays[3] &&
          _selectedDays[4] && !_selectedDays[0] && !_selectedDays[5] && !_selectedDays[6];

      if (isWeekdays) {
        _selectedFrequency = 'Mon to Fri';
      } else {
        // Check for other consecutive patterns
        List<int> selectedIndices = [];
        for (int i = 0; i < _selectedDays.length; i++) {
          if (_selectedDays[i]) selectedIndices.add(i);
        }

        bool isConsecutive = true;
        if (selectedIndices.length > 1) {
          for (int i = 0; i < selectedIndices.length - 1; i++) {
            if (selectedIndices[i + 1] != selectedIndices[i] + 1) {
              isConsecutive = false;
              break;
            }
          }
        }

        if (isConsecutive && selectedIndices.length > 1) {
          String startDay = days[selectedIndices.first];
          String endDay = days[selectedIndices.last];
          _selectedFrequency = '$startDay to $endDay';
        } else {
          _selectedFrequency = selectedDaysList.join(', ');
        }
      }
    }
  }

  void _selectFrequency(String frequency) {
    setState(() {
      _selectedFrequency = frequency;
      _showDatePicker = frequency == 'Ring Once';

      if (frequency == 'Custom') {
        _showCustomFrequencySection = true;
        _updateFrequency();
      } else if (frequency == 'Ring Once') {
        _showCustomFrequencySection = false;
        _selectedDays = List<bool>.filled(7, false);
        _dateController.clear();
      } else if (frequency == 'Everyday') {
        _showCustomFrequencySection = true;
        _selectedDays = List<bool>.filled(7, true);
        _updateFrequency();
      }
    });
  }

  void _resetState() {
    setState(() {
      _selectedFrequency = '';
      _showDatePicker = false;
      _selectedDays = List<bool>.filled(7, false);
      _timeController.clear();
      _dateController.clear();
      _selectedDropdownValue = null;
      _reminderAddedSuccessfully = false;
      _showCustomFrequencySection = false;
    });
  }

  Future<void> _addReminder() async {
    if (_timeController.text.isEmpty ||
        _selectedDropdownValue == null ||
        (_showDatePicker && _dateController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newReminder = Reminder(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(10000).toString(),
        time: _timeController.text,
        frequency: _selectedFrequency.isEmpty ? 'Ring Once' : _selectedFrequency,
        date: _showDatePicker ? _dateController.text : DateTime.now().toString().split(' ')[0],
        type: _selectedDropdownValue!,
      );

      await widget.reminderService.addReminder(newReminder);
      Utils().toastMessage('Reminder added successfully!');


      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Reminder added successfully'),
      //     backgroundColor: Color(0xFF5AA189),
      //   ),
      // );

      setState(() {
        _reminderAddedSuccessfully = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AllReminders(
              reminderService: widget.reminderService,
            ),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add reminder: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF5AA189),
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
            DropdownWidget(
              onChanged: (value) {
                setState(() {
                  _selectedDropdownValue = value;
                });
              },
              showDiabetesTestDate: false,
              diabetesTestDateController: TextEditingController(),
              hintText: 'Select label',
              items: [
                'Glucose Reading',
                'Log Calories',
                'Weight Check',
                'Step Count',
                'GDM Facts'
              ],
              label: 'Select Reminder label',
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              controller: _timeController,
              hintText: 'Select time (HH:mm)',
              readOnly: true,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please select time' : null,
              suffixIcon: IconButton(
                icon: Icon(Icons.access_time),
                color: Color(0xFF5AA189),
                onPressed: _selectTime,
              ),
            ),
            SizedBox(height: 16),
            if (_showDatePicker)
              CustomTextFormField(
                controller: _dateController,
                readOnly: true,
                hintText: 'Select date (yyyy-MM-dd)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Color(0xFF5AA189),
                  onPressed: () => _selectDate(context),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please select date' : null,
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _selectFrequency('Ring Once'),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedFrequency == 'Ring Once'
                          ? Color(0xFF5AA189)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Ring Once',
                      style: TextStyle(
                        color: _selectedFrequency == 'Ring Once'
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectFrequency('Custom'),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedFrequency == 'Custom'
                          ? Color(0xFF5AA189)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Custom',
                      style: TextStyle(
                        color: _selectedFrequency == 'Custom'
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showCustomFrequencySection && !_reminderAddedSuccessfully)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repeat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _selectedFrequency == 'Everyday' ? 'Everyday' : 'Weekdays',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 7; i++)
                        GestureDetector(
                          onTap: () => _toggleDay(i),
                          child: Container(
                            width: 30,
                            height: 35,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: _selectedDays[i]
                                  ? Color(0xFF5AA189)
                                  : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                ['S', 'M', 'T', 'W', 'T', 'F', 'S'][i],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedDays[i] ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Repeat: $_selectedFrequency',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            SizedBox(height: 24),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF5AA189)))
                : CustomButton(
              onTap: _addReminder,
              buttonText: 'Add Reminder',
            ),
          ],
        ),
      ),
    );
  }
}