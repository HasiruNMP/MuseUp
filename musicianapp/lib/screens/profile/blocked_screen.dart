import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicianapp/services/auth_service.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {


  @override
  Widget build(BuildContext context) {
    //count();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You have been blocked because you have violated the community guidlines! \n\n You will be signed out now. \n\n',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  AuthService().signOut();
                }, child: Text("Sign Out"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
