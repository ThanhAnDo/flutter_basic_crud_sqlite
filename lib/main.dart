import 'package:flutter/material.dart';
import 'package:flutter_crud_sqlite/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 19, 157, 243)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

