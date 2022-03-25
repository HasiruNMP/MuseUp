import 'package:adminweb/screens/common.dart';
import 'package:adminweb/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  String _selectedDoc = 'none';
  String _selectedDocUID = 'none';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('reports').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: spinkit);
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: Colors.deepPurple.shade50,
                        child: TextButton(
                          onPressed: (){
                            setState(() {
                              _selectedDoc = document.id;
                              _selectedDocUID = data['reporteeUID'];
                            });
                          },
                          child: ListTile(
                            title: Text(data['reporterName'].toString()),
                            subtitle: Text(
                              data['content'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                }).toList(),
              );
            },
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 5,
          child: _selectedDoc != 'none'? reportDetails(_selectedDoc) : Center(child: Text('Select A Report'),),
        ),
        VerticalDivider(),
        Expanded(
          flex: 5,
          child: _selectedDoc != 'none'? ProfileScreen(_selectedDocUID) : Center(child: Text('Select A Report'),),
        ),
      ],
    );
  }
  Widget reportDetails(String docID){
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('reports').doc(docID).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          Timestamp timestamp = data['time'];
          DateTime time = timestamp.toDate();

          return ListView(
            children: [
              ListTile(
                title: Text('REPORTER',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(data['reporterName'],style: TextStyle(fontSize: 16),),
                textColor: Colors.black,
              ),
              ListTile(
                title: Text('REPORTEE',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(data['reporteeName'],style: TextStyle(fontSize: 16),),
                textColor: Colors.black,
              ),
              ListTile(
                title: Text('DATE',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(time.toString(),style: TextStyle(fontSize: 16),),
                textColor: Colors.black,
              ),
              ListTile(
                title: Text('CONTENT',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(data['content'],style: TextStyle(fontSize: 16),),
                textColor: Colors.black,
              ),
              Container(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: (){},
                            child: Text('Mark As Action Taken'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: (){},
                            child: Text('Ignore'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Center(child: spinkit);
      },
    );
  }
}
