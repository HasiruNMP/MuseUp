import 'package:adminweb/models/report_model.dart';
import 'package:adminweb/screens/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbacksScreen extends StatefulWidget {
  const FeedbacksScreen({Key? key}) : super(key: key);

  @override
  State<FeedbacksScreen> createState() => _FeedbacksScreenState();
}

class _FeedbacksScreenState extends State<FeedbacksScreen> {
  String _selectedDoc = 'none';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: StreamBuilder<QuerySnapshot>(
            stream: Reports.getFeedbacksStream(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: spinKit);
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
                            });
                          },
                          child: ListTile(
                            title: Text(data['name'].toString(),style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),),
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
        const VerticalDivider(),
        Expanded(
          flex: 8,
          child: _selectedDoc != 'none'? feedbackDetails(_selectedDoc) : const Center(child: Text('Select A Feedback'),),
        ),
      ],
    );
  }


  Widget feedbackDetails(String docID){
    return FutureBuilder<DocumentSnapshot>(
      future: Reports.getFeedBackDetailsFuture(docID),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          Timestamp timestamp = data['time'];
          DateTime time = timestamp.toDate();

          return ListView(
            children: [
              ListTile(
                title: const Text('USER',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(
                  data['name'],
                  style: const TextStyle(fontSize: 16),
                ),
                textColor: Colors.black,
              ),
              ListTile(
                title: const Text('DATE',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(time.toString(),style: const TextStyle(fontSize: 16),),
                textColor: Colors.black,
              ),
              ListTile(
                title: const Text('RATING',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Row(
                  children: List.generate(data['rating'],(index){
                    return const Icon(Icons.star,color: Colors.amber,size: 24,);
                  }),
                ),
                textColor: Colors.black,
              ),
              ListTile(
                title: const Text('CONTENT',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(data['content'].toString(),style: const TextStyle(fontSize: 16),),
                textColor: Colors.black,
              ),
            ],
          );
        }

        return const Center(child: spinKit);
      },
    );
  }
}
