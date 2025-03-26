import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/bus_info.dart';
import 'package:buskrd/screen/Driver%20screens/driver_info.dart';
import 'package:buskrd/screen/Driver%20screens/driver_notification.dart';
import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:buskrd/screen/Driver%20screens/seat.dart';
import 'package:buskrd/screen/Driver%20screens/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DriverProfile extends StatefulWidget {
  final String enteredCode;
  const DriverProfile({super.key, required this.enteredCode});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the Route screen when the second icon (index 1) is tapped
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeDriver(enteredCode: widget.enteredCode),),);
     
    }
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TimeTable(enteredCode: widget.enteredCode),),);
     
    }
    
    else if (index == 2) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverNotification(enteredCode: widget.enteredCode),),);
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
            decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 156, 39, 176),
                Color.fromARGB(255, 233, 30, 99),
              ],
            ),),
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
                 _options("Driver infromation", Icons.person, DriverInformation()),
                 _options("Bus infromation", Icons.bus_alert, BusInformation()),
                 _options("Settings", Icons.settings, DriverInformation()),
                 _options("About us", Icons.help_outline, DriverInformation()),
 
                ],
              ),
            ),
          ),
        ], //children
      ),
      bottomNavigationBar: DriverBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
  Widget _options(String title, IconData icon, Widget next){
    return Container(
                    height: 51, // Reduced height for the "Help" box
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 213, 212, 212),
                    ),
                    child: ListTile(
                      leading: Icon(icon,
                          color: Colors.black), // Icon for help
                      title: Text(title),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0), // Adjusted padding
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> next,),);
                      },
                    ),
                  );
  }
}