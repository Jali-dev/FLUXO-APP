import 'package:flutter/material.dart';

void main() {
  runApp(const FluxoApp());
}

class FluxoApp extends StatelessWidget {
  const FluxoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluxo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Fluxo Initialized')),
      ),
    );
  }
}
