import 'package:buskrd/screen/passenger_notification.dart';
import 'package:buskrd/screen/passenger_profile.dart';
import 'package:flutter/material.dart';
import 'package:buskrd/screen/reservation.dart';
import 'package:buskrd/screen/route.dart';
import 'package:buskrd/navigators/bottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the Route screen when the second icon (index 1) is tapped
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RouteScreen()),
      );
    }
    else if (index == 2) {
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
    else if (index == 4) {
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
          Container(
            color: const Color.fromARGB(255, 33, 32, 70),
            height: 80, // Reduced the height for the search bar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align search bar and button to opposite sides
                children: [
                  // Search bar
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75, // Adjust the width of the search bar
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Favorite button action
                    },
                    icon: const Icon(
                      Icons.favorite_border_sharp, // Heart icon (outline)
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: const Center(
                child: Text('Bottom Half', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), 
    );
  }
}
