import 'package:flutter/material.dart';
import 'package:musicianapp/models/explore_model.dart';
import 'package:musicianapp/models/post_model.dart';
import 'package:musicianapp/screens/account/uploadphoto_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicianapp/screens/common/mainstatemanager.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:musicianapp/screens/account/welcome_screen.dart';
import 'package:musicianapp/screens/feed/addpost_screen.dart';
import 'package:musicianapp/screens/videos/myvideos_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MuseUpApp());
}

class MuseUpApp extends StatelessWidget {
  const MuseUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Explorer()),
        ChangeNotifierProvider(create: (context) => PostModel()),
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
      '/': (context) => const MainStateManager(),
      'test': (context) => const SetProfileScreen(''),
      'test2': (context) => const WelcomeScreen(),
      'image': (context) => const UploadPhotoScreen(),
      'add-post': (context) => const AddPost(),
      'media': (context) => const MyVideosScreen(),
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
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 0.0,
        color: Colors.white,
      ),
      bottomAppBarColor: Colors.white,
    );
  }
}

