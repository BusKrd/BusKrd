import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:buskrd/screen/Driver%20screens/bus_signup.dart';

class InvitationDriver extends StatefulWidget {
  const InvitationDriver({super.key});

  @override
  _InvitationDriverState createState() => _InvitationDriverState();
}

class _InvitationDriverState extends State<InvitationDriver> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

 // Function to check if the driver exists by the given code
  Future<bool> _checkDriverExistsByCode(String enteredCode) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> driverSnapshot = await FirebaseFirestore
          .instance
          .collection('drivers')
          .doc(enteredCode)
          .get();

      // Return false if driver document does not exist
      return driverSnapshot.exists && driverSnapshot.data() != null;
    } catch (e) {
      print("Error checking driver document: $e");
      return false;
    }
  }

  Future<bool> _checkDriverInfo(String enteredCode) async {
    try {
      CollectionReference infoRef = FirebaseFirestore.instance
          .collection('drivers')
          .doc(enteredCode)
          .collection('info');

      // Fetch busInfo and driverInfo
      DocumentSnapshot busInfoSnapshot = await infoRef.doc('busInfo').get();
      DocumentSnapshot driverInfoSnapshot = await infoRef.doc('driverInfo').get();

      bool hasBusInfo = busInfoSnapshot.exists &&
          busInfoSnapshot.data() != null &&
          (busInfoSnapshot.data() as Map<String, dynamic>).isNotEmpty;

      bool hasDriverInfo = driverInfoSnapshot.exists &&
          driverInfoSnapshot.data() != null &&
          (driverInfoSnapshot.data() as Map<String, dynamic>).isNotEmpty;

      return hasBusInfo && hasDriverInfo;
    } catch (e) {
      print("Error checking info documents: $e");
      return false;
    }
  }



  void _onSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String enteredCode = _codeController.text.trim();

    // Check if the driver exists
    bool isDriverValid = await _checkDriverExistsByCode(enteredCode);
    if (!isDriverValid) {
      setState(() {
        _isLoading = false;
      });
    // If driver is not valid, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid driver code. Please check the code or contact the admin.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop execution here if the code is invalid
    }

     // If the driver exists, check if info (busInfo & driverInfo) exists
    bool isInfoComplete = await _checkDriverInfo(enteredCode);

    setState(() {
      _isLoading = false;
    });

 if (isInfoComplete) {
      // If both busInfo and driverInfo exist → Navigate to HomeDriver screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeDriver()), // Replace with your screen
      );
} else {
      // If either busInfo or driverInfo is missing, navigate to BusSignup
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BusSignup(enteredCode: enteredCode)),
      );
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Invitation Code',
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please get the invitation code from the admin.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 116, 11, 98),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
