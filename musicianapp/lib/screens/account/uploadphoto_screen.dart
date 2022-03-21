import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/account/uploadvideo_screen.dart';
import 'package:image_crop/image_crop.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;

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
            Expanded(child: ListView(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.deepPurple.shade50.withOpacity(0.5),
                    child: imageSelected? Image.file(file) : Center(child: FaIcon(FontAwesomeIcons.image),),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: selectFile, child: Text('Select image'),),
                    )),
                  ],
                ),
              ],
            )),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (){
                        uploadImage(file.path);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UploadVideoScreen()),
                        );
                      },
                      child: Text('NEXT'),
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

  Future<void> uploadImage(String? filePath) async {
    File file = File(filePath!);
    final extension = p.extension(filePath);
    try {
      final ref = await firebase_storage.FirebaseStorage.instance.ref('users/${Globals.userID}/images/${Globals.userID}${DateTime.now()}.$extension').putFile(file);
      final url = await ref.ref.getDownloadURL();
      print(url);
      Profile().addImageURL(url);
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
