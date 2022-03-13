
import 'package:cloud_firestore/cloud_firestore.dart';

class Globals {
  static String userID = 'NoUser';
  static CollectionReference users = FirebaseFirestore.instance.collection('users');
}