import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class MediaSource {
  final AssetEntity assetEntity;
  final String url;
  final String thumbnailUrl;
  final int duration;

  MediaSource(this.assetEntity, this.url,  this.thumbnailUrl, this.duration);
}