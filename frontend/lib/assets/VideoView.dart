import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:gallery_app/objects/MediaSource.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';

import '../Services/AuthService.dart';

class VideoView extends StatefulWidget {
  const VideoView({
    super.key,
    required this.videoFile,
  });

  final MediaSource videoFile;

  @override
  State createState() => _VideoViewState();
}


class _VideoViewState extends State<VideoView>{
    VideoPlayerController? _videoPlayerController;
    ChewieController? _chewieController;

  bool codecNotSupported = false;
  bool initialized = false;

  Future<void> _initVideo() async {
    VideoPlayerController? localController;
    try {
      final File? video;
      if (widget.videoFile.url == "None")
        {
          video = await widget.videoFile.assetEntity.file;

          if (video == null){
            return;
          }

          localController = VideoPlayerController.file(video);
        }
      else {
        localController = VideoPlayerController.networkUrl(Uri.parse(widget.videoFile.url),
        httpHeaders:
        <String, String> {
          'Content-Type' : 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthService().getCurrentUser()?.token}'
        },
        );
      }




      await localController.initialize();

      if (!mounted){
        await localController.dispose();
        return;
      }

      setState(() {
        _videoPlayerController = localController;
        _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: true,
            looping: true,
            aspectRatio: _videoPlayerController!.value.aspectRatio
        );
      });

      setState(() {

      });
    } on Exception catch (e) {

      if (localController != null) {
        await localController.dispose();
      }

      if (!mounted) {
        return;
      }


      setState(() {
        codecNotSupported = true;
      });

      if (widget.videoFile.url == "None")
        {
          final video = await widget.videoFile.assetEntity.file;
          if (video != null) {
            _playVideoExternally(video);
          }
        }
    }
  }

  void _playVideoExternally(File file)  {
    OpenFile.open(file.path);
    }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose(){
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: codecNotSupported ? Center(
        child: Text("Playback Error"),
      ) : _chewieController != null &&
          _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(controller: _chewieController!)
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
