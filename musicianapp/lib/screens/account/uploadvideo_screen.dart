import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/explore/videoplayer_screen.dart';
import 'package:path/path.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart' as p;

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {

  UploadTask? task;
  late File file;
  String vPath = 'null';
  late Subscription _subscription;

  @override
  void initState() {
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Video'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: vPath=='null' ? Center(child: Text('Upload your best video!'),) : VideoView(file),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: (){
                        selectFile();
                      },
                      child: Text('Select Video'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: (){
                        uploadVideo(file.path);
                      },
                      child: Text('Upload'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,),
                    child: ElevatedButton(
                      onPressed: (){

                        Navigator.of(context).popUntil(ModalRoute.withName('/'));
                      },
                      child: Text('Finish Setup'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void compressVideo() async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
    uploadVideo(mediaInfo!.path);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    vPath = result.files.single.path!;
    setState(() {
      file = File(vPath);
    });
  }

  Future uploadFile() async {

    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'users/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }
  Future<void> uploadVideo(String? filePath) async {
    File file = File(filePath!);
    final extension = p.extension(filePath);
    try {
      final ref = await firebase_storage.FirebaseStorage.instance.ref('users/${Globals.userID}/videos/${Globals.userID}${DateTime.now()}.$extension').putFile(file);
      final url = await ref.ref.getDownloadURL();
      print(url);
      Profile().setProfileState(1);
      Profile().addVideoURL(url);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  @override
  void dispose() {
    _subscription.unsubscribe();
    super.dispose();
  }

}



