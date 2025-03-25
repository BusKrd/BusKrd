import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

final List<List<String>> seatPattern = [
    ["_", "_", "_", "s"],
    ["s", "s", "_", "_"],
    ["s", "s", "_", "s"],
    ["s", "s", "_", "s"],
    ["s", "s", "s", "s"],
  ];

  // Track clicked seats by their seat number (based on grid)
  List<int> clickedSeats = [];
  List<int> reservedSeats = []; 
  

 

  

   
  @override
  Widget build(BuildContext context) {
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
                  
                },
                child: Text("Confirm Selection"),
              ),
            ],
          ),
        ),




    );
  }
}