import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/screens/common/common_widgets.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/services/database_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              //fontSize: 16,
              //fontWeight: FontWeight.bold,
              //color: Colors.black87,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService.userRef.collection('notifications').orderBy('time',descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return FutureBuilder<DocumentSnapshot>(
                  future: DatabaseService.userColRef.doc(data['from']).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> sender = snapshot.data!.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.deepPurple.shade50,
                            child: TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfileScreen(snapshot.data!.id)),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(sender['imageURL']),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/1.3,
                                    child: (data['type']=='requested')? RichText(
                                      text: TextSpan(
                                        text: '',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(text: sender['fName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const TextSpan(text: ' has sent you a connection request'),
                                        ],
                                      ),
                                    ):RichText(
                                      text: TextSpan(
                                        text: 'Congratulations! ',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(text: sender['fName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const TextSpan(text: ' has accepted your request.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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

class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection(documentId);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc('').get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.deepPurple.shade50,
                child: TextButton(
                  onPressed: (){},
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'Anne Blake has sent you a connection request.',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
