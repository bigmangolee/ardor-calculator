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


import 'package:ardor_calculator/library/applog.dart';
import 'package:flutter/services.dart';

class AppInfo {
  static const _TAG = "AppInfo";
  static const perform = const MethodChannel("calculator.ardor.app/appinfo");

  //SHA1
  static Future<String> singInfo(String type) async{
    try {
      String text = await perform.invokeMethod("singInfo", {'type': type});
      return text;
    } on PlatformException catch (e) {
      String ee = "Failed to singInfo : '${e.message}'.";
      AppLog.w(_TAG, ee);
    }
    return null;
  }
}