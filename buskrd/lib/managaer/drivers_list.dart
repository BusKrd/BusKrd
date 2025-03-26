import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriversList extends StatefulWidget {
  const DriversList({super.key});

  @override
  State<DriversList> createState() => _DriversListState();
}

class _DriversListState extends State<DriversList> {
  TextEditingController plateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> cities = [];
  List<Map<String, dynamic>> drivers = [];
  List<Map<String, dynamic>> filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    fetchPlateNumAccToCity();
    fetchDrivers();
  }

  void fetchPlateNumAccToCity() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc =
          await firestore.collection("cities").doc("kurdistan").get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          cities = List<String>.from(data["city"] ?? []);
        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  void fetchDrivers() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot driversSnapshot = await firestore.collection("drivers").get();
      List<Map<String, dynamic>> tempDrivers = [];

      for (var doc in driversSnapshot.docs) {
        String driverId = doc.id;
        DocumentSnapshot driverInfoSnapshot =
            await firestore.collection("drivers").doc(driverId).collection("info").doc("driverInfo").get();
        DocumentSnapshot busInfoSnapshot =
            await firestore.collection("drivers").doc(driverId).collection("info").doc("busInfo").get();

        if (driverInfoSnapshot.exists && busInfoSnapshot.exists) {
          Map<String, dynamic> driverInfo = driverInfoSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> busInfo = busInfoSnapshot.data() as Map<String, dynamic>;

          if (driverInfo.isNotEmpty && busInfo.isNotEmpty) {
            tempDrivers.add({
              "id": driverId,
              "driverInfo": driverInfo,
              "busInfo": busInfo,
            });
          }
        }
      }

      setState(() {
        drivers = tempDrivers;
        filteredDrivers = tempDrivers;
      });
    } catch (e) {
      print("Error fetching drivers: $e");
    }
  }

  void filterDrivers(String query) {
  List<Map<String, dynamic>> temp = drivers.where((driver) {
    String firstName = driver["driverInfo"]["firstName"]?.toString().toLowerCase() ?? "";
    String lastName = driver["driverInfo"]["lastName"]?.toString().toLowerCase() ?? "";
    String busNumber = driver["busInfo"]["busNumber"]?.toString().toLowerCase() ?? "";
    String plateNumber = driver["busInfo"]["plateNumber"]?.toString().toLowerCase() ?? "";

    // Check if any of the fields match the query
    return firstName.contains(query.toLowerCase()) ||
        lastName.contains(query.toLowerCase()) ||
        busNumber.contains(query.toLowerCase()) ||
        plateNumber.contains(query.toLowerCase());
  }).toList();

  setState(() {
    filteredDrivers = temp;
  });
}


  

 void showDriverDetailsDialog(BuildContext context, Map<String, dynamic> driver) {
  String firstName = driver["driverInfo"]["firstName"] ?? "Unknown";
  String lastName = driver["driverInfo"]["lastName"] ?? "Unknown";
  String age = driver["driverInfo"]["age"]?.toString() ?? "N/A";
  String gender = driver["driverInfo"]["gender"] ?? "N/A";
  String phone = driver["driverInfo"]["phone"] ?? "No phone available";

  String busNumber = driver["busInfo"]["busNumber"] ?? "N/A";
  String plateNumber = driver["busInfo"]["plateNumber"] ?? "N/A";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("$firstName $lastName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("🚗 Driver Info", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("📅 Age: $age"),
            Text("⚧ Gender: $gender"),
            Text("📞 Phone: $phone"),
            const SizedBox(height: 10),
            const Text("🚌 Bus Info", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("🔢 Bus Number: $busNumber"),
            Text("🚍 Plate Number: $plateNumber"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

void filterByCity(String city) {
  Map<String, String> cityPlatePrefixes = {
    "Sulaymaniyah": "21",
    "Erbil": "22",
    "Kirkuk": "23",
    // Add more cities and their corresponding prefixes
  };

  String? prefix = cityPlatePrefixes[city];

  if (prefix != null) {
    List<Map<String, dynamic>> temp = drivers.where((driver) {
      String busPlate = driver["busInfo"]["plateNumber"]?.toString() ?? "";
      return busPlate.startsWith(prefix);
    }).toList();

    setState(() {
      filteredDrivers = temp;
    });
  } else {
    // If city not found in map, show all drivers
    setState(() {
      filteredDrivers = drivers;
    });
  }
}


  Widget _dropdownField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Colors.black),
    );

    return DropdownButtonFormField<String>(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.black),
    enabledBorder: border,
    focusedBorder: border,
  ),
  dropdownColor: Colors.white,
  items: cities.map((String city) {
    return DropdownMenuItem<String>(
      value: city,
      child: Text(city, style: const TextStyle(color: Colors.black)),
    );
  }).toList(),
  onChanged: (String? newValue) {
    if (newValue != null) {
      controller.text = newValue;
      filterByCity(newValue); // 🔥 Filter when city is selected
    }
  },
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 108, 149),
      appBar: AppBar(
        title: const Text("Drivers List", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 108, 108, 149),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dropdownField("Select City Plate", plateController),
            const SizedBox(height: 20),
            TextField(
  controller: searchController,
  decoration: InputDecoration(
    labelText: "Search",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Colors.black),
    ),
  ),
  onChanged: (value) => filterDrivers(value), // Filter as the user types
),

            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDrivers.length,
                itemBuilder: (context, index) {
                  var driver = filteredDrivers[index];
                  String firstName = driver["driverInfo"]["firstName"] ?? "Unknown";
                  String lastName = driver["driverInfo"]["lastName"] ?? "";
                  String fullName = "$firstName $lastName".trim();
                  String busNumber = driver["busInfo"]["plateNumber"] ?? "No Bus Info";

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text("Driver: $fullName"),
                      subtitle: Text("Bus Plate: $busNumber"),
                      leading: const Icon(Icons.person, color: Colors.blue),
                      onTap: () => showDriverDetailsDialog(context, driver),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
