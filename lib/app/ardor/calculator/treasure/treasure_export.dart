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

import 'package:ardor_calculator/app/ardor/calculator/treasure/password_keyboard.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class TreasureExport {
  static Future<void> toExport(BuildContext context) async {
    _selectExportType(context);
  }

  static Future<void> _selectExportType(BuildContext context) async {
    int i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(S.current.treasureExport_select_export_type),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(S.current.treasureExport_select_export_plaintext_data),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(S.current.treasureExport_select_export_ciphertext_data),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      if (i == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExportPage(null),
          ),
        );
      } else {
        String p = await _getExportPassword(context);
        if (p != null && p.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExportPage(p),
            ),
          );
        }
      }
    }
  }

  static Future<String> _getExportPassword(BuildContext context) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PasswordKeybordDialog(
            passwordType: PasswordType.exportPass,
            passwordOk: (String p) {
              Navigator.of(context).pop(p);
            },
          );
        });
  }
}

// ignore: must_be_immutable
class ExportPage extends StatefulWidget {
  String password;

  ExportPage(this.password);

  @override
  State<StatefulWidget> createState() {
    return _ExportPageState(password);
  }
}

class _ExportPageState extends State<ExportPage> {
  String password;
  String content;

  _ExportPageState(this.password) {
    StoreManager.getUserData().then((UserDataStore value) {
      String text = value.encodeJson();
      if (password != null && password.isNotEmpty) {
        ArdorCrypto.encrypt(password, text).then((onValue) {
          setState(() {
            content = onValue;
          });
        });
      } else {
        setState(() {
          content = text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.current.treasureExport_export_data),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.current.treasureExport_tooltip_SaveExportData,
            onPressed: () async{
              try {
                String path = await saveExport(content);
                ArdorToast.show(S.current.treasureExport_tips_export_data_save(path));
              } catch (e) {
                ArdorToast.show(S.current.treasureExport_tips_save_fail_no_permission);
              }

            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: S.current.treasureExport_tooltip_ShareExportData,
            onPressed: () async {
              Share.share(content);
            },
          ),
          IconButton(
            icon: const Icon(Icons.content_copy),
            tooltip: S.current.treasureExport_tooltip_CopyExportData,
            onPressed: () {
              ClipboardData data = new ClipboardData(text:content);
              Clipboard.setData(data);
              ArdorToast.show(S.current.treasureExport_tips_export_data_copied_to_clipboard);
            },
          ),
        ],
      ),
      body: new ListView(children: <Widget>[new Text(content)]),
    );
  }

  Future<String> saveExport(String content) async{
      String t = DateTime.now().toString();
      String dir = (await getExternalStorageDirectory()).path;
      String type = "unencrypted";
      if (password != null && password.isNotEmpty) {
        type = "encrypt";
      }
      String fileName = "export_${type}_$t.txt";
      File f = new File('$dir/ardor/calculator/$fileName');
      if(!f.existsSync()){
        f.createSync(recursive:true);
      }
      f.writeAsString(content);
      return f.absolute.path;
  }
}
