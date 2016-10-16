package com.yihg.erp.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yihg.erp.contant.SecurityConstant;
import com.yihg.erp.utils.WebUtils;
import com.yihg.sys.api.PlatformSessionService;
import com.yihg.sys.po.UserSession;

/**
 * Created by ZhengZiyu on 2015/5/21.
 */
@Controller
public class IndexController {

	@Autowired
	private PlatformSessionService platformSessionService;
	
    @RequestMapping(value="index.htm")
    public String index(HttpServletRequest request,HttpServletResponse response,ModelMap model){
    	/*UserSession userSession = WebUtils.getCurrentUserSession(request);
    	if(userSession!=null){
    		model.addAttribute("user",userSession);  
    		return "index";
    	}else{
    		return "redirect:login.htm";
    	}*/
    	
    	//UserSession userSession = WebUtils.getCurrentUserSession(request);
    	//model.addAttribute("userSession", userSession);
    	return "index";
    }
    
    @RequestMapping(value="desk.htm")
    public String desk(HttpServletRequest request,HttpServletResponse response,ModelMap model){
    	
    	return "desk";
    }
}
