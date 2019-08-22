// Copyright 2019-present the Anise.App authors. All Rights Reserved.
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


import 'package:flutter/services.dart';

class AppLog {
  static const perform = const MethodChannel("calculator.anise.app/app_log");

  static bool isEnable = true;

  static Future<void> _log(String level,String tag,String msg) async {
    if (!isEnable) {
      return;
    }

    try {
      await perform.invokeMethod(level, {'tag': tag, 'msg': msg});
    } on PlatformException catch (e) {
      String ee = "Failed to AppLog : '${e.message}'.";
      print(ee);
    }
  }

  static void v(String tag, String message) {
    _log('logV',tag,message);
  }

  static void d(String tag, String message) {
    _log('logD',tag,message);
  }

  static void i(String tag, String message) {
    _log('logI',tag,message);
  }

  static void w(String tag, String message) {
    _log('logW',tag,message);
  }

  static void e(String tag, String message) {
    _log('logE',tag,message);
  }
}