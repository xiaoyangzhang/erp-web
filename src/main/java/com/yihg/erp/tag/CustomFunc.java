package com.yihg.erp.tag;

public class CustomFunc {
	public static String thumbnail(String imgName,String size){
		int index = imgName.lastIndexOf('.');
		if(index>-1){
			return imgName.substring(0, index)+"_"+size+imgName.substring(index);
		}
		return imgName;
	}
}
