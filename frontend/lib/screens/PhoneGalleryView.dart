import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gallery_app/objects/MediaSource.dart';
import 'package:gallery_app/services/MediaUtils.dart';
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
  List<AssetEntity> files = [];
  List<AssetEntity> selectedItems = [];
  Map<int, bool> selectedMap = HashMap();

  final Color shadeGrey = Colors.grey.shade300;
  final Color shadeBlue = Colors.blue.shade50;
  bool isSelectionMode = false;


  Future<void> _fetchAssets() async {
    files = await PhotoManager.getAssetListRange(
        start: 0,
        end: 10000);
    setState(() {

    });
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  void handleUpload(BuildContext context, List<AssetEntity> selectedItems)
  {
    MediaUtils.uploadConfirmation(context: context, selectedItems: selectedItems,
        onSuccess: (String message){
          setState(()  {
            isSelectionMode = false;
            selectedItems = [];
            selectedMap = HashMap();
          });
          var snackBar = SnackBar(content: Text(message.toString()));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
  }


  @override
  Widget build(BuildContext context) {
    IconData selectionIcon = isSelectionMode ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded;

    var appState = context.watch<MyAppState>();
    final Color primaryColor = Theme.of(context).colorScheme.primary;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Storage',),
        actions: [
          if(isSelectionMode) IconButton(
              onPressed: ()  {
                if (selectedItems.isNotEmpty){
                  handleUpload(context, selectedItems);
                }
                },
              icon: Icon(Icons.upload)),
          IconButton(
              onPressed: () {
                setState(() {
                  isSelectionMode = isSelectionMode ? false: true;
                  selectedItems = [];
                  selectedMap = HashMap();
                });
              },
              icon: Icon(selectionIcon),
          )
        ],
        foregroundColor: Colors.white, backgroundColor: primaryColor,),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: appState.auth ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4
          ),
          itemCount: files.length,
          itemBuilder: (_, index){
            return Stack(
              children: [
                AssetThumbnail(
                asset: MediaSource(files[index], "None", "None", 0) ,
              ),
                if(isSelectionMode)AnimatedOpacity(
                  opacity: selectedMap[index] == true ? 1 : 0, duration: const Duration(milliseconds: 100),
                  child: Container(
                    color: primaryColor.withValues(alpha: 0.5),
                    alignment: Alignment.center,
                    child: Icon(Icons.check_circle_rounded, color: shadeBlue,size: 50,),
                  ),
                ),
                if(isSelectionMode)GestureDetector(
                  onTap: (){
                    setState(() {
                      if (selectedMap.containsKey(index)) {
                        selectedMap.remove(index);
                        selectedItems.remove(files[index]);
                      }
                      else {
                        selectedMap[index] = true;
                        selectedItems.add(files[index]);
                      }
                    });
                  },
                ),
              ]
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
