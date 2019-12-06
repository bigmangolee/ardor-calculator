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

import 'package:ardor_calculator/app/ardor/calculator/cal_blockchain.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_general.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_financial.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_scientific.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/callback.dart';
import 'package:ardor_calculator/library/crypto.dart';
import 'package:flutter/material.dart';

enum PasswordType { newPass, resetPass, exportPass, importPass }

typedef ImportCallback = void Function(
    String pass, UserDataStore userDataStore);

// ignore: must_be_immutable
class PasswordKeybordDialog extends StatefulWidget {
  PasswordType passwordType;
  StringCallback passwordOk;
  ImportCallback importCallback;
  String encryptionData;

  PasswordKeybordDialog({
    Key key,
    this.passwordType,
    this.passwordOk,
    this.importCallback,
    this.encryptionData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PasswordKeybordDialogState(
        passwordType, passwordOk, importCallback, encryptionData);
  }
}

class _PasswordKeybordDialogState extends State<PasswordKeybordDialog> {
  PasswordType passwordType;
  StringCallback passwordOk;
  ImportCallback importCallback;
  String encryptionData;

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

  _PasswordKeybordDialogState(this.passwordType, this.passwordOk,
      this.importCallback, this.encryptionData) {
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
      showToast(S.current.passwordKeybord_tips_please_enter_new_password);
      return S.current.passwordKeybord_tips_new_password;
    } else if (passwordType == PasswordType.resetPass) {
      showToast(S.current.passwordKeybord_tips_please_enter_original_password);
      return S.current.passwordKeybord_tips_reset_password;
    } else if (passwordType == PasswordType.exportPass) {
      showToast(S.current.passwordKeybord_tips_please_enter_export_password);
      return S.current.passwordKeybord_tips_export_password;
    } else if (passwordType == PasswordType.importPass) {
      showToast(S.current.passwordKeybord_tips_please_enter_import_password);
      return S.current.passwordKeybord_tips_import_password;
    }
    return "";
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
              tooltip: S.current.common_cancel,
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
      showToast(S.current.passwordKeybord_tips_please_input);
      return;
    }
    if (passwordType == PasswordType.newPass) {
      if (newPasswrod1 == null || newPasswrod1.isEmpty) {
        newPasswrod1 = currentInput;
        showToast(S.current.passwordKeybord_tips_please_enter_your_password_again);
        resetCal();
      } else if (newPasswrod2 == null || newPasswrod2.isEmpty) {
        if (currentInput == newPasswrod1) {
          newPasswrod2 = currentInput;
          resetCal();
          if (passwordOk != null) {
            passwordOk(newPasswrod2);
          }
        } else {
          showToast(S.current.passwordKeybord_tips_passwords_are_inconsistent);
        }
      } else {
        if (newPasswrod2 == newPasswrod1) {
          resetCal();
          if (passwordOk != null) {
            passwordOk(newPasswrod2);
          }
        } else {
          showToast(S.current.passwordKeybord_tips_passwords_are_inconsistent);
        }
      }
    } else if (passwordType == PasswordType.resetPass) {
      if (oldPasswrod == null || oldPasswrod.isEmpty) {
        StoreManager.checkPassword(currentInput).then((bool) {
          if (bool) {
            oldPasswrod = currentInput;
            resetCal();
            showToast(S.current.passwordKeybord_tips_please_enter_new_password);
          } else {
            showToast(S.current.passwordKeybord_tips_original_password_verification_does_not_pass);
          }
        });
      } else if (newPasswrod1 == null || newPasswrod1.isEmpty) {
        newPasswrod1 = currentInput;
        showToast(S.current.passwordKeybord_tips_to_confirm_the_new_password_again);
        resetCal();
      } else if (newPasswrod2 == null || newPasswrod2.isEmpty) {
        if (currentInput == newPasswrod1) {
          newPasswrod2 = currentInput;
          resetCal();
          if (passwordOk != null) {
            passwordOk(newPasswrod2);
          }
        } else {
          showToast(S.current.passwordKeybord_tips_passwords_are_inconsistent);
        }
      } else {
        if (newPasswrod2 == newPasswrod1) {
          resetCal();
          if (passwordOk != null) {
            passwordOk(newPasswrod2);
          }
        } else {
          showToast(S.current.passwordKeybord_tips_passwords_are_inconsistent);
        }
      }
    } else if (passwordType == PasswordType.exportPass) {
      if (newPasswrod1 == null || newPasswrod1.isEmpty) {
        newPasswrod1 = currentInput;
        showToast(S.current.passwordKeybord_tips_please_enter_your_password_again);
        resetCal();
      } else if (newPasswrod2 == null || newPasswrod2.isEmpty) {
        if (currentInput == newPasswrod1) {
          newPasswrod2 = currentInput;
          resetCal();
          if (passwordOk != null) {
            passwordOk(newPasswrod2);
          }
        } else {
          showToast(S.current.passwordKeybord_tips_passwords_are_inconsistent);
        }
      } else {
        if (newPasswrod2 == newPasswrod1) {
          resetCal();
          if (passwordOk != null) {
            passwordOk(newPasswrod2);
          }
        } else {
          showToast(S.current.passwordKeybord_tips_passwords_are_inconsistent);
        }
      }
    } else if (passwordType == PasswordType.importPass) {
      ArdorCrypto.decrypt(currentInput, encryptionData).then((onValue) {
        if (onValue == null || onValue.isEmpty) {
          ArdorToast.show(S.current.passwordKeybord_tips_data_decryption_failed);
          return;
        }
        try {
          UserDataStore dataStore = UserDataStore.parseJson(onValue);
          if (dataStore == null) {
            ArdorToast.show(S.current.passwordKeybord_tips_data_format_parsing_failed);
          } else {
            importCallback(currentInput, dataStore);
          }
        } catch (e) {
          ArdorToast.show(S.current.passwordKeybord_tips_data_format_parsing_failed);
        }
      });
    }
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
        CalScientific((String p) {
          passwordDown(p);
        }),
        CalFinancial((String p) {
          passwordDown(p);
        }),
        CalBlockChain((String p) {
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
