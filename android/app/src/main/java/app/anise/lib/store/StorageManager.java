package app.anise.lib.store;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;

import java.io.File;

public class StorageManager {

    /**
     * 目录枚举。
     */
    public enum Directory {

        Download,

        Data,

        // String directoryName;

        // Directory(String directoryName) {
        //     this.directoryName = directoryName;
        // }
        //
        // public String getDirectoryName() {
        //     return directoryName;
        // }
    }

    private static StorageManager sInstance;

    private Context context;

    public static StorageManager getInstance() {
        if (sInstance == null) {
            synchronized (StorageManager.class) {
                if (sInstance == null) {
                    sInstance = new StorageManager();
                }
            }
        }
        return sInstance;
    }

    /**
     * 初始化。
     * @param context context
     */
    public void init(Context context) {
        this.context = context;
    }

    private void checkInit(){
        if (this.context == null) {
            throw new RuntimeException(StorageManager.class.getName() + "  Not Init ~!!");
        }
    }

    /**
     * 获取私有沙盒文件目录。
     */
    public File getPrivateFilesDir() {
        checkInit();
        return context.getFilesDir();
    }

    /**
     * 获取私有沙盒缓存目录。
     */
    public File getPrivateCacheDir() {
        checkInit();
        return context.getCacheDir();
    }

    /**
     * 获取设备外部存储缓存目录。
     */
    @TargetApi(Build.VERSION_CODES.FROYO)
    public File getExternalCacheDir() {
        checkInit();
        return context.getExternalCacheDir();
    }

    /**
     * 获取设备外部存储指定目录。
     */
    @TargetApi(Build.VERSION_CODES.FROYO)
    public File getExternalFilesDir(Directory dirName) {
        if (dirName == null) {
            return null;
        }
        checkInit();
        return context.getExternalFilesDir(dirName.toString());
    }
}
