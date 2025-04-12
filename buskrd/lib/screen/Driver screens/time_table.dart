import 'package:buskrd/navigators/driver_bottom_navigation.dart';
import 'package:buskrd/screen/Driver%20screens/driver_notification.dart';
import 'package:buskrd/screen/Driver%20screens/driver_profile.dart';
import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:buskrd/screen/Driver%20screens/seat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTable extends StatefulWidget {
  final String enteredCode;
  const TimeTable({super.key, required this.enteredCode});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  int _selectedIndex = 0;
  Map<String, dynamic>? busInfo;
  Map<String, dynamic>? foundBusData;
  bool isLoading = true;

  List<String> datesWithData = [];
  Map<String, Map<String, dynamic>> busDataMap = {};

  @override
  void initState() {
    super.initState();
    fetchDriverInfo();
  }

  List<DateTime> upcomingDates =
      List.generate(365, (index) => DateTime.now().add(Duration(days: index)));

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeDriver(enteredCode: widget.enteredCode)));
    } else if (index == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DriverNotification(enteredCode: widget.enteredCode)));
    } else if (index == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DriverProfile(enteredCode: widget.enteredCode)));
    }
  }

  Future<void> fetchDriverInfo() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference busInfoRef = firestore
          .collection('drivers')
          .doc(widget.enteredCode)
          .collection('info')
          .doc('busInfo');

      var busSnapshot = await busInfoRef.get();

      if (busSnapshot.exists) {
        busInfo = busSnapshot.data() as Map<String, dynamic>;

        await fetchAvailableBusInfo();
      }
    } catch (e) {
      print("Error fetching driver data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAvailableBusInfo() async {
    if (busInfo == null) {
      print("❌ Missing busInfo.");
      return;
    }

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String busNumber = busInfo!['busNumber'];

      QuerySnapshot availableBusesSnapshot =
          await firestore.collection('availableBuses').get();

      for (var doc in availableBusesSnapshot.docs) {
        for (DateTime date in upcomingDates) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);

          CollectionReference subColRef =
              doc.reference.collection(formattedDate);
          var documents = await subColRef.get();

          for (var busDoc in documents.docs) {
            var data = busDoc.data() as Map<String, dynamic>;

            if (data.containsKey('busNumber') &&
                data['busNumber'] == busNumber) {
              foundBusData = data;
              datesWithData.add(formattedDate);
              busDataMap[formattedDate] = foundBusData!;
              print("🚍 Found Bus Data on $formattedDate: $foundBusData");
            }
          }
        }
      }

      if (datesWithData.isEmpty) {
        print("❌ No matching bus found.");
      }
    } catch (e) {
      print("❌ Error fetching available bus data: $e");
    }
  }

  void showNoDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Data Available"),
        content: Text("There is no bus data available for this date."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

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
          title: const Text("Time Table"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.separated(
            itemCount: upcomingDates.length,
            separatorBuilder: (context, index) =>
                const Divider(thickness: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              String formattedDate =
                  DateFormat('EEEE, MMM d').format(upcomingDates[index]);

              bool hasData = datesWithData.contains(
                  DateFormat('yyyy-MM-dd').format(upcomingDates[index]));

              return Container(
                color: hasData ? Colors.green[100] : Colors.white,
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.purple),
                  title: Text(formattedDate,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Shift details will be here"),
                  onTap: () {
                    if (hasData) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            data: busDataMap[DateFormat('yyyy-MM-dd')
                                .format(upcomingDates[index])]!,
                            selectedDate: DateFormat('yyyy-MM-dd')
                                .format(upcomingDates[index]),
                          ),
                        ),
                      );
                    } else {
                      showNoDataDialog();
                    }
                  },
                ),
              );
            }),
      ),
      bottomNavigationBar: DriverBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
