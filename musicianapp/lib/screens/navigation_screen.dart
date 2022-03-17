import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:musicianapp/screens/connections/connections_screen.dart';
import 'package:musicianapp/screens/connections/conversations_screen.dart';
import 'package:musicianapp/screens/explore/explore_screen.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/account/user_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  var _currentIndex = 0;
  List<Widget> pages = [
    ExploreScreen(),
    ConnectionsView(),
    ConversationsScreen(),
    ProfileScreen(''),
  ];
  Color _selectedColor = Color(0xFF2f3542);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Explore"),
            selectedColor: _selectedColor,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.people),
            title: Text("Connections"),
            selectedColor: _selectedColor,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.message_rounded),
            title: Text("Messages"),
            selectedColor: _selectedColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: _selectedColor,
          ),
        ],
      ),
    );
  }
}
