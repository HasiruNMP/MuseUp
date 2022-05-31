import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/profile/upload_video_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../explore/video_player_screen.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Videos"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          uploadVideo();
        },
      ),
      body: MediaContent(userID: Globals.userID,),
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

                return Wrap(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> mediaItemData = document.data()! as Map<String, dynamic>;
                    return SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VideoView(mediaItemData['url'])),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            children: [
                              FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network('https://picsum.photos/200'),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: (){},
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  iconSize: 65,
                                  color: Colors.black87.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            (widget.userID == Globals.userID)? Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UploadVideoScreen(atSignup: false)),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ): SizedBox()
          ],
        ),
      ),
    );
  }
}

