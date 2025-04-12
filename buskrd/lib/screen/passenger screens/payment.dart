import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  final String bus;
  final String time;
  final String route;
  final String city1;
  final String city2;
  final String date;
  final List<int> selectedSeats;
  final String docName;

  const Payment(
      {super.key,
      required this.date,
      required this.bus,
      required this.time,
      required this.route,
      required this.city1,
      required this.city2,
      required this.selectedSeats,
      required this.docName});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void incSeat() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("availableBuses")
          .doc(widget.docName)
          .collection(widget.date)
          .where("busNumber", isEqualTo: widget.bus)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot busDoc = querySnapshot.docs.first;
        String busDocId = busDoc.id;

        print("Found bus document ID: $busDocId");

        int reservedSeats = busDoc["reservedSeats"] ?? 0;
        int selectedSeatsCount = widget.selectedSeats.length;

        await _firestore
            .collection("availableBuses")
            .doc(widget.docName)
            .collection(widget.date)
            .doc(busDocId)
            .update({
          "reservedSeats": reservedSeats + selectedSeatsCount,
        });

        print("Available seats updated successfully.");
      } else {
        print("No matching bus found for BusNum: ${widget.bus}");
      }
    } catch (e) {
      print("🔥 Error updating available seats: $e");
    }
  }

  Future<void> saveSelectedSeats(List<int> selectedSeats) async {
    try {
      await _firestore
          .collection('availableBuses')
          .doc(widget.docName)
          .collection(widget.date)
          .doc(widget.bus)
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
          Container(
            width: double.infinity,
            height: 180,
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.city1,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      widget.city2,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  widget.time,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.bus,
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select a payment method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        incSeat();

                        saveSelectedSeats(widget.selectedSeats);

                        print('Selected FIB');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEB958),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Selected FastPay');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEB958),
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
