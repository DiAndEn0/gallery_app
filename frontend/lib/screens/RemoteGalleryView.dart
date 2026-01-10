import 'package:flutter/material.dart';
import 'package:gallery_app/Assets/DefaultAppBar.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:gallery_app/objects/MediaItem.dart';
import 'package:gallery_app/services/MediaService.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../Assets/AssetThumbnail.dart';
import '../objects/MediaSource.dart';
import 'HomePageView.dart';


class RemoteGalleryView extends StatefulWidget {


  @override
  State<RemoteGalleryView> createState() => _RemoteGalleryViewState();
}

class _RemoteGalleryViewState extends State<RemoteGalleryView> {
  List<MediaItem>? files = [];
  late Future<List<MediaItem>?> fetched_future_files;
  final Color shadeGrey =  Colors.grey.shade300;
  final Color shadeBlue = Colors.blue.shade50;
  bool isAuthenticated = AuthService().getCurrentUser() != null ? true : false;

  @override
  void initState()  {
    fetched_future_files = MediaService.getMediaList(1, 100);
    super.initState();
  }

  // Future<void> fetchFiles() async {
  //   files = await MediaService.getMediaList(1, 100) ;
  //   if (mounted){
  //     setState(() {
  //       ifFetched = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('Remote Storage',),
        foregroundColor: Colors.white, backgroundColor: primaryColor,),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: isAuthenticated ?  FutureBuilder(future: fetched_future_files, builder: (context, snapshot) {
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
                         asset: MediaSource(AssetEntity(id: "0", typeInt: 0, width: 0, height: 0) ,files![index].downloadUrl, files![index].thumbnailUrl, files![index].duration.toInt()) ,
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
