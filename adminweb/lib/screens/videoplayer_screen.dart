import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  String url;
  VideoPlayerScreen(this.url, {Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
      ),
      body: Stack(
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
              icon: _controller.value.isPlaying ? Icon(Icons.pause_outlined,size: 60,) : Icon(Icons.play_arrow_outlined,size: 60,),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

}
