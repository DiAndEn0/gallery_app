import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login/theme.dart';
import 'package:gallery_app/Screens/LoginScreenView.dart';
import 'package:gallery_app/Screens/HomePageView.dart';
import 'package:gallery_app/Services/AuthService.dart';

import '../Objects/User.dart';


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
  bool isAuthenticated = AuthService().getCurrentUser() != null ? true : false;
  User? user = AuthService().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    late String? accountEmail = isAuthenticated ? user?.email : "example@gmail.com";
    late String? accountName = isAuthenticated ? user?.name : "Guest";
    late String? logoCharacter = isAuthenticated ? user?.name?.substring(0, 1) : "G";

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: widget.primaryColor ),
            accountName:  Text(
              accountName!,
              style: TextStyle(fontSize: 18),
            ),
            //Placeholder
            accountEmail:  Text(accountEmail!),
            currentAccountPictureSize: const Size.square(50),
            currentAccountPicture:  CircleAvatar(
              backgroundColor: Color.fromARGB(255, 165, 255, 137),
              child: Text(
                logoCharacter!,
                style: TextStyle(fontSize: 30.0, color: Colors.blue),
              ),
            ),
          ),
          isAuthenticated ? ListTile(
            title: const Text('Logout', textAlign: TextAlign.center,),
            onTap: (){
              setState(() {
                AuthService().logout();
                isAuthenticated = false;
              });
            },
          ):  ListTile(
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
