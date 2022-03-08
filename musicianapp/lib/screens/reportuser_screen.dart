import 'package:flutter/material.dart';

class ReportUser extends StatefulWidget {
  const ReportUser({Key? key}) : super(key: key);

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {

  String reportSubject = 'One';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report User'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                Text('Report Subject: '),
                dropDownSubject()
              ],
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              textAlign: TextAlign.justify,
            ),
            ElevatedButton(onPressed: (){}, child: Text('Submit'))
          ],
        ),
      ),
    );
  }

  Widget dropDownSubject() {
    return DropdownButton<String>(
      value: reportSubject,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          reportSubject = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


}
