import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      selectedItemColor: const Color.fromARGB(255, 156, 39, 176),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
            color: Color.fromARGB(255, 156, 39, 176),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.route,
            color: Color.fromARGB(255, 156, 39, 176),
          ),
          label: 'Route',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: Color.fromARGB(255, 156, 39, 176),
          ),
          label: 'Reservation',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications_active,
            color: Color.fromARGB(255, 156, 39, 176),
          ),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Color.fromARGB(255, 156, 39, 176),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
