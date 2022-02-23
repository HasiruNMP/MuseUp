// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDr_iLswyQTy0rOx3Iej0hWWyaOJm26ufc',
    appId: '1:149470422946:web:0b4c6079ec6e1c15c2b4fb',
    messagingSenderId: '149470422946',
    projectId: 'hnmp-museup',
    authDomain: 'hnmp-museup.firebaseapp.com',
    storageBucket: 'hnmp-museup.appspot.com',
    measurementId: 'G-0PZCF0C1DD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAndpAjO1hPqjLb9qvKo-kBqUZA4OgvErU',
    appId: '1:149470422946:android:10d0227811fbb419c2b4fb',
    messagingSenderId: '149470422946',
    projectId: 'hnmp-museup',
    storageBucket: 'hnmp-museup.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMuUGjckbW2al_5JPB0bl0xPlh9keyyyc',
    appId: '1:149470422946:ios:3eedc0615298e5fec2b4fb',
    messagingSenderId: '149470422946',
    projectId: 'hnmp-museup',
    storageBucket: 'hnmp-museup.appspot.com',
    iosClientId: '149470422946-695rvrfvaebsg86m77s1jnkua4ob97j8.apps.googleusercontent.com',
    iosBundleId: 'com.museup.musicianapp',
  );
}