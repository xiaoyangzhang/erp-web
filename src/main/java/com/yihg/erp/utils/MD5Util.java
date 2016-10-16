package com.yihg.erp.utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Map;

/**
 * MD5工具类
 */
public class MD5Util {

	public final static String MD5(String s) {
        char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};       
        try {
            byte[] btInput = s.getBytes();
            // 获得MD5摘要算法的 MessageDigest 对象
            MessageDigest mdInst = MessageDigest.getInstance("MD5");
            // 使用指定的字节更新摘要
            mdInst.update(btInput);
            // 获得密文
            byte[] md = mdInst.digest();
            // 把密文转换成十六进制的字符串形式
            int j = md.length;
            char str[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	public static boolean authenticatePassword(String password , String inputstr) {
		if(password.equals(MD5Util.MD5(inputstr))){
			return true;
		}
		else{
			return false;
		}
		
	}
	
	/**
     * MD5加密
     *
     * @param str 需要处理的字符串
     * @return
     */
    public static String MD5_Taobao(String str) {
        try {
            MessageDigest m = MessageDigest.getInstance("MD5");
            m.reset();
            m.update(str.getBytes("UTF-8"));
            BigInteger bigInt = new BigInteger(1, m.digest());
            String hashtext = bigInt.toString(16);

            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;

        } catch (Exception e) {
            throw new RuntimeException("MD5 init failed.", e);
        }
    }

    /*
     * 获取签名
     *
     * @param code 供应商编码
     *
     * @param secretKey 签名密钥
     *
     * @param params 业务参数
     *
     * @return
     */
    public static String getSign_Aiyou(String code, String secretKey, Map<String, String> params) {

        String[] keys = params.keySet().toArray(new String[0]);
        Arrays.sort(keys);

        StringBuilder query = new StringBuilder();
        for (String key : keys) {
            String value = params.get(key);
            query.append(key).append(value);
        }
        return MD5(secretKey + query.toString());
    }
	
    public static String getSign_Taobao(String secretKey, Map<String, String> params) {

        String[] keys = params.keySet().toArray(new String[0]);
        Arrays.sort(keys);

        StringBuilder query = new StringBuilder();
        for (String key : keys) {
            String value = params.get(key);
            query.append(key).append(value);
        }
        return MD5_Taobao(query.toString()+secretKey);
    }
    
//    public static void main(String[] args) {
//        System.out.println(MD5Util.MD5("123456"));
//        
//        System.out.println(MD5Util.authenticatePassword("E10ADC3949BA59ABBE56E057F20F883E", "123456"));
//    }
}