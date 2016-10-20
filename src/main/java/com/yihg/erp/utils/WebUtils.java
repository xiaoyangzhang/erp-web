package com.yihg.erp.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com.alibaba.fastjson.JSONObject;
import com.yihg.erp.contant.SecurityConstant;
import com.yihg.sys.api.PlatformSessionService;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.PlatformOrgPo;
import com.yihg.sys.po.SysBizInfo;
import com.yihg.sys.po.UserSession;

public class WebUtils {
	/**
	 * 获取当前B商家id
	 * @return
	 */
	public static Integer getCurBizId(HttpServletRequest request){
		//return 1;
		return getCurBizInfo(request).getId();
	}
	
	public static String getCurBizCode(HttpServletRequest request){
		//return "YM";
		return getCurBizInfo(request).getCode();
	}
	
	/**
	 * 获取当前用户id
	 * @return
	 */
	public static Integer getCurUserId(HttpServletRequest request){
		//return 26;
		return getCurUser(request).getEmployeeId();
	}
	
	public static PlatformOrgPo getCurOrgInfo(HttpServletRequest request){
		return getCurrentUserSession(request).getOrgInfo();
	}
	
	/**
	 * 获取当前商家的logo，请添加上fastdfs的http前缀
	 * @param request
	 * @return
	 */
	public static String getCurBizLogo(String path,HttpServletRequest request){
		SysBizInfo bizInfo = getCurBizInfo(request);
		if(StringUtils.isNotBlank(bizInfo.getLogo())){
			return path+bizInfo.getLogo();
		}
		return null;
	}
	
	/**
	 * 获取当前登录用户信息
	 * @return
	 */
	public static PlatformEmployeePo getCurUser(HttpServletRequest request){
		/*UserSession userSession = getCurrentUserSession(request);
		if(userSession!=null){
			return userSession.getEmployeeInfo();
		}
		return  null;*/
		
		/*PlatformEmployeePo user= new PlatformEmployeePo();
		user.setBizId(1);
		//用户id
		user.setEmployeeId(1);
		//名称
		user.setName("张三");
		user.setMobile("13588888888");
		user.setPhone("010-56789234");
		user.setFax("010-11119234");
		return user;*/
		return getCurrentUserSession(request).getEmployeeInfo();
	}

	
	/**
	 * 获取当前商家信息
	 * @param request
	 * @return
	 */
	public static SysBizInfo getCurBizInfo(HttpServletRequest request){
		/*SysBizInfo bizInfo = new SysBizInfo();
		bizInfo.setId(1);
		bizInfo.setCode("YM");
		bizInfo.setName("怡美假日旅行社");
		return bizInfo;*/
		return getCurrentUserSession(request).getBizInfo();
	}
	
	/**
	 * 获取当前用户的数据权限,value为用户id的列表
	 * @param request
	 * @return
	 */
	public static  Set<Integer> getDataUserIdSet(HttpServletRequest request){		
		/*Set<Integer> userIdList = new HashSet<Integer>();
		userIdList.add(1);
		userIdList.add(2);		
		return userIdList;*/
		return getCurrentUserSession(request).getDataUserIdSet();
	}
	
	/***
	 * 获取当前用户的数据权限，同getDataUserIdSet函数一样，返回的是字符串"1,2,3,5"这样
	 * @param request
	 * @return
	 */
	public static String getDataUserIdString(HttpServletRequest request){		
		return StringUtils.join(getCurrentUserSession(request).getDataUserIdSet(), ',');
	}
	
	public static UserSession getCurrentUserSession(HttpServletRequest request){
		/*String sessionId = getSessionId(request);
    	if(StringUtils.isNotEmpty(sessionId)){
    		WebApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
    		PlatformSessionService sessionService = ctx.getBean(PlatformSessionService.class);
    		if(StringUtils.isNotEmpty(sessionId)){
    			return sessionService.getUserSession(sessionId);
    		}
    	}
		return null;*/
		
		//TODO 后续统一替换成新的代码模式 liyong
		com.yimayhd.erpcenter.dal.sys.po.UserSession uss =(com.yimayhd.erpcenter.dal.sys.po.UserSession)request.getAttribute("userSession");
		if(uss != null){
			String json = JSONObject.toJSONString(uss);
			return JSONObject.parseObject(json, UserSession.class);
		}else{
			return null;
		}
	}	
	
	public static String getBizConfigValue(HttpServletRequest request,String key){
		 Map<String,String> map = getCurrentUserSession(request).getBizConfigMap();
		 if(map.containsKey(key)){
			 return map.get(key);
		 }
		 return null;
	}
	
	public static String getSessionId(HttpServletRequest request){
    	Cookie[] cookies = request.getCookies();
	    if(null!=cookies){
	        for(Cookie cookie : cookies){
	            if(SecurityConstant.USER_LOGIN_SESSION_KEY.equals(cookie.getName())){
	            	return cookie.getValue();
	            }
	        }
	    }
	    return null;
    }
	
	
	/**
	 * 解析请求中的参数,用于查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午5:31:07
	 * @param request
	 * @return
	 */
	public static Map getQueryParamters(HttpServletRequest request){
		
		Map pm = getRequestParamters(request);
		pm.put("bizId", WebUtils.getCurBizId(request));
		pm.put("set", WebUtils.getDataUserIdSet(request)); //权限id集合
		String rightUserIds = WebUtils.getDataUserIdString(request);
		if (!"".equals(rightUserIds))
			rightUserIds= rightUserIds.substring(0, rightUserIds.length() - 1);
		pm.put("rightUserIds", rightUserIds);//权限id字符串，查询时 跟 set随便用一个就行，因为set在mySql日志监控里会换行 ，看起来不方便，所以又加了该行
		return pm;
	}
	
	
	/**
	 * 解析请求中的参数
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午5:31:07
	 * @param request
	 * @return
	 */
	public static Map getRequestParamters(HttpServletRequest request){
		
		Map pm = new HashMap();
		Map rm = request.getParameterMap();
		Set<String> keys = rm.keySet();
		for (String k : keys) {
			String val =request.getParameter(k);
			pm.put(k, StringUtils.isBlank(val) ? null : val);
		}
		return pm;
	}
	
}
