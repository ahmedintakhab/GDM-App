import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      // Request notification permissions
      await requestNotificationPermission();

      // Initialize local notifications
      await _initLocalNotifications();

      // Get and store FCM token
      String? token = await _messaging.getToken();
      if (token != null && _auth.currentUser != null) {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
        print('FCM token stored: $token');
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((token) async {
        if (_auth.currentUser != null) {
          await _firestore
              .collection('Users')
              .doc(_auth.currentUser!.uid)
              .set({'fcmToken': token}, SetOptions(merge: true));
          print('FCM token updated: $token');
        }
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message: ${message.notification?.title}');
        // Display a local notification
        if (message.notification != null) {
          _showLocalNotification(
            title: message.notification!.title ?? 'Notification',
            body: message.notification!.body ?? '',
          );
        }
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('Error initializing ReminderService: $e');
      rethrow;
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
        // Handle notification tap (e.g., navigate to a screen)
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      description: 'Channel for important reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  Future<void> _showLocalNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for important reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformDetails,
    );
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
      // Open notification settings if permission is denied
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  static Future<void> _initializeNotificationsForBackground() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Background notification tapped: ${response.payload}');
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await _initializeNotificationsForBackground();
    print('Handling background message: ${message.notification?.title}');
    if (message.notification != null) {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Channel for important reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(
        0,
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        platformDetails,
      );
    }
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
}