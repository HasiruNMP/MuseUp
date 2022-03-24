import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/chat_model.dart';
import 'package:musicianapp/models/connection_model.dart';
import 'package:musicianapp/screens/settings/settings.dart';

class UserScreen extends StatefulWidget {

  String userID;

  UserScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  Map<String, dynamic> profileData = {};
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String profileType = 'none';
  String bio = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.userID).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

              if(Globals.connectionsMap.containsKey(widget.userID)){
                profileType = Globals.connectionsMap[widget.userID]!;
                print(profileType);
              }

              DateTime dob = data['dob'].toDate();
              var age = (DateTime.now().difference(dob).inDays)/365;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          //color: Colors.deepPurple.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    color: Colors.deepPurple,
                                    width: MediaQuery.of(context).size.width/2.2,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.network(data['imageURL'],),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${data['fName']} ${data['lName']}',
                                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      //SizedBox(height: 18,),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${age.round().toString()} Y',
                                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      //SizedBox(height: 18,),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.location_on,size: 20,),
                                            Text(
                                              '${data['city']}, ${data['country']}',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Divider(),
                    ),
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          color: Colors.deepPurple.shade50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
                            child: OutlinedButton(
                              onPressed: (){},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Video'),
                                  Icon(Icons.video_file),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Divider(),
                    ),
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          color: Colors.deepPurple.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('BIO',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 350,
                                      child: Text(bio, style: TextStyle(fontSize: 15,),overflow: TextOverflow.fade),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Divider(),
                    ),
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          color: Colors.deepPurple.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ROLE',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text(data['role'], style: TextStyle(fontSize: 15,),),
                                    SizedBox(height: 8,),
                                    Text('INSTRUMENT',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text(data['instrument'], style: TextStyle(fontSize: 15,),),
                                    SizedBox(height: 8,),
                                    Text('GENRES',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text(data['genres'].toString(), style: TextStyle(fontSize: 15,),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Text("loading");
          },
        ),
      ),
    );
  }

  void getProfileData(String userID){
    FirebaseFirestore.instance.collection('users').doc(userID).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        profileData = documentSnapshot.data()! as Map<String, dynamic>;
      }
    });
  }



}
