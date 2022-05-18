import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/screens/account/authentication/forgotpassword_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:circle_button/circle_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        title: Text(''),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/12,
              ),
              Text(
                'Sign In',
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
                child: MUTextField1(controller: _tecEmail,label: 'Email',),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MUTextField1(controller: _tecPW,label: 'Password',),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
                child: TextButton(
                  onPressed: (){
                    AuthService().signInWithEmail(_tecEmail.text,_tecPW.text);
                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                  },
                  child: Text('SIGN IN'),
                  style: flatButtonStyle1,
                ),
              ),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                },
                child: Text('Forgot Password'),
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
      ),
    );
  }
}



