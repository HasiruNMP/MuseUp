import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UX {
  static Future<void> showLongToast(String text) async {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black.withOpacity(0.7),
      fontSize: 15.0,
    );
  }
}