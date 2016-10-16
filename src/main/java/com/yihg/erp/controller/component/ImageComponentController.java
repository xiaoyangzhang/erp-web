package com.yihg.erp.controller.component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.Gson;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.images.dto.TreeDto;
import com.yihg.images.po.ImgSpace;
import com.yihg.images.service.ImgSpaceServie;
import com.yihg.images.util.FileConstant;
import com.yihg.images.util.StaConstant;
import com.yihg.mybatis.utility.PageBean;

@Controller
@RequestMapping("/component")
public class ImageComponentController extends BaseController  {
	private static final Logger log = LoggerFactory
			.getLogger(ImageComponentController.class);
	
	@Autowired
	private ImgSpaceServie imgSpaceServie;
	@Autowired
	private SysConfig config;
	
	@RequestMapping(value="imgSelect.htm")
	public String selectImg(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
		List<TreeDto> dirDate = new ArrayList<TreeDto>();
		try {

			ImgSpace imgSpace = new ImgSpace();
			//imgSpace.setParentId(0);

			imgSpace.setType(FileConstant.DIRECTORY_TYPE);
			imgSpace.setStatus(StaConstant.AVAILABLE_STATUS);
			imgSpace.setParentId(null);
			imgSpace.setSysId("0");
			imgSpace.setDealerId(WebUtils.getCurBizId(request));
			//imgSpace.setUserId(WebUtils.getCurUserId());

			// 加载用户下的所有目录信息
			dirDate = imgSpaceServie.findImgDirTree(imgSpace);

		} catch (Exception e) {
			log.error("加载图片管理一级失败," + e.getMessage(), e);
		}
		Gson gson = new Gson();  
		String dirs = gson.toJson(dirDate);

		model.addAttribute("dirs", dirs);
		return "component/images/image-select";		
	}
	
	@RequestMapping(value="imgList.do",method =RequestMethod.POST)
	public String imgList(HttpServletRequest request,@RequestParam("imgId")Integer imgId,String name, String sortFileds,String order,Model model){
		//Map<String,Object> map = new HashMap<String,Object>();
		//System.out.print(config.getImages200Url());
		ImgSpace imgSpace = new ImgSpace();		
		if(!StringUtils.isEmpty(name)){
			imgSpace.setImgName(name);
		}else{
			imgSpace.setParentId(imgId);			
		}
		imgSpace.setSysId("0");
		imgSpace.setDealerId(WebUtils.getCurBizId(request));
		imgSpace.setType(FileConstant.IMAGE_TYPE);
		imgSpace.setStatus(StaConstant.AVAILABLE_STATUS);
		//显示图片的小图和原图的服务器地址
		model.addAttribute("images_source", config.getImgServerUrl());
		model.addAttribute("images_200", config.getImages200Url());
		
		/*map.put("parameter", imgSpace);
		
		if(StringUtils.isNotBlank(sortFileds)){			
			map.put("sortFileds", sortFileds);
		}
		
		if(StringUtils.isNotBlank(order)){			
			map.put("order", order);
		}*/
		
		List<ImgSpace> list = new ArrayList<ImgSpace>();
		
		try {
			//pageBean = imgSpaceServie.findImgSpaceByConditions(pageBean);
			list = imgSpaceServie.getImgList(imgSpace,sortFileds,order);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("list", list);
		
		
		return "component/images/image-list";
	}
}
