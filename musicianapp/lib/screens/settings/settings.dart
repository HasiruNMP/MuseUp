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
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: SettingsList(
          lightTheme: SettingsThemeData(
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
                  leading: Icon(Icons.format_paint),
                  title: Text('Only my connections can message'),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Account'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  value: Text('English'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {},
                  initialValue: true,
                  leading: Icon(Icons.format_paint),
                  title: Text('Enable custom theme'),
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
}
