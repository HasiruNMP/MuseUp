import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/screens/connections/chat_screen.dart';
import 'package:musicianapp/screens/connections/connections_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConnectionsView()),
          );
        },
        child: FaIcon(FontAwesomeIcons.plus,color: Colors.white,size: 16,),
      ),
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search),),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('conversations').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> conversationData = document.data()! as Map<String, dynamic>;
                String otherUser = conversationData['participants'][0] == 'anneblake@gmail.com'?
                  conversationData['participants'][1] : conversationData['participants'][0];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(otherUser).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                      Timestamp time = conversationData['lastMessageTime'];
                      var date = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              style: flatButtonStyleDoc1,
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(document.id,userData['name'],userData['imageLink']),),);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.green,
                                      backgroundImage: NetworkImage(userData['imageLink']),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            conversationData['lastMessage'],
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        '${date.hour}:${date.minute}',
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Text("loading");
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
