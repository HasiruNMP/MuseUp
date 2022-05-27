import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicianapp/common/globals.dart';

class Connection {

  String makeConnectionID(String connectionID){
    List<String> connList = [Globals.userID,connectionID];
    connList.sort();
    print(connList[0]+connList[1]);
    return connList[0]+connList[1];
  }

  Future<void> sendConnectionRequest(String otherUserID) async {

    Globals.connectionsMap.putIfAbsent(otherUserID, () => 'outgoing');

    await FirebaseFirestore.instance.collection('users').doc(Globals.userID).collection('connections').doc(otherUserID).set({
      'connectionUID': otherUserID,
      'status': 'outgoing',
      'time': DateTime.now(),
    }).then((value) {
      print("User Added");
    }).catchError((error) => print("Failed to add user: $error"));

    await FirebaseFirestore.instance.collection('users').doc(otherUserID).collection('connections').doc(Globals.userID).set({
      'connectionUID': Globals.userID,
      'status': 'incoming',
      'time': DateTime.now(),
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

    await FirebaseFirestore.instance.collection('users').doc(otherUserID).collection('notifications').add({
      'type': 'requested',
      'from': Globals.userID,
      'content':'',
      'status': 'new',
      'time': DateTime.now(),
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

  }

  Future<void> responseToConnectionRequest(String otherUserID, String response) async {

    if(response == 'accepted'){

      Globals.connectionsMap.update(otherUserID, (value) => response);
      Globals.connectionsMap.putIfAbsent(otherUserID, () => response);

      await FirebaseFirestore.instance.collection('users').doc(Globals.userID).collection('connections').doc(otherUserID).set({
        'connectionUID': otherUserID,
        'status': response,
        'time': DateTime.now(),
      }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

      await FirebaseFirestore.instance.collection('users').doc(otherUserID).collection('connections').doc(Globals.userID).set({
        'connectionUID': Globals.userID,
        'status': response,
        'time': DateTime.now(),
      }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

      await FirebaseFirestore.instance.collection('users').doc(otherUserID).collection('notifications').add({
        'type': 'accepted',
        'from': Globals.userID,
        'content':'',
        'status': 'new',
        'time': DateTime.now(),
      }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

    }else{

      Globals.connectionsMap.remove(otherUserID);

      FirebaseFirestore.instance.collection('users').doc(Globals.userID).collection('connections').doc(otherUserID).delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));

      FirebaseFirestore.instance.collection('users').doc(otherUserID).collection('connections').doc(Globals.userID).delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));

    }




  }

}