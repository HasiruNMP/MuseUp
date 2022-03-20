import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/screens/account/uploadvideo_screen.dart';
import 'package:image_crop/image_crop.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {

  late String imagePath;
  late File file;
  bool imageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Profile Picture'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(child: imageSelected? Image.file(file) : Center(child: Text('Select an Image'),),),
            ElevatedButton(onPressed: selectFile, child: Text('Select image'),),
            ElevatedButton(onPressed: (){}, child: Text('CROP'),),
            ElevatedButton(onPressed: (){
              uploadFile2(file.path);
            }, child: Text('UPLOAD'),),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadVideoScreen()),
                );
              },
              child: Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    imagePath = result.files.single.path!;

    setState(() {
      file = File(imagePath);
      imageSelected = true;
    });

  }

  Future<File> compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  Future<void> uploadFile2(String? filePath) async {
    File file = File(filePath!);
    try {
      final ref = await firebase_storage.FirebaseStorage.instance.ref('uploads/prpic.jpg').putFile(file);
      final url = await ref.ref.getDownloadURL();
      print(url);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

}

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({Key? key}) : super(key: key);

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
