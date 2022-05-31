import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/screens/common/ux.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final tecEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final emailRegX = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  bool submitted = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!emailRegX.hasMatch(value)){
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40,),
              Consumer<AuthService>(
                  builder: (context, authService, child){
                    return ElevatedButton(
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          submitted = true;
                          AuthService().resetPassword(tecEmail.text);
                        }
                      },
                      child: (submitted)? ValueListenableProvider<int>.value(
                          value: authService.resetNotifier,
                          child: Consumer<int>(
                              builder: (context, intVal, child){
                                if(intVal == 1){
                                  return const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white,),
                                  );
                                }
                                if(intVal == 3){
                                  UX.showLongToast("");
                                }
                                return const Text("SEND PASSWORD RESET LINK");
                              }
                          )
                      ): const Text("SEND PASSWORD RESET LINK"),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
