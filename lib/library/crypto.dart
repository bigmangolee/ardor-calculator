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

class ArdorCrypto {
  static const _TAG = "ArdorCrypto";
  static const perform = const MethodChannel("calculator.ardor.app/crypto");

  static Future<String> encrypt(String key, String content) async{
    try {
      String text = await perform.invokeMethod("encrypt", {'key': key, 'content': content});
      return text;
    } on PlatformException catch (e) {
      String ee = "Failed to encrypt : '${e.message}'.";
      AppLog.w(_TAG, ee);
    }
    return null;
  }

  static Future<String> decrypt(String key, String content) async{
    try {
      String text = await perform.invokeMethod("decrypt", {'key': key, 'content': content});
      return text;
    } on PlatformException catch (e) {
      String ee = "Failed to decrypt : '${e.message}'.";
      AppLog.w(_TAG, ee);
    }
    return null;
  }
}