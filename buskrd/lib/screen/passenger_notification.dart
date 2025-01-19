import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/screen/homepage.dart';
import 'package:buskrd/screen/passenger_profile.dart';
import 'package:buskrd/screen/reservation.dart';
import 'package:buskrd/screen/route.dart';
import 'package:flutter/material.dart';

class PassengerNotification extends StatefulWidget {
  const PassengerNotification({super.key});


  @override
  State<PassengerNotification> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PassengerNotification> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the Route screen when the second icon (index 1) is tapped
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
    else if (index == 1) {
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
      body: Stack(
        children: [
          // Top Section with Title
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.center,
            color: Color.fromARGB(255, 33, 32, 70),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40), // Padding specifically at the top
                  child: Text(
                    'Notification',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Section with ListTiles
          Padding(
            padding: const EdgeInsets.only(top: 130), // Ensure it doesn't overlap the title
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50, left: 22, right: 22),
                    child: ListView(
                      children: [
                        // Notification Container 1
                        Container(
                          height: 51,
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 213, 212, 212),
                          ),
                          child: Stack(
                            children: [
                              // Main content (Title and Description)
                              Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: ListTile(
                                  title: Text(
                                    'Title \nDescription',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                              // Time at the top right
                              Positioned(
                                top: 10,
                                right: 15,
                                child: Text(
                                  '12:30 PM', // Example time
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification Container 2
                        Container(
                          height: 51,
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 213, 212, 212),
                          ),
                          child: Stack(
                            children: [
                              // Main content (Title and Description)
                              Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: ListTile(
                                  title: Text(
                                    'Title \nDescription',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                              // Time at the top right
                              Positioned(
                            top: 10,
                                right: 15,
                                child: Text(
                                  '01:45 PM', // Example time
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification Container 3
                        Container(
                          height: 51,
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 213, 212, 212),
                          ),
                          child: Stack(
                            children: [
                              // Main content (Title and Description)
                              Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: ListTile(
                                  title: Text(
                                    'Title \nDescription',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                              // Time at the top right
                              Positioned(
                                top: 10,
                                right: 15,
                                child: Text(
                                  '02:10 PM', // Example time
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Small yellow cancel button
                  Positioned(
                    top: 15,
                    right: 25,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Example action: go back
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
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