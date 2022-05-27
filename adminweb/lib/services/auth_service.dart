import 'package:adminweb/models/user_model.dart';
import 'package:adminweb/screens/ux.dart';
import 'package:adminweb/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<CurrentUser> get onAuthStateChanged => _auth.authStateChanges().map((User? user) => CurrentUser(user!.uid));

  void signIn(String username, String password) async{

    String email = username + '@museup.me';

    DatabaseService.db.collection("employees").doc(email).get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          UX.showLongToast("Invalid Username");
          //print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          UX.showLongToast("Wrong Password");
          //print('Wrong password provided for that user.');
        }
      }
    },
      onError: (e) {
        //print("Error getting document: $e");
        UX.showLongToast("Invalid Username");
      },
    );
  }

  void signOut() async{
    await _auth.signOut();
  }

}


