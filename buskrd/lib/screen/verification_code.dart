import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buskrd/authentication.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final PhoneNumberAuth phoneNumberAuth;

  const VerificationCodeScreen({
    Key? key,
    required this.phoneNumber,
    required this.phoneNumberAuth,
  }) : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the verification code sent to ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCode() async {
    String verificationCode = _codeController.text.trim();
    if (verificationCode.isEmpty) {
      Get.snackbar('Error', 'Please enter the verification code');
      return;
    }

    try {
      bool isVerified = await widget.phoneNumberAuth.verifyOTP(verificationCode);
      if (isVerified) {
        Get.snackbar('Success', 'Phone number verified successfully');
        // Navigate to the next screen or perform any other action
      } else {
        Get.snackbar('Error', 'Invalid verification code');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify code: ${e.toString()}');
    }
  }
}

