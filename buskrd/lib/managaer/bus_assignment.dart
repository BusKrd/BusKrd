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
    fetchCities();
  }

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

  void fetchBusesForCity(String city) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot driversSnapshot =
          await firestore.collection("drivers").get();

      for (var driverDoc in driversSnapshot.docs) {
        DocumentSnapshot busInfoDoc = await firestore
            .collection("drivers")
            .doc(driverDoc.id)
            .collection("info")
            .doc("busInfo")
            .get();

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

          String firstName = driverData["firstName"] ?? "Unknown";
          String lastName = driverData["lastName"] ?? "";
          String fullName = "$firstName $lastName".trim();

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

  Widget _dropdownField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
    );

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
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
                const SizedBox(height: 60),
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
                bool anyBusSelected = selectedBuses.values.contains(true);

                if (!anyBusSelected) {
                  _showPleaseSelectBusDialog();
                } else {
                  String source = sourceController.text.trim();
                  String selectedDate = dateController.text.trim();

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

    DateTime selectedDate = DateTime.parse(dateString);
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    Timestamp timestamp = Timestamp.fromDate(selectedDate);

    print("Formatted date: $formattedDate");

    for (var entry in selectedBuses.entries) {
      if (entry.value) {
        String plateNumber = entry.key;
        Map<String, String> busDetails = selectedBusDetails[plateNumber] ?? {};

        String destination = busDetails["destination"] ?? "";
        String route = busDetails["route"] ?? "";
        String time = busDetails["time"] ?? "";
        int reservedSeats = 0;

        String busNumber = buses.firstWhere(
            (bus) => bus["plateNumber"] == plateNumber)["busNumber"];

        String docName = "";
        if (source == "Sulaymaniyah" && destination == "Erbil") {
          docName = "FJ6gDgls0EhZPmq2Sr5e";
        } else if (source == "Sulaymaniyah" && destination == "Kirkuk") {
          docName = "YwiwQPElXpQVeDW5bsow";
        }

        print("docName: $docName");
        print("formattedDate: $formattedDate");

        if (docName.isEmpty || formattedDate.isEmpty) {
          print("Error: docName or formattedDate is empty!");
          return;
        }

        try {
          QuerySnapshot existingAssignments =
              await firestore.collection("availableBuses").get();

          if (existingAssignments.docs.isEmpty) {
            print("No documents found in availableBuses collection.");
          }

          bool busAlreadyAssigned = false;

          for (var doc in existingAssignments.docs) {
            QuerySnapshot dateAssignmentsSnapshot =
                await doc.reference.collection(formattedDate).get();

            for (var busDoc in dateAssignmentsSnapshot.docs) {
              Map<String, dynamic> busData =
                  busDoc.data() as Map<String, dynamic>;

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
            await firestore
                .collection("availableBuses")
                .doc(docName)
                .collection(formattedDate)
                .doc(busNumber)
                .set({
              'selectedSeats': FieldValue.arrayUnion([]),
              'reservedSeats': reservedSeats,
              "timestamp": timestamp,
              "source": source,
              "destination": destination,
              "route": route,
              "time": time,
              "plateNumber": plateNumber,
              "busNumber": busNumber,
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
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

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
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _resetScreen() {
    sourceController.clear();
    dateController.clear();

    setState(() {
      selectedBuses.clear();

      selectedBuses = {for (var bus in busList) bus["plateNumber"]: false};

      selectedBusDetails.clear();
    });
  }
}
