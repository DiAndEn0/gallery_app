import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:gallery_app/Screens/LoginScreenView.dart';
import 'package:gallery_app/Screens/HomePageView.dart';


class DefaultAppBar extends StatefulWidget {
   DefaultAppBar({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  bool loginScreen = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: widget.primaryColor ),
            accountName: const Text(
              //PLaceholder
              "Guest",
              style: TextStyle(fontSize: 18),
            ),
            //Placeholder
            accountEmail: const Text("example@gmail.com"),
            currentAccountPictureSize: const Size.square(50),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 165, 255, 137),
              child: Text(
                //Placeholder
                "G",
                style: TextStyle(fontSize: 30.0, color: Colors.blue),
              ),
            ),
          ),
          ListTile(
            title: const Text('Login', textAlign: TextAlign.center,),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()
                  )
              );
            }
          )
        ],
      ),
    );
  }
}
