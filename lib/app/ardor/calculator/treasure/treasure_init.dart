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


import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/config.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/password_keyboard.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:flutter/material.dart';


class TreasureInit{

  static Future<void> toInit(BuildContext context) async{
    //App need init.
    Config config = await StoreManager.getConfig();
    if (config.randomSalt == null) {
      _selectInitType(context);
    }
  }

  static Future<void> _selectInitType(BuildContext context) async {
    int i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请选择初始化方式'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('1.无数据导入初始化'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('2.明文数据导入初始化'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回3
                  Navigator.pop(context, 3);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('3.密文数据导入初始化'),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      if (i == 1) {
        _setNewPassword(context);
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
              //TODO 需要实现随机数
              config.randomSalt = "init";
              StoreManager.saveConfig(config);
              StoreManager.secretKey = p;
              StoreManager.saveUserData(UserDataStore(""));
              ArdorToast.show("完成密码设置。");
            });
        });
  }
}



