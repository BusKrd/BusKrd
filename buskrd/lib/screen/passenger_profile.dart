
import 'package:buskrd/screen/passenger_info.dart';


import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/screen/homepage.dart';
import 'package:buskrd/screen/passenger_notification.dart';
import 'package:buskrd/screen/reservation.dart';
import 'package:buskrd/screen/route.dart';
import 'package:flutter/material.dart';

class PassengerProfile extends StatefulWidget {
  const PassengerProfile({super.key});

  @override
  State<PassengerProfile> createState() => _PassengerProfileState();
}

class _PassengerProfileState extends State<PassengerProfile> {
  int _selectedIndex = 0;
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RouteScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SeatReservation()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PassengerNotification()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // User Profile Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.center,
            color: Color.fromARGB(255, 33, 32, 70),
            child: const Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,
                          size: 50, color: Color.fromARGB(255, 10, 57, 122)),
                    
                      ),
                    
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Ahmad Mhamad',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  '+9647707580973',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 220),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: ListView(
                padding: const EdgeInsets.only(top: 45, left: 22, right: 22),
                children: [
                  Container(
                    height: 51,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 213, 212, 212),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text('Account Information'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassengerAccInfo()));
                      },
                    ),
                  ),
                  Container(
                    height: 51, // Reduced height for the "Settings" box
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 213, 212, 212),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.settings,
                          color: Colors.black), // Icon for settings
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0), // Adjusted padding
                      onTap: () {
                        // Navigate to settings
                      },
                    ),
                  ),
                  Container(
                    height: 51, // Reduced height for the "Help" box
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 213, 212, 212),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.help,
                          color: Colors.black), // Icon for help
                      title: const Text('Help'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0), // Adjusted padding
                      onTap: () {
                        // Navigate to help
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ], //children
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
