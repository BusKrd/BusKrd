import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.blue, // Color for selected item
       unselectedItemColor: Colors.grey, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled,color: Color.fromARGB(255, 0, 0, 0)), // Custom Home Icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route,color: Color.fromARGB(255, 0, 0, 0)), // Custom Route Icon
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book,color: Color.fromARGB(255, 0, 0, 0)), // Custom Reservation Icon
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active,color: Color.fromARGB(255, 0, 0, 0)), // Custom Noticiction Icon
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)), // Custom Profile Icon
            label: 'Profile',
          ),
        ],
      );
  }
}
