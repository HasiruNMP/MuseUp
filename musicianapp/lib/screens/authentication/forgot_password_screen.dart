import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final tecEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Enter your email address. \nYou will receive an email to reset your password.',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: tecEmail,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            ElevatedButton(
              onPressed: (){
                AuthService().resetPassword(tecEmail.text);
              },
              child: const Text('SEND PASSWORD RESET LINK'),
            ),
          ],
        ),
      ),
    );
  }
}
