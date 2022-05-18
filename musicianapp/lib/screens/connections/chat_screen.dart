import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/chat_model.dart';
import 'package:musicianapp/screens/account/authentication/signin_screen.dart';

class ChatScreen extends StatefulWidget {

  String conversationID;
  String connectionUID;
  String imageURL;
  String connectionName;

  ChatScreen(this.conversationID,this.connectionUID,this.connectionName,this.imageURL, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTEC = TextEditingController();
  late bool isSenderMe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              backgroundImage: NetworkImage(widget.imageURL),
            ),
            SizedBox(width: 8,),
            Text(widget.connectionName),
          ],
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_vert),),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('conversations').doc(widget.conversationID).collection('messages').orderBy('time', descending: false).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: spinkit);
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      Chat().initializeChat(widget.conversationID, widget.connectionUID);
                      return Text('Start Chatting with ${widget.connectionName}');
                    }


                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> messageData = document.data()! as Map<String, dynamic>;
                        messageData['sender'] == Globals.userID ? isSenderMe = true : isSenderMe = false;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            alignment: isSenderMe? Alignment.centerRight : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                //alignment: Alignment.centerRight,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSenderMe? lightPurple : darkPurple,
                                  borderRadius: BorderRadius.all(Radius.circular(15),),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        messageData['text'],
                                        //textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isSenderMe? Colors.black : Colors.white,
                                        ),
                                      ),
                                      //Text(messageData['time'].toString(),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                //color: Colors.grey,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.add_circle),),
                    Container(
                      width: 270,
                      child: TextField (
                        controller: messageTEC,
                        decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type message here'
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        if(messageTEC.text.isNotEmpty){
                          uploadMessage(widget.conversationID,messageTEC.text);
                          messageTEC.clear();
                        }
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<void> uploadMessage(String conversationID, String text) {
    return FirebaseFirestore.instance.collection('conversations').doc(conversationID).collection('messages').add({
      'order': 0,
      'text': text,
      'sender': Globals.userID,
      'time': FieldValue.serverTimestamp(),
    })
    .then((value) {
      print("Message Added");
      updateLastMessage(conversationID,text);
    })
    .catchError((error) => print("Failed to send message: $error"));
  }

  Future<void> updateLastMessage(String conversationID,String text) {
    return FirebaseFirestore.instance.collection('conversations').doc(conversationID).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }).then((value) => print("Message Added")).catchError((error) => print("Failed to send message: $error"));
  }

}
