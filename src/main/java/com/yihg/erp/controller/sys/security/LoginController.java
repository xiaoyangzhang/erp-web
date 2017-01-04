package com.yihg.erp.controller.sys.security;

import java.util.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSON;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import com.yihg.erp.contant.SecurityConstant;
import com.yihg.erp.contant.SysConfigConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.MD5Util;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sys.po.LoginLogPo;
import com.yimayhd.erpcenter.dal.sys.po.MsgInfoDetail;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.dal.sys.po.SysBizInfo;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.sales.service.GuestFacade;
import com.yimayhd.erpcenter.facade.sys.query.UserSessionDTO;
import com.yimayhd.erpcenter.facade.sys.result.PlatformEmployeeResult;
import com.yimayhd.erpcenter.facade.sys.result.SysBizInfoResult;
import com.yimayhd.erpcenter.facade.sys.result.UserSessionResult;
import com.yimayhd.erpcenter.facade.sys.service.SysLoginFacade;


@Controller
@RequestMapping("/")
public class LoginController extends BaseController {
	static Logger logger = LoggerFactory.getLogger(LoginController.class);
//	@Autowired
//	private PlatformEmployeeService platformEmployeeService;
//	@Autowired
//	private PlatformRoleService platformRoleService;
//	@Autowired
//	private PlatformOrgService platformOrgService;
//	@Autowired
//	private PlatformMenuService platformMenuService;
//	@Autowired
//	private PlatformSessionService platformSessionService;
//	@Autowired
//	private SysBizInfoService bizInfoService; 
//	@Autowired
//	private SysBizConfigService sysBizConfigService;
	@Autowired
	private SysLoginFacade sysLoginFacade;
    @Autowired
    private GuestFacade guestFacade;
	//@Resource
	//private IMsgSender msgSender;
	
	@RequestMapping(value="login.htm")
	public String login(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		String sessionId = WebUtils.getSessionId(request);
		if(sessionId == null) {
			return "login";
		}
		UserSessionResult sessionResult = sysLoginFacade.getUserSession(sessionId);
		if(sessionResult != null ){
			return "redirect:index.htm";
		}
		return "login";
	}
	
