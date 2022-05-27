import 'package:flutter/material.dart';
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
        child: SettingsList(
          lightTheme: const SettingsThemeData(
            settingsListBackground: Colors.white
          ),
          sections: [
            SettingsSection(
              title: const Text('Profile'),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) {
                    print(123);
                  },
                  initialValue: false,
                  leading: const Icon(Icons.format_paint),
                  title: const Text('Only my connections can message'),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Account'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: const Text('English'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {},
                  initialValue: true,
                  leading: const Icon(Icons.format_paint),
                  title: const Text('Enable custom theme'),
                ),
                SettingsTile(
                  title: const Text("Log Out"),
                  onPressed: signOut(),
                  description: const Text("log out of the application"),
                ),
              ],
            ),
          ],
        ),
        /*child: ListView(
          children: [
            ElevatedButton(
              onPressed: (){
                AuthService().signOut();
              },
              child: Text('LOGOUT'),
            ),
          ],
        ),*/
      ),
    );
  }

  Future<void> _signOutAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  dynamic signOut(){
    _signOutAlertDialog();
    //AuthService().signOut();
  }
}
