package com.yihg.erp.controller.images;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.csource.upload.UploadFileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.baidu.ueditor.ActionEnter;
import com.yihg.architect.logger.Log;
import com.yihg.architect.logger.LogFactory;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.images.utils.Common;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.dto.PageDto;
import com.yimayhd.erpcenter.dal.basic.po.ImgSpace;
import com.yimayhd.erpcenter.facade.basic.service.ImgFacade;

	/**
	 * @author : xusq
	 * @date : 2015年6月18日 下午4:32:16
	 * @Description: 富文本编辑器服务类
	 */
	@Controller
	public class UeditorContorller extends BaseController {

		private static final Log logger = LogFactory.getLogger(UeditorContorller.class);
		
		@Autowired
		private ImgFacade imgFacade;
		@Autowired
		private SysConfig sysConfig;
		
		@RequestMapping("/ueditor")
		public String ueditor() {
			
			return "/images/ueditor";
	
		}
		
		@RequestMapping("/js/ueditor/jsp/imageUp1")
		@ResponseBody
		public String uploadImg(HttpServletRequest request,
	            HttpServletResponse response,String  action) {
	    	
			if(action.equals("uploadimage")){
	    		
	    		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
	            // 获取file框的
	            Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();

	            
	            // 遍历获取的所有文件
	            List<String> picUrlS = new ArrayList<String>();
	            
	            for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
	            	
	                try {
	                	
	                    MultipartFile mf = entity.getValue();
	                    
	                    // 判断文件名是否为空。为空set null值
	                    String myfileUrl = UploadFileUtil.uploadFile(
	                            mf.getInputStream(),
	                            Common.getFileExt2(mf.getOriginalFilename()), null);
	                    
	                    if(null!=myfileUrl){
	                    	
	                    	//String newUrl = FileConstant.IMAGES_SOURCE + myfileUrl;
	                    	//picUrlS.add(FileConstant.IMAGES_SOURCE + myfileUrl);
	                    	String newUrl = sysConfig.getImgServerUrl() + myfileUrl;
	                    	picUrlS.add(sysConfig.getImgServerUrl() + myfileUrl);
	                    	
	                    	String status="{\"state\": \"SUCCESS\",\"title\": \"\",\"original\":\"" + mf.getOriginalFilename() + "\",\"type\": \""+Common.getFileExt(myfileUrl)+"\",\"url\":\"" + newUrl
	                    			+"\",\"size\": \""+mf.getSize()+"\"}";
	                    	
	                    	logger.info("uedtior上传图片，图片图片服务器返回 ："+myfileUrl +";原始文件名："+mf.getOriginalFilename());
	                    	
	                    	return status;
	                    	
	                    } else{
	                    	
	                    	return "{\"state\": \"Server is Error!\"}";
	                    	
	                    }
	                    
	                } catch (Exception e) {
	                	
	                    try {
	                    	
	                    	return "{\"state\": \"Server is Error!\"}";
	                        
	                    } catch (Exception e1) {
	                    	
	                        logger.error("富文本编辑器上传图片失败！！！"+e.getMessage(),e);
	                        
	                    }
	                    
	                    logger.error("富文本编辑器上传图片失败！！！"+e.getMessage(),e);
	                }
	                
	            }
	            
	    	}else if(action.equals("catchimage")){
	    		
	    		String[] source = request.getParameterValues("linkUp[]");
	    		
	    		StringBuffer status = new StringBuffer();
	    		
	    	    status.append("{\"state\": \"SUCCESS\", list: [");
	    	    
	    	    for (int i = 0; i < source.length; i++) {
	    	    	
	    	    	try {
	    	    		
	    	    		  URL url = new URL(source[i]);  
	    	    		  
				          HttpURLConnection uc = (HttpURLConnection) url.openConnection();  
				          uc.setDoInput(true);//设置是否要从 URL 连接读取数据,默认为true  
				          
				          uc.connect();  
				          
		                  // 判断文件名是否为空。为空set null值
		                  String myfileUrl = UploadFileUtil.uploadFile(uc.getInputStream(),
		                          Common.getFileExt2(source[i]), null);
		                  //String newUrl =FileConstant.IMAGES_SOURCE + myfileUrl;
		                  String newUrl = sysConfig.getImgServerUrl() + myfileUrl;
		                  
		                 if(i==source.length-1){
		                	 
		              	   status.append("{\"state\": \"SUCCESS\",\"title\": \"\",\"source\":\"" +source[i] + "\",\"type\": \""+Common.getFileExt(myfileUrl)+"\",\"url\":\"" + newUrl
		                             +"\",\"size\": \""+uc.getContentLength()+"\"}]}");
		              	   
		                 }else{
		                	 
		              	   status.append("{\"state\": \"SUCCESS\",\"title\": \"\",\"source\":\"" + source[i] + "\",\"type\": \""+Common.getFileExt(myfileUrl)+"\",\"url\":\"" + newUrl
		                             +"\",\"size\": \""+uc.getContentLength()+"\"},");
		              	   
		                 }
		                 
					} catch (Exception e) {
						   logger.error("文件上传失败！"+e.getMessage(),e);
					}
	    	    }
	  
	    	   return status.toString();
			
	    	    
	      }else if(action.equals("listimage")){
	    	  
	    	  String productId =request.getParameter("productId");
	    	  
	    	  Integer start =Integer.parseInt(request.getParameter("start"));
	    	//  Integer size =Integer.parseInt(request.getParameter("size"));
	    		PageDto pageDto=new PageDto();
	    		
	    		//pageDto.setDealerId(1L);
	    		
	    		pageDto.setSysId("0");
	    		
	    		pageDto.setUserId(WebUtils.getCurUserId(request));
	    		
	    		pageDto.setStart(start);
	    		
	    	//	pageDto.setSize(size);
	    		
		  		List<ImgSpace> listImgSpaces=new  ArrayList<ImgSpace>();
				try {
//					listImgSpaces = imgSpaceServie.findImgSpaceByConditions(pageDto);
					listImgSpaces = imgFacade.findImgSpaceByConditions(pageDto);
				} catch (Exception e) {
					 logger.error("查询图片空间列表出错"+e.getMessage(),e);
				}
		  		   
	  		   StringBuilder status = new StringBuilder();
	  		   
	  		   status.append("{\"state\": \"SUCCESS\",\"start\": "+start+", list: [");
	  		   
	  		   for (int i = 0; i < listImgSpaces.size(); i++) {
		  				 
		  				
		                 if(i==listImgSpaces.size()-1){
		                	 
		              	   //status.append("{\"url\":\"" + FileConstant.IMAGES_SOURCE+listImgSpaces.get(i).getFilePath()+"\",\"mtime\": \""+System.currentTimeMillis()+"\"}");
		                	 status.append("{\"url\":\"" + sysConfig.getImgServerUrl()+listImgSpaces.get(i).getFilePath()+"\",\"mtime\": \""+System.currentTimeMillis()+"\"}");
		              	   
		                 }else{
		                	 //status.append("{\"url\":\""  +FileConstant.IMAGES_SOURCE+listImgSpaces.get(i).getFilePath()+"\",\"mtime\": \""+System.currentTimeMillis()+"\"},");
		                	 status.append("{\"url\":\""  +sysConfig.getImgServerUrl()+listImgSpaces.get(i).getFilePath()+"\",\"mtime\": \""+System.currentTimeMillis()+"\"},");
		                 }
			  }
	  		   
	  		  status.append("]}");
	  		  
	         return status.toString();
	  	    
	     }else if(action.equals("config")){
	    	  
	    	try {
	    			
	       	     request.setCharacterEncoding( "utf-8" );
	       	     
	       		 response.setHeader("Content-Type" , "text/html");
	       		 
	       		 
	       		 request.setCharacterEncoding( "utf-8" );
	       		 response.setHeader("Content-Type" , "text/html");
	       		
	       		
	       	 	 String rootPath = request.getSession().getServletContext().getRealPath("/");
	       		
	       		 return  new ActionEnter( request, rootPath ).exec();
	       		
	       	   } catch (IOException e) {
	       		   
	              logger.error("富文本编辑器！！！"+e.getMessage(),e);
               }
	     }	
			
		 return "URL 不正确";
	    
		}

	}
