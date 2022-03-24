import 'package:adminweb/screens/videoplayer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  String uid;
  ProfileScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    print(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(widget.uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: Image.network(data['imageURL']),
                  ),
                  ListTile(
                    title: Text('USER ID'),
                    subtitle: Text(snapshot.data!.id),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('NAME'),
                    subtitle: Text(data['fName']),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('DOB'),
                    subtitle: Text(data['dob'].toString()),
                    textColor: Colors.black,
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoPlayerScreen(data['imageURL']),),
                      );
                    },
                    child: Text('Play Video'),
                  ),
                ],
              );
            }
            return Text("loading");
          },
        ),
      ),
    );
  }
  Future<void> blockProfile(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).update({
      'profileState':'blocked'
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }
}
