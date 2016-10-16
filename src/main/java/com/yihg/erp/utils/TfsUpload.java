package com.yihg.erp.utils;

import java.io.File;
import java.io.IOException;

import javax.annotation.Resource;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.ParseException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
/*import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;*/
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import com.alibaba.dubbo.common.json.JSON;
import com.yihg.erp.utils.upload.ResponseVo;

public class TfsUpload {	
	static Logger logger = LoggerFactory.getLogger(TfsUpload.class);
	
	private SysConfig sysConfig;
	public void setSysConfig(SysConfig sysConfig) {
		this.sysConfig = sysConfig;
	}
	
	/**
	 * 上传本地文件
	 * @param filepath 文件路径 d:\\test\\aaa.png
	 * @return tfs文件名
	 * @throws Exception
	 */
	public String uploadLocal(String filepath) throws Exception {
		if(StringUtils.isEmpty(sysConfig.getTfsGwUrl())){
			throw new Exception("请设置文件上传网关地址");
		}
		if(StringUtils.isEmpty(filepath)){
			throw new Exception("本地文件路径不能为空");
		}
		ResponseVo responseVo = null;
		HttpClient httpclient = new DefaultHttpClient();
		HttpPost httppost = new HttpPost(sysConfig.getTfsGwUrl());
		MultipartEntity reqEntity = new MultipartEntity();
		File file = new File(filepath);
		//获取文件名
		String fileName = file.getName();
		FileBody bin = new FileBody(file);
		StringBody comment = new StringBody(fileName);
		reqEntity.addPart(fileName, bin);
		reqEntity.addPart("filename1", comment);
		httppost.setEntity(reqEntity);
		HttpResponse response = httpclient.execute(httppost);
		int statusCode = response.getStatusLine().getStatusCode();
		if (statusCode == HttpStatus.SC_OK) {
			logger.debug("上传成功.....");  
			HttpEntity resEntity = response.getEntity();
			String jsonData = EntityUtils.toString(resEntity);
			responseVo = com.alibaba.fastjson.JSON.parseObject(jsonData, ResponseVo.class);
			EntityUtils.consume(resEntity);
		}		
		try {
			httpclient.getConnectionManager().shutdown();
		} catch (Exception ignore) {
			ignore.printStackTrace(); 
		}
		if(responseVo!=null){
			return responseVo.getData().toString();
		}
		return null;
	}
	
	public String upload(byte[] dataBytes,String fileName) throws Exception{
		if(StringUtils.isEmpty(sysConfig.getTfsGwUrl())){
			throw new Exception("请设置文件上传网关地址");
		}
		if(dataBytes == null || dataBytes.length == 0){
			throw new Exception("文件为空");
		}
		ResponseVo responseVo = null;
		HttpClient httpclient = new DefaultHttpClient();
		HttpPost httppost = new HttpPost(sysConfig.getTfsGwUrl());
		MultipartEntity reqEntity = new MultipartEntity();
		//获取文件名
		ByteArrayBody arrayBody = new ByteArrayBody(dataBytes,fileName);
		StringBody comment = new StringBody(fileName);
		reqEntity.addPart(fileName, arrayBody);
		reqEntity.addPart("filename1", comment);
		httppost.setEntity(reqEntity);
		HttpResponse response = httpclient.execute(httppost);
		int statusCode = response.getStatusLine().getStatusCode();
		if (statusCode == HttpStatus.SC_OK) {
			logger.debug("上传成功.....");  
			HttpEntity resEntity = response.getEntity();
			String jsonData = EntityUtils.toString(resEntity);
			responseVo = com.alibaba.fastjson.JSON.parseObject(jsonData, ResponseVo.class);
			EntityUtils.consume(resEntity);
		}		
		try {
			httpclient.getConnectionManager().shutdown();
		} catch (Exception ignore) {
			ignore.printStackTrace(); 
		}
		if(responseVo!=null){
			return responseVo.getData().toString();
		}
		return null;
	}
}
