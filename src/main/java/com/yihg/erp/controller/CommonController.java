package com.yihg.erp.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.erpcenterFacade.common.client.service.CommonFacade;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;

/**
 * 通用查询
 * 
 * @author Jing.Zhuo
 * @create 2015年7月27日 下午7:30:15
 */
@Controller
@RequestMapping(value = "/common")
public class CommonController {

	@Autowired
	private ApplicationContext appContext;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	/**
	 * 分页查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午7:30:42
	 * @param sl sqlId
	 * @param rp 返回页面
	 * @param svc 在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "queryListPage.htm")
	public String queryListPage(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String sl, String ssl, String rp, Integer page,
			Integer pageSize, String svc) {

		PageBean pb = new PageBean();
		if (page==null) {
			
			pb.setPage(1);
		}
		else {
			
			pb.setPage(page);
		}
		if(pageSize == null){
			pageSize = Constants.PAGESIZE;
		}
		else {
			
			pb.setPageSize(pageSize);
		}
		
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		
		String dateType = pms.get("dateType") != null ? pms.get("dateType").toString() : "";
		String startTime = null ;
		String endTime = null ;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(dateType!=null && dateType.equals("0")){
			try {
				startTime = pms.get("startTime") != null ? (sdf.parse(pms.get("startTime") .toString()).getTime()+""):null;
				endTime = pms.get("endTime") != null ? (sdf.parse(pms.get("endTime") .toString()).getTime()+""):null;
			} catch (ParseException e) {
				e.printStackTrace();
			}
			pms.put("startTime", startTime) ;
			pms.put("endTime", endTime) ;
		}
		
		
		String groupOrgIds = pms.get("orgIds") != null ? pms.get("orgIds").toString() : "";
		String groupSaleOperatorIds = pms.get("saleOperatorIds") != null ? pms.get("saleOperatorIds").toString() : "";
		
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(groupSaleOperatorIds) && StringUtils.isNotBlank(groupOrgIds)){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = groupOrgIds.split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				groupSaleOperatorIds = salesOperatorIds.substring(0, salesOperatorIds.length()-1);
//			}
//		}
		groupSaleOperatorIds = productCommonFacade.setSaleOperatorIds(groupSaleOperatorIds, 
				groupOrgIds, WebUtils.getCurBizId(request));
		if(null!=groupSaleOperatorIds && !"".equals(groupSaleOperatorIds)){
			pms.put("saleOperatorIds", groupSaleOperatorIds);
		}
		pms.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pms);
		pb=getCommonFacade(svc).queryListPage(sl, pb);
		model.addAttribute("pageBean", pb);
		model.addAttribute("reqpm", pms);
		
		
		//model.addAttribute("pageBean", getCommonService(svc).queryListPage(sl, pb));

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map pm = (Map)pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonFacade(svc).queryOne(ssl, pm));
		}
		return rp;
	}

	/**
	 * 列表查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午7:30:42
	 * @param sl sqlId
	 * @param rp 返回页面
	 * @param svc 在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "queryList.htm")
	public String queryList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String sl, String rp, String svc) {
		model.addAttribute("list", getCommonFacade(svc).queryList(sl, WebUtils.getQueryParamters(request)));
		return rp;
	}

	/**
	 * 对象查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午7:30:42
	 * @param sl sqlId
	 * @param rp 返回页面
	 * @param svc 在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "queryOne.htm")
	public String queryOne(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String sl, String rp, String svc) {
		model.addAttribute("one", getCommonFacade(svc).queryOne(sl, WebUtils.getQueryParamters(request)));
		return rp;
	}

	/**
	 * JSON对象查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午7:30:42
	 * @param sl sqlId
	 * @param svc 在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "queryJson.htm")
	public String queryJson(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String sl, String svc) {
		Object obj = getCommonFacade(svc).queryOne(sl, WebUtils.getQueryParamters(request));
		return JSON.toJSONString(obj);
	}

	/**
	 * 获取查询服务
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年8月18日 上午9:34:25
	 * @param svc
	 * @return
	 */
	private CommonFacade getCommonFacade(String svc) {
		if (StringUtils.isBlank(svc)) {
			svc = "commonFacade";
		}
		return appContext.getBean(svc, CommonFacade.class);
	}
}
