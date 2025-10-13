import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationController {

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) async {
      debugPrint('PayLoads : $payload');
      // var notificationVM = Provider.of<NotificationViewModel>(context, listen: false);
      // notificationVM.getNotificationData();

      _handleMessage(context, message);
    });
  }

  Future<void> showNotificationAlert(int id, String title, String body, DateTime dateTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      id,
      title,
      body,
      tz.TZDateTime.parse(tz.UTC, dateTime.toString()), //schedule the notification to show after 2 seconds.
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

    );
  }

  firebaseInit(BuildContext context) async {
    forGroundMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // var notificationVM = Provider.of<NotificationViewModel>(context, listen: false);


      debugPrint('title:${message.notification!.title}');
      debugPrint('body:${message.notification!.body}');
      debugPrint('payload:${message.data}');

      RemoteNotification? notification = message.notification;

      if (Platform.isAndroid) {
        _initLocalNotifications(context, message);
        _showNotification(notification!.title.toString(), notification.body.toString());
      } else {
        // _initLocalNotifications(context ,message);
        //  _showNotification(notification!.title.toString(), notification.body.toString());
      }
    });
  }

  Future forGroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(
        // ignore: use_build_context_synchronously
        context,
        initialMessage,
      );
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _handleMessage(context, event);
    });
  }

  void _handleMessage(BuildContext context, RemoteMessage message) async {


  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token!;
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {}
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {}
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {}
    }
  }

  static Future _showNotification(String title, String body) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body.toString(),
      htmlFormatBigText: false,
      contentTitle: title,
      htmlFormatContentTitle: false,
      htmlFormatSummaryText: false,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'admin id',
      importance: Importance.high,
      number: 10,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
    );

    ///   final DrawinNo platformChannelSpecificsIos = new IOSNotificationDetails(presentSound: true);
    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
      );
    });
  }
}
