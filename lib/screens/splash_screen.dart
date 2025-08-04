import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
    print("splash built");
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 244, 9), // Flipkart blue
      body: Center(
        child: Image(
          image: AssetImage('assets/images/f3_logo.png'),
          width: 140,
        ),
      ),
    );
  }
}
