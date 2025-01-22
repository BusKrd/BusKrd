import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  TextEditingController codeController1 = TextEditingController();
  TextEditingController codeController2 = TextEditingController();
  TextEditingController codeController3 = TextEditingController();
  TextEditingController codeController4 = TextEditingController();
  TextEditingController codeController5 = TextEditingController();
  TextEditingController codeController6 = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(right: 55, bottom: 20),
                child: Text(
                  "Enter Verification \nCode",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0, bottom: 25.0),
                child: Text(
                  "Please enter the 6-digit verification code that \nwas sent to your registered phone number.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCodeBox(codeController1, focusNode1, focusNode2),
                  const SizedBox(width: 8),
                  _buildCodeBox(codeController2, focusNode2, focusNode3),
                  const SizedBox(width: 8),
                  _buildCodeBox(codeController3, focusNode3, focusNode4),
                  const SizedBox(width: 8),
                  _buildCodeBox(codeController4, focusNode4, focusNode5),
                  const SizedBox(width: 8),
                  _buildCodeBox(codeController5, focusNode5, focusNode6),
                  const SizedBox(width: 8),
                  _buildCodeBox(codeController6, focusNode6, null),
                ],
              ),
              const SizedBox(height: 50),
              _resendButton(),
              // const SizedBox(height: 20),
              // _submitButton(),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildCodeBox(TextEditingController controller, FocusNode focusNode,
      FocusNode? nextFocusNode) {
    return SizedBox(
      width: 40, // Reduced width
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.yellow),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        onSubmitted: (value) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }

  Widget _resendButton() {
    return TextButton(
      onPressed: () {
        print("Resend code requested");
        Navigator.pushNamed(context, '/driver');
      },
      child: RichText(
        text: const TextSpan(
          text: 'Resend Code',
          style: TextStyle(
            color: Colors.yellow,
            decoration: TextDecoration.underline,
            decorationThickness: 2.5,
          ),
        ),
      ),
    );
  }
}
