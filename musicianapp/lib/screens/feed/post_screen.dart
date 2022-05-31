import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart.';
import 'package:flutter/material.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/feed/feed_screen.dart';
import 'package:musicianapp/services/database_service.dart';
import '../explore/explore_screen.dart';

class PostScreen extends StatefulWidget {
  String postID;
  String time;
  String authorID;
  String name;
  String imageURL;
  int commentsCount;
  PostScreen(this.postID, this.time, this.authorID, this.name, this.imageURL, this.commentsCount);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final tecComment = TextEditingController();

  @override
  void initState() {
    //List a = [widget.postID,widget.time,widget.authorID,widget.name,widget.imageURL,widget.commentsCount];
    //print(a);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('posts').doc(widget.postID).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> postData = snapshot.data!.data() as Map<String, dynamic>;

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
                                          future: DatabaseService.userColRef.doc(postData['authorUID']).get(),
                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text("Something went wrong");
                                            }

                                            if (snapshot.hasData && !snapshot.data!.exists) {
                                              return const Text("Document does not exist");
                                            }

                                            if (snapshot.connectionState == ConnectionState.done) {
                                              Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                                              //String name = userData['fName'];
                                              //imageURL = userData['imageURL'];

                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  backgroundImage: NetworkImage(userData['imageURL']),
                                                ),
                                                title: Text(
                                                  userData['fName']+' '+userData['lName'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(widget.time),
                                              );
                                            }
                                            return ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: Colors.green,
                                              ),
                                              title: const Text(''),
                                              subtitle: Text(widget.time),
                                            );
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(postData['authorUID'])));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        postData['text'],
                                        textAlign: TextAlign.justify,
                                      ),
                                      (postData['type']=='video')? PostVideoView(postData['videoURL']) : const SizedBox(),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: (Globals.likedPosts.contains(widget.postID))? TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.favorite,color: Colors.redAccent,),
                                            Text(postData['likesCount'].toString())
                                          ],
                                        ),
                                      ):TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.favorite_border,color: Colors.black87,),
                                            Text(postData['likesCount'].toString())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return const Text('Loading');
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('posts').doc(widget.postID).collection('comments').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> commentData = document.data()! as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: DatabaseService.userColRef.doc(commentData['UID']).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                          //String name = userData['fName'];
                          //imageURL = userData['imageURL'];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              backgroundImage: NetworkImage(userData['imageURL'],),
                            ),
                            title: Text(
                              userData['fName']+' '+userData['lName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(commentData['text'],style: const TextStyle(
                              color: Colors.black
                            ),),
                          );
                        }
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                          ),
                          title: const Text(''),
                          subtitle: Text(widget.time),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: tecComment,
                    placeholder: 'type your comment here',
                  ),
                ),
                CupertinoButton(
                  child: const Text('Send'),
                  onPressed: (){
                    addComment(widget.postID, tecComment.text);
                    tecComment.clear();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> addComment(String postID,String text) async {
    FirebaseFirestore.instance.collection('posts').doc(postID).collection('comments').add({
      'text': text,
      'UID': Globals.userID,
      'time': DateTime.now(),
    })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
    FirebaseFirestore.instance.collection('posts').doc(postID).update({
      'commentsCount': FieldValue.increment(1),
    })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }
}
