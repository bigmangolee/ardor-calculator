


import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/config.dart';
import 'package:flutter/material.dart';

import 'password_keyboard.dart';
import 'store/store_manager.dart';

class TreasureInit{

  static Future<void> toInit(BuildContext context) async{
    //App need init.
    Config config = await StoreManager.getConfig();
    if (config.randomSalt == null) {
      selectInitType(context);
    }
  }

  static Future<void> selectInitType(BuildContext context) async {
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
      Config config = await StoreManager.getConfig();
      config.randomSalt = "init";
      StoreManager.saveConfig(config);
      //TODO
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
          return PasswordKeybordDialog();
        });
  }
}



