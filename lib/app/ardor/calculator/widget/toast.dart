// Copyright 2019-present the Ardor.App authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


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