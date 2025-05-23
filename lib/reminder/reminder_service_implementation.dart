import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      'notificationSent': false,
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

class NotificationRecord {
  final String id;
  final String reminderId;
  final String title;
  final String body;
  final Timestamp sentAt;
  final String status;
  final String? error;

  NotificationRecord({
    required this.id,
    required this.reminderId,
    required this.title,
    required this.body,
    required this.sentAt,
    required this.status,
    this.error,
  });

  factory NotificationRecord.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationRecord(
      id: doc.id,
      reminderId: data['reminderId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      sentAt: data['sentAt'] ?? Timestamp.now(),
      status: data['status'] ?? '',
      error: data['error'],
    );
  }
}

class ReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Add a callback for GDM reminder taps
  Function(String)? onGdmReminderTapped;

  Future<void> init({required Function(String) onGdmReminderTapped}) async {
    print('Entering init()');
    if (_isInitialized) {
      print('init() skipped: Already initialized');
      return;
    }

    this.onGdmReminderTapped = onGdmReminderTapped; // Set the initial callback

    try {
      print('Requesting notification permission');
      await _requestNotificationPermission();
      print('Setting FCM auto-init');
      await _messaging.setAutoInitEnabled(true);
      print('Updating FCM token');
      await updateFCMToken();

      print('Setting up listeners');
      _messaging.onTokenRefresh.listen((token) {
        print('Token refreshed: $token');
        updateFCMToken();
      });
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );
      print('Local notifications initialized');

      _isInitialized = true;
      print('init() completed successfully');
    } catch (e) {
      print('Error initializing ReminderService: $e');
      rethrow;
    }
  }

  // New method to update the callback after initialization
  void setGdmReminderTappedCallback(Function(String) callback) {
    print('Updating onGdmReminderTapped callback');
    this.onGdmReminderTapped = callback;
  }

  Future<void> _requestNotificationPermission() async {
    print('Entering _requestNotificationPermission()');
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('Notification permission settings: $settings');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional notification permission');
    } else {
      print('User declined notification permission');
    }
  }

  Future<void> updateFCMToken() async {
    print('Entering updateFCMToken()');
    try {
      if (_auth.currentUser != null) {
        print('Current user UID: ${_auth.currentUser!.uid}');
        String? token = await _messaging.getToken();
        print('Retrieved FCM token: $token');
        if (token != null) {
          print('Writing FCM token to Firestore for user: ${_auth.currentUser!.uid}');
          await _firestore.collection('Users').doc(_auth.currentUser!.uid).set({
            'fcmToken': token,
            'timezone': 'Asia/Karachi',
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('Successfully updated FCM token and set timezone to Asia/Karachi');
        } else {
          print('FCM token is null');
        }
      } else {
        print('No user signed in');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Entering _handleForegroundMessage()');
    if (message.notification != null) {
      print('Foreground message received: ${message.notification!.title} - ${message.notification!.body}');
      const androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminder Notifications',
        channelDescription: 'Notifications for reminders',
        importance: Importance.max,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
      await _localNotifications.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['reminderId'],
      );
      print('Displayed local notification');
    } else {
      print('Foreground message received but no notification payload');
    }
  }
  void _handleNotificationResponse(NotificationResponse response) async {
    print('Entering _handleNotificationResponse()');
    if (response.payload != null) {
      print('Notification tapped with payload: ${response.payload}');
      final reminderId = response.payload!;
      if (reminderId.startsWith('gdm_')) {
        print('GDM reminder tapped, notifying listener');
        onGdmReminderTapped?.call(reminderId); // Call the callback to notify LinearProgressContainer
      }
    }
  }

  Future<void> handleGdmReminderResponse(String reminderId, String action, {String? snoozeDuration}) async {
    print('Entering handleGdmReminderResponse() with reminderId: $reminderId, action: $action');
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('handleGdmReminderResponse');
      final response = await callable.call({
        'reminderId': reminderId,
        'action': action,
        if (snoozeDuration != null) 'snoozeDuration': snoozeDuration,
      });
      print('GDM reminder response handled: ${response.data}');
    } catch (e) {
      print('Error handling GDM reminder response: $e');
      rethrow;
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    print('Entering addReminder() with reminder: ${reminder.toMap()}');
    try {
      final reminderCollection = await _getUserReminderCollection();
      print('Adding reminder to collection: ${reminderCollection.path}');
      final docRef = await reminderCollection.add(reminder.toMap());
      print('Reminder added with doc ID: ${docRef.id}');
      await docRef.update({'id': docRef.id});
      print('Reminder updated with ID: ${reminder.id}');
    } catch (e) {
      print('Error adding reminder: $e');
      rethrow;
    }
  }

  Future<CollectionReference> _getUserReminderCollection() async {
    print('Entering _getUserReminderCollection()');
    final user = _auth.currentUser;
    if (user == null) {
      print('No user signed in');
      throw Exception('No user signed in');
    }
    print('User UID: ${user.uid}');
    final collection = _firestore.collection('Users').doc(user.uid).collection('reminders');
    print('Returning collection path: ${collection.path}');
    return collection;
  }

  Future<void> deleteReminder(String reminderId) async {
    print('Entering deleteReminder() with reminderId: $reminderId');
    try {
      final reminderCollection = await _getUserReminderCollection();
      print('Deleting reminder from collection: ${reminderCollection.path}');
      await reminderCollection.doc(reminderId).delete();
      print('Reminder deleted: $reminderId');
    } catch (e) {
      print('Error deleting reminder: $e');
      rethrow;
    }
  }

  Future<void> updateReminderStatus(String reminderId, bool isActive) async {
    print('Entering updateReminderStatus() with reminderId: $reminderId, isActive: $isActive');
    try {
      final reminderCollection = await _getUserReminderCollection();
      print('Updating reminder in collection: ${reminderCollection.path}');
      await reminderCollection.doc(reminderId).update({'isActive': isActive});
      print('Reminder status updated: $reminderId, isActive: $isActive');
    } catch (e) {
      print('Error updating reminder status: $e');
      rethrow;
    }
  }

  Stream<List<Reminder>> getReminders() async* {
    print('Entering getReminders()');
    try {
      final reminderCollection = await _getUserReminderCollection();
      print('Streaming reminders from collection: ${reminderCollection.path}');
      yield* reminderCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        print('Received snapshot with ${snapshot.docs.length} reminders');
        return snapshot.docs.map(Reminder.fromDocument).toList();
      });
    } catch (e) {
      print('Error getting reminders: $e');
      yield [];
    }
  }

  Future<List<Reminder>> getAllActiveReminders() async {
    print('Entering getAllActiveReminders()');
    try {
      final reminderCollection = await _getUserReminderCollection();
      print('Querying active reminders from collection: ${reminderCollection.path}');
      final snapshot = await reminderCollection.where('isActive', isEqualTo: true).get();
      print('Retrieved ${snapshot.docs.length} active reminders');
      return snapshot.docs.map(Reminder.fromDocument).toList();
    } catch (e) {
      print('Error getting active reminders: $e');
      return [];
    }
  }

  Stream<List<NotificationRecord>> getDisplayReminders({String? reminderId}) async* {
    print('Entering getDisplayReminders() with reminderId: ${reminderId ?? 'all'}');
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No user signed in');
        throw Exception('No user signed in');
      }
      final collection = _firestore.collection('Users').doc(user.uid).collection('Display reminders');
      print('Querying Display reminders from collection: ${collection.path}');

      Query query = collection.orderBy('sentAt', descending: true);
      if (reminderId != null) {
        query = query.where('reminderId', isEqualTo: reminderId);
      }

      yield* query.snapshots().map((snapshot) {
        print('Retrieved ${snapshot.docs.length} display reminders');
        return snapshot.docs.map(NotificationRecord.fromDocument).toList();
      });
    } catch (e) {
      print('Error getting display reminders: $e');
      yield [];
    }
  }

  Future<void> fixExistingReminders() async {
    print('Entering fixExistingReminders()');
    try {
      if (_auth.currentUser == null) {
        print('No user signed in');
        return;
      }
      final reminderCollection = await _getUserReminderCollection();
      print('Fetching all reminders from collection: ${reminderCollection.path}');
      final snapshot = await reminderCollection.get();
      print('Retrieved ${snapshot.docs.length} reminders');
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['notificationSent'] == null) {
          print('Updating reminder ${doc.id} to add notificationSent: false');
          await doc.reference.update({'notificationSent': false});
          print('Updated reminder ${doc.id}');
        }
      }
      print('fixExistingReminders() completed');
    } catch (e) {
      print('Error fixing reminders: $e');
    }
  }
}