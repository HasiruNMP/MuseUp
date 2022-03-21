import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/common/globals.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/account/setlocation_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GetStartedScreen extends StatefulWidget {

  String userID;
  int profileState;

  GetStartedScreen(this.userID,this.profileState, {Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {

    /*switch(widget.profileState){
      case 0: {return SetProfileScreen(widget.userID);}
      case 1: {return EnterRoleInfo(widget.userID);}
      case 2: {return EnterBio();}
    }*/
    return Container();
  }
}


class SetProfileScreen extends StatefulWidget {

  String userID;

  SetProfileScreen(this.userID, {Key? key}) : super(key: key);

  @override
  _SetProfileScreenState createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {

  final tecFirstName = TextEditingController();
  final tecLastName = TextEditingController();
  String selectedGender = 'NotSelected';
  DateTime selectedDOB = DateTime.now();
  bool isDateSelected = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Details'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Your Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tecFirstName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tecLastName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 3,
                        children: List<Widget>.generate(Profile.genderList.length, (int index) {
                          return ChoiceChip(
                            label: Text(Profile.genderList[index]),
                            selected: selectedGender == Profile.genderList[index],
                            onSelected: (bool selected) {
                              setState(() {
                                selectedGender = selected ? Profile.genderList[index] : null;
                              });
                            },
                          );
                        },
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            '${selectedDOB.day}.${selectedDOB.month}.${selectedDOB.year}',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                            //textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: (){
                              _selectDate(context);
                            },
                            child: const Text('Select Date'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){

                          if(selectedGender != 'NotSelected' && isDateSelected){
                            if (_formKey.currentState!.validate()) {
                              Profile().addPersonalInfo(tecFirstName.text,tecLastName.text,selectedDOB,selectedGender);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EnterRoleInfo(widget.userID)),
                              );
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Select all fields')),
                            );
                          }

                        },
                        child: Text('CONTINUE')
                      ),
                    ),
                  ],
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
        initialDate: selectedDOB,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDOB) {
      setState(() {
        selectedDOB = picked;
        isDateSelected = true;
      });
    }
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
  String selectedInstrument = 'Guitar';
  List<String> selectedGenres = [];
  List<bool> selectedRoleList = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Details'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    const Text(
                      'What is your main role?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Wrap(
                      spacing: 2,
                      children: List<Widget>.generate(Profile.roleList.length, (int index) {
                        return ChoiceChip(
                          label: Text(Profile.roleList[index]),
                          selected: mainRole == Profile.roleList[index],
                          onSelected: (bool selected) {
                            setState(() {
                              mainRole = selected ? Profile.roleList[index] : null;
                              selectedRoleList = [false, false, false, false];
                              selectedRoleList[index] = true;
                            });
                          },
                        );
                      },).toList(),
                    ),
                    const Text(
                      'What instrument do you play?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Container(
                      child: mainRole != 'Instrumentalist'? const Center(child: Text('Not Applicable'),) :
                      Wrap(
                        spacing: 2,
                        children: List<Widget>.generate(Profile.instrumentList.length, (int index) {
                          return ChoiceChip(
                            label: Text(Profile.instrumentList[index]),
                            selected: selectedInstrument == Profile.instrumentList[index],
                            onSelected: (bool selected) {
                              setState(() {
                                selectedInstrument = selected ? Profile.instrumentList[index] : null;
                              });
                            },
                          );
                        },
                        ).toList(),
                      ),
                    ),
                    const Text(
                      'What are your music genres?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Wrap(
                      spacing: 2,
                      children: List<Widget>.generate(Profile.genreList.length, (int index) {
                        return FilterChip(
                          label: Text(Profile.genreList[index]),
                          selected: selectedGenres.contains(Profile.genreList[index]),
                          onSelected: (bool selected) {
                            setState(() {
                              if(selected){
                                selectedGenres.add(Profile.genreList[index]);
                              }else{
                                selectedGenres.remove(Profile.genreList[index]);
                              }
                            });
                          },
                        );
                      },
                      ).toList(),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Profile().addRoleInfo(mainRole,selectedRoleList,selectedInstrument,selectedGenres);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EnterBio()),
                        );
                      },
                      child: const Text('SEND'),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  final tecBio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Bio'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: tecBio,
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      textAlign: TextAlign.justify,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        //labelText: 'Bio',
                        hintText:  'Type your bio here',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Profile().addBio(tecBio.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SetLocationScreen()),
                        );
                      },
                      child: const Text('NEXT'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



