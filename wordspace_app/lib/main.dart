import 'package:flutter/material.dart';
import 'package:wordspace_app/login.dart';
import 'package:wordspace_app/regsiter.dart';
import 'package:wordspace_app/screens/AdminPanel.dart';
import 'package:wordspace_app/screens/home.dart';
import 'package:wordspace_app/splash.dart';
import 'screens/posts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash(),
      routes: {
        "/home": (context) => Home(),
        "/register": (context) => Register(),
        "/login": (context) => Login(),
        '/admin': (context) => const AdminPanel(),
        // "/details": (context) => Details(),
      },
    );
  }
}
