import 'package:flutter/material.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/auth/signin_screen.dart';
import 'package:musicianapp/screens/auth/signup_screen.dart';
import 'package:musicianapp/screens/navigation_screen.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text('SINGUP'),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
                child: const Text('LOGIN'),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NavigationScreen()),
                  );
                },
                child: const Text('HOME'),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetProfileScreen()),
                  );
                },
                child: const Text('SET PROFILE'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
