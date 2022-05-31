import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'common.dart';

class FeedContent extends StatelessWidget {
  final Stream<QuerySnapshot<Object?>>? _stream;

  const FeedContent(this._stream, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: spinKit,
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> postData =
            document.data()! as Map<String, dynamic>;
            return FeedListItem(document.id, postData);
          }).toList(),
        );
      },
    );
  }
}

class FeedListItem extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;
  const FeedListItem(this.postId, this.postData, {Key? key}) : super(key: key);

  @override
  State<FeedListItem> createState() => _FeedListItemState();
}

class _FeedListItemState extends State<FeedListItem> {
  String name = "";
  late Timestamp timestamp;
  late DateTime dateTime;
  late String dateTimeStr;
  late Map<String, dynamic> userData;
  late int likesCount;
  late bool liked;

  @override
  void initState() {
    likesCount = widget.postData['likesCount'];
    timestamp = widget.postData['time'];
    dateTime = timestamp.toDate();
    dateTimeStr = DateFormat('dd-MM-yyyy, kk:mm').format(dateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          //height: 300,
          color: Colors.indigo.shade50,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.postData['authorUID'])
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            userData =
                            snapshot.data!.data() as Map<String, dynamic>;

                            name = userData['fName'] + ' ' + userData['lName'];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                backgroundImage:
                                NetworkImage(userData['imageURL']),
                              ),
                              title: Text(
                                userData['fName'] + ' ' + userData['lName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(dateTimeStr),
                            );
                          }
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                            ),
                            title: const Text(''),
                            subtitle: Text(dateTime.toString()),
                          );
                        },
                      ),
                      onTap: () {
                        print('asd');
                      },
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined),
                    ),
                  ),*/
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        widget.postData['text'],
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    (widget.postData['type'] == 'video')
                        ? PostVideoView(widget.postData['videoURL'])
                        : const SizedBox(),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.black87,
                        ),
                        Text(likesCount.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.comment,
                            color: Colors.black87,
                          ),
                          Text(widget.postData['commentsCount'].toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostVideoView extends StatefulWidget {
  String link;
  PostVideoView(this.link, {Key? key}) : super(key: key);

  @override
  _PostVideoViewState createState() => _PostVideoViewState();
}

class _PostVideoViewState extends State<PostVideoView> {
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
    return AspectRatio(
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
