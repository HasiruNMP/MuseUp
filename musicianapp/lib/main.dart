//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/models/explore_model.dart';
import 'package:musicianapp/screens/account/setlocation_screen.dart';
import 'package:musicianapp/screens/account/uploadphoto_screen.dart';
import 'package:musicianapp/screens/connections/chat_screen.dart';
import 'package:musicianapp/screens/connections/connections_screen.dart';
import 'package:musicianapp/screens/explore/explore_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicianapp/screens/authentication/signin_screen.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/common/mainstatemanager.dart';
import 'package:musicianapp/screens/common/navigation_screen.dart';
import 'package:musicianapp/screens/explore/reportuser_screen.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/authentication/signup_screen.dart';
import 'package:musicianapp/screens/account/welcome_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
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
      'test': (context) => SetProfileScreen(''),
      'test2': (context) => const WelcomeScreen(),
      'image': (context) => const UploadPhotoScreen(),
      '/': (context) => const MainStateManager(),
    };
  }

  ThemeData buildThemeData() {
    return ThemeData(
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 0.0,
        color: Colors.white,
      ),
      bottomAppBarColor: Colors.white,
    );
  }
}

