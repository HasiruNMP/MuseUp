import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/screens/connections/connections_screen.dart';
import 'package:musicianapp/screens/connections/notifications_screen.dart';
import 'package:musicianapp/screens/explore/explore_screen.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/videos/myvideos_screen.dart';
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
        title: const Text('MuseUp'),
        centerTitle: true,
/*        leading: IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/hnmp-museup.appspot.com/o/users%2FyosJBYpOiVgqDWUZGDaV5pbxs3p2%2Fimages%2F1632695736378%20(1)%20(2).jpg?alt=media&token=375f1c3c-6235-48ae-b641-d3ca74b73829'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserScreen(Globals.userID)),
              );
            }
        ),*/
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
            icon: Badge(
              badgeContent: const Text(
                '2',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              child: const FaIcon(FontAwesomeIcons.solidBell),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('My Videos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyVideosScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {

              },
            ),
          ],
        ),
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
                    textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
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
                    textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 210,
              child: NearbyListView(),
            ),
            const Divider(),
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
                        MaterialPageRoute(builder: (context) => const ExploreScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(width: 10,),
                        Text(
                          'Explore Musicians',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        const FaIcon(FontAwesomeIcons.search,color: Colors.black87,size: 16,),
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
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ConnectionsView()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(width: 10,),
                        Text(
                          'Connections',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        const FaIcon(FontAwesomeIcons.users,color: Colors.black87,size: 16,),
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
    return Future.delayed(const Duration(seconds: 1));
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
      stream: FirebaseFirestore.instance.collection('users').where('profileState',isEqualTo: 1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: spinkit);
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
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(document.id),),
                      );
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(data['imageURL']),
                          ),
                        ),
                        Text(
                          '${data['fName']} ${data['lName']}',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          data['role'],
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
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
