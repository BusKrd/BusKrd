import 'package:buskrd/dateInput/date_input.dart';
import 'package:buskrd/managaer/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssignBus extends StatefulWidget {
  const AssignBus({super.key});

  @override
  State<AssignBus> createState() => _AssignBusState();
}

class _AssignBusState extends State<AssignBus> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final List<String> times = [
    "08:00 AM",
    "10:00 AM",
    "12:00 PM",
    "02:00 PM",
    "04:00 PM"
  ];
  List<String> cities = [];
  List<Map<String, dynamic>> buses = [];
  Map<String, bool> selectedBuses = {};
  Map<String, Map<String, String>> selectedBusDetails = {};

  List<Map<String, dynamic>> busList = [];

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
              "busNumber": busData["busNumber"],
              "plateNumber": busData["plateNumber"],
              "driverId": driverDoc.id,
              "driverName": fullName,
              "phoneNumber": driverData["phone"] ?? "No Phone",
            });
          } else if (city == "Erbil" &&
              busData["plateNumber"] != null &&
              busData["plateNumber"].toString().startsWith("22")) {
            busList.add({
              "busNumber": busData["busNumber"],
              "plateNumber": busData["plateNumber"],
              "driverId": driverDoc.id,
              "driverName": fullName,
              "phoneNumber": driverData["phone"] ?? "No Phone",
            });
          } else if (city == "Kirkuk" &&
              busData["plateNumber"] != null &&
              busData["plateNumber"].toString().startsWith("23")) {
            busList.add({
              "busNumber": busData["busNumber"],
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
      children: buses.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> bus = entry.value;

        return Column(
          children: [
            CheckboxListTile(
              tileColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus["plateNumber"],
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Text(
                    bus["driverName"],
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Text(
                    bus["phoneNumber"],
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              value: selectedBuses[bus["plateNumber"]],
              onChanged: (bool? value) {
                setState(() {
                  selectedBuses[bus["plateNumber"]] = value ?? false;
                });

                if (value == true) {
                  _showBusDialog(bus);
                }
              },
            ),
            if (index < buses.length - 1)
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
          ],
        );
      }).toList(),
    );
  }

  void _showBusDialog(Map<String, dynamic> bus) {
    String plateNumber = bus["plateNumber"];

    // Initialize values if they don’t exist
    if (!selectedBusDetails.containsKey(plateNumber)) {
      selectedBusDetails[plateNumber] = {
        "destination": "",
        "route": "",
        "time": "",
      };
    }

    TextEditingController destinationController = TextEditingController(
        text: selectedBusDetails[plateNumber]!["destination"]);
    TextEditingController routeController =
        TextEditingController(text: selectedBusDetails[plateNumber]!["route"]);
    TextEditingController timeController =
        TextEditingController(text: selectedBusDetails[plateNumber]!["time"]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bus Details:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Plate Number: ${bus["plateNumber"]}"),
              Text("Driver: ${bus["driverName"]}"),
              Text("Phone: ${bus["phoneNumber"]}"),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Destination"),
                value: destinationController.text.isNotEmpty
                    ? destinationController.text
                    : null,
                items: cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? destination) {
                  setState(() {
                    selectedBusDetails[plateNumber]!["destination"] =
                        destination ?? "";
                  });
                },
              ),
              TextField(
                controller: routeController,
                decoration: const InputDecoration(labelText: "Route"),
                onChanged: (value) {
                  selectedBusDetails[plateNumber]!["route"] = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Time"),
                value:
                    timeController.text.isNotEmpty ? timeController.text : null,
                items: times.map((String time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (String? time) {
                  setState(() {
                    selectedBusDetails[plateNumber]!["time"] = time ?? "";
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                print("Bus: $plateNumber");
                print(
                    "Destination: ${selectedBusDetails[plateNumber]!["destination"]}");
                print("Route: ${selectedBusDetails[plateNumber]!["route"]}");
                print("Time: ${selectedBusDetails[plateNumber]!["time"]}");

                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 39, 176),
      appBar: AppBar(
        title: const Text("Assign Bus"),
        backgroundColor: const Color.fromARGB(255, 156, 39, 176),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                DateInput(dateController: dateController),
                const SizedBox(height: 10),
                _dropdownField("Source", sourceController),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _busCheckboxList(),
                    ),
                  ),
                ),
                const SizedBox(height: 60), // Space for the button
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                // Check if any bus is selected
                bool anyBusSelected = selectedBuses.values.contains(true);

                if (!anyBusSelected) {
                  // If no bus is selected, show the dialog
                  _showPleaseSelectBusDialog();
                } else {
                  // Get the source and date values
                  String source =
                      sourceController.text.trim(); // Get the source city
                  String selectedDate = dateController.text
                      .trim(); // Get the date from the date controller

                  // Call the method to save bus details
                  await saveBusDetailsToFirestore(
                      source, selectedBusDetails, selectedDate);
                  _resetScreen();
                  print("Bus Assignment Completed");
                }
              },
              child: const Text(
                "Assign Bus",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveBusDetailsToFirestore(
    String source,
    Map<String, Map<String, String>> selectedBusDetails,
    String dateString) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Convert the date string from the dateController to a DateTime object
  DateTime selectedDate = DateTime.parse(dateString); // Assuming the date is in "yyyy-MM-dd" format
  String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
  Timestamp timestamp = Timestamp.fromDate(selectedDate); // Convert to Firestore timestamp

  // Debugging - check values
  print("Formatted date: $formattedDate");

  for (var entry in selectedBuses.entries) {
    if (entry.value) {
      // Process only selected buses
      String plateNumber = entry.key;
      Map<String, String> busDetails = selectedBusDetails[plateNumber] ?? {};

      String destination = busDetails["destination"] ?? "";
      String route = busDetails["route"] ?? "";
      String time = busDetails["time"] ?? "";
      int reservedSeats = 0;

      // Get the bus number from the buses list
      String busNumber = buses.firstWhere(
          (bus) => bus["plateNumber"] == plateNumber)["busNumber"];

      String docName = "";
      // Check if source and destination match specific conditions
      if (source == "Sulaymaniyah" && destination == "Erbil") {
        docName = "FJ6gDgls0EhZPmq2Sr5e";
      }
      else if (source == "Sulaymaniyah" && destination == "Kirkuk") {
        docName = "YwiwQPElXpQVeDW5bsow";
      }

      // Check if docName or dateString is empty
      print("docName: $docName");
      print("formattedDate: $formattedDate");

      if (docName.isEmpty || formattedDate.isEmpty) {
        print("Error: docName or formattedDate is empty!");
        return; // Early exit if any value is invalid
      }

      try {
        // Now we will check for all availableBuses documents for the selected date
        QuerySnapshot existingAssignments = await firestore
            .collection("availableBuses")
            .get(); // Fetch all documents in the availableBuses collection

        if (existingAssignments.docs.isEmpty) {
          print("No documents found in availableBuses collection.");
        }

        // Loop through all available bus documents and check for conflicts
        bool busAlreadyAssigned = false;

        for (var doc in existingAssignments.docs) {
          QuerySnapshot dateAssignmentsSnapshot = await doc.reference
              .collection(formattedDate) // Get the subcollection for the specific date
              .get();

          for (var busDoc in dateAssignmentsSnapshot.docs) {
            Map<String, dynamic> busData = busDoc.data() as Map<String, dynamic>;

            // Check if the same bus has already been assigned for the same date
            if (busData["plateNumber"] == plateNumber) {
              busAlreadyAssigned = true;
              break;
            }
          }

          if (busAlreadyAssigned) {
            break;
          }
        }

        if (busAlreadyAssigned) {
          _showAlreadyAssignedDialog();
        } else {
          // Proceed with saving the bus details if no conflicts
          await firestore
              .collection("availableBuses")
              .doc(docName)
              .collection(formattedDate) // Subcollection for the specific date
              .doc(busNumber) // Each bus has its own document with bus number as ID
              .set({
            'selectedSeats': FieldValue.arrayUnion([]),
            'reservedSeats': reservedSeats,
            "timestamp": timestamp,
            "source": source,
            "destination": destination,
            "route": route,
            "time": time,
            "plateNumber": plateNumber,
            "busNumber": busNumber, // Include the bus number
            "driverName": buses.firstWhere(
                (bus) => bus["plateNumber"] == plateNumber)["driverName"],
            "phoneNumber": buses.firstWhere(
                (bus) => bus["plateNumber"] == plateNumber)["phoneNumber"],
          });

          print("Bus $plateNumber assigned successfully.");
        }
      } catch (e) {
        print("Error checking if bus is assigned: $e");
      }
    }
  }

  print("All selected buses have been processed.");
}



void _showConflictingAssignmentDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Bus Conflict Detected"),
        content: const Text(
            "This bus has already been assigned to a different route for the selected date."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}


  /// Show a dialog indicating that the bus is already assigned
  void _showAlreadyAssignedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bus Already Assigned"),
          content: const Text(
              "This bus has already been assigned for the selected date and route."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// Show a dialog asking the user to select a bus
  void _showPleaseSelectBusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Bus Selected"),
          content: const Text("Please select at least one bus to proceed."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Method to reset the screen
void _resetScreen() {
  // Clear the text fields
  sourceController.clear();
  dateController.clear();

  // Reset the selected buses and set them all to false
  setState(() {
    selectedBuses.clear();
    
    // Re-initialize the selectedBuses map with false for each bus
    selectedBuses = {for (var bus in busList) bus["plateNumber"]: false};
    
    selectedBusDetails.clear();
  });
}

}
