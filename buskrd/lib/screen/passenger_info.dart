import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PassengerAccInfo extends StatefulWidget {
  const PassengerAccInfo({super.key});

  @override
  State<PassengerAccInfo> createState() => _PassengerAccInfoState();
}

class _PassengerAccInfoState extends State<PassengerAccInfo> {
  String valueChoose = "";
  List<String> listItem = ["Male", "Female"];
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
            children: [
              _HeaderText(),
              const SizedBox(height: 25),
              _imageCircle(),
              const SizedBox(height: 25),
              _inputField("First name", firstnameController, "First Name:"),
              const SizedBox(height: 5),
              _inputField("Last name", lastnameController, "Last Name:"),
              const SizedBox(height: 5),
              _inputField("Age", ageController, "Age:"),
              const SizedBox(height: 5),
              _genderDropdown("Gender:"),
              const SizedBox(height: 10),
              _phoneNumberInput("Phone Number:"),
              const SizedBox(height: 10),
              _nextBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderDropdown(String labelText) {
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
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            border: border,
            enabledBorder: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: valueChoose.isNotEmpty && listItem.contains(valueChoose)
                  ? valueChoose
                  : null,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: const Color.fromARGB(255, 233, 30, 99),
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
                  color: Colors.yellow,
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

  Widget _phoneNumberInput(String labelText) {
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
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            border: border,
            enabledBorder: border,
          ),
          child: InternationalPhoneNumberInput(
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
        ),
      ],
    );
  }

  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
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
