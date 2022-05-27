import 'package:adminweb/controllers/auth_state_controller.dart';
import 'package:adminweb/services/auth_service.dart';
import 'package:adminweb/services/firebase_options.dart';
import 'package:adminweb/screens/navigation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        Provider(create: (context) => AuthService()),
      ],

      child: MaterialApp(
        title: 'MuseUp Admin Dashboard',
        theme: buildThemeData(),
        home: const AuthStateController(),
      ),

    );
  }

  ThemeData buildThemeData() {
    return ThemeData(
      primarySwatch: Colors.indigo,
    );
  }
}

