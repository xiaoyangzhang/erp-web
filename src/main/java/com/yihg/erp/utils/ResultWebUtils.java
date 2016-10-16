package com.yihg.erp.utils;

import com.google.gson.JsonObject;

public class ResultWebUtils {

	public static String successJson(String...kvs){
		JsonObject json = new JsonObject();
		json.addProperty("sucess", true);//？
		json.addProperty("success", true);
		if(kvs==null || kvs.length==0){
			return json.toString();
		}
		for(int i=0,len=kvs.length;(i+1)<len;i+=2){
			json.addProperty(kvs[i], kvs[i+1]);
		}			
		return json.toString();
	}
	
	public static String errorJson(String msg){
		JsonObject json = new JsonObject();
		json.addProperty("sucess", false);//?
		json.addProperty("success", false);
		json.addProperty("msg", msg);
		return json.toString();
	}
}
