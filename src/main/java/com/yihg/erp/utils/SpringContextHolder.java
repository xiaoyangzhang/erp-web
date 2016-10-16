package com.yihg.erp.utils;

import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * <strong>SpringContextHolder</strong><br>
 * Spring Context Holder<br>
 * <strong>Create on : 2011-12-31<br>
 * </strong>
 * <p>
 * <strong>Copyright (C) Ecointel Software Co.,Ltd.<br>
 * </strong>
 * <p>
 * 
 * @author peng.shi peng.shi@ecointel.com.cn<br>
 * @version <strong>Ecointel v1.0.0</strong><br>
 */
public class SpringContextHolder implements ApplicationContextAware {

	private static ApplicationContext applicationContext;

	public void setApplicationContext(ApplicationContext applicationContext) {
		SpringContextHolder.applicationContext = applicationContext;
	}

	/**
	 * 得到Spring 上下文环境
	 * 
	 * @return
	 */
	public static ApplicationContext getApplicationContext() {
		checkApplicationContext();
		return applicationContext;
	}

	/**
	 * 通过Spring Bean name 得到Bean
	 * 
	 * @param name
	 *            bean 上下文定义名称
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getBean(String name) {
		checkApplicationContext();
		return (T) applicationContext.getBean(name);
	}
	
	@SuppressWarnings("unchecked")
	public static <T> T getBeanByClass(String className) {
		checkApplicationContext();
		Class beanClass=applicationContext.getType(className);
		return (T) applicationContext.getBeansOfType(beanClass);
	}

	/**
	 * 通过类型得到Bean
	 * 
	 * @param clazz
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getBean(Class<T> clazz) {
		checkApplicationContext();
		return (T) applicationContext.getBeansOfType(clazz);
	}

	private static void checkApplicationContext() {
		if (applicationContext == null) {
			throw new IllegalStateException(
					"applicaitonContext未注入,请在application-context.xml中定义SpringContextHolder");
		}
	}

	public static boolean containsBean(String name) {
		return applicationContext.containsBean(name);
	}

	public static boolean isSingleton(String name)
			throws NoSuchBeanDefinitionException {
		return applicationContext.isSingleton(name);
	}

	public static Class getType(String name)
			throws NoSuchBeanDefinitionException {
		return applicationContext.getType(name);
	}

	public static String[] getAliases(String name)
			throws NoSuchBeanDefinitionException {
		return applicationContext.getAliases(name);
	}

}