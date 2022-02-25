import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down_circle_outlined))
        ],
      ),
      body: ListView(
        children: [
          CircleAvatar(radius: 80,backgroundColor: Colors.green,),
          Text('Hasiru Navodya'),
          Row(children: [Icon(Icons.location_on_outlined),Text('Homagama, Sri Lanka'),],)
        ],
      ),
    );
  }
}
