package app.ardor.lib.crypto;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5 {
	
	/**
	 * 生成Md5
	 * @date 2013-4-26
	 * @param srcContent
	 * @return
	 */
	public static String makeMD5(String srcContent) {
		return makeMD5(srcContent.getBytes());
	}
	
	/**
	 * 生成md5校验码
	 * 
	 * @param srcContent 
	 * @return 
	 */
	public static String makeMD5(byte[] srcContent) {
		if (srcContent == null) {
			return null;
		}

		String strDes = null;

		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			md5.update(srcContent);
			strDes = bytes2Hex(md5.digest()); 
		} catch (NoSuchAlgorithmException e) {
			return null;
		}
		return strDes;
	}

	private static String bytes2Hex(byte[] byteArray) {
		
		StringBuffer strBuf = new StringBuffer();
		for (int i = 0; i < byteArray.length; i++) 
		{
			if (byteArray[i] >= 0 && byteArray[i] < 16) {
				strBuf.append("0");
			}
			strBuf.append(Integer.toHexString(byteArray[i] & 0xFF));
		}
		return strBuf.toString();
	}
}
