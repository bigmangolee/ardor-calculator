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

import 'dart:async';
import 'dart:io';

import 'package:ardor_calculator/library/callback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

/// 文件选择插件
/// 点击一个文件夹，传入文件夹的路径，显示该文件夹下的文件和文件夹
/// 点击一个文件，回调选中路径
/// 返回上一层，返回上一层目录路径 [dir.parent.path]
// ignore: must_be_immutable
class FileSelector extends StatefulWidget {
  static Future<String> pickFile(BuildContext context) async {
    bool permission = await checkPermission();
    if (!permission) {
      return null;
    }
    String sdcardDir = (await getExternalStorageDirectory()).path;
    String selectPath = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => FileSelector(sdcardDir, (String path) {
          Navigator.pop(context, path);
        }),
      ),
    );
    return selectPath;
  }

  // Permission check
  static Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      bool permissionRead = await SimplePermissions.checkPermission(
          Permission.ReadExternalStorage);
      bool permissionWrite = await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage);
      if (!permissionRead) {
        permissionRead = PermissionStatus.authorized ==
            await SimplePermissions.requestPermission(
                Permission.ReadExternalStorage);
      }
      if (!permissionWrite) {
        permissionWrite = PermissionStatus.authorized ==
            await SimplePermissions.requestPermission(
                Permission.WriteExternalStorage);
      }
      return permissionRead && permissionWrite;
    } else if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  StringCallback selectFileCallback;
  String selectDir;
  FileSelector(this.selectDir, this.selectFileCallback);

  @override
  _FileSelectorState createState() =>
      _FileSelectorState(selectDir, selectFileCallback);
}

class _FileSelectorState extends State<FileSelector> {
  String rootDir;
  StringCallback selectFileCallback;
  List<FileSystemEntity> files = [];
  Directory parentDir;
  ScrollController controller = ScrollController();
  int count = 0; // 记录当前文件夹中以 . 开头的文件和文件夹
  List<double> position = [];

  _FileSelectorState(this.rootDir, this.selectFileCallback);

  @override
  void initState() {
    super.initState();
    parentDir = Directory(rootDir);
    initPathFiles(rootDir);
  }

