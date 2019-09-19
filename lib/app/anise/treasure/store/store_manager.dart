
import 'package:anise_calculator/app/anise/store/safe_file_store.dart';
import 'package:anise_calculator/app/anise/treasure/store/user_data_store.dart';

class StoreManager {

  static Future<UserDataStore> getUserData() async{
    SafeFileStore safeFileStore = SafeFileStore("UserDataStore");
    String content = await safeFileStore.readString();
    if (content != null) {
      return UserDataStore.parseJson(content);
    }
    return new UserDataStore("");
  }

  static Future<bool> saveUserData(UserDataStore userData) async{
    SafeFileStore safeFileStore = SafeFileStore("UserDataStore");
    String content = userData.encodeJson();
    await safeFileStore.write(content);
    return true;
  }

}