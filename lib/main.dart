import 'package:flutter/material.dart';
import 'telas/tela_splash.dart';

void main() {
  runApp(const ImperialLuxorApp());
}

class ImperialLuxorApp extends StatelessWidget {
  const ImperialLuxorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imperial Luxor',
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: const TelaSplash(),
    );
  }
}