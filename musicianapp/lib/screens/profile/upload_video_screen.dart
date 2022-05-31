import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicianapp/screens/common/ux.dart';
import 'package:musicianapp/models/media_model.dart';
import 'package:musicianapp/screens/explore/video_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoScreen extends StatefulWidget {

  final bool atSignup;
  const UploadVideoScreen({required this.atSignup,Key? key}) : super(key: key);

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {

  late File file;
  String vPath = 'null';
  late Subscription _subscription;
  bool submitted = false;
  bool isAudioFxChecked = false;

  @override
  void initState() {
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      //debugPrint('progress: $progress');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.atSignup)? const Text('Add Profile Video') : const Text('Add New Video'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Colors.indigo.shade50,
                child: (vPath=='null')? const Center(child: Text('Upload Your Best Videos!'),) : VideoView(file),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: (){
                      selectFile();
                    },
                    child: const Text('Select Video'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: isAudioFxChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isAudioFxChecked = value!;
                    });
                  },
                ),
                const Text('Add Audio FX',style: TextStyle(fontWeight: FontWeight.bold),),
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.info_outline,size: 20,),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<MediaModel>(
                        builder: (context, mediaModel, child){
                          return ElevatedButton(
                            onPressed: (){
                              submitted = true;
                              if(isAudioFxChecked){
                                mediaModel.uploadVideoWithFX(vPath);
                                Navigator.pop(context);
                                UX.showLongToast('Your video will be available shortly');
                              }else{
                                mediaModel.uploadVideo(vPath,context);
                              }
                            },
                            child: ValueListenableProvider<int>.value(
                                value: mediaModel.uploadNotifier,
                                child: Consumer<int>(
                                    builder: (context, intVal, child){
                                      if(intVal == 1 && submitted){
                                        return const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(color: Colors.white,),
                                        );
                                      }
                                      if(intVal == 2){
                                        //submitted = false;
                                        UX.showLongToast("Uploaded Successfully!");
                                        if(1<1){
                                          //Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                        }else{
                                          //Navigator.pop(context);
                                        }
                                      }
                                      if(intVal == 3){
                                        //submitted = false;
                                        UX.showLongToast("Error!");
                                        //Navigator.pop(context);
                                      }
                                      return const Text("UPLOAD");
                                    }
                                )
                            ),
                          );
                        }
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
    vPath = result.files.single.path!;
    setState(() {
      file = File(vPath);
    });
  }

  @override
  void dispose() {
    _subscription.unsubscribe();
    super.dispose();
  }

}



