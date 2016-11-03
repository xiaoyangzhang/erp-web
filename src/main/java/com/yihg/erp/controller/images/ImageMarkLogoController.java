package com.yihg.erp.controller.images;

import static com.squareup.pollexor.ThumborUrlBuilder.watermark;

import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.csource.upload.UploadFileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.squareup.pollexor.Thumbor;
import com.yihg.architect.logger.Log;
import com.yihg.architect.logger.LogFactory;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.ImgWatermark;
import com.yimayhd.erpcenter.facade.basic.result.ResultSupport;
import com.yimayhd.erpcenter.facade.basic.service.ImgFacade;

@Controller
@RequestMapping(value = "/imageMark")
public class ImageMarkLogoController extends BaseController{
	
	Log logger = LogFactory.getLogger(ImageMarkLogoController.class);

	@Autowired
	private ImgFacade imgFacade;
	@Autowired
	private SysConfig sysConfig;
	
	/***
	 * 水印生成预览
	* @param 
	* @return 
	* @exception
	* @see
	 */
	@RequestMapping(value="/logo",method =RequestMethod.POST)
	@ResponseBody
	public String imageMarkLogo(
			@RequestParam("iconPath") CommonsMultipartFile iconPath,
			@RequestParam("alpha") String alpha,
			@RequestParam("iconImageWidth") String iconImageWidth,
			@RequestParam("iconImageHeight") String iconImageHeight,
			@RequestParam("positionWidth") String positionWidth,
			@RequestParam("positionHeight") String positionHeight){
		
	    int	intpositionWidth = Integer.valueOf(positionWidth);
		int intpositionHeight = Integer.valueOf(positionHeight);
		int intalpha = Integer.valueOf(alpha);
		int inticonImageWidth = Integer.valueOf(iconImageWidth);
		int inticonImageHeight = Integer.valueOf(iconImageHeight);
		
		String fileName = iconPath.getOriginalFilename();
		String fileType = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length());
		InputStream in;
		String icoImagePath = null;
		String uploadFileUrl = null;
		try {
			in = iconPath.getInputStream();
			uploadFileUrl = UploadFileUtil.uploadFile(in, fileType, null);
			//Thumbor thumbor = Thumbor.create(FileConstant.IMAGES_CUT_SERVER);
			Thumbor thumbor = Thumbor.create(sysConfig.getImgCutServerUrl());
			// 水印模板图
			 icoImagePath = thumbor.buildImage("http://192.168.1.88/group1/M00/00/01/wKgBWVV_mtKAAu0eAABtZHrOWqY338.png")
			.resize(400, 300)
		    .filter(
				 //watermark(thumbor.buildImage(FileConstant.IMAGES_SOURCE+uploadFileUrl).resize(inticonImageWidth, inticonImageHeight), intpositionWidth, intpositionHeight,intalpha)
		    		watermark(thumbor.buildImage(sysConfig.getImgServerUrl()+uploadFileUrl).resize(inticonImageWidth, inticonImageHeight), intpositionWidth, intpositionHeight,intalpha)
		     ).toUrl();
			logger.info("生成之后的水印图"+icoImagePath);
		} catch (Exception e) {
			//logger.info("设置默认水印"+iconPath);
			e.printStackTrace();
		}
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("icoImagePath", icoImagePath);
		map.put("uploadFileUrl", uploadFileUrl);
		return successJson(map);
	}
	
	/***
	 * 水印 信息保存
	* @param 
	* @return 
	* @exception
	* @see
	 */
	@RequestMapping(value="/createIcon",method = RequestMethod.POST)
	@ResponseBody
	public String createIconImage(
			HttpServletRequest request,
			@RequestParam("iconImagePath") String iconImagePath,
			@RequestParam("alpha") String alpha,
			@RequestParam("status") String status,
			@RequestParam("iconImageWidth") String iconImageWidth,
			@RequestParam("iconImageHeight") String iconImageHeight,
			@RequestParam("positionWidth") String positionWidth,
			@RequestParam("positionHeight") String positionHeight){
		
		Integer	intpositionWidth = Integer.valueOf(positionWidth);
		Integer intpositionHeight = Integer.valueOf(positionHeight);
		Integer intalpha = Integer.valueOf(alpha);
		Integer inticonImageWidth = Integer.valueOf(iconImageWidth);
		Integer inticonImageHeight = Integer.valueOf(iconImageHeight);
		Integer intstatus = Integer.valueOf(status);
		
		
		ImgWatermark watermark = new ImgWatermark();
		watermark.setUserId(WebUtils.getCurUserId(request));
		watermark.setDealerId(WebUtils.getCurBizId(request));
		watermark.setSysId("0");
		
		//int count = this.imgWatermarkService.deleteWatermarkById(WebUtils.getCurUserId(request),WebUtils.getCurBizId(request),"0");
		watermark.setLastModifiedTime(new Date());
		watermark.setName(String.valueOf(WebUtils.getCurUserId(request))+"-"+String.valueOf(0));
		watermark.setFilePath(iconImagePath);
		watermark.setAlpha(intalpha);
		watermark.setMarginTop(intpositionWidth);
		watermark.setMarginBottom(intpositionHeight);
		watermark.setIconImageWidth(inticonImageWidth);
		watermark.setIconImageHeight(inticonImageHeight);
		watermark.setStatus(intstatus);
		try {
//			int resultCount = imgWatermarkService.saveWatermark(watermark);
			ResultSupport resultSupport = imgFacade.saveWatermark(watermark);
			return resultSupport.isSuccess() ? successJson() : errorJson("服务器未响应");
		} catch (Exception e) {
			logger.error("水印 信息保存失败",e);
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	
	
	
	
}
