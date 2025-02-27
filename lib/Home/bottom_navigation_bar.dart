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
        // BottomNavigationBarItem(
        //   icon: Container(
        //     decoration: BoxDecoration(
        //       color: Color(0xFF5AA189),
        //       shape: BoxShape.circle,
        //     ),
        //     padding: EdgeInsets.all(12),
        //     child: Icon(Icons.add, color: Colors.white),
        //   ),
        //   label: '',
        // ),
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