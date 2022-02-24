//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/screens/chat_screen.dart';
import 'package:musicianapp/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicianapp/screens/login_screen.dart';
import 'package:musicianapp/screens/setprofile_screen.dart';
import 'package:musicianapp/screens/signup_screen.dart';
import 'package:musicianapp/screens/welcome_screen.dart';
import 'services/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MuseUpApp());
}


class MuseUpApp extends StatelessWidget {
  const MuseUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MuseUp',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xFFEFEFEF)
      ),
      home: const HomeView(),
    );
  }
}


