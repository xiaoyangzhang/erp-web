package com.yihg.erp.controller.agency;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.query.BrandQueryDTO;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.BrandQueryResult;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.result.RegionResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.common.MergeGroupUtils;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductRemark;
import com.yimayhd.erpcenter.dal.product.vo.ProductGroupVo;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.FitOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.MergeGroupOrderVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.sales.query.AgencyOrderQueryDTO;
import com.yimayhd.erpcenter.facade.sales.result.AgencyOrderResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.WebResult;
import com.yimayhd.erpcenter.facade.sales.service.AgencyFitFacade;

@Controller
@RequestMapping(value = "/agencyFit")
public class AgencyFitController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(AgencyFitController.class);

	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private AgencyFitFacade agencyFitFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@RequestMapping(value = "getGroupPirceData.do", method = RequestMethod.GET)
	@ResponseBody
	public String getGroupPirceData(Integer productId, Integer supplierId,
			Date date) {
		List<ProductGroupVo> priceGroup = agencyFitFacade.selectGroupsByProdctIdAndSupplierId(productId, supplierId,date);
//		List<ProductGroupVo> priceGroup = productGroupService
//				.selectGroupsByProdctIdAndSupplierId(productId, supplierId,
//						date);
		Gson gson = new Gson();
		String string = gson.toJson(priceGroup);
		return string;
	}

	/**
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param productId
	 * @param groupId
	 * @param priceId
	 * @param date
	 * @param adultPrice
	 * @param childPrice
	 * @param type
	 *            订单类型 1确认 0预留
	 * @return
	 */
	@RequestMapping(value = "toAddGroupOrder.htm", method = RequestMethod.GET)
	public String toAddGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer productId,
			Integer groupId, Integer priceId, Date date, Float adultPrice,
			Float childPrice, Float adultCost, Float childCost, Integer type) {

		model.addAttribute("operType", 1);
		model.addAttribute("editType", true);
		model.addAttribute("config", config);
		model.addAttribute("isSales", true);

		model.addAttribute("groupId", groupId);
		model.addAttribute("adultPrice", adultPrice);
		model.addAttribute("childPrice", childPrice);
		model.addAttribute("adultCost", adultCost);
		model.addAttribute("childCost", childCost);

//		List<ProductGroupSupplierVo> groupSuppliersList = productGroupSupplierService
//				.selectProductGroupSupplierVos(groupId, priceId);
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setDate(date);
		queryDTO.setGroupId(groupId);
		queryDTO.setPriceId(priceId);
		queryDTO.setProductId(productId);
		AgencyOrderResult result = agencyFitFacade.toAddGroupOrder(queryDTO);
		model.addAttribute("supplierList", result.getGroupSupplierVos());

//		ProductInfo productInfo = productInfoService
//				.findProductInfoById(productId);
//		ProductGroup group = productGroupService.getGroupInfoById(groupId);
		model.addAttribute("productGroup", result.getProductGroup());

		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		model.addAttribute("curUser", curUser);
//		ProductRemark productRemark = productRemarkService
//				.findProductRemarkByProductId(productId);
		ProductRemark productRemark = result.getProductRemark();
		ProductInfo productInfo = result.getProductInfo();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		FitOrderVO vo = new FitOrderVO();
		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setType(type);
		groupOrder.setPriceId(priceId);
		groupOrder.setSaleOperatorId(curUser.getEmployeeId());
		groupOrder.setSaleOperatorName(curUser.getName());
		groupOrder.setOperatorId(productInfo.getOperatorId());
		groupOrder.setOperatorName(productInfo.getOperatorName());
		groupOrder.setRemark(productRemark.getRemarkInfo());
		groupOrder.setServiceStandard(productRemark.getServeLevel());
		groupOrder.setProductBrandId(productInfo.getBrandId());
		groupOrder.setProductBrandName(productInfo.getBrandName());
		groupOrder.setProductId(productInfo.getId());
		groupOrder.setProductName(productInfo.getNameCity());
		groupOrder.setDepartureDate(sdf.format(date));
		vo.setGroupOrder(groupOrder);
		model.addAttribute("vo", vo);
		
//		int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),date);
		int count = result.getCount();
		model.addAttribute("allowNum", count); // 库存

		int bizId = WebUtils.getCurBizId(request);
		model.addAttribute("productId", productId);
//		List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		List<DicInfo> jdxjList = saleCommonFacade.getHotelLevelListByTypeCode();
		model.addAttribute("jdxjList", jdxjList);
//		List<DicInfo> jtfsList = dicService.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		List<DicInfo> jtfsList = saleCommonFacade.getTransportListByTypeCode(bizId);
		model.addAttribute("jtfsList", jtfsList);
//		List<DicInfo> zjlxList = dicService.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		List<DicInfo> zjlxList = saleCommonFacade.getCertificateTypesByTypeCode();
		model.addAttribute("zjlxList", zjlxList);
//		List<DicInfo> guestSourceList = dicService.getListByTypeCode(BasicConstants.GYXX_GUESTSOURCE,bizId);
		List<DicInfo> guestSourceList = saleCommonFacade.getGuestSourcesByTypeCode(bizId);
		model.addAttribute("guestSourceList", guestSourceList);

		DicInfo dicInfoCR = saleCommonFacade.getAdultFeeItems(bizId);
//		DicInfo dicInfoCR = dicService.getDicInfoByTypeCodeAndDicCode(
//				WebUtils.getCurBizId(request), BasicConstants.GYXX_LYSFXM,
//				BasicConstants.CR);
		DicInfo dicInfoET = saleCommonFacade.getEatFeeItems(bizId);
//		DicInfo dicInfoET = dicService.getDicInfoByTypeCodeAndDicCode(
//				WebUtils.getCurBizId(request), BasicConstants.GYXX_LYSFXM,
//				BasicConstants.ERT);

		List<DicInfo> dicInfoCRList = new ArrayList<DicInfo>();
		dicInfoCRList.add(dicInfoCR);
		List<DicInfo> dicInfoETList = new ArrayList<DicInfo>();
		dicInfoETList.add(dicInfoET);
		model.addAttribute("dicInfoCRList", dicInfoCRList);
		model.addAttribute("dicInfoETList", dicInfoETList);

		List<DicInfo> sourceTypeList = saleCommonFacade.getGuestSourceTypes(bizId);
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", regionResult.getRegionList());
		
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(BasicConstants.GYXX_LYSFXM, bizId);
		List<DicInfo> lysfxmList = saleCommonFacade.getFeeItems2(bizId);
		model.addAttribute("lysfxmList", lysfxmList);

		return "agency/fitOrder/fitOrderInfo";
	}

	@RequestMapping(value = "toEditFirOrder.htm", method = RequestMethod.GET)
	public String toEditFirOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer orderId,
			Integer operType, boolean isSales) throws Exception {
		AgencyOrderResult result = agencyFitFacade.toEditFirOrder(orderId);
//		FitOrderVO vo = fitOrderService.selectFitOrderVOById(orderId);
		FitOrderVO vo = result.getFitOrderVO();
		model.addAttribute("vo", vo);
		model.addAttribute("operType", operType);
		model.addAttribute("config", config);
		model.addAttribute("editType", false);
		model.addAttribute("isSales", isSales);

//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		GroupOrder groupOrder = groupOrderService.findById(orderId);
//		int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),sdf.parse(groupOrder.getDepartureDate()));
		int count = result.getCount();
		model.addAttribute("allowNum", count); // 库存

		int bizId = WebUtils.getCurBizId(request);
		
		List<DicInfo> jdxjList = saleCommonFacade.getHotelLevelListByTypeCode();
//		List<DicInfo> jdxjList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = saleCommonFacade.getTransportListByTypeCode(bizId);
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = saleCommonFacade.getCertificateTypesByTypeCode();
//		List<DicInfo> zjlxList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		List<DicInfo> sourceTypeList = saleCommonFacade.getGuestSourceTypes(bizId);
//		List<DicInfo> guestSourceList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_GUESTSOURCE,bizId);
		List<DicInfo> guestSourceList = saleCommonFacade.getGuestSourcesByTypeCode(bizId);
		model.addAttribute("guestSourceList", guestSourceList);
		model.addAttribute("sourceTypeList", sourceTypeList);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", regionResult.getRegionList());

		List<RegionInfo> cityList = result.getRegionList();
//		if (groupOrder.getProvinceId() != null && groupOrder.getProvinceId() != -1) {
//			cityList = regionService.getRegionById(groupOrder.getProvinceId()
//					+ "");
//		}
		model.addAttribute("allCity", cityList);
		
		List<DicInfo> lysfxmList = saleCommonFacade.getFeeItems2(bizId);
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
//				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
//		List<Map<String, Object>> payDetails = financeService
//				.selectDetailByLocOrderId(orderId);
		model.addAttribute("payDetails", result.getMapList());
		return "agency/fitOrder/fitOrderInfo";
	}

	@RequestMapping(value = "saveFitOrderInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveFitOrderInfo(HttpServletRequest request,
			FitOrderVO fitOrderVO) throws Exception {
//		ProductInfo productInfo ;
//		Integer orderId;
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		Integer newNum = fitOrderVO.getGroupOrder().getNumAdult()
//				+ fitOrderVO.getGroupOrder().getNumChild();   //修改后人数
//		
//		Integer oldNum = 0;  //修改前人数
//		try {
//			if (fitOrderVO.getGroupOrder().getId() != null) {
//				FitOrderVO vo = fitOrderService.selectFitOrderVOById(fitOrderVO
//						.getGroupOrder().getId());
//
//				oldNum = vo.getGroupOrder().getNumAdult()
//						+ vo.getGroupOrder().getNumChild();
//			}
//			
//			//查出库存(剩余人数)
//			int freeCount = productStockService.getRestCountByProductIdAndDate(fitOrderVO
//					.getGroupOrder().getProductId(),sdf.parse(fitOrderVO
//							.getGroupOrder().getDepartureDate()));
//			//实际库存应该是修改前人数+库存
//			freeCount = oldNum + freeCount;
//			if(newNum > freeCount){
//				//如果新增人数大于库存,则不能保存
//				return errorJson("由于库存剩余数有变化，目前剩余库存不足【" + newNum + "】！实际库存还有【" + freeCount + "】");
//			}
//			
			fitOrderVO.getGroupOrder().setOrderNo(
					settingCommon.getMyBizCode(request));
			fitOrderVO.setAgency(true);
//			if(fitOrderVO.getGroupOrder().getId()==null){
//				fitOrderVO.setProductCode(productInfoService.findProductInfoById(fitOrderVO.getGroupOrder().getProductId()).getCode());
//			}
////			String bizConfigValue = WebUtils.getBizConfigValue(request,
////					BizConfigConstant.AUTO_MERGE_ORDER);
//			 productInfo = productInfoService.findProductInfoById(fitOrderVO.getGroupOrder().getProductId());
//			orderId = fitOrderService.saveOrUpdateFitOrderInfo(fitOrderVO,
//					WebUtils.getCurUserId(request), WebUtils
//							.getCurUser(request).getName(),productInfo==null?null:productInfo.getOperatorId(),productInfo==null?"":productInfo.getOperatorName(), WebUtils
//							.getCurBizId(request), settingCommon
//							.getMyBizCode(request), true);
//		} catch (ParseException e) {
//			return errorJson("操作失败,请检查后重试！");
//		}
//		try {
//			if(productInfo!=null){
//				if(fitOrderVO.getGroupOrder().getType()==0){ //预留
//					productStockService.updateReserveCount(fitOrderVO.getGroupOrder().getProductId(), sdf.parse(fitOrderVO.getGroupOrder().getDepartureDate()), newNum - oldNum);
//					
//				}else{
//				
//
//				productStockService.updateStockCount(fitOrderVO.getGroupOrder()
//						.getProductId(), sdf.parse(fitOrderVO.getGroupOrder()
//						.getDepartureDate()), newNum - oldNum);
//				
//				}
//			}
//			
//			
//			
//			
//		} catch (Exception e) {
//			return errorJson("更新库存失败！");
//		}
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setBizCode(settingCommon.getMyBizCode(request));
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setUserId(WebUtils.getCurUserId(request));
		queryDTO.setUserName(WebUtils.getCurUser(request).getName());
		WebResult<Map<String,Object>> result = agencyFitFacade.saveFitOrderInfo(fitOrderVO, queryDTO);
		
		return result.isSuccess() ? successJson("orderId", result.getValue().get("orderId")+"") : errorJson(result.getResultMsg());
	}

	/**
	 * 门市管理-散客订单列表
	 * @param request
	 * @param reponse
	 * @param model
	 * @param isSales
	 * @return
	 */
	@RequestMapping(value = "toFitOrderListForMsgl.htm")
	@RequiresPermissions(PermissionConstants.MSGL_SK_ORDER)
	public String toFitOrderListForMsgl(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("isSales", true);
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult pp = productCommonFacade.brandQuery(brandQueryDTO);
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp.getBrandList());
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", regionResult.getRegionList());
		
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> sourceTypeList = saleCommonFacade.getGuestSourceTypes(bizId);
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "agency/fitOrder/fitOrderList";
	}
	@RequestMapping(value = "getFitOrderListForMsglData.do")
	@RequiresPermissions(PermissionConstants.MSGL_SK_ORDER)
	public String getFitOrderListForMsglData(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder) throws ParseException {
		model.addAttribute("isSales", true);
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (!"".equals(groupOrder.getStartTime())) {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime())
						.getTime() + "");
			}
			if (!"".equals(groupOrder.getEndTime())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
		}

		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = groupOrder.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(
//					WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				groupOrder.setSaleOperatorIds(salesOperatorIds.substring(0,
//						salesOperatorIds.length() - 1));
//			}
//		}
		groupOrder.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(groupOrder.getSaleOperatorIds(),
				groupOrder.getOrgIds(), WebUtils.getCurBizId(request)));
		
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage() == null ? 1 : groupOrder
				.getPage());
		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectFitOrderListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request),0);
