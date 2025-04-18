import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimePicker extends StatefulWidget {
  final Function(String) onTimeSelected;

  const TimePicker({Key? key, required this.onTimeSelected}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int selectedHour = 12; // Default to 12
  int selectedMinute = 0; // Default to 00
  String selectedPeriod = 'am'; // Default to AM

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0XFF5AA189),
              ),
            ),
          ),
          // Picker
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours Picker
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = index + 1; // Hours from 1 to 12
                      });
                    },
                    children: List<Widget>.generate(12, (index) {
                      return Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    }),
                    looping: true,
                  ),
                ),
                // Colon Separator
                Text(
                  ':',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                // Minutes Picker
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = index; // Minutes from 0 to 59
                      });
                    },
                    children: List<Widget>.generate(60, (index) {
                      return Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    }),
                    looping: true,
                  ),
                ),
                // AM/PM Picker
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedPeriod = index == 0 ? 'am' : 'pm';
                      });
                    },
                    children: [
                      Center(child: Text('am', style: TextStyle(fontSize: 22))),
                      Center(child: Text('pm', style: TextStyle(fontSize: 22))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Confirm Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                final selectedTime =
                    '$selectedHour:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod';
                widget.onTimeSelected(selectedTime);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5AA189),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Confirm',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the TimePicker in a bottom sheet
Future<void> showTimePickerDialog(
    BuildContext context,
    Function(String) onTimeSelected,
    ) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return TimePicker(onTimeSelected: onTimeSelected);
    },
  );
}