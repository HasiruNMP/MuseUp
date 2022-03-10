import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:musicianapp/common/common_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _tecEmail = TextEditingController();
  final _tecPW = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/4,),
              MUTextField1(controller: _tecEmail,label: 'Email',),
              MUTextField1(controller: _tecPW,label: 'Password',),
              ElevatedButton(
                onPressed: (){
                  AuthService().signInWithEmail(_tecEmail.text,_tecPW.text);
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                child: Text('Sign in with Email'),
              ),
              ElevatedButton(
                onPressed: (){
                  //signInWithEmail('hasirunmp@gmail.com', '123qwe');
                },
                child: Text('Sign In with Google'),
              )
            ],
          ),
        ),
      ),
    );
  }
}



