import 'package:buskrd/managaer/bus_assignment.dart';
import 'package:buskrd/managaer/drivers_list.dart';
import 'package:buskrd/managaer/edit_assigned_bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 108, 149),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            // Display the total number of buses from Firestore
            FutureBuilder<int>(
              future: _getTotalBuses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.business, size: 40),
                          SizedBox(height: 8),
                          Text("Manager", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Total number of buses",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                          SizedBox(height: 8),
                          Text("${snapshot.data}", style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildCard("Assign buses", Icons.add_chart_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AssignBus()));
                  }),
                  _buildCard("List of drivers", Icons.list_alt, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DriversList()));
                  }),
                  _buildCard("Update/Delete", Icons.edit_calendar, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditAsBuses()));
                  }),
                  _buildCard("Profile", Icons.person, () {
                    print("Profile clicked");
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get total buses count from Firestore
  // Function to get total buses count from Firestore
Future<int> _getTotalBuses() async {
  int totalBuses = 0;

  try {
    // Get the 'drivers' collection
    QuerySnapshot driversSnapshot = await FirebaseFirestore.instance.collection('drivers').get();

    // Loop through all the driver documents
    for (var driverDoc in driversSnapshot.docs) {
      // Get the 'info' subcollection for each driver
      var infoCollection = driverDoc.reference.collection('info');
      var busInfoDoc = await infoCollection.doc('busInfo').get();

      // If busInfo document exists and contains the 'busNumber' field, count the bus
      if (busInfoDoc.exists && busInfoDoc.data() != null) {
        var busData = busInfoDoc.data();

        // Check if 'busNumber' field exists and is not null
        if (busData != null && busData.containsKey('busNumber') && busData['busNumber'] != null) {
          totalBuses++;  // Increment the total buses count
        }
      }
    }
  } catch (e) {
    print("Error fetching bus count: $e");
  }

  return totalBuses;
}

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
