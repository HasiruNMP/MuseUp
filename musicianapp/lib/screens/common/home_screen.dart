import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/models/explore_model.dart';
import 'package:musicianapp/screens/connections/notifications_screen.dart';
import 'package:musicianapp/screens/explore/explore_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MuseUp'),
        centerTitle: true,
        leading: IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/users%2Femmamclean%40gmail.com%2Fimages%2Fpexels-pavel-danilyuk-7802607%20(1).jpg?alt=media&token=07fc13be-3990-4db2-9c24-2bb030aa43c3'),
            ),
            onPressed: () { print("Pressed"); }
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
            icon: Badge(
              badgeContent: Text(
                '2',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              child: FaIcon(FontAwesomeIcons.solidBell),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Discover',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: 210,
              child: NearbyListView(),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Highlighted',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: 210,
              child: NearbyListView(),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 60,
                  color: Colors.deepPurple.shade50,
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExploreScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(width: 10,),
                        Text(
                          'Explore Musicians',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87),
                          ),
                        ),
                        SizedBox(width: 10,),
                        FaIcon(FontAwesomeIcons.search,color: Colors.black87,size: 16,),
                        //FaIcon(FontAwesomeIcons.angleRight,color: Colors.black45,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 60,
                  color: Colors.deepPurple.shade50,
                  child: TextButton(
                    onPressed: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(width: 10,),
                        Text(
                          'Connections',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87),
                          ),
                        ),
                        SizedBox(width: 10,),
                        FaIcon(FontAwesomeIcons.users,color: Colors.black87,size: 16,),
                        //FaIcon(FontAwesomeIcons.angleRight,color: Colors.black45,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 1));
  }
}

class NearbyListView extends StatefulWidget {
  const NearbyListView({
    Key? key,
  }) : super(key: key);

  @override
  State<NearbyListView> createState() => _NearbyListViewState();
}

class _NearbyListViewState extends State<NearbyListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Colors.deepPurple.shade50,
                  width: 150,
                  child: Column(
                    children: [
                      Image.network(data['imageLink']),
                      Text(
                        data['name'],
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        data['role'],
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
