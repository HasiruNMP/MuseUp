import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musicianapp/common/common_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final tecEmail = TextEditingController();
  final tecPW = TextEditingController();
  final tecRePW = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            MUTextField1(controller: tecEmail,label: 'Email',),
            MUTextField1(controller: tecPW,label: 'Password',),
            MUTextField1(controller: tecRePW,label: 'Retype Password',),
            ElevatedButton(
              onPressed: (){
                registerWithEmail();
              },
              child: const Text('SIGN UP WITH EMAIL'),
            ),
            ElevatedButton(
              onPressed: (){
                //signInWithGoogle();
              },
              child: const Text('SIGN UP WITH GOOGLE'),
            ),
          ],
        ),
      ),
    );
  }

  void registerWithEmail() async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: tecEmail.text,
          password: tecPW.text,
      );
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



}




