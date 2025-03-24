import 'package:flutter/material.dart';
import 'add_reminders_screen.dart';
import 'reminder_item_widget.dart';
import 'delete_reminder_dialog.dart';

class Reminder {
  final String id;
  final String time;
  final String frequency;
  final String date;
  final String type; // From dropdown
  bool isActive;

  Reminder({
    required this.id,
    required this.time,
    required this.frequency,
    required this.date,
    required this.type,
    this.isActive = true,
  });
}

class AllReminders extends StatefulWidget {
  @override
  _AllRemindersState createState() => _AllRemindersState();
}

class _AllRemindersState extends State<AllReminders> {
  // Sample list of reminders (in a real app, this would come from a database)
  List<Reminder> reminders = [
    Reminder(
      id: '1',
      time: '2:46 AM',
      frequency: 'Everyday',
      date: '2025-03-22',
      type: 'Glucose Reading',
      isActive: true,
    ),
    Reminder(
      id: '2',
      time: '8:30 AM',
      frequency: 'Weekdays',
      date: '2025-03-22',
      type: 'Log Calories',
      isActive: false,
    ),
    Reminder(
      id: '3',
      time: '6:00 PM',
      frequency: 'Mon, Wed, Fri',
      date: '2025-03-22',
      type: 'Step Count',
      isActive: true,
    ),
  ];

  void _deleteReminder(String id) {
    setState(() {
      reminders.removeWhere((reminder) => reminder.id == id);
    });

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder deleted successfully'),
        backgroundColor: Color(0XFF5AA189),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleReminder(String id, bool value) {
    setState(() {
      final index = reminders.indexWhere((reminder) => reminder.id == id);
      if (index != -1) {
        reminders[index].isActive = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0XFF5AA189),
        title: Text(
          'All Reminders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: reminders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No reminders yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add a reminder to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: reminders.length,
        padding: EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ReminderItem(
            time: reminder.time,
            frequency: reminder.frequency,
            isActive: reminder.isActive,
            onDelete: () => _deleteReminder(reminder.id),
            onToggle: (value) => _toggleReminder(reminder.id, value),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReminders()),
          ).then((newReminder) {
            if (newReminder != null) {
              setState(() {
                reminders.add(newReminder);
              });
            }
          });
        },
        backgroundColor: Color(0XFF5AA189),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}