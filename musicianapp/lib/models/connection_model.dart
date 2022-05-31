import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/services/database_service.dart';
import 'package:musicianapp/services/notifications_service.dart';

class ConnectionsModel {

  String makeConnectionID(String connectionID){
    List<String> connList = [Globals.userID,connectionID];
    connList.sort();
    print(connList[0]+connList[1]);
    return connList[0]+connList[1];
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getConnections() {
    return DatabaseService.userRef.collection('connections').where('status',isEqualTo: 'accepted').get();
  }

  Future<void> sendConnectionRequest(String otherUserID,String name) async {

    Globals.connectionsMap.putIfAbsent(otherUserID, () => 'outgoing');

    await DatabaseService.userRef.collection('connections').doc(otherUserID).set({
      'connectionUID': otherUserID,
      'status': 'outgoing',
      'time': DateTime.now(),
    }).then((value) {
      print("User Added");
    }).catchError((error) => print("Failed to add user: $error"));

    await DatabaseService.userColRef.doc(otherUserID).collection('connections').doc(Globals.userID).set({
      'connectionUID': Globals.userID,
      'status': 'incoming',
      'time': DateTime.now(),
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

    await DatabaseService.userColRef.doc(otherUserID).collection('notifications').add({
      'type': 'requested',
      'from': Globals.userID,
      'content':'',
      'status': 'new',
      'time': DateTime.now(),
    }).then((value) {
      print("User Added");
      Notifications.sendNotificationToUser(otherUserID, "Connection Request", "John has sent you a request");
    }).catchError((error) => print("Failed to add user: $error"));

  }

  Future<void> responseToConnectionRequest(String otherUserID, String response) async {

    if(response == 'accepted'){

      Globals.connectionsMap.update(otherUserID, (value) => response);
      Globals.connectionsMap.putIfAbsent(otherUserID, () => response);

      await DatabaseService.userRef.collection('connections').doc(otherUserID).set({
        'connectionUID': otherUserID,
        'status': response,
        'time': DateTime.now(),
      }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

      await DatabaseService.userColRef.doc(otherUserID).collection('connections').doc(Globals.userID).set({
        'connectionUID': Globals.userID,
        'status': response,
        'time': DateTime.now(),
      }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

      await DatabaseService.userColRef.doc(otherUserID).collection('notifications').add({
        'type': 'accepted',
        'from': Globals.userID,
        'content':'',
        'status': 'new',
        'time': DateTime.now(),
      }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

    }else{

      Globals.connectionsMap.remove(otherUserID);

      DatabaseService.userRef.collection('connections').doc(otherUserID).delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));

      DatabaseService.userColRef.doc(otherUserID).collection('connections').doc(Globals.userID).delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));

    }




  }

}