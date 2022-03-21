import 'package:circle_button/circle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/services/auth_service.dart';

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
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/15,
            ),
            Text(
              'Create an Account',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/4,
              child: Container(
                child: Image.asset('assets/img/welcome-image.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: MUTextField1(controller: tecEmail,label: 'Email',),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: MUTextField1(controller: tecPW,label: 'Password',),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: MUTextField1(controller: tecRePW,label: 'Retype Password',),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: (){
                  AuthService().registerWithEmail(tecEmail.text,tecPW.text);
                },
                child: const Text('SIGN UP'),
                style: flatButtonStyle1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Text('OR'),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleButton(
                      onTap: () => {},
                      tooltip: 'Sign In with Google',
                      width: 40.0,
                      height: 40.0,
                      borderColor: Colors.black,
                      borderWidth: 0.4,
                      borderStyle: BorderStyle.solid,
                      backgroundColor: Colors.transparent,
                      child: FaIcon(FontAwesomeIcons.google),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleButton(
                      onTap: () => {},
                      tooltip: 'Sign In with Phone',
                      width: 40.0,
                      height: 40.0,
                      borderColor: Colors.black,
                      borderWidth: 0.4,
                      borderStyle: BorderStyle.solid,
                      backgroundColor: Colors.transparent,
                      child: FaIcon(FontAwesomeIcons.phone),
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




