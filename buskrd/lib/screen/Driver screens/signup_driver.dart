import 'package:buskrd/screen/Driver%20screens/homeDriver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignupDriver extends StatefulWidget {
  final String enteredCode;
  const SignupDriver({super.key, required this.enteredCode});

  @override
  State<SignupDriver> createState() => _SignupDriverState();
}

class _SignupDriverState extends State<SignupDriver> {
  String valueChoose = "";
  List<String> listItem = ["Male", "Female"];

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  PhoneNumber? phoneNumber;

  
      
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
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: _page(),
      ),
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
            children: [
              const SizedBox(height: 0),
              _HeaderText(),
              const SizedBox(height: 25),
              _inputField("First name", firstnameController),
              const SizedBox(height: 10),
              _inputField("Last name", lastnameController),
              const SizedBox(height: 10),
              _inputField("Age", ageController),
              const SizedBox(height: 10),
              _genderDropdown(),
              const SizedBox(height: 10),
              _phoneNumberInput(),
              const SizedBox(height: 10),
              _nextBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButton<String>(
        value: valueChoose.isNotEmpty && listItem.contains(valueChoose)
            ? valueChoose
            : null,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: const Color.fromARGB(255, 33, 32, 70),
        style: const TextStyle(color: Colors.white),
        hint: const Text(
          "Select Gender",
          style: TextStyle(color: Colors.white),
        ),
        underline: const SizedBox(),
        isExpanded: true,
        items: listItem.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              valueChoose = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _HeaderText() {
    return const Text(
      "Create account",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 30, color: Colors.white),
    );
  }



  Widget _inputField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
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
        filled: false,
      ),
    );
  }

  Widget _phoneNumberInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() {
                phoneNumber = number;
              });
            },
            onInputValidated: (bool value) {
              print(value ? 'Valid phone number' : 'Invalid phone number');
            },
            
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: const TextStyle(color: Colors.white),
            textStyle: const TextStyle(color: Colors.white),
            
            initialValue: PhoneNumber(isoCode: 'IQ'),
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            inputDecoration: const InputDecoration(
              hintText: 'Phone number',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: () {
        saveDriverInfo(widget.enteredCode);
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40),
      ),
      child: const SizedBox(
        width: 32,
        child: Text(
          "Next",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> saveDriverInfo(String enteredCode) async {
  String firstName = firstnameController.text.trim();
  String lastName = lastnameController.text.trim();
  String age = ageController.text.trim();
  String gender = valueChoose;
  String phone = phoneNumber?.phoneNumber ?? "";

  if (firstName.isEmpty || lastName.isEmpty || age.isEmpty || gender.isEmpty || phone.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill in all fields")),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection('drivers') // Change this to your correct collection
        .doc(enteredCode)
        .collection('info')
        .doc('driverInfo')
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'phone': phone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Driver information saved successfully!")),
    );

    // Navigate to HomeDriver
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeDriver()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving data: $e")),
    );
  }
}

  }
