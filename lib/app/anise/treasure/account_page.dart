// Copyright 2019-present the Anise.App authors. All Rights Reserved.
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

import 'package:anise_calculator/app/anise/calculator/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bean/account.dart';
import 'bean/group.dart';
import 'store/store_manager.dart';
import 'store/user_data_store.dart';

// ignore: must_be_immutable
class AccountHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AccountHomePageState();
  }
}

class _AccountHomePageState extends State<AccountHomePage> {
  UserDataStore _userDataStore;
  int _groupId = 0;
  Group _group;

  _AccountHomePageState();

  @override
  void dispose() {
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
            icon: const Icon(Icons.add_alert),
            tooltip: 'Add Account',
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
              child: new ListView.builder(
                itemCount: getAccounts().length,
                itemBuilder: (context, index) {
                  Account account = getAccounts()[index];
                  return new ListTile(
                    title: new Text('${account.name}'),
                    onTap: () {
                      _onClickAccountItem(account);
                    },
                    onLongPress: () {
                      _onLongPressAccountItem(account);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _initArguments(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    if (obj != null && obj["groupId"] != null && obj["groupId"] is int) {
      _groupId = obj["groupId"];
    }
  }

  List<Account> getAccounts() {
    List<Account> list;
    if (_userDataStore != null) {
      list = _userDataStore.getAccountsByGroup(_groupId);
    }
    if (list == null) {
      list = new List();
    }
    return list;
  }

  void _addAccount() {
    if (_userDataStore == null) {
      _userDataStore = UserDataStore("");
    }
    _showAccount(new Account(_groupId), true);
  }

  void _showAccount(Account acc, bool isEditEnable) {

    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AccountEditDialog(
            account : acc,
            groups : _userDataStore.getGroups(),
            isEditEnable : isEditEnable,
            onSaveAccount : (Account account){
              if (acc.groupId != account.groupId) {
                //组id有变化，则县移除，后保存新组
                int gid = acc.groupId;
                acc.resetValues(account);
                acc.groupId = gid;
                changeGroup(acc,account.groupId);
              } else {
                _saveAccount(account);
              }
            },
          );
        });
  }

  void _showEditOrNotDialog(Account account) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '请选择对(${account.name})操作。',
              style: AppStyle.getAppStyle().dialog.titleText,
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    '删除：此操作会将(${account.name})信息删除，请谨慎操作。',
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    '取消：不做任何操作。',
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    '查看：仅查看(${account.name})信息。',
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    '编辑：对(${account.name})信息进行编辑。',
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
                    '删除',
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteAccount(account);
                  },
                ),
              ),
              Container(
                height: 30,
                width: 60,
                child: new RaisedButton(
                  child: new Text(
                    '取消',
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
                    '查看',
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showAccount(account, false);
                  },
                ),
              ),
              Container(
                height: 30,
                width: 60,
                child: new RaisedButton(
                  child: new Text(
                    '编辑',
                    style: AppStyle.getAppStyle().dialog.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showAccount(account, true);
                  },
                ),
              ),
            ],
          );
        });
  }

  void _onClickAccountItem(Account account) {
    _showAccount(account, false);
  }

  void _onLongPressAccountItem(Account account) {
    _showEditOrNotDialog(account);
  }

  void _saveAccount(Account account) async {
    _userDataStore.updateAccount(account);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }

  void _deleteAccount(Account account) async {
    _userDataStore.removeAccount(account);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }

  void changeGroup( Account account, int toGroupId) async{
    _userDataStore.changeGroup(account, toGroupId);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }
}

typedef OnSaveAccount = void Function(Account account);

// ignore: must_be_immutable
class AccountEditDialog extends StatefulWidget {

  Account account;
  List<Group> groups;
  bool isEditEnable;
  OnSaveAccount onSaveAccount;

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
    return new _AccountEditDialogState(account,groups,isEditEnable,onSaveAccount);
  }
}

class _AccountEditDialogState extends State<AccountEditDialog> {

  Account account;
  List<Group> groups;
  bool isEditEnable;
  OnSaveAccount onSaveAccount;
  Group selectGroupvalue ;
  Account accountEditCache;

  Color backgroundColor;

  double elevation;

  Duration insetAnimationDuration = const Duration(milliseconds: 100);

  Curve insetAnimationCurve = Curves.decelerate;

  ShapeBorder shape;

  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  _AccountEditDialogState(this.account, this.groups, this.isEditEnable,
      this.onSaveAccount) {
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
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
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
              color: backgroundColor ?? dialogTheme.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
              elevation: elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: getContent(),
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
                "Cancel",
                style: AppStyle.getAppStyle().dialog.buttonText,
              ),
              onPressed: () {
                //关闭对话框
                Navigator.pop(context);
              }),
          new RaisedButton(
              child: new Text(
                "Confirm",
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
                "Ok",
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
                new Text("Group name:   ",
                    style: AppStyle.getAppStyle().textField(isEditEnable)
                ),
                new Text(selectGroupvalue.name,
                    style: AppStyle.getAppStyle().textField(isEditEnable)
                ),
                new Center(
                    child:new PopupMenuButton(
                      enabled: isEditEnable,
                      icon: new Icon(Icons.arrow_drop_down),
                      onSelected: (Group value){
                        _updateOnSelectedGroup(value);
                      },
                      itemBuilder: (BuildContext context) =>getGroupListData(),
                    )
                ),
              ]
          ),
          new TextField(
            enabled: isEditEnable,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.name,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.nature_people),
                labelText: "Account name"),
            onChanged: (String str) {
              accountEditCache.name = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.address,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.add_call),
                labelText: "Address"),
            onChanged: (String str) {
              accountEditCache.address = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.account,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.accessibility),
                labelText: "Username"),
            onChanged: (String str) {
              accountEditCache.account = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.password,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.signal_cellular_4_bar),
                labelText: "Password"),
            onChanged: (String str) {
              accountEditCache.password = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.order.toString(),
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.reorder),
                labelText: "Display Order"),
            onChanged: (String str) {
              accountEditCache.order = int.parse(str);
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: accountEditCache.remarks,
            )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            maxLines: 3,
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.bookmark),
                labelText: "Account Remarks"),
            onChanged: (String str) {
              accountEditCache.remarks = str;
            },
          ),
          new TextField(
            enabled: false,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: DateTime.fromMillisecondsSinceEpoch(
                  accountEditCache.createTime)
                  .toString(),
            )),
            style: AppStyle.getAppStyle().textField(false),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.timer),
                labelText: "Create time"),
            onChanged: (String str) {},
          ),
          new TextField(
            enabled: false,
            controller:
            TextEditingController.fromValue(TextEditingValue(
              // 设置内容
              text: DateTime.fromMillisecondsSinceEpoch(
                  accountEditCache.updateTime)
                  .toString(),
            )),
            style: AppStyle.getAppStyle().textField(false),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.timer),
                labelText: "Update time"),
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

  List<PopupMenuItem<Group>> getGroupListData(){
    List<PopupMenuItem<Group>> items=new List();
    for (Group g in groups) {
          items.add(new PopupMenuItem(
          value:g,
          child: new Text(g.name)
      ));
    }
    return items;
  }
}
