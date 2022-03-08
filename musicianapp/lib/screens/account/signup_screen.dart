import 'package:flutter/material.dart';
import 'package:musicianapp/common/common_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
            CommonTextField(label: 'Email Address'),
            CommonTextField(label: 'Password'),
            CommonTextField(label: 'Retype Password'),
            CommonButton(label: 'SIGN UP WITH EMAIL', function: (){}),
            CommonButton(label: 'SIGN UP WITH GOOGLE', function: (){})
          ],
        ),
      ),
    );
  }
}


