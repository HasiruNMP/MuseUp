import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'common.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen(this.url, {Key? key}) : super(key: key);

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
        setState(() {});
      });
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video',
          style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade50,
        foregroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: _controller.value.isInitialized ? VideoPlayer(_controller) : const Center(child: spinKit),
            ),
          ),
          (_controller.value.isInitialized)? Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _controller.value.isPlaying ? (){
                        setState(() {
                          _controller.pause();
                        });
                      } : (){
                        setState(() {
                          _controller.play();
                        });
                      },
                      child: _controller.value.isPlaying ? const Icon(Icons.pause,color: Colors.white,) : const Icon(Icons.play_arrow,color: Colors.white,),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        primary: const Color(0xFF303952),
                        onPrimary: const Color(0xFF40407a),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ): const SizedBox(),
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
