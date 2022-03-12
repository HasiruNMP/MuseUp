import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  late String userID;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String uid, String email) {
    return users.doc('ABC123').set({
      'full_name': "Mary Jane",
      'age': 18
    }).then((value) {
      print("User Added");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }

}
