package com.yihg.erp.controller.basic;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.LogOperator;
import com.yimayhd.erpcenter.facade.basic.result.SingleListResult;
import com.yimayhd.erpcenter.facade.basic.service.LogFacade;

@Controller
@RequestMapping("/basic")
public class LogController extends BaseController{
	@Autowired
	private LogFacade logFacade;

	
	@RequestMapping(value="/singleList.htm")
	public String dicEdit(HttpServletRequest request,HttpServletResponse response,ModelMap model,LogOperator log){
		
		SingleListResult result = logFacade.singleList(log, WebUtils.getCurBizId(request));
		model.addAttribute("list", result.getList());
		model.addAttribute("log", result.getLog());
		return "/basic/log/singleList";
	}
	

}
