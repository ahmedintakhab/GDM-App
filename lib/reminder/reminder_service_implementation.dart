import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;

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

  // Convert Reminder to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'frequency': frequency,
      'date': date,
      'type': type,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create Reminder from Firestore document
  factory Reminder.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reminder(
      id: doc.id,
      time: data['time'] ?? '',
      frequency: data['frequency'] ?? '',
      date: data['date'] ?? '',
      type: data['type'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }
}

class ReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize notification plugin
  Future<void> initNotifications() async {
    // Initialize timezone
    tz_init.initializeTimeZones();

    // Initialize Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Complete initialization
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        // Handle notification tap
        print('Notification tapped: ${notificationResponse.payload}');
      },
    );
  }

  // Get the collection for the current user
  Future<CollectionReference> _getUserReminderCollection() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is signed in');
    }

    String uid = currentUser.uid;
    String userCollection = '';

    // Check which collection the user belongs to
    DocumentSnapshot? userDoc = await _firestore.collection('user').doc(uid).get();

    if (userDoc.exists) {
      userCollection = 'user';
    } else {
      userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userCollection = 'users';
      } else {
        userDoc = await _firestore.collection('doctor').doc(uid).get();
        if (userDoc.exists) {
          userCollection = 'doctor';
        } else {
          throw Exception('User does not exist in any collection');
        }
      }
    }

    return _firestore.collection(userCollection).doc(uid).collection('reminders');
  }

  // Add a new reminder
  Future<void> addReminder(Reminder reminder) async {
    try {
      final reminderCollection = await _getUserReminderCollection();

      // Add to Firestore
      DocumentReference docRef = await reminderCollection.add(reminder.toMap());

      // Schedule notification if reminder is active
      if (reminder.isActive) {
        await _scheduleNotification(
            docRef.id,
            reminder.type,
            reminder.date,
            reminder.time
        );
      }

      print('Reminder added successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding reminder: $e');
      throw e;
    }
  }

  // Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    try {
      final reminderCollection = await _getUserReminderCollection();

      // Delete from Firestore
      await reminderCollection.doc(reminderId).delete();

      // Cancel the notification
      await _cancelNotification(reminderId);

      print('Reminder deleted successfully');
    } catch (e) {
      print('Error deleting reminder: $e');
      throw e;
    }
  }

  // Update reminder status (active/inactive)
  Future<void> updateReminderStatus(String reminderId, bool isActive) async {
    try {
      final reminderCollection = await _getUserReminderCollection();

      // Update in Firestore
      await reminderCollection.doc(reminderId).update({'isActive': isActive});

      // Get the reminder details
      DocumentSnapshot doc = await reminderCollection.doc(reminderId).get();
      Reminder reminder = Reminder.fromDocument(doc);

      // Handle notification based on status
      if (isActive) {
        await _scheduleNotification(
            reminderId,
            reminder.type,
            reminder.date,
            reminder.time
        );
      } else {
        await _cancelNotification(reminderId);
      }

      print('Reminder status updated successfully');
    } catch (e) {
      print('Error updating reminder status: $e');
      throw e;
    }
  }

  // Get all reminders for the current user
  Stream<List<Reminder>> getReminders() async* {
    try {
      final reminderCollection = await _getUserReminderCollection();

      yield* reminderCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Reminder.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting reminders: $e');
      yield [];
    }
  }

  // Schedule a notification
  Future<void> _scheduleNotification(
      String id,
      String title,
      String dateStr,
      String timeStr,
      ) async {
    try {
      // Parse date and time
      final dateParts = dateStr.split('-');
      final timeParts = timeStr.split(':');

      if (dateParts.length != 3 || timeParts.length != 2) {
        throw Exception('Invalid date or time format');
      }

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final scheduledDate = tz.TZDateTime(
        tz.local,
        year,
        month,
        day,
        hour,
        minute,
      );

      // Check if the date is in the past
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        print('Skipping notification scheduling as the time is in the past');
        return;
      }

      // Define Android notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Notification channel for reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      // Define iOS notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combine platform-specific details
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule the notification - Fixed parameters
      await _notificationsPlugin.zonedSchedule(
        int.parse(id.hashCode.toString().substring(0, 6)), // Convert string ID to int
        'Reminder: $title',
        'It\'s time for your ${title.toLowerCase()}',
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: id,
        matchDateTimeComponents: DateTimeComponents.time, // Agar aapko repeat chahiye to
      );


      print('Notification scheduled for $scheduledDate');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Cancel a scheduled notification
  Future<void> _cancelNotification(String id) async {
    try {
      await _notificationsPlugin.cancel(
          int.parse(id.hashCode.toString().substring(0, 6))
      );
      print('Notification canceled for ID: $id');
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }
}

// Make sure to import this at the top of the file
// This enum might be missing from your imports
enum UILocalNotificationDateInterpretation {
  absoluteTime,
  wallClockTime,
}