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
import 'package:anise_calculator/app/anise/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bean/group.dart';
import 'store/store_manager.dart';
import 'store/user_data_store.dart';

class GroupHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _GroupHomePageState();
  }
}

class _GroupHomePageState extends State<GroupHomePage> {
  UserDataStore _userDataStore;
  final _searchTextController = TextEditingController();

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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Group List"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit_location),
            tooltip: 'Reset Passwrod',
            onPressed: _resetPass,
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Export',
            onPressed: _export,
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
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
              controller: _searchTextController,
              decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.all(5.0),
                  icon: new Icon(Icons.search),
                  labelText: "What you need to search for."),
              onChanged: (String str) {
                //onChanged是每次输入框内每次文字变更触发的回调
                Fluttertoast.showToast(msg: "input $str");
              },
              onSubmitted: (String str) {
                //onSubmitted是用户提交而触发的回调{当用户点击提交按钮（输入法回车键）}
                Fluttertoast.showToast(msg: "最终 input $str");
              },
            ),
          ),
          new Expanded(
            flex: 1,
            child: new Container(
              child: new ListView.builder(
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
              ),
            ),
          ),
        ],
      )),
    );
  }

  List<Group> getGroups() {
    if (_userDataStore != null) {
      return _userDataStore.getGroups();
    }
    return new List();
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

  void _resetPass() {}

  void _export() {}

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
    // TODO: implement createState
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

}