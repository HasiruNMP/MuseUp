import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Post"),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: TextFormField(),
          ),
        ),
      ),
    );
  }
}
