import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buskrd/dateInput/date_input.dart';

class EditAsBuses extends StatefulWidget {
  const EditAsBuses({super.key});

  @override
  State<EditAsBuses> createState() => _EditAsBusesState();
}

class _EditAsBusesState extends State<EditAsBuses> {
  TextEditingController dateController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> busList = [];

  @override
  void initState() {
    super.initState();
    dateController.addListener(_fetchBusDataOnDateChange);
  }

  void fetchBusData(String selectedDate) async {
    if (selectedDate.isEmpty) return;

    try {
      QuerySnapshot availableBusesSnapshot =
          await firestore.collection("availableBuses").get();

      List<Map<String, dynamic>> fetchedBuses = [];

      for (var doc in availableBusesSnapshot.docs) {
        CollectionReference dateCollection =
            doc.reference.collection(selectedDate);
        QuerySnapshot dateSnapshot = await dateCollection.get();

        for (var busDoc in dateSnapshot.docs) {
          Map<String, dynamic> busData = busDoc.data() as Map<String, dynamic>;
          fetchedBuses.add(busData);
        }
      }

      setState(() {
        busList = fetchedBuses;
      });
    } catch (e) {
      print("Error fetching bus data: $e");
    }
  }

  void _fetchBusDataOnDateChange() {
    String selectedDate = dateController.text;
    fetchBusData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 39, 176),
      appBar: AppBar(
        title: const Text("Edit Bus Details"),
        backgroundColor: const Color.fromARGB(255, 156, 39, 176),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                DateInput(dateController: dateController),
                const SizedBox(height: 20),
                busList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: busList.length,
                          itemBuilder: (context, index) {
                            var bus = busList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(
                                  '${bus["busNumber"] ?? "No Bus Number"}: ${bus["source"] ?? "Unknown"} to ${bus["destination"] ?? "Unknown"}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Route: ${bus['route'] ?? 'N/A'}"),
                                    Text("Driver: ${bus['driverName'] ?? 'Unknown'}"),
                                    Text("Time: ${bus['time'] ?? 'N/A'}"),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Bus Details - ${bus["busNumber"]}'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Date: ${dateController.text}'),
                                              Text('Time: ${bus['time'] ?? 'N/A'}'),
                                              Text('Route: ${bus['route'] ?? 'N/A'}'),
                                              Text('Destination: ${bus['destination'] ?? 'Unknown'}'),
                                              
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
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
        ],
      ),
    );
  }
}