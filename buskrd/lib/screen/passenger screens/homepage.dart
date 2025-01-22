import 'package:buskrd/screen/passenger%20screens/passenger_notification.dart';
import 'package:buskrd/screen/passenger%20screens/passenger_profile.dart';
import 'package:flutter/material.dart';
import 'package:buskrd/screen/passenger%20screens/reservation.dart';
import 'package:buskrd/screen/passenger%20screens/route.dart';
import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> buses = [
    {"Place":"Place 1"},
    {"Place":"Place 2"},
    {"Place":"Place 3"},
    {"Place":"Place 4"},
  ];

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
          SizedBox(width: 16), 
          
        ],
          ),
        ),
         actions: [
          IconButton(onPressed: () {
            
          Column(
                children: [
                  const SizedBox(
                      height: 20), // Space between container top and title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Favorates',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space after the title
                  Expanded(
                    child: ListView.builder(
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side (Bus number and time interval)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buses[index]["place"]!, // Bus name
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    
                                  ],
                                ),
                                // Right side (Bus icon)
                                const Icon(
                                  Icons.favorite, // Bus icon
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ],
                            ),
                            
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
             
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
      
      bottomNavigationBar:BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), 
    );
    
  }
}
