import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:musicianapp/common/globals.dart';

class Profile {

  static List genderList = ['Male','Female','Other',];
  static List roleList = ['Instrumentalist','Vocalist','Composer','Producer'];
  static List genreList = ['Pop','Classical','Rock', 'Jazz'];
  static List instrumentList = ['Guitar','Piano','Drums', 'Violin','Harp','Cello','Trumpet','Viola','Bass Guitar','Percussion','Flute'];
  static String gender = 'NotSelected';
  DateTime selectedDate = DateTime.now();


  Future<void> addUser(String name, DateTime dob, String gender) {
    return Globals.usersRef.doc(Globals.userID).update({
      'name': name,
      'dob': dob,
      'gender': gender,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addRoleInfo(List<bool> mainRole, String instrument, List<String> genres) {
    return Globals.usersRef.doc(Globals.userID).update({
      'isInstrumentalist': mainRole[0],
      'isVocalist': mainRole[1],
      'isComposer': mainRole[2],
      'isProducer': mainRole[3],
      'genres': genres,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addBio(String bio) {
    return Globals.usersRef.doc(Globals.userID).update({
      'bio': bio,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addLocation(LatLng location) {
    GeoFirePoint geoFirePoint = Geoflutterfire().point(latitude: location.latitude, longitude: location.longitude);
    return Globals.usersRef.doc(Globals.userID).update({
      'location': geoFirePoint.data,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> setProfileState(int state) {
    return Globals.usersRef.doc(Globals.userID).update({
      'profileState': state,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addVideoLink(String url) {
    return Globals.usersRef.doc(Globals.userID).update({
      'videoLink': url,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }


}