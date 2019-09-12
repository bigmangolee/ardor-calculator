
package app.anise.lib.crypto;

import android.text.TextUtils;

public class TCrypto {

    public static final String encrypt(String key,String content) throws Exception{
        if(TextUtils.isEmpty(key)){
            throw new Exception("key is null");
        }
        return AES.encrypt(MD5.makeMD5(key), content);
    }

    public static final String decrypt(String key,String content) throws Exception{
        if(TextUtils.isEmpty(key)){
            throw new Exception("key is null");
        }
        return AES.decrypt(MD5.makeMD5(key), content);
    }
}

