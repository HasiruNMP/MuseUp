import 'package:flutter/material.dart';

final ButtonStyle flatButtonStyle1 = TextButton.styleFrom(
  primary: Colors.white,
  backgroundColor: Colors.indigo,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),

  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
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