import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:musicianapp/screens/connections_screen.dart';
import 'package:musicianapp/screens/conversations_screen.dart';
import 'package:musicianapp/screens/explore_screen.dart';
import 'package:musicianapp/screens/profile_screen.dart';
import 'package:musicianapp/screens/account/user_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ExploreScreen(),
    ConnectionsView(),
    ConversationsScreen(),
    UserScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
