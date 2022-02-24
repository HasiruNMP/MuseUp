import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:musicianapp/services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/4,),
              Text('EMAIL'),
              CommonTextField(),
              Text('PASSWORD'),
              CommonTextField(),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    signInWithEmail('hasirunmp@gmail.com', '123qwe');
                  },
                  child: Text('LOGIN'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 20,
      decoration: const InputDecoration(
        //icon: Icon(Icons.favorite),
        labelStyle: TextStyle(
          color: Color(0xFF6200EE),
        ),
        /*suffixIcon: Icon(
          Icons.check_circle,
        ),*/
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
    );
  }
}


