import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/home/navigation_screen.dart';
import 'package:musicianapp/screens/profile/blocked_screen.dart';
import 'package:musicianapp/screens/profile/set_profile_screen.dart';
import 'package:musicianapp/screens/view_controllers/main_state_controller.dart';


class ProfileStateController extends StatefulWidget {
  final String userID;
  const ProfileStateController(this.userID, {Key? key}) : super(key: key);

  @override
  State<ProfileStateController> createState() => _ProfileStateControllerState();
}

class _ProfileStateControllerState extends State<ProfileStateController> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed){
      ProfileModel().setOnlineStatus(true);
    }else{
      ProfileModel().setOnlineStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
      stream: Globals.usersRef.doc(widget.userID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const LoadingScreen();
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        if(data['profileState'] == 1){
          return const NavigationScreen();
        }else if(data['profileState'] == 9){
          return const BlockedScreen();
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