import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:musicianapp/screens/login_screen.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('conversations').doc('anneblake@gmail.com-emmamclean@gmail.com').collection('messages').snapshots();

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
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return ListTile(
                          subtitle: Text(data['sender']),
                          title: Text(data['text']),
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
                      child: TextField (decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'type message here'
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.send),),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
