package com.yihg.erp.controller.component;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.service.ProductCommonFacade;
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
import com.yihg.images.service.ImgSpaceServie;
import com.yimayhd.erpcenter.dal.basic.dto.TreeDto;
import com.yimayhd.erpcenter.dal.basic.po.ImgSpace;

@Controller
@RequestMapping("/component")
public class ImageComponentController extends BaseController  {
	private static final Logger log = LoggerFactory
			.getLogger(ImageComponentController.class);
	
	@Autowired
	private ImgSpaceServie imgSpaceServie;
	@Autowired
	private SysConfig config;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
	@RequestMapping(value="imgSelect.htm")
	public String selectImg(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
		List<TreeDto> result = productCommonFacade.findImgDirTree(WebUtils.getCurBizId(request));
		
		Gson gson = new Gson();  
		String dirs = gson.toJson(result);

		model.addAttribute("dirs", dirs);
		return "component/images/image-select";		
	}
	
	@RequestMapping(value="imgList.do",method =RequestMethod.POST)
	public String imgList(HttpServletRequest request,@RequestParam("imgId")Integer imgId,String name, String sortFileds,String order,Model model){
		List<ImgSpace> result = productCommonFacade.imgList(WebUtils.getCurBizId(request), imgId, name, sortFileds, order);
		model.addAttribute("list", result);
		//显示图片的小图和原图的服务器地址
		model.addAttribute("images_source", config.getImgServerUrl());
		model.addAttribute("images_200", config.getImages200Url());
		return "component/images/image-list";
	}
}
