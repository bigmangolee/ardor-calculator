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
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_general.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_financial.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_mathematicall.dart';
import 'package:flutter/material.dart';

enum PasswordType { newPass, resetPass }

// ignore: must_be_immutable
class PasswordKeybordDialog extends StatefulWidget {
  PasswordType passwordType;
  VoidCallback passwordOk;

  PasswordKeybordDialog({
    Key key,
    this.passwordType,
    this.passwordOk,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PasswordKeybordDialogState(passwordType, passwordOk);
  }
}

class _PasswordKeybordDialogState extends State<PasswordKeybordDialog> {
  PasswordType passwordType;
  VoidCallback passwordOk;

  String oldPasswrod;
  String newPasswrod1;
  String newPasswrod2;

  List<CalBase> calculators;

  Color backgroundColor;

  double elevation;

  Duration insetAnimationDuration = const Duration(milliseconds: 100);

  Curve insetAnimationCurve = Curves.decelerate;

  ShapeBorder shape;

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  _PasswordKeybordDialogState(this.passwordType, this.passwordOk) {
    initCalculators();
  }

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: backgroundColor ??
                  dialogTheme.backgroundColor ??
                  Theme.of(context).dialogBackgroundColor,
              elevation:
                  elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: getContent(),
            ),
          ),
        ),
      ),
    );
  }

  String getTips() {
    if (passwordType == PasswordType.newPass) {
      return "新设密码";
    } else if (passwordType == PasswordType.resetPass) {
      return "重置密码";
    } else {
      return "Input Password";
    }
  }

  Widget getContent() {
    return new DefaultTabController(
      length: calculators.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(
            getTips(),
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: new TabBar(
            isScrollable: true,
            tabs: calculators.map((CalBase cal) {
              return new Tab(
                text: cal.getName(),
                icon: new Icon(cal.getIcon()),
              );
            }).toList(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.cached),
              tooltip: 'cancel',
              onPressed: cleanCache,
            ),
          ],
        ),
        body: new TabBarView(
          children: calculators.map((CalBase cal) {
            return new Padding(
              padding: const EdgeInsets.all(3.0),
              child: new ChoiceKeyboard(cal: cal),
            );
          }).toList(),
        ),
      ),
    );
  }

  void passwordDown(String currentInput) {
    if (currentInput == null || currentInput.isEmpty) {
      showToast("请输入");
      return;
    }
    if (passwordType == PasswordType.newPass) {
      if (newPasswrod1 == null || newPasswrod1.isEmpty) {
        newPasswrod1 = currentInput;
        showToast("请再次输入密码。");
        resetCal();
      } else if (newPasswrod2 == null || newPasswrod2.isEmpty) {
        if (currentInput == newPasswrod1) {
          newPasswrod2 = currentInput;
          saveNewPassword(newPasswrod2);
          resetCal();
          showToast("完成密码设置。");
          Navigator.of(context).pop();
          if (passwordOk != null) {
            passwordOk();
          }
        } else {
          showToast("密码不一致，请重新输入。");
        }
      } else {
        if (newPasswrod2 == newPasswrod1) {
          saveNewPassword(newPasswrod2);
          resetCal();
          showToast("完成密码设置。");
          Navigator.of(context).pop();
          if (passwordOk != null) {
            passwordOk();
          }
        } else {
          showToast("密码不一致，请重新输入。");
        }
      }
    } else if (passwordType == PasswordType.resetPass) {
      if (oldPasswrod == null || oldPasswrod.isEmpty) {
        StoreManager.checkPassword(currentInput).then((bool) {
          if (bool) {
            oldPasswrod = currentInput;
            resetCal();
            showToast("请输入新密码。");
          } else {
            showToast("原密码校验不通过，请重新输入。");
          }
        });
      } else if (newPasswrod1 == null || newPasswrod1.isEmpty) {
        newPasswrod1 = currentInput;
        showToast("请再次输入，确认新密码。");
        resetCal();
      } else if (newPasswrod2 == null || newPasswrod2.isEmpty) {
        if (currentInput == newPasswrod1) {
          newPasswrod2 = currentInput;
          resetNewPassword(oldPasswrod, newPasswrod2);
          resetCal();
          showToast("完成密码重置。");
          Navigator.of(context).pop();
          if (passwordOk != null) {
            passwordOk();
          }
        } else {
          showToast("密码不一致，请重新输入。");
        }
      } else {
        if (newPasswrod2 == newPasswrod1) {
          resetNewPassword(oldPasswrod, newPasswrod2);
          resetCal();
          showToast("完成密码重置。");
          Navigator.of(context).pop();
          if (passwordOk != null) {
            passwordOk();
          }
        } else {
          showToast("密码不一致，请重新输入。");
        }
      }
    } else {}
  }

  void saveNewPassword(String password) async {
    Config config = await StoreManager.getConfig();
    //TODO 需要实现随机数
    config.randomSalt = "init";
    StoreManager.saveConfig(config);
    StoreManager.secretKey = password;
    StoreManager.saveUserData(UserDataStore(""));
  }

  void resetNewPassword(String oldPassword, String newPassword) async {
    UserDataStore userDataStore = await StoreManager.getUserData();
    StoreManager.secretKey = newPassword;
    StoreManager.saveUserData(userDataStore);
  }

  void cleanCache() {
    oldPasswrod = null;
    newPasswrod1 = null;
    newPasswrod2 = null;
    resetCal();
  }

  void resetCal() {
    for (CalBase cal in calculators) {
      cal.reset();
    }
  }

  void initCalculators() {
    if (calculators == null) {
      calculators = <CalBase>[
        CalGeneral((String p) {
          passwordDown(p);
        }),
        CalMathematical((String p) {
          passwordDown(p);
        }),
        CalFinancial((String p) {
          passwordDown(p);
        }),
      ];
    }
  }

  void showToast(String msg) {
    ArdorToast.show(msg);
  }
}

class ChoiceKeyboard extends StatelessWidget {
  const ChoiceKeyboard({Key key, this.cal}) : super(key: key);

  final CalBase cal;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.white,
      child: new Center(
        child: cal,
      ),
    );
  }
}
