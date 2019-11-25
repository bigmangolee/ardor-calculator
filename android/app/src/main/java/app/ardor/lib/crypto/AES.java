

package app.ardor.lib.crypto;

import android.annotation.TargetApi;
import android.os.Build;
import android.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


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
        String text = Base64.encodeToString(encrypted,Base64.NO_WRAP | Base64.URL_SAFE | Base64.NO_PADDING);
        return text;
    }

    @TargetApi(Build.VERSION_CODES.FROYO)
    public static String decrypt(String secretKey, String decData) {
        try {
            byte[] raw = secretKey.getBytes("ASCII");
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec iv = new IvParameterSpec(ivs);
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
            byte[] encrypted = Base64.decode(decData,Base64.NO_WRAP | Base64.URL_SAFE | Base64.NO_PADDING);
            byte[] original = cipher.doFinal(encrypted);
            String originalString = new String(original, "utf-8");
            return originalString;
        } catch (Exception ex) {
            return null;
        }
    }
}
