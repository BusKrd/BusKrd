import 'package:flutter/material.dart';

class Reservation1 extends StatefulWidget {
  const Reservation1({super.key});

  @override
  _Reservation1State createState() => _Reservation1State();
}

class _Reservation1State extends State<Reservation1> {
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController2 = TextEditingController();

  // List of bus options with time intervals
  final List<Map<String, String>> buses = [
    {"bus": "Bus A", "time": "10:00 - 12:00"},
    {"bus": "Bus B", "time": "12:00 - 14:00"},
    {"bus": "Bus C", "time": "14:00 - 16:00"},
    {"bus": "Bus D", "time": "16:00 - 18:00"},
    {"bus": "Bus E", "time": "18:00 - 20:00"},
    {"bus": "Bus F", "time": "20:00 - 22:00"},
  ];

  // Input Field Widget
  Widget _inputField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextField(
      style: const TextStyle(color: Colors.white), // White text color
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white), // White hint text
        enabledBorder: border,
        focusedBorder: border,
        filled: false, // Transparent background
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 70),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
      ),
      body: Column(
        children: [
          // Top Half with rounded bottom corners (now filling horizontally)
          Container(
            width: double.infinity, // Make it fill horizontally
            height: 172, // Adjust height as needed
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 33, 32, 70), // Background color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), // Rounded bottom-left corner
                bottomRight: Radius.circular(30), // Rounded bottom-right corner
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First Input Field (From)
                  _inputField("From", textFieldController1),
                  const SizedBox(height: 10), // Space between text fields
                  // Second Input Field (To)
                  _inputField("To", textFieldController2),
                  const SizedBox(height: 10), // Space between text fields
                ],
              ),
            ),
          ),
          // Bottom Half with list of buses and rounded top corners
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), // Rounded top-left corner
                  topRight: Radius.circular(30), // Rounded top-right corner
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                      height: 20), // Space between container top and title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Select Bus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space after the title
                  Expanded(
                    child: ListView.builder(
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side (Bus number and time interval)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buses[index]["bus"]!, // Bus name
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      buses[index]["time"]!, // Time interval
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                // Right side (Bus icon)
                                const Icon(
                                  Icons.directions_bus, // Bus icon
                                  color: Color.fromARGB(255, 33, 32, 70),
                                  size: 30,
                                ),
                              ],
                            ),
                            onTap: () {
                              // Handle bus selection (for now it just prints)
                              Navigator.pushNamed(context, '/payment');
                            },
                          ),
                        );
                      },
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
