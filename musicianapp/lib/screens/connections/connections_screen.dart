import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicianapp/models/connection_model.dart';
import 'package:musicianapp/screens/common/common_widgets.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/services/database_service.dart';

import '../../models/chat_model.dart';

class ConnectionsView extends StatefulWidget {
  const ConnectionsView({Key? key}) : super(key: key);

  @override
  _ConnectionsViewState createState() => _ConnectionsViewState();
}

class _ConnectionsViewState extends State<ConnectionsView> with AutomaticKeepAliveClientMixin<ConnectionsView>{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search),),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
          future: ConnectionsModel.getConnections(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: spinkit);
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> connectionData = document.data()! as Map<String, dynamic>;
                return FutureBuilder<DocumentSnapshot>(
                  future: DatabaseService.userColRef.doc(connectionData['connectionUID']).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              style: flatButtonStyleDoc1,
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfileScreen(snapshot.data!.id)),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.green,
                                            backgroundImage: NetworkImage(userData['imageURL']),
                                          ),
                                          const SizedBox(width: 7,),
                                          Column(
                                            children: [
                                              Text(
                                                '${userData['fName']} ${userData['lName']}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              /*Text(
                                                '${userData['role']}',
                                                style: TextStyle(
                                                  //fontSize: 18,
                                                  color: Colors.black54,
                                                ),
                                              ),*/
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ProfileScreen(snapshot.data!.id)),
                                        );
                                      },
                                      icon: const FaIcon(FontAwesomeIcons.solidUser,color: Colors.black87,size: 20,),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        Chat().openChat(connectionData['connectionUID'], context, userData['fName'],userData['imageURL']);
                                      },
                                      icon: const FaIcon(FontAwesomeIcons.solidEnvelope,color: Colors.black87,size: 20,),
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
    );
  }
}
