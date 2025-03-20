import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const ShanaAI());
}

class ShanaAI extends StatelessWidget {
  const ShanaAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