    @RequestMapping(value = "login.do", method = RequestMethod.POST)
    public String login(HttpServletRequest request, HttpServletResponse response, String verify,
            String loginName, String password, String code, RedirectAttributesModelMap attrModel,
            HttpSession httpSession) {
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
		
		SysBizInfoResult curBizInfoResult = sysLoginFacade.getBizInfoByCode(code);
		if(curBizInfoResult == null){
			attrModel.addFlashAttribute("loginName", loginName);
			attrModel.addFlashAttribute("code", code);
			attrModel.addFlashAttribute("errMsg", "当前企业编码不存在！");
			return "redirect:login.htm"; 
		}	
		SysBizInfo curBizInfo = new SysBizInfo();
		BeanUtils.copyProperties(curBizInfoResult, curBizInfo);
		//PlatformEmployeePo platformEmployeePo = platformEmployeeService.getEmployeeByLoginName(loginName);
		PlatformEmployeeResult platformEmployeeResult = sysLoginFacade.getEmployeeByBizIdAndLoginName(curBizInfo.getId(), loginName);
		if(platformEmployeeResult!=null){
			PlatformEmployeePo platformEmployeePo = new PlatformEmployeePo();
			BeanUtils.copyProperties(platformEmployeeResult, platformEmployeePo);
			if(MD5Util.authenticatePassword(platformEmployeePo.getPassword(), password)){
				//int sysId = SysServiceSingleton.getPlatformSysPo().getSysId();
				int bizId = curBizInfo.getId(); //WebUtils.getCurBizId(request);
				UserSession userSession = new UserSession();
					
				
//				//List<PlatformOrgPo> orgList = platformOrgService.getOrgList(bizId, platformEmployeePo.getOrgId(),platformEmployeePo.getIsSuper());
//				PlatformOrgPo orgInfo = platformOrgService.getOrgInfo(bizId,platformEmployeePo.getOrgId());
//				List<PlatformRolePo> roleList = platformRoleService.getRoleList(bizId, platformEmployeePo.getEmployeeId(),platformEmployeePo.getIsSuper());
//				List<PlatformMenuPo> menuList = platformMenuService.getMenuList(bizId, roleList,platformEmployeePo.getIsSuper());
//				MenuOptVo menuOptVo = platformMenuService.getOptMaps(bizId, roleList,platformEmployeePo.getIsSuper());
//				//操作权限的编码
//				//Map<String,Map<String,Boolean>> optMap = menuOptVo.getMenuOptMap();
//				//Set<Integer> userIdSet = platformEmployeeService.getUserIdListByOrgId(bizId, platformEmployeePo.getOrgId());
//				Set<Integer> userIdSet = platformEmployeeService.getDataRightListByUserId(bizId,platformEmployeePo.getEmployeeId());
//				
//				userSession.setMenuOptMap(menuOptVo.getMenuOptMap());
//				userSession.setOptMap(menuOptVo.getOptMap());
//				//userSession.setOrgList(orgList);
//				userSession.setOrgInfo(orgInfo);
//				userSession.setRoleList(roleList);
//				userSession.setMenuList(menuList);
//				//model.addAttribute("userSession", userSession);
//				userSession.setDataUserIdSet(userIdSet);
//				
//				//添加配置
//				Map<String,String> bizConfigMap = sysBizConfigService.getConfigMapByBizId(bizId);
//				userSession.setBizConfigMap(bizConfigMap);		
				
				UserSessionResult userSessionResult = sysLoginFacade.getUserSessionResult(bizId, platformEmployeePo.getOrgId(), platformEmployeePo.getEmployeeId(), platformEmployeePo.getIsSuper());
				userSessionResult.setEmployeeId(platformEmployeePo.getEmployeeId());
				userSessionResult.setLoginName(platformEmployeePo.getLoginName());
				userSessionResult.setName(platformEmployeePo.getName());
				userSessionResult.setIsSuper(platformEmployeePo.getIsSuper());
				userSessionResult.setEmployeeInfo(platformEmployeePo);
				userSessionResult.setBizInfo(curBizInfo);
				BeanUtils.copyProperties(userSessionResult, userSession);//把userSession相关的信息拷贝到userSession中
//				userSession.setDataUserIdSet(userSessionResult.getDataUserIdSet());
				String uuid = UUID.randomUUID().toString(); 
				String sessionId = uuid.substring(0,8)+uuid.substring(9,13)+uuid.substring(14,18)+uuid.substring(19,23)+uuid.substring(24);
				//记录每个用户登录的sessionId
				userSession.setUserToken(sessionId);
				Cookie cookie = new Cookie(SecurityConstant.USER_LOGIN_SESSION_KEY,sessionId);
			    cookie.setPath("/");
			    //cookie.setMaxAge(24*60*60);
			    response.addCookie(cookie);
			    
//				  String s = UUID.randomUUID().toString(); 
//			        return s.substring(0,8)+s.substring(9,13)+s.substring(14,18)+s.substring(19,23)+s.substring(24); 
			    UserSessionDTO userSessionDTO = new UserSessionDTO();
			    userSessionDTO.setUserSession(userSession);
			    sysLoginFacade.setUserSession(sessionId, SysConfigConstant.SESSION_TIMEOUT_SECONDS, userSessionDTO);
				
				//addLoginLog(request,platformEmployeePo);
				
				attrModel.addFlashAttribute("userSession", userSession);
                // WebSocket session设置
                httpSession.setAttribute("userSession", userSession);

                // 获取消息
                MsgInfoDetail msgInfoDetail = sysLoginFacade.findMsgCountByUserId(bizId,
                        platformEmployeePo.getEmployeeId());
                if (msgInfoDetail != null){
                    attrModel.addFlashAttribute("totalCount", msgInfoDetail.getTotalCount());
                    attrModel.addFlashAttribute("readCount", msgInfoDetail.getReadCount());
                    attrModel.addFlashAttribute("unreadCount", msgInfoDetail.getUnreadCount());
                }else{
                	 attrModel.addFlashAttribute("totalCount", 0);
                     attrModel.addFlashAttribute("readCount", 0);
                     attrModel.addFlashAttribute("unreadCount", 0);
                }

				// 获取当前系统商家名称
				attrModel.addFlashAttribute("bizName",curBizInfoResult.getName());

				return "redirect:index.htm";
            } else {
                attrModel.addFlashAttribute("loginName", loginName);
                attrModel.addFlashAttribute("code", code);
                attrModel.addFlashAttribute("errMsg", "用户名密码不匹配！");
                return "redirect:login.htm";
            }
        } else {
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
		sysLoginFacade.delUserSession(sessionId);
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
	
	 @RequestMapping(value = "visa.htm")
	    public String visa(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
	        return "visa";
	    }
	    
	    @RequestMapping(value = "visa.do", method = RequestMethod.POST)
	    public String visa(HttpServletRequest request, HttpServletResponse response, String verify,
	            String loginName, RedirectAttributesModelMap attrModel, HttpSession httpSession) {       
	         if(StringUtils.isBlank(verify)){
	        	 attrModel.addFlashAttribute("loginName", loginName);
	        	 attrModel.addFlashAttribute("errMsg", "验证码不能为空！"); 
	        	 return  "redirect:visa.htm"; 
	         } 
	         String codeInCookie = getVerifyCode(request);
	          //添加一个万能验证码 
	          if(!verify.equals("m^9A") && (codeInCookie==null || !codeInCookie.equals(MD5Util.MD5(verify)))){
		          attrModel.addFlashAttribute("loginName", loginName);
		          attrModel.addFlashAttribute("errMsg", "验证码有误！"); 
		          return "redirect:visa.htm";
	          }
	         
	        if (StringUtils.isBlank(verify) || StringUtils.isBlank(loginName)) {
	            attrModel.addFlashAttribute("loginName", loginName);
	            attrModel.addFlashAttribute("verify", verify);
	            attrModel.addFlashAttribute("errMsg", "手机号或验证码不能为空！");
	            return "redirect:visa.htm";
	        }

	        //根据手机号获取用户信息
//	        List<GroupOrderGuest> groupOrderGuestList = guestFacade
//	                .getEmployeeByMobile(loginName);
	        List<GroupOrderGuest> groupOrderGuestList=guestFacade.getEmployeeByMobile(loginName).getGroupOrderGuestList();
	        
	        if (groupOrderGuestList.size() >0) {
	        	for(GroupOrderGuest groupOrderGuest : groupOrderGuestList){
	        		
	        	
		        	if(loginName.equals(groupOrderGuest.getMobile())){
		        	UserSession userSession = new UserSession();
		        	userSession.setLoginName(groupOrderGuest.getMobile());
		        	String uuid = UUID.randomUUID().toString();
		            String sessionId = uuid.substring(0, 8) + uuid.substring(9, 13)
		                    + uuid.substring(14, 18) + uuid.substring(19, 23) + uuid.substring(24);
		
		            Cookie cookie = new Cookie(SecurityConstant.USER_LOGIN_SESSION_KEY, sessionId);
		            cookie.setPath("/");
		            response.addCookie(cookie);
		            UserSessionDTO userSessionDTO=new UserSessionDTO();
		            userSessionDTO.setUserSession(userSession);
		            sysLoginFacade.setUserSession(sessionId,
		                    SysConfigConstant.SESSION_TIMEOUT_SECONDS, userSessionDTO);
		
		            attrModel.addFlashAttribute("userSession", userSession);
		
		            httpSession.setAttribute("userSession", userSession);
		            } else {
		                attrModel.addFlashAttribute("loginName", loginName);
		                attrModel.addFlashAttribute("errMsg", "手机号不匹配！");
		                return "redirect:visa.htm";
		            }
	        	}
	        	return "redirect:taobao/visaDetail.do?mobile="+loginName;
	        } else {
	            attrModel.addFlashAttribute("loginName", loginName);
	            attrModel.addFlashAttribute("errMsg", "手机号不存在！");
	            return "redirect:visa.htm";
	        }
	    	
	    }

	/**
	 * 判断sessionId是否过期
	 * @author daixiaoman
	 * @date 2016年12月15日 下午12:02:33
	 */
	@RequestMapping("/login.verify")
	@ResponseBody
	public String loginVerifySession(HttpServletRequest request,HttpServletResponse response){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("flag",0);

		String sessionId = request.getParameter("sid");
		UserSessionResult sessionResult = sysLoginFacade.getUserSession(sessionId);
		if(null != sessionResult){
			resultMap.put("flag",1);
		}
		return JSON.toJSONString(resultMap);
	}
}
