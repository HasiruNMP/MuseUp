import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({Key? key}) : super(key: key);

  @override
  _SetProfileScreenState createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              MUText1("What's your name?"),
              const TextField (
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              MUText1("What's your birthday?"),
              const TextField (
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              MUText1("Main Role"),
              const TextField (
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              MUText1("Instruments"),
              const TextField (
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MUText1 extends StatelessWidget {
  String text;
  MUText1(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
