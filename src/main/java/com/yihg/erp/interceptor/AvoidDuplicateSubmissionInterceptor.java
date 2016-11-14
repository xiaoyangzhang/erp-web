package com.yihg.erp.interceptor;

import java.lang.reflect.Method;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.yihg.erp.aop.AvoidDuplicateSubmission;
import com.yihg.erp.contant.TokenConstant.tokenActionEnum;

public class AvoidDuplicateSubmissionInterceptor extends
		HandlerInterceptorAdapter {
	private static final Logger LOG = Logger
			.getLogger(AvoidDuplicateSubmissionInterceptor.class);

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		if (!(handler instanceof HandlerMethod)) {// 不是controller过来的其他类型的请求
			return true;
		}
		HandlerMethod handlerMethod = (HandlerMethod) handler;
		Method method = handlerMethod.getMethod();

		AvoidDuplicateSubmission annotation = method
				.getAnnotation(AvoidDuplicateSubmission.class);
		if (annotation != null) {
			tokenActionEnum tokenActionEnum = annotation.validToken();
			if (tokenActionEnum.equals(tokenActionEnum.add)) {
				request.getSession(false).setAttribute("token",
						UUID.randomUUID().toString());
			} else {
				if (isRepeatSubmit(request)) {
					LOG.warn("please don't repeat submit!");
					return false;
				}
				request.getSession(false).removeAttribute("token");
			}
		}

		return true;
	}

	private boolean isRepeatSubmit(HttpServletRequest request) {
		String serverToken = (String) request.getSession(false).getAttribute(
				"token");
		if (serverToken == null) {
			return true;
		}
		String clinetToken = request.getParameter("token");
		if (clinetToken == null) {
			return true;
		}
		if (!serverToken.equals(clinetToken)) {
			return true;
		}
		return false;
	}

}
