import 'package:flutter/material.dart';
import 'package:gallery_app/DefaultAppBar.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

import 'AssetThumbnail.dart';

class RemoteGalleryView extends StatefulWidget {
  const RemoteGalleryView({super.key});

  @override
  State<RemoteGalleryView> createState() => _RemoteGalleryViewState();
}

class _RemoteGalleryViewState extends State<RemoteGalleryView> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Remote Storage',),
        foregroundColor: Colors.white, backgroundColor: primaryColor,),
      drawer: DefaultAppBar(primaryColor: primaryColor),
      body: Center(
        child: Column(
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
