import 'package:adminweb/models/profile_model.dart';
import 'package:adminweb/screens/common.dart';
import 'package:adminweb/screens/video_player_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  final String uid;
  const ProfileScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    //print(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<DocumentSnapshot>(
        future: Profile.profileFuture(widget.uid),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            Timestamp timestamp = data['dob'];
            DateTime dob = timestamp.toDate();

            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
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
                      child: const Icon(Icons.person),
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
                    child: const Text('Play Video'),
                  ),
                ),
                ListTile(
                  title: const Text('USER ID',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(snapshot.data!.id,style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('NAME',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data['fName']+' '+data['lName'],style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('DOB',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(dob.toString(),style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('GENDER',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data['gender'],style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('COUNTRY',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data['country'],style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('CITY',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data['city'],style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('BIO',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data['bio'],style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                ListTile(
                  title: const Text('ROLE',style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(data['role'],style: const TextStyle(fontSize: 16),),
                  textColor: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 200),
                  child: ElevatedButton(
                    onPressed: (){
                      Profile.blockProfile(snapshot.data!.id);
                    },
                    child: const Text('BLOCK USER'),
                  ),
                ),

              ],
            );
          }
          return const Center(child: spinKit);
        },
      ),
    );
  }
}
