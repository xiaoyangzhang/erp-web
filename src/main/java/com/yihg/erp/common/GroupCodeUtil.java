package com.yihg.erp.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class GroupCodeUtil {
	public static String getCode(String code, String mark) {
		if(mark==null){
			mark = "";
		}
		mark=mark.trim();
		String[] split = code.split("-");
		String head = split[0];
		String foot = split[split.length - 1];
		String ss = "";
		for (int i = 1; i < split.length - 1; i++) {
			ss += split[i] + "-";
		}
		ss = ss.substring(0, ss.length() - 1);
		if (ss.indexOf("(") != -1) {
			ss = ss.substring(0, ss.indexOf("("));
		}
		if ("".equals(mark)) {
			return head + "-" + ss + "-" + foot;
		} else {
			mark = "(" + mark.toUpperCase() + ")";
			return head + "-" + ss + mark + "-" + foot;
		}

	}
	/**
	 * 组团社
	 * @param code
	 * @param mark
	 * example :test-ttt-160101/01(哈哈哈)-100
	 * @return
	 */
	public static String getCodeForAgency(String code, String mark, String productCode) {
		if(mark==null){
			mark="";
		}
		mark=mark.trim();
		String[] split = code.split("-");
		String head = split[0] + "-" + productCode;
		String foot = split[split.length - 1];
		String ss = "";
		for (int i = 2; i < split.length - 1; i++) {
			ss += split[i] + "-";
		}
		ss = ss.substring(0, ss.length() - 1);
		if (ss.indexOf("(") != -1) {
			ss = ss.substring(0, ss.indexOf("("));
		}
		if ("".equals(mark)) {
			return head + "-" + ss + "-" + foot;
		} else {
			mark = "(" + mark.toUpperCase() + ")";
			return head + "-" + ss + mark + "-" + foot;
		}

	}
	
	/**
	 * 组团版编辑时重新生成团号
	 * @param args
	 * @throws ParseException
	 */
	public static String getCodeForAgency(String bizCode,String code,String mark,String productCode,String startTime, String endTime){
		String[] split = code.split("-");
	
		SimpleDateFormat sdf1 = new SimpleDateFormat("yy-MM-dd");
		try {
			startTime = sdf1.format(sdf1.parse(startTime));
			endTime = sdf1.format(sdf1.parse(endTime));
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		mark = (mark == null || "".equals(mark)) ? "" : "("
				+ mark.toUpperCase() + ")";
		
		String newCode = "";
		if(productCode == null || "".equals(productCode)){
			newCode = bizCode + "-" + startTime.replace("-", "")+"/"+endTime.split("-")[2]+ mark + "-" + split[split.length-1];
		}else{
			newCode = bizCode + "-" +productCode+"-"+ startTime.replace("-", "")+"/"+endTime.split("-")[2]+ mark + "-" + split[split.length-1];
		}
		return newCode;
	}
	
	
	
	public static void main(String[] args) throws ParseException {
		
		System.out.println(GroupCodeUtil.getCodeForAgency("test-ttt-160101/01(哈哈哈)-100", "", "ccc"));
	}
}
