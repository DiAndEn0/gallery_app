import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

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
        page = Placeholder();
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

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color shadeGrey =  Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(title: const Text('Local Storage')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                child: Text('Account Details'),
              ),
            ),
            Container(
              //color: Colors.blue.shade50,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.circular(50),
                      color: shadeGrey ,
                      image: DecorationImage(
                        image: AssetImage('images/person-icon.png'),
                        fit: BoxFit.contain,
                        opacity: 0.1,
                      )
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 25,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusGeometry.circular(25),
                          color: shadeGrey,
                        ),
                        child: Text('Guest',
                        textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                      ),
                      Text('example@gmail.com',)
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Login', textAlign: TextAlign.center,),
              tileColor: shadeGrey,
              onTap: () {
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: appState.auth ? Container(

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


