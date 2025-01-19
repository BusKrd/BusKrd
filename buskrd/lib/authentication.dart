import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberAuth {
  final FirebaseAuth _auth;
  PhoneNumberAuth(this._auth);
  var verificationid = ''.obs;

  Future<void> phoneAuth(
    BuildContext context,
    String countryCode, // Added country code parameter
    String phoneNumber,
  ) async {
    String fullPhoneNumber = '$countryCode$phoneNumber'; // Combine country code with phone number

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar("Error", "The phone number provided is invalid");
        } else {
          Get.snackbar("Error", e.message ?? "Something went wrong, try again");
        }
      },
      codeSent: (verificationid, int? resendtoken) {
        this.verificationid.value = verificationid;
      },
      codeAutoRetrievalTimeout: (verificationid) {
        this.verificationid.value = verificationid;
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationid.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
