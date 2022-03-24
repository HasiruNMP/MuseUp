import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {

  int i = 5;

  void count(){
    final periodicTimer = Timer.periodic(
      const Duration(seconds: 1), (timer) {
        setState(() {
          i = i - 1;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //count();
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'You have been blocked because you have violated the community guidlines! \n\n You will be signed out now. \n\n $i',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 15,
                //fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
