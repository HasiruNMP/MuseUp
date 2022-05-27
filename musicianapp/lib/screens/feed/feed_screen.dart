import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart.';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:intl/intl.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/post_model.dart';
import 'package:musicianapp/screens/feed/createpost_screen.dart';
import 'package:musicianapp/screens/feed/post_screen.dart';
import 'package:musicianapp/screens/explore/explore_screen.dart';
import 'package:musicianapp/screens/explore/videoplayer_screen.dart';
import 'package:musicianapp/screens/feed/search_posts_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

//String str = 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPostsScreen()));
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add-post');
        },
        child: Icon(Icons.post_add),
      ),
      body: FeedContent(
          FirebaseFirestore.instance.collection('posts').snapshots()),
    );
  }
}

class FeedContent extends StatelessWidget {
  Stream<QuerySnapshot<Object?>>? _stream;

  FeedContent(this._stream, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: spinkit,
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
    liked = Globals.likedPosts.contains(widget.postId);
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
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(dateTimeStr),
                            );
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                            ),
                            title: Text(''),
                            subtitle: Text(dateTime.toString()),
                          );
                        },
                      ),
                      onTap: () {
                        print('asd');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person_add_alt_1),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  children: [
                    Text(
                      widget.postData['text'],
                      textAlign: TextAlign.justify,
                    ),
                    (widget.postData['type'] == 'video')
                        ? PostVideoView(widget.postData['videoURL'])
                        : SizedBox(),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: (liked)
                        ? TextButton(
                            onPressed: () {
                              PostModel().unLikePost(widget.postId);
                              setState(() {
                                likesCount -= 1;
                                liked = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                Text(likesCount.toString()),
                              ],
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              PostModel().likePost(widget.postId);
                              setState(() {
                                likesCount += 1;
                                liked = true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.black87,
                                ),
                                Text(likesCount.toString()),
                              ],
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostScreen(
                                  widget.postId,
                                  dateTimeStr,
                                  widget.postData['authorUID'],
                                  name,
                                  userData['imageURL'],
                                  5)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
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
                : const Center(child: spinkit),
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
                    ? Icon(
                        Icons.pause,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(12),
                  primary: Color(0xFF303952), // <-- Button color
                  onPrimary: Color(0xFF40407a), // <-- Splash color
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
