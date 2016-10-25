package com.yihg.erp.controller.sys.sysConfig;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yihg.erp.contant.PathPrefixConstant;
import com.yihg.erp.utils.SysServiceSingleton;
import com.yimayhd.erpcenter.dal.sys.po.PlatformSysPo;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformSysFacade;


@Controller
@RequestMapping(value = "/sysConfig")
public class sysConfigController {
	
	@Autowired
	private SysPlatformSysFacade sysPlatformSysFacade;
	
	
	@RequestMapping(value="/sysConfigList")
    public String sysConfigList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
		System.out.println(SysServiceSingleton.getInstance().getPlatformSysPo().getSysId());
    	List<PlatformSysPo> list = sysPlatformSysFacade.getPlatformSysList().getPlatformSysPos();
        model.addAttribute("list", list);
        return PathPrefixConstant.SYSTEM_CONFIG_PREFIX+"sysConfigList";
    }

}