//		List<GroupOrder> list = pageBean.getResult();
//		if (list != null && list.size() > 0) {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//			for (GroupOrder groupOrder2 : list) {
//				if (groupOrder2.getCreateTime() != null) {
//					Long createTime = groupOrder2.getCreateTime();
//					String dateStr = sdf.format(createTime);
//					groupOrder2.setCreateTimeStr(dateStr);
//					
//					if (groupOrder2.getProductId()!=null){ 
//						ProductInfo productInfo = productInfoService.findProductInfoById(groupOrder2.getProductId());
//						groupOrder2.setQuartzTime(productInfo.getObligateHour());
//					}
//				}
//
//			}
//		}
//
//		GroupOrder order = groupOrderService.selectFitOrderTotalCount(
//				groupOrder, WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request),0);
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setGroupOrder(groupOrder);
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setPageBean(pageBean);
		queryDTO.setOperatorType(0);
		AgencyOrderResult result = agencyFitFacade.getFitOrderListForMsglData(queryDTO);
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("totalOrder", result.getGroupOrder());
		return "agency/fitOrder/fitOrderList_table";
	}

	@RequestMapping(value = "toFitOrderListForSales.htm")
	@RequiresPermissions(PermissionConstants.XSGL_SK_ORDER)
	public String toFitOrderListForSales(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("isSales", false);
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult pp = productCommonFacade.brandQuery(brandQueryDTO);
		model.addAttribute("pp", pp.getBrandList());
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE);
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", regionResult.getRegionList());
		
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> sourceTypeList = saleCommonFacade.getGuestSourceTypes(bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "agency/fitOrder/fitOrderList";
	}
	
	@RequestMapping(value = "getFitOrderListForSalesData.do")
	@RequiresPermissions(PermissionConstants.XSGL_SK_ORDER)
	public String getFitOrderListForSalesData(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder) throws ParseException {
		model.addAttribute("isSales", false);
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (!"".equals(groupOrder.getStartTime())) {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime())
						.getTime() + "");
			}
			if (!"".equals(groupOrder.getEndTime())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
		}

		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = groupOrder.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(
//					WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				groupOrder.setSaleOperatorIds(salesOperatorIds.substring(0,
//						salesOperatorIds.length() - 1));
//			}
//		}
		groupOrder.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(groupOrder.getSaleOperatorIds(),
				groupOrder.getOrgIds(), WebUtils.getCurBizId(request)));
		
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage() == null ? 1 : groupOrder
				.getPage());
		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectFitOrderListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request),1);
