import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/driver_profile.dart';
import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:buskrd/screen/Driver%20screens/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DriverNotification extends StatefulWidget {
  const DriverNotification({super.key});

  @override
  State<DriverNotification> createState() => _DriverNotificationState();
}

class _DriverNotificationState extends State<DriverNotification> {
   int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the Route screen when the second icon (index 1) is tapped
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeDriver(),),);
     
    }
    else if (index == 1) {
     Navigator.push(context, MaterialPageRoute(builder: (context)=> TimeTable(),),);
    }
    else if (index == 3) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverProfile(),),);
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
                         // Example action: go back
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color:Color(0xFFFEB958),
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
      bottomNavigationBar:DriverBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), 
    );
  }
}