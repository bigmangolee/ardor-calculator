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

import 'package:ardor_calculator/app/ardor/calculator/style/style.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/account.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/group.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef ChangeGroupCallback = void Function(Account account, int toGroupId);
typedef AccountCallback = void Function(Account account);

// ignore: must_be_immutable
class AccountHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AccountHomePageState();
  }

  static void showAccount(
      BuildContext context,
      Account acc,
      List<Group> groups,
      bool isEditEnable,
      ChangeGroupCallback changeGroupCallback,
      AccountCallback saveAccountCallback) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AccountEditDialog(
            account: acc,
            groups: groups,
            isEditEnable: isEditEnable,
            onSaveAccount: (Account account) {
              AppLog.i(tag, "onSaveAccount $account");
              if (acc.groupId != account.groupId) {
                //组id有变化，则县移除，后保存新组
                int gid = acc.groupId;
                acc.resetValues(account);
                acc.groupId = gid;
                if (changeGroupCallback != null) {
                  changeGroupCallback(acc, account.groupId);
                }
              } else {
                if (saveAccountCallback != null) {
                  saveAccountCallback(account);
                }
              }
            },
          );
        });
  }

  static void showEditOrNotDialog(
      BuildContext context,
      Account account,
      List<Group> groups,
      ChangeGroupCallback changeGroupCallback,
      AccountCallback saveAccountCallback,
      AccountCallback deleteAccountCallback) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              S.current.account_tips_select_operation_for_account(account.name),
              style: AppStyle.getAppStyle().dialog.titleText,
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    S.current.account_tips_select_operation_delete(account.name),
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    S.current.account_tips_select_operation_cancel,
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    S.current.account_tips_select_operation_view(account.name),
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    S.current.account_tips_select_operation_edit(account.name),
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                height: 30,
                width: 60,
                child: new RaisedButton(
                  child: new Text(
                    S.current.common_delete,
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (deleteAccountCallback != null) {
                      deleteAccountCallback(account);
                    }
//                    _deleteAccount(account);
                  },
                ),
              ),
              Container(
                height: 30,
                width: 60,
                child: new RaisedButton(
                  child: new Text(
                    S.current.common_cancel,
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                height: 30,
                width: 60,
                child: new RaisedButton(
                  child: new Text(
                    S.current.common_view,
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAccount(context, account, groups, false,
                        changeGroupCallback, saveAccountCallback);
                  },
                ),
              ),
              Container(
                height: 30,
                width: 60,
                child: new RaisedButton(
                  child: new Text(
                    S.current.common_edit,
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAccount(context, account, groups, true,
                        changeGroupCallback, saveAccountCallback);
                  },
                ),
              ),
            ],
          );
        });
  }
}

class _AccountHomePageState extends State<AccountHomePage> {
  static DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN');

  UserDataStore _userDataStore;
  int _groupId = 0;
  Group _group;

  bool isReorderEdit = false;

  List<Account> reorderAccounts;

  _AccountHomePageState();

  @override
  void dispose() {
    if (isReorderEdit) {
      StoreManager.reCacheUserData();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    StoreManager.getUserData().then((UserDataStore value) {
      setState(() {
        _userDataStore = value;
        _group = _userDataStore.getGroup(_groupId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _initArguments(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_group == null ? "" : _group.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(isReorderEdit ? Icons.save : Icons.reorder),
            tooltip: S.current.account_tooltip_reorder,
            onPressed: _reorder,
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: S.current.account_tooltip_add_account,
            onPressed: _addAccount,
          ),
        ],
      ),
      body: new Center(
          child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Container(
              child: getDataView(),
            ),
          ),
        ],
      )),
    );
  }

  void _initArguments(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    if (obj != null) {
      if (obj["groupId"] != null && obj["groupId"] is int) {
        _groupId = obj["groupId"];
      }
    }
  }

