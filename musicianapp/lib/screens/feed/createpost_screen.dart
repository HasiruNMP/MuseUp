import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/ux.dart';
import 'package:musicianapp/models/post_model.dart';
import 'package:musicianapp/screens/explore/videoplayer_screen.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  final tecText = TextEditingController();
  final tecKeywords = TextEditingController();

  late File file;
  String vPath = 'null';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Post"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: tecText,
                      keyboardType: TextInputType.multiline,
                      maxLines: 12,
                      maxLength: 800,
                      textAlign: TextAlign.justify,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'type your post here',
                        hintText:  'type your post here',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: (){
                            selectFile();
                          },
                          child: Container(
                            height: 240,
                            color: Colors.indigo.shade50,
                            child: Center(
                              child: vPath=='null' ? Text("Attach a Video +") : VideoView(file),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: tecKeywords,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Keywords',
                        hintText:  'separate with commas',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Consumer<FeedModel>(
                      builder: (context, feedModel, child){
                        return ElevatedButton(
                          onPressed: (){
                            feedModel.createPost(tecText.text, tecKeywords.text, vPath);
                          },
                          child: ValueListenableProvider<int>.value(
                            value: feedModel.createPostVal,
                            child: Consumer<int>(
                              builder: (context, intVal, child){
                                if(intVal == 1){
                                  return SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white,),
                                  );
                                }
                                if(intVal == 2){
                                  UX.showLongToast("Post Created Successfully!");
                                  //Navigator.pop(context);
                                }
                                return Text("POST");
                              }
                            )
                          ),
                        );
                      }
                    )
                  ),
                ],
              ),
            ],
          ),
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

}
