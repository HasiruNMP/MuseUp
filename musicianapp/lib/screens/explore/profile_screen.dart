import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/common_widgets.dart';

class ProfileScreen extends StatefulWidget {

  String userID;

  ProfileScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic> profileData = {};
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String bio = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.settings),),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc('anneblake@gmail.com').get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

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
                          color: Colors.deepPurple.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(data['imageLink'],height: 150.0, width: 150.0,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 18,),
                                      Text(
                                        '${age.round().toString()} Y',
                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 18,),
                                      Text(
                                        'Dublin, Ireland',
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                    child: TextButton(
                                      onPressed: (){},
                                      child: Text('CONNECT'),
                                      style: flatButtonStyle1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                    child: TextButton(
                                      onPressed: (){},
                                      child: Text('MESSAGE'),
                                      style: flatButtonStyle1,
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
                                    Text('Instrumentalist', style: TextStyle(fontSize: 15,),),
                                    SizedBox(height: 8,),
                                    Text('INSTRUMENT',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text('Guitar', style: TextStyle(fontSize: 15,),),
                                    SizedBox(height: 8,),
                                    Text('GENRES',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text('Pop, Acoustic, Rock, Jazz', style: TextStyle(fontSize: 15,),),
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
