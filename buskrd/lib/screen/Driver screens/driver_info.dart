import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class DriverInformation extends StatefulWidget {
  final String enteredCode;
  const DriverInformation({super.key, required this.enteredCode});

  @override
  State<DriverInformation> createState() => _DriverInformationState();
}

class _DriverInformationState extends State<DriverInformation> {
  String valueChoose = "";
  List<String> listItem = ["Male", "Female"];

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  PhoneNumber? phoneNumber;
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>?> fetchDriverInfo() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(widget.enteredCode)
          .collection('info')
          .doc('driverInfo')
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching driver info: $e");
      return null;
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

  Map<String, dynamic> originalData = {};

  Widget _page() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchDriverInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
              child: Text("Error loading data",
                  style: TextStyle(color: Colors.white)));
        } else {
          Map<String, dynamic> data = snapshot.data!;
          originalData = Map.from(data);

          firstnameController.text = data["firstName"] ?? "";
          lastnameController.text = data["lastName"] ?? "";
          ageController.text = data["age"]?.toString() ?? "";
          valueChoose = data["gender"] ?? "";

          String phoneHint = "";
          if (data["phone"] != null && data["phone"].startsWith("+964")) {
            phoneHint = data["phone"].substring(4);
          }

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _HeaderText(),
                    const SizedBox(height: 25),
                    _imageCircle(),
                    const SizedBox(height: 25),
                    _inputField("First name", firstnameController,
                        "First Name:", data["firstName"] ?? ""),
                    const SizedBox(height: 5),
                    _inputField("Last name", lastnameController, "Last Name:",
                        data["lastName"] ?? ""),
                    const SizedBox(height: 5),
                    _inputField("Age", ageController, "Age:",
                        data["age"]?.toString() ?? ""),
                    const SizedBox(height: 5),
                    _genderDropdown("Gender:", data["gender"] ?? ""),
                    const SizedBox(height: 10),
                    _phoneNumberInput("Phone Number:", phoneHint),
                    const SizedBox(height: 10),
                    saveBtn(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _genderDropdown(String labelText, String selectedGender) {
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
        InputDecorator(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            border: border,
            enabledBorder: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: listItem.contains(valueChoose) ? valueChoose : null,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: const Color.fromARGB(255, 233, 30, 99),
              style: const TextStyle(color: Colors.white),
              hint: Text(
                selectedGender.isNotEmpty ? selectedGender : 'Select Gender',
                style: const TextStyle(color: Colors.white),
              ),
              isExpanded: true,
              items: listItem.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    valueChoose = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _HeaderText() {
    return const Text(
      "Account Information",
      style: TextStyle(
        fontSize: 27,
        color: Colors.white,
      ),
    );
  }

  Widget _imageCircle() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? IconButton(
                      icon: const Icon(
                        Icons.person,
                        size: 50,
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    )
                  : null,
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEB958),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      String labelText, String hintValue) {
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
            hintText: hintValue.isNotEmpty ? hintValue : hintText,
            hintStyle: const TextStyle(color: Colors.white),
            enabledBorder: border,
            focusedBorder: border,
            filled: false,
          ),
        ),
      ],
    );
  }

  Widget _phoneNumberInput(String labelText, String hintText) {
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
        InputDecorator(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            border: border,
            enabledBorder: border,
          ),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() {
                phoneNumber = number;
              });
            },
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: const TextStyle(color: Colors.white),
            textStyle: const TextStyle(color: Colors.white),
            textFieldController: phoneController,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            initialValue: PhoneNumber(isoCode: 'IQ'),
            inputDecoration: InputDecoration(
              hintText: hintText.isNotEmpty ? hintText : 'Phone number',
              hintStyle: const TextStyle(color: Colors.white),
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget saveBtn() {
    return ElevatedButton(
      onPressed: () async {
        await _saveChanges();
      },
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

  Future<void> _saveChanges() async {
    Map<String, dynamic> updatedData = {};

    if (firstnameController.text != (originalData["firstName"] ?? "")) {
      updatedData["firstName"] = firstnameController.text;
    }
    if (lastnameController.text != (originalData["lastName"] ?? "")) {
      updatedData["lastName"] = lastnameController.text;
    }
    if (ageController.text != (originalData["age"]?.toString() ?? "")) {
      updatedData["age"] = int.tryParse(ageController.text) ?? 0;
    }
    if (valueChoose != (originalData["gender"] ?? "")) {
      updatedData["gender"] = valueChoose;
    }
    if (phoneNumber != null &&
        phoneNumber!.phoneNumber != (originalData["phone"] ?? "")) {
      updatedData["phone"] = phoneNumber!.phoneNumber;
    }

    if (updatedData.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No changes detected!")));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(widget.enteredCode)
          .collection('info')
          .doc('driverInfo')
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Changes saved successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error updating data: $e")));
    }
  }
}
