import 'package:flutter/material.dart';
import 'package:musicianapp/models/explore_model.dart';
import 'package:musicianapp/models/media_model.dart';
import 'package:musicianapp/models/post_model.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/authentication/sign_in_screen.dart';
import 'package:musicianapp/screens/profile/set_location_map_screen.dart';
import 'package:musicianapp/screens/profile/upload_photo_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicianapp/screens/view_controllers/main_state_controller.dart';
import 'package:musicianapp/screens/profile/set_profile_screen.dart';
import 'package:musicianapp/screens/profile/welcome_screen.dart';
import 'package:musicianapp/screens/feed/create_post_screen.dart';
import 'package:musicianapp/screens/media/media_screen.dart';
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
        Provider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProfileModel()),
        Provider(create: (context) => FeedModel()),
        Provider(create: (context) => MediaModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MuseUp',
        theme: themeData(),
        routes: routes(),
        initialRoute: '/',
      ),
    );
  }

  Map<String, WidgetBuilder> routes() {
    return {
      '/': (context) => const MainStateController(),
      'test': (context) => const SetProfileScreen(''),
      'test2': (context) => const WelcomeScreen(),
      'image': (context) => const UploadPhotoScreen(),
      'add-post': (context) => const CreatePostScreen(),
      'media': (context) => const MediaScreen(),
      //'upload-video': (context) => UploadVideoScreen(),
      'sign-in-phone': (context) => const SignInWithPhone(),
      'set-location-map': (context) => const SetLocationMapScreen(),
    };
  }

  ThemeData themeData() {
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

