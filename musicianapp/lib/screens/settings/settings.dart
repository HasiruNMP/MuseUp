import 'package:flutter/material.dart';
import 'package:musicianapp/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ElevatedButton(onPressed: (){
              AuthService().signOut();
            }, child: Text('LOGOUT'))
          ],
        ),
      ),
    );
  }
}
