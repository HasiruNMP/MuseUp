import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MyVideosScreen extends StatefulWidget {
  const MyVideosScreen({Key? key}) : super(key: key);

  @override
  State<MyVideosScreen> createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Videos"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          uploadVideo();
        },
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Wrap(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VideoViewer()),
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  void uploadVideo() async{

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    String vPath = result.files.single.path!;
    File file = File(vPath);

    var request = http.MultipartRequest('POST', Uri.parse('https://f2f8-2402-d000-a400-b083-2901-7971-e47b-2cad.ngrok.io/uploads'));
    request.files.add(await http.MultipartFile.fromPath('image',vPath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }

  }

}

class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key}) : super(key: key);

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {

  final videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
  );

  final playerWidget = Chewie(
    controller: ChewieController(
      videoPlayerController: VideoPlayerController.network(
          'https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/users%2FyosJBYpOiVgqDWUZGDaV5pbxs3p2%2Fvideos%2F22222.mp4?alt=media&token=47c604df-dd0c-438f-8647-20017934e2c0'
      ),
      autoPlay: true,
      looping: false,
    ),
  );

  @override
  void initState() {
    videoPlayerController.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: playerWidget,
      ),
    );
  }
}
