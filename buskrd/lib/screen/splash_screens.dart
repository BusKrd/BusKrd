import 'package:buskrd/screen/decisions.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define the zoom-in animation
    _animation = Tween<double>(begin: 0.5, end: 1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the signup screen after a 3-second delay (2 seconds for animation + 1 second hold)
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> DecisionsScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 32, 70),
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
        
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/images/new_logo.png',
              width: 150,
              //height: 300,
            ),
          ),
        ),
      ),
    );
  }
}