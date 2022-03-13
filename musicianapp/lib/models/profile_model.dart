import 'package:flutter/material.dart';
import 'package:musicianapp/common/globals.dart';

class Profile {
  Future<void> addRoleInfo() {
    return Globals.users.doc(Globals.userID).set({
      'isComposer': true,
      'isVocalist': true,
      'isInstrumentalist': true,
      'isProducer': true,
      'genres': '',
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }
}