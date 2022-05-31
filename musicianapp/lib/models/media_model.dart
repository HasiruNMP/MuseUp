import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/common/ux.dart';
import 'package:musicianapp/services/database_service.dart';
import 'package:musicianapp/services/storage_service.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class MediaModel {

  ValueNotifier<int> uploadNotifier = ValueNotifier(0);

  Future<void> uploadVideo(String? filePath,BuildContext context) async {
    uploadNotifier.value = 1;
    File file = File(filePath!);
    final extension = path.extension(filePath);
    try {
      final ref = await StorageService.instance.ref('users/${Globals.userID}/media/${Globals.userID}${DateTime.now()}.$extension').putFile(file);
      final url = await ref.ref.getDownloadURL();
      addURL(url);
      uploadNotifier.value = 2;
      Navigator.pop(context);
      UX.showLongToast('Your video will be available shortly');
      print(url);
    } on FirebaseException catch (e) {
      print(e);
      uploadNotifier.value = 3;
    }
    uploadNotifier.value = 0;
  }

  Future<void> addURL(String url) {
    return FirebaseFirestore.instance.collection('media').add({
      'type': 'video',
      'userID': Globals.userID,
      'url' : url,
      'time': DateTime.now(),
    }).then((value) => print("url added")).catchError((error) => print("Failed: $error"));
  }


  Future<void> uploadVideoWithFX(String? filePath) async {

    String apiUrl = '';

    DatabaseService.db.collection('api').doc('url').get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      apiUrl = data['url'];

      var request = http.MultipartRequest('POST', Uri.parse('${apiUrl}upload/video-with-fx?userID=${Globals.userID}'));
      request.files.add(await http.MultipartFile.fromPath('video', filePath!));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      }
      else {
      print(response.reasonPhrase);
      }

    },
      onError: (e) => print("Error getting document: $e"),
    );
  }

}