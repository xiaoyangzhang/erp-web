package com.yihg.erp.controller.sys.security;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.contant.SecurityConstant;
import com.yihg.erp.contant.SysConfigConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.MD5Util;
import com.yihg.erp.utils.WebUtils;
/*import com.yihg.queue.api.IMsgSender;
import com.yihg.queue.constants.MsgQueueNameConstant;
import com.yihg.queue.po.SendResult;*/
import com.yihg.sys.api.*;
import com.yihg.sys.po.*;
import com.yihg.sys.vo.MenuOptVo;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;


@Controller
@RequestMapping("/")
public class LoginController extends BaseController {
	static Logger logger = LoggerFactory.getLogger(LoginController.class);
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private PlatformRoleService platformRoleService;
	@Autowired
	private PlatformOrgService platformOrgService;
	@Autowired
	private PlatformMenuService platformMenuService;
	@Autowired
	private PlatformSessionService platformSessionService;
	@Autowired
	private SysBizInfoService bizInfoService; 
	@Autowired
	private SysBizConfigService sysBizConfigService;
	//@Resource
	//private IMsgSender msgSender;
	
	@RequestMapping(value="login.htm")
	public String login(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		return "login";
	}
	
	@RequestMapping(value="login.do",method=RequestMethod.POST)
	public String login(HttpServletRequest request,HttpServletResponse response,String verify,String loginName,String password,String code,RedirectAttributesModelMap attrModel){
		/*String sessionId = null;
	    Cookie[] cookies = request.getCookies();
	    if(null!=cookies){
	        for(Cookie cookie : cookies){
	            if(SecurityConstant.USER_LOGIN_SESSION_KEY.equals(cookie.getName())){
	            	sessionId = cookie.getValue();
	            }
	        }
	    }
	    if(StringUtils.isNotEmpty(sessionId)){
	    	platformSessionService.
	    }*/
		
		
		
		/*if(StringUtils.isBlank(verify)){
			attrModel.addFlashAttribute("loginName", loginName);
			attrModel.addFlashAttribute("code", code);
			attrModel.addFlashAttribute("errMsg", "验证码不能为空！");
			return "redirect:login.htm";
		}		
		String codeInCookie = getVerifyCode(request);
		//添加一个万能验证码
		if(!verify.equals("m^9A") && (codeInCookie==null || !codeInCookie.equals(MD5Util.MD5(verify)))){
			attrModel.addFlashAttribute("loginName", loginName);
			attrModel.addFlashAttribute("code", code);
			attrModel.addFlashAttribute("errMsg", "验证码有误！");
			return "redirect:login.htm";
		}*/
		if(StringUtils.isBlank(code) || StringUtils.isBlank(loginName) || StringUtils.isBlank(password)){
			attrModel.addFlashAttribute("loginName", loginName);
			attrModel.addFlashAttribute("code", code);
			attrModel.addFlashAttribute("errMsg", "企业编号、用户名或密码不能为空！");
			return "redirect:login.htm";
		}
		
		SysBizInfo curBizInfo = bizInfoService.getBizInfoByCode(code);
		if(curBizInfo == null){
			attrModel.addFlashAttribute("loginName", loginName);
			attrModel.addFlashAttribute("code", code);
			attrModel.addFlashAttribute("errMsg", "当前企业编码不存在！");
			return "redirect:login.htm"; 
		}	
		
		//PlatformEmployeePo platformEmployeePo = platformEmployeeService.getEmployeeByLoginName(loginName);
		PlatformEmployeePo platformEmployeePo = platformEmployeeService.getEmployeeByBizIdAndLoginName(curBizInfo.getId(), loginName);
		if(platformEmployeePo!=null){
			if(MD5Util.authenticatePassword(platformEmployeePo.getPassword(), password)){
				//int sysId = SysServiceSingleton.getPlatformSysPo().getSysId();
				int bizId = curBizInfo.getId(); //WebUtils.getCurBizId(request);
				UserSession userSession = new UserSession();
				userSession.setEmployeeId(platformEmployeePo.getEmployeeId());
				userSession.setLoginName(platformEmployeePo.getLoginName());
				userSession.setName(platformEmployeePo.getName());
				userSession.setIsSuper(platformEmployeePo.getIsSuper());
				userSession.setEmployeeInfo(platformEmployeePo);
				userSession.setBizInfo(curBizInfo);				
				
				//List<PlatformOrgPo> orgList = platformOrgService.getOrgList(bizId, platformEmployeePo.getOrgId(),platformEmployeePo.getIsSuper());
				PlatformOrgPo orgInfo = platformOrgService.getOrgInfo(bizId,platformEmployeePo.getOrgId());
				List<PlatformRolePo> roleList = platformRoleService.getRoleList(bizId, platformEmployeePo.getEmployeeId(),platformEmployeePo.getIsSuper());
				List<PlatformMenuPo> menuList = platformMenuService.getMenuList(bizId, roleList,platformEmployeePo.getIsSuper());
				MenuOptVo menuOptVo = platformMenuService.getOptMaps(bizId, roleList,platformEmployeePo.getIsSuper());
				//操作权限的编码
				//Map<String,Map<String,Boolean>> optMap = menuOptVo.getMenuOptMap();
				//Set<Integer> userIdSet = platformEmployeeService.getUserIdListByOrgId(bizId, platformEmployeePo.getOrgId());
				Set<Integer> userIdSet = platformEmployeeService.getDataRightListByUserId(bizId,platformEmployeePo.getEmployeeId());
				
				userSession.setMenuOptMap(menuOptVo.getMenuOptMap());
				userSession.setOptMap(menuOptVo.getOptMap());
				//userSession.setOrgList(orgList);
				userSession.setOrgInfo(orgInfo);
				userSession.setRoleList(roleList);
				userSession.setMenuList(menuList);
				//model.addAttribute("userSession", userSession);
				userSession.setDataUserIdSet(userIdSet);
				
				//添加配置
				Map<String,String> bizConfigMap = sysBizConfigService.getConfigMapByBizId(bizId);
				userSession.setBizConfigMap(bizConfigMap);				
				
				String uuid = UUID.randomUUID().toString(); 
				String sessionId = uuid.substring(0,8)+uuid.substring(9,13)+uuid.substring(14,18)+uuid.substring(19,23)+uuid.substring(24); 
				
				Cookie cookie = new Cookie(SecurityConstant.USER_LOGIN_SESSION_KEY,sessionId);
			    cookie.setPath("/");
			    //cookie.setMaxAge(24*60*60);
			    response.addCookie(cookie);
			    
//				  String s = UUID.randomUUID().toString(); 
//			        return s.substring(0,8)+s.substring(9,13)+s.substring(14,18)+s.substring(19,23)+s.substring(24); 
				platformSessionService.setUserSession(sessionId, SysConfigConstant.SESSION_TIMEOUT_SECONDS, userSession);
				
				//addLoginLog(request,platformEmployeePo);
				
				attrModel.addFlashAttribute("userSession", userSession);
				return "redirect:index.htm";
			}
			else{
				attrModel.addFlashAttribute("loginName", loginName);
				attrModel.addFlashAttribute("code", code);
				attrModel.addFlashAttribute("errMsg", "用户名密码不匹配！");
				return "redirect:login.htm";
			}
		}
		else{
			attrModel.addFlashAttribute("loginName", loginName);
			attrModel.addFlashAttribute("code", code);
			attrModel.addFlashAttribute("errMsg", "用户名不存在！");
			return "redirect:login.htm";
		}
		
	}
	
