import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/screens/common/common_widgets.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/models/chat_model.dart';
import 'package:musicianapp/models/connection_model.dart';
import 'package:musicianapp/screens/feed/feed_screen.dart';
import 'package:musicianapp/screens/media/media_screen.dart';
import 'package:musicianapp/screens/settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {

  String userID;

  ProfileScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin  {


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

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.deepPurple.shade50,
                        height: MediaQuery.of(context).size.height/5.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  color: Colors.deepPurple,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network(data['imageURL'],),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Container(
                                    //color: Colors.black12,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data['fName']} ${data['lName']}',
                                          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                        ),
                                        //SizedBox(height: 18,),
                                        Text(
                                          '${age.round().toString()} Y',
                                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                        ),
                                        //SizedBox(height: 18,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.location_on,size: 12,),
                                            Text(
                                              '${data['city']}, ${data['country']}',
                                              //style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        _profileButtons(profileType, widget.userID, data['city'] + data['country'], data['imageURL'])
                                      ],
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
                          const MediaContent(),
                        ],
                      ),
                    ),
                  ),
                ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
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
                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("10 Connections"),
                      SizedBox(width: 5,),
                      Icon(Icons.people,size: 22,)
                    ],
                  )
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
      ),
    );
  }

  Widget _profileButtons(String profileType, String uid, String name, String imageURL){
    if(profileType == 'accepted'){
      return Container(
        child: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.person_add_alt_1),
                  //child: Text('CONNECTED'),
                  //style: flatButtonWithIconStyle1,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: IconButton(
                  onPressed: (){
                    Chat().openChat(uid, context, name,imageURL);
                  },
                  icon: const Icon(Icons.add),
                  //child: Text('MESSAGE'),
                  //style: flatButtonWithIconStyle1,
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
                          Connection().responseToConnectionRequest(uid, 'accepted');
                        });
                      },
                      child: const Text('ACCEPT'),
                      style: flatButtonWithIconStyle1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          Connection().responseToConnectionRequest(uid, 'none');
                        });
                      },
                      child: const Text('IGNORE'),
                      style: flatButtonWithIconStyle1,
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
                      style: flatButtonWithIconStyle1,
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
                      style: flatButtonWithIconStyle1,
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
                      style: flatButtonWithIconStyle1,
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
                          Connection().sendConnectionRequest(uid);
                        });
                      },
                      child: const Icon(Icons.person_add_alt_1),
                      style: flatButtonWithIconStyle1,
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
                      child: const Icon(Icons.chat),
                      style: flatButtonWithIconStyle1,
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

/*
  void getProfileData(String userID){
    FirebaseFirestore.instance.collection('users').doc(userID).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        profileData = documentSnapshot.data()! as Map<String, dynamic>;
      }
    });
  }
*/




}