//		List<GroupOrder> list = pageBean.getResult();
//		if (list != null && list.size() > 0) {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//			for (GroupOrder groupOrder2 : list) {
//				if (groupOrder2.getCreateTime() != null) {
//					Long createTime = groupOrder2.getCreateTime();
//					String dateStr = sdf.format(createTime);
//					groupOrder2.setCreateTimeStr(dateStr);
//					if (groupOrder2.getProductId()!=null){
//						ProductInfo productInfo = productInfoService.findProductInfoById(groupOrder2.getProductId());
//						groupOrder2.setQuartzTime(productInfo.getObligateHour());
//					}
//				}
//
//			}
//		}
//
//		GroupOrder order = groupOrderService.selectFitOrderTotalCount(
//				groupOrder, WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request),1);
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setGroupOrder(groupOrder);
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setPageBean(pageBean);
		queryDTO.setOperatorType(1);
		AgencyOrderResult result = agencyFitFacade.getFitOrderListForMsglData(queryDTO);
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("totalOrder", result.getGroupOrder());
		return "agency/fitOrder/fitOrderList_table";
	}

	/**
	 * 跳转到加入团列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param tourGroup
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "getInsertFitGroupList.htm")
	public String getInsertFitGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, TourGroup tourGroup,
			Integer tid) throws ParseException {
//		if (tid != null) {
//			GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(tid);
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//			tourGroup.setEndTime(sdf.parse(groupOrder.getDepartureDate()));
//		}
		tourGroup.setGroupMode(0);
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(tourGroup.getPageSize() == null ? Constants.PAGESIZE
				: tourGroup.getPageSize());
		pageBean.setPage(tourGroup.getPage());
		pageBean.setParameter(tourGroup);
//		pageBean = tourGroupService.selectSKGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setPageBean(pageBean);
		pageBean = agencyFitFacade.getInsertFitGroupList(queryDTO);
		model.addAttribute("page", pageBean);
		model.addAttribute("tourGroup", (TourGroup)pageBean.getParameter());
		return "agency/fitOrder/insertFitGroupList";

	}

	/**
	 * 由预留改为确认
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrder
	 * @return
	 */
	@RequestMapping(value = "changeType.do")
	@ResponseBody
	public String changeType(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrder groupOrder) {
//		groupOrderService.updateGroupOrder(groupOrder);
		ResultSupport resultSupport = agencyFitFacade.updateGroupOrder(groupOrder);
		return successJson();
	}

	/**
	 * 删除订单信息(逻辑删)
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delGroupOrder.do")
	@ResponseBody
	public String delGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
//		if (airTicketRequestService.doesOrderhaveRequested(
//				WebUtils.getCurBizId(request), id)) {
//			return errorJson("删除订单前请先取消机票申请。");
//		}
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		groupOrder.setState(-1);
//		groupOrderService.updateGroupOrder(groupOrder);
//
//		try {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//			
//			if(groupOrder.getType()==0){ //预留
//				productStockService.updateReserveCount(groupOrder.getProductId(), sdf.parse(groupOrder.getDepartureDate()),-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
//				
//			}else{
//			
//
//				productStockService.updateStockCount(groupOrder.getProductId(),
//						sdf.parse(groupOrder.getDepartureDate()),
//						-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
//			
//			}
//			
//			
//			
//			
//		} catch (Exception e) {
//			return errorJson("更新库存失败！");
//		}
		ResultSupport resultSupport = agencyFitFacade.delGroupOrder(id, WebUtils.getCurBizId(request));
		return resultSupport.isSuccess() ? successJson() : errorJson(resultSupport.getResultMsg());
	}

	/**
	 * 判断是否满足批量加入团条件--正常散
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "beforeInsertGroup.htm")
	@ResponseBody
	public String beforeInsertGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String ids) {
		String[] split = ids.split(",");
//		List<String> datelist = new ArrayList<String>();
//		for (String id : split) {
//			GroupOrder groupOrder = groupOrderService.findById(Integer
//					.parseInt(id));
//			datelist.add(groupOrder.getDepartureDate());
////			List<GroupOrderGuest> guestList = groupOrderGuestService
////					.selectByOrderId(Integer.parseInt(id));
////			if (guestList == null || guestList.size() == 0) {
////				return errorJson("订单号:" + groupOrder.getOrderNo()
////						+ "无客人信息,无法并团!");
////			}
//
//		}
		AgencyOrderResult result = agencyFitFacade.modifyGroup(split);
		if (!MergeGroupUtils.hasSame(result.getStrList())) {
			return errorJson("发团日期一致的订单才允许加入到团中!");
		}
		return successJson();
	}

	/**
	 * 判断是否满足并团条件--并团页面再次选择订单时用
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "judgeMergeGroup.htm")
	@ResponseBody
	public String judgeMergeGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String ids) {
		String[] split = ids.split(",");
//		List<String> datelist = new ArrayList<String>();
//		List<Integer> productlist = new ArrayList<Integer>();
//		List<Integer> brandlist = new ArrayList<Integer>();
//		List<Integer> statelist = new ArrayList<Integer>();
//		for (String id : split) {
//			GroupOrder groupOrder = groupOrderService.findById(Integer
//					.parseInt(id));
//			datelist.add(groupOrder.getDepartureDate());
//			productlist.add(groupOrder.getProductId());
//			statelist.add(groupOrder.getStateFinance());
//			brandlist.add(groupOrder.getProductBrandId());
////			List<GroupOrderGuest> guestList = groupOrderGuestService
////					.selectByOrderId(Integer.parseInt(id));
////			if (guestList == null || guestList.size() == 0) {
////				return errorJson("订单号:" + groupOrder.getOrderNo()
////						+ "无客人信息,无法并团!");
////			}
//
//		}
		AgencyOrderResult result = agencyFitFacade.modifyGroup(split);
		if (!MergeGroupUtils.hasSame(result.getStrList())) {
			return errorJson("发团日期一致的订单才允许并团!");
		}
		// if (!MergeGroupUtils.hasSame(productlist)) {
		// return errorJson("产品一致的订单才允许并团!");
		// }
		if (!MergeGroupUtils.hasSame(result.getIntList())) {
			return errorJson("产品品牌一致的订单才允许并团!");
		}

		return successJson();
	}

	@RequestMapping(value = "insertGroupMany.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroupMany(HttpServletRequest request,
			HttpServletResponse reponse, String ids, String code) {

//		TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
//		if (tourGroup == null) {
//			return errorJson("未查到该团号对应的散客团信息!");
//		}
		String[] split = ids.split(",");
//		for (String str : split) {
//			GroupOrder groupOrder = groupOrderService
//					.selectByPrimaryKey(Integer.parseInt(str));
//			groupOrder.setGroupId(tourGroup.getId());
//			groupOrder.setOperatorId(WebUtils.getCurUserId(request));
//			groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
//			groupOrderService.updateGroupOrder(groupOrder);
//			tourGroup.setOrderNum(tourGroup.getOrderNum() == null ? 1
//					: tourGroup.getOrderNum() + 1);
//			tourGroupService.updateByPrimaryKey(tourGroup);
//			groupOrderService.updateGroupPersonNum(tourGroup.getId());
//			groupOrderService.updateGroupPrice(tourGroup.getId());
//
//			List<GroupRequirement> list = groupRequirementService
//					.selectByOrderId(Integer.parseInt(str));
//			if (list != null && list.size() > 0) {
//				for (GroupRequirement groupRequirement : list) {
//					groupRequirement.setGroupId(tourGroup.getId());
//					groupRequirementService
//							.updateByPrimaryKeySelective(groupRequirement);
//				}
//			}
//		}
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setUserId(WebUtils.getCurUserId(request));
		queryDTO.setUserName(WebUtils.getCurUser(request).getName());
		queryDTO.setIdArr(split);
		ResultSupport resultSupport = agencyFitFacade.insertGroupMany(queryDTO);
		return resultSupport.isSuccess() ? successJson():errorJson(resultSupport.getResultMsg());
	}

	@RequestMapping(value = "insertGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroup(HttpServletRequest request,
			HttpServletResponse reponse, Integer id, String code) {

//		TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
//		if (tourGroup == null) {
//			return errorJson("未查到该团号对应的散客团信息!");
//		}
//		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(id);
//		groupOrder.setGroupId(tourGroup.getId());
//		groupOrder.setOperatorId(tourGroup.getOperatorId());
//		groupOrder.setOperatorName(tourGroup.getOperatorName());
//		groupOrderService.updateGroupOrder(groupOrder);
//		tourGroup.setOrderNum(tourGroup.getOrderNum() == null ? 1 : tourGroup
//				.getOrderNum() + 1);
//		tourGroupService.updateByPrimaryKey(tourGroup);
//		groupOrderService.updateGroupPersonNum(tourGroup.getId());
//		groupOrderService.updateGroupPrice(tourGroup.getId());
//
//		List<GroupRequirement> list = groupRequirementService
//				.selectByOrderId(id);
//		if (list != null && list.size() > 0) {
//			for (GroupRequirement groupRequirement : list) {
//				groupRequirement.setGroupId(tourGroup.getId());
//				groupRequirementService
//						.updateByPrimaryKeySelective(groupRequirement);
//			}
//		}

//		return successJson();
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setUserId(WebUtils.getCurUserId(request));
		queryDTO.setUserName(WebUtils.getCurUser(request).getName());
		String[] idArr = {id+""};
		queryDTO.setIdArr(idArr);
		ResultSupport resultSupport = agencyFitFacade.insertGroupMany(queryDTO);
		return resultSupport.isSuccess() ? successJson():errorJson(resultSupport.getResultMsg());
	}

	/**
	 * 跳转到并团页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "toMergeGroup.htm")
	public String toMergeGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String ids) {
//		List<GroupOrder> list = new ArrayList<GroupOrder>();
		String[] split = ids.split(",");
//		for (String str : split) {
//			GroupOrder groupOrder = groupOrderService.findById(Integer
//					.parseInt(str));
//			groupOrder.setGroupOrderGuestList((groupOrderGuestService
//					.selectByOrderId(groupOrder.getId())));
//			list.add(groupOrder);
//		}
		List<GroupOrder> list = agencyFitFacade.toMergeGroup(split);
		model.addAttribute("list", list);
		model.addAttribute("ids", ids);
		return "agency/fitOrder/mergeGroup";
	}

	/**
	 * 并团
	 * 
	 * @param request
	 * @param reponse
	 * @param mergeGroupOrderVO
	 * @return
	 * @throws ParseException
	 */
	//TODO 逻辑有问题
	@RequestMapping(value = "mergeGroup.do")
	@ResponseBody
	public String mergeGroup(HttpServletRequest request,
			HttpServletResponse reponse, MergeGroupOrderVO mergeGroupOrderVO)
			throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		List<GroupOrder> orderList = mergeGroupOrderVO.getOrderList();

		List<MergeGroupOrderVO> result = new ArrayList<MergeGroupOrderVO>();
