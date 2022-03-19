import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/user_model.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/auth/signin_screen.dart';
import 'package:musicianapp/screens/common/navigation_screen.dart';
import 'package:musicianapp/screens/account/welcome_screen.dart';
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
    final authService = Provider.of<AuthService>(context,listen: false);
    return StreamBuilder<CurrentUser>(

      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){

          final currentUser = snapshot.data;

          if ((currentUser != null)) {
            Globals.userID = currentUser.userID;
            return Provider<CurrentUser>.value(
                value: currentUser,
                child: ProfileStateManager(currentUser.userID),
            );

          } else {
            return WelcomeScreen();
          }
        }
        return Scaffold(
          body: Container(
            child: Center(
              child: Text('ZXC'),
            ),
          ),
        );
      }
    );
  }
}

class ProfileStateManager extends StatefulWidget {
  final String userID;
  ProfileStateManager(this.userID);

  @override
  State<ProfileStateManager> createState() => _ProfileStateManagerState();
}

class _ProfileStateManagerState extends State<ProfileStateManager> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
      stream: Globals.usersRef.doc(widget.userID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        if(data['profileState'] == 1){
          return NavigationScreen();
        }else{
          return SetProfileScreen(widget.userID);
        }
      },
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
        body: Container(
          child: Center(
            child: Text('LOADING...'),
        ),
      ),
    );
  }
}


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('ERROR!!!'),
      ),
    );
  }
}
