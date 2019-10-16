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
import 'package:ardor_calculator/app/ardor/calculator/treasure/account_page.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/account.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/group.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/password_keyboard.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/treasure_export.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class GroupHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _GroupHomePageState();
  }
}

class _GroupHomePageState extends State<GroupHomePage> {
  UserDataStore _userDataStore;
  final _searchTextController = TextEditingController();

  String searchKey;
  List<Account> searchAccountList;

  bool isReorderEdit = false;

  List<Group> reorderGroups;
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _initArguments(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Groups"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.vpn_key),
            tooltip: 'Reset Passwrod',
            onPressed: _resetPass,
          ),
          IconButton(
            icon: Icon(isReorderEdit? Icons.save : Icons.reorder),
            tooltip: 'Reorder',
            onPressed: _reorder,
          ),
          IconButton(
            icon: const Icon(Icons.import_export),
            tooltip: 'Export',
            onPressed: _export,
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: 'Add Group',
            onPressed: _addGroup,
          ),
        ],
      ),
      body: new Center(
          child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new TextField(
              enabled: !isReorderEdit,
              controller: _searchTextController,
              decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.all(5.0),
                  icon: new Icon(Icons.search),
                  labelText: "What you need to search for."),
              onChanged: (String str) async {
                //onChanged是每次输入框内每次文字变更触发的回调
                Fluttertoast.showToast(msg: "input $str");
                List<Account> list = await _searchAccounts(str);
                setState(() {
                  searchKey = str;
                  searchAccountList = list;
                });
              },
              onSubmitted: (String str) {
                //onSubmitted是用户提交而触发的回调{当用户点击提交按钮（输入法回车键）}
//                Fluttertoast.showToast(msg: "最终 input $str");
              },
            ),
          ),
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
  }

  List<Widget> getGroupWidget(List<Group> items) {
    List<Widget> listWidget = new List();
    for (Group group in items) {
      listWidget.add(ListTile(
        key: ValueKey(group.groupId),
        title: new TextField(
          enabled: false,
          controller: TextEditingController.fromValue(
              TextEditingValue(
                // 设置内容
                text: group.name,
              )),
          decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(5.0),
              suffixIcon: new Icon(Icons.reorder)),
        ),
      ));
    }
    return listWidget;
  }

  Widget getDataView() {
    if (isReorderEdit) {
      List<Widget> listWidget = getGroupWidget(reorderGroups);
      return ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          var element = reorderGroups[oldIndex];
          if (newIndex >= reorderGroups.length) newIndex = reorderGroups.length - 1;
          setState(() {
            reorderGroups.removeAt(oldIndex);
            reorderGroups.insert(newIndex, element);
            for (int i = 0;i<reorderGroups.length;i++) {
                Group g = reorderGroups[i];
                g.order = i;
            }
          });
        },
        children: listWidget,
      );
    } else {
      if (searchKey == null || searchKey.isEmpty) {
        return new ListView.builder(
          itemCount: getGroups().length,
          itemBuilder: (context, index) {
            Group group = getGroups()[index];
            return new ListTile(
              title: new Text('${group.name}'),
              onTap: () {
                _onClickGroupItem(group);
              },
              onLongPress: () {
                _onLongPressGroupItem(group);
              },
            );
          },
        );
      } else {
        return new ListView.builder(
          itemCount: searchAccountList.length,
          itemBuilder: (context, index) {
            Account account = searchAccountList[index];
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
        );
      }
    }
  }

  List<Group> getGroups() {
    if (_userDataStore != null) {
      List<Group> list = _userDataStore.getGroups();
      list.sort((left,right){return left.order - right.order;});
      return list;
    }
    return new List();
  }

  Future<List<Account>> _searchAccounts(String key) async{
    if (_userDataStore == null) {
      return new List();
    }
    List<Account> resultList = new List();
    List<Group> listGroups =_userDataStore.getGroups();
    for (Group g in listGroups) {
      List<Account> listAccounts = _userDataStore.getAccountsByGroup(g.groupId);
      if (listAccounts == null) {
        continue;
      }
      for (Account a in listAccounts) {
        if (_searchMatchKey(a,key)) {
          resultList.add(a);
        }
      }
    }
    return resultList;
  }

  bool _searchMatchKey(Account a ,String key){
    if(a.name != null && a.name.contains(key)){
      return true;
    }else if(a.address != null && a.address.contains(key)){
      return true;
    }else if(a.remarks != null && a.remarks.contains(key)){
      return true;
    }
    return false;
  }

  void _addGroup() {
    if (_userDataStore == null) {
      _userDataStore = UserDataStore("");
    }
    _showGroup(new Group(""), true);
  }

  void _showGroup(Group g, bool isEditEnable) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GroupEditDialog(
            group : g,
            isEditEnable : isEditEnable,
            onSaveGroup : (Group group){
              _saveGroup(group);
            },
          );
        });
  }

  void _showEditOrNotDialog(Group group) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '请选择对(${group.name})操作。',
              style: AppStyle.getAppStyle().dialog.titleText,
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    '删除：此操作会将(${group.name})组及(${group.name})组名下的信息都删除，请谨慎操作。',
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    '取消：不做任何操作。',
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    '查看：仅查看(${group.name})组信息。',
                    style: AppStyle.getAppStyle().dialog.contentText,
                  ),
                  new Text(""),
                  new Text(
                    '编辑：对(${group.name})组信息进行编辑。',
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
                    _deleteGroup(group.groupId);
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
                    _showGroup(group, false);
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
                    _showGroup(group, true);
                  },
                ),
              ),
            ],
          );
        });
  }

  void _resetPass() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PasswordKeybordDialog(
              passwordType: PasswordType.resetPass,
              passwordOk: (String p) async {
                Navigator.of(context).pop();
                UserDataStore userDataStore = await StoreManager.getUserData();
                StoreManager.secretKey = p;
                StoreManager.saveUserData(userDataStore);
                ArdorToast.show("完成密码重置。");
              });
        });
  }

  void _reorder() {
    if (isReorderEdit) {
      //保存编辑的排序
      StoreManager.saveUserData(_userDataStore);
    } else {
      reorderGroups = getGroups();
    }
    setState(() {
      isReorderEdit = !isReorderEdit;
    });
  }

  void _export() {
    TreasureExport.toExport(context);
  }

  void _onClickGroupItem(Group group) {
    Navigator.pushNamed(context, '/account',
        arguments: {"groupId": group.groupId});
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => AccountHomePage(groupId:group.groupId),
//      ),
//    );
  }

  void _onLongPressGroupItem(Group group) {
    _showEditOrNotDialog(group);
  }

  void _saveGroup(Group group) async {
    _userDataStore.updateGroup(group);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }

  void _deleteGroup(int groupId) async {
    _userDataStore.removeGroup(groupId);
    setState(() {});
    await StoreManager.saveUserData(_userDataStore);
  }

  void _onClickAccountItem(Account account) {
    AccountHomePage.showAccount(context,account,_userDataStore.getGroups(), false,null,null);
  }

  void _onLongPressAccountItem(Account account) {
    AccountHomePage.showEditOrNotDialog(context,account,_userDataStore.getGroups(),changeGroup,_saveAccount,_deleteAccount);
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

typedef OnSaveGroup = void Function(Group group);
// ignore: must_be_immutable
class GroupEditDialog extends StatefulWidget {

  Group group;
  bool isEditEnable;
  OnSaveGroup onSaveGroup;

  GroupEditDialog({
    Key key,
    this.group,
    this.isEditEnable,
    this.onSaveGroup,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _GroupEditDialogState(group,isEditEnable,onSaveGroup);
  }
}

class _GroupEditDialogState extends State<GroupEditDialog> {

  Group group;
  bool isEditEnable;
  OnSaveGroup onSaveGroup;

  Color backgroundColor;

  double elevation;

  Duration insetAnimationDuration = const Duration(milliseconds: 100);

  Curve insetAnimationCurve = Curves.decelerate;

  ShapeBorder shape;

  _GroupEditDialogState(this.group, this.isEditEnable,
      this.onSaveGroup);

  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

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

  Widget getContent () {
    Group groupEditCache = new Group("");
    groupEditCache.resetValues(group);

    List<Widget> getActionSelect(){
      if (isEditEnable) {
        return <Widget>[
          Container(
            height: 30,
            width: 90,
            child: new RaisedButton(
                child: new Text(
                  "Cancel",
                  style: AppStyle.getAppStyle().dialog.buttonText,
                ),
                onPressed: () {
                  //关闭对话框
                  Navigator.pop(context);
                }),
          ),
          Container(
            height: 30,
            width: 90,
            child: new RaisedButton(
                child: new Text(
                  "Confirm",
                  style: AppStyle.getAppStyle().dialog.buttonText,
                ),
                onPressed: () {
                  group.resetValues(groupEditCache);
                  onSaveGroup(group);
                  Navigator.pop(context); //关闭对话框
                }),
          ),
        ];
      } else {
        return <Widget>[
          Container(
            height: 30,
            width: 90,
            child: new RaisedButton(
                child: new Text(
                  "OK",
                  style: AppStyle.getAppStyle().dialog.buttonText,
                ),
                onPressed: () {
                  //关闭对话框
                  Navigator.pop(context);
                }),
          ),
        ];
      }
    }

    return new Container(
      padding: const EdgeInsets.all(5.0),
      constraints:BoxConstraints(
        maxHeight: 330,
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(
                TextEditingValue(
                  // 设置内容
                  text: groupEditCache.name,
                )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.group),
                labelText: "Group name"),
            onChanged: (String str) {
              groupEditCache.name = str;
            },
          ),
          new TextField(
            enabled: isEditEnable,
            controller: TextEditingController.fromValue(
                TextEditingValue(
                  // 设置内容
                  text: groupEditCache.order.toString(),
                )),
            style: AppStyle.getAppStyle().textField(isEditEnable),
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.reorder),
                labelText: "Display Order"),
            onChanged: (String str) {
              groupEditCache.order = int.parse(str);
            },
          ),
          new TextField(
            enabled: isEditEnable,
            style: AppStyle.getAppStyle().textField(isEditEnable),
            maxLines: 3,
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.bookmark),
                labelText: "Group Remarks"),
            onChanged: (String str) {
              groupEditCache.remarks = str;
            },
          ),
          new TextField(
            enabled: false,
            controller: TextEditingController.fromValue(
                TextEditingValue(
                  // 设置内容
                  text: DateTime.fromMillisecondsSinceEpoch(group.createTime).toString(),
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
            controller: TextEditingController.fromValue(
                TextEditingValue(
                  // 设置内容
                  text: DateTime.fromMillisecondsSinceEpoch(group.updateTime).toString(),
                )),
            style: AppStyle.getAppStyle().textField(false),
            decoration: new InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                icon: new Icon(Icons.av_timer),
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

}