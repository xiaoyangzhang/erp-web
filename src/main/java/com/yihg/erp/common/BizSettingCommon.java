package com.yihg.erp.common;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;

@Service
public class BizSettingCommon {
//	@Resource
//	private PlatformOrgService orgService;	
	@Autowired
	private SysPlatformOrgFacade platformOrgFacade;
	@Resource
	private SysConfig config;
	/**
	 * 获取当前公司或商家编码
	 * TODO 设置开关：有的公司取商家编码，有的公司取公司编码
	 * @param request
	 * @return
	 */
	public String getMyBizCode(HttpServletRequest request){
		//WebUtils.getCurBizCode(request)
		return platformOrgFacade.getCompanyCodeByOrgId(WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getOrgId());
	}
	
	/**
	 * 获取当前公司或商家logo
	 * TODO 设置开关：有的公司取商家logo，有的公司取公司logo
	 * @param request
	 * @return
	 */
	public String getMyBizLogo(HttpServletRequest request){		
		//WebUtils.getCurBizLogo(path, request)
		return getOrgLogo(WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getOrgId());
	}
	
	/**
	 * 根据orgId向上遍历查找logo
	 * @param bizId
	 * @param orgId
	 * @return
	 */
	public String getOrgLogo(Integer bizId,Integer orgId){
		String logo = platformOrgFacade.getLogoByOrgId(bizId,orgId); 
		if(StringUtils.isNotBlank(logo)){
			return config.getImgServerUrl()+logo;
		}
		return null;
	}
}
