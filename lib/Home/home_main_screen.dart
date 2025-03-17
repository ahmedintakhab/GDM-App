import 'package:flutter/material.dart';
import 'package:gdm_app/Home/add_pillscreen.dart';
import 'package:gdm_app/Home/chat_container.dart';
import 'package:gdm_app/Home/doctor_visit_container.dart';
import 'package:gdm_app/Home/heart_blood_container.dart';
import 'package:gdm_app/Home/linear_progress_container.dart';
import 'package:gdm_app/Home/progress_and_stepscount.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/Home/user_reports_screen.dart';
import 'package:gdm_app/glucose_screen/glucose_details_screen.dart';
import 'package:provider/provider.dart';
import 'User_profile_screen.dart';
import 'bottom_navigation_bar.dart';
import 'gulcose_chart.dart';
import 'notification_screen.dart';
// Import ProfileScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index

  // List of screens to display based on the selected index
  final List<Widget> _screens = [
    HomeContent(), // Home content
    NotificationScreen(), // Notifications screen
    MealsScreen(), // Reports screen
    ProfileScreen(), // Profile screen
  ];

  // Function to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
            boxShadow: [
        BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 15,
        spreadRadius: 3,
        offset: Offset(0, -3),)
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

// Home content (moved from the original HomeScreen)
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to UserProvider changes
    return Consumer<UserProvider>(
        builder: (context, userProvider, child)
    {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fixed Header Row (Text and CircleAvatar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userProvider.isLoading
                      ? 'Hi, Loading...'
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
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
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

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Chat Container
                    ChatContainer(),
                    SizedBox(height: 16),

                    // Progress and Steps Count
                    ProgressAndStepscount(),
                    SizedBox(height: 16),
                    //Linear percentage bar container function calling
                    LinearProgressContainer(),
                    SizedBox(height: 16),


                    // Pills and Glucose Row
                    Row(
                      children: [
                        // First Container (Pills)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddPillScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                        'Pills',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.medication,
                                          color: Colors.blue[800]),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '2 taken',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Spacer between the two containers

                        // Second Container (Glucose)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (
                                      context) => const GlucoseDetailsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                        'Glucose',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.water_drop,
                                          color: Colors.red[800]),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '143 mg/dl',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Health Metrics Row
                    HealthMetricsRow(),
                    SizedBox(height: 16),
                    //Doctor checkup container function calling
                    DoctorVisitContainer(),
                    SizedBox(height: 16),

                    // Weekly Graph Container
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
                            'Glucose, week avg',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 150,
                            child: WeeklyGlucoseChart(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    );
  }
}