	private void addLoginLog(HttpServletRequest request,PlatformEmployeePo employeePo){
		LoginLogPo log = new LoginLogPo();
		log.setBizId(employeePo.getBizId());
		log.setIp(request.getRemoteAddr());
		log.setLoginTime(new Date());
		log.setOrgId(employeePo.getOrgId());
		log.setUserAccount(employeePo.getLoginName());
		log.setUserId(employeePo.getEmployeeId());
		log.setUserName(employeePo.getName());
		//SendResult result = msgSender.sendMessage(MsgQueueNameConstant.LOGIN_LOG_QUEUE_NAME, JSON.toJSONString(log));
		//logger.debug(result.toString());
	}
	
	@RequestMapping(value="logout.htm")
	public String logout(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String po){
		String sessionId = WebUtils.getSessionId(request);				
		platformSessionService.delUserSession(sessionId);
		return "redirect:login.htm";
	}
	
	@ResponseBody
	@RequestMapping(value="noAuth.htm")
	public String noAuth(HttpServletRequest request,HttpServletResponse response) throws Exception{
		return "权限不够，请联系管理员！";
	}

	private String getVerifyCode(HttpServletRequest request){
		Cookie[] cookies = request.getCookies();
	    if(null!=cookies && cookies.length>0){
	        for(Cookie cookie : cookies){
	            if(SecurityConstant.USER_LOGIN_VERIFY_CODE_KEY.equals(cookie.getName())){
	            	return cookie.getValue();
	            }
	        }
	    }
	    return null;
	}
}
