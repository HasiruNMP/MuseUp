import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ConnectionsView extends StatefulWidget {
  const ConnectionsView({Key? key}) : super(key: key);

  @override
  _ConnectionsViewState createState() => _ConnectionsViewState();
}

class _ConnectionsViewState extends State<ConnectionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
      ),
      body: Container(),
    );
  }
}

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('musicians').snapshots();

  //Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: field);
  final geo = Geoflutterfire();


  @override
  Widget build(BuildContext context) {
    //setLocation();

    return Container();
  }
//7.242016, 80.857134
  void setLocation(){
    GeoFirePoint myLocation = geo.point(latitude: 7.206750, longitude: 80.848153);
    GeoFirePoint myLocation1 = geo.point(latitude: 7.195850, longitude: 80.677751);
    GeoFirePoint myLocation2 = geo.point(latitude: 7.201300, longitude: 80.523840);
    GeoFirePoint myLocation3 = geo.point(latitude: 6.955992, longitude: 80.276482);
    GeoFirePoint myLocation4 = geo.point(latitude: 6.235698, longitude: 80.303966);
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation1.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation2.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation3.data});
    firestore.collection('locations').add({'name': 'random name', 'position': myLocation4.data});
  }

  void getData(){
    GeoFirePoint center = geo.point(latitude: 7.242016, longitude: 80.857134);
    double radius = 2;
    String field = 'position';
    var collectionReference = firestore.collection('locations');
    Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: field);
    stream.listen((List<DocumentSnapshot> documentList) {
      for (var document in documentList) {
        print(document.data());
      }
    });
  }
}