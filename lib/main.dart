import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Home/user_data_provider.dart';
import 'Splash Screen/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Create a singleton instance of ReminderService
  final ReminderService reminderService = ReminderService();

  // Initialize the notification plugin
  await reminderService.initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers if needed
      ],
      child: MyApp(reminderService: reminderService),
    ),
  );}

class MyApp extends StatelessWidget {
  final ReminderService reminderService;

  const MyApp({Key? key, required this.reminderService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // Use GetMaterialApp for navigation
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with Splash Screen
    );
  }
}

