import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/account/setlocation_screen.dart';
import 'package:musicianapp/screens/account/uploadphoto_screen.dart';
import 'package:musicianapp/screens/account/uploadvideo_screen.dart';
import 'package:musicianapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:musicianapp/models/user_model.dart';



class SetProfileScreen extends StatefulWidget {

  String userID;

  SetProfileScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _SetProfileScreenState createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {

  final tecName = TextEditingController();
  final tecBio = TextEditingController();
  List genderList = ['Male','Female','Other',];
  String gender = 'NotSelected';
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              MUTextField1(controller: tecName, label: 'Name'),
              Text(
                'What is your gender?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Wrap(
                children: List<Widget>.generate(genderList.length, (int index) {
                  return ChoiceChip(
                    label: Text(genderList[index]),
                    selected: gender == genderList[index],
                    onSelected: (bool selected) {
                      setState(() {
                        gender = selected ? genderList[index] : null;
                      });
                    },
                  );
                },
                ).toList(),
              ),
              Text(
                'What is your date of birth?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    //textAlign: TextAlign.center,
                  ),
                  OutlinedButton(onPressed: (){_selectDate(context);}, child: Text('Select Date'),),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EnterRoleInfo(widget.userID)),
                    );
                  },
                  child: Text('NEXT'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: addUser,
                  child: Text('send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> addUser() {
    return Globals.users.doc(widget.userID).set({
      'full_name': "Mary Jane",
      'age': 18
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }
}

class EnterRoleInfo extends StatefulWidget {
  String userID;
  EnterRoleInfo(this.userID, {Key? key}) : super(key: key);

  @override
  State<EnterRoleInfo> createState() => _EnterRoleInfoState();
}

class _EnterRoleInfoState extends State<EnterRoleInfo> {

  String mainRole = 'Vocalist';
  String instrument = 'Guitar';
  List roleList = ['Composer','Instrumentalist','Vocalist', 'Producer'];
  List genreList = ['Any Genre','Pop','Classical','Rock', 'Jazz'];
  List selectedGenres = [];
  List instrumentList = ['Guitar','Piano','Drums', 'Violin','Harp','Cello','Trumpet','Viola','Bass Guitar','Percussion','Flute'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text(
                'What is your main role?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Wrap(
                children: List<Widget>.generate(roleList.length, (int index) {
                  return ChoiceChip(
                    label: Text(roleList[index]),
                    selected: mainRole == roleList[index],
                    onSelected: (bool selected) {
                      setState(() {
                        mainRole = selected ? roleList[index] : null;
                      });
                    },
                  );
                },
                ).toList(),
              ),
              Text(
                'What instrument do you play?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Container(
                child: mainRole != 'Instrumentalist'? Center(child: Text('Not Applicable'),) : Wrap(
                  children: List<Widget>.generate(instrumentList.length, (int index) {
                    return ChoiceChip(
                      label: Text(instrumentList[index]),
                      selected: instrument == instrumentList[index],
                      onSelected: (bool selected) {
                        setState(() {
                          instrument = selected ? instrumentList[index] : null;
                        });
                      },
                    );
                  },
                  ).toList(),
                ),
              ),
              Text(
                'What are your music genres?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Wrap(
                children: List<Widget>.generate(genreList.length, (int index) {
                  return FilterChip(
                    label: Text(genreList[index]),
                    selected: selectedGenres.contains(genreList[index]),
                    onSelected: (bool selected) {
                      setState(() {
                        if(selected){
                          selectedGenres.add(genreList[index]);
                        }else{
                          selectedGenres.remove(genreList[index]);
                        }
                      });
                    },
                  );
                },
                ).toList(),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EnterBio()),
                    );
                  },
                  child: Text('NEXT'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    Profile().addRoleInfo();
                  },
                  child: Text('SEND'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnterBio extends StatefulWidget {
  const EnterBio({Key? key}) : super(key: key);

  @override
  State<EnterBio> createState() => _EnterBioState();
}

class _EnterBioState extends State<EnterBio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Bio'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bio',
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SetLocationScreen()),
                    );
                  },
                  child: Text('NEXT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



