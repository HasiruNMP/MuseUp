import 'package:adminweb/screens/navigation_screen.dart';
import 'package:adminweb/screens/reports_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuseUp Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReportsScreen(),
    );
  }
}

