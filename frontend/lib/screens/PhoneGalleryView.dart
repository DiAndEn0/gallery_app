import 'package:flutter/material.dart';
import 'package:gallery_app/objects/MediaSource.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../Assets/AssetThumbnail.dart';
import '../Assets/DefaultAppBar.dart';
import 'HomePageView.dart';

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
              asset: MediaSource(assets[index], "None", "None", 0) ,
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
