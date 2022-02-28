import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Video'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Upload your best video that showcases your main role\n\n\n'),
              Container(
                width: 180,
                height: 320,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
              ),
              ElevatedButton(onPressed: (){}, child: Text('select video'),),
              ElevatedButton(onPressed: (){}, child: Text('UPLOAD'),)
            ],
          ),
        ),
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
  late VideoPlayerController _controller,
  UploadTask? task;
  File? file;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    //_controller.play();
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
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
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

}