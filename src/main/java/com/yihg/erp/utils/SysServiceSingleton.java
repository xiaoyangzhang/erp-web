package com.yihg.erp.utils;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.yimayhd.erpcenter.dal.sys.po.PlatformSysPo;
import com.yimayhd.erpcenter.facade.sys.result.PlatformSysPoResult;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformSysFacade;
public class SysServiceSingleton {

	private static final Logger LOGGER = LoggerFactory
			.getLogger(SysServiceSingleton.class);

	private static ApplicationContext context;
	
	private static String code;

	static class SysServiceSingletonHolder {
		static SysServiceSingleton instance = new SysServiceSingleton();
		static {
			context = new ClassPathXmlApplicationContext(
					new String[] { "remoting.xml" });
			InputStream resourceAsStream = SysServiceSingleton.class.getResourceAsStream("/application.properties");
			Properties pps = new Properties();
			try {
				pps.load(resourceAsStream);
				code = pps.getProperty("sys.code");
			} catch (FileNotFoundException e) {
				LOGGER.error(e.getMessage(), e);
			} catch (IOException e) {
				LOGGER.error(e.getMessage(), e);
			}
		}
	}

	public static SysServiceSingleton getInstance() {
		return SysServiceSingletonHolder.instance;
	}

	@SuppressWarnings("finally")
	public SysPlatformSysFacade getPlatformSysService(){
		SysPlatformSysFacade platformSysService = null;
		try{
			platformSysService = (SysPlatformSysFacade)context.getBean("sysPlatformSysFacade");
		}
		catch(Exception e){
			LOGGER.error(e.getMessage(), e);
		}
		finally{
			return platformSysService;
		}
	}
	
	public static PlatformSysPoResult  getPlatformSysPo() {
		PlatformSysPoResult platformSysPo = null;
		platformSysPo =  getInstance().getPlatformSysService().findByCode(code);
		return platformSysPo;
	}

}

