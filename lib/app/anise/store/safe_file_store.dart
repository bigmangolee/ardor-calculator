import 'dart:io';
import 'dart:async';
import 'package:anise_calculator/library/anise_crypto.dart';
import 'package:path_provider/path_provider.dart';

class SafeFileStore {

  static String _key = "SafeFileStore";

  String _fileName;

  SafeFileStore(this._fileName);

  static void setStoreKey(String key) {
    _key = key;
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileName = _getFilePath();
    return new File('$dir/$fileName');
  }

  String _getFilePath() {
    return _fileName;
  }

  Future<Null> write(String content) async{
    String text = await AniseCrypto.encrypt(_key, content);
    await (await _getLocalFile()).writeAsString(text);
  }

  Future<String> readString() async{
    try {
      File file = await _getLocalFile();
      String content = await file.readAsString();
      String text = await AniseCrypto.decrypt(_key, content);
      return text;
    } on FileSystemException {
      return null;
    }
  }

}