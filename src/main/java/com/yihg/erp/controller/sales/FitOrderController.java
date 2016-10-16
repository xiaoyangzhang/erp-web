package com.yihg.erp.controller.sales;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.ErrorManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.yihg.airticket.api.AirTicketRequestService;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.exception.ClientException;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.common.MergeGroupUtils;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.product.api.ProductGroupExtraItemService;
import com.yihg.product.api.ProductGroupPriceService;
import com.yihg.product.api.ProductGroupService;
import com.yihg.product.api.ProductGroupSupplierService;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductRemarkService;
import com.yihg.product.api.ProductRouteService;
import com.yihg.product.api.ProductStockService;
import com.yihg.product.po.ProductAttachment;
import com.yihg.product.po.ProductGroup;
import com.yihg.product.po.ProductGroupExtraItem;
import com.yihg.product.po.ProductGroupPrice;
import com.yihg.product.po.ProductGroupSupplier;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.ProductRemark;
import com.yihg.product.po.ProductRoute;
import com.yihg.product.po.ProductRouteSupplier;
import com.yihg.product.po.ProductRouteTraffic;
import com.yihg.product.po.ProductStock;
import com.yihg.product.vo.ProductGroupSupplierVo;
import com.yihg.product.vo.ProductGroupVo;
import com.yihg.product.vo.ProductRouteDayVo;
import com.yihg.product.vo.ProductRouteVo;
import com.yihg.product.vo.ProductSupplierCondition;
import com.yihg.sales.api.FitOrderService;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.GroupRequirementService;
import com.yihg.sales.api.SpecialGroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupRequirement;
import com.yihg.sales.po.GroupRoute;
import com.yihg.sales.po.GroupRouteAttachment;
import com.yihg.sales.po.GroupRouteSupplier;
import com.yihg.sales.po.GroupRouteTraffic;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.FitOrderVO;
import com.yihg.sales.vo.GroupRouteDayVO;
import com.yihg.sales.vo.GroupRouteVO;
import com.yihg.sales.vo.MergeGroupOrderVO;
import com.yihg.supplier.constants.Constants;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.po.PlatformEmployeePo;

@Controller
@RequestMapping(value = "/fitOrder")
public class FitOrderController extends BaseController {
	@Autowired
	private GroupOrderService groupOrderService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private GroupOrderGuestService groupOrderGuestService;
	@Autowired
	private DicService dicService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private ProductGroupSupplierService productGroupSupplierService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private ProductGroupService productGroupService;
	@Autowired
	private SpecialGroupOrderService specialGroupOrderService;
	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private ProductGroupPriceService productGroupPriceService;
	@Autowired
	private GroupRequirementService groupRequirementService;
	@Autowired
	private ProductRemarkService productRemarkService;
	@Autowired
	private ProductRouteService productRouteService;
	@Autowired
	private ProductInfoService productInfoService;
	@Autowired
	private ProductStockService productStockService;
	@Autowired
	private ProductGroupExtraItemService productGroupExtraItemService;
	@Autowired
	private FitOrderService fitOrderService;
	@Autowired
	private AirTicketRequestService airTicketRequestService;
	@Autowired
	private BookingSupplierService bookingSupplierService ;
	@Autowired
	private BizSettingCommon bizSettingCommon;
	@RequestMapping(value = "getGroupPirceData.do", method = RequestMethod.GET)
	@ResponseBody
	public String getGroupPirceData(Integer productId, Integer supplierId,
			Date date) {
		List<ProductGroupVo> priceGroup = productGroupService
				.selectGroupsByProdctIdAndSupplierId(productId, supplierId,
						date);
		Gson gson = new Gson();
		String string = gson.toJson(priceGroup);
		return string;
	}

