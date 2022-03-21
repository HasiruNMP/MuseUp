import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/account/uploadphoto_screen.dart';
import 'package:musicianapp/screens/account/user_screen.dart';
import 'package:musicianapp/screens/account/signin_screen.dart';
import 'package:musicianapp/screens/account/signup_screen.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/common/navigation_screen.dart';
import 'package:musicianapp/services/auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container()
            ),
            Expanded(
              flex: 1,
              child: Text(
                'MuseUp',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Image.asset('assets/img/welcome-image.png'),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Create Music Together',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Join Our Community',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 17,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          style: flatButtonStyle1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInScreen()),
                            );
                          },
                          child: Text('LOGIN'),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          style: flatButtonStyle1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: Text('CREATE ACCOUNT'),                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
