import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/models/user_model.dart';
import 'package:provider/provider.dart';



class AuthService with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //String userID = 'No User';
  int authState = 0;

  Stream<CurrentUser> get onAuthStateChanged => _auth.authStateChanges().map((User? user) => CurrentUser(user!.uid));

  void listenToAuthStateChanges(){
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        authState = 0;
        notifyListeners();
      } else {
        print('User is signed in!');
        authState = 1;
        notifyListeners();
      }
    });
  }

  void signInWithEmail(String email, String password) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void registerWithEmail(String email, String password) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Profile().createUser(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The screens.account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signOut() async{
    await FirebaseAuth.instance.signOut();
    Globals.userID = 'NoUser';
  }

}



