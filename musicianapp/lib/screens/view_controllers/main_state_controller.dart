import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/models/user_model.dart';
import 'package:musicianapp/screens/profile/welcome_screen.dart';
import 'package:musicianapp/screens/view_controllers/profile_state_controller.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:musicianapp/services/notifications_service.dart';
import 'package:provider/provider.dart';

class MainStateController extends StatefulWidget {
  const MainStateController({Key? key}) : super(key: key);

  @override
  State<MainStateController> createState() => _MainStateControllerState();
}

class _MainStateControllerState extends State<MainStateController> {

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

    }
  }

  @override
  void initState() {
    requestPermission();
    loadFCM();
    listenFCM();
    Notifications.getFCMToken();
    Notifications.listenToFCMToken();
    super.initState();
  }

  Future<void> preLoadData() async {
    ProfileModel().getConnectionsList();
    ProfileModel().getLikedPostsList();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context,listen: false);

    //changes the state of the application after sign in and sign out
    return StreamBuilder<CurrentUser>(
      stream: authService.onAuthStateChanged, //authentication changes stream
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          final currentUser = snapshot.data;
          if ((currentUser != null)) {
            Globals.userID = currentUser.userID;

            //downloads the necessary connections and posts data of the user
            preLoadData();

            return Provider<CurrentUser>.value(
                value: currentUser,
                child: ProfileStateController(currentUser.userID),
            );

          } else {
            return const WelcomeScreen();
          }

        }
        return const LoadingScreen();
      }
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
            child: SpinKitSpinningLines(
              color: Colors.deepPurple.shade500,
              size: 120.0,
            ),
        ),
      ),
    );
  }
}


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('ERROR!!!'),
      ),
    );
  }
}
