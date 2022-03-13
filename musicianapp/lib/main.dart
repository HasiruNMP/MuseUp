//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/models/explore_model.dart';
import 'package:musicianapp/screens/account/setlocation_screen.dart';
import 'package:musicianapp/screens/connections/chat_screen.dart';
import 'package:musicianapp/screens/explore/explore_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicianapp/screens/auth/signin_screen.dart';
import 'package:musicianapp/screens/mainstatemanager.dart';
import 'package:musicianapp/screens/navigation_screen.dart';
import 'package:musicianapp/screens/explore/reportuser_screen.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/auth/signup_screen.dart';
import 'package:musicianapp/screens/welcome_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Explorer()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        //Provider(create: (context) => CurrentUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MuseUp',
        theme: buildThemeData(),
        initialRoute: '/',
        routes: routes(),
      ),
    );
  }

  Map<String, WidgetBuilder> routes() {
    return {
        'test': (context) => const SetLocationScreen(),
        'test2': (context) => const WelcomeScreen(),

        '/': (context) => const MainStateManager(),
        'chat': (context) => const ChatScreen(),
      };
  }

  ThemeData buildThemeData() {
    return ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xFFEFEFEF)
      );
  }
}