  List<Widget> getAccountWidget(List<Account> items) {
    List<Widget> listWidget = new List();

    for (Account account in items) {
      String subtitle = account.address.isEmpty
          ? _dateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(account.updateTime))
          : account.address;

      listWidget.add(ListTile(
        key: ValueKey(account.id),
        title: new Text('${account.name}'),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.0)),
        trailing: new Icon(Icons.reorder),
      ));
    }
    return listWidget;
  }

  Widget getDataView() {
    if (isReorderEdit) {
      List<Widget> listWidget = getAccountWidget(reorderAccounts);
      return ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          var element = reorderAccounts[oldIndex];
          if (newIndex >= reorderAccounts.length)
            newIndex = reorderAccounts.length - 1;
          setState(() {
            reorderAccounts.removeAt(oldIndex);
            reorderAccounts.insert(newIndex, element);
            for (int i = 0; i < reorderAccounts.length; i++) {
              Account a = reorderAccounts[i];
              a.order = i + 1;
            }
          });
        },
        children: listWidget,
      );
    } else {
      return new ListView.builder(
        itemCount: getAccounts().length,
        itemBuilder: (context, index) {
          Account account = getAccounts()[index];
          String subtitle = account.address.isEmpty
              ? _dateFormat.format(
                  DateTime.fromMillisecondsSinceEpoch(account.updateTime))
              : account.address;

          return new ListTile(
            title: new Text('${account.name}'),
            subtitle: Text(subtitle, style: TextStyle(fontSize: 12.0)),
            trailing: new Text(_dateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(account.updateTime))),
            onTap: () {
              _onClickAccountItem(account);
            },
            onLongPress: () {
              _onLongPressAccountItem(account);
            },
          );
        },
      );
    }
  }

  List<Account> getAccounts() {
    List<Account> list;
    if (_userDataStore != null) {
      list = _userDataStore.getAccountsByGroup(_groupId);
    }
    if (list == null) {
      list = new List();
    } else {
      list.sort((left, right) {
        return left.order - right.order;
      });
    }
    return list;
  }

  void _reorder() {
    if (isReorderEdit) {
      //保存编辑的排序
      StoreManager.saveUserData(_userDataStore);
    } else {
      reorderAccounts = List.from(getAccounts());
    }
    setState(() {
      isReorderEdit = !isReorderEdit;
    });
  }

  void _addAccount() {
    if (_userDataStore == null) {
      _userDataStore = UserDataStore("");
    }
    AccountHomePage.showAccount(context, new Account(_groupId),
        _userDataStore.getGroups(), true, changeGroup, _saveAccount);
  }

  void _onClickAccountItem(Account account) {
    AccountHomePage.showAccount(
        context, account, _userDataStore.getGroups(), false, null, null);
  }

  void _onLongPressAccountItem(Account account) {
    AccountHomePage.showEditOrNotDialog(context, account,
        _userDataStore.getGroups(), changeGroup, _saveAccount, _deleteAccount);
  }

  void _saveAccount(Account account) async {
    AppLog.i(tag, "_saveAccount $account");
    _userDataStore.updateAccount(account);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }

  void _deleteAccount(Account account) async {
    _userDataStore.removeAccount(account);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }

  void changeGroup(Account account, int toGroupId) async {
    _userDataStore.changeGroup(account, toGroupId);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }
}

// ignore: must_be_immutable
class AccountEditDialog extends StatefulWidget {
  Account account;
  List<Group> groups;
  bool isEditEnable;
  AccountCallback onSaveAccount;

  Color backgroundColor;

  double elevation;

  Duration insetAnimationDuration;

  Curve insetAnimationCurve;

  ShapeBorder shape;

  AccountEditDialog({
    Key key,
    this.account,
    this.groups,
    this.isEditEnable,
    this.onSaveAccount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _AccountEditDialogState(
        account, groups, isEditEnable, onSaveAccount);
  }
}

class _AccountEditDialogState extends State<AccountEditDialog> {
  Account account;
  List<Group> groups;
  bool isEditEnable;
  AccountCallback onSaveAccount;
  Group selectGroupvalue;
  Account accountEditCache;

  Color backgroundColor;

  double elevation;

  Duration insetAnimationDuration = const Duration(milliseconds: 100);

  Curve insetAnimationCurve = Curves.decelerate;

