import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:gallery_app/Screens/HomePageView.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:gallery_app/screens/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
