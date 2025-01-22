import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/driver_notification.dart';
import 'package:buskrd/screen/Driver%20screens/driver_profile.dart';
import 'package:buskrd/screen/Driver%20screens/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeDriver extends StatefulWidget {
  const HomeDriver({super.key});

  @override
  State<HomeDriver> createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the Route screen when the second icon (index 1) is tapped
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TimeTable(),),);
     
    }
    else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverNotification(),),);
     
    }
    else if (index == 3) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverProfile(),),);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
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
          child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
         elevation: 0,
        toolbarHeight: 80, // Reduced the height for the search bar
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align search bar and button to opposite sides
        children: [
          // Search bar
          Flexible(
            child: Container(
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
          ),
          SizedBox(width: 16), // Add some space between the search bar and the icon button
        ],
          ),
        ),
         
      ),
       ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
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
      bottomNavigationBar:DriverBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), 
    );
    
  }
}