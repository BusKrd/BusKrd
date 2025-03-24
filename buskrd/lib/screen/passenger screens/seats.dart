import 'package:flutter/material.dart';
import 'package:bus_seat_plan/bus_seat_plan.dart';

class Seats extends StatefulWidget {
  final String bus;
  final String time;
  final String route;
  final String city1;
  final String city2;
  final String date;

  const Seats({
    super.key,
    required this.date,
    required this.bus,
    required this.time,
    required this.route,
    required this.city1,
    required this.city2,
  });

  @override
  State<Seats> createState() => _SeatsState();
}

class _SeatsState extends State<Seats> {
  List<SeatPlanModal> selectedSeats = []; // Ensure this is initialized

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.city1} → ${widget.city2}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Select Your Seat",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: BusSeatPlanWidget(
                seatMap: const [
                  "___s", 
                  "ss__",
                  "ss_s", 
                  "ss_s",
                  "ssss",
                ],
                prefix: 'A',
                bookedSeats: const [], // Ensure it's not null
                selectedSeats: selectedSeats,
                seatSetusColor: SeatStatusColor(
                  bookedColor: Colors.red,
                  canBuyColor: Colors.green,
                  selectedColor: Colors.yellow,
                ),
                clickSeat: (seat) {
                  setState(() {
                    if (selectedSeats.any((s) => s.seatNo == seat.seatNo)) {
                      selectedSeats.removeWhere((s) => s.seatNo == seat.seatNo);
                    } else {
                      selectedSeats.add(seat);
                    }
                  });
                },
                callBackSelectedSeatCannotBuy: (seat) {
                  print("Cannot buy seat: ${seat.seatNo}");
                },
                customTopWidget: (gridCount) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Bus Seat Layout",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                print("Selected Seats: ${selectedSeats.map((s) => s.seatNo).toList()}");
              },
              child: Text("Book ${selectedSeats.length} Seats"),
            ),
          ),
        ],
      ),
    );
  }
}
