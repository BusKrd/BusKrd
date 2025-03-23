import 'package:buskrd/managaer/managar.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 108, 149),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.business, size: 40),
                    SizedBox(height: 8),
                    Text("Manager", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Total number of buses",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    SizedBox(height: 8),
                    Text("3", style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildCard("Assign buses", Icons.add_chart_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AssignBus()));
                  }),
                  _buildCard("List of drivers", Icons.list_alt, () {
                    print("List of drivers clicked");
                  }),
                  _buildCard("PICKUP", Icons.store, () {
                    print("PICKUP clicked");
                  }),
                  _buildCard("Profile", Icons.person, () {
                    print("Profile clicked");
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
