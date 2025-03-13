import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buskrd/screen/Driver%20screens/signup_driver.dart';

class BusSignup extends StatefulWidget {
  const BusSignup({super.key});

  @override
  _BusSignupState createState() => _BusSignupState();
}

class _BusSignupState extends State<BusSignup> {
  final TextEditingController busNumberController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();

  /// Check if busNumber or plateNumber already exists in Firestore
  Future<bool> isBusInfoUnique(String busNumber, String plateNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('BusInformation')
        .where('busNumber', isEqualTo: busNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return false; // Bus Number already exists
    }

    final plateQuerySnapshot = await FirebaseFirestore.instance
        .collection('BusInformation')
        .where('plateNumber', isEqualTo: plateNumber)
        .get();

    if (plateQuerySnapshot.docs.isNotEmpty) {
      return false; // Plate Number already exists
    }

    return true; // Both are unique
  }

  Future<void> addBusInfoToFirestore() async {
    String busNumber = busNumberController.text.trim();
    String plateNumber = plateNumberController.text.trim();

    if (busNumber.isEmpty || plateNumber.isEmpty) {
      Get.snackbar("Error", "Both fields are required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    bool isUnique = await isBusInfoUnique(busNumber, plateNumber);
    if (!isUnique) {
      Get.snackbar("Error", "Bus Number or Plate Number already exists",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // Add the unique bus information to Firestore
      await FirebaseFirestore.instance.collection('BusInformation').add({
        'busNumber': busNumber,
        'plateNumber': plateNumber,

      });

      Get.snackbar("Success", "Bus Information Added",
          backgroundColor: Colors.green, colorText: Colors.white);

      // Clear the fields after saving
      busNumberController.clear();
      plateNumberController.clear();

      // Navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupDriver()),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to add data: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 150,
                  child: Image.asset(
                    'assets/images/new_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Driver',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: busNumberController,
                      decoration: InputDecoration(
                        labelText: 'Bus Number',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: plateNumberController,
                      decoration: InputDecoration(
                        labelText: 'Plate Number',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addBusInfoToFirestore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 116, 11, 98),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
