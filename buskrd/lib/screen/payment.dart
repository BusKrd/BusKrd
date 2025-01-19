import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A5B), // Dark blue background
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sulaymaniyah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Hawler',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Route Information
          Container(width: double.infinity, // Make it fill horizontally
            height: 172, // Adjust height as needed
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 33, 32, 70), // Background color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), // Rounded bottom-left corner
                bottomRight: Radius.circular(30), // Rounded bottom-right corner
              ),
            ),
            child: const Column(
              children: [
                Text(
                  '08:00 AM - 11:00 PM', // Bus time
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Bus 02',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Kirkuk Route',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // Select Payment Method Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select a payment method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),

          // Payment method buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                      // Handle FIB payment method
                      print('Selected FIB');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200], // Light grey background
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'FIB',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                      // Handle FastPay payment method
                      print('Selected FastPay');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200], // Light grey background
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'FastPay',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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


