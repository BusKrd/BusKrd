import 'package:buskrd/authentication.dart';
import 'package:buskrd/screen/verification_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupPageState();
}

class _SignupPageState extends State<Signup> {
  String valueChoose = "";
  List<String> listItem = ["Male", "Female"];

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  PhoneNumber? phoneNumber;

  final PhoneNumberAuth phoneNumberAuth =
      PhoneNumberAuth(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _extraText(),
              const SizedBox(height: 25),
              _inputField(Icons.person, "First name", firstnameController),
              const SizedBox(height: 5),
              _inputField(Icons.person, "Last name", lastnameController),
              const SizedBox(height: 5),
              _inputField(Icons.person, "Age", ageController),
              const SizedBox(height: 5),
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
      child: Row(
        children: [
          const Icon(Icons.man_outlined, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: valueChoose.isNotEmpty && listItem.contains(valueChoose)
                  ? valueChoose
                  : null,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Color.fromARGB(255, 156, 39, 176),
              style: const TextStyle(color: Colors.white),
              hint: const Text(
                "Select Gender",
                style: TextStyle(color: Colors.white),
              ),
              underline: const SizedBox(),
              isExpanded: true,
              items: listItem.map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
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
        ],
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

  Widget _extraText() {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_sharp,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 15,
          ),
          SizedBox(width: 1),
          Text(
            "You must have an account in order to reserve a seat",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
      IconData icon, hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
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
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
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
      onPressed: () async {
        if (phoneNumber != null && phoneNumber!.phoneNumber != null) {
          String countryCode = phoneNumber!.dialCode ?? '';
          String phoneNumberWithoutCode =
              phoneNumber!.phoneNumber!.replaceAll(countryCode, '');

          try {
            await phoneNumberAuth.phoneAuth(
                countryCode, phoneNumberWithoutCode, context);
          } catch (e) {
            Get.snackbar("Error", "Failed to send OTP: ${e.toString()}");
          }
        } else {
          Get.snackbar("Error", "Please enter a valid phone number");
        }
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
}
