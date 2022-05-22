import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Color lightPurple = Colors.deepPurple.shade50;
Color darkPurple = Color(0xFF40407a);

const spinkit = SpinKitFadingFour(
  color: Colors.indigo,
  size: 25.0,
);

final ButtonStyle flatButtonStyle1 = TextButton.styleFrom(
  primary: Colors.white,
  backgroundColor: Colors.indigo,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),

  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);

final ButtonStyle flatButtonStyleDoc1 = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  ),
);



class MUTextField1 extends StatelessWidget {

  const MUTextField1({
    Key? key,
    required this.controller,
    required this.label
  }) : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }
}