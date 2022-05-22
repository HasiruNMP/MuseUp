import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
      body: MediaContent(),
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

class MediaContent extends StatefulWidget {
  const MediaContent({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaContent> createState() => _MediaContentState();
}

class _MediaContentState extends State<MediaContent> {

  //final db = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> mediaList = FirebaseFirestore.instance
      .collection("media")
      .where("userID", isEqualTo: "123")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: mediaList,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }

            return GridView.count(
              crossAxisCount: 3,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> mediaItemData = document.data()! as Map<String, dynamic>;
                return MediaItem(mediaItemData['url']);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class MediaItem extends StatefulWidget {
  String url;
  MediaItem(this.url);

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});  //when your thumbnail will show.
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<Uint8List?> getThumbnail(String vidUrl) async {
    Uint8List? imgData = await VideoThumbnail.thumbnailData(
      video: vidUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return imgData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width/3,
      child: AspectRatio(
        aspectRatio: 1,
        child: FittedBox(
          fit: BoxFit.cover,
          child: FutureBuilder<Uint8List?>(
            future: getThumbnail(widget.url),
            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot){
              if(snapshot.hasData){
                return Image.memory(snapshot.data!);
              }
              return SizedBox();
            }
          ),
        ),
      ),
    );
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
