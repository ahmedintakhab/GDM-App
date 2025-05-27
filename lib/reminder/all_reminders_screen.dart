import 'package:flutter/material.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'add_reminders_screen.dart';
import 'reminder_item_widget.dart';

class AllReminders extends StatefulWidget {
  final ReminderService reminderService;

  AllReminders({required this.reminderService});

  @override
  _AllRemindersState createState() => _AllRemindersState();
}

class _AllRemindersState extends State<AllReminders> {
  void _deleteReminder(String id) async {
    try {
      await widget.reminderService.deleteReminder(id);

      // Show confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder deleted successfully'),
          backgroundColor: Color(0XFF5AA189),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete reminder: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleReminder(String id, bool value) async {
    try {
      await widget.reminderService.updateReminderStatus(id, value);

      // Show confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Reminder activated' : 'Reminder deactivated'),
          backgroundColor: Color(0XFF5AA189),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update reminder: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      body: StreamBuilder<List<Reminder>>(
          stream: widget.reminderService.getReminders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Color(0XFF5AA189)));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading reminders: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final reminders = snapshot.data ?? [];

            if (reminders.isEmpty) {
              return Center(
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
              );
            }

            return ListView.builder(
              itemCount: reminders.length,
              padding: EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ReminderItem(
                  time: reminder.time,
                  frequency: reminder.frequency,
                  isActive: reminder.isActive,
                  type: reminder.type,
                  onDelete: () => _deleteReminder(reminder.id),
                  onToggle: (value) => _toggleReminder(reminder.id, value),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReminders(
                reminderService: widget.reminderService,
              ),
            ),
          );
        },
        backgroundColor: Color(0XFF5AA189),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}