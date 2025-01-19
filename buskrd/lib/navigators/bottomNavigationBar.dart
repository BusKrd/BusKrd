import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 156, 39, 176),
            Color.fromARGB(255, 233, 30, 99),
          ],
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png', width: 24, height: 24), // Custom Home Icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/route.png', width: 24, height: 24), // Custom Route Icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/reserve.png', width: 24, height: 24), // Custom Notifications Icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/notification.png', width: 24, height: 24), // Custom Messages Icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/profile.png', width: 24, height: 24), // Custom Profile Icon
            label: '',
          ),
        ],
      ),
    );
  }
}
