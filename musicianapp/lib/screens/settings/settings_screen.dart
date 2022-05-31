import 'package:flutter/material.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:settings_ui/settings_ui.dart';

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
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text('Account',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),)
            ),
            ListTile(
              title: Text('Sign Out'),
              subtitle: ElevatedButton(
                onPressed: (){
                  _signOutAlertDialog();
                },
                child: Text('SIGN OUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOutAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to sign out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                AuthService().signOut();
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
