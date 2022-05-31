import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/common/ux.dart';
import 'package:musicianapp/services/database_service.dart';

class ProfileModel with ChangeNotifier {

  static List genderList = ['Male','Female','Other',];
  static List roleList = ['Instrumentalist','Vocalist','Composer','Producer'];
  static List genreList = ['Pop','Classical','Rock', 'Jazz'];
  static List instrumentList = ['Guitar','Piano','Drums', 'Violin','Harp','Cello','Trumpet','Viola','Bass Guitar','Percussion','Flute'];
  static String gender = 'NotSelected';
  DateTime selectedDate = DateTime.now();
  bool success = false;


  Future<void> createUser(UserCredential userCredential) {
    return DatabaseService.db.doc(userCredential.user!.uid).set(
      {
        'email': userCredential.user!.email,
        'profileState':0,
        'fcmToken':'0',
      },
    ).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addPersonalInfo(String fName, String lName, DateTime dob, String gender) async {
    DatabaseService.userColRef.doc(Globals.userID).update({
      'fName': fName,
      'lName': lName,
      'dob': dob,
      'gender': gender,
    }).then((value) {
      print("User Added");
      success = true;
      UX.showLongToast('done');
    }).catchError((error) {
      print("Failed to add user: $error");
      success = false;
      UX.showLongToast('error');
    });
    notifyListeners();
  }

  Future<void> addRoleInfo(String selectedRole, List<bool> mainRole, String instrument, List<String> genres) {
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'isInstrumentalist': mainRole[0],
      'isVocalist': mainRole[1],
      'isComposer': mainRole[2],
      'isProducer': mainRole[3],
      'genres': genres,
      'role': selectedRole,
      'instrument': instrument,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addBio(String bio) {
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'bio': bio,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addLocation(LatLng location,String country,String city) {
    GeoFirePoint geoFirePoint = Geoflutterfire().point(latitude: location.latitude, longitude: location.longitude);
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'location': geoFirePoint.data,
      'country': country,
      'city': city,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> setProfileState(int state) {
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'profileState': state,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addVideoURL(String url) {
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'videoURL': url,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addImageURL(String url) {
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'imageURL': url,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> setOnlineStatus(bool state) {
    return DatabaseService.userColRef.doc(Globals.userID).update({
      'isOnline': state,
    }).then((value) => print("Setting Online Status")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> getConnectionsList() async {
    DatabaseService.userRef.collection('connections')
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            print(doc["connectionUID"]);
            Globals.connectionsMap.putIfAbsent(doc["connectionUID"], () => doc["status"]);
            if(doc["status"]=='accepted'){
              Globals.connectionsList.add(doc["connectionUID"]);
            }
        }
    });
    print(Globals.connectionsMap);
  }

  Future<void> getLikedPostsList() async {
    FirebaseFirestore.instance.collection('posts').where('likedByUIDs',arrayContains: Globals.userID)
      .get()
      .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          print(doc["likedByUIDs"]);
          Globals.likedPosts.add(doc.id);
        }
      });
    print(Globals.likedPosts);
  }

  
}