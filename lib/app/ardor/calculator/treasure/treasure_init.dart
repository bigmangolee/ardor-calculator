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

import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/config.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/password_keyboard.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:ardor_calculator/library/file_selector.dart';
import 'package:ardor_calculator/library/random_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ImportType {
  unencryptedData,
  encryptionData,
}

class TreasureInit {
  static Future<void> toInit(BuildContext context) async {
    //App need init.
    Config config = await StoreManager.getConfig();
    if (config.randomSalt == null) {
      _selectInitType(context);
    }
  }

  static Future<void> _selectInitType(BuildContext context) async {
    int t = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(S.current.treasureInit_select_init_type),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(S.current.treasureInit_select_init_no_data),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(S.current.treasureInit_select_init_plaintext_data),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回3
                  Navigator.pop(context, 3);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(S.current.treasureInit_select_init_ciphertext_data),
                ),
              ),
            ],
          );
        });

    if (t != null) {
      if (t == 1) {
        _setNewPassword(context);
      } else if (t == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportPage(ImportType.unencryptedData),
          ),
        );
      } else if (t == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportPage(ImportType.encryptionData),
          ),
        );
      }
    }
  }

  static void _setNewPassword(BuildContext context) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PasswordKeybordDialog(
              passwordType: PasswordType.newPass,
              passwordOk: (String p) async {
                Navigator.of(context).pop();
                Config config = await StoreManager.getConfig();
                config.randomSalt = RandomUtils.generateString(20);
                StoreManager.saveConfig(config);
                StoreManager.secretKey = p;
                StoreManager.saveUserData(UserDataStore(""));
                ArdorToast.show(S.current.treasureInit_tips_complete_password_setting);
              });
        });
  }
}

// ignore: must_be_immutable
class ImportPage extends StatefulWidget {
  ImportType type;

  ImportPage(this.type);

  @override
  State<StatefulWidget> createState() {
    return _ImportPageState(type);
  }
}

class _ImportPageState extends State<ImportPage> {
  ImportType type;
  String content = "";

  _ImportPageState(this.type);

  String getTitle() {
    return type == ImportType.encryptionData ?
    S.current.treasureInit_import_encrypted_data : S.current.treasureInit_import_plaintext_data;
  }

  String getNext() {
    return type == ImportType.encryptionData ?
    S.current.treasureInit_next_step_enter_password : S.current.treasureInit_next_step_new_password;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(getTitle()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: S.current.treasureInit_tooltip_ReadImportData,
            onPressed: () async {
              String path = await FileSelector.pickFile(context);
                AppLog.i(tag,"Import $path");
              if (path != null) {
                try {
                  String text = await new File(path).readAsString();
                  if (text != null) {
                    setState(() {
                      content = text;
                    });
                  }
                } on FileSystemException {
                  ArdorToast.show(S.current.treasureInit_tips_file_read_failed(path));
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.content_paste),
            tooltip: S.current.treasureInit_tooltip_PasteImportData,
            onPressed: () async {
              var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
              if (clipboardData != null) {
                ///Display the content of the obtained pasteboard
                setState(() {
                  content = clipboardData.text;
                });
              }
            },
          ),
        ],
      ),
      body: new ListView(children: <Widget>[new Text(content)]),
      bottomNavigationBar:
          RaisedButton(child: new Text(getNext()), onPressed: doNext),
    );
  }

  void doNext() {
    if (content == null || content.isEmpty) {
      ArdorToast.show(S.current.treasureInit_tips_please_import_the_data_source);
      return;
    }
    if (type == ImportType.encryptionData) {
      _getOldPassword(content);
    } else {
      try {
        UserDataStore dataStore = UserDataStore.parseJson(content);
        if (dataStore == null) {
          ArdorToast.show(S.current.treasureInit_tips_data_format_parsing_failed);
        } else {
          _setNewPassword(dataStore);
        }
      } catch (e) {
        ArdorToast.show(S.current.treasureInit_tips_data_format_parsing_failed);
      }
    }
  }

  void _setNewPassword(UserDataStore userDataStore) async {
    int i = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PasswordKeybordDialog(
              passwordType: PasswordType.newPass,
              passwordOk: (String p) async {
                Navigator.of(context).pop(1);
                Config config = await StoreManager.getConfig();
                config.randomSalt = RandomUtils.generateString(20);
                StoreManager.saveConfig(config);
                StoreManager.secretKey = p;
                StoreManager.saveUserData(userDataStore);
                ArdorToast.show(S.current.treasureInit_tips_complete_the_plaintext_data_import);
              });
        });
    if (i == 1) {
      //退出数据导入页面。
      Navigator.of(context).pop();
    }
  }

  void _getOldPassword(String data) async {
    int i = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PasswordKeybordDialog(
              passwordType: PasswordType.importPass,
              encryptionData: data,
              importCallback: (String p, UserDataStore userDataStore) async {
                Navigator.of(context).pop(1);
                Config config = await StoreManager.getConfig();
                config.randomSalt = RandomUtils.generateString(20);
                StoreManager.saveConfig(config);
                StoreManager.secretKey = p;
                StoreManager.saveUserData(userDataStore);
                ArdorToast.show(S.current.treasureInit_tips_complete_the_ciphertext_data_import);
              });
        });

    if (i == 1) {
      //退出数据导入页面。
      Navigator.of(context).pop();
    }
  }
}
