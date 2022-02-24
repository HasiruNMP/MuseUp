import 'package:flutter/material.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Upload your best video that showcases your main role\n\n\n'),
            Text('URL'),
            ElevatedButton(onPressed: (){}, child: Text('select video'),),
            Expanded(child: Container()),
            ElevatedButton(onPressed: (){}, child: Text('UPLOAD'),)
          ],
        ),
      ),
    );
  }
}
