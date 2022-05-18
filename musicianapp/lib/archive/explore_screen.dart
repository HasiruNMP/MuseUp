import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/*
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({ Key? key }) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {

    final PageController controller = PageController();

    return Scaffold(
      appBar: AppBar(title: const Text('Explore'),),
      body: SafeArea(
        child: PageView(
          controller: controller,
          scrollDirection: Axis.vertical,
          allowImplicitScrolling: true,
          children: [
            VideoApp('https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/videos%2F11111.mp4?alt=media&token=77c0d7fa-b744-4f1d-872c-7df35169221c'),
            VideoApp('https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/videos%2F22222.mp4?alt=media&token=02794153-a1fb-48c1-bc89-353759ea5fb9'),
            VideoApp('https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/videos%2F33333.mp4?alt=media&token=8a96a388-dd09-4ada-9646-f9dfba54aa53'),
          ],
        )
      ),
    );
  }
}

class VideoApp extends StatefulWidget {
  String link;
  VideoApp(this.link, {Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
      ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}*/
