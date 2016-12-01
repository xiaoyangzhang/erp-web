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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;


@Controller
@RequestMapping("/placeOrderQuery")
public class PlaceOrderQueryController extends BaseController {
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private PlaceOrderQueryFacade placeOrderQueryFacade;
	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model,
			HttpServletRequest request) {

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
	 * ��ȡ��ѯ����
	 *
	 * @author Jing.Zhuo
	 * @create 2015��8��18�� ����9:34:25
	 * @param svc
	 * @return
	 */
	/*private CommonService getCommonService(String svc) {
		if (StringUtils.isBlank(svc)) {
			svc = "commonsaleService";
		}
		return appContext.getBean(svc, CommonService.class);
	}*/

	// ҵ���ѯ��������
	/*private PageBean commonQuery(HttpServletRequest request, ModelMap model,
				String sl, Integer page, Integer pageSize, String svc) {
			PageBean pb = new PageBean();
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

			// �����ԱΪ�ղ��Ҳ��Ų�Ϊ�գ���ȡ�����µ���id
			if (StringUtils.isBlank((String) paramters.get("saleOperatorIds"))
					&& StringUtils.isNotBlank((String) paramters.get("orgIds"))) {
				Set<Integer> set = new HashSet<Integer>();
				String[] orgIdArr = paramters.get("orgIds").toString().split(",");
				for (String orgIdStr : orgIdArr) {
					set.add(Integer.valueOf(orgIdStr));
				}
				set = platformEmployeeService.getUserIdListByOrgIdList(
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
			pb = getCommonService(svc).queryListPage(sl, pb);
			model.addAttribute("pageBean", pb);

			return pb;
		}*/

	/*Ԥ����ϸͳ�Ʋ�ѯ*/
	@SuppressWarnings("unchecked")
	@RequestMapping("getSupplierStatisticsDetail")
	public String getSupplierDetails(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {

		Map paramters = WebUtils.getQueryParamters(request);
		PlaceOrderQueryDTO placeOrderQueryDTO = new PlaceOrderQueryDTO();
		placeOrderQueryDTO.setParamters(paramters);
		placeOrderQueryDTO.setSl(sl);
		placeOrderQueryDTO.setSsl(ssl);
		placeOrderQueryDTO.setRp(rp);
		placeOrderQueryDTO.setPage(page);
		placeOrderQueryDTO.setPageSize(pageSize);
		placeOrderQueryDTO.setSvc(svc);
		placeOrderQueryDTO.setVisit(visit);
		PlaceOrderQueryResult placeOrderQueryResult = placeOrderQueryFacade.getSupplierDetails(placeOrderQueryDTO);
		model.addAttribute("sum", placeOrderQueryResult.getSum());
		model.addAttribute("pageBean", placeOrderQueryResult.getPageBean());
		return rp;
	}

	/**
	 * ��ʹ��Ԥ����ϸͳ�Ʋ�ѯ����
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
		//�Ƶꡢ�ͣ�������
		modelMap.addAttribute("supplierType", Constants.RESTAURANT+","+Constants.HOTEL+","+Constants.FLEET+","+Constants.SCENICSPOT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);
		PlaceOrderQueryDTO placeOrderQueryDTO = new PlaceOrderQueryDTO();
		placeOrderQueryDTO.setBizId(bizId);
		PlaceOrderQueryResult placeOrderQueryResult = placeOrderQueryFacade.sightList(placeOrderQueryDTO);

	/*	// ��������
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.SCENICSPOT_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);*/

		//ʡ��
		modelMap.addAttribute("allProvince", placeOrderQueryResult.getAllProvince());

		//���㷽ʽ
		modelMap.addAttribute("cashType", placeOrderQueryResult.getCashTypes());

		/*// ��ȡ�Ƶꡢ�ͣ����������
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT+","+BasicConstants.SUPPLIER_LEVEL_FLEET+","+BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		
		modelMap.addAttribute("levelList", levelList);*/

		return "queries/placeorder/placeOrderDetailList";
	}
	

	
}
