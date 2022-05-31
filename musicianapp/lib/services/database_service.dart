import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicianapp/globals/globals.dart';

class DatabaseService {

  static final db = FirebaseFirestore.instance;

  static final userRef = db.collection('users').doc(Globals.userID);

  static final userColRef = db.collection('users');

  static final postsRef = db.collection('posts');

  static final userConnectionsRef = db.collection('users').doc(Globals.userID).collection('connections');

  static final conversationsRef = db.collection('conversations').doc(Globals.userID);

}