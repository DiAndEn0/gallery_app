import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/Assets/VideoView.dart' hide VideoView;
import 'package:gallery_app/objects/MediaSource.dart';
import 'package:photo_manager/photo_manager.dart';

import '../Services/AuthService.dart';
import 'ImageView.dart';
import 'VideoView.dart';

class AssetThumbnail extends StatelessWidget{
  const AssetThumbnail({
    super.key,
    required this.asset,
  });

  final MediaSource asset;

  @override
  Widget build(BuildContext context) {
    return asset.url.contains("None") ? FutureBuilder<Uint8List>(
      future:  asset.assetEntity.thumbnailData.then((value) => value!),
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return const CircularProgressIndicator();
        return InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) {
                    if (asset.assetEntity.type == AssetType.image) {
                      return ImageView(
                          imageFile: asset
                      );
                    }
                    else {
                      return VideoView(
                        videoFile: asset,
                    );

                    }}
              ),
            );
          },
          child: Stack(
              children: [
                Positioned.fill(
                    child: Image.memory(bytes, fit: BoxFit.cover,)
                ),
                if (asset.assetEntity.type == AssetType.video)
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsetsDirectional.only(end: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text('${asset.assetEntity.videoDuration.inMinutes}:${asset.assetEntity.videoDuration.inSeconds}', style: TextStyle(fontSize: 16, color: Colors.white,),),
                      ],
                    ),
                  )
              ]
          ),
        );
      },
    ) :
    InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) {
                if (asset.url == asset.thumbnailUrl) {
                  return ImageView(
                      imageFile: asset
                  );
                }
                else {
                  return VideoView(
                    videoFile: asset,
                  );

                }}
          ),
        );
      },
      child: Stack(
          children: [
            Positioned.fill(
                child: CachedNetworkImage(
                    imageUrl:  "${asset.thumbnailUrl}?type=${asset.url != asset.thumbnailUrl ? "thumbnail" : "original"}",
                  httpHeaders: <String, String> {
                  'Content-Type' : 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer ${AuthService().getCurrentUser()?.token}'
                },
                fit: BoxFit.cover,
                )
            ),
            if (asset.url != asset.thumbnailUrl)
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsetsDirectional.only(end: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text('${asset.duration ~/ 60}:${asset.duration % 60}', style: TextStyle(fontSize: 16, color: Colors.white,),),
                  ],
                ),
              )
          ]
      ),
    );
  }
}