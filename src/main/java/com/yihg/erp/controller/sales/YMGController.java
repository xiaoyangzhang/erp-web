package com.yihg.erp.controller.sales;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.yimayhd.erpcenter.facade.finance.result.QueryYmgOrderListByOpTable;
import org.yimayhd.erpcenter.facade.finance.result.QueryYmgOrderListTableDataResult;
import org.yimayhd.erpcenter.facade.finance.result.SaveSpecialGroupResult;
import org.yimayhd.erpcenter.facade.finance.result.ToEditTaobaoOrderResult;
import org.yimayhd.erpcenter.facade.finance.service.YMGFacade;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.LogUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.constant.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SpecialGroupOrderVO;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.basic.service.DicFacade;
import com.yimayhd.erpcenter.facade.basic.service.RegionFacade;

/**
 * Created by zhoum on 2017/2/07.
 */
@Controller
@RequestMapping(value = "/ymg")
public class YMGController extends BaseController{
	
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
	@Autowired
	private DicFacade dicFacade;
	
	@Autowired
	private RegionFacade regionFacade;
	
	@Autowired
	private YMGFacade ymgFacade;
	
	@Autowired
	private SysConfig config;
	
	@Autowired
	private BizSettingCommon settingCommon;
	
	
	/**
	 * ymg-操作单
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("ymgOrderList.htm")
	public String ymgOrderList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		List<DicInfo> pp = dicFacade.getListByTypeCode(BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		List<RegionInfo> allProvince = regionFacade.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> typeList = dicFacade.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE, bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicFacade.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);

		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("curUser", WebUtils.getCurUser(request).getName());
		model.addAttribute("curUserId", WebUtils.getCurUserId(request));

		return "sales/ymgOrder/ymgOrderList";
	}
	
	
	@RequestMapping("ymgOrderList_tableData.do")
	@ResponseBody
	public String ymgOrderList_tableData(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
			Integer rows, GroupOrder groupOrder) throws ParseException {
		
		String sidx = request.getParameter("sidx");
		String sord = request.getParameter("sord");
		QueryYmgOrderListTableDataResult result = ymgFacade.queryYmgOrderListTableData(sidx, sord, rows, 
				groupOrder, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		
	   PageBean<GroupOrder> page = result.getPage();
				
	   model.addAttribute("typeList", result.getTypeList());
	   model.addAttribute("page", page);
	   /*
		 * SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		 * String today = formatter.format(new Date());
		 * model.addAttribute("today", today);
	   */
	   return JSON.toJSONString(page);
	}

	@RequestMapping("ymgOrderList_PostFooter.do")
	@ResponseBody
	public String ymgOrderList_PostFooter(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
			GroupOrder groupOrder) throws ParseException {
		
		GroupOrder go = ymgFacade.ymgOrderListPostFooter(groupOrder, WebUtils.getDataUserIdSet(request), WebUtils.getCurBizId(request));
		model.addAttribute("go", go);
		return JSON.toJSONString(go);
	}
	
	/**
	 * ymg-计调操作单
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("ymgOrderListByOp.htm")
	public String ymgOrderListByOp(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		List<DicInfo> pp = dicFacade.getListByTypeCode(BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		List<RegionInfo> allProvince = regionFacade.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> typeList = dicFacade.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE, bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicFacade.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);

		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "sales/ymgOrder/ymgOrderListByOp";
	}

	/**
	 * ymg-计调操作单table
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 */
	@RequestMapping("ymgOrderListByOp_table.htm")
	public String ymgOrderListByOp_table(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
			GroupOrder groupOrder) throws ParseException {
		
		
		QueryYmgOrderListByOpTable result = ymgFacade.ymgOrderListByOpTable(groupOrder, 
				WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("typeList", result.getTypeList());
		model.addAttribute("pageTotalAudit", result.getPageTotalAudit());
		model.addAttribute("pageTotalChild", result.getTotalChild());
		model.addAttribute("pageTotalGuide", result.getTotalGuide());
		model.addAttribute("pageTotal", result.getPageTotal());
		model.addAttribute("page", result.getPage());
		model.addAttribute("totalAudit", result.getTotalAdult());
		model.addAttribute("totalChild", result.getTotalChild());
		model.addAttribute("totalGuide", result.getTotalGuide());
		model.addAttribute("total", result.getTotal());

		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String, Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.JDGL_JDCZD;
		model.addAttribute("CHANGE_PRICE",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.CHANGE_PRICE)));
		return "sales/ymgOrder/ymgOrderListByOp_table";
	}
	
	/**
	 * 跳转到新增订单页面
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("addYMGOrder.htm")
	public String addYMGOrder(HttpServletRequest request, HttpServletResponse reponse, String retVal,
			ModelMap model) {
		
		model.addAttribute("OrgId", WebUtils.getCurOrgInfo(request).getParentId());
		
		model.addAttribute("operType", 1);
		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		SpecialGroupOrderVO vo = new SpecialGroupOrderVO();
		vo.setGroupOrder(groupOrder);
		model.addAttribute("vo", vo);
		int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> jdxjList = dicFacade.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicFacade.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicFacade.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> typeList = dicFacade.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE, bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicFacade
				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		/*
		 * List<DicInfo> sourceTypeList =
		 * dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		 * model.addAttribute("sourceTypeList", sourceTypeList);
		 */
		List<RegionInfo> allProvince = regionFacade.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		List<DicInfo> lysfxmList = dicFacade.getListByTypeCode(BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		model.addAttribute("config", config);
		model.addAttribute("retVal", retVal);
		return "sales/ymgOrder/addYMGOrder";
	}

	/**
	 * 保存订单
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveYMGSpecialGroup.do")
	@ResponseBody
	public String saveSpecialGroup(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
			SpecialGroupOrderVO vo, String ids, String id, Integer GroupMode) throws ParseException {
		
		SaveSpecialGroupResult result = ymgFacade.saveSpecialGroup(vo, ids, ids, GroupMode, settingCommon.getMyBizCode(request), 
				WebUtils.getCurBizId(request), WebUtils.getCurUser(request));
		
		if(result.isSuccess()){
			return successJson("groupId", result.getOrderId() + "");
		}else{
			return errorJson(result.getResultMsg());
		}
	}
	
	/* 操作单-编辑 */
	@RequestMapping(value = "toEditYMGOrder.htm")
	public String toEditTaobaoOrder(HttpServletRequest request, HttpServletResponse reponse, Integer see,
			ModelMap model, Integer id, Integer operType) throws ParseException { // see=0
																					// 查看
																					// see=1操作单编辑
																					// see=2计调操作单
		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String, Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.JDGL_JDCZD;
		model.addAttribute("SH", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.JDCZD_SH)));
		if (operType == null) {
			operType = 1;
		}
		model.addAttribute("operType", operType);
		List<DicInfo> jdxjList = dicFacade.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> zjlxList = dicFacade.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> lysfxmList = dicFacade.getListByTypeCode(BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		List<DicInfo> jtfsList = dicFacade.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> typeList = dicFacade.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE, bizId);
		model.addAttribute("typeList", typeList);
		List<RegionInfo> allProvince = regionFacade.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("config", config);
		List<DicInfo> sourceTypeList = dicFacade.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		model.addAttribute("see", see);
		
		ToEditTaobaoOrderResult toEditResult = ymgFacade.toEditTaobaoOrder(see, id, operType, 
				WebUtils.getCurOrgInfo(request).getParentId(), WebUtils.getCurUserId(request), bizId);
		
		model.addAttribute("vo", toEditResult.getVo());
		model.addAttribute("allowNum", toEditResult.getCount()); // 库存
		model.addAttribute("allCity", toEditResult.getCityList());
		model.addAttribute("allCity1", toEditResult.getDepartCityList());
		model.addAttribute("guideStr", toEditResult.getGuideStr());
		model.addAttribute("orders", toEditResult.getOrders());
		model.addAttribute("tbIds", toEditResult.getTbOrderIds());

		// 获取消息
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bizId", bizId);
		map.put("userId", WebUtils.getCurUserId(request));
		map.put("OrgId", WebUtils.getCurOrgInfo(request).getParentId());
		map.put("orderId", id);

		model.addAttribute("msgInfoList", toEditResult.getMsgInfo());

		model.addAttribute("groupCanEdit", toEditResult.getGroupCanEdit());
		model.addAttribute("groupId", toEditResult.getGroupId());
		model.addAttribute("bookingInfo", toEditResult.getDatas());

		model.addAttribute("bdList", toEditResult.getList());
		model.addAttribute("tg", toEditResult.getTg());
		return "sales/ymgOrder/addYMGOrder";
	}
}
