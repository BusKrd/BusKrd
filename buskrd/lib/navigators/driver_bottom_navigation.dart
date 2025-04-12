import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DriverBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const DriverBottomNavigation(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<DriverBottomNavigation> createState() => _DriverBottomNavigationState();
}

class _DriverBottomNavigationState extends State<DriverBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon:
              Icon(Icons.home_filled, color: Color.fromARGB(255, 156, 39, 176)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month,
              color: Color.fromARGB(255, 156, 39, 176)),
          label: 'Time Table',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active,
              color: Color.fromARGB(255, 156, 39, 176)),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Color.fromARGB(255, 156, 39, 176)),
          label: 'Profile',
        ),
      ],
    );
  }
}
