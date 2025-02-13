import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PhoneNumberAuth {
  final FirebaseAuth _auth;
  PhoneNumberAuth(this._auth);
  var verificationid = ''.obs;

  Future<void> phoneAuth(String countryCode, String phoneNumber) async {
    String fullPhoneNumber = '$countryCode$phoneNumber';

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
          Get.offAllNamed('/home'); // Navigate to home after successful verification
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
          Get.toNamed('/verification'); // Navigate to OTP verification screen
        },
        codeAutoRetrievalTimeout: (verificationid) {
          this.verificationid.value = verificationid;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to send OTP: ${e.toString()}");
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationid.value,
          smsCode: otp,
        ),
      );
      return credentials.user != null;
    } catch (e) {
      Get.snackbar("Error", "Failed to verify OTP: ${e.toString()}");
      return false;
    }
  }
}