  Future<bool> onWillPop() async {
    if (parentDir.path != rootDir) {
      initPathFiles(parentDir.parent.path);
      jumpToPosition(false);
    } else {
      SystemNavigator.pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              parentDir?.path == rootDir
                  ? 'SD Card'
                  : path.basename(parentDir.path),
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Color(0xffeeeeee),
          elevation: 0.0,
          leading: parentDir?.path == rootDir
              ? IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: (){
                Navigator.pop(context);
              })
              : IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: onWillPop),
        ),
        body: files.length == 0 || files.length == count
            ? Center(child: Text('The folder is empty'))
            : Scrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  itemCount: files.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (path.basename(files[index].path).substring(0, 1) == '.')
                      return Container();

                    if (FileSystemEntity.isFileSync(files[index].path))
                      return _buildFileItem(FileDescribe(files[index]));
                    else
                      return _buildFolderItem(FolderDescribe(files[index]));
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildFileItem(FileDescribe fileDescribe) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
        ),
        child: ListTile(
          leading: fileDescribe.getIcon(),
          title: Text(fileDescribe.getName()),
          subtitle: Text(
              '${fileDescribe.getModifiedTime()}  ${fileDescribe.getFileSize()}',
              style: TextStyle(fontSize: 12.0)),
        ),
      ),
      onTap: () {
        selectFileCallback(fileDescribe.file.path);
      },
    );
  }

  Widget _buildFolderItem(FolderDescribe folderDescribe) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
        ),
        child: ListTile(
          leading: folderDescribe.getIcon(),
          title: Row(
            children: <Widget>[
              Expanded(child: Text(folderDescribe.getName())),
              Text(
                '${folderDescribe.getFileCount()}项',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          subtitle: Text(folderDescribe.getModifiedTime(),
              style: TextStyle(fontSize: 12.0)),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () {
        // 点进一个文件夹，记录进去之前的offset
        // 返回上一层跳回这个offset，再清除该offset
        position.add(controller.offset);
        initPathFiles(folderDescribe.file.path);
        jumpToPosition(true);
      },
    );
  }

  void jumpToPosition(bool isEnter) async {
    if (isEnter)
      controller.jumpTo(0.0);
    else {
      try {
        await Future.delayed(Duration(milliseconds: 1));
        controller?.jumpTo(position[position.length - 1]);
      } catch (e) {}
      position.removeLast();
    }
  }

  // 初始化该路径下的文件、文件夹
  void initPathFiles(String path) {
    try {
      setState(() {
        parentDir = Directory(path);
        count = 0;
        sortFiles();
        count = FolderDescribe.calculatePointBegin(files);
      });
    } catch (e) {
      print(e);
      print("Directory does not exist！");
    }
  }

  // 排序
  void sortFiles() {
    List<FileSystemEntity> _files = [];
    List<FileSystemEntity> _folder = [];

    for (var v in parentDir.listSync()) {
      if (FileSystemEntity.isFileSync(v.path))
        _files.add(v);
      else
        _folder.add(v);
    }

    _files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
    _folder
        .sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
    files.clear();
    files.addAll(_folder);
    files.addAll(_files);
  }
}

///文件夹描述
class FolderDescribe {
  FileSystemEntity file;

  FolderDescribe(this.file);

  String getModifiedTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(file.statSync().modified.toLocal());
  }

  Widget getIcon() {
    return Image.asset('assets/images/file/folder.png');
  }

  String getName() {
    return file.path.substring(file.parent.path.length + 1);
  }

  int getFileCount() {
    return _calculateFilesCountByFolder(file);
  }

  // 计算以 . 开头的文件、文件夹总数
  static int calculatePointBegin(List<FileSystemEntity> fileList) {
    int count = 0;
    for (var v in fileList) {
      if (path.basename(v.path).substring(0, 1) == '.') count++;
    }
    return count;
  }

  // 计算文件夹内 文件、文件夹的数量，以 . 开头的除外
  int _calculateFilesCountByFolder(Directory path) {
    var dir = path.listSync();
    int count = dir.length - calculatePointBegin(dir);

    return count;
  }
}

///文件描述
class FileDescribe {
  FileSystemEntity file;

  FileDescribe(this.file);

  String getModifiedTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(file.statSync().modified.toLocal());
  }

  Widget getIcon() {
    return Image.asset(_selectIcon(path.extension(file.path)));
  }

  String getName() {
    return file.path.substring(file.parent.path.length + 1);
  }

  String getFileSize() {
    return _getFileSize(file.statSync().size);
  }

  static String _getFileSize(int fileSize) {
    String str = '';

    if (fileSize < 1024) {
      str = '${fileSize.toStringAsFixed(2)}B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      str = '${(fileSize / 1024).toStringAsFixed(2)}KB';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      str = '${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    } else if (1073741824 <= fileSize) {
      str = '${(fileSize / 1024 / 1024 / 1024).toStringAsFixed(2)}GB';
    }
    return str;
  }

  static String _selectIcon(String ext) {
    String iconImg = 'assets/images/file/unknown.png';

    switch (ext) {
      case '.ppt':
      case '.pptx':
        iconImg = 'assets/images/file/ppt.png';
        break;
      case '.doc':
      case '.docx':
        iconImg = 'assets/images/file/word.png';
        break;
      case '.xls':
      case '.xlsx':
        iconImg = 'assets/images/file/excel.png';
        break;
      case '.jpg':
      case '.jpeg':
      case '.png':
        iconImg = 'assets/images/file/image.png';
        break;
      case '.txt':
        iconImg = 'assets/images/file/txt.png';
        break;
      case '.mp3':
        iconImg = 'assets/images/file/mp3.png';
        break;
      case '.mp4':
        iconImg = 'assets/images/file/video.png';
        break;
      case '.rar':
      case '.zip':
        iconImg = 'assets/images/file/zip.png';
        break;
      case '.psd':
        iconImg = 'assets/images/file/psd.png';
        break;
      default:
        iconImg = 'assets/images/file/file.png';
        break;
    }
    return iconImg;
  }
}