  ShapeBorder shape;

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  _AccountEditDialogState(
      this.account, this.groups, this.isEditEnable, this.onSaveAccount) {
    accountEditCache = new Account(account.groupId);
    accountEditCache.resetValues(account);
    if (selectGroupvalue == null) {
      for (Group g in groups) {
        if (g.groupId == account.groupId) {
          selectGroupvalue = g;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
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
            constraints:
                const BoxConstraints(minWidth: 280.0, maxHeight: 530.0),
            child: Material(
              color: backgroundColor ??
                  dialogTheme.backgroundColor ??
                  Theme.of(context).dialogBackgroundColor,
              elevation:
                  elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: new ListView(children: <Widget>[getContent()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget getContent() {
    List<Widget> getActionSelect() {
      if (isEditEnable) {
        return <Widget>[
          new RaisedButton(
              child: new Text(
                S.current.common_cancel,
                style: AppStyle.getAppStyle().dialog.buttonText,
              ),
              onPressed: () {
                //关闭对话框
                Navigator.pop(context);
              }),
          new RaisedButton(
              child: new Text(
                S.current.common_confirm,
                style: AppStyle.getAppStyle().dialog.buttonText,
              ),
              onPressed: () {
                onSaveAccount(accountEditCache);
                Navigator.pop(context); //关闭对话框
              }),
        ];
      } else {
        return <Widget>[
          new RaisedButton(
              child: new Text(
                S.current.common_ok,
                style: AppStyle.getAppStyle().dialog.buttonText,
              ),
              onPressed: () {
                //关闭对话框
                Navigator.pop(context);
              }),
        ];
      }
    }

    return new Container(
      padding: const EdgeInsets.all(5.0),
      constraints: BoxConstraints(
        maxHeight: 530,
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("    ${S.current.group_title}: ",
                    style: AppStyle.getAppStyle().textField(isEditEnable)),
                new Text(selectGroupvalue.name,
                    style: AppStyle.getAppStyle().textField(isEditEnable)),
                new Center(
                    child: new PopupMenuButton(
                  enabled: isEditEnable,
                  icon: new Icon(Icons.arrow_drop_down),
                  onSelected: (Group value) {
                    _updateOnSelectedGroup(value);
                  },
                  itemBuilder: (BuildContext context) => getGroupListData(),
                )),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  tooltip: S.current.account_tooltip_copy_data,
                  onPressed: () {
                    String content = "${S.current.account_edit_label_name}:${accountEditCache.name}\r\n"
                        "${S.current.account_edit_label_address}:${accountEditCache.address}\r\n"
                        "${S.current.account_edit_label_account}:${accountEditCache.account}\r\n"
                        "${S.current.account_edit_label_password}:${accountEditCache.password}\r\n"
                        "${S.current.common_label_remarks}:${accountEditCache.remarks}\r\n";
                    ClipboardData data = new ClipboardData(text: content);
                    Clipboard.setData(data);
                    ArdorToast.show("已复制到剪切板");
                  },
                ),
              ]),
          new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.name,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.account_circle),
                labelText: S.current.account_edit_label_name),
            onChanged: (String str) {
              accountEditCache.name = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.address,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.add_location),
                labelText: S.current.account_edit_label_address),
            onChanged: (String str) {
              accountEditCache.address = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.account,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.person),
                labelText: S.current.account_edit_label_account),
            onChanged: (String str) {
              accountEditCache.account = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.password,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.vpn_key),
                labelText: S.current.account_edit_label_password),
            onChanged: (String str) {
              accountEditCache.password = str;
            },
          ),
//          new TextField(
//            enabled: isEditEnable,
//            controller: TextEditingController.fromValue(TextEditingValue(
//              // 设置内容
//              text: accountEditCache.order.toString(),
//            )),
//            style: AppStyle.getAppStyle().textField(isEditEnable),
//            keyboardType: TextInputType.number,
//            decoration: new InputDecoration(
//                contentPadding: const EdgeInsets.all(5.0),
//                icon: new Icon(Icons.reorder),
//                labelText: "Display Order"),
//            onChanged: (String str) {
//              accountEditCache.order = int.parse(str);
//            },
//          ),
          Expanded(child: new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.remarks,
            )),
            maxLines: null,
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.bookmark),
                labelText: S.current.common_label_remarks),
            onChanged: (String str) {
              accountEditCache.remarks = str;
            },
          )),
          new TextField(
            enabled: false,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: DateTime.fromMillisecondsSinceEpoch(
                      accountEditCache.createTime)
                  .toString(),
            )),
            style: AppStyle.getAppStyle().textField(false),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.timer),
                labelText: S.current.common_label_create_time),
            onChanged: (String str) {},
          ),
          new TextField(
            enabled: false,
            controller: TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: DateTime.fromMillisecondsSinceEpoch(
                      accountEditCache.updateTime)
                  .toString(),
            )),
            style: AppStyle.getAppStyle().textField(false),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.av_timer),
                labelText: S.current.common_label_update_time),
            onChanged: (String str) {},
          ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: getActionSelect()),
        ],
      ),
    );
  }

  void _updateOnSelectedGroup(Group group) {
    accountEditCache.groupId = group.groupId;
    setState(() {
      selectGroupvalue = group;
    });
  }

  List<PopupMenuItem<Group>> getGroupListData() {
    List<PopupMenuItem<Group>> items = new List();
    for (Group g in groups) {
      items.add(new PopupMenuItem(value: g, child: new Text(g.name)));
    }
    return items;
  }
}
