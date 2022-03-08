import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:musicianapp/screens/account/signin_screen.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('conversations').doc('anneblake@gmail.com-emmamclean@gmail.com').collection('messages').orderBy('time', descending: false).snapshots();
  final messageTEC = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('anneblake@gmail.com'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> messageData = document.data()! as Map<String, dynamic>;
                        return Container(
                          alignment: messageData['sender'] == 'anneblake@gmail.com' ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              //alignment: Alignment.centerRight,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.all(Radius.circular(8),),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      messageData['text'],
                                      //textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    //Text(messageData['time'].toString(),),
                                  ],
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
                color: Colors.grey,
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
                        hintText: 'type message here'
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        uploadMessage();
                        messageTEC.clear();
                    }, icon: Icon(Icons.send),),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<void> uploadMessage() {
    return FirebaseFirestore.instance.collection('conversations').doc('anneblake@gmail.com-emmamclean@gmail.com').collection('messages').add({
      'order': 0,
      'text': messageTEC.text,
      'sender': 'anneblake@gmail.com',
      'time': FieldValue.serverTimestamp(),
    })
    .then((value) => print("Message Added"))
    .catchError((error) => print("Failed to send message: $error"));
  }

}
