import 'package:flutter/material.dart';
import 'package:gallery_app/Assets/DefaultAppBar.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:gallery_app/objects/MediaItem.dart';
import 'package:gallery_app/services/MediaService.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../Assets/AssetThumbnail.dart';
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
  bool ifFetched =false;

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
    var appState = context.watch<MyAppState>();

    final Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('Remote Storage',),
        foregroundColor: Colors.white, backgroundColor: primaryColor,),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             FutureBuilder(future: fetched_future_files, builder: (context, snapshot) {
               switch (snapshot.connectionState){
                 case ConnectionState.none:
                   return Text("none");
                 case ConnectionState.done:
                   return Text(snapshot.data!.first.downloadUrl);
                 case ConnectionState.waiting:
                   return Text("waiting");
                 case ConnectionState.active:
                   return Text("Actively waiting");
                 }
             } ),
            // appState.userAuth? PagedGridView(
            //     pagingController: pagingController,
            //     builderDelegate: PagedChildBuilderDelegate<dynamic>(
            //       animateTransitions: true,
            //         itemBuilder: (_, item, index) => AssetThumbnail(asset: item)
            //     ),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 4
            //     ),
            // ) :
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
