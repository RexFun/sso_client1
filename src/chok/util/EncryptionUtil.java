package chok.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EncryptionUtil 
{
	public static String getMD5(String OrigString) 
	{
		try 
		{
			MessageDigest alg;
			alg = MessageDigest.getInstance("MD5");
			alg.update(OrigString.getBytes());
			return byte2hex(alg.digest());
		} 
		catch (NoSuchAlgorithmException e)
		{
			System.out.println(e.getMessage());
			return null;
		}
	}

	public static String byte2hex(byte byteString[]) 
	{
		String result = "";
		String tmpChar = "";
		for (int n = 0; n < byteString.length; n++) 
		{
			tmpChar = Integer.toHexString(byteString[n] & 255);
			if (tmpChar.length() == 1)
				result = result + "0" + tmpChar;
			else
				result = result + tmpChar;
		}
		return result.toUpperCase();
	}
	
	public static void main(String[] args) {      
        //测试
        System.out.println(EncryptionUtil.getMD5("root"));  
    }   
}
