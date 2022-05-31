

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../globals/globals.dart';
import '../../services/database_service.dart';

class AddFeedbackScreen extends StatefulWidget {

  const AddFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {

  final tecDesc = TextEditingController();
  final tecName = TextEditingController();
  int rate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Feedback"),
      ),
      body: SafeArea(
        child: ListView(
          children: [

            SizedBox(height: 30,),

          Center(
            child: RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              rate = rating.toInt();
            },
        ),
          ),
            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tecDesc,
                keyboardType: TextInputType.multiline,
                maxLines: 12,
                maxLength: 800,
                textAlign: TextAlign.justify,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: 'Description',
                  hintText:  'Description',
                ),
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: (){
                  sendReport(rate);
                  Navigator.pop(context);
                },
                child: Text("SUBMIT"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendReport(int rate) async {

    String reporterName = '';

    DatabaseService.userColRef.doc(Globals.userID).get().then((DocumentSnapshot doc) {
      final data2 = doc.data() as Map<String, dynamic>;
      reporterName = data2['fName'] + ' ' + data2['lName'];
      FirebaseFirestore.instance.collection('feedback').add({
        'rating': rate,
        'name':reporterName,
        'userID':Globals.userID,
        'time': DateTime.now(),
        'content': tecDesc.text,
      }).then((value) => print("Report Added")).catchError((error) => print("Failed to send report: $error"));
    },
      onError: (e) => print("Error getting document: $e"),
    );
  }

}
