import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/services/storage_service.dart';
import 'package:path/path.dart' as path;

class MediaModel {

  ValueNotifier<int> uploadNotifier = ValueNotifier(0);

  Future<void> uploadVideo(String? filePath) async {
    uploadNotifier.value = 1;
    File file = File(filePath!);
    final extension = path.extension(filePath);
    try {
      final ref = await StorageService.instance.ref('users/${Globals.userID}/media/${Globals.userID}${DateTime.now()}.$extension').putFile(file);
      final url = await ref.ref.getDownloadURL();
      uploadNotifier.value = 2;
      print(url);
    } on FirebaseException catch (e) {
      print(e);
      uploadNotifier.value = 3;
    }
    uploadNotifier.value = 0;
  }


}