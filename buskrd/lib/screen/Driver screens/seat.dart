import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/driver_notification.dart';
import 'package:buskrd/screen/Driver%20screens/driver_profile.dart';
import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:buskrd/screen/Driver%20screens/time_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReserveSeat extends StatefulWidget {
  const ReserveSeat({super.key});

  @override
  State<ReserveSeat> createState() => _ReserveSeatState();
}

class _ReserveSeatState extends State<ReserveSeat> {
int _selectedIndex = 0;

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the Route screen when the second icon (index 1) is tapped
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeDriver(),),);
     
    }
    else if (index == 1) {
     Navigator.push(context, MaterialPageRoute(builder: (context)=> TimeTable()),);
    }
    else if (index == 3) {
     Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverNotification(),),);
    }
    else if (index == 4) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverProfile(),),);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("time table")),
      bottomNavigationBar: DriverBottomNavigation(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}