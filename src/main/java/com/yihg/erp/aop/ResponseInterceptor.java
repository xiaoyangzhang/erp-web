package com.yihg.erp.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpresource.dal.constants.SupplierConstant;

/**
 * 处理响应资源
 * 
 * @author Jing.Zhuo
 * @create 2015年7月27日 上午10:54:07
 */
public class ResponseInterceptor extends HandlerInterceptorAdapter{
	
	@Autowired
	private SysConfig config;
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		
		request.setAttribute("images_source_200", config.getImages200Url());
		request.setAttribute("reqpm", WebUtils.getRequestParamters(request));
		request.setAttribute("sup_type_map",SupplierConstant.supplierTypeMap);

	}

}