//		for (int i = 0; i < orderList.size();) {
//			GroupOrder order = orderList.get(i);
//			GroupOrder groupOrder = groupOrderService.findById(order.getId());
//			groupOrder.setGroupCode(order.getGroupCode());
//			orderList.remove(order);
//			MergeGroupOrderVO mov = new MergeGroupOrderVO();
//			mov.getOrderList().add(groupOrder);
//
//			for (int j = 0; j < orderList.size();) {
//				GroupOrder order2 = orderList.get(j);
//				GroupOrder go = groupOrderService.findById(order2.getId());
//				go.setGroupCode(order2.getGroupCode());
//				// 相同，分组，并加入到组容器集合
//				if (go.getGroupCode().equals(groupOrder.getGroupCode())) {
//					mov.getOrderList().add(go);
//					orderList.remove(order2);
//				} else {
//					j++;
//				}
//			}
//			result.add(mov);
//		}
		
//		for (MergeGroupOrderVO mgo : result) {
//			List<GroupOrder> oList = mergeGroupOrderVO.getOrderList();
//			Integer orderId = null;
//			Integer dayNum = null;
//			// 设置订单
//			for (GroupOrder go2 : orderList) {
//				List<GroupRoute> rouList = groupRouteService.selectByOrderId(go2.getId());
//				if (rouList != null && rouList.size() > 0) {
//
//					if (orderId == null) {
//						orderId = go2.getId();
//					}
//					if (dayNum == null) {
//						dayNum = rouList.size();
//					}
//					if (rouList.size() > dayNum) {
//						dayNum = rouList.size();
//						orderId = go2.getId();
//					}
//				}
//			}
//			
//			GroupOrder key = groupOrderService.selectByPrimaryKey(orderId);
//			ProductInfo productInfo = productInfoService.findProductInfoById(key.getProductId());
//			mgo.setProductCode(productInfo.getCode());
//		}
//		// -------------------------------------------------------------------------------
//
//		fitOrderService.mergetGroup(result, WebUtils.getCurBizId(request),
//				WebUtils.getCurUserId(request), WebUtils.getCurUser(request)
//						.getName(), settingCommon.getMyBizCode(request),true);
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setBizCode(settingCommon.getMyBizCode(request));
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setUserId(WebUtils.getCurUserId(request));
		queryDTO.setUserName(WebUtils.getCurUser(request).getName());
		queryDTO.setMergeGroupOrderVOs(result);
		ResultSupport resultSupport = agencyFitFacade.mergeGroup(queryDTO, mergeGroupOrderVO);
		return successJson();
	}

	/**
	 * 跳转到并团新增订单列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 */
	@RequestMapping(value = "toImpNotGroupList.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String toImpNotGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder,
			String idLists) {
		if (null == groupOrder.getEndTime()
				&& null == groupOrder.getDepartureDate()) {
			Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1);
			groupOrder.setDepartureDate(c.get(Calendar.YEAR) + "-"
					+ (c.get(Calendar.MONTH) + 1) + "-01");
			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			groupOrder.setEndTime(c.get(Calendar.YEAR) + "-"
					+ (c.get(Calendar.MONTH) + 1) + "-" + c.get(Calendar.DATE));

		}
		model.addAttribute("idLists", idLists);
		String[] split = idLists.split(",");
		List<Integer> intIds = new ArrayList<Integer>();
		for (String id : split) {
			intIds.add(Integer.parseInt(id));
		}
		groupOrder.setIdList(intIds);
		groupOrder.setDateType(1);
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage() == null ? 1 : groupOrder
				.getPage());
		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectNotGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
		pageBean = agencyFitFacade.toImpNotGroupList(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
//		List<GroupOrder> result = pageBean.getResult();
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult pp = productCommonFacade.brandQuery(brandQueryDTO);
		model.addAttribute("pp", pp.getBrandList());
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("page", pageBean);
		return "agency/fitOrder/impNotGroupOrder";
	}

	/**
	 * 删除订单信息(逻辑删) 操作单版
	 *    用于散客团的删除，需要还库存
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delYmgGroupOrder.do")
	@ResponseBody
	public String delYmgGroupOrder(HttpServletRequest request,
								   HttpServletResponse reponse, Integer id) {
//		if (airTicketRequestService.doesOrderhaveRequested(
//				WebUtils.getCurBizId(request), id)) {
//			return errorJson("删除订单前请先取消机票申请。");
//		}
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		groupOrder.setState(-1);
//		groupOrderService.updateGroupOrder(groupOrder);
//
//		try {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//			if(groupOrder.getType()==0){ //预留
//				productStockService.updateReserveCount(groupOrder.getProductId(), sdf.parse(groupOrder.getDepartureDate()),-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
//
//			}else{
//
//
//				productStockService.updateStockCount(groupOrder.getProductId(),
//						sdf.parse(groupOrder.getDepartureDate()),
//						-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
//
//			}
//			if(groupOrder.getGroupId()!=null){    									// 判断是否成团，团中有无订单，若无订单删除团。
//				List<GroupOrder> list =groupOrderService.selectSubOrderList(groupOrder.getGroupId());
//				if(list==null || list.size()<1){
//					TourGroup tourGroup=tourGroupService.selectByPrimaryKey(groupOrder.getGroupId());
//					tourGroup.setGroupState(-1);
//					tourGroupService.updateByPrimaryKeySelective(tourGroup);
//				}
//				financeService.calcTourGroupAmount(groupOrder.getGroupId());
//			}
//		} catch (Exception e) {
//			return errorJson("更新库存失败！");
//		}
		ResultSupport resultSupport = agencyFitFacade.delYmgGroupOrder(WebUtils.getCurBizId(request),id);
		if (!resultSupport.isSuccess()) {
			return  errorJson(resultSupport.getResultMsg());
		}
		return successJson();
	}


}
