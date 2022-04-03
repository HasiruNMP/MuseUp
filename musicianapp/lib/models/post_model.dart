
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicianapp/common/globals.dart';

class PostModel with ChangeNotifier {

  Future<void> likePost(String postID) {
    return FirebaseFirestore.instance.collection('posts').doc(postID).update({
      'likedByUIDs': FieldValue.arrayUnion([Globals.userID])
    }).then((value) {
      print("Post Liked");
      Globals.likedPosts.add(postID);
      notifyListeners();
    }).catchError((error) => print("Failed to add user: $error"));
  }
}