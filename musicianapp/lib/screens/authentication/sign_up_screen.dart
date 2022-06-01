import 'package:circle_button/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/screens/common/common_widgets.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/15,
              ),
              Text(
                'Create an Account',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
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
                child: TextFormField(
                  controller: tecEmail,
                  decoration: InputDecoration(
                    label: Text('Email'),
                    prefixIcon: Icon(Icons.email_outlined)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: tecPW,
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text('Password'),
                      prefixIcon: Icon(Icons.password_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value != tecRePW.text){
                      return "Passwords don't match";
                    }
                    return null;
                  },
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: tecRePW,
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text('Retype Password'),
                      prefixIcon: Icon(Icons.password)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please retype your password';
                    }
                    if (value != tecPW.text){
                      return "Passwords don't match";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      AuthService().registerWithEmail(tecEmail.text,tecPW.text);
                    }
                  },
                  child: const Text('SIGN UP'),
                  style: flatButtonStyle1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
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
                        onTap: () => {
                        AuthService().signInWithGoogle(context)
                        },
                        tooltip: 'Sign In with Google',
                        width: 40.0,
                        height: 40.0,
                        borderColor: Colors.black,
                        borderWidth: 0.4,
                        borderStyle: BorderStyle.solid,
                        backgroundColor: Colors.transparent,
                        child: const FaIcon(FontAwesomeIcons.google),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleButton(
                        onTap: () => {
                          Navigator.pushReplacementNamed(
                              context, 'sign-in-phone')
                        },
                        tooltip: 'Sign In with Phone',
                        width: 40.0,
                        height: 40.0,
                        borderColor: Colors.black,
                        borderWidth: 0.4,
                        borderStyle: BorderStyle.solid,
                        backgroundColor: Colors.transparent,
                        child: const FaIcon(FontAwesomeIcons.phone),
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




