import 'package:adminweb/screens/common.dart';
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

              Timestamp timestamp = data['dob'];
              DateTime dob = timestamp.toDate();

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'REPORTEE PROFILE',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //Image.network(data['imageURL']
                  Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.blueGrey.shade100,
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 250),
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPlayerScreen(data['imageURL']),),
                        );
                      },
                      child: Text('Play Video'),
                    ),
                  ),
                  ListTile(
                    title: Text('USER ID',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(snapshot.data!.id,style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('NAME',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data['fName']+' '+data['lName'],style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('DOB',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(dob.toString(),style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('GENDER',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data['gender'],style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('COUNTRY',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data['country'],style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('CITY',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data['city'],style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('BIO',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data['bio'],style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  ListTile(
                    title: Text('ROLE',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data['role'],style: TextStyle(fontSize: 16),),
                    textColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 200),
                    child: ElevatedButton(
                      onPressed: (){
                        blockProfile(snapshot.data!.id);
                      },
                      child: Text('BLOCK USER'),
                    ),
                  ),

                ],
              );
            }
            return Center(child: spinkit);
          },
        ),
      ),
    );
  }
  Future<void> blockProfile(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).update({
      'profileState':9
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }
}
