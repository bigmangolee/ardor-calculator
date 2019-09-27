
import 'package:ardor_calculator/app/ardor/store/safe_file_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/bean/config.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/library/crypto.dart';
import 'package:ardor_calculator/library/applog.dart';

const String tag = "StoreManager";
class StoreManager {
  static String _secretKey;

  static set secretKey(String value) {
    if (_secretKey != value) {
      _userDataStore = null;
    }
    _secretKey = value;
  }

  static Config _config;
  static UserDataStore _userDataStore;

  static Future<Config> getConfig() async{
    if (_config != null) {
      return _config;
    }
    SafeFileStore safeFileStore = SafeFileStore("Config");
    String content = await safeFileStore.readString();
    if (content != null) {
      _config = Config.parseJson(content);
    }
    if (_config == null) {
      _config = new Config();
    }
    return _config;
  }

  static Future<bool> saveConfig(Config config) async{
    SafeFileStore safeFileStore = SafeFileStore("Config");
    String content = config.encodeJson();
    await safeFileStore.write(content);
    _config = config;
    return true;
  }

  static Future<UserDataStore> getUserData() async{
    if (_userDataStore != null) {
      return _userDataStore;
    }
    _config = await getConfig();
    SafeFileStore safeFileStore = SafeFileStore("UserDataStore");
    String content = await safeFileStore.readString();
    if (content != null) {
      String key = "$_secretKey${_config.randomSalt}";
      AppLog.i(tag, "getUserData secretKey: $key");
      String text = await ArdorCrypto.decrypt(key, content);
      if (text != null) {
        _userDataStore = UserDataStore.parseJson(text);
      }
    }
    if (_userDataStore == null) {
      _userDataStore = UserDataStore("");
    }
    return _userDataStore;
  }

  static Future<bool> saveUserData(UserDataStore userData) async{
    _config = await getConfig();
    SafeFileStore safeFileStore = SafeFileStore("UserDataStore");
    String content = userData.encodeJson();
    String key = "$_secretKey${_config.randomSalt}";
    AppLog.i(tag, "saveUserData secretKey: $key");
    String text = await ArdorCrypto.encrypt(key, content);
    await safeFileStore.write(text);
    _userDataStore = userData;
    return true;
  }
}