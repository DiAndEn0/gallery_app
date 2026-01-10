import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../Services/AuthService.dart';
import '../objects/MediaSource.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.imageFile,
  });

  final MediaSource imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: imageFile.url == "None" ? FutureBuilder<File>(
          future: imageFile.assetEntity.file.then((value) => value!),
          builder: (_, snapshot){
            final file = snapshot.data;
            if (file == null) return Container();
            return PhotoView(
                imageProvider: FileImage(file)
            );
          }
      ) : PhotoView(
        imageProvider:  CachedNetworkImageProvider(imageFile.url,
          headers: <String, String> {
            'Content-Type' : 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${AuthService().getCurrentUser()?.token}'
          },
      ),
    )
    );
  }
}
