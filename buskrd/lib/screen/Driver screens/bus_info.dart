import 'package:flutter/material.dart';

class BusInformation extends StatefulWidget {
  const BusInformation({super.key});

  @override
  State<BusInformation> createState() => _BusInformationState();
}

class _BusInformationState extends State<BusInformation> {
  TextEditingController busNumController = TextEditingController();
  TextEditingController plateNumController = TextEditingController();
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
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: _page(),
          ),
        ),
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _HeaderText(),
              const SizedBox(height: 50),
              _inputField("Bus number", busNumController, "Bus number:"),
              const SizedBox(height: 5),
              _inputField("Plate number", plateNumController, "Plate number:"),
              const SizedBox(height: 10),
              _nextBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _HeaderText() {
    return const Text(
      "Bus Information",
      style: TextStyle(
        fontSize: 27,
        color: Colors.white,
      ),
    );
  }

  Widget _inputField(
      String hintText, TextEditingController controller, String labelText) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
            enabledBorder: border,
            focusedBorder: border,
            filled: false,
          ),
        ),
      ],
    );
  }

  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: const Color(0xFFFEB958),
        padding: const EdgeInsets.symmetric(horizontal: 30),
      ),
      child: const SizedBox(
        width: 90,
        child: Text(
          "Save Changes",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
