import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;

class Reminder {
  final String id;
  final String time;
  final String frequency;
  final String date;
  final String type;
  bool isActive;

  Reminder({
    required this.id,
    required this.time,
    required this.frequency,
    required this.date,
    required this.type,
    this.isActive = true,
  });

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
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  Future<void> initNotifications() async {
    if (_isInitialized) return;

    try {
      // Initialize timezones
      tz_init.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print('Timezone initialized: $timeZoneName');

      // Initialize notifications plugin
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final initSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          print('Notification tapped: ${response.payload}');
          // Handle notification tap here
        },
      );

      // Create notification channel
      await _createNotificationChannel();

      // Schedule all active reminders
      await scheduleAllActiveReminders();

      _isInitialized = true;
      print('Notification system initialized');
    } catch (e) {
      print('Error in initNotifications: $e');
      rethrow;
    }
  }

  Future<void> _createNotificationChannel() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      description: 'Channel for important reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      // Fixed Int64List by making it nullable
      vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print('Notification channel created');
  }

  Future<CollectionReference> _getUserReminderCollection() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('No user signed in');

    final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
    if (!userDoc.exists) throw Exception('User not found');

    return _firestore.collection('Users').doc(currentUser.uid).collection('reminders');
  }

  Future<void> addReminder(Reminder reminder) async {
    try {
      print('Adding new reminder: ${reminder.type} at ${reminder.time}');
      final reminderCollection = await _getUserReminderCollection();
      final docRef = await reminderCollection.add(reminder.toMap());
      await docRef.update({'id': docRef.id});

      await _cancelNotification(docRef.id);

      if (reminder.isActive) {
        await _scheduleReminderNotification(Reminder(
          id: docRef.id,
          time: reminder.time,
          frequency: reminder.frequency,
          date: reminder.date,
          type: reminder.type,
          isActive: true,
        ));
      }
      print('Reminder added successfully');
    } catch (e) {
      print('Error adding reminder: $e');
      rethrow;
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      final reminderCollection = await _getUserReminderCollection();
      await reminderCollection.doc(reminderId).delete();
      await _cancelNotification(reminderId);
      print('Reminder deleted successfully');
    } catch (e) {
      print('Error deleting reminder: $e');
      rethrow;
    }
  }

  Future<void> updateReminderStatus(String reminderId, bool isActive) async {
    try {
      final reminderCollection = await _getUserReminderCollection();
      await reminderCollection.doc(reminderId).update({'isActive': isActive});

      final doc = await reminderCollection.doc(reminderId).get();
      final reminder = Reminder.fromDocument(doc);

      await _cancelNotification(reminderId);

      if (isActive) {
        await _scheduleReminderNotification(reminder);
      }
      print('Reminder status updated to $isActive');
    } catch (e) {
      print('Error updating reminder status: $e');
      rethrow;
    }
  }

  Stream<List<Reminder>> getReminders() async* {
    try {
      final reminderCollection = await _getUserReminderCollection();
      yield* reminderCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map(Reminder.fromDocument).toList());
    } catch (e) {
      print('Error getting reminders: $e');
      yield [];
    }
  }

  Future<List<Reminder>> getAllActiveReminders() async {
    try {
      final reminderCollection = await _getUserReminderCollection();
      final snapshot = await reminderCollection
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map(Reminder.fromDocument).toList();
    } catch (e) {
      print('Error getting active reminders: $e');
      return [];
    }
  }

  Future<void> scheduleAllActiveReminders() async {
    try {
      await _notificationsPlugin.cancelAll();
      print('Canceled all existing notifications');

      final activeReminders = await getAllActiveReminders();
      print('Found ${activeReminders.length} active reminders to schedule');

      for (var reminder in activeReminders) {
        if (reminder.frequency == 'Once') {
          final date = DateTime.parse(reminder.date);
          final time = _parseTimeString(reminder.time);
          final combined = DateTime(
              date.year, date.month, date.day, time.hour, time.minute);

          if (combined.isBefore(DateTime.now())) {
            print('Skipping past one-time reminder: ${reminder.id}');
            await updateReminderStatus(reminder.id, false);
            continue;
          }
        }

        await _scheduleReminderNotification(reminder);
      }
      print('Finished scheduling all active reminders');
    } catch (e) {
      print('Error scheduling reminders: $e');
      rethrow;
    }
  }

  Future<void> _scheduleReminderNotification(Reminder reminder) async {
    try {
      print('Scheduling reminder: ${reminder.type} (${reminder.frequency})');
      await _cancelNotification(reminder.id);

      switch (reminder.frequency) {
        case 'Everyday':
          await _scheduleDailyReminder(reminder);
          break;
        case 'Weekdays':
          await _scheduleWeeklyReminder(reminder, [1, 2, 3, 4, 5]);
          break;
        case 'Weekends':
          await _scheduleWeeklyReminder(reminder, [6, 7]);
          break;
        case 'Mon, Wed, Fri':
          await _scheduleWeeklyReminder(reminder, [1, 3, 5]);
          break;
        case 'Tue, Thu':
          await _scheduleWeeklyReminder(reminder, [2, 4]);
          break;
        case 'Once':
          await _scheduleSingleReminder(reminder);
          break;
        default:
          await _scheduleSingleReminder(reminder);
      }
    } catch (e) {
      print('Error scheduling reminder notification: $e');
      rethrow;
    }
  }

  Future<void> _scheduleSingleReminder(Reminder reminder) async {
    try {
      final date = DateTime.parse(reminder.date);
      final time = _parseTimeString(reminder.time);
      final scheduledDate = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      print('Scheduling single reminder for: ${scheduledDate.toString()}');

      await _showNotification(
        reminder.id,
        'Reminder: ${reminder.type}',
        'Time for your ${reminder.type.toLowerCase()}',
        scheduledDate,
      );
    } catch (e) {
      print('Error in _scheduleSingleReminder: $e');
      rethrow;
    }
  }

  Future<void> _scheduleDailyReminder(Reminder reminder) async {
    try {
      final time = _parseTimeString(reminder.time);
      final scheduledDate = _nextInstanceOfTime(time);

      print('Scheduling daily reminder for: ${scheduledDate.toString()}');

      await _showNotification(
        reminder.id,
        'Daily Reminder: ${reminder.type}',
        'Time for your daily ${reminder.type.toLowerCase()}',
        scheduledDate,
        repeatDaily: true,
      );
    } catch (e) {
      print('Error in _scheduleDailyReminder: $e');
      rethrow;
    }
  }

  Future<void> _scheduleWeeklyReminder(Reminder reminder, List<int> days) async {
    try {
      final time = _parseTimeString(reminder.time);
      for (int day in days) {
        final scheduledDate = _nextInstanceOfTimeAndDay(time, day);
        print('Scheduling weekly reminder for day $day at: ${scheduledDate.toString()}');

        await _showNotification(
          '${reminder.id}-$day',
          'Reminder: ${reminder.type}',
          'Time for your ${reminder.type.toLowerCase()}',
          scheduledDate,
          repeatWeekly: true,
        );
      }
    } catch (e) {
      print('Error in _scheduleWeeklyReminder: $e');
      rethrow;
    }
  }

  Future<void> _showNotification(
      String id,
      String title,
      String body,
      tz.TZDateTime scheduledDate, {
        bool repeatDaily = false,
        bool repeatWeekly = false,
      }) async {
    try {
      print('Preparing notification: $title at $scheduledDate');
      final now = tz.TZDateTime.now(tz.local);

      if (scheduledDate.isBefore(now)) {
        if (repeatDaily || repeatWeekly) {
          while (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
          }
          print('Rescheduled to future date: $scheduledDate');
        } else {
          print('Skipping - one-time notification time is in the past');
          return;
        }
      }

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Channel for important reminders',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.cancel(_getNotificationId(id));

      await _notificationsPlugin.zonedSchedule(
        _getNotificationId(id),
        title,
        body,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: repeatDaily
            ? DateTimeComponents.time
            : (repeatWeekly ? DateTimeComponents.dayOfWeekAndTime : null),
      );

      print('Notification scheduled successfully for: ${scheduledDate.toString()}');
    } catch (e) {
      print('Error in _showNotification: $e');
      rethrow;
    }
  }

  Future<void> _cancelNotification(String id) async {
    try {
      await _notificationsPlugin.cancel(_getNotificationId(id));
      for (int i = 1; i <= 7; i++) {
        await _notificationsPlugin.cancel(_getNotificationId('$id-$i'));
      }
      print('Notifications canceled for ID: $id');
    } catch (e) {
      print('Error canceling notifications: $e');
      rethrow;
    }
  }

  TimeOfDay _parseTimeString(String timeStr) {
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      print('Error parsing time string: $timeStr');
      return TimeOfDay.now();
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfTimeAndDay(TimeOfDay time, int targetDay) {
    var scheduled = _nextInstanceOfTime(time);
    while (scheduled.weekday != targetDay) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  int _getNotificationId(String id) {
    return id.hashCode & 0x7FFFFFFF;
  }

  void dispose() {
    _notificationsPlugin.cancelAll();
  }
}