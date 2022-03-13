import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/user_model.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/auth/signin_screen.dart';
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
                child: SetProfileScreen(currentUser.userID)
            );

            /*FirebaseFirestore.instance.collection('users').doc(currentUser.userID).get().then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                final data = documentSnapshot.get('profileState');
                print('Document data: ${data}');
                if(data==0){
                  return Provider<CurrentUser>.value(
                      value: currentUser,
                      child: SetProfileScreen()
                  );
                }else{
                  return Provider<CurrentUser>.value(
                      value: currentUser,
                      child: NavigationScreen()
                  );
                }
              }else{
                return const ErrorScreen();
              }
            });*/

          } else {
            return SignInScreen();
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
