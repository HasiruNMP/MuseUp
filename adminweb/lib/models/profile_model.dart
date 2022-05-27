

import 'package:adminweb/screens/ux.dart';
import 'package:adminweb/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {

  static Future<DocumentSnapshot<Map<String, dynamic>>> profileFuture(String userId) {
    return DatabaseService.db.collection('users').doc(userId).get();
  }

  static Future<void> blockProfile(String userId) {
    return DatabaseService.db.collection('users').doc(userId).update({
      'profileState':9
    }).then((value) {
      //print("User Added");
      UX.showLongToast("Profile Blocked!");
    }).catchError((error) {
      //print("Failed to add user: $error");
      UX.showLongToast("Error! Couldn't Block Profile");
    });
  }

}