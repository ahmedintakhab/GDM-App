import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Home/user_data_provider.dart';
import 'Meals_plain/meals_data_provider.dart';
import 'Splash Screen/splash_screen.dart';
import 'controller/language_change_controller.dart';

// Background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling background message: ${message.messageId}');
//   if (message.notification != null) {
//     final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
//     const androidDetails = AndroidNotificationDetails(
//       'reminder_channel',
//       'Reminder Notifications',
//       channelDescription: 'Notifications for reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//     const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
//     await localNotifications.show(
//       0,
//       message.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//       payload: message.data['reminderId'],
//     );
//   }
// }
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Print Firebase project info and FCM token
  // final app = Firebase.app();
  // print('projectId=${app.options.projectId}  senderId=${app.options.messagingSenderId}');
  // final token = await FirebaseMessaging.instance.getToken();
  // print('FCM token: $token');

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Initialize Firebase Analytics
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // Create a singleton instance of ReminderService
  final ReminderService reminderService = ReminderService();

  // Initialize the ReminderService
  await reminderService.init(
    onGdmReminderTapped: (reminderId) {
      print('GDM reminder tapped in Main screen (no-op): $reminderId');
    },
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MealsProvider()),
        ChangeNotifierProvider(create: (_) => LanguageChangeController()),
      ],
      child: MyApp(reminderService: reminderService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ReminderService reminderService;

  const MyApp({Key? key, required this.reminderService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ReminderService>.value(
      value: reminderService,
      child: Consumer<LanguageChangeController>(
        builder: (context, provider, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            locale: provider.appLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            fallbackLocale: const Locale('en'),
            builder: (context, child) {
              return Directionality(
                textDirection: provider.appLocale?.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
            home: SplashScreen(reminderService: reminderService),
          );
        },
      ),
    );
  }
}