import 'package:flutter/material.dart';
import 'package:musicianapp/screens/account/uploadvideo_screen.dart';
import 'package:musicianapp/services/auth_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 100,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadVideoScreen()),
                );
              },
              child: Text('ADD VIDEO'),
            ),
            ElevatedButton(
              onPressed: (){
                AuthService().signOut();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
