import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/common/ux.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/account/authentication/forgotpassword_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:circle_button/circle_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _tecEmail = TextEditingController();
  final _tecPW = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
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
                  height: MediaQuery.of(context).size.height / 4,
                  child: Container(
                    child: Image.asset('assets/img/welcome-image.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _tecEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("Email"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _tecPW,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("Password"),
                    ),
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: Consumer<AuthService>(
                        builder: (context, authService, child){
                          return TextButton(
                            style: flatButtonStyle1,
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                authService.signInWithEmail(_tecEmail.text, _tecPW.text);
                                setState((){
                                  submitted = true;
                                });
                              }
                            },
                            child: (submitted)? ValueListenableProvider<int>.value(
                                value: authService.signInNotifier,
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
                                        UX.showLongToast("Logged In Successfully as ${_tecEmail.text}");
                                      }
                                      if(intVal == 4){
                                        UX.showLongToast("No user found with that email!");
                                      }
                                      if(intVal == 5){
                                        UX.showLongToast("wrong password");
                                      }
                                      return Text("SIGN IN");
                                    }
                                )
                            ): const Text("SIGN IN"),
                          );
                        }
                    ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: Text('Forgot Password'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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
                          onTap: () => {AuthService().signInWithGoogle()},
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
      ),
    );
  }
}

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({Key? key}) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final tecPhoneNo = TextEditingController();
  final tecSMSCode = TextEditingController();

  @override
  void initState() {
    tecPhoneNo.text = '+94';
  }

  Future<void> signInWithPhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,

      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verification Failed! Please Try Again."),
          ),
        );
      },

      codeSent: (String verificationId, int? resendToken) async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Enter SMS Code"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: tecSMSCode,
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("DONE"),
                onPressed: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: tecSMSCode.text);
                  //Profile().createUser(credential);
                  await auth.signInWithCredential(credential);
                },
              )
            ],
          ),
        );
      },

      codeAutoRetrievalTimeout: (String verificationId) {},

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In with Your Phone"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/3.5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: TextFormField(
                  controller: tecPhoneNo,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    label: Text('Your Phone Number'),
                    border: OutlineInputBorder(
                    ),
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    signInWithPhone(tecPhoneNo.text);
                  },
                  child: Text('Send Code'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
