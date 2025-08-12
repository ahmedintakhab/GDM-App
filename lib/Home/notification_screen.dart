import '../utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../reminder/reminder_service_implementation.dart';
import '../l10n/app_localizations.dart';
import 'notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  // Helper method to format Timestamp to a readable string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Unknown';
    }
    final dateTime = timestamp.toDate();
    return DateFormat('dd.MM.yy HH:mm').format(dateTime); // e.g., 21.05.25 18:04
  }

  // Method to delete all notifications
  Future<void> _deleteAllNotifications(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.noUserLoggedIn)),
        );
        return;
      }

      final collection = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Display reminders');

      // Fetch all documents and delete them
      final snapshot = await collection.get();
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      Utils().toastMessage(l10n.allNotificationsDeleted);

    } catch (e) {
      Utils().toastMessage('${l10n.errorDeletingNotifications}$e');

    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final reminderService = ReminderService();

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
                   Text(
                   l10n.notification ,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _deleteAllNotifications(context),
                    icon: const Icon(Icons.delete_outline),
                    label:  Text(l10n.deleteAll),
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
                child: StreamBuilder<List<NotificationRecord>>(
                  stream: reminderService.getDisplayReminders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0XFF5AA189),));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('${l10n.errorLoadingNotifications} ${snapshot.error}'));
                    }
                    final notifications = snapshot.data ?? [];
                    if (notifications.isEmpty) {
                      return  Center(child: Text(l10n.noNotificationsAvailable));
                    }

                    // Find the latest notification based on sentAt
                    NotificationRecord? latestNotification;
                    if (notifications.isNotEmpty) {
                      latestNotification = notifications.reduce((a, b) =>
                      (a.sentAt.toDate().isAfter(b.sentAt.toDate())) ? a : b);
                    }

                    // Define a list of colors for avatarColor
                    final colors = [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                    ];

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        // Assign a color based on index
                        final color = colors[index % colors.length];
                        return NotificationItem(
                          avatarColor: color,
                          title: notification.title,
                          message: notification.body,
                          time: _formatTimestamp(notification.sentAt),
                          isNew: latestNotification != null && notification.id == latestNotification.id,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}