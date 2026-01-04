import 'package:flutter/material.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:gallery_app/screens/HomePageView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await AuthService().tryAutoLogin();
    if (mounted)
      {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomePageView())
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}



