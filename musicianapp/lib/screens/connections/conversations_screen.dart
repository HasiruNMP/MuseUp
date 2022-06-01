import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicianapp/screens/common/common_widgets.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/models/chat_model.dart';
import 'package:musicianapp/screens/connections/connections_screen.dart';
import 'package:musicianapp/services/database_service.dart';

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
        child: const FaIcon(FontAwesomeIcons.plus,color: Colors.white,size: 16,),
      ),
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search),),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /*Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Online',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),*/
            const SizedBox(
              height: 55,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: OnlineConnections(),
              ),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('conversations').where('participants',arrayContains: Globals.userID).orderBy("lastMessageTime",descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: spinkit);
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> conversationData = document.data()! as Map<String, dynamic>;
                      String otherUser = conversationData['participants'][0] == Globals.userID? conversationData['participants'][1] : conversationData['participants'][0];
                      return FutureBuilder<DocumentSnapshot>(
                        future: DatabaseService.userColRef.doc(otherUser).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const Text("Document does not exist");
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                            //Timestamp time = conversationData['lastMessageTime'];
                            //var date = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: TextButton(
                                    style: flatButtonStyleDoc1,
                                    onPressed: (){
                                      Chat().openChat(otherUser, context, userData['fName'],userData['imageURL']);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Colors.green,
                                            backgroundImage: NetworkImage(userData['imageURL']),
                                          ),
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userData['fName'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  conversationData['lastMessage'],
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                            child: Text(
                                              //'${date.hour}:${date.minute}',
                                              '',
                                              style: const TextStyle(
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
                          return const Center(child: spinkit);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnlineConnections extends StatefulWidget {
  const OnlineConnections({Key? key}) : super(key: key);

  @override
  State<OnlineConnections> createState() => _OnlineConnectionsState();
}

class _OnlineConnectionsState extends State<OnlineConnections> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService.userColRef.where('isOnline',isEqualTo: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: spinkit);
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: InkWell(
                      onTap: (){
                        Chat().openChat(document.id, context, data['fName'],data['imageURL']);
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(data['imageURL']),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 10, 0),
                        child: Badge(
                          badgeColor: Colors.green,
                          badgeContent: const Text(''),
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            );
          }).toList(),
        );
      },
    );
  }
}


