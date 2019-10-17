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

// group.g.dart 将在我们运行生成命令后自动生成
// flutter packages pub run build_runner build
part 'group.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()

class Group {
  int groupId = -1;
  bool isPrivate = false;
  String name = "";
  String remarks = "";
  int createTime = new DateTime.now().millisecondsSinceEpoch;
  int updateTime = new DateTime.now().millisecondsSinceEpoch;
  int order = 0;

  Group(this.name);

  //不同的类使用不同的mixin即可
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);


  void resetValues(Group group){
    name = group.name;
    remarks = group.remarks;
    createTime = group.createTime;
    updateTime = group.updateTime;
    order = group.order;
    groupId = group.groupId;
    isPrivate = group.isPrivate;
  }

  @override
  String toString() {
    return 'Group{groupId: $groupId, isPrivate: $isPrivate, name: $name, remarks: $remarks, createTime: $createTime, updateTime: $updateTime, order: $order}';
  }


}