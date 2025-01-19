import 'package:buskrd/screen/passenger_notification.dart';
import 'package:buskrd/screen/passenger_profile.dart';
import 'package:flutter/material.dart';
import 'package:buskrd/navigators/bottomNavigationBar.dart';
import 'package:buskrd/screen/homepage.dart';
import 'package:buskrd/screen/route.dart';
import 'package:buskrd/dateInput/date_input.dart';

class SeatReservation extends StatefulWidget {
  const SeatReservation({super.key});

  @override
  _SeatReservationState createState() => _SeatReservationState();
}

class _SeatReservationState extends State<SeatReservation> {
  int _selectedIndex = 0;
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController2 = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RouteScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PassengerNotification()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PassengerProfile()),
      );
    }
  }

  // Input field widget to avoid repetition
  Widget _inputField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust for the keyboard
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with rounded edges
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 33, 32, 70),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Smaller Logo

                    Image.asset(
                      'assets/images/new_logo.png', // Correct usage of Image.asset
                      width: 100, // Set a custom width
                      height: 100, // Set a custom height
                    ),

                    const SizedBox(height: 10),
                    _inputField("From", textFieldController1),
                    const SizedBox(height: 10),
                    _inputField("To", textFieldController2),
                  ],
                ),
              ),
            ),

            // Bottom Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: bottomInsets), // Adjust padding for keyboard
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DateInput(dateController: dateController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reservation1');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
