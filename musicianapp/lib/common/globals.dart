
import 'package:cloud_firestore/cloud_firestore.dart';

class Globals {
  static String userID = 'NoUser';
  static CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
}