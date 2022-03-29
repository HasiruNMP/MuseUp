import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart.';
import 'package:flutter/material.dart';
import 'package:musicianapp/screens/common/feed_screen.dart';

class PostScreen extends StatefulWidget {
  String postID;
  String time;
  String authorID;
  String name;
  String imageURL;
  int commentsCount;
  PostScreen(this.postID, this.time, this.authorID, this.name, this.imageURL, this.commentsCount);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                //height: 300,
                color: Colors.indigo.shade50,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                              ),
                              title: Text('Name'),
                              subtitle: Text('time'),
                            ),
                            onTap: (){
                              print('asd');
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite),),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,8,8),
                      child: Text(
                        '',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 10),
                      child: ExpandablePanel(
                        theme: ExpandableThemeData(
                          headerAlignment: ExpandablePanelHeaderAlignment.center,
                        ),
                        header: Text(
                          'Comments',
                        ),
                        collapsed: Text('', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                              /*child: TextButton(
                                onPressed: (){},
                                child: Text('Add Your Comment'),
                              ),*/
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CupertinoTextField(
/*                                      decoration: InputDecoration(
                                        hintText: 'type your comment here..'
                                      ),*/
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: TextButton(
                                      onPressed: (){},
                                      child: Text('Post'),
                                    ),
                                  ),
                                  //IconButton(onPressed: (){}, icon: Icon(Icons.send),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Text('Name',style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text('Lorem ipsum may be'),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
