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
import 'dart:async';
import 'package:ardor_calculator/library/crypto.dart';
import 'package:path_provider/path_provider.dart';

class SafeFileStore {

  static String _key = "SafeFileStore";

  String _fileName;

  SafeFileStore(this._fileName);

  static void setStoreKey(String key) {
    _key = key;
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileName = _getFilePath();
    return new File('$dir/$fileName');
  }

  String _getFilePath() {
    return _fileName;
  }

  Future<Null> write(String content) async{
    String text = await ArdorCrypto.encrypt(_key, content);
    await (await _getLocalFile()).writeAsString(text);
  }

  Future<String> readString() async{
    try {
      File file = await _getLocalFile();
      String content = await file.readAsString();
      String text = await ArdorCrypto.decrypt(_key, content);
      return text;
    } on FileSystemException {
      return null;
    }
  }

}