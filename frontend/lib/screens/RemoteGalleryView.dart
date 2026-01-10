import 'package:flutter/material.dart';
import 'package:gallery_app/Assets/DefaultAppBar.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:gallery_app/objects/MediaItem.dart';
import 'package:gallery_app/services/MediaService.dart';
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

            },
            icon: Icon(Icons.delete)),
        IconButton(
            onPressed: () {
              setState(() {
                isSelectionMode = isSelectionMode ? false : true;
                selectedItems = [];
              });
            },
            icon: Icon(selectionIcon)),
      ],
      ),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: isAuthenticated ?  FutureBuilder(future: fetchedFiles, builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                 case ConnectionState.done:
                   files = snapshot.data;
                   return GridView.builder(
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 4
                     ),
                     itemCount: files?.length,
                     itemBuilder: (_, index){
                       return AssetThumbnail(
                           asset: MediaSource(
                               AssetEntity(id: "0", typeInt: 0, width: 0, height: 0) ,files![index].downloadUrl, files![index].thumbnailUrl, files![index].duration.toInt()) ,
                         );
                     },
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
