import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';

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
        title: Text('Connections'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search),),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc('hasirunmp@gmail.com').collection('connections').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> connectionData = document.data()! as Map<String, dynamic>;
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(connectionData['userEmail']).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
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
                                  MaterialPageRoute(builder: (context) => ProfileScreen('')),
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
                                            backgroundImage: NetworkImage(userData['imageLink']),
                                          ),
                                          SizedBox(width: 7,),
                                          Text(
                                            userData['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){},
                                      icon: FaIcon(FontAwesomeIcons.solidUser,color: Colors.black87,size: 20,),
                                    ),
                                    IconButton(
                                      onPressed: (){},
                                      icon: FaIcon(FontAwesomeIcons.solidEnvelope,color: Colors.black87,size: 20,),
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
