import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';


class VideoView extends StatefulWidget {
  File file;
  VideoView(this.file, {Key? key}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    //_controller.play();
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: _controller.value.isInitialized ? VideoPlayer(_controller) : const Center(child: Text('Loading'),),
          ),
        ),
        Center(
          child: IconButton(
            onPressed: _controller.value.isPlaying ? (){
              setState(() {
                _controller.pause();
              });
            } : (){
              setState(() {
                _controller.play();
              });
            },
            icon: _controller.value.isPlaying ? const Icon(Icons.pause_outlined,size: 60,) : const Icon(Icons.play_arrow_outlined,size: 60,),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


}