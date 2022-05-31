import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/globals/globals.dart';
import 'package:musicianapp/services/database_service.dart';

class AddReportScreen extends StatefulWidget {

  final String userID;

  const AddReportScreen({required this.userID,Key? key}) : super(key: key);

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {

  final tecDesc = TextEditingController();
  final tecName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report User"),
      ),
      body: SafeArea(
        child: ListView(
          children: [

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
                  sendReport(widget.userID);
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

  Future<void> sendReport(String userID) async {

    String reporterName = '';
    String reporteeName = '';

    DatabaseService.userColRef.doc(userID).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
        reporteeName = data['fName'] + ' ' + data['lName'];
      DatabaseService.userColRef.doc(Globals.userID).get().then((DocumentSnapshot doc) {
        final data2 = doc.data() as Map<String, dynamic>;
        reporterName = data2['fName'] + ' ' + data2['lName'];
        FirebaseFirestore.instance.collection('reports').add({
          'reporteeName':reporteeName,
          'reporteeUID':userID,
          'reporterName':reporterName,
          'reporterUID':Globals.userID,
          'time': DateTime.now(),
          'content': tecDesc.text,
        }).then((value) => print("Report Added")).catchError((error) => print("Failed to send report: $error"));
      },
        onError: (e) => print("Error getting document: $e"),
      );
      },
      onError: (e) => print("Error getting document: $e"),
    );




  }

}
