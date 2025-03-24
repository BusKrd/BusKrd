import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  final String bus;
  final String time;
  final String route;
  final String city1;
  final String city2;
  final String date ;

  const Payment(
      {super.key,
      required this.date,
      required this.bus,
      required this.time,
      required this.route,
      required this.city1,
      required this.city2});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

   void incSeat() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Identify the correct document for the bus route
    String docName = "";
    if (widget.city1 == "Sulaymaniyah" && widget.city2 == "Erbil") {
      docName = "FJ6gDgls0EhZPmq2Sr5e";
    } else if (widget.city1 == "Sulaymaniyah" && widget.city2 == "Kirkuk") {
      docName = "YwiwQPElXpQVeDW5bsow";
    } else {
      print("No valid route found for ${widget.city1} to ${widget.city2}");
      return;
    }

    // Query the bus collection for the correct bus document
    QuerySnapshot querySnapshot = await firestore
        .collection("availableBuses")
        .doc(docName)
        .collection(widget.date)
        .where("busNumber", isEqualTo: widget.bus) // Filter buses by BusNum
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first matching document
      DocumentSnapshot busDoc = querySnapshot.docs.first;
      String busDocId = busDoc.id; // The actual document ID

      print(" Found bus document ID: $busDocId");

      int reservedSeats = busDoc["reservedSeats"] ?? 0;

      // Update the available seats
      await firestore
          .collection("availableBuses")
          .doc(docName)
          .collection(widget.date)
          .doc(busDocId) // Use the found document ID
          .update({
        "reservedSeats": reservedSeats + 1,
      });

      print("Available seats updated successfully.");
    } else {
      print("No matching bus found for BusNum: ${widget.bus}");
    }
  } catch (e) {
    print("🔥 Error updating available seats: $e");
  }
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
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: const Text(
              'Payment',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Route Information
          Container(
            width: double.infinity, // Make it fill horizontally
            height: 180, // Adjust height as needed
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

            child: Column(
              children: [
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.city1, // City 1
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      widget.city2, // City 2
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  widget.time, // Bus time
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.bus, // Bus name
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.route,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Select Payment Method Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select a payment method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Payment method buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 200, // Set a fixed width for both buttons
                    child: ElevatedButton(
                      onPressed: () {
                        
                        incSeat();
                        // Handle FIB payment method
                        print('Selected FIB');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEB958), // Light grey background
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'FIB',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between buttons
                  SizedBox(
                    width: 200, // Set a fixed width for both buttons
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle FastPay payment method
                        print('Selected FastPay');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEB958), // Light grey background
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'FastPay',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
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
