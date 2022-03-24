import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/screens/connections/chat_screen.dart';

class Chat {

  String makeConversationID(String connectionID){
    List<String> connList = [Globals.userID,connectionID];
    connList.sort();
    print(connList[0]+connList[1]);
    return connList[0]+connList[1];
  }

  void openChat(String otherUser, BuildContext context, String otherUserName, String otherUserImageURL) {
    String conversationID = Chat().makeConversationID(otherUser);
    Navigator.push(
      context, MaterialPageRoute(
      builder: (context) => ChatScreen(conversationID,otherUser,otherUserName,otherUserImageURL),
    ),);
  }

  Future<void> initializeChat(String conversationID, String connectionID) {
    return FirebaseFirestore.instance.collection('conversations').doc(conversationID).update({
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'participants' : [Globals.userID,connectionID],
    }).then((value) => print("Message Added")).catchError((error) => print("Failed to send message: $error"));
  }

}