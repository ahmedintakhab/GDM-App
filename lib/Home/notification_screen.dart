import 'package:flutter/material.dart';

import 'notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Row with Title and Delete All button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Add delete all functionality
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete all'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Notification List
              Expanded(
                child: ListView(
                  children: [
                    NotificationItem(
                      avatarColor: Colors.red,
                      title: 'Blood test results',
                      message: 'The results of your tests are ready, you can see the results in your electronic medical records or click on this notification.',
                      time: '20.09.20',
                      isNew: true,
                    ),
                    NotificationItem(
                      avatarColor: Colors.blue,
                      title: 'Glucose test results',
                      message: 'The results of your tests are ready, you can see the results in your electronic medical records or click on this notification.',
                      time: '20.09.20',
                    ),
                    NotificationItem(
                      avatarColor: Colors.green,
                      title: 'Doctor confirmed the request',
                      message: 'Dr. Markus Lilja is waiting for you 20.09.20 at CCMHC Medial Center',
                      time: '19.09.20',
                    ),
                    NotificationItem(
                      avatarColor: Colors.blue,
                      title: 'Reminder',
                      message: 'We remind you that once a year it is necessary to take a blood test. Take care of yourself.',
                      time: '18.09.20',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

