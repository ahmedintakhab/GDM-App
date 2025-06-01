import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/chat_container.dart';
import 'package:gdm_app/Home/doctor_visit_container.dart';
import 'package:gdm_app/Home/information_card_widget.dart';
import 'package:gdm_app/Home/linear_progress_container.dart';
import 'package:gdm_app/Home/progress_and_stepscount.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/Meals_plain/meals_main_screen.dart';
import 'package:gdm_app/feedback/feedback_container_widget.dart';
import 'package:gdm_app/feedback/feedback_screen.dart';
import 'package:gdm_app/glucose_screen/glucose_details_screen.dart';
import 'package:gdm_app/help%20center/information_screen.dart';
import 'package:gdm_app/reminder/add_reminders_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../reminder/reminder_service_implementation.dart';
import 'User_profile_screen.dart';
import 'bottom_navigation_bar.dart';
import 'glucose_card_widget.dart';
import 'gulcose_chart.dart';
import 'notification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget {
  final ReminderService reminderService; // Add reminderService

  const HomeScreen({Key? key, required this.reminderService}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(reminderService: widget.reminderService), // Pass reminderService
      NotificationScreen(),
      AddReminders(reminderService: widget.reminderService),
      MealsMainScreen(),
      ProfileScreen(reminderService: widget.reminderService),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserData();
      userProvider.fetchGlucoseData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: const ChatActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 3,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigation(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final ReminderService reminderService;

  const HomeContent({Key? key, required this.reminderService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Access AppLocalizations
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final averageGlucoseValue = userProvider.glucoseData.isNotEmpty
            ? (userProvider.glucoseData)
            .map((data) => (data['value'] as num).toDouble())
            .reduce((a, b) => a + b) /
            userProvider.glucoseData.length
            : 0;

        return Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userProvider.isLoading
                        ? l10n.hiLoading
                        : 'Hi, ${userProvider.name}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(reminderService: reminderService)),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                  if (userProvider.userType != 'Doctor' )...[
                      ProgressAndStepscount(),
                      ],
                      SizedBox(height: 16),
                   if( userProvider.userType != 'Not Pregnant') ...[
                      InformationCardWidget(
                        onTap: () {
                          Get.to(InformationScreen());
                        },
                      ),
                      ],
                      SizedBox(height: 16),
                      if (userProvider.userType != 'Doctor' &&
                          userProvider.userType != 'Not Pregnant') ...[
                        LinearProgressContainer(
                            reminderService: reminderService), // Pass reminderService
                        SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                        if (userProvider.userType != 'Doctor' )...[
                             Expanded(
                              child: FeedbackContainerWidget(
                                  onTap: () {
                                    Get.to(FeedbackScreen());
                                  })),],
                          if (userProvider.userType != 'Doctor') ...[
                            SizedBox(width: 16.w),
                            Expanded(
                              child: GlucoseCardWidget(
                                title: l10n.glucose,
                                value: userProvider.isLoading
                                    ? l10n.loading
                                    : '${averageGlucoseValue == averageGlucoseValue.truncateToDouble() ? averageGlucoseValue.toInt()
                                    : averageGlucoseValue.toStringAsFixed(2)} '
                                    '${userProvider.glucoseData.isNotEmpty ?
                                userProvider.glucoseData.first['unit'] : 'mg/dl'}', // Line ~10: Format double
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GlucoseDetailsScreen(),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ],
                      ),
                      SizedBox(height: 16),
                      if (userProvider.userType != 'Doctor' &&
                          userProvider.userType != 'Not Pregnant') ...[
                        DoctorVisitContainer(),
                        ],
                        SizedBox(height: 16),
                        if (userProvider.userType != 'Doctor')...[
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.glucoseWeeklyAvg,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 150,
                                child: WeeklyGlucoseChart(
                                    weeklyData: userProvider.getWeeklyAverages()),
                              ),
                            ],
                          ),
                        ),
                              ]
                      ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}