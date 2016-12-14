package com.yihg.erp.controller.sys;

import org.springframework.ui.ModelMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;





/**
 * Created by Xuzejun on 2015/5/25.
 */
//@Controller
public class IndexController {

	//@Autowired
	//PlatformSysService platformSysService;
	
    //@RequestMapping(value="index")
    public String index(){
        return "index";
    }
    
    
    //@RequestMapping(value="sys/sys")
    public String sys(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
    	/*List<PlatformSysPo> list = platformSysService.getPlatformSysList();
        for(PlatformSysPo sys: list){
        	System.out.println("client " +sys.getName()+"\t"+sys.getCode()+"\t"+sys.getIsParent()+"\t"+sys.getIsPublic());
        }
        model.addAttribute("list", list);*/
        return "sys/sys";
    }
}
