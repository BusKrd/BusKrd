import 'package:flutter/material.dart';
//import 'package:splash_screen/screens/splash_screens.dart';

void main() {
  runApp(const MyApp());
}

// Define the MyApp widget and MaterialApp setup
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: '/', // Start at SplashScreen
      // routes: {
      //   '/': (context) => const SplashScreen(), // Root route
      //   '/signup': (context) => SignIn(), // Route to signup screen
      // },
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SigninPageState();
}

class _SigninPageState extends State<SignIn> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  get isPassword => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 33, 32, 70),
      body: _page(),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 0),
            _HeaderText(),
            const SizedBox(height: 40),
            _extraText(),
            const SizedBox(height: 40),
            _inputField("Phone Number", phoneController),
            const SizedBox(height: 15),
            _inputField("Password", passwordController),
            const SizedBox(height: 50),
            _nextBtn(),
          ],
        ),
      ),
    );
  }

  Widget _HeaderText() {
    return const Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40, color: Colors.white),
    );
  }

  Widget _extraText() {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0), // Add left padding here
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 1), // Add space between the icon and text
          Text(
            "Please enter your phone number and your password to sign \n"
            "in to your account.",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    // Determine if the current field is a password field
    bool isPasswordField = hintText.toLowerCase() == "password";

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPasswordField, // Set to true for password fields
    );
  }

  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.yellow, // Set the background color to yellow
        foregroundColor: Colors.black, // Set the text color to black
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
      child: const SizedBox(
        width: 50,
        child: Text(
          "Sign in",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


