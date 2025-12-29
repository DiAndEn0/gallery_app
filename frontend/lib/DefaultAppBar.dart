import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DefaultAppBar extends StatelessWidget {
   DefaultAppBar({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor ),
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
              //Need to do logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
