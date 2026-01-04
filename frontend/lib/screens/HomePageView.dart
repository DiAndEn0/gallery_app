import 'package:flutter/material.dart';
import 'package:gallery_app/Assets/DefaultAppBar.dart';
import 'package:gallery_app/Screens/LoginScreenView.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../Assets/AssetThumbnail.dart';
import 'PhoneGalleryView.dart';
import 'RemoteGalleryView.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Gallery App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var auth = false;

  void toggleAuth(){
    auth = true;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = PhoneGallery();
        break;
      case 1:
        page = RemoteGalleryView();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // The body is just the page content now
          body: Container(
            color: Theme
                .of(context)
                .colorScheme
                .primaryContainer,
            child: page,
          ),
          // The navigation moves to the dedicated bottom property
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Local',
              ),
              NavigationDestination(
                icon: Icon(Icons.computer),
                label: 'Remote',
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        );
      },
    );
  }
}



