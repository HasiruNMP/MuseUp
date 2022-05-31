import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'common.dart';
import 'feed_screen.dart';

class MediaContent extends StatefulWidget {

  final String userID;
  const MediaContent({
    required this.userID,
    Key? key,
  }) : super(key: key);

  @override
  State<MediaContent> createState() => _MediaContentState();
}

class _MediaContentState extends State<MediaContent> {

  //final db = FirebaseFirestore.instance;

  //final Stream<QuerySnapshot> mediaList = FirebaseFirestore.instance.collection("media").where("userID", isEqualTo: widget.userID).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("media").where("userID", isEqualTo: widget.userID).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                return GridView.count(
                  crossAxisCount: 3,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> mediaItemData = document.data()! as Map<String, dynamic>;
                    return SizedBox(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostVideoView(mediaItemData['url'])),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PostVideoView2(mediaItemData['url'])),
                                );
                              },
                              icon: const Icon(Icons.play_arrow_rounded),
                              iconSize: 65,
                              color: Colors.black87.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class PostVideoView2 extends StatefulWidget {
  String link;
  PostVideoView2(this.link, {Key? key}) : super(key: key);

  @override
  _PostVideoView2State createState() => _PostVideoView2State();
}

class _PostVideoView2State extends State<PostVideoView2> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    //_controller.play();
    return Scaffold(
      appBar: AppBar(
        title: Text("Video"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(
                    _controller,
                  ),
                )
                    : const Center(child: spinKit),
              ),
              Container(
                child: Center(
                  child: ElevatedButton(
                    onPressed: _controller.value.isPlaying
                        ? () {
                      setState(() {
                        _controller.pause();
                      });
                    }
                        : () {
                      setState(() {
                        _controller.play();
                      });
                    },
                    child: _controller.value.isPlaying
                        ? const Icon(
                      Icons.pause,
                      color: Colors.white,
                    )
                        : const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      primary: const Color(0xFF303952).withOpacity(0.3),
                      onPrimary: const Color(0xFF40407a).withOpacity(0.3),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void play() {}

  void showProfileView() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}