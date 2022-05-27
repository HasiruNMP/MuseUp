import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'feed_screen.dart';

class SearchPostsScreen extends StatefulWidget {
  const SearchPostsScreen({Key? key}) : super(key: key);

  @override
  State<SearchPostsScreen> createState() => _SearchPostsScreenState();
}

class _SearchPostsScreenState extends State<SearchPostsScreen> {

  bool submitted = false;
  final tecKeywords = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            controller: tecKeywords,
            decoration: const InputDecoration(
              hintText: 'Type Keywords Here',
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                submitted = true;
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: (!submitted)? Container(
          child: const Center(
            child: Text("Search"),
          ),
        ): FeedContent(FirebaseFirestore.instance.collection('posts').where('keywords',arrayContainsAny: tecKeywords.text.split(',')).snapshots()),
      ),
    );
  }
}
