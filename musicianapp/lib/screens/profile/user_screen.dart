import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/screens/common/common_widgets.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/models/chat_model.dart';
import 'package:musicianapp/models/connection_model.dart';
import 'package:musicianapp/screens/feed/feed_screen.dart';
import 'package:musicianapp/screens/settings/settings_screen.dart';
import 'package:musicianapp/screens/media/media_screen.dart';
import 'package:musicianapp/services/database_service.dart';

class UserScreen extends StatefulWidget {

  final String userID;

  const UserScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with SingleTickerProviderStateMixin {

  Map<String, dynamic> profileData = {};
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String profileType = 'none';
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.userID).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
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
                child: Column(
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
                              ],
                            ),
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
                              style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                            ),
                          ),
                          //SizedBox(height: 18,),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '${age.round().toString()} Y',
                              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                          ),
                          //SizedBox(height: 18,),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on,size: 20,),
                                Text(
                                  '${data['city']}, ${data['country']}',
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Divider(),
                    ),*/
                    Container(
                      child: TabBar(
                        controller: _controller,
                        labelColor: Colors.black87,
                        tabs: const [
                          Tab(text: 'INFO'),
                          Tab(text: 'POSTS'),
                          Tab(text: 'MEDIA'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          controller: _controller,
                          children: [
                            profileInfo(data),
                            FeedContent(FirebaseFirestore.instance.collection('posts').where('authorUID',isEqualTo: Globals.userID).snapshots()),
                            //const MediaContent(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: spinkit);
          },
        ),
      ),
    );
  }

  //_profileButtons(profileType,widget.userID,data['fName'],data['imageURL']),

  Widget profileInfo(Map<String, dynamic> _data) {
    return ListView(
      children: [
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
                    children: const [
                      Text('Video'),
                      Icon(Icons.video_file),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
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
                        const Text('BIO',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: 350,
                          child: Text(_data['bio'], style: const TextStyle(fontSize: 15,),overflow: TextOverflow.fade),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
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
                        const Text('ROLE',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(_data['role'], style: const TextStyle(fontSize: 15,),),
                        const SizedBox(height: 8,),
                        const Text('INSTRUMENT',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(_data['instrument'], style: const TextStyle(fontSize: 15,),),
                        const SizedBox(height: 8,),
                        const Text('GENRES',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(_data['genres'].toString(), style: const TextStyle(fontSize: 15,),),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileButtons(String profileType, String uid, String name, String imageURL){
    if(profileType == 'accepted'){
      return Container(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: TextButton(
                  onPressed: null,
                  child: const Text('CONNECTED'),
                  style: flatButtonStyle1,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: TextButton(
                  onPressed: (){
                    Chat().openChat(uid, context, name,imageURL);
                  },
                  child: const Text('MESSAGE'),
                  style: flatButtonStyle1,
                ),
              ),
            ),
          ],
        ),
      );
    }
    else if (profileType == 'incoming'){
      return Container(
        child: Column(
          children: [
            Text('$name has asked to connect with you'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          ConnectionsModel().responseToConnectionRequest(uid, 'accepted');
                        });
                      },
                      child: const Text('ACCEPT'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          ConnectionsModel().responseToConnectionRequest(uid, 'none');
                        });
                      },
                      child: const Text('IGNORE'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        Chat().openChat(uid, context, name,imageURL);
                      },
                      child: const Text('MESSAGE'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else if (profileType == 'outgoing'){
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: null,
                      child: const Text('REQUESTED'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        Chat().openChat(uid, context, name,imageURL);
                      },
                      child: const Text('MESSAGE'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          //ConnectionsModel().sendConnectionRequest(uid);
                        });
                      },
                      child: const Text('CONNECT'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        Chat().openChat(uid, context, name,imageURL);
                      },
                      child: const Text('MESSAGE'),
                      style: flatButtonStyle1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void getProfileData(String userID){
    DatabaseService.userColRef.doc(userID).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        profileData = documentSnapshot.data()! as Map<String, dynamic>;
      }
    });
  }
}
