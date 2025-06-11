import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const DiarioViagensApp());
}

class DiarioViagensApp extends StatelessWidget {
  const DiarioViagensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário de viagens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}