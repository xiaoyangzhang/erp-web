package com.yihg.erp.controller.images;

import com.google.gson.Gson;
import com.yihg.architect.logger.Log;
import com.yihg.architect.logger.LogFactory;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.images.utils.Common;
import com.yihg.erp.controller.images.utils.ThumborUtil;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.TfsUpload;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.util.FileConstant;
import com.yimayhd.erpcenter.common.util.StaConstant;
import com.yimayhd.erpcenter.dal.basic.dto.TreeDto;
import com.yimayhd.erpcenter.dal.basic.po.ImgSpace;
import com.yimayhd.erpcenter.dal.basic.po.ImgWatermark;
import com.yimayhd.erpcenter.facade.basic.result.ResultSupport;
import com.yimayhd.erpcenter.facade.basic.service.ImgFacade;
import org.apache.commons.lang.StringUtils;
import org.csource.upload.UploadFileUtil;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;


/**
 * 图片管理
 * @author xusq
 *
 */

@Controller
//@RequestMapping(value = "/imManger")
public class ImagesSpaceController extends BaseController{
	
	Log logger = LogFactory.getLogger(ImagesSpaceController.class);

	@Autowired
	private ImgFacade imgFacade;
	@Autowired
	private SysConfig sysConfig;
	@Autowired
	private TfsUpload tfsUpload;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
	@RequestMapping("/images/v_home")
	public String toIndex(HttpServletRequest request,ImgSpace imgSpace,Model model){
		logger.info("跳转至图片管理首页,加载一级目录信息。。。");
		loadTreeInfo(request,imgSpace,model);
		return "/imgspace/index";
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 加载树
	 */
	public void loadTreeInfo(HttpServletRequest request,ImgSpace imgSpace,Model model){
		List<TreeDto> dirDate = new ArrayList<TreeDto>();
		try {

			//imgSpace.setParentId(0);

			imgSpace.setType(FileConstant.DIRECTORY_TYPE);
			imgSpace.setStatus(StaConstant.AVAILABLE_STATUS);
			imgSpace.setParentId(null);
			imgSpace.setSysId("0");
			imgSpace.setDealerId(WebUtils.getCurBizId(request));
			//imgSpace.setUserId(WebUtils.getCurUserId());

			// 加载用户下的所有目录信息
//			dirDate = imgSpaceServie.findImgDirTree(imgSpace);
			dirDate = imgFacade.findImgDirTree(imgSpace);
		} catch (Exception e) {

			logger.error("加载图片管理一级失败," + e.getMessage(), e);
		}
		Gson gson = new Gson();  
		String dirs = gson.toJson(dirDate);

		model.addAttribute("dirs", dirs);
	}
	
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 加载图片列表
	 */
	@RequestMapping(value = "/images/v_model",method =RequestMethod.POST)
	public String loadModel(HttpServletRequest request,@RequestParam("imgId")Integer imgId,String name, PageBean<ImgSpace> pageBean ,Model model){
		ImgSpace imgSpace = new ImgSpace();
//		loadTreeInfo(request,imgSpace,model);
		
		if(!StringUtils.isEmpty(name)){
			imgSpace.setImgName(name);
		}else{
			imgSpace.setParentId(imgId);			
		}
		//imgSpace.setType(FileConstant.IMAGE_TYPE);
		imgSpace.setStatus(StaConstant.AVAILABLE_STATUS);
		imgSpace.setDealerId(WebUtils.getCurBizId(request));
		//显示图片的小图和原图的服务器地址
		//model.addAttribute("images_source", FileConstant.IMAGES_SOURCE);
		//model.addAttribute("images_200", FileConstant.IMAGES_200);
		model.addAttribute("images_source", sysConfig.getImgServerUrl());
		model.addAttribute("images_200", sysConfig.getImages200Url());
		
		//分页和排序设置
		pageBean.setPageSize(18);
		
		if(StringUtils.isEmpty(pageBean.getSortFields())){			
			pageBean.setSortFields("TYPE");
		}else{
			pageBean.setSortFields("TYPE,"+pageBean.getSortFields());
		}
		
		if(StringUtils.isEmpty(pageBean.getOrder())){			
			pageBean.setOrder("TYPE");
		}else{
			pageBean.setOrder("ASC,"+pageBean.getOrder());
		}
		
		//pageBean.setPage(page);
		
		pageBean.setParameter(imgSpace);
		
		try {
//			pageBean = imgSpaceServie.findImgSpaceByConditions(pageBean);
			pageBean = imgFacade.findImgSpaceByConditions(pageBean);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pb", pageBean);
		
		
		return "/imgspace/modelPage/imagesModel";
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 查询回收站内容
	 */
	@RequestMapping(value = "/images/recyclebin")
	public String loadRecyclebin(PageBean<ImgSpace> pageBean ,Model model){
		loadRecyclebinList(pageBean,model,pageBean.getPage());
		return "/imgspace/modelPage/recyclebinIndex";
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 分页查询 回收站内容
	 */
	@RequestMapping(value = "/images/recyclebinList")
	public String loadRecyclebinList(PageBean<ImgSpace> pageBean ,Model model,@RequestParam("pageNum")int pageNum){
		
		ImgSpace imgSpace = new ImgSpace();
		pageBean.setPage(pageNum);
		imgSpace.setStatus(StaConstant.REMOVE_STATUS);
		imgSpace.setType(FileConstant.IMAGE_TYPE);
		// 显示图片的小图和原图的服务器地址
		/*model.addAttribute("images_source", FileConstant.IMAGES_SOURCE);
		model.addAttribute("images_200", FileConstant.IMAGES_200);*/
		
		model.addAttribute("images_source", sysConfig.getImgServerUrl());
		model.addAttribute("images_200", sysConfig.getImages200Url());
		
		// 分页和排序设置
		pageBean.setPageSize(18);

		if (StringUtils.isEmpty(pageBean.getSortFields())) {
			pageBean.setSortFields("TYPE");
		} else {
			pageBean.setSortFields("TYPE," + pageBean.getSortFields());
		}

		if (StringUtils.isEmpty(pageBean.getOrder())) {
			pageBean.setOrder("TYPE");
		} else {
			pageBean.setOrder("ASC," + pageBean.getOrder());
		}
		
		pageBean.setParameter(imgSpace);
		try {
			pageBean = imgFacade.findImgSpaceByConditions(pageBean);
		} catch (Exception e) {
			logger.error("查询回收站出错", e);
			e.printStackTrace();
		}
		model.addAttribute("pb", pageBean);
		return "/imgspace/modelPage/recyclebinList";
	} 
	
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 还原回收站中的内容
	 */
	@RequestMapping(value = "/images/restoreImage",method = RequestMethod.POST)
	@ResponseBody
	public String restoreImage(@RequestParam("imageId") Integer imageId){
//		int resultCount = imgSpaceServie.restoreImageById(imageId);
		ResultSupport resultSupport;
		try {
			resultSupport = imgFacade.restoreImageById(imageId);
			return resultSupport.isSuccess() ? successJson() : errorJson("服务器未响应");
		} catch (Exception e) {
			logger.error("还原回收站出错，error:{}",e);
		}
		return errorJson("操作失败");
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 永久删除回收站内容
	 */
	@RequestMapping(value = "/images/perpetualDelRestore",method = RequestMethod.POST)
	@ResponseBody
	public String perpetualDelRestore(@RequestParam("imageId") Integer imageId){
//		int resultCount = this.imgSpaceServie.perpetualDelRestore(imageId);
//		return resultCount > 0 ? successJson() : errorJson("服务器未响应");
		ResultSupport resultSupport;
		try {
			resultSupport = imgFacade.perpetualDelRestore(imageId);
			return resultSupport.isSuccess() ? successJson() : errorJson("服务器未响应");
		} catch (Exception e) {
			logger.error("清空回收站出错，error:{}",e);
		}
		return errorJson("操作失败");
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 重命名
	 */
	@RequestMapping(value="/images/imageRename",method =RequestMethod.POST)
	@ResponseBody
	public String imageRename(@RequestParam("imageId") Integer imageId,@RequestParam("imgName") String imgName)throws Exception{
//		int resultCount = this.imgSpaceServie.imageRename(imageId,imgName);
//		return resultCount > 0 ? successJson() : errorJson("服务器未响应");
		ResultSupport resultSupport;
		try {
			resultSupport = imgFacade.imageRename(imageId,imgName);
			return resultSupport.isSuccess() ? successJson() : errorJson("服务器未响应");
		} catch (Exception e) {
			logger.error("重命名出错，error:{}",e);
		}
		return errorJson("操作失败");
	}
	
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 返回树级列表
	 */
	@RequestMapping("/images/openTreeWindow")
	public String openTreeWindow(HttpServletRequest request,ImgSpace imgSpace,Model model){
		loadTreeInfo(request,imgSpace,model);
		return "/imgspace/modelPage/moveDialog";
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 文件移动
	 */
	@RequestMapping(value="/images/moveImage",method =RequestMethod.POST)
	@ResponseBody
	public String moveImage(ImgSpace imgSpace,Model model,@RequestParam("imageId") Integer imageId,@RequestParam("parentId") Integer parentId){
//		int resultCount = this.imgSpaceServie.moveImage(imageId,parentId);
//		return resultCount > 0 ? successJson() : errorJson("服务器未响应");
		ResultSupport resultSupport;
		try {
			resultSupport = imgFacade.moveImage(imageId,parentId);
			return resultSupport.isSuccess() ? successJson() : errorJson("服务器未响应");
		} catch (Exception e) {
			logger.error("文件移动出错，error:{}",e);
		}
		return errorJson("操作失败");
	}
	
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 图片替换
	 */
	@RequestMapping(value="/images/replaceImage",method =RequestMethod.POST)
	@ResponseBody
	public String replaceImage(
			HttpServletRequest request,
			@RequestParam("iconPath") CommonsMultipartFile iconPath,
			@RequestParam("imageId") String imageId
			//@RequestParam("isUseLog") String isUseLog){
			){
		String fileName = iconPath.getOriginalFilename();
		String fileType = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length());
		InputStream in = null;
		String uploadFileUrl = null;
		try {
			in = iconPath.getInputStream();
			uploadFileUrl = UploadFileUtil.uploadFile(in, fileType, null);
			 
			/*if(isUseLog.equals("true")){
				 ImgWatermark  watermark = new ImgWatermark();
			     watermark.setSysId("0");
			     watermark.setUserId(WebUtils.getCurUserId(request));
			     watermark.setDealerId(WebUtils.getCurBizId(request));
			     watermark.setStatus(StaConstant.AVAILABLE_STATUS);   
				 watermark = imgWatermarkService.findImgWatermarkByConditions(watermark);
				 //uploadFileUrl=ThumborUtil.uploadFile(uploadFileUrl, watermark);
				 uploadFileUrl=ThumborUtil.uploadFile(sysConfig.getImgServerUrl(),uploadFileUrl, watermark);
			}
			*/
			
			
//			int resultCount = this.imgSpaceServie.replaceImage(uploadFileUrl,fileName,Integer.valueOf(imageId));
			ResultSupport result = imgFacade.replaceImage(uploadFileUrl,fileName,Integer.valueOf(imageId));
			return result.isSuccess() ? successJson() : errorJson("服务器未响应");
		} catch (Exception e) {
			logger.error("图片替换失败",e);
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	
	/**
	* @param 
	* @return 
	 * @throws Exception 
	* @exception
	* @see 新建文件夹
	 */
	@RequestMapping(value = "/images/newFile",method =RequestMethod.POST)
	@ResponseBody
	public String newFile(HttpServletRequest request,@RequestParam("parentId") String parentId,@RequestParam("fileName") String fileName) throws Exception{
		ImgSpace imgSpace = new ImgSpace();
		imgSpace.setCreateTime(new Date());
		imgSpace.setImgName(fileName);
		imgSpace.setUserId(WebUtils.getCurUserId(request));
		imgSpace.setSysId("0");
		imgSpace.setDealerId(WebUtils.getCurBizId(request));
		imgSpace.setType(FileConstant.DIRECTORY_TYPE);
		imgSpace.setStatus(StaConstant.AVAILABLE_STATUS);
		imgSpace.setParentId(Integer.parseInt(parentId));
//		int resultCount =  this.imgSpaceServie.saveImgSpace(imgSpace);
		ResultSupport result =  imgFacade.saveImgSpace(imgSpace);
		 return result.isSuccess() ? successJson() : errorJson("");
	}
	
	/***
	* @param 
	* @return 
	* @exception
	* @see 删除文件以及文件夹
	 */
	@RequestMapping(value="/images/imageDelete",method =RequestMethod.POST)
	@ResponseBody
	public String imageDelete(@RequestParam("parentId") Integer parentId)throws Exception{
//		int resultCount = this.imgSpaceServie.imageDelete(parentId);
		ResultSupport result = imgFacade.imageDelete(parentId);
		return result.isSuccess() ? successJson() : errorJson("服务器未响应");
	}
	
	
	
	/**
	* @param 
	* @return 
	 * @throws Exception 
	* @exception
	* @see 新建文件夹
	 */
	@RequestMapping(value = "/images/toUploadPage")
	public String toUploadPage(@RequestParam("parentId") String parentId,Model model) throws Exception{
		
		if(!StringUtils.isEmpty(parentId)){
			model.addAttribute("parentId", parentId);
			com.yimayhd.erpcenter.dal.basic.po.ImgSpace imgSpace = productCommonFacade.toUploadPage(Integer.parseInt(parentId));
			if(null!=imgSpace){				
				model.addAttribute("location", imgSpace.getImgName());
			}
		}else{
			model.addAttribute("error", "请先选择父级目录");
			logger.error("请先选择父级目录");
		}
		return "/imgspace/include/upload";
	}
	
	 /**
     * Webuploader上传图片.
     * @param request HttpServletRequest
     * @param response
     *            HttpServletResponse
     */
	@RequestMapping("/js/ueditor/jsp/imageUp")
    public void uploadImg(@RequestParam("parentId") Integer parentId,HttpServletRequest request,HttpServletResponse response) {
		
		/*ImgWatermark  watermark = new ImgWatermark();
		watermark.setSysId("0");
		watermark.setUserId(WebUtils.getCurUserId(request));
		watermark.setDealerId(WebUtils.getCurBizId(request));
		watermark.setStatus(StaConstant.AVAILABLE_STATUS);
		try {
			watermark = imgWatermarkService.findImgWatermarkByConditions(watermark);
		} catch (Exception e2) {
			watermark=null;
            logger.error("获取水印失败！！！"+e2.getMessage(),e2);
		}*/
		ImgWatermark  watermark = null;	     
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        // 获取file框的
        Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();

        // 遍历获取的所有文件
        Map<String,String> map_name_url = new LinkedHashMap<String,String>();
        
        for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
            try {
                MultipartFile mf = entity.getValue();
                //String myfileUrl = UploadFileUtil.uploadFile(mf.getInputStream(),Common.getFileExt2(mf.getOriginalFilename()), null);
                String myfileUrl = tfsUpload.upload(mf.getBytes(),mf.getOriginalFilename());
                
                //判断当前用户是否需要加水印
                if(null!=watermark){
                	//myfileUrl=ThumborUtil.uploadFile(myfileUrl, watermark);
                	myfileUrl=ThumborUtil.uploadFile(sysConfig.getImgServerUrl(),myfileUrl, watermark);
                }
                if(null!=myfileUrl){
                	
                	//String newUrl = FileConstant.IMAGES_SOURCE + myfileUrl;
                	String newUrl = sysConfig.getImgServerUrl() + myfileUrl;
                	map_name_url.put(mf.getOriginalFilename(),myfileUrl);
                	String status="{\"state\": \"SUCCESS\",\"title\": \"\",\"original\":\"" + mf.getOriginalFilename() + "\",\"type\": \""+Common.getFileExt(myfileUrl)+"\",\"url\":\"" + newUrl
                			+"\",\"size\": \""+mf.getSize()+"\"}";
                	response.getWriter().print(status);
                	logger.info("uedtior上传图片，图片图片服务器返回 ："+myfileUrl +";原始文件名："+mf.getOriginalFilename());
                } else{
                	response.getWriter().print("{\"state\": \"Server is Error!\"}");
                }
            } catch (Exception e) {
                try {
                    response.getWriter().print("{\"state\": \"Server is Error!\"}");
                } catch (IOException e1) {
                    logger.error("富文本编辑器上传图片失败！！！"+e.getMessage(),e);
                }
                logger.error("富文本编辑器上传图片失败！！！"+e.getMessage(),e);
            }
            
        }
        
        if(map_name_url.size()>0){
        	//遍历上传成功的文件集合 保存到数据库
        	List<ImgSpace> imgSpaces=new ArrayList<ImgSpace>();
        	for(Map.Entry<String, String> entry: map_name_url.entrySet()) {
        		
        		ImgSpace imgSpace=new ImgSpace();
        		imgSpace.setImgName(entry.getKey());
        		imgSpace.setFilePath(entry.getValue());
        		imgSpace.setParentId(parentId);
        		imgSpace.setType(FileConstant.IMAGE_TYPE);
        		imgSpace.setStatus(StaConstant.AVAILABLE_STATUS);
        		imgSpace.setCreateTime(new Date());
        		imgSpace.setUserId(WebUtils.getCurUserId(request));
        		imgSpace.setSysId("0");
        		imgSpace.setDealerId(WebUtils.getCurBizId(request));
        		
        		imgSpaces.add(imgSpace);
        		}
            try {
//				this.imgSpaceServie.saveListImgSpaces(imgSpaces);
				ResultSupport resultSupport = imgFacade.saveListImgSpaces(imgSpaces);
			} catch (Exception e) {
				 logger.error("图片保存到数据库失败！！！"+e.getMessage(),e);
			}
        	
        }
        
        
    	 
    }
	
	
	
	
	
}

