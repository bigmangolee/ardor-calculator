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

import 'package:ardor_calculator/app/ardor/store/safe_file_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/config.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/library/crypto.dart';
import 'package:ardor_calculator/library/applog.dart';

const String tag = "StoreManager";
class StoreManager {
  static String _sotreFileName = "UserDataStore";
  static String _secretKey;

  static String get secretKey => _secretKey;

  static set secretKey(String value) {
    if (_secretKey != value) {
      _userDataStore = null;
    }
    _secretKey = value;
  }

  static Config _config;
  static UserDataStore _userDataStore;

  static Future<Config> getConfig() async{
    if (_config != null) {
      return _config;
    }
    SafeFileStore safeFileStore = SafeFileStore("Config");
    String content = await safeFileStore.readString();
    if (content != null) {
      _config = Config.parseJson(content);
    }
    if (_config == null) {
      _config = new Config();
    }
    return _config;
  }

  static Future<bool> saveConfig(Config config) async{
    SafeFileStore safeFileStore = SafeFileStore("Config");
    String content = config.encodeJson();
    await safeFileStore.write(content);
    _config = config;
    return true;
  }

  static Future<bool> checkPassword(String password) async{
    _config = await getConfig();
    UserDataStore userDataStore;
    SafeFileStore safeFileStore = SafeFileStore(_sotreFileName);
    String content = await safeFileStore.readString();
    if (content != null) {
      String key = "$password${_config.randomSalt}";
      String text = await ArdorCrypto.decrypt(key, content);
      if (text != null) {
        userDataStore = UserDataStore.parseJson(text);
      }
    }
    return userDataStore != null;
  }

  static void reCacheUserData() {
    _userDataStore = null;
  }

  static Future<UserDataStore> getUserData() async{
    if (_userDataStore != null) {
      return _userDataStore;
    }
    _config = await getConfig();
    SafeFileStore safeFileStore = SafeFileStore(_sotreFileName);
    String content = await safeFileStore.readString();
    if (content != null) {
      String key = "$_secretKey${_config.randomSalt}";
      AppLog.i(tag, "getUserData secretKey: $key");
      String text = await ArdorCrypto.decrypt(key, content);
      if (text != null) {
        _userDataStore = UserDataStore.parseJson(text);
      }
    }
    return _userDataStore;
  }

  static Future<bool> saveUserData(UserDataStore userData) async{
    _config = await getConfig();
    SafeFileStore safeFileStore = SafeFileStore(_sotreFileName);
    String content = userData.encodeJson();
    String key = "$_secretKey${_config.randomSalt}";
    AppLog.i(tag, "saveUserData secretKey: $key");
    String text = await ArdorCrypto.encrypt(key, content);
    await safeFileStore.write(text);
    _userDataStore = userData;
    return true;
  }
}