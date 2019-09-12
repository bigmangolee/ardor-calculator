
package app.anise.lib.store;

import android.text.TextUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import app.anise.lib.crypto.AES;

import static app.anise.lib.crypto.MD5.makeMD5;


public class SafeFileStore {
    private static byte[] keys = makeMD5("app.anise.lib.store.SafeFileStore").getBytes();
    private File file;
    private FileInputStream fileInputStream;
    private FileOutputStream fileOutputStream;

    public static void setKey(String key) {
        SafeFileStore.keys = makeMD5(key).getBytes();
    }

    public SafeFileStore(String fileName) {
        init(fileName,false);
    }

    public SafeFileStore(String fileName,boolean isForceCreate) {
        init(fileName,isForceCreate);
    }

    private void init(String fileName,boolean isForceCreate){
        fileName = makeMD5(fileName)+".d";
        String path = getStorePath();
        try {
            file = new File(path, fileName);
            if(isForceCreate && file.exists()) {
                file.delete();
            }

            if(!file.exists()) {
                file.createNewFile();
            }

            fileInputStream = new FileInputStream(file);
            fileOutputStream = new FileOutputStream(file, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取存储路径
     * @return
     */
    public static String getStorePath() {
        File file = StorageManager.getInstance().getExternalFilesDir(StorageManager.Directory.Data);
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public void wrireBytes(String content) throws Exception {
        if(TextUtils.isEmpty(content) || fileOutputStream== null) {
            return;
        }
        wrireBytes(content.getBytes());
    }

    public void wrireBytes(byte[] content) throws Exception {
        if(content==null || fileOutputStream== null ) {
            return;
        }
        byte[] result = AES.encrypt(keys,content);
        fileOutputStream.write(result);
    }

    public byte[] readBytes(){
        if(fileInputStream == null){
            return null;
        }
        int size = (int)file.length();
        byte[] data = new byte[size];
        if(size == 0){
            return null;
        }
        try {
            fileInputStream.read(data, 0, size);
            data = AES.decrypt(keys,data);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public String readString(){
        byte[] bs = readBytes();
        if(bs == null){
            return null;
        }
        return new String(bs);
    }

    public void close() throws Exception {
        fileInputStream.close();
        fileOutputStream.close();
        fileInputStream = null;
        fileOutputStream = null;
    }
}
