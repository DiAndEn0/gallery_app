import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/VideoView.dart';
import 'package:photo_manager/photo_manager.dart';

import 'ImageView.dart';

class AssetThumbnail extends StatelessWidget{
  const AssetThumbnail({
    super.key,
    required this.asset,
  });

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future:  asset.thumbnailData.then((value) => value!),
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return const CircularProgressIndicator();
        return InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) {
                    if (asset.type == AssetType.image) {
                      return ImageView(
                          imageFile: asset.file
                      );
                    }
                    else {
                      return VideoView(
                        videoFile: asset.file,
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
                if (asset.type == AssetType.video)
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
                        Text('${asset.videoDuration.inMinutes}:${asset.videoDuration.inSeconds}', style: TextStyle(fontSize: 16, color: Colors.white,),),
                      ],
                    ),
                  )
              ]
          ),
        );
      },
    );
  }
}