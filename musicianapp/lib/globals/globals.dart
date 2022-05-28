
import 'package:cloud_firestore/cloud_firestore.dart';

class Globals {

  static String userID = 'NoUser';

  static CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  static List<String> connectionsList = [];

  static Map<String,String> connectionsMap = {};

  static List<String> likedPosts = [];

}