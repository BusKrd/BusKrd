import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/driver_notification.dart';
import 'package:buskrd/screen/Driver%20screens/driver_profile.dart';
import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:buskrd/screen/Driver%20screens/seat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  int _selectedIndex = 0;

  // Generate a list of the next 365 days
  List<DateTime> upcomingDates = List.generate(365, (index) => DateTime.now().add(Duration(days: index)));

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDriver()));
    }else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DriverNotification()));
    } else if (index == 43) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DriverProfile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
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
          ),
          title: const Text("Time Table"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Light grey background for the list
        child: ListView.separated(
          itemCount: upcomingDates.length,
          separatorBuilder: (context, index) => const Divider(thickness: 1, color: Colors.grey), // Line between items
          itemBuilder: (context, index) {
            String formattedDate = DateFormat('EEEE, MMM d').format(upcomingDates[index]);
            return Container(
              color: Colors.white, // White background for each list item
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.purple), // Icon color
                title: Text(formattedDate, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Shift details will be here"), // Placeholder
                onTap: () {
                  // Navigate to the seat reservation screen when a date is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Details()),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: DriverBottomNavigation(
        selectedIndex: _selectedIndex, 
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
