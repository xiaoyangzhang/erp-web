package com.yihg.erp.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by ZhengZiyu on 2015/5/21.
 */
@Controller
public class IndexController {

	
    @RequestMapping(value="index.htm")
    public String index(HttpServletRequest request,HttpServletResponse response,ModelMap model){
//    	UserSession userSession = WebUtils.getCurrentUserSession(request);
        Object userSession = request.getSession().getAttribute("userSession");
//    	if(userSession!=null){
//    		model.addAttribute("user",userSession);
//    		return "index";
//    	}else{
//    		return "redirect:login.htm";
//    	}
    	
    	//UserSession userSession = WebUtils.getCurrentUserSession(request);
    	model.addAttribute("userSession", userSession);

    	return "index";
    }
    
    @RequestMapping(value="desk.htm")
    public String desk(HttpServletRequest request,HttpServletResponse response,ModelMap model){
    	
    	return "desk";
    }
}
