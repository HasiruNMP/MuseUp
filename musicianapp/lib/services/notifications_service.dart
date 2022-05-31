import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:musicianapp/services/database_service.dart';

class Notifications {

  static String fcmAPIKey = "Bearer AAAAIs0hp6I:APA91bErer2KO3nWMcDaIpLMkZKmIpYuEQdIY1U0Tc79TZ1H5Nd9u7bdABIvFxd3bhlFUIiPwgMc-KS21QxjBuXXrqsCEhLbHX0Oj1acGvPVObIsYBncNnZXLYm0ttZABZFX1JhQD1fb";

  static String fcmToken = "";

   static final db = FirebaseFirestore.instance;

  static Future<void> getFCMToken() async {
    fcmToken = (await FirebaseMessaging.instance.getToken())!;
    print(fcmToken);
    sendTokenToFirestore();
  }

  static Future<void> listenToFCMToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      fcmToken = token;
      sendTokenToFirestore();
    }).onError((err) {
      // Error getting token.
      print("Error getting FCM token");
    });
  }

  static Future<void> sendTokenToFirestore() async {
    return DatabaseService.userRef.update({
      'fcmToken': fcmToken,
    }).then((value) {
      print("token added to firebase");
    }).catchError((error) {
      print("Failed to add token: $error");
    });
  }

  static Future<String> getTokenOfUser(String userID) async {
    String token = "0";
    final docRef = db.collection("users").doc(userID);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      token = data['fcmToken'];
    },
      onError: (e) {
        print("Error getting document: $e");
      },
    );
    return token;
  }

  static Future<void> sendNotificationToUser(String userID, String title, String body,) async {

    String userFcmToken = await getTokenOfUser(userID);

    var headers = {
      'Authorization': fcmAPIKey,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": "e01n8MPNSSGwiPxQXnh0ib:APA91bFn_XHw3gpQ64D8zl01Qe3U14kq7IaTuKDoUFB9tNF4XErSv3xYIkcNmyE-M4aEKuAKd6rSHBGxC9XCShL218X_28hsF7N5IpEADx1aACG-Gstu6VEdBSAkOOJLIpUP-N0-NUck",
      "notification": {
        "title": title,
        "body": body,
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

}