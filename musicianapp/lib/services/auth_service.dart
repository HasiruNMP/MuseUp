import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/models/user_model.dart';
import 'package:musicianapp/screens/common/ux.dart';



class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //String userID = 'No User';
  int authState = 0;

  Future<String?> getCurrentUserId() async {
    String? uid;
    final User? user = _auth.currentUser;
    uid = user?.uid;
    return uid;
  }

  Stream<CurrentUser> get onAuthStateChanged => _auth.authStateChanges().map((User? user) => CurrentUser(user!.uid));

  /*void listenToAuthStateChanges(){
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
  }*/

  ValueNotifier<int> signInNotifier = ValueNotifier(0);

  Future<void> signInWithPhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  Future<void> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
    UX.showLongToast('Signed In using ${user.user?.email}');
    Navigator.pop(context);
    //ProfileModel().createUser(user);
  }

  void signInWithEmail(String email, String password) async{
    signInNotifier.value = 1;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      signInNotifier.value = 3;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        signInNotifier.value = 4;
        print('No user found for that email.');
        UX.showLongToast("No user found with that email!");
      } else if (e.code == 'wrong-password') {
        signInNotifier.value = 5;
        UX.showLongToast("wrong password");
        print('Wrong password provided for that user.');
      }
    }
    //signInNotifier.value = 0;
  }

  void registerWithEmail(String email, String password) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ProfileModel().createUser(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The screens.profile already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


  ValueNotifier<int> resetNotifier = ValueNotifier(0);

  void resetPassword(String email) async {
    resetNotifier.value = 1;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      UX.showLongToast('Email Sent!');
    } on FirebaseAuthException catch (e) {
      resetNotifier.value = 2;
      print(e.code);
      print(e.message);
    }
  }

  void signOut() async{
    await _auth.signOut();
    Globals.userID = 'NoUser';
  }

}



