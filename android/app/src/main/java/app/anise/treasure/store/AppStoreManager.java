
package app.anise.treasure.store;


import android.text.TextUtils;

import app.anise.lib.crypto.TCrypto;
import app.anise.lib.store.SafeFileStore;
import app.anise.lib.utils.AppLog;


public class AppStoreManager {

    private static final String TAG = AppStoreManager.class.getSimpleName();

//    private static HashMap<String,String> map = new HashMap<>();

    private static String password;

    private AppStoreManager() {
    }

    /**
     * 获取存储的文件信息,该方法会优先返回缓存对象,若缓存木有则加载本地文件
     * @param tClass
     * @param <T>
     * @return
     */
    public static <T> T getStoreFile(Class<T> tClass){
        return getStoreFile(tClass,password);
    }

    /**
     * 获取存储的文件信息,该方法会优先返回缓存对象,若缓存木有则加载本地文件
     * @param tClass
     * @param <T>
     * @return
     */
    public static <T> T getStoreFile(Class<T> tClass,String password){

        if(tClass == null){
            return null;
        }
        String key = tClass.getName();
        String json = null;
//        synchronized (map){
//            json = map.get(key); //先从内存里拿出配置对应的json
//        }
//        AppLog.i(TAG,"getStoreFile : key:"+key+" map:"+map);
        if(TextUtils.isEmpty(json)){ //内存里面没有就从本地配置文件读取
            json = loadStoreFile(tClass,password); //从本地配置文件读取
            if (TextUtils.isEmpty(json)){ //本地也没有
//                T temp = createNewInstance(tClass); //创建一个空的配置类对象
//                json = object2Json(temp);
                //文件不存在或密码错误
                return null;
            }
//            synchronized (map){
//                map.put(key, json); //保存到内存
//            }
        }
        AppLog.i(TAG,"getStoreFile : "+json);
        return json2Object(tClass, json); //转成配饰实体类返回
    }

    /**
     * 加载存储文件信息
     * @param tClass
     * @param password
     * @param autoCreate    是否自动创建
     * @param <T>
     * @return
     */
//    public static <T> T loadStoreFile(Class<T> tClass,String password,boolean autoCreate){
//        T result = null;
//        try {
//            SafeFileStore safeFileStore = new SafeFileStore(tClass.getName(),false);
//            String content = safeFileStore.readString();
//            if(!TextUtils.isEmpty(password) && !TextUtils.isEmpty(content)){
//                content = TCrypto.decrypt(password,content);
//            }
//            AppLog.i(TAG,"loadStoreFile "+tClass.getName()+"  : "+content);
//            Gson gson =new Gson();
//            result =gson.fromJson(content,tClass);
//            safeFileStore.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        if(result == null && autoCreate){
//            try {
//                result = tClass.newInstance();
//            } catch (InstantiationException e) {
//                e.printStackTrace();
//            } catch (IllegalAccessException e) {
//                e.printStackTrace();
//            }
//            saveFile(result,password);
//        }
//        return result;
//    }

    /**
     * 加载存储文件信息,该方法会把配置文件的内容转成json返回
     * @param tClass
     * @return
     */
    public static String loadStoreFile(Class<?> tClass,String password){
        SafeFileStore safeFileStore = null;
        try {
            safeFileStore = new SafeFileStore(tClass.getName());
            String content = safeFileStore.readString();
            AppLog.i(TAG,"loadStoreFile password:"+password+" content:"+content);
            if(!TextUtils.isEmpty(password) && !TextUtils.isEmpty(content)){
                content = TCrypto.decrypt(password,content);
                AppLog.i(TAG,"loadStoreFile decrypt content:"+content);
            }
            AppLog.i(TAG,"loadStoreFile "+tClass.getName()+"  : "+content);
            return content;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (safeFileStore != null) {
                    safeFileStore.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * json配置信息转成具体的配置实体类
     * @param tClass
     * @param json
     * @param <T>
     * @return
     */
    private static <T> T json2Object(Class<T> tClass, String json){
        T result = null;
        // try {
        //     Gson gson = new Gson();
        //     result = gson.fromJson(json, tClass);
        // } catch (Exception e) {
        //     e.printStackTrace();
        // }
        // if(result == null){
        //     result = createNewInstance(tClass);
        // }
        return result;
    }

    /**
     * 创建空的配置实体
     * @param tClass
     * @param <T>
     * @return
     */
    private static <T> T createNewInstance(Class<T> tClass){
        T t = null;
        try {
            t = tClass.newInstance();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return t;
    }

    /**
     * 配置实体类转成json用于保存
     * @param o
     * @return
     */
    private static String object2Json(Object o) {
        // try{
        //     Gson gson =new Gson();
        //     return gson.toJson(o);
        // }catch (Exception e){
        //     e.printStackTrace();
        // }
        return null;
    }

    /**
     * 保存存储文件到 /data/data目录
     * @param storeFile
     * @param <T>
     * @return
     */
    public static <T> boolean saveFile(T storeFile){
        return saveFile(storeFile,password);
    }
    /**
     * 保存存储文件到 /data/data目录
     * @param storeFile
     * @param <T>
     * @return
     */
    public static <T> boolean saveFile(T storeFile,String password){
        if(storeFile == null){
            return false;
        }
        try {
            SafeFileStore safeFileStore = new SafeFileStore(storeFile.getClass().getName(),true);
            String sb = object2Json(storeFile);
            AppLog.i(TAG,"saveFile "+storeFile.getClass().getName()+" password:"+password+" "+sb);
            if(!TextUtils.isEmpty(password)){
                String cc = TCrypto.encrypt(password,sb);
                AppLog.i(TAG,"saveFile encrypt:"+cc);
                safeFileStore.wrireBytes(cc);
            }else{
                safeFileStore.wrireBytes(sb);
            }
//            synchronized (map){
//                map.put(storeFile.getClass().getName(), sb);
//            }
            safeFileStore.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static <T> boolean importDataFile(String storeFile,String data){
        if(storeFile == null || TextUtils.isEmpty(data)){
            return false;
        }
        try {
            AppLog.i(TAG,"importDataFile:"+storeFile+"   "+data);
            SafeFileStore safeFileStore = new SafeFileStore(storeFile,true);
            safeFileStore.wrireBytes(data);
            safeFileStore.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static String getPassword() {
        return password;
    }

    public static void setPassword(String password) {
        AppStoreManager.password = password;
    }
}
