import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';

class Explorer with ChangeNotifier{

  List<String> filterSettings = [];
  final geo = Geoflutterfire();
  List<String> videoList = [];

 void searchUsersByMusic() {
    videoList.clear();
    FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        videoList.add(doc['videoLink']);
        print(doc["name"]);
      }
      notifyListeners();
    });

  }

  void searchUsersByDistance(){
    GeoFirePoint center = geo.point(latitude: 7.242016, longitude: 80.857134);
    double radius = 2;
    String field = 'position';
    var collectionReference = FirebaseFirestore.instance.collection('locations');
    Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: field);
    stream.listen((List<DocumentSnapshot> documentList) {
      for (var document in documentList) {
        print(document.data());
      }
    });
  }

}




