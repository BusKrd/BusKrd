import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriversList extends StatefulWidget {
  const DriversList({super.key});

  @override
  State<DriversList> createState() => _DriversListState();
}

class _DriversListState extends State<DriversList> {
  TextEditingController plateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    fetchPlateNumAccToCity(); // Fetch cities when the screen loads
  }

  void fetchPlateNumAccToCity() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc =
          await firestore.collection("cities").doc("kurdistan").get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          cities = List<String>.from(data["city"] ?? []);
        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  Widget _dropdownField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
    );

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true, // Ensures background color is applied
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      dropdownColor: Colors.white,
      items: cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.text = newValue;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 108, 149),
      appBar: AppBar(
        title: const Text("Drivers List", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 108, 108, 149),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dropdownField("City Plate Number", plateController), // Dropdown Field
            const SizedBox(height: 20), // Space between dropdown and text field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ), // Text Field for Search
          ],
        ),
      ),
    );
  }
}
