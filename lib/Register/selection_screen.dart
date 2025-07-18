import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/login_screen.dart';
import 'package:gdm_app/Register/pregnancy_register_screen.dart';
import 'package:gdm_app/Register/users_signup_screen.dart';
import 'package:gdm_app/Register/without_pregnancy_signup.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Home/user_data_provider.dart';
import '../reminder/reminder_service_implementation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize ReminderService
  final ReminderService reminderService = ReminderService();
  await reminderService.init(
    onGdmReminderTapped: (reminderId) {
      print('GDM reminder tapped in Selection screen (no-op): $reminderId');
    },
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider<ReminderService>.value(value: reminderService),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SelectionScreen(reminderService: reminderService),
      ),
    ),
  );
}

class SelectionScreen extends StatefulWidget {
  final ReminderService reminderService;

  const SelectionScreen({super.key, required this.reminderService});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? _selectedOptionKey; // To store the selected option key (non-localized)

  // Map of option keys to their localized display values
  Map<String, String> getOptionLabels(AppLocalizations l10n) => {
    'Pregnant': l10n.pregnant,
    'Not Pregnant': l10n.notPregnant,
    'Doctor': l10n.doctor,
  };

  Future<void> saveSelectedOption(String optionKey) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .set({
          'userType': optionKey, // Save the non-localized key
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print('User type saved successfully');
      } else {
        print('No user is logged in');
      }
    } catch (e) {
      print('Error saving user type: $e');
    }
  }

  // Function to handle navigation based on the selected option key
  void _navigateToNextScreen() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedOptionKey == null) {
      // Show an error if no option is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectOption)),
      );
      return;
    }

    await saveSelectedOption(_selectedOptionKey!);

    // Navigate to the respective screen based on the selected option key
    switch (_selectedOptionKey) {
      case 'Pregnant':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PregnancyRegistrationScreen(
              selectedOption: l10n.pregnant, // Pass localized value for display
              reminderService: widget.reminderService,
            ),
          ),
        );
        break;
      case 'Not Pregnant':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WithoutPregnancySignup(
              selectedOption: l10n.notPregnant, // Pass localized value for display
              reminderService: widget.reminderService,
            ),
          ),
        );
        break;
      case 'Doctor':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(reminderService: widget.reminderService),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final optionLabels = getOptionLabels(l10n);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          l10n.userSelection,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chooseOption,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.iAm,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Custom Radio Button Box for each option
            ...optionLabels.entries.map((entry) {
              return Column(
                children: [
                  _buildRadioButtonBox(
                    optionKey: entry.key,
                    optionLabel: entry.value,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 100.0, right: 15),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: l10n.dontHaveAccount,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontFamily: 'Gilroy',
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              UsersSignupScreen(reminderService: widget.reminderService),
                            );
                          },
                        text: l10n.signUp,
                        style: TextStyle(
                          color: const Color(0xFF000000),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Show Next Button only if a radio button is selected
            if (_selectedOptionKey != null)
              Center(
                child: ElevatedButton(
                  onPressed: _navigateToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5AA189),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.next,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a custom radio button box
  Widget _buildRadioButtonBox({
    required String optionKey,
    required String optionLabel,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionKey = optionKey; // Store the non-localized key
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedOptionKey == optionKey
              ? const Color(0xFFE8F5E9)
              : Colors.transparent,
          border: Border.all(
            color: _selectedOptionKey == optionKey
                ? const Color(0xFF4CAF50)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _selectedOptionKey == optionKey
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: _selectedOptionKey == optionKey
                  ? const Color(0xFF4CAF50)
                  : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              optionLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: _selectedOptionKey == optionKey
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}