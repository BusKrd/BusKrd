import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/bus_info.dart';
import 'package:buskrd/screen/Driver%20screens/driver_info.dart';
import 'package:buskrd/screen/Driver%20screens/driver_notification.dart';
import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:buskrd/screen/Driver%20screens/seat.dart';
import 'package:buskrd/screen/Driver%20screens/time_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, dynamic>? driverInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDriverInfo();
  }

  Future<void> fetchDriverInfo() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference driverInfoRef = firestore
          .collection('drivers')
          .doc(widget.enteredCode)
          .collection('info')
          .doc('driverInfo');

      var driverSnapshot = await driverInfoRef.get();

      if (driverSnapshot.exists) {
        setState(() {
          driverInfo = driverSnapshot.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          driverInfo = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching driver data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeDriver(enteredCode: widget.enteredCode),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeTable(enteredCode: widget.enteredCode),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverNotification(enteredCode: widget.enteredCode),
        ),
      );
    }
  }

   String getInitials() {
    String firstName = driverInfo?['firstName'] ?? '';
    String lastName = driverInfo?['lastName'] ?? '';

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
    } else if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase();
    } else if (lastName.isNotEmpty) {
      return lastName[0].toUpperCase();
    } else {
      return '?'; // Fallback when no name is available
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
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          getInitials(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 10, 57, 122),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "${driverInfo?['firstName'] ?? 'No First Name'} ${driverInfo?['lastName'] ?? 'No Last Name'}",
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                const SizedBox(height: 10),
                isLoading
                    ? const SizedBox.shrink()
                    : Text(
                        driverInfo?['phone'] ?? 'No Phone Number',
                        style: const TextStyle(color: Colors.white),
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
                  _options("Driver information", Icons.person, DriverInformation()),
                  _options("Bus information", Icons.bus_alert, BusInformation()),
                  _options("Settings", Icons.settings, DriverInformation()),
                  _options("About us", Icons.help_outline, DriverInformation()),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DriverBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _options(String title, IconData icon, Widget next) {
    return Container(
      height: 51,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 213, 212, 212),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => next));
        },
      ),
    );
  }
}
