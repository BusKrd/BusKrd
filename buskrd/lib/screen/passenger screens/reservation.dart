import 'package:buskrd/dateInput/date_input.dart';
import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/screen/passenger%20screens/busSelection.dart';
import 'package:buskrd/screen/passenger%20screens/homepage.dart';
import 'package:buskrd/screen/passenger%20screens/passenger_notification.dart';
import 'package:buskrd/screen/passenger%20screens/passenger_profile.dart';
import 'package:buskrd/screen/passenger%20screens/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeatReservation extends StatefulWidget {
  @override
  _SeatReservationState createState() => _SeatReservationState();
}

class _SeatReservationState extends State<SeatReservation> {
  int _selectedIndex = 0;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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
void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RouteScreen()),
      );
      } else if (index == 3) {
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

  // Dropdown field widget (same as before, but dynamic)
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
      body: SafeArea(
        child: Column(
          children: [
            // UI remains the same, just replacing static cities with dynamic data
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 156, 39, 176),
                    Color.fromARGB(255, 233, 30, 99),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/new_logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    _dropdownField("From", fromController),
                    const SizedBox(height: 10),
                    _dropdownField("To", toController),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DateInput(dateController: dateController),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusSelection(
                            city1: fromController.text,
                            city2: toController.text,
                            date: dateController.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEB958),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
