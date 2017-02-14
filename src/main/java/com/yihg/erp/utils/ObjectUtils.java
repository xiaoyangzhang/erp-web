package com.yihg.erp.utils;
/**
 * 工具操作类
 * @author daixiaoman
 * @date 2016年11月30日
 */
public class ObjectUtils {

	public static Integer parseInteger(Object src)
	{
		Integer num = null;
		if(null != src )
		{
			try{
				num = Integer.parseInt(src.toString());
			}catch(Exception e){
				e.printStackTrace();
				num = null;
			}
			
		}
		return num;
	}
	
	public static Integer parseInteger(Object src,int defauleNum){
		Integer num = parseInteger(src);
		return num != null ? num : defauleNum;
	}
	public static  boolean isNull(Object src){
		return src == null || "".equals(src.toString().trim());
	}
	public static String toString(Object src,String ... planStr){
		if(!isNull(src)){
			return src.toString();
		}else{
			if( planStr != null && planStr.length > 0){
				for(String str:planStr){
					if(!isNull(str)){
						return str;
					}
				}
			}
		}
		return "";
	}
}
