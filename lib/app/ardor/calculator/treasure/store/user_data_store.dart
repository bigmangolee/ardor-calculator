import 'dart:convert';

import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/account.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/group.dart';
import 'package:json_annotation/json_annotation.dart';

import '../app_global.dart';

part 'user_data_store.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()


class UserDataStore {
  String name;
  int maxGroupId = 0;
  int maxAccountId = 0;
  List<Group> groups = new List<Group>();
  Map<String,List<Account>> accounts = new Map<String,List<Account>>();

  UserDataStore(this.name);

  ///将json字符串解析成对象。
  static UserDataStore parseJson(String jsonString) {
    Map userMap = jsonDecode(jsonString);
    return UserDataStore.fromJson(userMap as Map<String, dynamic>);
  }

  ///将对象编码成json字符串。
  String encodeJson() {
    Map userMap = toJson();
    return jsonEncode(userMap);
  }

  factory UserDataStore.fromJson(Map<String, dynamic> json) => _$UserDataStoreFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataStoreToJson(this);

  int _currentTimeMilliseconds () {
    return new DateTime.now().millisecondsSinceEpoch;
  }


  List<Group> getGroups() {
    List<Group> list = new List();
    for (Group group in groups) {
      if(!group.isPrivate || (group.isPrivate && AppGlobal.isPrivateShow)){
        list.add(group);
      }
    }
    return list;
  }

  void _addNewGroup(Group group){
    group.groupId = ++maxGroupId;
    group.createTime = _currentTimeMilliseconds();
    group.updateTime = group.createTime;
    groups.add(group);
  }

  void updateGroup(Group group){
    Group g = getGroup(group.groupId);
    if(g == null || group.groupId == -1){
      _addNewGroup(group);
    } else {
      g.resetValues(group);
      g.updateTime = _currentTimeMilliseconds();
    }
  }

  Group getGroup(int groupId){
    for (Group group in groups) {
      if(groupId == group.groupId){
        return group;
      }
    }
    return null;
  }

  bool removeGroup(int groupId){
    Group removeGroup;
    for (Group group in groups) {
      if(groupId == group.groupId){
        removeGroup = group;
      }
    }
    if(removeGroup != null){
      groups.remove(removeGroup);
    }
    return true;
  }

  void _addNewAccount(Account account,int groupId){
    List<Account> list = getAccountsByGroup(groupId);
    if(list == null){
      list = new List<Account>();
      accounts.putIfAbsent(groupId.toString(), () => list);
    }
    account.id = ++maxAccountId;
    account.groupId = groupId;
    account.createTime = _currentTimeMilliseconds();
    account.updateTime = account.createTime;
    list.add(account);
  }

  //更新账号列表，若该组不存在账号，则向该groupId新增。
  void updateAccount(Account account){
    Account localAccount = getAccount(account);
    if(localAccount != null){
      localAccount.resetValues(account);
      localAccount.updateTime = _currentTimeMilliseconds();
    }else{
      _addNewAccount(account,account.groupId);
    }
  }

  bool removeAccount(Account account){
    List<Account> list =  getAccountsByGroup(account.groupId);
    Account deleteAccount;
    for(Account a in list){
      if(a.id == account.id){
        deleteAccount = a;
      }
    }
    if(deleteAccount != null){
      list.remove(deleteAccount);
    }
    return true;
  }

  Account getAccount(Account account){
    List<Account> list =  getAccountsByGroup(account.groupId);
    if (list == null) {
      return null;
    }
    for(Account a in list){
      if(a.id == account.id){
        return a;
      }
    }
    return null;
  }


  List<Account> getAccountsByGroup(int groupId) {
    return accounts[groupId.toString()];
  }

  ///变更帐号所在的组
  void changeGroup( Account account, int toGroupId){
    List<Account> oldList = getAccountsByGroup(account.groupId);
    List<Account> newList = getAccountsByGroup(toGroupId);
    if(newList == null){
      newList = new List<Account>();
      accounts.putIfAbsent(toGroupId.toString(), () => newList);
    }
    Account deleteAccount;
    if(oldList != null){
      for(Account a in oldList){
        if(a.id == account.id){
          deleteAccount = a;
        }
      }
      if(deleteAccount != null){
        oldList.remove(deleteAccount);
      }
    }
    deleteAccount = null;
    for(Account a in newList){
      if(a.id == account.id){
        deleteAccount = a;
      }
    }
    if(deleteAccount != null){
      newList.remove(deleteAccount);
    }
    account.groupId = toGroupId;
    newList.add(account);
  }

  @override
  String toString() {
    return 'UserDataStore{name: $name, maxGroupId: $maxGroupId, maxAccountId: $maxAccountId, groups: $groups, accounts: $accounts}';
  }

}