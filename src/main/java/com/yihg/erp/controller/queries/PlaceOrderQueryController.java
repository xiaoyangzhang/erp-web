package com.yihg.erp.controller.queries;


import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;

import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import com.yimayhd.erpcenter.facade.dataanalysis.client.query.PlaceOrderQueryDTO;
import com.yimayhd.erpcenter.facade.dataanalysis.client.result.PlaceOrderQueryResult;
import com.yimayhd.erpcenter.facade.dataanalysis.client.service.PlaceOrderQueryFacade;
import com.yimayhd.erpresource.dal.po.SupplierInfo;
import org.apache.commons.lang.StringUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.sales.client.CommonDal;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.facade.basic.service.RegionFacade;
import com.yimayhd.erpcenter.facade.dataanalysis.client.query.GetNumAndOrderDTO;
import com.yimayhd.erpcenter.facade.dataanalysis.client.query.QueryDTO;
import com.yimayhd.erpcenter.facade.dataanalysis.client.result.GetNumAndOrderResult;
import com.yimayhd.erpcenter.facade.dataanalysis.client.result.QueryResult;
import com.yimayhd.erpcenter.facade.dataanalysis.client.result.RestaurantQueriesResult;
import com.yimayhd.erpcenter.facade.dataanalysis.client.service.DataAnalysisFacade;
import com.yimayhd.erpcenter.facade.dataanalysis.client.service.QueryFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;
import com.yimayhd.erpresource.dal.constants.BasicConstants;
import com.yimayhd.erpresource.dal.po.SupplierInfo;
import org.apache.commons.lang.StringUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;





@Controller
@RequestMapping("/placeOrderQuery")
public class PlaceOrderQueryController extends BaseController {
	@Autowired

	private ProductCommonFacade productCommonFacade;
	@Autowired
	private PlaceOrderQueryFacade placeOrderQueryFacade;

	private ApplicationContext appContext;

	@Autowired
	private SysPlatformEmployeeFacade platformEmployeeFacade;

	@Autowired
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private SysPlatformOrgFacade orgFacade;
	@Autowired
	QueryFacade queryFacade;
	@Autowired
	DataAnalysisFacade dataAnalysisFacade;

	@Autowired RegionFacade regionFacade;

	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model,
			HttpServletRequest request) {

		model.addAttribute("orgJsonStr", orgFacade
				.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
		model.addAttribute("orgUserJsonStr", platformEmployeeFacade
				.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
	}
	/**
	 * 获取查询服务
	 *
	/*	model.addAttribute("orgJsonStr", orgService
				.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
		model.addAttribute("orgUserJsonStr", platformEmployeeService
				.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));*/

		DepartmentTuneQueryDTO departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
	}
	/**
	 * 获取查询服务
	 *
	 * @author Jing.Zhuo
	 * @create 2015年8月18日 上午9:34:25
	 * @param svc
	 * @return
	 */
	private CommonDal getCommonService(String svc) {
		if (StringUtils.isBlank(svc)) {
			svc = "commonsaleService";
		}
		return appContext.getBean(svc, CommonDal.class);
	}

	// 业务查询公共方法
	private PageBean commonQuery(HttpServletRequest request, ModelMap model,
				String sl, Integer page, Integer pageSize, String svc) {
			/*PageBean pb = new PageBean();
			if (page == null) {
				pb.setPage(1);
			} else {

				pb.setPage(page);
			}
			if (pageSize == null) {
				pageSize = Constants.PAGESIZE;
			}
			pb.setPageSize(pageSize);
			Map paramters = WebUtils.getQueryParamters(request);

			paramters.put("citysSupplierIds",
					request.getAttribute("citysSupplierIds"));
			paramters.put("supplierLevel", request.getAttribute("supplierLevel"));
			// paramters.put("supplierDetailLevel",
			// request.getAttribute("supplierDetailLevel"));

			// 如果人员为空并且部门不为空，则取部门下的人id
			if (StringUtils.isBlank((String) paramters.get("saleOperatorIds"))
					&& StringUtils.isNotBlank((String) paramters.get("orgIds"))) {
				Set<Integer> set = new HashSet<Integer>();
				String[] orgIdArr = paramters.get("orgIds").toString().split(",");
				for (String orgIdStr : orgIdArr) {
					set.add(Integer.valueOf(orgIdStr));
				}
				set = platformEmployeeFacade.getUserIdListByOrgIdList(
						WebUtils.getCurBizId(request), set);
				String salesOperatorIds = "";
				for (Integer usrId : set) {
					salesOperatorIds += usrId + ",";
				}
				if (!salesOperatorIds.equals("")) {
					paramters.put("saleOperatorIds", salesOperatorIds.substring(0,
							salesOperatorIds.length() - 1));
				}
			}
			pb.setParameter(paramters);
			pb = getCommonService(svc).queryListPage(sl, pb);*/
		QueryDTO queryDTO = new QueryDTO();
		queryDTO.setSl(sl);
		queryDTO.setSvc(svc);
		queryDTO.setPage(page);
		queryDTO.setPageSize(pageSize);
		queryDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setParameters(WebUtils.getQueryParamters(request));
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		QueryResult queryResult = queryFacade.commonQuery(queryDTO);
		PageBean pb = queryResult.getPageBean();
		model.addAttribute("pageBean", queryResult.getPageBean());

		return pb;
		}

	/*预订明细统计查询*/
	@SuppressWarnings("unchecked")
	@RequestMapping("getSupplierStatisticsDetail")
	public String getSupplierDetails(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {

		GetNumAndOrderDTO getNumAndOrderDTO =new GetNumAndOrderDTO();
		getNumAndOrderDTO.setBizId(WebUtils.getCurBizId(request));
		getNumAndOrderDTO.setPage(page);
		getNumAndOrderDTO.setPageSize(pageSize);
		getNumAndOrderDTO.setParamters(WebUtils.getQueryParamters(request));
		getNumAndOrderDTO.setSl(sl);
		getNumAndOrderDTO.setSsl(ssl);
		getNumAndOrderDTO.setSvc(svc);

		getNumAndOrderDTO.setParamters(WebUtils.getQueryParamters(request));
		GetNumAndOrderResult result = dataAnalysisFacade.getSupplierDetails(getNumAndOrderDTO);
		model.addAttribute("sum", result.getSum());
		model.addAttribute("pageBean", result.getPb());
		return rp;
	}

	/**
	 * 初使化预订明细统计查询参数
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("placeOrderList.htm")
	public String sightList(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		/*//酒店、餐，景，车
		modelMap.addAttribute("supplierType", Constants.RESTAURANT+","+Constants.HOTEL+","+ Constants.FLEET+","+Constants.SCENICSPOT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);*/

	/*	// 景区类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.SCENICSPOT_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);*/

	/*	//省份
		List<RegionInfo> allProvince = regionFacade.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		//结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);*/

		/*// 获取酒店、餐，景，车类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT+","+BasicConstants.SUPPLIER_LEVEL_FLEET+","+BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		
		modelMap.addAttribute("levelList", levelList);*/

		//酒店、餐，景，车
		modelMap.addAttribute("supplierType", Constants.RESTAURANT+","+Constants.HOTEL+","+ Constants.FLEET+","+Constants.SCENICSPOT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);
		RestaurantQueriesResult result = dataAnalysisFacade.sightJSFS(bizId);
		modelMap.addAttribute("allProvince", result.getAllProvince());
		modelMap.addAttribute("cashType", result.getCashTypes());
		return "queries/placeorder/placeOrderDetailList";
	}
	

	
}
