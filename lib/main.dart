import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crepas Admin',
      theme: ThemeData(colorSchemeSeed: Colors.pink, useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('Crepas Admin App'))),
    );
  }
}
