import 'dart:convert';
import 'dart:io';

import 'package:gallery_app/Services/AuthService.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:photo_manager/photo_manager.dart';

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
    return null;
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

  static Future<String> deleteSelectedItemsHttp(List<MediaItem> selectedItems) async{
    List<String> selectedStorageKeys = [];
    for (MediaItem item in selectedItems){
      selectedStorageKeys.add(item.storageKey);
    }

    final response = await http.delete(Uri.parse(
        '${AppConfig.getBaseUrl()}/local/delete'),
      headers: <String, String> {
        'Content-Type' : 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthService().getCurrentUser()?.token}'
      },
      body: jsonEncode(selectedStorageKeys)
    );

    return response.body;
  }

  static Future<List<String>> uploadSelectedItems(List<AssetEntity> selectedItems ) async {
    List<MultipartFile> convertedItems = await convertToMultipartFileList(selectedItems);
    List<String> responses = [];
    for (var i = 0; i < convertedItems.length; i += 10){
      int start = i;
      int end = (start + 10) > convertedItems.length ? convertedItems.length : (start + 10);
      final request =  http.MultipartRequest('POST',Uri.parse(
          '${AppConfig.getBaseUrl()}/local/upload')
      )..files.addAll(convertedItems.getRange(start, end))..headers['Authorization'] = 'Bearer ${AuthService().getCurrentUser()!.token!}';

      var response = await request.send();

      if (response.statusCode == 200){
        responses.add("bundle  uploaded");
      }
      else {
        responses.add("bundle  ${response.toString()}");
      }

    }
    return responses;
  }

  static Future<List<MultipartFile>> convertToMultipartFileList(List<AssetEntity> selectedItems) async {
    final List<MultipartFile?> results = await Future.wait(
      selectedItems.map((asset) async {
        final File? originFile = await asset.file;
        if (originFile == null) {
          print("Warning: Could not resolve file for Asset ID: ${asset.id}");
          return null;
        }
        return await MultipartFile.fromPath('files', originFile.path, contentType: MediaType.parse(lookupMimeType(originFile.path) ?? 'image/jpeg'));
      }),
    );
    return results.whereType<MultipartFile>().toList();
    }


  Map<String, dynamic> toJson(List<MultipartFile> rawFiles) =>{
    'files' : rawFiles,
  };

}
