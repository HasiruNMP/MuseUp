import 'package:adminweb/models/user_model.dart';
import 'package:adminweb/screens/auth_screen.dart';
import 'package:adminweb/screens/navigation_screen.dart';
import 'package:adminweb/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AuthStateController extends StatefulWidget {
  const AuthStateController({Key? key}) : super(key: key);

  @override
  State<AuthStateController> createState() => _AuthStateControllerState();
}

class _AuthStateControllerState extends State<AuthStateController> {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context,listen: false);

    //changes the state of the application after sign in and sign out
    return StreamBuilder<CurrentUser>(
        stream: authService.onAuthStateChanged, //authentication changes stream
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            final currentUser = snapshot.data;
            if ((currentUser != null)) {
              return const NavigationScreen();
            } else {
              return const AuthScreen();
            }
          }
          return const LoadingScreen();
        }
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.deepPurple.shade500,
          size: 120.0,
        ),
      ),
    );
  }
}


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Service is Not Available! Try Later'),
    );
  }
}