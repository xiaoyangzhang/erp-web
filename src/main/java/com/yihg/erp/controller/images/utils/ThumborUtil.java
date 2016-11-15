package com.yihg.erp.controller.images.utils;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.commons.lang.StringUtils;
import org.csource.upload.UploadFileUtil;

import com.squareup.pollexor.Thumbor;
import com.squareup.pollexor.ThumborUrlBuilder;
import com.yihg.architect.logger.Log;
import com.yihg.architect.logger.LogFactory;
import com.yimayhd.erpcenter.dal.basic.po.ImgWatermark;

public class ThumborUtil {
	
	 private static final String  SLICE_SERVER = "http://192.168.1.93:8001/";
	static Log logger = LogFactory.getLogger(ThumborUtil.class);
	
	/** 
     * 获取网络上的图片 
     * @param FileUrl url地址 
     * @throws Exception 
     */ 
    public static InputStream getImgStreamByUrl(String FileUrl) throws Exception { 
    	URL url = new URL(FileUrl); //创建URL 
        HttpURLConnection uc = (HttpURLConnection) url.openConnection();  
        uc.setDoInput(true);//设置是否要从 URL 连接读取数据,默认为true  
        uc.connect();  
        InputStream iputstream = uc.getInputStream(); 
         return iputstream;
    } 
	
    
    /** 
     * 给原图片加水印 
     * @param imgPath 原图片地址   waterMark 水印对象
     * @throws Exception 
     */ 
    public static String uploadFile(String imgServerUrl,String imgPath,ImgWatermark waterMark) throws Exception{
        String filePath="";
    	if(StringUtils.isEmpty(imgPath)){
    		throw new Exception("加水印失败! 原图片地址为空");
    	}
    	
    	if(null==waterMark||StringUtils.isEmpty(waterMark.getFilePath())){
    		throw new Exception("加水印失败! 水印信息不完整 无法添加~");
    	}
    	Thumbor thumbor = Thumbor.create(SLICE_SERVER);
		//String str = thumbor.buildImage(FileConstant.IMAGES_SOURCE+imgPath)
    	String str = thumbor.buildImage(imgServerUrl+imgPath)
	    .filter(
    		ThumborUrlBuilder.watermark(thumbor.buildImage(
    				//FileConstant.IMAGES_SOURCE+waterMark.getFilePath()).resize(waterMark.getIconImageWidth(), waterMark.getIconImageHeight()),//固定水印图的大小
    				imgServerUrl+waterMark.getFilePath()).resize(waterMark.getIconImageWidth(), waterMark.getIconImageHeight()),//固定水印图的大小
				null==waterMark.getMarginTop()?0:waterMark.getMarginTop(), //上边距
				null==waterMark.getMarginBottom()?0:waterMark.getMarginBottom(),//左边距
				null==waterMark.getAlpha()?0:waterMark.getAlpha()//透明度
    		    )
           ).toUrl();
		
		InputStream in=null;
	    try {
	    	in=getImgStreamByUrl(str);
		} catch (Exception e) {
			throw new Exception("加水印失败! 获取切图服务器添加水印后图片失败~");
		}
	    try {
	    	filePath=UploadFileUtil.uploadFile(in,  Common.getFileExt2(imgPath), null);
		} catch (Exception e) {
			throw new Exception("加水印失败! 水印完成图片上传失败~");
		}
		return filePath;
    	
    }
   
}
