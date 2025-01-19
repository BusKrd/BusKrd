import 'package:buskrd/screen/passenger_notification.dart';
import 'package:buskrd/screen/passenger_profile.dart';
import 'package:flutter/material.dart';
import 'package:buskrd/screen/homepage.dart';
import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/screen/reservation.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  int _selectedIndex = 1; // Start on the "Route" screen index (second item)

  // Handle the bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SeatReservation()),
      );
    }
    else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PassengerNotification()),
      );
    }
    else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PassengerProfile()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top half of the screen
          Container(
            height: 200, // Adjust the height for the top section
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 33, 32, 70),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo (using Image.asset correctly here)
                  Image.asset(
                    'assets/images/new_logo.png', // Correct usage of Image.asset
                    width: 100, // Set a custom width
                    height: 100, // Set a custom height
                  ),
                  const SizedBox(height: 10),
                  // Search bar below the logo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for a route...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom half of the screen with rounded edges
          Expanded(
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Route Content Here',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
