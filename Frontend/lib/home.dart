import 'package:flutter/material.dart';
import 'package:gallery_app/DefaultAppBar.dart';
import 'package:gallery_app/RemoteGalleryView.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

import 'AssetThumbnail.dart';

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

class PhoneGallery extends StatefulWidget {

  @override
  State<PhoneGallery> createState() => _PhoneGalleryState();
}

class _PhoneGalleryState extends State<PhoneGallery> {
  List<AssetEntity> assets = [];
  final Color shadeGrey =  Colors.grey.shade300;
  final Color shadeBlue = Colors.blue.shade50;

  Future<void> _fetchAssets() async {
    assets = await PhotoManager.getAssetListRange(
        start: 0,
        end: 10000);
    setState(() {

    });
  }

  @override
    void initState(){
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final Color primaryColor = Theme.of(context).colorScheme.primary;


    return Scaffold(
      appBar: AppBar(title: const Text('Local Storage',),
      foregroundColor: Colors.white, backgroundColor: primaryColor,),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: appState.auth ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4
          ),
          itemCount: assets.length,
          itemBuilder: (_, index){
            return AssetThumbnail(
              asset: assets[index],
            );
          },
        ) : IconButton(
            onPressed: (){
              PhotoManager.requestPermissionExtend().then(
                  (PermissionState state) {
                    if (state.isAuth){
                      setState(() {
                         appState.toggleAuth();
                      }
                      );
                    }
                  },
              );
            },
            icon: Icon(
              Icons.lock_reset_rounded
            ),
          iconSize: 100,
        ),
      ),
    );
  }
}


