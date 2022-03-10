import 'package:flutter/material.dart';
import 'package:musicianapp/screens/navigation_screen.dart';
import 'package:musicianapp/screens/welcome_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class MainStateManager extends StatefulWidget {
  const MainStateManager({Key? key}) : super(key: key);

  @override
  State<MainStateManager> createState() => _MainStateManagerState();
}

class _MainStateManagerState extends State<MainStateManager> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: AuthService().onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          return (snapshot.data != null)? NavigationScreen() : WelcomeScreen();
        }
        return Container(
          child: Center(
            child: Text('ZXC'),
          ),
        );
      }
    );
  }
}
