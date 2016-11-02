package com.yihg.erp.aop;

import java.lang.reflect.Field;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.ReflectiveMethodInvocation;

import com.google.gson.Gson;
import com.yimayhd.erpcenter.common.exception.ClientException;

@Aspect
public class PostInterceptor {

	private final static Logger logger = LoggerFactory.getLogger(PostInterceptor.class);

	@Around("execution(* com.yihg.erp..*.*(..))")
	public Object handYMPost(ProceedingJoinPoint pjp) throws Throwable {

		Field field = getMethodInvocation(pjp);
		ReflectiveMethodInvocation inv = (ReflectiveMethodInvocation) field.get(pjp);

		if (!inv.getMethod().isAnnotationPresent(PostHandler.class)) {
			return pjp.proceed();
		}

		ResultBean rst = new ResultBean();
		try {
			rst.setData(pjp.proceed());
			rst.setSuccess(true);
		} catch (ClientException e) {
			rst.setMsg(e.getMessage());
		} catch (Exception e) {
			rst.setMsg(getMsg(e.getMessage()));
			logger.error(e.getMessage(), e);
		}
		return inv.getMethod().getReturnType() == String.class ? new Gson().toJson(rst) : rst;
	}

	private Field methodInvocation;

	private Field getMethodInvocation(ProceedingJoinPoint pjp) throws SecurityException, NoSuchFieldException {
		if (methodInvocation == null) {
			methodInvocation = pjp.getClass().getDeclaredField("methodInvocation");
			methodInvocation.setAccessible(true);
		}
		return methodInvocation;
	}

	String getMsg(String msg) {
		if (msg == null)
			return null;
		if (msg.startsWith(ClientException.class.getName())) {
			int a = msg.indexOf(": ");
			int b = msg.indexOf("\n");
			if (a > 0 && b > a + 2)
				return msg.substring(a + 2, b);
		}
		return "未知异常";
	}
}
