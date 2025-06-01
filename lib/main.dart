import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Home/user_data_provider.dart';
import 'Meals_plain/meals_data_provider.dart';
import 'Splash Screen/splash_screen.dart';
import 'controller/language_change_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        // Add other providers if needed
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
            locale: provider.appLocale, // Should switch between 'en' and 'ar'
            localizationsDelegates: const [
              AppLocalizations.delegate, // Your translations
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales, // From generated file
            fallbackLocale: const Locale('en'), // Fallback if translation missing
            builder: (context, child) {
              // Ensure text direction is set based on locale
              return Directionality(
                textDirection: provider.appLocale?.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
            home: SplashScreen(reminderService: reminderService),
          );        },
      ),
    );
  }
}