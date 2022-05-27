import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/screens/account/authentication/signin_screen.dart';
import 'package:musicianapp/screens/account/authentication/signup_screen.dart';

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
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
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
                        textStyle: const TextStyle(
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
                              textStyle: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Join Our Community',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
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
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: flatButtonStyle1,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                                  );
                                },
                                child: const Text('LOGIN'),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: flatButtonStyle1,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );
                                },
                                child: const Text('CREATE ACCOUNT'),                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
