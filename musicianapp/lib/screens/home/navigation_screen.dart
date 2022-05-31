import 'package:flutter/material.dart';

import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/feed/feed_screen.dart';
import 'package:musicianapp/screens/home/home_screen.dart';
import 'package:musicianapp/screens/connections/conversations_screen.dart';
import 'package:musicianapp/screens/profile/user_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  var _currentIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const FeedScreen(),
    const ConversationsScreen(),
    ProfileScreen(Globals.userID)
  ];
  final Color _selectedColor = const Color(0xFF2f3542);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_filled),
            title: const Text("Home"),
            selectedColor: _selectedColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.feed),
            title: const Text("Feed"),
            selectedColor: _selectedColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.message_rounded),
            title: const Text("Messages"),
            selectedColor: _selectedColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: _selectedColor,
          ),
        ],
      ),
    );
  }
}
