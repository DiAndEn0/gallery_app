import 'dart:core';
import 'dart:ffi';



class MediaItem {

  final String fileName;

  final int size;

  final String storageKey;

  final String downloadUrl;

  final String fileType;

  final double duration;

  String thumbnailUrl;

  MediaItem(this.fileName, this.size, this.storageKey, this.downloadUrl,  this.fileType,this.duration, this.thumbnailUrl);

  MediaItem.fromJson(Map<String, dynamic> json):
      fileName = json['fileType'],
      size = json['size'],
      storageKey = json['storageKey'],
      downloadUrl = json['downloadUrl'],
      fileType = json['fileType'],
      duration = json['duration'],
      thumbnailUrl = json['thumbnailUrl'];
}
