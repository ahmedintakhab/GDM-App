// bottom_navigation.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';


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
    final l10n = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: l10n.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: l10n.notification,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.no_meals),
          label: l10n.meals,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.alarm_add),
          label: l10n.reminder,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
      selectedItemColor: Color(0xFF5AA189),
      unselectedItemColor: Colors.grey,
    );
  }
}