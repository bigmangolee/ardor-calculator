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


import 'dart:io';

import 'package:ardor_calculator/app/ardor/store/safe_file_store.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:device_info/device_info.dart';

class AppGlobal {

  static AppGlobal _instance = AppGlobal();

  String treasuresKey;
  //是否显示私有隐藏数据。
  static bool isPrivateShow = false;

  static AppGlobal get instance => _instance;

  AppGlobal();

  Future<void> init() async{
    String key = await getDeviceInfo();
    AppLog.i("AppGlobal", "init : $key");
    SafeFileStore.setStoreKey(key);
  }

  Future<String> getDeviceInfo() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    }else if(Platform.isAndroid){
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return "${androidDeviceInfo.androidId}${androidDeviceInfo.device}${androidDeviceInfo.model}";
    }
    return "AppGlobal";
  }
}