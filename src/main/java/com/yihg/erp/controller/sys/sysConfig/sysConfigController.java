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
import com.yihg.sys.api.PlatformSysService;
import com.yihg.sys.po.PlatformSysPo;


@Controller
@RequestMapping(value = "/sysConfig")
public class sysConfigController {
	
	@Autowired
	PlatformSysService platformSysService;
	
	
	@RequestMapping(value="/sysConfigList")
    public String sysConfigList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
		System.out.println(SysServiceSingleton.getInstance().getPlatformSysPo().getSysId());
    	List<PlatformSysPo> list = platformSysService.getPlatformSysList();
        model.addAttribute("list", list);
        return PathPrefixConstant.SYSTEM_CONFIG_PREFIX+"sysConfigList";
    }

}
