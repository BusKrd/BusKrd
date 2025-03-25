import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buskrd/screen/passenger%20screens/payment.dart';
import 'package:flutter/material.dart';

class SeatLayout extends StatefulWidget {
  final String bus;
  final String time;
  final String route;
  final String city1;
  final String city2;
  final String date;
  final String docName;

  const SeatLayout({
    super.key,
    required this.date,
    required this.bus,
    required this.time,
    required this.route,
    required this.city1,
    required this.city2,
    required this.docName,
  });

  @override
  _SeatLayoutState createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  final List<List<String>> seatPattern = [
    ["_", "_", "_", "s"],
    ["s", "s", "_", "_"],
    ["s", "s", "_", "s"],
    ["s", "s", "_", "s"],
    ["s", "s", "s", "s"],
  ];

  // Track clicked seats by their seat number (based on grid)
  List<int> clickedSeats = [];
  List<int> reservedSeats = []; // List to hold seats from Firestore

  @override
  void initState() {
    super.initState();
    _fetchReservedSeats(); // Fetch reserved seats from Firestore
  }

  // Fetch reserved seats from Firestore
  void _fetchReservedSeats() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('availableBuses')
          .doc(widget.docName)
          .collection(widget.date)
          .where("busNumber", isEqualTo: widget.bus)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<int> fetchedSeats = [];
        for (var doc in querySnapshot.docs) {
          fetchedSeats.addAll(List<int>.from(doc['selectedSeats'] ?? []));
        }
        setState(() {
          reservedSeats = fetchedSeats;
        });
      }
    } catch (e) {
      print("Error fetching reserved seats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select a seat",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Seat Layout
              Column(
                children: seatPattern.asMap().entries.map((entry) {
                  int rowIndex = entry.key;
                  List<String> row = entry.value;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: row.asMap().entries.map((seatEntry) {
                      int seatIndex = seatEntry.key;
                      String seat = seatEntry.value;

                      // Calculate seatCounter based on row and column
                      int seatCounter = rowIndex * row.length + seatIndex + 1;

                      // Check if this seat is already reserved (from Firestore)
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
                                      // Toggle clicked state (red or back to grey)
                                      if (!isClicked) {
                                        clickedSeats.add(seatCounter); // Mark seat as clicked (red)
                                      } else {
                                        clickedSeats.remove(seatCounter); // Unclick (reset color)
                                      }
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isReserved
                                  ? Colors.transparent // Red if the seat is reserved
                                  : isClicked
                                      ? Colors.transparent // Change color to red if clicked
                                      : Colors.grey[300], // Default available color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.zero,
                              minimumSize: Size(60, 60),
                            ),
                            child: Icon(Icons.chair_alt_rounded), // Optional: Add any child widget (like icon/text) if needed
                          ),
                        );
                      }
                    }).toList(),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Reserved"),
                  SizedBox(width: 20),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Available"),
                ],
              ),
              SizedBox(height: 60),
              // Confirm Button - Navigate to the next screen
              ElevatedButton(
                onPressed: () {
                  // Pass the selected seats to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payment(
                        selectedSeats: clickedSeats,
                        bus: widget.bus,
                        time: widget.time,
                        route: widget.route,
                        city1: widget.city1,
                        city2: widget.city2,
                        date: widget.date,
                        docName: widget.docName,
                      ),
                    ),
                  );
                },
                child: Text("Confirm Selection"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