	@RequestMapping(value = "toAddGroupOrder.htm", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String toAddGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer productId,
			Date date) {

		model.addAttribute("operType", 1);
		model.addAttribute("editType", true);
		model.addAttribute("config", config);
		List<ProductGroupSupplier> supplierList = productGroupSupplierService
				.selectProductGroupSuppliers2(productId); // 获取价格下的组团社列表

		model.addAttribute("supplierList", supplierList);
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		model.addAttribute("curUser", curUser);
		ProductRemark productRemark = productRemarkService
				.findProductRemarkByProductId(productId);
		ProductInfo productInfo = productInfoService
				.findProductInfoById(productId);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		FitOrderVO vo = new FitOrderVO();
		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setSaleOperatorId(curUser.getEmployeeId());
		groupOrder.setSaleOperatorName(curUser.getName());
		groupOrder.setOperatorId(curUser.getEmployeeId());
		groupOrder.setOperatorName(curUser.getName());
		groupOrder.setRemark(productRemark.getRemarkInfo());
		groupOrder.setServiceStandard(productRemark.getServeLevel());
		groupOrder.setProductBrandId(productInfo.getBrandId());
		groupOrder.setProductBrandName(productInfo.getBrandName());
		groupOrder.setProductId(productInfo.getId());
		groupOrder.setProductName(productInfo.getNameCity());
		groupOrder.setDepartureDate(sdf.format(date));
		vo.setGroupOrder(groupOrder);
		model.addAttribute("vo", vo);
		int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),date);
		model.addAttribute("allowNum", count); // 库存

		int bizId = WebUtils.getCurBizId(request);
		
		model.addAttribute("productId", productId);
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);

		DicInfo dicInfoCR = dicService.getDicInfoByTypeCodeAndDicCode(
				WebUtils.getCurBizId(request), BasicConstants.GYXX_LYSFXM,
				BasicConstants.CR);
		DicInfo dicInfoET = dicService.getDicInfoByTypeCodeAndDicCode(
				WebUtils.getCurBizId(request), BasicConstants.GYXX_LYSFXM,
				BasicConstants.ERT);

		List<DicInfo> dicInfoCRList = new ArrayList<DicInfo>();
		dicInfoCRList.add(dicInfoCR);
		List<DicInfo> dicInfoETList = new ArrayList<DicInfo>();
		dicInfoETList.add(dicInfoET);
		model.addAttribute("dicInfoCRList", dicInfoCRList);
		model.addAttribute("dicInfoETList", dicInfoETList);

		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);

		return "sales/fitOrder/fitOrderInfo";
	}

	@RequestMapping(value = "toEditFirOrder.htm")
	public String toEditFirOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer orderId,
			Integer operType) throws ParseException {
		FitOrderVO vo = fitOrderService.selectFitOrderVOById(orderId);
		
		model.addAttribute("vo", vo);
		model.addAttribute("operType", operType);
		model.addAttribute("config", config);
		model.addAttribute("editType", false);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		GroupOrder groupOrder = groupOrderService.findById(orderId);
		int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),sdf.parse(groupOrder.getDepartureDate()));
		model.addAttribute("allowNum", count); // 库存

		int bizId = WebUtils.getCurBizId(request);
		
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		List<RegionInfo> cityList = null;
		if (groupOrder.getProvinceId() != null
				&& groupOrder.getProvinceId() != -1) {
			cityList = regionService.getRegionById(groupOrder.getProvinceId()
					+ "");
		}
		model.addAttribute("allCity", cityList);
		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		return "sales/fitOrder/fitOrderInfo";
	}

	@RequestMapping(value = "saveFitOrderInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveFitOrderInfo(HttpServletRequest request,
			FitOrderVO fitOrderVO) throws ParseException {
		Integer orderId;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Integer newNum = fitOrderVO.getGroupOrder().getNumAdult()
				+ fitOrderVO.getGroupOrder().getNumChild();
		Integer oldNum = 0;
		try {
			if (fitOrderVO.getGroupOrder().getId() != null) {
				FitOrderVO vo = fitOrderService.selectFitOrderVOById(fitOrderVO
						.getGroupOrder().getId());

				oldNum = vo.getGroupOrder().getNumAdult()
						+ vo.getGroupOrder().getNumChild();
			}
			
			
			//查出库存(剩余人数)
			int freeCount = productStockService.getRestCountByProductIdAndDate(fitOrderVO
					.getGroupOrder().getProductId(),sdf.parse(fitOrderVO
							.getGroupOrder().getDepartureDate()));
			//实际库存应该是修改前人数+库存
			freeCount = oldNum + freeCount;
			if(newNum > freeCount){
				//如果新增人数大于库存,则不能保存
				return errorJson("由于库存剩余数有变化，目前剩余库存不足【" + newNum + "】！实际库存还有【" + freeCount + "】");
			}
			
			
			fitOrderVO.getGroupOrder().setOrderNo(
					settingCommon.getMyBizCode(request));
			String bizConfigValue = WebUtils.getBizConfigValue(request,
					BizConfigConstant.AUTO_MERGE_ORDER);
			boolean mergeGroup = false;
			if (bizConfigValue != null && "1".equals(bizConfigValue)) {
				mergeGroup = true;
			}
			
			
			ProductInfo productInfo = productInfoService.findProductInfoById(fitOrderVO.getGroupOrder().getProductId());
			
			orderId = fitOrderService.saveOrUpdateFitOrderInfo(fitOrderVO,
					WebUtils.getCurUserId(request), WebUtils
							.getCurUser(request).getName(),productInfo.getOperatorId(),productInfo.getOperatorName(), WebUtils
							.getCurBizId(request), settingCommon
							.getMyBizCode(request), mergeGroup);
		} catch (ParseException e) {
			return errorJson("操作失败,请检查后重试！");
		}
		try {

			productStockService.updateStockCount(fitOrderVO.getGroupOrder()
					.getProductId(), sdf.parse(fitOrderVO.getGroupOrder()
					.getDepartureDate()), newNum - oldNum);
		} catch (Exception e) {
			return errorJson("更新库存失败！");
		}

		return successJson("orderId", orderId + "");
	}

	/**
	 * 跳转到散客订单列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toFitOrderList.htm")
	public String toFitOrderList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "sales/fitOrder/fitOrderList";
	}

	@RequestMapping(value = "getFitOrderListData.do")
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String getFitOrderListData(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder)
			throws ParseException {

		getFitOrdersData(request, model, groupOrder);
		model.addAttribute("orderLockSwitch",BizConfigConstant.ORDER_LOCK_BINGTUAN);
		return "sales/fitOrder/fitOrderList_table";
	}

	private void getFitOrdersData(HttpServletRequest request, ModelMap model,
			GroupOrder groupOrder) throws ParseException {
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
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
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
				groupOrder.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage() == null ? 1 : groupOrder
				.getPage());
		pageBean.setParameter(groupOrder);
		pageBean = groupOrderService.selectFitOrderListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request),0);
		List<GroupOrder> list = pageBean.getResult();
		if (list != null && list.size() > 0) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (GroupOrder groupOrder2 : list) {
				if (groupOrder2.getCreateTime() != null) {
					Long createTime = groupOrder2.getCreateTime();
					String dateStr = sdf.format(createTime);
					groupOrder2.setCreateTimeStr(dateStr);
				}

			}
		}

		GroupOrder order = groupOrderService.selectFitOrderTotalCount(
				groupOrder, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request),0);
		model.addAttribute("page", pageBean);
		model.addAttribute("totalOrder", order);
	}
	/**
	 * 散客订单打印预览
	 * @param request
	 * @param response
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("fitOrdersPreview.htm")
	public String fitOrdersPreview(HttpServletRequest request,HttpServletResponse response,ModelMap model,GroupOrder groupOrder) throws ParseException{
		groupOrder.setPageSize(100000);
		getFitOrdersData(request, model, groupOrder);
		model.addAttribute("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		return "sales/fitOrder/fit-order-print";
		
	}
	/**
	 * 散客团下子订单
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "getSubOrderListData.do")
	public String getSubOrderListData(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId)
			throws ParseException {
		List<GroupOrder> orders = groupOrderService.selectSubOrderList(groupId) ;
		model.addAttribute("orders", orders);
		return "sales/fitGroup/subOrderList";
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
		if (tid != null) {
			GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(tid);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

			tourGroup.setEndTime(sdf.parse(groupOrder.getDepartureDate()));
		}
		tourGroup.setGroupMode(0);
		tourGroup.setContainSealedGroup(false);
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(tourGroup.getPageSize() == null ? Constants.PAGESIZE
				: tourGroup.getPageSize());
		pageBean.setPage(tourGroup.getPage());
		pageBean.setParameter(tourGroup);
		pageBean = tourGroupService.selectSKGroupListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		model.addAttribute("tourGroup", tourGroup);
		return "sales/fitOrder/insertFitGroupList";

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
		if (airTicketRequestService.doesOrderhaveRequested(
				WebUtils.getCurBizId(request), id)) {
			return errorJson("删除订单前请先取消机票申请。");
		}
		GroupOrder groupOrder = groupOrderService.findById(id);

		//2016-6-23 ou 增加是否审核，是否收款检查
		if (groupOrder.getTotalCash() != null){
			int a=groupOrder.getTotalCash().compareTo(BigDecimal.ZERO);
			if (a==1 || a==-1 ){
				return errorJson("订单已经存在收款，不能删除！");}
			}
		if (groupOrder.getStateFinance() != null){
			Integer initState = 1;
			if (groupOrder.getStateFinance().equals(initState) ){
				return errorJson("订单已经审核，不能删除！");
			}
		}
		groupOrder.setState(-1);
		
		groupOrderService.updateGroupOrder(groupOrder);
		if (groupOrder.getPriceId() != null) {
			boolean updateStock = productGroupPriceService.updateStock(
					groupOrder.getPriceId(), groupOrder.getSupplierId(),
					-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
		} else {
			try {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				productStockService.updateStockCount(groupOrder.getProductId(),
						sdf.parse(groupOrder.getDepartureDate()),
						-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
			} catch (Exception e) {
				return errorJson("更新库存失败！");
			}
		}
		
		bookingSupplierService.upateGroupIdAfterDelOrderFromGroup(id);

		return successJson();
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
		List<String> datelist = new ArrayList<String>();
		for (String id : split) {
			GroupOrder groupOrder = groupOrderService.findById(Integer
					.parseInt(id));
			datelist.add(groupOrder.getDepartureDate());
//			List<GroupOrderGuest> guestList = groupOrderGuestService
//					.selectByOrderId(Integer.parseInt(id));
//			if (guestList == null || guestList.size() == 0) {
//				return errorJson("订单号:" + groupOrder.getOrderNo()
//						+ "无客人信息,无法并团!");
//			}

		}

		if (!MergeGroupUtils.hasSame(datelist)) {
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
		List<String> datelist = new ArrayList<String>();
		List<Integer> productlist = new ArrayList<Integer>();
		List<Integer> brandlist = new ArrayList<Integer>();
		List<Integer> statelist = new ArrayList<Integer>();
		for (String id : split) {
			GroupOrder groupOrder = groupOrderService.findById(Integer
					.parseInt(id));
			datelist.add(groupOrder.getDepartureDate());
			productlist.add(groupOrder.getProductId());
			statelist.add(groupOrder.getStateFinance());
			brandlist.add(groupOrder.getProductBrandId());
//			List<GroupOrderGuest> guestList = groupOrderGuestService
//					.selectByOrderId(Integer.parseInt(id));
//			if (guestList == null || guestList.size() == 0) {
//				return errorJson("订单号:" + groupOrder.getOrderNo()
//						+ "无客人信息,无法并团!");
//			}

		}

		if (!MergeGroupUtils.hasSame(datelist)) {
			return errorJson("发团日期一致的订单才允许并团!");
		}
		// if (!MergeGroupUtils.hasSame(productlist)) {
		// return errorJson("产品一致的订单才允许并团!");
		// }
		if (!MergeGroupUtils.hasSame(brandlist)) {
			return errorJson("产品品牌一致的订单才允许并团!");
		}

		return successJson();
	}

	@RequestMapping(value = "insertGroupMany.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroupMany(HttpServletRequest request,
			HttpServletResponse reponse, String ids, String code) {

		TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
		if (tourGroup == null) {
			return errorJson("未查到该团号对应的散客团信息!");
		}
		String[] split = ids.split(",");
		for (String str : split) {
			GroupOrder groupOrder = groupOrderService
					.selectByPrimaryKey(Integer.parseInt(str));
			groupOrder.setGroupId(tourGroup.getId());
			groupOrder.setOperatorId(tourGroup.getOperatorId());
			groupOrder.setOperatorName(tourGroup.getOperatorName());
			groupOrderService.updateGroupOrder(groupOrder);
			tourGroup.setOrderNum(tourGroup.getOrderNum() == null ? 1
					: tourGroup.getOrderNum() + 1);
			tourGroupService.updateByPrimaryKey(tourGroup);
			groupOrderService.updateGroupPersonNum(tourGroup.getId());
			groupOrderService.updateGroupPrice(tourGroup.getId());

			List<GroupRequirement> list = groupRequirementService
					.selectByOrderId(Integer.parseInt(str));
			if (list != null && list.size() > 0) {
				for (GroupRequirement groupRequirement : list) {
					groupRequirement.setGroupId(tourGroup.getId());
					groupRequirementService
							.updateByPrimaryKeySelective(groupRequirement);
				}
			}
			
			bookingSupplierService.updateGroupIdByOrderId(tourGroup.getId(), groupOrder.getId());
		}
		return successJson();
	}

	@RequestMapping(value = "insertGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroup(HttpServletRequest request,
			HttpServletResponse reponse, Integer id, String code) {

		TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
		if (tourGroup == null) {
			return errorJson("未查到该团号对应的散客团信息!");
		}
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(id);
		groupOrder.setGroupId(tourGroup.getId());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		groupOrderService.updateGroupOrder(groupOrder);
		tourGroup.setOrderNum(tourGroup.getOrderNum() == null ? 1 : tourGroup
				.getOrderNum() + 1);
		tourGroupService.updateByPrimaryKey(tourGroup);
		groupOrderService.updateGroupPersonNum(tourGroup.getId());
		groupOrderService.updateGroupPrice(tourGroup.getId());
		
		List<GroupRequirement> list = groupRequirementService
				.selectByOrderId(id);
		if (list != null && list.size() > 0) {
			for (GroupRequirement groupRequirement : list) {
				groupRequirement.setGroupId(tourGroup.getId());
				groupRequirementService
						.updateByPrimaryKeySelective(groupRequirement);
			}
		}
		
		bookingSupplierService.updateGroupIdByOrderId(tourGroup.getId(), id);

		return successJson();
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
		List<GroupOrder> list = new ArrayList<GroupOrder>();
		String[] split = ids.split(",");
		for (String str : split) {
			GroupOrder groupOrder = groupOrderService.findById(Integer
					.parseInt(str));
			groupOrder.setGroupOrderGuestList((groupOrderGuestService
					.selectByOrderId(groupOrder.getId())));
			list.add(groupOrder);
		}
		model.addAttribute("list", list);
		model.addAttribute("ids", ids);
		return "sales/fitOrder/mergeGroup";
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
	@RequestMapping(value = "mergeGroup.do")
	@ResponseBody
	public String mergeGroup(HttpServletRequest request,
			HttpServletResponse reponse, MergeGroupOrderVO mergeGroupOrderVO)
			throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		List<GroupOrder> orderList = mergeGroupOrderVO.getOrderList();

		List<MergeGroupOrderVO> result = new ArrayList<MergeGroupOrderVO>();
		for (int i = 0; i < orderList.size();) {
			GroupOrder order = orderList.get(i);
			GroupOrder groupOrder = groupOrderService.findById(order.getId());
			groupOrder.setGroupCode(order.getGroupCode());
			orderList.remove(order);
			MergeGroupOrderVO mov = new MergeGroupOrderVO();
			mov.getOrderList().add(groupOrder);

			for (int j = 0; j < orderList.size();) {
				GroupOrder order2 = orderList.get(j);
				GroupOrder go = groupOrderService.findById(order2.getId());
				go.setGroupCode(order2.getGroupCode());
				// 相同，分组，并加入到组容器集合
				if (go.getGroupCode().equals(groupOrder.getGroupCode())) {
					mov.getOrderList().add(go);
					orderList.remove(order2);
				} else {
					j++;
				}
			}
			result.add(mov);
		}
		// -------------------------------------------------------------------------------
		fitOrderService.mergetGroup(result, WebUtils.getCurBizId(request),
				mergeGroupOrderVO.getChoseOperator(), mergeGroupOrderVO.getChoseOperatorName(), settingCommon.getMyBizCode(request),false);

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
		pageBean = groupOrderService.selectNotGroupListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		List<GroupOrder> result = pageBean.getResult();
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("page", pageBean);
		return "sales/fitOrder/impNotGroupOrder";
	}
	
	/**
	 * 跳转到编辑接送信息页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param orderId
	 * @param operType
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "toEditTransportInfo.htm", method = RequestMethod.GET)
	public String toEditTransportInfo(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer orderId,
			Integer operType) throws ParseException {
		FitOrderVO vo = fitOrderService.selectFitOrderVOById(orderId);
		model.addAttribute("vo", vo);
		model.addAttribute("operType", operType);
		model.addAttribute("config", config);
		model.addAttribute("editType", false);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		GroupOrder groupOrder = groupOrderService.findById(orderId);
		int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),sdf.parse(groupOrder.getDepartureDate()));
		model.addAttribute("allowNum", count); // 库存

		int bizId = WebUtils.getCurBizId(request);
		
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		List<RegionInfo> cityList = null;
		if (groupOrder.getProvinceId() != null
				&& groupOrder.getProvinceId() != -1) {
			cityList = regionService.getRegionById(groupOrder.getProvinceId()
					+ "");
		}
		model.addAttribute("allCity", cityList);
		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		return "sales/fitOrder/transportInfo";
	}
	
	@RequestMapping(value = "saveTransportInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveTransportInfo(HttpServletRequest request, FitOrderVO fitOrderVO) throws ParseException {
		try {
			fitOrderService.saveTransportInfo(fitOrderVO);
		} catch (Exception e) {
			return errorJson("操作失败,请检查后重试！");
		}
		return successJson();
	}
	
	/**
	 * 跳转到编辑接送信息页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param orderId
	 * @param operType
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "toEditGuestInfo.htm", method = RequestMethod.GET)
	public String toEditGuestInfo(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer orderId,
			Integer operType) throws ParseException {
		FitOrderVO vo = fitOrderService.selectFitOrderVOById(orderId);
		model.addAttribute("vo", vo);
		model.addAttribute("operType", operType);
		model.addAttribute("config", config);
		model.addAttribute("editType", false);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		GroupOrder groupOrder = groupOrderService.findById(orderId);
		int count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),sdf.parse(groupOrder.getDepartureDate()));
		model.addAttribute("allowNum", count); // 库存

		int bizId = WebUtils.getCurBizId(request);
		
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		List<RegionInfo> cityList = null;
		if (groupOrder.getProvinceId() != null
				&& groupOrder.getProvinceId() != -1) {
			cityList = regionService.getRegionById(groupOrder.getProvinceId()
					+ "");
		}
		model.addAttribute("allCity", cityList);
		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		return "sales/fitOrder/guestInfo";
	}
	
	@RequestMapping(value = "saveGuestInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGuestInfo(HttpServletRequest request, FitOrderVO fitOrderVO) throws ParseException {
		try {
			fitOrderService.saveGuestInfo(fitOrderVO);
		} catch (Exception e) {
			return errorJson("操作失败,请检查后重试！");
		}
		return successJson();
	}

}
