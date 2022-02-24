import 'package:flutter/material.dart';
import 'package:musicianapp/screens/home_screen.dart';
import 'package:musicianapp/screens/login_screen.dart';
import 'package:musicianapp/screens/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){
                  SignUpScreen();
                },
                child: const Text('SINGUP'),
              ),
              ElevatedButton(
                onPressed: (){
                  LoginScreen();
                },
                child: const Text('LOGIN'),
              ),
              ElevatedButton(
                onPressed: (){
                  HomeView();
                },
                child: const Text('HOME'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
