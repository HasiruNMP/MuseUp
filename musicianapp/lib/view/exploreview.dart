import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/controller.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: const UserInformation(),
    );
  }
}

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('musicians').snapshots();

  //Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: field);
  final geo = Geoflutterfire();
  

  @override
  Widget build(BuildContext context) {
    //setLocation();

    return const VideoApp();
  }
//7.242016, 80.857134
  void setLocation(){
    GeoFirePoint myLocation = geo.point(latitude: 7.206750, longitude: 80.848153);
    GeoFirePoint myLocation1 = geo.point(latitude: 7.195850, longitude: 80.677751);
    GeoFirePoint myLocation2 = geo.point(latitude: 7.201300, longitude: 80.523840);
    GeoFirePoint myLocation3 = geo.point(latitude: 6.955992, longitude: 80.276482);
    GeoFirePoint myLocation4 = geo.point(latitude: 6.235698, longitude: 80.303966);
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation1.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation2.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation3.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation4.data});
  }

  void getData(){
    GeoFirePoint center = geo.point(latitude: 7.242016, longitude: 80.857134);
    double radius = 2;
    String field = 'position';
    var collectionReference = firestore.collection('locations');
    Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: field);
    stream.listen((List<DocumentSnapshot> documentList) {
      for (var document in documentList) {
        print(document.data());
      }
    });
  }
}

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/videos%2F33333.mp4?alt=media&token=8a96a388-dd09-4ada-9646-f9dfba54aa53')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
