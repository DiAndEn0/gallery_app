
import 'package:flutter/material.dart';
import 'package:gallery_app/objects/MediaItem.dart';
import 'package:photo_manager/photo_manager.dart';

import 'MediaService.dart';

class MediaUtils {

  static void uploadConfirmation({
    required BuildContext context,
    required List<dynamic> selectedItems,
    required Function(String resultMessage) onSuccess,
  }
      )  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure you want to upload these files?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    showDialog(
                      context: ctx,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );
                    List<String> listResponses= [];
                    if (selectedItems is List<MediaItem>) {
                      // Placeholder
                    }
                    else if (selectedItems is List<AssetEntity>) {
                      listResponses = await MediaService.uploadSelectedItems(selectedItems);
                    }
                    else {
                      print("Unknown item type in selection");
                    }
                    if (!ctx.mounted) return;

                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                    onSuccess(listResponses.toString());
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('No'))
            ],
          );
        }
    );
  }

  static void deleteConfirmation({
    required BuildContext context,
    required List<dynamic> selectedItems,
    required Function(String resultMessage) onSuccess
  })  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove the box?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    showDialog(
                      context: ctx,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );
                    String response = "";
                    if (selectedItems is List<MediaItem>) {
                      response = await MediaService.deleteSelectedItemsHttp(selectedItems);
                    }
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();

                    onSuccess(response);
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('No'))
            ],
          );
        }
    );
  }
}