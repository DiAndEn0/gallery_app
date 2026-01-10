import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gallery_app/Objects/User.dart';
import 'package:gallery_app/Services/AuthService.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../AppConfig.dart';
import '../objects/MediaItem.dart';

class MediaService {
  static Future<List<MediaItem>?> getMediaList(int page, int limit,) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppConfig.getBaseUrl()}/local/fetch'),
        headers: <String, String> {
          'Content-Type' : 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthService().getCurrentUser()?.token}'
        },
      );
      if (response.statusCode == 200) {
        final itemList = jsonDecode(response.body);
        return getMediaListFromResponse(itemList);
      } else {
        return null;
      }
    } catch (e) {
      print("Error $e");
    }
  }

  static List<MediaItem>? getMediaListFromResponse(List<dynamic> response){
    try {
      List<MediaItem> mediaItems = response.map((currentItem) => MediaItem.fromJson(currentItem)).toList();
      return mediaItems;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}