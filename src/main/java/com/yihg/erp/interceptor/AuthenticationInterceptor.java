package com.yihg.erp.interceptor;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.SysConfigConstant;
import com.yimayhd.erpcenter.dal.sys.po.PlatformMenuPo;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.sys.query.UserSessionDTO;
import com.yimayhd.erpcenter.facade.sys.result.UserSessionResult;
import com.yimayhd.erpcenter.facade.sys.service.SysLoginFacade;

public class AuthenticationInterceptor implements HandlerInterceptor {
	private static final Logger logger = LoggerFactory
			.getLogger(AuthenticationInterceptor.class);
	private PathMatcher pathMatcher = new AntPathMatcher();
	private List<String> excludedUrls;
	private List<String> noAuthorityUrls;

//	@Autowired
//	private PlatformSessionService platformSessionService;
	@Autowired
	private SysLoginFacade sysLoginFacade;
	public void setExcludedUrls(List<String> excludedUrls) {
		this.excludedUrls = excludedUrls;
	}

	public void setNoAuthorityUrls(List<String> noAuthorityUrls) {
		this.noAuthorityUrls = noAuthorityUrls;
	}

	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		//未登录判断
		for (String url : this.excludedUrls) {
			if (pathsMatch(url, request)) {
				return true;
			}
		}
		String sessionId = com.yihg.erp.utils.WebUtils.getSessionId(request);		
		if (sessionId == null) {
			response.sendRedirect(request.getContextPath() + "/login.htm");
			return false;
		}

		UserSessionResult userSessionReuslt = sysLoginFacade.getUserSession(sessionId);
		if (userSessionReuslt == null) {
			response.sendRedirect(request.getContextPath() + "/login.htm");
			return false;
		} else {
			UserSession userSession = new UserSession();
			BeanUtils.copyProperties(userSessionReuslt, userSession);
			UserSessionDTO userSessionDTO= new UserSessionDTO();
			userSessionDTO.setUserSession(userSession);
			sysLoginFacade.setUserSession(sessionId, SysConfigConstant.SESSION_TIMEOUT_SECONDS, userSessionDTO);
			//request中可以直接使用的
			request.setAttribute("userSession", userSession);
			// 管理员默认有所有权限
			if (userSession.getIsSuper() != 0) {
				return true;
			}
			if(!(handler instanceof HandlerMethod)){//不是controller过来的其他类型的请求
				return true;
			}
			HandlerMethod handlerMethod = (HandlerMethod) handler;
	        Method method = handlerMethod.getMethod();
	        RequiresPermissions permission = method.getAnnotation(RequiresPermissions.class);	        
	        if(permission!=null){
	        	Map<String,Map<String,Boolean>> menuOptMap = userSession.getMenuOptMap();
	        	if(menuOptMap.containsKey(permission.value())){
	        		Map<String,Boolean> map = menuOptMap.get(permission.value());
	        		request.setAttribute("optMap", map);
	        		return true;
	        	}else{
	        		logger.error("no Authority:" + request.getRequestURI());
					response.sendRedirect(request.getContextPath() + "/noAuth.htm");
					return false;
	        	}
	        }else{//如果没用注解配置功能权限，则取所有的操作权限
	        	Map<String,Boolean> optMap = userSession.getOptMap();
	        	request.setAttribute("optMap", optMap);
        		return true;
	        }
		}
	}

	/**
	 * 判断是否有菜单操作权限
	 * 
	 * @param list
	 * @param request
	 * @return
	 */
	public boolean hasPower(List<PlatformMenuPo> list,
			HttpServletRequest request) {
		for (PlatformMenuPo platformMenuPo : list) {
			if (pathsMatch(platformMenuPo.getUrl(), request)
					|| (platformMenuPo.getChildMenuList() != null
							&& platformMenuPo.getChildMenuList().size() > 0 && hasPower(
								platformMenuPo.getChildMenuList(), request))) {
				return true;
			}
		}
		return false;
	}

	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
	}

	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

	protected boolean pathsMatch(String path, ServletRequest request) {
		String requestURI = getPathWithinApplication(request);

		return pathsMatch(path, requestURI);
	}

	protected boolean pathsMatch(String pattern, String path) {
		return this.pathMatcher.match(pattern, path);
	}

	protected String getPathWithinApplication(ServletRequest request) {
		return WebUtils.getPathWithinApplication((HttpServletRequest) request);
	}
}
