// bottom_navigation.dart
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.alarm_add),
          label: 'Reminder',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.no_meals),
          label: 'Meals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Color(0xFF5AA189),
      unselectedItemColor: Colors.grey,
    );
  }
}