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

  @override
  String toString() {
    return 'Account{id: $id, groupId: $groupId, name: $name, address: $address, account: $account, password: $password, remarks: $remarks, order: $order, createTime: $createTime, updateTime: $updateTime}';
  }


}