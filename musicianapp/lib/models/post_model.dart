
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicianapp/globals/globals.dart';

class FeedModel {
  ValueNotifier<int> createPostVal = ValueNotifier(0);

  Future<void> createPost(String text, String keywords, String filePath) async {
    createPostVal.value = 1;

    String videoUrl = 'none';
    String type = 'text';

    if(filePath != 'null'){
      type = 'video';
      File file = File(filePath);
      final extension = p.extension(filePath);
      try {
        final ref = await FirebaseStorage.instance.ref('users/${Globals.userID}/media/${Globals.userID}${DateTime.now()}.$extension').putFile(file);
        videoUrl = await ref.ref.getDownloadURL();
        print(videoUrl);
      } on FirebaseException {
        createPostVal.value = 4;
      }
    }

    FirebaseFirestore.instance.collection('posts').add({
      'authorUID': Globals.userID,
      'text': text,
      'type': type,
      'time': DateTime.now(),
      'videoURL': videoUrl,
      'keywords': keywords.split(','),
      'likesCount': 0,
      'commentsCount': 0,
    }).then((value) {
      print("Post Liked");
      createPostVal.value = 2;
    }).catchError((error) {
      print("Failed to add user: $error");
      createPostVal.value = 3;
    });
  }
}

class PostModel with ChangeNotifier {

  Future<void> likePost(String postID) async {
    var one = FirebaseFirestore.instance.collection('posts').doc(postID).update({
      'likedByUIDs': FieldValue.arrayUnion([Globals.userID]),
      'likesCount' : FieldValue.increment(1),
    }).then((value) {
      print("Post Liked");
      Globals.likedPosts.add(postID);

    }).catchError((error) => print("Failed to add user: $error"));
    //notifyListeners();
  }

  Future<void> unLikePost(String postID) async {
    var one = FirebaseFirestore.instance.collection('posts').doc(postID).update({
      'likedByUIDs': FieldValue.arrayRemove([Globals.userID]),
      'likesCount' : FieldValue.increment(-1),
    }).then((value) {
      print("Post UnLiked");
      Globals.likedPosts.remove(postID);

    }).catchError((error) => print("Failed to add user: $error"));
    //notifyListeners();
  }

}