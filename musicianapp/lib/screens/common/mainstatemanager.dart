import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/models/user_model.dart';
import 'package:musicianapp/screens/account/blocked_screen.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/authentication/signin_screen.dart';
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
            Profile().getConnectionsList();
            print(Globals.userID);

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

class _ProfileStateManagerState extends State<ProfileStateManager> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed){
      Profile().setOnlineStatus(true);
    }else{
      Profile().setOnlineStatus(false);
    }
  }

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
          return LoadingScreen();
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        if(data['profileState'] == 1){
          return NavigationScreen();
        }else if(data['profileState'] == 9){
          return BlockedScreen();
        }else{
          return SetProfileScreen(widget.userID);
        }
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
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
            child: SpinKitSpinningLines(
              color: Colors.deepPurple.shade500,
              size: 120.0,
            ),
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
