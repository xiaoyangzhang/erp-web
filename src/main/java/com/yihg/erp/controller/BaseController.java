package com.yihg.erp.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import com.yihg.erp.contant.PathPrefixConstant;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import com.alibaba.fastjson.JSONObject;

public class BaseController {
	@InitBinder  
	public void initBinder(WebDataBinder binder) {  
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");  
	    dateFormat.setLenient(false);  
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true)); 
	}
	
	protected String resultJson(String...kvs){
		JSONObject json = new JSONObject();
		if(kvs==null || kvs.length==0){
			return json.toString();
		}
		for(int i=0,len=kvs.length;(i+1)<len;i+=2){
			json.put(kvs[i], kvs[i+1]);
		}			
		return json.toString();
	}
	
	protected String successJson(){
		JSONObject json = new JSONObject();
		json.put("success", true);
		return json.toString();
	}
	
	protected String successJson(String...kvs){
		JSONObject json = new JSONObject();
		json.put("success", true);
		if(kvs==null || kvs.length==0){
			return json.toString();
		}
		for(int i=0,len=kvs.length;(i+1)<len;i+=2){
			json.put(kvs[i], kvs[i+1]);
		}			
		return json.toString();
	}
	
	protected static String successJson(Map<String,Object> map){
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("sucess", true);
		for(Map.Entry<String, Object> entry : map.entrySet()){
			jsonObject.put(entry.getKey(),entry.getValue());
		}
		return jsonObject.toString();
	}
	
	protected String result(String msg){
		JSONObject json = new JSONObject();
		json.put("success", false);
		json.put("msg", msg);
		return json.toString();
	}

	protected String errorJson(Object msg){
		JSONObject json = new JSONObject();
		json.put("success", false);
		json.put("msg", msg);
		return json.toString();
	}
	protected String getSystemOrgPrefixPath(String path)
	{
		return PathPrefixConstant.SYSTEM_ORG_PREFIX+path;
	}
}
