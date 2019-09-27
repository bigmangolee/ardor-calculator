

import 'package:json_annotation/json_annotation.dart';

// account.g.dart 将在我们运行生成命令后自动生成
// flutter packages pub run build_runner build
part 'account.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()

class Account {
  int id = -1;
  int groupId = -1;
  String name = "";
  String address = "";
  String account = "";
  String password = "";
  String remarks = "";
  int order = 0;
  int createTime = new DateTime.now().millisecondsSinceEpoch;
  int updateTime = new DateTime.now().millisecondsSinceEpoch;

  Account(this.groupId);

  //不同的类使用不同的mixin即可
  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  void resetValues(Account account){
    id = account.id;
    groupId = account.groupId;
    name = account.name;
    address = account.address;
    this.account = account.account;
    password = account.password;
    remarks = account.remarks;
    createTime = account.createTime;
    updateTime = account.updateTime;
    order = account.order;
  }
}