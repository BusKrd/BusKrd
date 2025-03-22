import 'package:buskrd/dateInput/date_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  TextEditingController fromController = TextEditingController();
   TextEditingController dateController = TextEditingController();
  List<String> cities = [];
  List<Map<String, dynamic>> buses = [];
  Map<String, bool> selectedBuses = {}; // To track checkbox states

  @override
  void initState() {
    super.initState();
    fetchCities(); // Fetch cities when the screen loads
  }

  /// Fetch cities from Firestore
  void fetchCities() async {
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

  /// Fetch buses and driver info based on selected city
  void fetchBusesForCity(String city) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> busList = [];

    try {
      QuerySnapshot driversSnapshot =
          await firestore.collection("drivers").get();

      for (var driverDoc in driversSnapshot.docs) {
        // Fetch busInfo
        DocumentSnapshot busInfoDoc = await firestore
            .collection("drivers")
            .doc(driverDoc.id)
            .collection("info")
            .doc("busInfo")
            .get();

        // Fetch driverInfo
        DocumentSnapshot driverInfoDoc = await firestore
            .collection("drivers")
            .doc(driverDoc.id)
            .collection("info")
            .doc("driverInfo")
            .get();

        if (busInfoDoc.exists && driverInfoDoc.exists) {
          Map<String, dynamic> busData =
              busInfoDoc.data() as Map<String, dynamic>;
          Map<String, dynamic> driverData =
              driverInfoDoc.data() as Map<String, dynamic>;

          // Construct full name from firstName and lastName
          String firstName = driverData["firstName"] ?? "Unknown";
          String lastName = driverData["lastName"] ?? "";
          String fullName = "$firstName $lastName".trim();

          // Check if the city is Sulaymaniyah and plate number starts with "21"
          if (city == "Sulaymaniyah" &&
              busData["plateNumber"] != null &&
              busData["plateNumber"].toString().startsWith("21")) {
            busList.add({
              "plateNumber": busData["plateNumber"],
              "driverId": driverDoc.id,
              "driverName": fullName,
              "phoneNumber": driverData["phone"] ?? "No Phone",
            });
          }
        }
      }

      setState(() {
        buses = busList;
        selectedBuses = {for (var bus in busList) bus["plateNumber"]: false};
      });
    } catch (e) {
      print("Error fetching buses: $e");
    }
  }

  /// Dropdown for selecting city
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
          fetchBusesForCity(newValue);
        }
      },
    );
  }

  /// Checkbox list for buses, showing plate number, driver full name, and phone
  Widget _busCheckboxList() {
    return Column(
      children: buses.map((bus) {
        return CheckboxListTile(
          tileColor: Colors.white,
          title: Text(
            "${bus["plateNumber"]} |${bus["driverName"]} |${bus["phoneNumber"]}",
            style: const TextStyle(fontSize: 14,color: Colors.black),
          ),
          value: selectedBuses[bus["plateNumber"]],
          onChanged: (bool? value) {
            setState(() {
              selectedBuses[bus["plateNumber"]] = value ?? false;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 156, 39, 176),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds padding on left and right
      child: Column(
        children: [
          const SizedBox(height: 10),
          DateInput(dateController: dateController),
          const SizedBox(height: 10),
          _dropdownField("From", fromController),
          const SizedBox(height: 10), // Adds spacing between dropdown and checkbox list
          buses.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10), // Adds padding inside the checkbox list
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color of the list
                        borderRadius: BorderRadius.circular(12), // Optional rounded corners
                      ),
                      child: _busCheckboxList(),
                    ),
                  ),
                )
              : const Text(
                  "No buses available",
                  style: TextStyle(color: Colors.white),
                ),
        ],
      ),
    ),
  );
}

}
