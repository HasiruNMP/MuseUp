
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicianapp/common/globals.dart';

class PostModel with ChangeNotifier {

  Future<void> likePost(String postID) async {
    var one = FirebaseFirestore.instance.collection('posts').doc(postID).update({
      'likedByUIDs': FieldValue.arrayUnion([Globals.userID])
    }).then((value) {
      print("Post Liked");
      Globals.likedPosts.add(postID);

    }).catchError((error) => print("Failed to add user: $error"));
    notifyListeners();
  }

  Future<void> unLikePost(String postID) async {
    var one = FirebaseFirestore.instance.collection('posts').doc(postID).update({
      'likedByUIDs': FieldValue.arrayRemove([Globals.userID])
    }).then((value) {
      print("Post UnLiked");
      Globals.likedPosts.remove(postID);

    }).catchError((error) => print("Failed to add user: $error"));
    notifyListeners();
  }

}