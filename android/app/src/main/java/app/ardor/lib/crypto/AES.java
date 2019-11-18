

package app.ardor.lib.crypto;

import android.annotation.TargetApi;
import android.os.Build;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import app.ardor.lib.encoding.Base58;


public class AES {

    private static byte[] ivs = "IvPara.Ardor.App".getBytes();

    public static void setIvParameterSpec(String ivKey) {
        ivs = MD5.makeMD5(ivKey).substring(0,16).getBytes();
    }

    @TargetApi(Build.VERSION_CODES.FROYO)
    public static String encrypt(String secretKey, String encData) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] raw = secretKey.getBytes();
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");

        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, new IvParameterSpec(ivs));
        byte[] encrypted = cipher.doFinal(encData.getBytes("utf-8"));
        return Base58.encode(encrypted);
    }

    @TargetApi(Build.VERSION_CODES.FROYO)
    public static String decrypt(String secretKey, String decData) {
        try {
            byte[] raw = secretKey.getBytes("ASCII");
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec iv = new IvParameterSpec(ivs);
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
            byte[] encrypted = Base58.decode(decData);
            byte[] original = cipher.doFinal(encrypted);
            String originalString = new String(original, "utf-8");
            return originalString;
        } catch (Exception ex) {
            return null;
        }
    }
}
