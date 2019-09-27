

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
}