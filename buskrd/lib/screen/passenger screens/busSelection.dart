import 'package:buskrd/screen/passenger%20screens/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusSelection extends StatefulWidget {
  final String city1;
  final String city2;
  BusSelection({super.key, required this.city1, required this.city2});

  @override
  _BusSelectionState createState() => _BusSelectionState();
}

class _BusSelectionState extends State<BusSelection> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  List<String> cities = []; // Will store fetched city names

  @override
  void initState() {
    super.initState();
    fetchCities(); // Fetch cities when the screen loads
  }

  // Function to fetch city names from Firestore
 void fetchCities() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    DocumentSnapshot doc = await firestore.collection("cities").doc("kurdistan").get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        cities = List<String>.from(data["city"] ?? []); // Convert Firestore array to List<String> safely
      });
    } else {
      print("Document does not exist");
    }
  } catch (e) {
    print("Error fetching cities: $e");
  }
}

  // List of bus options with time intervals
  final List<Map<String, String>> buses = [
    {"bus": "Bus A", "time": "10:00 - 12:00", "route": "Kirkuk"},
    {"bus": "Bus B", "time": "12:00 - 14:00", "route": "Dukan"},
    {"bus": "Bus C", "time": "14:00 - 16:00", "route": "Kani shaitan"},
    {"bus": "Bus D", "time": "16:00 - 18:00", "route": "Kirkuk"},
    {"bus": "Bus E", "time": "18:00 - 20:00", "route": "Dukan"},
    {"bus": "Bus F", "time": "20:00 - 22:00", "route": "Dukan"},
  ];

  // Input Field Widget
  Widget _dropdownField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Colors.white),
    );

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      dropdownColor: Color.fromARGB(255, 156, 39, 176),
      items: cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        controller.text = newValue!;
      },
    );
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First Input Field (From)
                  _dropdownField(widget.city1, fromController),
                  const SizedBox(height: 10), // Space between text fields
                  // Second Input Field (To)
                  _dropdownField(widget.city2, toController),
                  const SizedBox(height: 10), // Space between text fields
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
                                      buses[index]["route"]!, // Time interval
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                // Right side (Bus icon)
                                const Icon(
                                  Icons.directions_bus, // Bus icon
                                  color: Color.fromARGB(255, 33, 32, 70),
                                  size: 30,
                                ),
                              ],
                            ),
                            onTap: () {
                              // Handle bus selection (for now it just prints)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Payment(
                                          bus: buses[index]["bus"]!,
                                          time: buses[index]["time"]!,
                                          route: buses[index]["route"]!,
                                          city1: widget.city1,
                                          city2: widget.city2)));
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
