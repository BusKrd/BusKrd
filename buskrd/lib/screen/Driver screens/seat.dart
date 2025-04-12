import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Details extends StatefulWidget {
  final Map<String, dynamic> data;
  final String selectedDate;

  const Details({super.key, required this.data, required this.selectedDate});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<List<String>> seatPattern = [
    ["_", "_", "_", "s"],
    ["s", "s", "_", "_"],
    ["s", "s", "_", "s"],
    ["s", "s", "_", "s"],
    ["s", "s", "s", "s"],
  ];

  String route = "";
  String source = "";
  String destination = "";
  String time = "";
  String busNumber = "";

  List<int> clickedSeats = [];
  List<int> reservedSeats = [];
  String docName = "";

  @override
  void initState() {
    super.initState();
  }

  void setDocNameAndFetchSeats() {
    if (source == "Sulaymaniyah" && destination == "Erbil") {
      docName = "FJ6gDgls0EhZPmq2Sr5e";
    } else if (source == "Sulaymaniyah" && destination == "Kirkuk") {
      docName = "YwiwQPElXpQVeDW5bsow";
    } else {
      print("Invalid route, docName not set");
      return;
    }

    _fetchReservedSeats();
  }

  Future<void> saveSelectedSeats(List<int> selectedSeats) async {
    try {
      await _firestore
          .collection('availableBuses')
          .doc(docName)
          .collection(widget.selectedDate)
          .doc(busNumber)
          .update({
        'selectedSeats': FieldValue.arrayUnion(selectedSeats),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Seats saved successfully!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error saving seats: $e"),
      ));
    }
  }

  Future<void> incSeat() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("availableBuses")
          .doc(docName)
          .collection(widget.selectedDate)
          .where("busNumber", isEqualTo: busNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot busDoc = querySnapshot.docs.first;
        String busDocId = busDoc.id;

        int reservedSeatsCount = busDoc["reservedSeats"] ?? 0;
        int selectedSeatsCount = clickedSeats.length;

        await _firestore
            .collection("availableBuses")
            .doc(docName)
            .collection(widget.selectedDate)
            .doc(busDocId)
            .update({
          "reservedSeats": reservedSeatsCount + selectedSeatsCount,
        });

        print("Reserved seats count updated successfully.");
      } else {
        print("No matching bus found for BusNum: $busNumber");
      }
    } catch (e) {
      print("Error updating reserved seats: $e");
    }
  }

  Future<void> _fetchReservedSeats() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('availableBuses')
          .doc(docName)
          .collection(widget.selectedDate)
          .where("busNumber", isEqualTo: busNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<int> fetchedSeats = [];
        for (var doc in querySnapshot.docs) {
          fetchedSeats.addAll(List<int>.from(doc['selectedSeats'] ?? []));
        }

        if (mounted) {
          setState(() {
            reservedSeats = fetchedSeats;
          });
        }
      }
    } catch (e) {
      print("Error fetching reserved seats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    route = widget.data['route'] ?? 'N/A';
    source = widget.data['source'] ?? 'N/A';
    time = widget.data['time'] ?? 'N/A';
    destination = widget.data['destination'] ?? 'N/A';
    busNumber = widget.data['busNumber'] ?? 'N/A';

    setDocNameAndFetchSeats();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
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
          ),
          title: const Text("Details"),
          centerTitle: true,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                widget.selectedDate,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    source,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.arrow_forward),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    destination,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                route,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                time,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50),
            Column(
              children: seatPattern.asMap().entries.map((entry) {
                int rowIndex = entry.key;
                List<String> row = entry.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.asMap().entries.map((seatEntry) {
                    int seatIndex = seatEntry.key;
                    String seat = seatEntry.value;

                    int seatCounter = rowIndex * row.length + seatIndex + 1;

                    bool isReserved = reservedSeats.contains(seatCounter);

                    if (seat == "_") {
                      return Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    } else {
                      bool isClicked = clickedSeats.contains(seatCounter);

                      return Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.all(6),
                        child: ElevatedButton(
                          onPressed: isReserved
                              ? null
                              : () {
                                  setState(() {
                                    if (!isClicked) {
                                      clickedSeats.add(seatCounter);
                                    } else {
                                      clickedSeats.remove(seatCounter);
                                    }
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isReserved
                                ? Colors.red
                                : isClicked
                                    ? Colors.red
                                    : const Color.fromARGB(255, 0, 255, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                            minimumSize: Size(60, 60),
                          ),
                          child: Icon(Icons.chair_alt_rounded),
                        ),
                      );
                    }
                  }).toList(),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text("Selected"),
                SizedBox(width: 20),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 255, 64),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text("Available"),
              ],
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                incSeat();
                saveSelectedSeats(clickedSeats);
              },
              child: Text("Confirm Selection"),
            ),
          ],
        ),
      ),
    );
  }
}
