

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastLength { SHORT, LONG }

class ArdorToast {

  static Future<bool> show(
    String msg, {
    ToastLength length,
  }) async {
    Toast l = Toast.LENGTH_SHORT;
    if (length == ToastLength.LONG) {
      l = Toast.LENGTH_LONG;
    }
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: l,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.lime[100],
      textColor: Colors.deepOrange,
    );

  }
}