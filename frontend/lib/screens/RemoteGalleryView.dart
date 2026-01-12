import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gallery_app/Assets/DefaultAppBar.dart';
import 'package:gallery_app/Screens/LoginScreenView.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:gallery_app/objects/MediaItem.dart';
import 'package:gallery_app/services/MediaService.dart';
import 'package:gallery_app/services/MediaUtils.dart';
import 'package:photo_manager/photo_manager.dart';
import '../Assets/AssetThumbnail.dart';
import '../objects/MediaSource.dart';

class RemoteGalleryView extends StatefulWidget {


  @override
  State<RemoteGalleryView> createState() => _RemoteGalleryViewState();

}

class _RemoteGalleryViewState extends State<RemoteGalleryView> {
  List<MediaItem>? files = [];
  List<MediaItem> selectedItems = [];
  Map<int, bool> selectedMap = HashMap();
  late Future<List<MediaItem>?> fetchedFiles;
  final Color shadeGrey =  Colors.grey.shade300;
  final Color shadeBlue = Colors.blue.shade50;
  bool isSelectionMode = false;
  bool isAuthenticated = AuthService().getCurrentUser() != null ? true : false;

  @override
  void initState()  {
    fetchedFiles = MediaService.getMediaList(1, 100);
    super.initState();
  }


 void handleDelete(BuildContext context, List<MediaItem> selectedItems){
    MediaUtils.deleteConfirmation(
        context: context,
        selectedItems: selectedItems,
        onSuccess: (String message){
          setState(()  {
            for (MediaItem item in selectedItems){
              files?.remove(files?[files!.indexOf(item)]);
            }
            isSelectionMode = false;
            selectedItems = [];
            selectedMap = HashMap();
          });

          var snackBar = SnackBar(content: Text(message));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
 }



  @override
  Widget build(BuildContext context) {
    IconData selectionIcon = isSelectionMode ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded;

    final Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Storage',),
        foregroundColor: Colors.white, backgroundColor: primaryColor,
      actions: [
        if(isSelectionMode) IconButton(
            onPressed: (){
              if (selectedItems.isNotEmpty){
                handleDelete(context, selectedItems);
              }
            },
            icon: Icon(Icons.delete)),
        IconButton(
            onPressed: () {
              setState(() {
                isSelectionMode = isSelectionMode ? false : true;
                selectedItems = [];
                selectedMap = HashMap();
              });
            },
            icon: Icon(selectionIcon)),
      ],
      ),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: (isAuthenticated) ?  FutureBuilder(future: fetchedFiles, builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                 case ConnectionState.done:
                   files = snapshot.data;
                   return (files != null) ? GridView.builder(
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 4
                     ),
                     itemCount: files?.length,
                     itemBuilder: (_, index){
                       return Stack(
                         children: [
                           AssetThumbnail(
                             asset: MediaSource(
                                 AssetEntity(id: "0", typeInt: 0, width: 0, height: 0) ,files![index].downloadUrl, files![index].thumbnailUrl, files![index].duration.toInt()) ,
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
                                 if (files != null) {
                                 selectedItems.remove(files![index]);
                                 }
                                 } else {
                                 selectedMap[index] = true;
                                 if (files != null) {
                                 selectedItems.add(files![index]);
                                 }
                                 }
                               });
                             },
                           ),
                         ]
                       );
                     },
                   ) : Center(
                     child: Text("No media found", style: TextStyle(fontSize: 18)),
                   );
                 default:
                   return CircularProgressIndicator();
               }
             }
             ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()
                    )
                );
              },
              icon: Icon(
                  Icons.signal_wifi_off_rounded
              ),
              iconSize: 100,
            ),
            Text('Not Connected', style: TextStyle(fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
