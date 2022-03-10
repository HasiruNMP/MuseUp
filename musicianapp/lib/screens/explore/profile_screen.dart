import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  String userID;

  ProfileScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic> profileData = {};
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(data['imageLink'],),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      data['name'],
                      style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      '${age.round().toString()} Y',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Dublin, Ireland',
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text('BIO'),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit',
                      style: TextStyle(fontSize: 15,),
                    ),
                    SizedBox(height: 10,),
                    Text('ROLE'),
                    Text(
                      'Instrumentalist',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    Text('INSTRUMENT'),
                    Text(
                      'Guitar',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    Text('GENRES'),
                    Text(
                      'Pop, Acoustic, Rock, Jazz',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){}, child: Text('CONNECT'),),
                        SizedBox(width: 10,),
                        ElevatedButton(onPressed: (){}, child: Text('MESSAGE'),),
                      ],
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
