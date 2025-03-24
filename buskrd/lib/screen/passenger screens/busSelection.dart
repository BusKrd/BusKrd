import 'package:buskrd/screen/Driver%20screens/seat.dart';
import 'package:buskrd/screen/passenger%20screens/payment.dart';
import 'package:buskrd/screen/passenger%20screens/seats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusSelection extends StatefulWidget {
  final String city1;
  final String city2;
  final String date;
  BusSelection(
      {super.key,
      required this.city1,
      required this.city2,
      required this.date});

  @override
  _BusSelectionState createState() => _BusSelectionState();
}

class _BusSelectionState extends State<BusSelection> {
  List<String> cities = []; // Will store fetched city names
  List<Map<String, String>> buses = [];

  @override
  void initState() {
    super.initState();
    fetchCities();
    fetchBuses(); // Fetch cities when the screen loads
  }

  // Function to fetch city names from Firestore
  void fetchCities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc =
          await firestore.collection("cities").doc("kurdistan").get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          cities = List<String>.from(data["city"] ??
              []); // Convert Firestore array to List<String> safely
        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  void fetchBuses() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String docName = "";

    // Determine the correct document
    if (widget.city1 == "Sulaymaniyah" && widget.city2 == "Erbil") {
      docName = "FJ6gDgls0EhZPmq2Sr5e";
    } else if (widget.city1 == "Sulaymaniyah" && widget.city2 == "Kirkuk") {
      docName = "YwiwQPElXpQVeDW5bsow";
    } else {
      print("No valid route found for ${widget.city1} to ${widget.city2}");
      return;
    }

    try {

      QuerySnapshot querySnapshot = await firestore
          .collection("availableBuses")
          .doc(docName)
          .collection(widget.date)
          .get();

      print("Selected Cities: ${widget.city1} to ${widget.city2}");
      print("Document Name: $docName");

      print("🔹 Query executed: ${querySnapshot.size} buses found.");

      if (querySnapshot.docs.isEmpty) {
        print("No buses found for ${widget.city1} to ${widget.city2}");
      }

      setState(() {
        buses = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            "bus": data["busNumber"].toString(), // Bus name
            "time": data["time"].toString(), // Time interval
            "route": data["route"].toString(), // Route
            "reservedSeats": data["reservedSeats"].toString(),
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching buses: $e");
    }
  }

  // Input Field Widget
  

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
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Bus selection',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white, // Set the back arrow color to white
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Top Half with rounded bottom corners (now filling horizontally)
          Container(
            width: double.infinity, // Make it fill horizontally
            height: 172, // Adjust height as needed
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 156, 39, 176),
                  Color.fromARGB(255, 233, 30, 99),
                ],
              ), // Background color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), // Rounded bottom-left corner
                bottomRight: Radius.circular(30), // Rounded bottom-right corner
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.city1, // City 1
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      widget.city2, // City 2
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.date, // Date
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
            ),
          ),
          // Bottom Half with list of buses and rounded top corners
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(
                      height: 20), // Space between container top and title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Select Bus',
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
                        int reservedSeats = int.tryParse(
                                buses[index]["reservedSeats"] ?? "0") ??
                            0;
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buses[index]["bus"]!, // Bus name
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      buses[index]["time"]!, // Time interval
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      buses[index]["route"]!, // Route
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.directions_bus,
                                      color: Color.fromARGB(255, 33, 32, 70),
                                      size: 30,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '(${reservedSeats}/12)', // Display available seats
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Seats(
                                    bus: buses[index]["bus"]!,
                                    time: buses[index]["time"]!,
                                    route: buses[index]["route"]!,
                                    city1: widget.city1,
                                    city2: widget.city2,
                                    date: widget.date,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
