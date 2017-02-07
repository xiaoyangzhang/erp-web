package com.yihg.erp.controller.sales;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sys.po.PlatformOrgPo;
import com.yimayhd.erpcenter.facade.sales.query.grouporder.*;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.grouporder.*;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
//import com.yihg.airticket.api.AirTicketRequestService;
//import com.yihg.basic.api.DicService;
//import com.yihg.basic.api.RegionService;
//import com.yihg.basic.contants.BasicConstants;
//import com.yihg.basic.po.DicInfo;
//import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupPrice;
//import com.yihg.finance.po.FinanceCommission;
//import com.yihg.mybatis.utility.PageBean;
//import com.yihg.operation.api.BookingDeliveryService;
//import com.yihg.operation.api.BookingGuideService;
//import com.yihg.operation.api.BookingShopService;
//import com.yihg.operation.api.BookingSupplierDetailService;
//import com.yihg.operation.api.BookingSupplierService;
//import com.yihg.operation.po.BookingDelivery;
//import com.yihg.operation.po.BookingGuide;
//import com.yihg.operation.po.BookingShop;
//import com.yihg.operation.po.BookingSupplier;
//import com.yihg.operation.po.BookingSupplierDetail;
//import com.yihg.product.api.ProductGroupExtraItemService;
//import com.yihg.product.api.ProductGroupPriceService;
//import com.yihg.product.api.ProductGroupService;
//import com.yihg.product.api.ProductGroupSupplierService;
//import com.yihg.product.api.ProductInfoService;
//import com.yihg.product.api.ProductRemarkService;
//import com.yihg.product.api.ProductRouteService;
//import com.yihg.product.po.ProductAttachment;
//import com.yihg.product.po.ProductGroup;
//import com.yihg.product.po.ProductGroupExtraItem;
//import com.yihg.product.po.ProductGroupPrice;
//import com.yihg.product.po.ProductInfo;
//import com.yihg.product.po.ProductRemark;
//import com.yihg.product.po.ProductRoute;
//import com.yihg.product.po.ProductRouteSupplier;
//import com.yihg.product.po.ProductRouteTraffic;
//import com.yihg.product.vo.ProductGroupSupplierVo;
//import com.yihg.product.vo.ProductRouteDayVo;
//import com.yihg.product.vo.ProductRouteVo;
//import com.yihg.sales.api.GroupOrderGuestService;
//import com.yihg.sales.api.GroupOrderPriceService;
//import com.yihg.sales.api.GroupOrderService;
//import com.yihg.sales.api.GroupOrderTransportService;
//import com.yihg.sales.api.GroupRequirementService;
//import com.yihg.sales.api.GroupRouteService;
//import com.yihg.sales.api.TourGroupService;
//import com.yihg.sales.po.GroupGuidePrintPo;
//import com.yihg.sales.po.GroupOrderGuest;
//import com.yihg.sales.po.GroupOrderPrice;
//import com.yihg.sales.po.GroupOrderPrintPo;
//import com.yihg.sales.po.GroupOrderTransport;
//import com.yihg.sales.po.GroupRequirement;
//import com.yihg.sales.po.GroupRoute;
//import com.yihg.sales.po.GroupRouteAttachment;
//import com.yihg.sales.po.GroupRouteSupplier;
//import com.yihg.sales.po.GroupRouteTraffic;
//import com.yihg.sales.po.TourGroup;
//import com.yihg.sales.vo.GroupOrderPriceVO;
//import com.yihg.sales.vo.GroupOrderVO;
//import com.yihg.sales.vo.GroupRouteDayVO;
//import com.yihg.sales.vo.GroupRouteVO;
//import com.yihg.sales.vo.MergeGroupOrderVO;
//import com.yihg.sales.vo.SalePrice;
//import com.yihg.sales.vo.TransportVO;
//import com.yihg.supplier.api.SupplierGuideService;
//import com.yihg.supplier.api.SupplierService;
//import com.yihg.supplier.constants.Constants;
//import com.yihg.supplier.po.SupplierContactMan;
//import com.yihg.supplier.po.SupplierGuide;
//import com.yihg.supplier.po.SupplierInfo;
//import com.yihg.sys.api.PlatformOrgService;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrice;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrintPo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRequirement;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupOrderPriceVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.MergeGroupOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SalePrice;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TransportVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.sales.result.BaseStateResult;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade;

@Controller
@RequestMapping(value = "/groupOrder")
public class GroupOrderController extends BaseController {
	
	//private static final Logger log = LoggerFactory.getLogger(GroupOrderController.class);

//	@Autowired
//	private SupplierGuideService guideService;
//	@Autowired
//	private DicService dicService;
//	@Autowired
//	private RegionService regionService;
//	@Autowired
//	private GroupOrderService groupOrderService;
//	@Autowired
//	private GroupOrderGuestService groupOrderGuestService;
//	@Autowired
//	private GroupOrderPriceService groupOrderPriceService;
//	@Autowired
//	private GroupOrderTransportService groupOrderTransportService;
//	@Autowired
//	private GroupRequirementService groupRequirementService;
//	@Autowired
//	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
////	private PlatformEmployeeService platformEmployeeService;
//	@Autowired
//	private SupplierService supplierService;
//	@Autowired
//	private ProductInfoService productInfoService;
//	@Autowired
//	private ProductGroupService productGroupService;
//	@Autowired
//	private ProductGroupExtraItemService productGroupExtraItemService;
//
//	@Autowired
//	private ProductGroupPriceService productGroupPriceService;
//	@Autowired
//	private ProductRouteService productRouteService;
//	@Autowired
//	private GroupRouteService groupRouteService;
//	@Autowired
//	private TourGroupService tourGroupService;
//	@Autowired
//	private SysConfig config;
//	@Autowired
//	private PlatformOrgService orgService;
//	@Autowired
//	private ProductRemarkService productRemarkService;
//	@Autowired
//	private ProductGroupSupplierService productGroupSupplierService;
//	@Autowired
//	private BookingGuideService bookingGuideService;
//	
//	//两个service，名称不同
//	@Autowired
//	private BookingSupplierDetailService bookingSupplierDetailService;
//
	//FIXME 特殊暂放
	@Autowired
	private BizSettingCommon settingCommon;
//
//	@Autowired
//	private BizSettingCommon bizSettingCommon;
//	@Autowired
//	private BookingDeliveryService deliveryService;
//
//	@Autowired
//	private GroupRouteService routeService;
//
//	@Autowired
//	private BookingShopService shopService;
//
//	@Autowired
//	private BookingSupplierService bookingSupplierService;
//	@Autowired
//	private BookingSupplierDetailService detailService;
//	@Autowired
//	private AirTicketRequestService airTicketRequestService ;
//	
//	@Autowired
//	private SupplierService supplierInfoService;
	
	@Autowired
	private GroupOrderFacade groupOrderFacade;

	/**
	 * 散客订单、订单日志页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "toFitList.htm")
	public String toFitList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder)
			throws ParseException {
		return "sales/fitOrder/fitList";
	}
	
	/**
	 * 日志详细
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "getFitOrderListData.do")
	public String getFitOrderListData(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder)
			throws ParseException {
//		if(null==groupOrder.getTourGroup()){
//			TourGroup tourGroup = new TourGroup() ;
//			groupOrder.setTourGroup(tourGroup);
//		}
//		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
//		pageBean.setPageSize(1000);
//		pageBean.setPage(1);
//		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectProductOrderListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		model.addAttribute("page", pageBean);
//		return "sales/fitOrder/productOrdersDetail";
		
		GetFitOrderListDataDTO getFitOrderListDataDTO=new GetFitOrderListDataDTO();
		getFitOrderListDataDTO.setCurBizId(WebUtils.getCurBizId(request));
		getFitOrderListDataDTO.setGroupOrder(groupOrder);
		getFitOrderListDataDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		GetFitOrderListDataResult result=groupOrderFacade.getFitOrderListData(getFitOrderListDataDTO);
		model.addAttribute("page", result.getPageBean());
		
		return "sales/fitOrder/productOrdersDetail";
	}
	/**
	 * 订单日志列表
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toProductOrdersList.htm")
	public String toProductOrdersList(HttpServletRequest request, Model model) {
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("allProvince", allProvince);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
//		return "sales/fitOrder/productOrdersList";
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		ToProductOrdersListResult result=groupOrderFacade.toProductOrdersList(bizId);
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("orgJsonStr",result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "sales/fitOrder/productOrdersList";
	}
	
	/**
	 * 订单日志查询分页
	 * @param request
	 * @param model
	 * @param order
	 * @return
	 */
	@RequestMapping(value = "/toProductOrdersTable.htm")
	public String toProductOrdersTable(HttpServletRequest request, Model model,
			GroupOrder order) {
		
//		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
//		pageBean.setPage(order.getPage());
//		pageBean.setPageSize(order.getPageSize() == null ? Constants.PAGESIZE: order.getPageSize());
//		pageBean.setParameter(order);
//		
//		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(order.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(order.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = order.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				order.setSaleOperatorIds(salesOperatorIds.substring(0,
//						salesOperatorIds.length() - 1));
//			}
//		}
//		
//		pageBean = groupOrderService.selectOrderGroupByProductIdListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		
//		GroupOrder go = groupOrderService.selectOrderGroupByProductIdList(pageBean,WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request)) ;
//		if(null!=go){
//			model.addAttribute("totalOrder", go.getTotalOrder());
//			model.addAttribute("totalAdult", go.getTotalAdult());
//			model.addAttribute("totalChild", go.getTotalChild());
//			model.addAttribute("totalSum", go.getTotalSum());
//		}else{
//			model.addAttribute("totalOrder", "");
//			model.addAttribute("totalAdult", "");
//			model.addAttribute("totalChild", "");
//			model.addAttribute("totalSum", "");
//		}
//		
//		model.addAttribute("page", pageBean);
//		model.addAttribute("orders", pageBean.getResult());
		
		ToProductOrdersTableDTO toProductOrdersTableDTO=new ToProductOrdersTableDTO();
		toProductOrdersTableDTO.setCurBizId(WebUtils.getCurBizId(request));
		toProductOrdersTableDTO.setOrder(order);
		toProductOrdersTableDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		ToProductOrdersTableResult result=groupOrderFacade.toProductOrdersTable(toProductOrdersTableDTO);
		
		GroupOrder go=result.getGo();
		if(null!=go){
			model.addAttribute("totalOrder", go.getTotalOrder());
			model.addAttribute("totalAdult", go.getTotalAdult());
			model.addAttribute("totalChild", go.getTotalChild());
			model.addAttribute("totalSum", go.getTotalSum());
		}else{
			model.addAttribute("totalOrder", "");
			model.addAttribute("totalAdult", "");
			model.addAttribute("totalChild", "");
			model.addAttribute("totalSum", "");
		}
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("orders", result.getPageBean().getResult());
		
		return "sales/fitOrder/productOrdersTable";
	}
	
	/**
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param productId
	 * @param priceId
	 *            价格ID
	 * @param groupId
	 *            --价格组ID
	 * @return
	 */
	@RequestMapping(value = "toAddGroupOrder.htm", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String toAddGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer productId,
			Integer groupId, Integer priceId) {
//		model.addAttribute("priceId", priceId);
//		model.addAttribute("groupId", groupId);
//		model.addAttribute("operType", 1);
//		ProductGroupPrice productGroupPrice = productGroupPriceService
//				.selectByPrimaryKey(priceId).getGroupPrice();
//
//		model.addAttribute("allowNum", productGroupPrice.getStockCount()
//				- productGroupPrice.getReceiveCount());
//
//		ProductGroup group = productGroupService.getGroupInfoById(groupId);
//		model.addAttribute("productGroup", group);
//
//		ProductInfo productInfo = productInfoService
//				.findProductInfoById(productId);
//
//		model.addAttribute("productInfo", productInfo);
//
//		ProductRemark productRemark = productRemarkService
//				.findProductRemarkByProductId(productId);
//		model.addAttribute("productRemark", productRemark);
//		List<ProductGroupExtraItem> grouplist = productGroupExtraItemService
//				.findByGroupId(groupId);
//
//		model.addAttribute("grouplist", grouplist);
//		
//		int bizId = WebUtils.getCurBizId(request);
//		
//		ProductGroupPrice groupPrice = productGroupPriceService
//				.selectByPrimaryKey(priceId).getGroupPrice();
//		model.addAttribute("groupPrice", groupPrice);
//		List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
//		model.addAttribute("jdxjList", jdxjList);
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
//		model.addAttribute("jtfsList", jtfsList);
//		List<DicInfo> zjlxList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
//		model.addAttribute("zjlxList", zjlxList);
//		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
//		model.addAttribute("sourceTypeList", sourceTypeList);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//		
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
//				BasicConstants.GYXX_LYSFXM, bizId);
//		model.addAttribute("lysfxmList", lysfxmList);
//		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
//		model.addAttribute("curUser", curUser);
//	
//		
//
//		List<ProductGroupSupplierVo> groupSuppliersList = productGroupSupplierService
//				.selectProductGroupSupplierVos(groupId, priceId);
//		model.addAttribute("groupSuppliersList", groupSuppliersList);
		
		int bizId = WebUtils.getCurBizId(request);
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);

		ToAddGroupOrderResult result= groupOrderFacade.toAddGroupOrder(bizId,productId,groupId,priceId);
		
		model.addAttribute("priceId", priceId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("operType", 1);
		model.addAttribute("curUser", curUser);
		
		model.addAttribute("productInfo", result.getProductInfo());
		model.addAttribute("productGroup", result.getGroup());
		
		ProductGroupPrice productGroupPrice = result.getProductGroupPrice();
		model.addAttribute("allowNum", productGroupPrice.getStockCount()- productGroupPrice.getReceiveCount());
		
		model.addAttribute("productRemark", result.getProductRemark());
		model.addAttribute("grouplist", result.getGrouplist());
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("groupPrice", result.getGroupPrice());
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
		model.addAttribute("groupSuppliersList", result.getGroupSuppliersList());
		model.addAttribute("lysfxmList", result.getLysfxmList());

		return "sales/groupOrder/addGroupOrder";
	}
	
	@RequestMapping("toSalePriceList.htm")
	public String toDeliveryPriceList(HttpServletRequest request,Model model){
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr", sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(BasicConstants.GYXX_LYSFXM, bizId);
//		model.addAttribute("lysfxmList", lysfxmList);
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		ToDeliveryPriceListResult result=groupOrderFacade.toDeliveryPriceList(bizId);
		
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		
		return "/operation/sales/salePriceList" ;
	}
	
	@RequestMapping("toSalePriceTable.htm")
	public String toDeliveryPriceTable(HttpServletRequest request,SalePrice sp,Model model){

//		PageBean<SalePrice> pageBean = new PageBean<SalePrice>() ;
//		pageBean.setPage(sp.getPage());
//		pageBean.setPageSize(sp.getPageSize()==null?Constants.PAGESIZE:sp.getPageSize());
//		if(StringUtils.isBlank(sp.getSaleOperatorIds()) && StringUtils.isNotBlank(sp.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = sp.getOrgIds().toString().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				sp.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
//		pageBean.setParameter(sp);
//		BigDecimal totals = groupOrderService.getSalePriceToalPrice(pageBean,WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request)) ;
//		pageBean = groupOrderService.getSalePriceListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request)) ;
//		model.addAttribute("totals", totals) ;
//		model.addAttribute("page", pageBean) ;
//		model.addAttribute("prices", pageBean.getResult()) ;
	
		ToDeliveryPriceTableDTO toDeliveryPriceTableDTO=new ToDeliveryPriceTableDTO();
		toDeliveryPriceTableDTO.setSp(sp);
		toDeliveryPriceTableDTO.setBizId(WebUtils.getCurBizId(request));
		toDeliveryPriceTableDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		ToDeliveryPriceTableResult result=groupOrderFacade.toDeliveryPriceTable(toDeliveryPriceTableDTO);
		model.addAttribute("totals", result.getTotals()) ;
		model.addAttribute("page", result.getPageBean()) ;
		model.addAttribute("prices", result.getPageBean().getResult()) ;
		
		return "/operation/sales/salePriceTable" ;
	}	
	/**
	 * 更新订单锁单状态
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateOrderLockState.do")
	@ResponseBody
	public String updateOrderLockState(Integer orderId,Integer orderLockState) {
//		int i = groupOrderService.updateOrderLockState(orderId, orderLockState);
//		Map<String, Object> map = new HashMap<String, Object>() ;
//		map.put("orderLockState", orderLockState) ;
//		if(i==1){
//			return successJson(map);
//		}else{
//			return errorJson("服务器忙！");
//		}
		
		BaseStateResult result = groupOrderFacade.updateOrderLockState(orderId, orderLockState);
		if(result.isSuccess()){
			Map<String, Object> map = new HashMap<String, Object>() ;
			map.put("orderLockState", orderLockState) ;
			return successJson(map);
		}else{
			return errorJson(result.getError());
		}
	}
	
	//FIXME 这批量咋处理的，逻辑和单个处理一样
	/**
	 * 更新订单锁单状态
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/batchUpdateOrderLockState.do")
	@ResponseBody
	public String batchUpdateOrderLockState(Integer orderId,Integer orderLockState) {
//		int i = groupOrderService.updateOrderLockState(orderId, orderLockState);
//		Map<String, Object> map = new HashMap<String, Object>() ;
//		map.put("orderLockState", orderLockState) ;
//		if(i==1){
//			return successJson(map);
//		}else{
//			return errorJson("服务器忙！");
//		}
		
		BaseStateResult result = groupOrderFacade.updateOrderLockState(orderId, orderLockState);
		if(result.isSuccess()){
			Map<String, Object> map = new HashMap<String, Object>() ;
			map.put("orderLockState", orderLockState) ;
			return successJson(map);
		}else{
			return errorJson(result.getError());
		}
	}
	
	/**
	 * 锁单列表
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toOrderLockList.htm")
	public String toOrderLockList(HttpServletRequest request, Model model) {
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("allProvince", allProvince);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
//		return "sales/orderLock/orderLockList";
		
		Integer bizId = WebUtils.getCurBizId(request);
		ToOrderLockListResult toOrderLockListResult=groupOrderFacade.toOrderLockList(bizId);
		
		model.addAttribute("allProvince", toOrderLockListResult.getAllProvince());
		model.addAttribute("orgJsonStr",toOrderLockListResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",toOrderLockListResult.getOrgUserJsonStr());
		
		return "sales/orderLock/orderLockList";
	}

	/**
	 * 锁单查询分页
	 * 
	 * @param request
	 * @param model
	 * @param order
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/toOrderLockTable.htm")
	public String toOrderLockTable(HttpServletRequest request, Model model,
			GroupOrder order) throws ParseException {
		
//		if (order != null && order.getDateType() == 2) {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//			if (!"".equals(order.getStartTime())) {
//				order.setStartTime(sdf.parse(order.getStartTime())
//						.getTime() + "");
//			}
//			if (!"".equals(order.getEndTime())) {
//				Calendar calendar = Calendar.getInstance();
//				calendar.setTime(sdf.parse(order.getEndTime()));
//				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
//				order.setEndTime(calendar.getTime().getTime() + "");
//			}
//		}
//		
//		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
//		pageBean.setPage(order.getPage());
//		pageBean.setPageSize(order.getPageSize() == null ? Constants.PAGESIZE
//				: order.getPageSize());
//		pageBean.setParameter(order);
//		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(order.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(order.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = order.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
//					WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				order.setSaleOperatorIds(salesOperatorIds.substring(0,
//						salesOperatorIds.length() - 1));
//			}
//		}
//		pageBean = groupOrderService.selectOrderLockByConListPage(pageBean,
//				WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
//		String totalPb = groupOrderService.selectOrderLockByCon(pageBean,
//				WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
//		model.addAttribute("totalPb", totalPb);
//		model.addAttribute("page", pageBean);
//		model.addAttribute("orders", pageBean.getResult());
//		return "sales/orderLock/orderLockTable";
		
		ToOrderLockTableDTO orderLockTableDTO=new ToOrderLockTableDTO();
		orderLockTableDTO.setBizId(WebUtils.getCurBizId(request));
		orderLockTableDTO.setOrder(order);
		orderLockTableDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		ToOrderLockTableResult toOrderLockTableResult=groupOrderFacade.toOrderLockTable(orderLockTableDTO);
		model.addAttribute("totalPb", toOrderLockTableResult.getTotalPb());
		model.addAttribute("page", toOrderLockTableResult.getPageBean());
		model.addAttribute("orders", toOrderLockTableResult.getPageBean().getResult());
		
		return "sales/orderLock/orderLockTable";
	}
	
	@RequestMapping(value = "insertGroupMany.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroupMany(HttpServletRequest request,
			HttpServletResponse reponse, String ids, String code) {

//		TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
//		if (tourGroup == null) {
//			return errorJson("未查到该团号对应的散客团信息!");
//		}
//		String[] split = ids.split(",");
//		for (String str : split) {
//			GroupOrder groupOrder = groupOrderService
//					.selectByPrimaryKey(Integer.parseInt(str));
//			groupOrder.setGroupId(tourGroup.getId());
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
//		return successJson();
	
		BaseStateResult result=groupOrderFacade.insertGroupMany(ids,code);
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
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
//
//		return successJson();
		
		BaseStateResult result=groupOrderFacade.insertGroup(id,code);
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
	}

	/**
	 * 修改散客团信息
	 * 
	 * @param request
	 * @param reponse
	 * @param tourGroup
	 * @return
	 */
	@RequestMapping(value = "editOrderGroupInfo.do")
	@ResponseBody
	public String editOrderGroupInfo(HttpServletRequest request,
			HttpServletResponse reponse, TourGroup tourGroup) {
//		if (tourGroup.getPrudctBrandId() != null) {
//			DicInfo dicInfo = dicService.getById(tourGroup.getPrudctBrandId()+ "");
//			tourGroup.setProductBrandName(dicInfo.getValue());
//		}
//		if (tourGroup.getGroupCode() != null) {
//			tourGroup.setGroupCode(GroupCodeUtil.getCode(
//					tourGroup.getGroupCode(), tourGroup.getGroupCodeMark()));
//		}
//		if(tourGroup.getGroupState()==2){
//		List<FinanceCommission> fc1=groupOrderService.selectFinanceCommissionByGroupId(tourGroup.getId());
//		if (fc1 != null && fc1.size() > 0) {
//				return "该团已有购物及佣金被审核！";
//		}
//		List<FinanceCommission> fc2=groupOrderService.selectFCByGroupId(tourGroup.getId());
//		if (fc2 != null && fc2.size() > 0) {
//				return "该团已有购物及佣金被审核！";
//		}
//		}
//		tourGroupService.updateByPrimaryKeySelective(tourGroup);
//		return successJson();
		EditOrderGroupInfoDTO editOrderGroupInfoDTO=new EditOrderGroupInfoDTO();
		editOrderGroupInfoDTO.setTourGroup(tourGroup);
		
		BaseStateResult result=groupOrderFacade.editOrderGroupInfo(editOrderGroupInfoDTO);
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
	}

	/**
	 * 删除散客团
	 * 
	 * @param request
	 * @param reponse
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "delFitTour.do")
	@ResponseBody
	public String delFitTour(HttpServletRequest request,
			HttpServletResponse reponse, Integer groupId) {
//		tourGroupService.delFitTourGroup(groupId);
//		return successJson();
		
		BaseStateResult result=groupOrderFacade.delFitTourGroup(groupId);
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
	}

	
	/**
	 * 跳转到散客团信息订单列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "toFitOrderList.htm")
	public String toFitOrderList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId,
			Integer operType) throws ParseException {
		
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tourGroup);
//		List<GroupOrder> result = groupOrderService.selectOrderByGroupId(groupId);
//		for (GroupOrder groupOrder2 : result) {
//			groupOrder2.setGroupNo(tourGroupService.selectByPrimaryKey(groupOrder2.getGroupId()).getGroupCode());
//			List<GroupRoute> list = groupRouteService.selectByOrderId(groupOrder2.getId());
//			if (list != null && list.size() > 0) {
//				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//				Calendar cal = Calendar.getInstance();
//				cal.setTime(sdf.parse(groupOrder2.getDepartureDate()));
//				cal.add(Calendar.DAY_OF_MONTH, +(list.size() - 1));
//				Date time = cal.getTime();
//				groupOrder2.setFitDate(sdf.format(time));
//			}
//		}
//		model.addAttribute("groupOrderList", result);
//		model.addAttribute("operType", operType);
		
		model.addAttribute("operType", operType);
		
		ToFitOrderListResult result=groupOrderFacade.toFitOrderList(groupId);
		model.addAttribute("groupOrderList", result.getList());
		model.addAttribute("tourGroup", result.getTourGroup());
		
		return "sales/groupOrder/fitOrderList";
	}

	/**
	 * 跳转到散客团信息页
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "toFitEdit.htm")
	public String toFitEdit(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId,
			Integer operType) {
		
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		List<DicInfo> ppList = dicService.getListByTypeCode(BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
//		model.addAttribute("ppList", ppList);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("operType", operType);
//		model.addAttribute("groupId", groupId);
		
		Integer bizId = WebUtils.getCurBizId(request);
		ToFitEditResult result=groupOrderFacade.toFitEdit(groupId,bizId);
		
		model.addAttribute("ppList", result.getPpList());
		model.addAttribute("tourGroup", result.getTourGroup());
		model.addAttribute("operType", operType);
		model.addAttribute("groupId", groupId);
		
		return "sales/groupOrder/fitEdit";
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
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		List<GroupOrder> orderList = mergeGroupOrderVO.getOrderList();
//
//		List<MergeGroupOrderVO> result = new ArrayList<MergeGroupOrderVO>();
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
//		// --------------------------------------------------------------------------------
//		for (MergeGroupOrderVO mergeGroupOrderVO2 : result) {
//			List<GroupOrder> orderList2 = mergeGroupOrderVO2.getOrderList();
//			ProductInfo productInfo = null;
//			for (GroupOrder groupOrder : orderList2) {
//				ProductInfo productInfo2 = productInfoService
//						.findProductInfoById(groupOrder.getProductId());
//				if (productInfo == null) {
//					productInfo = productInfo2;
//				} else if (productInfo2 != null
//						&& productInfo2.getTravelDays() > productInfo
//								.getTravelDays()) {
//					productInfo = productInfo2;
//				}
//			}
//			// -------------------------------------------------------------------------------
//			ProductRouteVo productRouteVo = productRouteService
//					.findByProductId(productInfo.getId());
//			ProductRemark productRemark = productRemarkService
//					.findProductRemarkByProductId(productInfo.getId());
//
//			TourGroup tourGroup = new TourGroup();
//			tourGroup.setServiceStandard(productRemark.getItemInclude()
//					+ productRemark.getItemExclude());
//			tourGroup.setRemark(productRemark.getChildPlan()
//					+ productRemark.getShoppingPlan()
//					+ productRemark.getItemCharge()
//					+ productRemark.getItemFree());
//			tourGroup
//					.setWarmNotice(productRemark.getAttention()
//							+ productRemark.getItemOther()
//							+ productRemark.getWarmTip());
//
//			tourGroup.setServiceStandard(productRemark.getItemInclude()
//					+ productRemark.getItemExclude());
//			tourGroup.setRemark(productRemark.getChildPlan()
//					+ productRemark.getShoppingPlan()
//					+ productRemark.getItemCharge()
//					+ productRemark.getItemFree());
//			tourGroup
//					.setWarmNotice(productRemark.getAttention()
//							+ productRemark.getItemOther()
//							+ productRemark.getWarmTip());
//
//			mergeGroupOrderVO2.setTourGroup(tourGroup);
//
//			GroupRouteVO groupRouteVO = new GroupRouteVO();
//			List<GroupRouteDayVO> groupRouteDayVOList = new ArrayList<GroupRouteDayVO>();
//			List<ProductRouteDayVo> productRoteDayVoList = productRouteVo
//					.getProductRoteDayVoList();
//
//			if (productRoteDayVoList != null && productRoteDayVoList.size() > 0) {
//				for (int i = 0; i < productRoteDayVoList.size(); i++) {
//					ProductRoute productRoute = productRoteDayVoList.get(i)
//							.getProductRoute();
//					GroupRoute groupRoute = new GroupRoute();
//					GroupRouteDayVO groupRouteDayVO = new GroupRouteDayVO();
//					try {
//						BeanUtils.copyProperties(groupRoute, productRoute);
//						Calendar cal = Calendar.getInstance();
//						cal.setTime(sdf.parse(mergeGroupOrderVO2.getOrderList()
//								.get(0).getDepartureDate()));
//						cal.add(Calendar.DAY_OF_MONTH, i);
//						Date time = cal.getTime();
//						groupRoute.setId(null);
//						groupRoute.setGroupDate(time);
//						List<ProductAttachment> productAttachmentsList = productRoteDayVoList
//								.get(i).getProductAttachments();
//						List<GroupRouteAttachment> groupRouteAttachmentList = new ArrayList<GroupRouteAttachment>();
//						if (productAttachmentsList != null
//								&& productAttachmentsList.size() > 0) {
//							for (ProductAttachment productAttachment : productAttachmentsList) {
//								GroupRouteAttachment groupRouteAttachment = new GroupRouteAttachment();
//								BeanUtils.copyProperties(groupRouteAttachment,
//										productAttachment);
//								groupRouteAttachment.setId(null);
//								groupRouteAttachmentList
//										.add(groupRouteAttachment);
//							}
//						}
//
//						List<ProductRouteTraffic> productRouteTrafficList = productRoteDayVoList
//								.get(i).getProductRouteTrafficList();
//						List<GroupRouteTraffic> groupRouteTrafficList = new ArrayList<GroupRouteTraffic>();
//						if (productRouteTrafficList != null
//								&& productRouteTrafficList.size() > 0) {
//							for (ProductRouteTraffic productRouteTraffic : productRouteTrafficList) {
//								GroupRouteTraffic groupRouteTraffic = new GroupRouteTraffic();
//								BeanUtils.copyProperties(groupRouteTraffic,
//										productRouteTraffic);
//								groupRouteTraffic.setId(null);
//								groupRouteTrafficList.add(groupRouteTraffic);
//
//							}
//						}
//
//						// List<GroupRouteSupplier> groupRouteScenicSupplierList
//						// =
//						// new ArrayList<GroupRouteSupplier>();
//						// List<ProductRouteSupplier> productScenicSupplierList
//						// =
//						// productRoteDayVoList
//						// .get(i).getProductScenicSupplierList();
//						// if (productScenicSupplierList != null
//						// && productScenicSupplierList.size() > 0) {
//						// for (ProductRouteSupplier productRouteScenicSupplier
//						// :
//						// productScenicSupplierList) {
//						// GroupRouteSupplier groupRouteScenicSupplier = new
//						// GroupRouteSupplier();
//						// BeanUtils.copyProperties(groupRouteScenicSupplier,
//						// productRouteScenicSupplier);
//						// groupRouteScenicSupplier.setId(null);
//						// groupRouteScenicSupplierList
//						// .add(groupRouteScenicSupplier);
//						// }
//						// }
//
//						List<GroupRouteSupplier> groupRouteOptionsSupplierList = new ArrayList<GroupRouteSupplier>();
//						List<ProductRouteSupplier> productOptionsSupplierList = productRoteDayVoList
//								.get(i).getProductOptionsSupplierList();
//						if (productOptionsSupplierList != null
//								&& productOptionsSupplierList.size() > 0) {
//							for (ProductRouteSupplier productRouteSupplier : productOptionsSupplierList) {
//								GroupRouteSupplier groupRouteOptionsSupplier = new GroupRouteSupplier();
//								BeanUtils.copyProperties(
//										groupRouteOptionsSupplier,
//										productRouteSupplier);
//								groupRouteOptionsSupplier.setId(null);
//								groupRouteOptionsSupplierList
//										.add(groupRouteOptionsSupplier);
//							}
//						}
//						groupRouteDayVO.setGroupRoute(groupRoute);
//						groupRouteDayVO
//								.setGroupRouteAttachmentList(groupRouteAttachmentList);
//						groupRouteDayVO
//								.setGroupRouteOptionsSupplierList(groupRouteOptionsSupplierList);
//						// groupRouteDayVO
//						// .setGroupRouteScenicSupplierList(groupRouteScenicSupplierList);
//						groupRouteDayVO
//								.setGroupRouteTrafficList(groupRouteTrafficList);
//
//					} catch (Exception e) {
//						return errorJson("行程转换错误!");
//					}
//					groupRouteDayVOList.add(groupRouteDayVO);
//
//				}
//
//			}
//			groupRouteVO.setGroupRouteDayVOList(groupRouteDayVOList);
//
//			mergeGroupOrderVO2.setGroupRouteVO(groupRouteVO);
//		}
//
//		// -------------------------------------------------------------------------------
//
//		groupOrderService.mergeGroup(result, WebUtils.getCurBizId(request),
//				WebUtils.getCurUserId(request), WebUtils.getCurUser(request)
//						.getName(), settingCommon.getMyBizCode(request));
		
		MergeGroupDTO mergeGroupDTO=new MergeGroupDTO();
		
		mergeGroupDTO.setBizCode(settingCommon.getMyBizCode(request));
		mergeGroupDTO.setBizId(WebUtils.getCurBizId(request));
		mergeGroupDTO.setUserId(WebUtils.getCurUserId(request));
		mergeGroupDTO.setUserName(WebUtils.getCurUser(request).getName());
		
		BaseStateResult result = groupOrderFacade.mergeGroup(mergeGroupDTO);
		
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
	}

	/**
	 * 散客团订单列表中添加订单
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "secMergeGroup.htm")
	@ResponseBody
	public String secMergeGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId,
			String ids) {
		
//		List<GroupOrder> glist = groupOrderService.selectOrderByGroupId(groupId);
//		List<String> datelist = new ArrayList<String>();
//		List<Integer> productlist = new ArrayList<Integer>();
//		List<Integer> statelist = new ArrayList<Integer>();
//		if (glist != null && glist.size() > 0) {
//			datelist.add(glist.get(0).getDepartureDate());
//		}
//		String[] split = ids.split(",");
//		for (String id : split) {
//			datelist.add(groupOrderService.findById(Integer.parseInt(id)).getDepartureDate());
//			productlist.add(groupOrderService.findById(Integer.parseInt(id)).getProductId());
//			statelist.add(groupOrderService.findById(Integer.parseInt(id)).getStateFinance());
//		}
//		
//		// if (!Utils.hasSame(datelist)) {
//		// return errorJson("发团日期一致的订单才允许添加!");
//		// }
//		// if (!Utils.hasSame(productlist)) {
//		// return errorJson("产品一致的订单才允许并团!");
//		// }
//		
//		for (String str : split) {
//			tourGroupService.addFitOrder(groupId, Integer.parseInt(str));
//		}
		
		groupOrderFacade.secMergeGroup(groupId,ids);
		
		return successJson();
	}

	

	/**
	 * 判断是否满足批量加入团条件
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
//		String[] split = ids.split(",");
//		List<String> datelist = new ArrayList<String>();
////		List<Integer> productlist = new ArrayList<Integer>();
////		List<Integer> brandlist = new ArrayList<Integer>();
////		List<Integer> statelist = new ArrayList<Integer>();
//		for (String id : split) {
//			GroupOrder groupOrder = groupOrderService.findById(Integer
//					.parseInt(id));
//			datelist.add(groupOrder.getDepartureDate());
////			productlist.add(groupOrder.getProductId());
////			statelist.add(groupOrder.getStateFinance());
////			brandlist.add(groupOrder.getProductBrandId());
//			List<GroupOrderGuest> guestList = groupOrderGuestService
//					.selectByOrderId(Integer.parseInt(id));
//			if (guestList == null || guestList.size() == 0) {
//				return errorJson("订单号:" + groupOrder.getOrderNo()
//						+ "无客人信息,无法并团!");
//			}
//
//		}
//
//		if (!MergeGroupUtils.hasSame(datelist)) {
//			return errorJson("发团日期一致的订单才允许加入到团中!");
//		}
//		return successJson();
		
		BaseStateResult result=groupOrderFacade.beforeInsertGroup(ids);
		if(result.isSuccess()){
			return errorJson(result.getError());
		}else{
			return successJson();
		}
	}
	/**
	 * 判断是否满足并团条件
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
		
//		String[] split = ids.split(",");
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
//			List<GroupOrderGuest> guestList = groupOrderGuestService
//					.selectByOrderId(Integer.parseInt(id));
//			if (guestList == null || guestList.size() == 0) {
//				return errorJson("订单号:" + groupOrder.getOrderNo()
//						+ "无客人信息,无法并团!");
//			}
//
//		}
//
//		if (!MergeGroupUtils.hasSame(datelist)) {
//			return errorJson("发团日期一致的订单才允许并团!");
//		}
//		// if (!MergeGroupUtils.hasSame(productlist)) {
//		// return errorJson("产品一致的订单才允许并团!");
//		// }
//		if (!MergeGroupUtils.hasSame(brandlist)) {
//			return errorJson("产品品牌一致的订单才允许并团!");
//		}
//
//		return successJson();
		
		BaseStateResult result=groupOrderFacade.judgeMergeGroup(ids);
		if(!result.isSuccess()){
			return errorJson(result.getError());
		}else{
			return successJson();
		}
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
//		String[] split = ids.split(",");
//		for (String str : split) {
//			GroupOrder groupOrder = groupOrderService.findById(Integer.parseInt(str));
//			groupOrder.setGroupOrderGuestList((groupOrderGuestService.selectByOrderId(groupOrder.getId())));
//			list.add(groupOrder);
//		}
//		model.addAttribute("list", list);
//		model.addAttribute("ids", ids);
		
		ToMergeGroupResult result=groupOrderFacade.toMergeGroup(ids);
		model.addAttribute("list", result.getList());
		model.addAttribute("ids", ids);
		
		return "sales/groupOrder/mergeGroup";
	}

	/**
	 * 跳转到散客订单页面
	 * 
	 * @param request
	 * @param reponse
	 * @return
	 */
	@RequestMapping(value = "toGroupOrderList.htm")
	public String toGroupOrderList(HttpServletRequest request,HttpServletResponse reponse) {
		return "sales/groupOrder/GroupOrderList";
	}

	/**
	 * 跳转到未并团列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "toNotGroupList.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String toNotGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder)
			throws ParseException {
		
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//		if (groupOrder.getReqType() != null && groupOrder.getReqType() == 0) {
//			groupOrder.setDateType(1);
//			Calendar c = Calendar.getInstance();
//			int year = c.get(Calendar.YEAR);
//			int month = c.get(Calendar.MONTH);
//			c.set(year, month, 1);
//			groupOrder.setDepartureDate(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-01");
//			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
//			groupOrder.setEndTime(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-" + c.get(Calendar.DATE));
//		}
//
//		PageBean pageBean = new PageBean();
//		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
//				: groupOrder.getPageSize());
//		pageBean.setPage(groupOrder.getPage());
//		pageBean.setParameter(groupOrder);
//		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = groupOrder.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
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
//		model.addAttribute("groupOrder", groupOrder);
//
//		if (groupOrder.getDateType()!=null && groupOrder.getDateType() == 2) {
//			if (groupOrder.getDepartureDate() != null) {
//				groupOrder.setDepartureDate(sdf.parse(
//						groupOrder.getDepartureDate()).getTime()
//						+ "");
//			}
//			if (groupOrder.getEndTime() != null) {
//				Calendar calendar = new GregorianCalendar();
//				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
//				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
//				groupOrder.setEndTime(calendar.getTime().getTime() + "");
//			}
//
//		}
//
//		pageBean = groupOrderService.selectNotGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//
//		GroupOrder order = groupOrderService.selectTotalNotGroup(groupOrder,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//
//		if (groupOrder.getDateType()!=null && groupOrder.getDateType() == 2) {
//			if (groupOrder.getDepartureDate() != null) {
//				groupOrder.setDepartureDate(sdf.format(new Date(Long
//						.valueOf(groupOrder.getDepartureDate()))));
//			}
//			if (groupOrder.getEndTime() != null) {
//				Calendar calendar = new GregorianCalendar();
//				calendar.setTimeInMillis(Long.valueOf(groupOrder.getEndTime()));
//				calendar.add(calendar.DATE, -1);// 把日期往后增加一天.整数往后推,负数往前移动
//				groupOrder.setEndTime(sdf.format(calendar.getTime()));
//			}
//		}
//
//		model.addAttribute("totalAudit",
//				order == null ? 0 : order.getNumAdult());
//		model.addAttribute("totalChild",
//				order == null ? 0 : order.getNumChild());
//		model.addAttribute("total", order == null ? 0 : order.getTotal());
//
//		List<GroupOrder> result = pageBean.getResult();
//		Integer pageTotalAudit = 0;
//		Integer pageTotalChild = 0;
//		BigDecimal pageTotal = new BigDecimal(0);
//
//		for (GroupOrder groupOrder2 : result) {
//			List<GroupRoute> list = groupRouteService
//					.selectByOrderId(groupOrder2.getId());
//			if (list != null && list.size() > 0) {
//				Calendar cal = Calendar.getInstance();
//				cal.setTime(sdf.parse(groupOrder2.getDepartureDate()));
//				cal.add(Calendar.DAY_OF_MONTH, +(list.size() - 1));
//				Date time = cal.getTime();
//				groupOrder2.setFitDate(sdf.format(time));
//			}
//			pageTotalAudit += groupOrder2.getNumAdult();
//			pageTotalChild += groupOrder2.getNumChild();
//			pageTotal = pageTotal
//					.add(groupOrder2.getTotal() == null ? new BigDecimal(0)
//							: groupOrder2.getTotal());
//			
//			if (groupOrder2.getCreateTime() != null) {
//				SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//				Long createTime = groupOrder2.getCreateTime();
//				String dateStr = sf.format(createTime);
//				groupOrder2.setCreateTimeStr(dateStr);
//			}
//			
//		}
//		model.addAttribute("pageTotalAudit", pageTotalAudit);
//		model.addAttribute("pageTotalChild", pageTotalChild);
//		model.addAttribute("pageTotal", pageTotal);
//
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
//		model.addAttribute("pp", pp);
//		model.addAttribute("page", pageBean);
//
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//		List<RegionInfo> cityList = null;
//		if (groupOrder.getProvinceId() != null
//				&& groupOrder.getProvinceId() != -1) {
//			cityList = regionService.getRegionById(groupOrder.getProvinceId()
//					+ "");
//		}
//		model.addAttribute("allCity", cityList);
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
		
		ToNotGroupListDTO toNotGroupListDTO=new ToNotGroupListDTO();
		toNotGroupListDTO.setBizId( WebUtils.getCurBizId(request));
		toNotGroupListDTO.setGroupOrder(groupOrder);
		toNotGroupListDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		ToNotGroupListResult result=groupOrderFacade.toNotGroupList(toNotGroupListDTO);
		
		model.addAttribute("groupOrder", result.getGroupOrder());
		
		model.addAttribute("totalAudit",result.getTotalAudit());
		model.addAttribute("totalChild",result.getTotalChild());
		model.addAttribute("total",result.getTotal());

		model.addAttribute("pageTotalAudit",result.getPageTotalAudit());
		model.addAttribute("pageTotalChild", result.getPageTotalChild());
		model.addAttribute("pageTotal", result.getPageTotal());

		model.addAttribute("pp", result.getPp());
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("allProvince", result.getAllProvince());
		

		model.addAttribute("allCity", result.getCityList());
		model.addAttribute("orgJsonStr",result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "sales/groupOrder/notGroupList";
	}

	@RequestMapping(value = "toSecImpNotGroupList.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String toSecImpNotGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder,
			Integer gid) {
		
//		if (groupOrder.getReqType() != null && groupOrder.getReqType() == 0) {
//			Calendar c = Calendar.getInstance();
//			int year = c.get(Calendar.YEAR);
//			int month = c.get(Calendar.MONTH);
//			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//			c.set(year, month, 1);
//			groupOrder.setDepartureDate(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-01");
//			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
//			groupOrder.setEndTime(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-" + c.get(Calendar.DATE));
//			groupOrder.setDateType(1);
//		}
//		PageBean pageBean = new PageBean();
//		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
//				: groupOrder.getPageSize());
//		pageBean.setPage(groupOrder.getPage());
//		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectNotGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		List<GroupOrder> result = pageBean.getResult();
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
//		model.addAttribute("pp", pp);
//		model.addAttribute("groupOrder", groupOrder);
//		model.addAttribute("groupId", gid);
//		model.addAttribute("page", pageBean);
		
		 ToSecImpNotGroupListDTO toSecImpNotGroupListDTO=new ToSecImpNotGroupListDTO();
		 toSecImpNotGroupListDTO.setCurBizId(WebUtils.getCurBizId(request));
		 toSecImpNotGroupListDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		 toSecImpNotGroupListDTO.setGroupOrder(groupOrder);
		 
		ToSecImpNotGroupListResult result=groupOrderFacade.toSecImpNotGroupList(toSecImpNotGroupListDTO);
		model.addAttribute("pp", result.getPp());
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("groupId", gid);
		model.addAttribute("page", result.getPageBean());
		
		return "sales/groupOrder/secImpNotGroupOrder";
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
//		if (null == groupOrder.getEndTime()
//				&& null == groupOrder.getDepartureDate()) {
//			Calendar c = Calendar.getInstance();
//			int year = c.get(Calendar.YEAR);
//			int month = c.get(Calendar.MONTH);
//			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//			c.set(year, month, 1);
//			groupOrder.setDepartureDate(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-01");
//			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
//			groupOrder.setEndTime(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-" + c.get(Calendar.DATE));
//
//		}
//		model.addAttribute("idLists", idLists);
//		String[] split = idLists.split(",");
//		List<Integer> intIds = new ArrayList<Integer>();
//		for (String id : split) {
//			intIds.add(Integer.parseInt(id));
//		}
//		groupOrder.setIdList(intIds);
//		PageBean pageBean = new PageBean();
//		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
//				: groupOrder.getPageSize());
//		pageBean.setPage(groupOrder.getPage());
//		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectNotGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		List<GroupOrder> result = pageBean.getResult();
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,WebUtils.getCurBizId(request));
//		model.addAttribute("pp", pp);
//		model.addAttribute("groupOrder", groupOrder);
//		model.addAttribute("page", pageBean);
		
		ToImpNotGroupListDTO toImpNotGroupListDTO=new ToImpNotGroupListDTO();
		
		toImpNotGroupListDTO.setBizId(WebUtils.getCurBizId(request));
		toImpNotGroupListDTO.setGroupOrder(groupOrder);
		toImpNotGroupListDTO.setIdLists(idLists);
		toImpNotGroupListDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		ToImpNotGroupListResult result=groupOrderFacade.toImpNotGroupList(toImpNotGroupListDTO);
		model.addAttribute("idLists", idLists);
		model.addAttribute("pp", result.getPp());
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("page", result.getPageBean());
		
		return "sales/groupOrder/impNotGroupOrder";
	}

	/**
	 * 跳转到已并团列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException
	 */
//	@RequestMapping(value = "toYesGroupList.htm")
//	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
//	public String toYesGroupList(HttpServletRequest request,
//			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder)
//			throws ParseException {
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		if (groupOrder.getReqType() != null && groupOrder.getReqType() == 0) {
//			groupOrder.setDateType(1);
//			Calendar c = Calendar.getInstance();
//			int year = c.get(Calendar.YEAR);
//			int month = c.get(Calendar.MONTH);
//			c.set(year, month, 1);
//			groupOrder.setDepartureDate(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-01");
//			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
//			groupOrder.setEndTime(c.get(Calendar.YEAR) + "-"
//					+ (c.get(Calendar.MONTH) + 1) + "-" + c.get(Calendar.DATE));
//
//		}
//		if (groupOrder.getDateType() == 2) {
//			if (groupOrder.getDepartureDate() != null) {
//				groupOrder.setDepartureDate(sdf.parse(
//						groupOrder.getDepartureDate()).getTime()
//						+ "");
//			}
//			if (groupOrder.getEndTime() != null) {
//				Calendar calendar = new GregorianCalendar();
//				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
//				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
//				groupOrder.setEndTime(calendar.getTime().getTime() + "");
//			}
//
//		}
//
//		PageBean pageBean = new PageBean();
//		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
//				: groupOrder.getPageSize());
//		pageBean.setPage(groupOrder.getPage());
//		pageBean.setParameter(groupOrder);
//		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = groupOrder.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
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
//
//		pageBean = groupOrderService.selectYesGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		List<GroupOrder> result = pageBean.getResult();
//
//		GroupOrder order = groupOrderService.selectTotalYesGroup(groupOrder,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//
//		if (groupOrder.getDateType() == 2) {
//			if (groupOrder.getDepartureDate() != null) {
//				groupOrder.setDepartureDate(sdf.format(new Date(Long
//						.valueOf(groupOrder.getDepartureDate()))));
//			}
//			if (groupOrder.getEndTime() != null) {
//				Calendar calendar = new GregorianCalendar();
//				calendar.setTimeInMillis(Long.valueOf(groupOrder.getEndTime()));
//				calendar.add(calendar.DATE, -1);// 把日期往后增加一天.整数往后推,负数往前移动
//				groupOrder.setEndTime(sdf.format(calendar.getTime()));
//			}
//		}
//		model.addAttribute("totalAudit",
//				order == null ? 0 : order.getNumAdult());
//		model.addAttribute("totalChild",
//				order == null ? 0 : order.getNumChild());
//		model.addAttribute("total", order == null ? 0 : order.getTotal());
//		Integer pageTotalAudit = 0;
//		Integer pageTotalChild = 0;
//		BigDecimal pageTotal = new BigDecimal(0);
//		for (GroupOrder groupOrder2 : result) {
//			groupOrder2.setGroupNo(tourGroupService.selectByPrimaryKey(
//					groupOrder2.getGroupId()).getGroupCode());
//			List<GroupRoute> list = groupRouteService
//					.selectByOrderId(groupOrder2.getId());
//			if (list != null && list.size() > 0) {
//				Calendar cal = Calendar.getInstance();
//				cal.setTime(sdf.parse(groupOrder2.getDepartureDate()));
//				cal.add(Calendar.DAY_OF_MONTH, +(list.size() - 1));
//				Date time = cal.getTime();
//				groupOrder2.setFitDate(sdf.format(time));
//			}
//			pageTotalAudit += groupOrder2.getNumAdult();
//			pageTotalChild += groupOrder2.getNumChild();
//			pageTotal = pageTotal
//					.add(groupOrder2.getTotal() == null ? new BigDecimal(0)
//							: groupOrder2.getTotal());
//			if (groupOrder2.getCreateTime() != null) {
//				SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//				Long createTime = groupOrder2.getCreateTime();
//				String dateStr = sf.format(createTime);
//				groupOrder2.setCreateTimeStr(dateStr);
//			}
//		}
//		model.addAttribute("pageTotalAudit", pageTotalAudit);
//		model.addAttribute("pageTotalChild", pageTotalChild);
//		model.addAttribute("pageTotal", pageTotal);
//
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
//		model.addAttribute("pp", pp);
//		model.addAttribute("groupOrder", groupOrder);
//		model.addAttribute("page", pageBean);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//		List<RegionInfo> cityList = null;
//		if (groupOrder.getProvinceId() != null
//				&& groupOrder.getProvinceId() != -1) {
//			cityList = regionService.getRegionById(groupOrder.getProvinceId()
//					+ "");
//		}
//		model.addAttribute("allCity", cityList);
//		model.addAttribute("allCity", cityList);
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
//		return "sales/groupOrder/yesGroupList";
//	}

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
		
//		if (airTicketRequestService.doesOrderhaveRequested(WebUtils.getCurBizId(request), id)){
//			return errorJson("删除订单前请先取消机票申请。");
//		}
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		groupOrder.setState(-1);
//		groupOrderService.updateGroupOrder(groupOrder);
//		if (groupOrder.getPriceId() != null) {
//
//			boolean updateStock = productGroupPriceService.updateStock(
//					groupOrder.getPriceId(), groupOrder.getSupplierId(),
//					-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
//
//			log.info("更新库存:" + updateStock);
//		}
//		bookingSupplierService.upateGroupIdAfterDelOrderFromGroup(id);
		
		BaseStateResult result = groupOrderFacade.delGroupOrder(WebUtils.getCurBizId(request),id);
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
	}

	

	/**
	 * 添加散客订单业务
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderVO
	 * @return
	 * @throws InvocationTargetException
	 * @throws IllegalAccessException
	 */
	@RequestMapping(value = "addGroupOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderVO groupOrderVO,
			Integer priceId, Integer priceGroupId)
			throws IllegalAccessException, InvocationTargetException {		
		
//		groupOrderVO.getGroupOrder().setBizId(WebUtils.getCurBizId(request));
//		groupOrderVO.getGroupOrder().setOrderNo(
//				settingCommon.getMyBizCode(request));
//		groupOrderVO.getGroupOrder().setOperatorId(
//				WebUtils.getCurUserId(request));
//		groupOrderVO.getGroupOrder().setOperatorName(
//				WebUtils.getCurUser(request).getName());
//		groupOrderVO.getGroupOrder().setCreatorId(
//				WebUtils.getCurUserId(request));
//		groupOrderVO.getGroupOrder().setCreatorName(
//				WebUtils.getCurUser(request).getName());
//		groupOrderVO.getGroupOrder().setPriceId(priceId);
//		groupOrderVO.getGroupOrder().setCreateTime(System.currentTimeMillis());
//
//		ProductRouteVo productRouteVo = productRouteService
//				.findByProductId(groupOrderVO.getGroupOrder().getProductId());
//		GroupRouteVO groupRouteVO = new GroupRouteVO();
//		// -----------------------------------------------------
//		List<GroupRouteDayVO> groupRouteDayVOList = new ArrayList<GroupRouteDayVO>();
//		List<ProductRouteDayVo> productRoteDayVoList = productRouteVo
//				.getProductRoteDayVoList();
//		// -----------------------------------------------------
//		if (productRoteDayVoList != null && productRoteDayVoList.size() > 0) {
//			for (int i = 0; i < productRoteDayVoList.size(); i++) {
//				ProductRoute productRoute = productRoteDayVoList.get(i)
//						.getProductRoute();
//				GroupRoute groupRoute = new GroupRoute();
//				GroupRouteDayVO groupRouteDayVO = new GroupRouteDayVO();
//				try {
//					BeanUtils.copyProperties(groupRoute, productRoute);
//					groupRoute.setId(null);
//					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//					Calendar cal = Calendar.getInstance();
//					cal.setTime(sdf.parse(groupOrderVO.getGroupOrder()
//							.getDepartureDate()));
//					cal.add(Calendar.DAY_OF_MONTH, +(i + 1));
//					Date time = cal.getTime();
//					groupRoute.setGroupDate(time);
//					List<ProductAttachment> productAttachmentsList = productRoteDayVoList
//							.get(i).getProductAttachments();
//					List<GroupRouteAttachment> groupRouteAttachmentList = new ArrayList<GroupRouteAttachment>();
//					if (productAttachmentsList != null
//							&& productAttachmentsList.size() > 0) {
//						GroupRouteAttachment groupRouteAttachment = new GroupRouteAttachment();
//						for (ProductAttachment productAttachment : productAttachmentsList) {
//							BeanUtils.copyProperties(groupRouteAttachment,
//									productAttachment);
//							groupRouteAttachment.setId(null);
//							groupRouteAttachmentList.add(groupRouteAttachment);
//						}
//					}
//
//					List<ProductRouteTraffic> productRouteTrafficList = productRoteDayVoList
//							.get(i).getProductRouteTrafficList();
//					List<GroupRouteTraffic> groupRouteTrafficList = new ArrayList<GroupRouteTraffic>();
//					if (productRouteTrafficList != null
//							&& productRouteTrafficList.size() > 0) {
//						for (ProductRouteTraffic productRouteTraffic : productRouteTrafficList) {
//							GroupRouteTraffic groupRouteTraffic = new GroupRouteTraffic();
//							BeanUtils.copyProperties(groupRouteTraffic,
//									productRouteTraffic);
//							groupRouteTraffic.setId(null);
//							groupRouteTrafficList.add(groupRouteTraffic);
//
//						}
//					}
//
//					// List<GroupRouteSupplier> groupRouteScenicSupplierList =
//					// new ArrayList<GroupRouteSupplier>();
//					// List<ProductRouteSupplier> productScenicSupplierList =
//					// productRoteDayVoList
//					// .get(i).getProductScenicSupplierList();
//					// if (productScenicSupplierList != null
//					// && productScenicSupplierList.size() > 0) {
//					// for (ProductRouteSupplier productRouteScenicSupplier :
//					// productScenicSupplierList) {
//					// GroupRouteSupplier groupRouteScenicSupplier = new
//					// GroupRouteSupplier();
//					// BeanUtils.copyProperties(groupRouteScenicSupplier,
//					// productRouteScenicSupplier);
//					// groupRouteScenicSupplier.setId(null);
//					// groupRouteScenicSupplierList
//					// .add(groupRouteScenicSupplier);
//					// }
//					// }
//
//					List<GroupRouteSupplier> groupRouteOptionsSupplierList = new ArrayList<GroupRouteSupplier>();
//					List<ProductRouteSupplier> productOptionsSupplierList = productRoteDayVoList
//							.get(i).getProductOptionsSupplierList();
//					if (productOptionsSupplierList != null
//							&& productOptionsSupplierList.size() > 0) {
//						for (ProductRouteSupplier productRouteSupplier : productOptionsSupplierList) {
//							GroupRouteSupplier groupRouteOptionsSupplier = new GroupRouteSupplier();
//							BeanUtils.copyProperties(groupRouteOptionsSupplier,
//									productRouteSupplier);
//							groupRouteOptionsSupplier.setId(null);
//							groupRouteOptionsSupplierList
//									.add(groupRouteOptionsSupplier);
//						}
//					}
//					groupRouteDayVO.setGroupRoute(groupRoute);
//					groupRouteDayVO
//							.setGroupRouteAttachmentList(groupRouteAttachmentList);
//					groupRouteDayVO
//							.setGroupRouteOptionsSupplierList(groupRouteOptionsSupplierList);
//					// groupRouteDayVO
//					// .setGroupRouteScenicSupplierList(groupRouteScenicSupplierList);
//
//				} catch (Exception e) {
//					return errorJson("行程转换错误!");
//				}
//				groupRouteDayVOList.add(groupRouteDayVO);
//
//			}
//
//		}
//		groupRouteVO.setGroupRouteDayVOList(groupRouteDayVOList);
//
//		List<GroupOrderGuest> audlt = new ArrayList<GroupOrderGuest>();
//		List<GroupOrderGuest> child = new ArrayList<GroupOrderGuest>();
//		int isSingle = 0;
//		List<GroupOrderGuest> groupOrderGuestList2 = groupOrderVO
//				.getGroupOrderGuestList();
//		List<GroupOrderPrice> insertList = new ArrayList<GroupOrderPrice>();
//		int totalIncome = 0;
//		if (groupOrderGuestList2 != null && groupOrderGuestList2.size() > 0) {
//			for (GroupOrderGuest groupOrderGuest : groupOrderGuestList2) {
//
//				if (groupOrderGuest.getIsSingleRoom() == 1) {
//					isSingle++;
//				}
//				if (groupOrderGuest.getType() == 1) {
//					audlt.add(groupOrderGuest);
//				} else {
//					child.add(groupOrderGuest);
//				}
//
//			}
//			ProductGroupPrice productGroupPrice = productGroupPriceService
//					.selectByPrimaryKey(priceId).getGroupPrice();
//
//			// ----------------------收入----------------------
//
//			GroupOrderPrice audltIn = new GroupOrderPrice();
//			audltIn.setCreateTime(System.currentTimeMillis());
//			audltIn.setCreatorId(WebUtils.getCurUserId(request));
//			audltIn.setCreatorName(WebUtils.getCurUser(request).getName());
//			audltIn.setMode(0);
//			audltIn.setNumPerson(Double.valueOf(audlt.size()+""));
//			audltIn.setUnitPrice(productGroupPrice.getPriceSettlementAdult()
//					.doubleValue());
//			audltIn.setNumTimes(1.0);
//			totalIncome += audlt.size()
//					* productGroupPrice.getPriceSettlementAdult().doubleValue()
//					* 1;
//			audltIn.setTotalPrice(audlt.size()
//					* productGroupPrice.getPriceSettlementAdult().doubleValue()
//					* 1);
//			DicInfo dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(
//					BasicConstants.GGXX_LYSFXM, BasicConstants.CR);
//			audltIn.setItemId(dicInfo.getId());// 大人
//			audltIn.setItemName(dicInfo.getValue());
//			if (audlt.size() != 0) {
//				insertList.add(audltIn);
//			}
//
//			GroupOrderPrice childIn = new GroupOrderPrice();
//			childIn.setCreateTime(System.currentTimeMillis());
//			childIn.setCreatorId(WebUtils.getCurUserId(request));
//			childIn.setCreatorName(WebUtils.getCurUser(request).getName());
//			childIn.setMode(0);
//			childIn.setNumPerson(Double.valueOf(child.size()+""));
//			childIn.setUnitPrice(productGroupPrice.getPriceSettlementChild()
//					.doubleValue());
//			childIn.setNumTimes(1.0);
//			totalIncome += child.size()
//					* productGroupPrice.getPriceSettlementChild().doubleValue()
//					* 1;
//			childIn.setTotalPrice(child.size()
//					* productGroupPrice.getPriceSettlementChild().doubleValue()
//					* 1);
//			dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(
//					BasicConstants.GGXX_LYSFXM, BasicConstants.ERT);
//			childIn.setItemId(dicInfo.getId());// 小孩
//			childIn.setItemName(dicInfo.getValue());
//			if (child.size() != 0) {
//				insertList.add(childIn);
//			}
//			if (isSingle > 0) {
//				GroupOrderPrice roomIn = new GroupOrderPrice();
//				roomIn.setCreateTime(System.currentTimeMillis());
//				roomIn.setCreatorId(WebUtils.getCurUserId(request));
//				roomIn.setCreatorName(WebUtils.getCurUser(request).getName());
//				roomIn.setMode(0);
//				roomIn.setNumPerson(Double.valueOf(isSingle+""));
//				roomIn.setUnitPrice(productGroupPrice
//						.getPriceSettlementRoomeSpread().doubleValue());
//				roomIn.setNumTimes(1.0);
//				totalIncome += isSingle
//						* productGroupPrice.getPriceSettlementRoomeSpread()
//								.doubleValue() * 1;
//				roomIn.setTotalPrice(isSingle
//						* productGroupPrice.getPriceSettlementRoomeSpread()
//								.doubleValue() * 1);
//				dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(
//						BasicConstants.GGXX_LYSFXM, BasicConstants.DFC);
//				roomIn.setItemId(dicInfo.getId());
//				roomIn.setItemName(dicInfo.getValue()); // 单房差
//				insertList.add(roomIn);
//			}
//
//			// -------------------成本------------------------
//
//			GroupOrderPrice audltOut = new GroupOrderPrice();
//			audltOut.setCreateTime(System.currentTimeMillis());
//			audltOut.setCreatorId(WebUtils.getCurUserId(request));
//			audltOut.setCreatorName(WebUtils.getCurUser(request).getName());
//			audltOut.setMode(1); // 成本
//			audltOut.setNumPerson(Double.valueOf(audlt.size()+""));
//			audltOut.setUnitPrice(productGroupPrice.getPriceCostAdult()
//					.doubleValue());
//			audltOut.setNumTimes(1.0);
//			audltOut.setTotalPrice(audlt.size()
//					* productGroupPrice.getPriceCostAdult().doubleValue() * 1);
//			dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(
//					BasicConstants.GGXX_LYSFXM, BasicConstants.CR);
//			audltOut.setItemId(dicInfo.getId());
//			audltOut.setItemName(dicInfo.getValue());
//			if (audlt.size() != 0) {
//				insertList.add(audltOut);
//			}
//
//			GroupOrderPrice childOut = new GroupOrderPrice();
//			childOut.setCreateTime(System.currentTimeMillis());
//			childOut.setCreatorId(WebUtils.getCurUserId(request));
//			childOut.setCreatorName(WebUtils.getCurUser(request).getName());
//			childOut.setMode(1); // 成本
//			childOut.setNumPerson(Double.valueOf(child.size()+""));
//			childOut.setUnitPrice(productGroupPrice.getPriceCostChild()
//					.doubleValue());
//			childOut.setNumTimes(1.0);
//			childOut.setTotalPrice(child.size()
//					* productGroupPrice.getPriceCostChild().doubleValue() * 1);
//			dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(
//					BasicConstants.GGXX_LYSFXM, BasicConstants.ERT);
//			childOut.setItemId(dicInfo.getId());
//			childOut.setItemName(dicInfo.getValue());
//			if (child.size() != 0) {
//				insertList.add(childOut);
//			}
//
//			if (isSingle > 0) {
//				GroupOrderPrice roomIn = new GroupOrderPrice();
//				roomIn.setCreateTime(System.currentTimeMillis());
//				roomIn.setCreatorId(WebUtils.getCurUserId(request));
//				roomIn.setCreatorName(WebUtils.getCurUser(request).getName());
//				roomIn.setMode(1);
//				roomIn.setNumPerson(Double.valueOf(isSingle+""));
//				roomIn.setUnitPrice(productGroupPrice.getPriceCostRoomSpread()
//						.doubleValue());
//				roomIn.setNumTimes(1.0);
//				roomIn.setTotalPrice(isSingle
//						* productGroupPrice.getPriceCostRoomSpread()
//								.doubleValue() * 1);
//				dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(
//						BasicConstants.GGXX_LYSFXM, BasicConstants.DFC);
//				roomIn.setItemId(dicInfo.getId());
//				roomIn.setItemName(dicInfo.getValue()); // 单房差
//				insertList.add(roomIn);
//			}
//
//		}
//		List<GroupOrderPrice> groupOrderPriceList = groupOrderVO
//				.getGroupOrderPriceList();
//		if (groupOrderPriceList != null && groupOrderPriceList.size() > 0) {
//			for (GroupOrderPrice groupOrderPrice : groupOrderPriceList) {
//				totalIncome += groupOrderPrice.getUnitPrice()
//						* groupOrderPrice.getNumPerson()
//						* groupOrderPrice.getNumTimes();
//			}
//		}
//		groupOrderVO.getGroupOrder().setTotal(new BigDecimal(totalIncome));
//
//		// modified by gejinjun 2105-11-03 防止出现保存出错但是也更新库存的问题，修改为如下逻辑
//		try {
//			// 修改订单信息
//			groupOrderService.saveGroupOrder(groupOrderVO, groupRouteVO,
//					insertList);
//			// 更新库存信息
//			ProductGroup group = productGroupService
//					.getGroupInfoById(priceGroupId);
//			boolean updateStock = productGroupPriceService.updateStock(priceId,
//					group.getGroupSetting() == 0 ? groupOrderVO.getGroupOrder()
//							.getSupplierId() : null, groupOrderVO
//							.getGroupOrderGuestList().size());
//			log.info("更新库存状态:" + updateStock);
//		} catch (Exception ex) {
//			// 修改订单信息或更新库存报错
//			ex.printStackTrace();
//			log.error(ex.getMessage());
//		}
//
//		return successJson();
		
		groupOrderVO.getGroupOrder().setBizId(WebUtils.getCurBizId(request));
		groupOrderVO.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
		groupOrderVO.getGroupOrder().setOperatorId(WebUtils.getCurUserId(request));
		groupOrderVO.getGroupOrder().setOperatorName(WebUtils.getCurUser(request).getName());
		groupOrderVO.getGroupOrder().setCreatorId(WebUtils.getCurUserId(request));
		groupOrderVO.getGroupOrder().setCreatorName(WebUtils.getCurUser(request).getName());
		groupOrderVO.getGroupOrder().setPriceId(priceId);
		groupOrderVO.getGroupOrder().setCreateTime(System.currentTimeMillis());
		
		AddGroupOrderDTO addGroupOrderDTO=new AddGroupOrderDTO();
		addGroupOrderDTO.setGroupOrderVO(groupOrderVO);
		addGroupOrderDTO.setPriceGroupId(priceGroupId);
		addGroupOrderDTO.setPriceId(priceId);
		
		BaseStateResult result=groupOrderFacade.addGroupOrder(addGroupOrderDTO);
		if(result.isSuccess()){
			return successJson();
		}else{
			return errorJson(result.getError());
		}
	}

	@RequestMapping(value = "toLookGroupOrder.htm", method = RequestMethod.GET)
	public String toLookGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		groupOrder.setStateFinance(1);
//		model.addAttribute("groupOrder", groupOrder);
//		PlatformEmployeePo saleEmployeePo = sysPlatformEmployeeFacade
//				.findByEmployeeId(groupOrder.getSaleOperatorId()).getPlatformEmployeePo();
//		model.addAttribute("saleEmployeePo", saleEmployeePo);
//
//		PlatformEmployeePo operaEmployeePo = sysPlatformEmployeeFacade
//				.findByEmployeeId(groupOrder.getOperatorId()).getPlatformEmployeePo();
//		model.addAttribute("operaEmployeePo", operaEmployeePo);
//		ProductInfo productInfo = productInfoService
//				.findProductInfoById(groupOrder.getProductId());
//		model.addAttribute("productInfo", productInfo);
//		SupplierInfo supplierInfo = supplierService
//				.selectBySupplierId(groupOrder.getSupplierId());
//		model.addAttribute("supplierInfo", supplierInfo);
//		List<DicInfo> jdxjList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
//		model.addAttribute("jdxjList", jdxjList);
//
//		List<GroupOrderPrice> costList = groupOrderPriceService
//				.selectByOrderAndType(groupOrder.getId(), 0); // mode 0：收入
//		Double income = 0.0;
//		if (costList != null && costList.size() > 0) {
//
//			for (GroupOrderPrice groupOrderPrice : costList) {
//				income += groupOrderPrice.getTotalPrice();
//			}
//
//		}
//		model.addAttribute("income", income);
//
//		List<GroupOrderPrice> budgetList = groupOrderPriceService
//				.selectByOrderAndType(groupOrder.getId(), 1);// 1：预算
//
//		Double budget = 0.0;
//		if (budgetList != null && budgetList.size() > 0) {
//			for (GroupOrderPrice groupOrderPrice : budgetList) {
//				budget += groupOrderPrice.getTotalPrice();
//			}
//		}
//		model.addAttribute("budget", budget);
//
//		model.addAttribute("costList", costList);
//		model.addAttribute("budgetList", budgetList);
//		List<GroupOrderTransport> transportList = groupOrderTransportService
//				.selectByOrderId(groupOrder.getId());
//		model.addAttribute("transportList", transportList);
//		int bizId = WebUtils.getCurBizId(request);
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
//		model.addAttribute("jtfsList", jtfsList);
//
//		List<DicInfo> zjlxList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
//		model.addAttribute("zjlxList", zjlxList);
//
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
//				BasicConstants.GYXX_LYSFXM, bizId);
//		model.addAttribute("lysfxmList", lysfxmList);
//
//		List<GroupRequirement> restaurantList = groupRequirementService
//				.selectByOrderAndType(groupOrder.getId(), Constants.HOTEL);// 酒店
//		List<GroupRequirement> airticketagentList = groupRequirementService
//				.selectByOrderAndType(groupOrder.getId(),
//						Constants.AIRTICKETAGENT); // 机票
//		List<GroupRequirement> trainticketagentList = groupRequirementService
//				.selectByOrderAndType(groupOrder.getId(),
//						Constants.TRAINTICKETAGENT);// 火车票
//
//		model.addAttribute("restaurantList", restaurantList);
//		model.addAttribute("airticketagentList", airticketagentList);
//		model.addAttribute("trainticketagentList", trainticketagentList);
//
//		List<GroupOrderGuest> guestList = groupOrderGuestService
//				.selectByOrderId(groupOrder.getId());
//		for (GroupOrderGuest guest : guestList) {
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.getGuestByGuestCertificateNum(guest.getCertificateNum(),
//							guest.getOrderId());
//			guest.setHistoryNum(guests.size());
//		}
//		model.addAttribute("guestList", guestList);
		
		int bizId = WebUtils.getCurBizId(request);
		ToLookGroupOrderResult result= groupOrderFacade.toLookGroupOrder(id,bizId);
		
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("saleEmployeePo", result.getSaleEmployeePo());
		model.addAttribute("operaEmployeePo", result.getOperaEmployeePo());
		model.addAttribute("productInfo", result.getProductInfo());
		model.addAttribute("supplierInfo", result.getSupplierInfo());
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("income", result.getIncome());
		model.addAttribute("budget", result.getBudget());
		model.addAttribute("costList", result.getCostList());
		model.addAttribute("budgetList", result.getBudgetList());
		model.addAttribute("transportList", result.getTransportList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("restaurantList", result.getRestaurantList());
		model.addAttribute("airticketagentList", result.getAirticketagentList());
		model.addAttribute("trainticketagentList", result.getTrainticketagentList());
		model.addAttribute("guestList", result.getGuestList());
		
		return "sales/groupOrder/editGroupOrder";
	}

	/**
	 * 跳转到查看散客订单页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toEditGroupOrder.htm", method = RequestMethod.GET)
	public String toEditGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {

//		GroupOrder groupOrder = groupOrderService.findById(id);
//
//		model.addAttribute("groupOrder", groupOrder);
//		ProductInfo productInfo = productInfoService
//				.findProductInfoById(groupOrder.getProductId());
//		model.addAttribute("productInfo", productInfo);
//
//		PlatformEmployeePo saleEmployeePo = sysPlatformEmployeeFacade
//				.findByEmployeeId(groupOrder.getSaleOperatorId()).getPlatformEmployeePo();
//		model.addAttribute("saleEmployeePo", saleEmployeePo);
//
//		PlatformEmployeePo operaEmployeePo = sysPlatformEmployeeFacade
//				.findByEmployeeId(groupOrder.getOperatorId()).getPlatformEmployeePo();
//		model.addAttribute("operaEmployeePo", operaEmployeePo);
//
//		SupplierInfo supplierInfo = supplierService
//				.selectBySupplierId(groupOrder.getSupplierId());
//		model.addAttribute("supplierInfo", supplierInfo);
//		
//		int bizId = WebUtils.getCurBizId(request);
//		
//		List<DicInfo> jdxjList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
//		model.addAttribute("jdxjList", jdxjList);
//
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
//		model.addAttribute("sourceTypeList", sourceTypeList);
//
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//		List<RegionInfo> cityList = null;
//		if (groupOrder.getProvinceId() != null
//				&& groupOrder.getProvinceId() != -1) {
//			cityList = regionService.getRegionById(groupOrder.getProvinceId()
//					+ "");
//		}
//		model.addAttribute("allCity", cityList);
//
//		List<GroupOrderPrice> costList = groupOrderPriceService
//				.selectByOrderAndType(groupOrder.getId(), 0); // mode 0：收入
//		Double income = 0.0;
//		if (costList != null && costList.size() > 0) {
//
//			for (GroupOrderPrice groupOrderPrice : costList) {
//				income += groupOrderPrice.getTotalPrice();
//			}
//
//		}
//		model.addAttribute("income", income);
//
//		List<GroupOrderPrice> budgetList = groupOrderPriceService
//				.selectByOrderAndType(groupOrder.getId(), 1);// 1：预算
//
//		Double budget = 0.0;
//		if (budgetList != null && budgetList.size() > 0) {
//			for (GroupOrderPrice groupOrderPrice : budgetList) {
//				budget += groupOrderPrice.getTotalPrice();
//			}
//		}
//		model.addAttribute("budget", budget);
//
//		model.addAttribute("costList", costList);
//		model.addAttribute("budgetList", budgetList);
//		List<GroupOrderTransport> transportList = groupOrderTransportService
//				.selectByOrderId(groupOrder.getId());
//		model.addAttribute("transportList", transportList);
//
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
//		model.addAttribute("jtfsList", jtfsList);
//
//		List<DicInfo> zjlxList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
//		model.addAttribute("zjlxList", zjlxList);
//
//		
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
//				BasicConstants.GYXX_LYSFXM, bizId);
//		model.addAttribute("lysfxmList", lysfxmList);
//
//		List<GroupRequirement> restaurantList = groupRequirementService
//				.selectByOrderAndType(groupOrder.getId(), Constants.HOTEL);// 酒店
//		List<GroupRequirement> airticketagentList = groupRequirementService
//				.selectByOrderAndType(groupOrder.getId(),
//						Constants.AIRTICKETAGENT); // 机票
//		List<GroupRequirement> trainticketagentList = groupRequirementService
//				.selectByOrderAndType(groupOrder.getId(),
//						Constants.TRAINTICKETAGENT);// 火车票
//
//		model.addAttribute("restaurantList", restaurantList);
//		model.addAttribute("airticketagentList", airticketagentList);
//		model.addAttribute("trainticketagentList", trainticketagentList);
//
//		List<GroupOrderGuest> guestList = groupOrderGuestService
//				.selectByOrderId(groupOrder.getId());
//		List<Integer> guestIdList = airTicketRequestService.findIssuedGuestIdList(WebUtils.getCurBizId(request), groupOrder.getId());
//		for (GroupOrderGuest guest : guestList) {
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.getGuestByGuestCertificateNum(guest.getCertificateNum(),
//							guest.getOrderId());
//			guest.setHistoryNum(guests.size());
//			guest.setEditType(!guestIdList.contains(guest.getId()));
//		}
//		model.addAttribute("guestList", guestList);
//
//		ProductGroupPrice productGroupPrice = productGroupPriceService
//				.selectByPrimaryKey(groupOrder.getPriceId()).getGroupPrice();
//		if(productGroupPrice!=null){
//		
//		ProductGroup groductGroup = productGroupService
//				.getGroupInfoById(productGroupPrice.getGroupId());
//
//		if (groductGroup.getGroupSetting() == 0) {
//
//			ProductGroupSupplierVo supplierVosToSales = productGroupSupplierService
//					.selectProductGroupSupplierVosToSales(
//							productGroupPrice.getGroupId(),
//							groupOrder.getPriceId(), groupOrder.getSupplierId());
//			if (supplierVosToSales == null) {
//				model.addAttribute(
//						"allowNum",
//						productGroupPrice.getStockCount()
//								- productGroupPrice.getReceiveCount());
//			} else {
//				if (supplierVosToSales.getStock() == -1) {
//					model.addAttribute("allowNum",
//							productGroupPrice.getStockCount()
//									- productGroupPrice.getReceiveCount());
//				} else {
//
//					model.addAttribute("allowNum",
//							supplierVosToSales.getStock());
//				}
//			}
//
//		} else {
//			model.addAttribute("allowNum", productGroupPrice.getStockCount()
//					- productGroupPrice.getReceiveCount());
//		}
//		}else{
//			model.addAttribute("allowNum",10000);
//		}
		
		int bizId = WebUtils.getCurBizId(request);
		ToEditGroupOrderResult result=groupOrderFacade.toEditGroupOrder(id,bizId);
		
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("saleEmployeePo", result.getSaleEmployeePo());
		model.addAttribute("operaEmployeePo", result.getOperaEmployeePo());
		model.addAttribute("productInfo", result.getProductInfo());
		model.addAttribute("supplierInfo", result.getSupplierInfo());
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("income", result.getIncome());
		model.addAttribute("budget", result.getBudget());
		model.addAttribute("costList", result.getCostList());
		model.addAttribute("budgetList", result.getBudgetList());
		model.addAttribute("transportList", result.getTransportList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("restaurantList", result.getRestaurantList());
		model.addAttribute("airticketagentList", result.getAirticketagentList());
		model.addAttribute("trainticketagentList", result.getTrainticketagentList());
		model.addAttribute("guestList", result.getGuestList());
		
		model.addAttribute("allowNum",result.getAllowNum());
		model.addAttribute("allCity", result.getCityList());
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
		
		return "sales/groupOrder/editGroupOrder";
	}

	/**
	 * 修改订单信息
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param employeeId
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "editGroupOrder.do", method = RequestMethod.GET)
	@ResponseBody
	public String editGroupOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer employeeId,
			Integer id, Integer num) {

//		PlatformEmployeePo platformEmployeePo = sysPlatformEmployeeFacade
//				.findByEmployeeId(employeeId).getPlatformEmployeePo();
//
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		if (num == 1) {
//			groupOrder.setSaleOperatorId(employeeId);
//			groupOrder.setSaleOperatorName(platformEmployeePo.getName());
//		} else {
//			groupOrder.setOperatorId(employeeId);
//			groupOrder.setOperatorName(platformEmployeePo.getName());
//		}
//		groupOrderService.updateGroupOrder(groupOrder);
//
//		return successJson();
		
		groupOrderFacade.editGroupOrder(id,employeeId,num);
		return successJson();
	}

	/**
	 * 修改订单信息
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param employeeId
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "editSupplierAndReceiveMode.do", method = RequestMethod.GET)
	@ResponseBody
	public String editSupplierAndReceiveMode(String supplierCode,
			String receiveMode, Integer orderId) {
		
//		GroupOrder groupOrder = groupOrderService.findById(orderId);
//		groupOrder.setSupplierCode(supplierCode);
//		groupOrder.setReceiveMode(receiveMode);
//		groupOrderService.updateGroupOrder(groupOrder);
		
		EditSupplierAndReceiveModeDTO editSupplierAndReceiveModeDTO=new EditSupplierAndReceiveModeDTO();
		editSupplierAndReceiveModeDTO.setOrderId(orderId);
		editSupplierAndReceiveModeDTO.setReceiveMode(receiveMode);
		editSupplierAndReceiveModeDTO.setSupplierCode(supplierCode);
		
		groupOrderFacade.editSupplierAndReceiveMode(editSupplierAndReceiveModeDTO);

		return successJson();
	}

	@RequestMapping(value = "editGroupOrderText.do", method = RequestMethod.POST)
	public String editGroupOrderText(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder) {
		
//		groupOrderService.updateGroupOrder(groupOrder);
//		return "redirect:toEditGroupOrder.htm?id=" + groupOrder.getId();
		
		EditGroupOrderDTO editGroupOrderDTO=new EditGroupOrderDTO();
		editGroupOrderDTO.setGroupOrder(groupOrder);
		
		groupOrderFacade.editGroupOrderText(editGroupOrderDTO);
		
		return "redirect:toEditGroupOrder.htm?id=" + groupOrder.getId();
		
	}

	/**
	 * 修改订单联系人信息
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param conId
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "editGroupOrderContMan.do", method = RequestMethod.GET)
	@ResponseBody
	public String editGroupOrderContMan(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer conId,
			Integer id) {
		
//		SupplierContactMan man = supplierService
//				.selectSupplierContactManById(conId);
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		groupOrder.setContactFax(man.getFax());
//		groupOrder.setContactName(man.getName());
//		groupOrder.setContactTel(man.getTel());
//		groupOrder.setContactMobile(man.getMobile());
//		groupOrderService.updateGroupOrder(groupOrder);
		
		groupOrderFacade.editGroupOrderContMan(conId,id);
		
		return successJson();
	}

	/**
	 * 编辑客人信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupRequirement
	 * @return
	 */
	@RequestMapping(value = "editGroupGuest.do", method = RequestMethod.POST)
	@ResponseBody
	public String editGroupGuest(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderGuest groupGuest) {
		
//		if (groupGuest.getId() == null) {
//			groupGuest.setCreateTime(System.currentTimeMillis());
//			groupOrderGuestService.insert(groupGuest);
//			GroupOrder groupOrder = groupOrderService
//					.selectByPrimaryKey(groupGuest.getOrderId());
//
//			ProductGroupPrice productGroupPrice = productGroupPriceService
//					.selectByPrimaryKey(groupOrder.getPriceId())
//					.getGroupPrice();
//			ProductGroup groductGroup = productGroupService
//					.getGroupInfoById(productGroupPrice.getGroupId());
//			if(groupOrder.getPriceId()!=null){
//			boolean updateStock = productGroupPriceService.updateStock(
//					groupOrder.getPriceId(),
//					groductGroup.getGroupSetting() == 0 ? groupOrder
//							.getSupplierId() : null, 1);
//			log.info("编辑订单,新增客人库存状态更新：" + updateStock);
//			}
//
//		} else {
//			groupOrderGuestService.updateByPrimaryKeySelective(groupGuest);
//		}
		
		EditGroupGuestDTO editGroupGuestDTO=new EditGroupGuestDTO();
		editGroupGuestDTO.setGroupGuest(groupGuest);
		
		groupOrderFacade.editGroupGuest(editGroupGuestDTO);
		
		return successJson();
	}

	/**
	 * 根据客人ID获取客人信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toEditGroupGuest.htm", method = RequestMethod.GET)
	@ResponseBody
	public String toEditGroupGuest(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
//		GroupOrderGuest orderGuest = groupOrderGuestService
//				.selectByPrimaryKey(id);
//		Gson gson = new Gson();
//		String json = gson.toJson(orderGuest);
		
		ToEditGroupGuestResult result = groupOrderFacade.toEditGroupGuest(id);
		GroupOrderGuest orderGuest=result.getOrderGuest();
		
		Gson gson = new Gson();
		String json = gson.toJson(orderGuest);
		
		return json;
	}

	/**
	 * 删除客人信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delGroupGuest.do", method = RequestMethod.GET)
	@ResponseBody
	public String delGroupGuest(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {

//		GroupOrderGuest orderGuest = groupOrderGuestService
//				.selectByPrimaryKey(id);
//		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderGuest
//				.getOrderId());
//
//		ProductGroupPrice productGroupPrice = productGroupPriceService
//				.selectByPrimaryKey(groupOrder.getPriceId()).getGroupPrice();
//		ProductGroup groductGroup = productGroupService
//				.getGroupInfoById(productGroupPrice.getGroupId());
//		boolean updateStock = productGroupPriceService.updateStock(
//				groupOrder.getPriceId(),
//				groductGroup.getGroupSetting() == 0 ? groupOrder
//						.getSupplierId() : null, -1);
//		log.info("编辑订单,新增客人库存状态更新：" + updateStock);
//		groupOrderGuestService.deleteByPrimaryKey(id);
		
		groupOrderFacade.delGroupGuest(id);
		
		return successJson();

	}

	/**
	 * 新增计调信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupRequirement
	 * @return
	 */
	@RequestMapping(value = "addGroupRequirement.do", method = RequestMethod.POST)
	@ResponseBody
	public String addGroupRequirement(HttpServletRequest request,
			HttpServletResponse reponse, GroupRequirement groupRequirement) {
		
//		groupRequirement.setCreateTime(System.currentTimeMillis());
//		groupRequirement.setCreatorId(WebUtils.getCurUserId(request));
//		groupRequirement.setCreatorName(WebUtils.getCurUser(request).getName());
//		groupRequirementService.insertSelective(groupRequirement);
		
		AddGroupRequirementDTO addGroupRequirementDTO=new AddGroupRequirementDTO();
		addGroupRequirementDTO.setGroupRequirement(groupRequirement);
		addGroupRequirementDTO.setUserId(WebUtils.getCurUserId(request));
		addGroupRequirementDTO.setUserName(WebUtils.getCurUser(request).getName());
		
		groupOrderFacade.addGroupRequirement(addGroupRequirementDTO);
		
		return successJson();
	}

	/**
	 * 编辑计调信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupRequirement
	 * @return
	 */
	@RequestMapping(value = "editGroupRequirement.do", method = RequestMethod.POST)
	@ResponseBody
	public String editGroupRequirement(HttpServletRequest request,
			HttpServletResponse reponse, GroupRequirement groupRequirement) {
		
		//groupRequirementService.updateByPrimaryKeySelective(groupRequirement);
		AddGroupRequirementDTO addGroupRequirementDTO=new AddGroupRequirementDTO();
		addGroupRequirementDTO.setGroupRequirement(groupRequirement);
		
		groupOrderFacade.editGroupRequirement(addGroupRequirementDTO);
		
		return successJson();
	}

	/**
	 * 根据ID获取计调信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toEditGroupRequirement.htm", method = RequestMethod.GET)
	@ResponseBody
	public String toEditGroupRequirement(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
//		GroupRequirement requirement = groupRequirementService
//				.selectByPrimaryKey(id);
//		Gson gson = new Gson();
//		String json = gson.toJson(requirement);
//		log.info(json);
		
		ToEditGroupRequirementResult result = groupOrderFacade.toEditGroupRequirement(id);
		GroupRequirement requirement = result.getRequirement();
		Gson gson = new Gson();
		String json = gson.toJson(requirement);
		
		return json;

	}

	/**
	 * 删除计调信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delGroupRequirement.do", method = RequestMethod.GET)
	@ResponseBody
	public String delGroupRequirement(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
		//groupRequirementService.deleteByPrimaryKey(id);
		groupOrderFacade.delGroupRequirement(id);
		
		return successJson();

	}

	/**
	 * 新增接送信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderTransport
	 * @return
	 */
	@RequestMapping(value = "addManyGroupOrderTransport.do", method = RequestMethod.POST)
	@ResponseBody
	public String addManyGroupOrderTransport(HttpServletRequest request,
			HttpServletResponse reponse, TransportVO transportVO) {
		
//		if (transportVO.getGroupOrderTransportList() != null
//				&& transportVO.getGroupOrderTransportList().size() > 0) {
//			List<GroupOrderTransport> list = transportVO
//					.getGroupOrderTransportList();
//			for (GroupOrderTransport groupOrderTransport2 : list) {
//				groupOrderTransport2.setCreateTime(System.currentTimeMillis());
//				groupOrderTransportService
//						.insertSelective(groupOrderTransport2);
//			}
//		}
		
		AddManyGroupOrderTransportDTO addManyGroupOrderTransportDTO=new AddManyGroupOrderTransportDTO();
		addManyGroupOrderTransportDTO.setTransportVO(transportVO);
		
		groupOrderFacade.addManyGroupOrderTransport(addManyGroupOrderTransportDTO);
		
		return successJson();
	}

	/**
	 * 批量新增接送信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderTransport
	 * @return
	 */
	@RequestMapping(value = "addGroupOrderTransport.do", method = RequestMethod.POST)
	@ResponseBody
	public String addGroupOrderTransport(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderTransport groupOrderTransport) {
		
//		groupOrderTransport.setCreateTime(System.currentTimeMillis());
//		groupOrderTransportService.insertSelective(groupOrderTransport);
		
		AddGroupOrderTransportDTO addGroupOrderTransport=new AddGroupOrderTransportDTO();
		addGroupOrderTransport.setGroupOrderTransport(groupOrderTransport);
		
		groupOrderFacade.addGroupOrderTransport(addGroupOrderTransport);
		
		return successJson();
	}

	/**
	 * 编辑接送信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderTransport
	 * @return
	 */
	@RequestMapping(value = "editGroupOrderTransport.do", method = RequestMethod.POST)
	@ResponseBody
	public String editGroupOrderTransport(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderTransport groupOrderTransport) {
		
//		groupOrderTransportService
//				.updateByPrimaryKeySelective(groupOrderTransport);
		
		AddGroupOrderTransportDTO addGroupOrderTransport=new AddGroupOrderTransportDTO();
		addGroupOrderTransport.setGroupOrderTransport(groupOrderTransport);
		
		groupOrderFacade.editGroupOrderTransport(addGroupOrderTransport);
		
		return successJson();
	}

	/**
	 * 根据价格ID返回接送信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toEditGroupOrderTransport.htm", method = RequestMethod.GET)
	@ResponseBody
	public String toEditGroupOrderTransport(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
//		GroupOrderTransport orderTransport = groupOrderTransportService
//				.selectByPrimaryKey(id);
//		//Gson gson = new Gson();
//		
//		String json = JSON.toJSONString(orderTransport);
//		log.info("编辑接送信息" + json);
		
		ToEditGroupOrderTransportResult result=groupOrderFacade.toEditGroupOrderTransport(id);
		GroupOrderTransport orderTransport = result.getOrderTransport();
		
		String json = JSON.toJSONString(orderTransport);
		
		return json;
	}

	/**
	 * 删除接送信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delGroupOrderTransport.do", method = RequestMethod.GET)
	@ResponseBody
	public String delGroupOrderTransport(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		//groupOrderTransportService.deleteByPrimaryKey(id);
		groupOrderFacade.delGroupOrderTransport(id);
		
		return successJson();
	}

	/**
	 * 新增价格信息[弹出]
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderPrice
	 * @return
	 */
	@RequestMapping(value = "addGroupOrderPrice.do", method = RequestMethod.POST)
	@ResponseBody
	public String addGroupOrderPrice(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderPrice groupOrderPrice) {
		
//		groupOrderPrice.setCreateTime(System.currentTimeMillis());
//		groupOrderPrice.setRowState(0);
//		groupOrderPrice.setItemName(dicService.getById(
//				groupOrderPrice.getItemId() + "").getValue());
//		groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
//		groupOrderPrice.setCreatorName(WebUtils.getCurUser(request).getName());
//		groupOrderPriceService.insertSelective(groupOrderPrice);
		
		AddGroupOrderPriceDTO addGroupOrderPriceDTO=new AddGroupOrderPriceDTO();
		addGroupOrderPriceDTO.setGroupOrderPrice(groupOrderPrice);
		addGroupOrderPriceDTO.setUserId(WebUtils.getCurUserId(request));
		addGroupOrderPriceDTO.setUserName(WebUtils.getCurUser(request).getName());
		
		groupOrderFacade.addGroupOrderPrice(addGroupOrderPriceDTO);
		
		return successJson();
	}

	/**
	 * 新增价格信息[加列,批量]
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderPrice
	 * @return
	 */
	@RequestMapping(value = "addGroupOrderPriceMany.do", method = RequestMethod.POST)
	@ResponseBody
	public String addGroupOrderPriceMany(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderPriceVO groupOrderPriceVO) {

//		List<GroupOrderPrice> groupOrderPriceList = groupOrderPriceVO
//				.getGroupOrderPriceList();
//		for (GroupOrderPrice groupOrderPrice : groupOrderPriceList) {
//			groupOrderPrice.setCreateTime(System.currentTimeMillis());
//			groupOrderPrice.setRowState(0);
//			groupOrderPrice.setItemName(dicService.getById(
//					groupOrderPrice.getItemId() + "").getValue());
//			groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
//			groupOrderPrice.setCreatorName(WebUtils.getCurUser(request)
//					.getName());
//			groupOrderPriceService.insertSelective(groupOrderPrice);
//		}
		
		AddGroupOrderPriceManyDTO addGroupOrderPriceManyDTO=new AddGroupOrderPriceManyDTO();
		addGroupOrderPriceManyDTO.setGroupOrderPriceVO(groupOrderPriceVO);
		addGroupOrderPriceManyDTO.setUserId(WebUtils.getCurUserId(request));
		addGroupOrderPriceManyDTO.setUserName(WebUtils.getCurUser(request).getName());
		
		groupOrderFacade.addGroupOrderPriceMany(addGroupOrderPriceManyDTO);
		
		return successJson();
	}

	/**
	 * 编辑价格信息
	 * 
	 * @param request
	 * @param reponse
	 * @param groupOrderPrice
	 * @return
	 */
	@RequestMapping(value = "editGroupOrderPrice.do", method = RequestMethod.POST)
	@ResponseBody
	public String editGroupOrderPrice(HttpServletRequest request,
			HttpServletResponse reponse, GroupOrderPrice groupOrderPrice) {
		
//		if (groupOrderPrice.getItemId() != null) {
//			groupOrderPrice.setItemName(dicService.getById(
//					groupOrderPrice.getItemId() + "").getValue());
//		}
//		groupOrderPriceService.updateByPrimaryKeySelective(groupOrderPrice);
		
		AddGroupOrderPriceDTO addGroupOrderPriceDTO=new AddGroupOrderPriceDTO();
		addGroupOrderPriceDTO.setGroupOrderPrice(groupOrderPrice);
		groupOrderFacade.editGroupOrderPrice(addGroupOrderPriceDTO);
		
		return successJson();
	}

	/**
	 * 删除价格信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delOrderPrice.do", method = RequestMethod.GET)
	@ResponseBody
	public String delOrderPrice(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
		//groupOrderPriceService.deleteByPrimaryKey(id);
		groupOrderFacade.delOrderPrice(id);
		
		return successJson();
	}

	/**
	 * 根据价格ID返回价格信息
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toEditGroupOrderPrice.htm", method = RequestMethod.GET)
	@ResponseBody
	public String toEditGroupOrderPrice(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
//		GroupOrderPrice groupOrderPrice = groupOrderPriceService
//				.selectByPrimaryKey(id);
//		Gson gson = new Gson();
//		String json = gson.toJson(groupOrderPrice);
		
		ToEditGroupOrderPriceResult result=groupOrderFacade.toEditGroupOrderPrice(id);
		GroupOrderPrice groupOrderPrice = result.getGroupOrderPrice();
		
		Gson gson = new Gson();
		String json = gson.toJson(groupOrderPrice);
		
		return json;
	}

	/**
	 * 订单打印
	 * 
	 * @param orderId
	 * @param request
	 * @param response
	 */
	@RequestMapping("download.htm")
	public void downloadFile(Integer groupId, Integer num,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			// 处理中文文件名下载乱码
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		String path = "";
		String fileName = "";
		if (num == 1) {
			// 打印散客团
			path = createIndividual(request, groupId);
			try {
				fileName = new String("散客计调单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		} else if (num == 2) {
			try {
				fileName = new String("客人名单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createGuestNames(request, groupId);
		} else if (num == 3) {
			try {
				fileName = new String("游客意见反馈单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createtTickling(request, groupId);
		} else if (num == 4) {
			try {
				fileName = new String("散客购物明细单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createShoppingDetail(request, groupId);
		} else if (num == 5) {
			try {
				fileName = new String("散客导游单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createSKGuide(request, groupId);
		} else if (num == 6) {
			try {
				fileName = new String("客人名单接送.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createSKGuideUpOff(request, groupId);
		}else if (num == 7) {
			try {
				fileName = new String("游客意见反馈单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createtOrderTickling(request, groupId);
		}else if (num == 8) {
			try {
				fileName = new String("散客购物明细单2.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createShoppingDetail2(request, groupId);
		} 

		response.setCharacterEncoding("utf-8");
		response.setContentType("application/msword"); // word格式
		try {
			response.setHeader("Content-Disposition", "attachment; filename="
					+ fileName);
			File file = new File(path);
			InputStream inputStream = new FileInputStream(file);
			OutputStream os = response.getOutputStream();
			byte[] b = new byte[10240];
			int length;
			while ((length = inputStream.read(b)) > 0) {
				os.write(b, 0, length);
			}
			inputStream.close();
			file.delete();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 游客意见反馈表预览
	 * @param request
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toIndividualGuestTickling.htm")
	public String toIndividualGuestTickling(HttpServletRequest request,Integer groupId,
			Model model) {
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = order.getNumAdult();
//			Integer numChild = order.getNumChild();
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//					+ (numChild == null ? 0 : numChild) + "小");
//			gops.add(gop);
//		}
//		List<Integer> list = new ArrayList<Integer>() ;
//		for (int i = 0; i < 5; i++) {
//			list.add(i) ;
//		}
//		model.addAttribute("groupMode", tg.getGroupMode());
//		model.addAttribute("list", list);
//		model.addAttribute("gops", gops);
//		model.addAttribute("groupCode", tg.getGroupCode());
//		model.addAttribute("totalNum", tg.getTotalAdult()+"大"+tg.getTotalChild()+ "小");
//		model.addAttribute("guide", guideString);
//		model.addAttribute("imgPath", imgPath);
//		model.addAttribute("groupId", groupId);
//		model.addAttribute("productName","【"+ tg.getProductBrandName()+ "】"+ (tg.getProductName() == null ? "" : tg
//								.getProductName()));
		
		String imgPath = settingCommon.getMyBizLogo(request);
		
		ToIndividualGuestTicklingResult result=groupOrderFacade.toIndividualGuestTickling(groupId);
		
		TourGroup tg = result.getTg();
		
		model.addAttribute("groupMode", tg.getGroupMode());
		model.addAttribute("list", result.getList());
		model.addAttribute("gops", result.getGops());
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("totalNum", tg.getTotalAdult()+"大"+tg.getTotalChild()+ "小");
		model.addAttribute("guide", result.getGuideString());
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("groupId", groupId);
		model.addAttribute("productName","【"+ tg.getProductBrandName()+ "】"+ (tg.getProductName() == null ? "" : tg.getProductName()));
		
		return "sales/preview/individual_guest_tickling";
	}
	
	
	/**
	 * 散客订单-游客意见反馈表预览
	 * @param request
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toIndividualOrderGuestTickling.htm")
	public String toIndividualOrderGuestTickling(HttpServletRequest request,Integer orderId,
			Model model) {
		
//		GroupOrder go = groupOrderService.selectByPrimaryKey(orderId) ;
//		TourGroup tg = new TourGroup() ;
//		List<BookingGuide> guides = new ArrayList<BookingGuide>();
//		String guideString = "";
//		if(go!=null&&go.getGroupId()!=null){
//			tg = tourGroupService.selectByPrimaryKey(go.getGroupId());
//			guides = bookingGuideService
//					.selectGuidesByGroupId(go.getGroupId());
//			if (guides.size() > 0) {
//				guideString = getGuides(guides);
//			}
//		}
//		
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		
//		GroupOrderPrintPo gop = new GroupOrderPrintPo() ;
//		gop = new GroupOrderPrintPo();
//		gop.setReceiveMode(go.getReceiveMode());
//		gop.setPersonNum((go.getNumAdult() == null ? 0 : go.getNumAdult()) + "大"
//				+ (go.getNumChild() == null ? 0 : go.getNumChild()) + "小");
//		model.addAttribute("groupMode", tg.getGroupMode());
//		model.addAttribute("groupCode", tg.getGroupCode());
//		model.addAttribute("totalNum", tg.getTotalAdult()+"大"+tg.getTotalChild()+ "小");
//		model.addAttribute("guide", guideString);
//		model.addAttribute("imgPath", imgPath);
//		model.addAttribute("groupId", orderId);
//		model.addAttribute("gop", gop);
//		model.addAttribute("productName","【"+ tg.getProductBrandName()+ "】"+ (tg.getProductName() == null ? "" : tg
//								.getProductName()));
		
		String imgPath = settingCommon.getMyBizLogo(request);
		
		ToIndividualOrderGuestTicklingResult result=groupOrderFacade.toIndividualOrderGuestTickling(orderId);
		
		TourGroup tg = result.getTg();
		
		model.addAttribute("groupMode", tg.getGroupMode());
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("totalNum", tg.getTotalAdult()+"大"+tg.getTotalChild()+ "小");
		model.addAttribute("guide", result.getGuideString());
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("groupId", orderId);
		model.addAttribute("gop", result.getGop());
		model.addAttribute("productName","【"+ tg.getProductBrandName()+ "】"+ (tg.getProductName() == null ? "" : tg.getProductName()));
		
		return "sales/preview/individual_order_guest_tickling";
	}
	
	/**
	 * 客人名单-接送
	 * 
	 * @param request
	 * @param groupId
	 * @return
	 */
	public String createSKGuideUpOff(HttpServletRequest request, Integer groupId) {
		
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		// 查询导游信息
//		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		String driverString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//			driverString = getDrivers(guides);
//		}
//		//预定车信息
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		StringBuilder sbsb = new StringBuilder() ;
//		for (BookingSupplier bs : bookingSuppliers) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			for (BookingSupplierDetail bsd : details) {
//				sbsb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//			}
//		}
//		driverString = sbsb.toString() ;
//		List<GroupOrder> orders = groupOrderService.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gopp = null;
//		// 房量总计
//		String total = getHotelTotalNum(orders);
//		for (GroupOrder order : orders) {
//			// 拿到单条订单信息
//			gopp = new GroupOrderPrintPo();
//			gopp.setPlace((order.getProvinceName() == null ? "" : order
//					.getProvinceName())
//					+ (order.getCityName() == null ? "" : order.getCityName()));
//			gopp.setRemark(order.getRemarkInternal());
//			
//			// 根据散客订单统计客人信息
//			List<GroupOrderGuest> guests = groupOrderGuestService.selectByOrderId(order.getId());
//			gopp.setGuesStatic(order.getReceiveMode());
//			gopp.setGuestInfo(getGuestInfo2(guests));
//
//			gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
//			
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService.selectByOrderAndType(order.getId(), 3);
//			StringBuilder sb = new StringBuilder();
//			for (GroupRequirement gsl : grogShopList) {
//				if (gsl.getHotelLevel() != null) {
//					sb.append(dicService.getById(gsl.getHotelLevel()).getValue() + "\n");
//				}
//			}
//			gopp.setHotelLevel(sb.toString());
//			gopp.setHotelNum(getHotelNum(grogShopList));
//			
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService.selectByOrderId(order.getId());
//			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
//			// 根据散客订单统计送机信息
//			gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
//			// 省内交通
//			gopp.setTrans(getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}
		
		CreateSKGuideUpOffResult result=groupOrderFacade.createSKGuideUpOff(groupId);
		TourGroup tourGroup=result.getTourGroup();
		String guideString = result.getGuideString();
		String driverString = result.getDriverString();
		List<GroupOrderPrintPo> gopps=result.getGopps();
		String total=result.getTotal();
		
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/guestName_Up_Off.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}

		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tourGroup.getGroupCode());
		map0.put("operator", tourGroup.getOperatorName());
		if (null != tourGroup.getDateStart()) {
			map0.put("startTime", DateUtils.format(tourGroup.getDateStart()));
		} else {
			map0.put("startTime", "");
		}
		map0.put("guide", guideString);
		map0.put("driver", driverString);
		map0.put("totalPersons",tourGroup.getTotalAdult() + "大" + tourGroup.getTotalChild()+ "小");
		map0.put("productBrandName",(tourGroup.getProductBrandName()==null?"":tourGroup.getProductBrandName()));
		map0.put("productName",(tourGroup.getProductName()==null?"":tourGroup.getProductName()));
		/**
		 * 第二个表格
		 */
		List<Map<String, String>> orderList = new ArrayList<Map<String, String>>();
		int i = 1;
		for (GroupOrderPrintPo po : gopps) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("num", "" + i++);
			map.put("guestStatic", po.getGuesStatic());
			map.put("personNum", po.getPersonNum());
			map.put("place", po.getPlace());
			map.put("hotelLevel", po.getHotelLevel());
			map.put("hotelNum", po.getHotelNum());
			map.put("up", po.getAirPickup());
			map.put("off", po.getAirOff());
			map.put("trans", po.getTrans());
			map.put("guestInfo", po.getGuestInfo());
			map.put("remark", po.getRemark());
			orderList.add(map);
		}
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("total", total);
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(orderList, 1);
			export.export(map1, 2);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 散客导游单
	 * 
	 * @param request
	 * @param groupId
	 * @return
	 */
	public String createSKGuide(HttpServletRequest request, Integer groupId) {
		
//		Map<String, Object> datas = bookingSupplierService.selectBookingInfo(groupId, 1);
//		
//		String realPath = "";
//		String url = request.getSession().getServletContext().getRealPath("/")
//				+ "/download/" + System.currentTimeMillis() + ".doc";
//		
//		// 查询导游信息
//		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
//		String guideString = getGuides(guides);
//		String driverString = getDrivers(guides);
//		
//		//预定车信息
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		StringBuilder sbsb = new StringBuilder() ;
//		for (BookingSupplier bs : bookingSuppliers) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			for (BookingSupplierDetail bsd : details) {
//				sbsb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//			}
//		}
//		driverString = sbsb.toString() ;
//		// 团信息
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		
//		/**
//		 * 获取全陪，定制团一个团对应一个订单
//		 */
//		List<GroupOrder> orders = groupOrderService.selectOrderByGroupId(tourGroup.getId());
//		GroupOrder order = orders.get(0);
//		
//		realPath = request.getSession().getServletContext().getRealPath("/template/guide_Individual.docx");
//		WordReporter export = new WordReporter(realPath);
//		try {
//			export.init();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//		
//		/**
//		 * logo图片
//		 */
//		String imgPath = settingCommon.getMyBizLogo(request);
//		Map<String, Object> params1 = new HashMap<String, Object>();
//		params1.put("print_time",com.yihg.erp.utils.DateUtils.format(new Date()));
//		
//		if (imgPath != null) {
//			Map<String, String> picMap = new HashMap<String, String>();
//			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
//			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
//			picMap.put("type", "jpg");
//			picMap.put("path", imgPath);
//			params1.put("logo", picMap);
//		} else {
//			params1.put("logo", "");
//		}
//		params1.put("printName", WebUtils.getCurUser(request).getName());
//		params1.put("printTime", DateUtils.format(new Date()));
//		
//		/**
//		 * 第一个表格
//		 */
//		Map<String, Object> map1 = new HashMap<String, Object>();
//		map1.put("groupCode", tourGroup.getGroupCode());
//		map1.put("operator", tourGroup.getOperatorName());
//		if (null != tourGroup.getDateStart()) {
//			map1.put("startTime", DateUtils.format(tourGroup.getDateStart()));
//		} else {
//			map1.put("startTime", "");
//		}
//		map1.put("guide", guideString);
//		map1.put("driver", driverString);
//		map1.put("totalNum",tourGroup.getTotalAdult() + "大" + tourGroup.getTotalChild()+ "小");
//		map1.put("productBrandName", tourGroup.getProductBrandName());
//		map1.put("productName", tourGroup.getProductName());
//
//		GroupRouteVO groupRouteVO = groupRouteService.findGroupRouteByGroupId(groupId);
//		List<GroupRouteDayVO> routeDayVOList = groupRouteVO.getGroupRouteDayVOList();
//		
//		/**
//		 * 行程列表表格
//		 */
//		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
//		for (GroupRouteDayVO groupRoute : routeDayVOList) {
//			Map<String, String> map = new HashMap<String, String>();
//			if (null != groupRoute.getGroupRoute().getGroupDate()) {
//				map.put("day_num", DateUtils.format(groupRoute.getGroupRoute().getGroupDate()));
//			} else {
//				map.put("day_num", "");
//			}
//			map.put("route_desp", groupRoute.getGroupRoute().getRouteDesp());
//			map.put("breakfast", groupRoute.getGroupRoute().getBreakfast());
//			map.put("lunch", groupRoute.getGroupRoute().getLunch());
//			map.put("supper", groupRoute.getGroupRoute().getSupper());
//			map.put("hotel_name", groupRoute.getGroupRoute().getHotelName());
//			routeList.add(map);
//		}
//		
//		/**
//		 * 酒店信息
//		 */
//		List<Map<String, String>> hotelList = new ArrayList<Map<String, String>>();
//		List<BookingSupplier> hlList = bookingSupplierService.getHotelInfoByGroupId(groupId) ;
//		for (BookingSupplier bs : hlList) {
//			SupplierInfo supplierInfo = supplierInfoService.selectBySupplierId(bs.getSupplierId()) ;
//			bs.setCityName(supplierInfo.getCityName());
//		}
//		int i =1 ;
//		for (BookingSupplier bs : hlList) {
//			Map<String, String> map = new HashMap<String, String>();
//			map.put("bookingDate", ""+i++);
//			map.put("cityName", bs.getCityName());
//			map.put("supplierName", bs.getSupplierName());
//			map.put("hotelNumStatic", bs.getHotelNumStatic().replace(",", "\n"));
//			map.put("contact", bs.getContact());
//			map.put("cashType", bs.getCashType());
//			hotelList.add(map) ;
//		}
//		
//		List<Map<String, String>> orderList = null;
//		List<GroupOrder> orders1 = groupOrderService.selectOrderByGroupId(tourGroup.getId());
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gopp = null;
//		for (GroupOrder order1 : orders1) {
//			// 拿到单条订单信息
//			gopp = new GroupOrderPrintPo();
//			gopp.setRemark(order1.getRemarkInternal());
//			gopp.setPlace((order1.getProvinceName() == null ? "" : order1
//					.getProvinceName())
//					+ (order1.getCityName() == null ? "" : order1.getCityName()));
//			// 根据散客订单统计人数order1
//			Integer numAdult = groupOrderGuestService.selectNumAdultByOrderID(order1.getId());
//			Integer numChild = groupOrderGuestService.selectNumChildByOrderID(order1.getId());
//			gopp.setPersonNum((numAdult == null ? "" : numAdult) + "+" + (numChild == null ? "" : numChild));
//			
//			// 根据散客订单统计客人信息
//			List<GroupOrderGuest> guests = groupOrderGuestService.selectByOrderId(order1.getId());
//			gopp.setGuesStatic(order1.getReceiveMode());
//			gopp.setGuestInfo(getGuestInfo2(guests));
//
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService.selectByOrderAndType(order1.getId(), 3);
//			StringBuilder sb = new StringBuilder();
//			for (GroupRequirement gsl : grogShopList) {
//				if (gsl.getHotelLevel() != null) {
//					sb.append(dicService.getById(gsl.getHotelLevel()).getValue() + "\n");
//				}
//			}
//			gopp.setHotelLevel(sb.toString());
//			gopp.setHotelNum(getHotelNum(grogShopList));
//			
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService.selectByOrderId(order1.getId());
//			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
//			
//			// 根据散客订单统计送机信息
//			gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
//			
//			// 省内交通
//			gopp.setTrans(getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}
//		orderList = new ArrayList<Map<String, String>>();
//		int x = 1;
//		for (GroupOrderPrintPo po1 : gopps) {
//			Map<String, String> map = new HashMap<String, String>();
//			map.put("num", "" + x++);
//			map.put("guestStatic", po1.getGuesStatic());
//			map.put("personNum", po1.getPersonNum());
//			map.put("place", po1.getPlace());
//			map.put("hotelLevel", po1.getHotelLevel());
//			map.put("hotelNum", po1.getHotelNum());
//			map.put("up", po1.getAirPickup());
//			map.put("off", po1.getAirOff());
//			map.put("trans", po1.getTrans());
//			map.put("guestInfo", po1.getGuestInfo());
//			map.put("remark", po1.getRemark());
//			orderList.add(map);
//		}
//
//		/**
//		 * 计调信息
//		 */
//		List<GroupGuidePrintPo> pos = new ArrayList<GroupGuidePrintPo>();
//		GroupGuidePrintPo po = null;
//		// 预定下接社信息
//		List<Map<String, String>> mapList = new ArrayList<Map<String, String>>();
//		List<BookingDelivery> deliveries = deliveryService.getDeliveryListByGroupId(tourGroup.getId());
//		for (BookingDelivery bd : deliveries) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("下接社");
//			po.setSupplierName(bd.getSupplierName());
//			po.setContacktWay(bd.getContact() + "-" + bd.getContactMobile());
//			po.setPaymentWay("");
//			String dd = "";
//			if (bd.getDateArrival() != null) {
//				dd = com.yihg.erp.utils.DateUtils.format(bd.getDateArrival());
//			}
//			po.setDetail(dd + " " + "人数：" + bd.getPersonAdult() + "大" + bd.getPersonChild() + "小" + bd.getPersonGuide() + "陪");
//			pos.add(po);
//		}
//		
//		/*// 预定购物
//		List<BookingShop> shops = shopService.getShopListByGroupId(tourGroup
//				.getId());
//		for (BookingShop bs : shops) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("购物店");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay("");
//			po.setPaymentWay("");
//			po.setDetail(bs.getShopDate());
//			pos.add(po);
//		}*/
//		
//		/**
//		 * 预订房信息
//		 */
//		List<BookingSupplier> bs3 = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(),3);
//		for (BookingSupplier bs : bs3) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("房");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact() + "-" + bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId());
//			StringBuilder sb = new StringBuilder();
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "";
//				if (bsd.getItemDate() != null) {
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate());
//				}
//				sb.append(dd+
//						" 【"+bsd.getType1Name()+"】 "+
//						"("+bsd.getItemNum().toString().replace(".0","")+
//						"-"+bsd.getItemNumMinus().toString().replace(".0","")+")" +"\n");
//			}
//			po.setDetail(sb.toString());
//			pos.add(po);
//		}
//		
//		/**
//		 * 预定车信息
//		 */
//		List<BookingSupplier> bs4 = bookingSupplierService
//				.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(),
//						4);
//		for (BookingSupplier bs : bs4) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId());
//			StringBuilder sb = new StringBuilder();
//			for (BookingSupplierDetail bsd : details) {
//				po = new GroupGuidePrintPo();
//				po.setSupplierType("司机");
//				po.setSupplierName(bsd.getDriverName());
//				po.setContacktWay(bsd.getDriverTel());
//				po.setPaymentWay(bs.getCashType());
//				sb.append(bsd.getType1Name() + "," + bsd.getType2Name() + "座"
//						+ "," + bsd.getCarLisence() + "," + "价格："
//						+ bsd.getItemPrice());
//				if (bs.getRemark() != "" && bs.getRemark() != null) {
//					sb.append(",备注：" + bs.getRemark());
//				}
//				po.setDetail(sb.toString());
//				pos.add(po);
//			}
//		}
//		/**
//		 * 预定景区信息
//		 */
//		/*List<BookingSupplier> bs5 = bookingSupplierService
//				.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(),
//						5);
//		for (BookingSupplier bs : bs5) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("景区");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact() + "-" + bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService
//					.selectByPrimaryBookId(bs.getId());
//			StringBuilder sb = new StringBuilder();
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "";
//				if (bsd.getItemDate() != null) {
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate());
//				}
//				sb.append(dd + " 【" + bsd.getType1Name() + "】 "
//						+ bsd.getItemPrice().toString().replace(".0", "")
//						+ "*(" + bsd.getItemNum().toString().replace(".0", "")
//						+ "-"
//						+ bsd.getItemNumMinus().toString().replace(".0", "")
//						+ ")");
//			}
//			po.setDetail(sb.toString());
//
//			pos.add(po);
//		}*/
//		/**
//		 * 组织打印数据
//		 */
//		for (GroupGuidePrintPo ggp : pos) {
//			Map<String, String> map = new HashMap<String, String>();
//			map.put("supplierType", ggp.getSupplierType());
//			map.put("supplierName", ggp.getSupplierName());
//			map.put("contactWay", ggp.getContacktWay());
//			map.put("paymentWay", ggp.getPaymentWay());
//			map.put("detail", ggp.getDetail());
//			mapList.add(map);
//		}
//		
//		/**
//		 * 备注信息
//		 */
//		Map<String, Object> map2 = new HashMap<String, Object>();
//		map2.put("remarkInternal", tourGroup.getRemarkInternal());
//		
//		try {
//			export.export(params1);
//			export.export(map1, 0);
//			export.export(routeList, 1);
//			export.export(hotelList, 2);
//			export.export(orderList, 3);
//			export.export(mapList, 4);
//			export.export(map2, 5);
//			export.generate(url);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		
//		return url;
		
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/guide_Individual.docx");
		
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		/**
		 * logo图片
		 */
		String imgPath = settingCommon.getMyBizLogo(request);
		
		CreateSKGuideResult result=groupOrderFacade.createSKGuide(groupId,imgPath,WebUtils.getCurUser(request).getName());
		
		try {
			export.export(result.getParams1());
			export.export(result.getMap1(), 0);
			export.export(result.getRouteList(), 1);
			export.export(result.getHotelList(), 2);
			export.export(result.getOrderList(), 3);
			export.export(result.getMapList(), 4);
			export.export(result.getMap2(), 5);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return url;
	}

	/**
	 * 购物明细预览页面
	 * @param request
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toShoppingDetailPreview.htm")
	public String toShoppingDetailPreview(HttpServletRequest request,
			Integer groupId,Model model) {
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = groupOrderGuestService
//					.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService
//					.selectNumChildByOrderID(order.getId());
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//					+ (numChild == null ? 0 : numChild) + "小");
//			gop.setPlace(order.getProvinceName() + order.getCityName());
//			gops.add(gop);
//		}
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		
//		model.addAttribute("printTime", DateUtils.format(new Date()));
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
//		model.addAttribute("groupCode", tg.getGroupCode());
//		model.addAttribute("imgPath", imgPath);
//		model.addAttribute("groupId", groupId);
//		model.addAttribute("groupCode", tg.getGroupCode());
//		model.addAttribute("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()
//				+ "小");
//		model.addAttribute("guide", guideString);
//		model.addAttribute(
//				"productName",
//				"【"
//						+ tg.getProductBrandName()
//						+ "】"
//						+ (tg.getProductName() == null ? "" : tg
//								.getProductName()));
//		model.addAttribute("gops",gops) ;
		
		String imgPath = settingCommon.getMyBizLogo(request);
		
		ToShoppingDetailPreviewResult result=groupOrderFacade.toShoppingDetailPreview(groupId);
		
		TourGroup tg = result.getTg();
		
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()
				+ "小");
		model.addAttribute("guide", result.getGuideString());
		model.addAttribute(
				"productName",
				"【"
						+ tg.getProductBrandName()
						+ "】"
						+ (tg.getProductName() == null ? "" : tg
								.getProductName()));
		model.addAttribute("gops",result.getGops()) ;
		
		return "sales/preview/individual_shopping_detail";
	}
	
	/**
	 * 散客购物明细表
	 * 
	 * @param request
	 * @param groupId
	 * @return
	 */
	public String createShoppingDetail(HttpServletRequest request,
			Integer groupId) {
		
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = groupOrderGuestService
//					.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService
//					.selectNumChildByOrderID(order.getId());
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//					+ (numChild == null ? 0 : numChild) + "小");
//			gop.setPlace(order.getProvinceName() + order.getCityName());
//			gops.add(gop);
//		}
		
		CreateShoppingDetailResult result=groupOrderFacade.createShoppingDetail(groupId,WebUtils.getCurUser(request).getName());
		TourGroup tg = result.getTg();
		List<GroupOrderPrintPo> gops = result.getGops();
		String guideString = result.getGuideString();
		
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/individual_shopping_detail.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", tg.getGroupCode());
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tg.getGroupCode());
		map0.put("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()
				+ "小");
		map0.put("guide", guideString);
		map0.put(
				"productName",
				"【"
						+ tg.getProductBrandName()
						+ "】"
						+ (tg.getProductName() == null ? "" : tg
								.getProductName()));
		/**
		 * 客人信息
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		int i = 1;
		for (GroupOrderPrintPo po : gops) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("n", "" + i++);
			map.put("rm", po.getReceiveMode());
			map.put("pn", po.getPersonNum());
			map.put("p", po.getPlace());
			map.put("zg", "");
			map.put("rj", "");
			map.put("yd", "");
			map.put("fc", "");
			map.put("y", "");
			map.put("c", "");
			map.put("hly", "");
			map.put("qt", "");
			map.put("bz", "");
			guestList.add(map);
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(guestList, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 购物明细预览页面2
	 * @param request
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toShoppingDetailPreview2.htm")
	public String toShoppingDetailPreview1(HttpServletRequest request,
			Integer groupId,Model model) {
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = groupOrderGuestService
//					.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService
//					.selectNumChildByOrderID(order.getId());
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//					+ (numChild == null ? 0 : numChild) + "小");
//			gop.setPlace(order.getProvinceName() + order.getCityName());
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			gop.setGuestInfo(getGuestInfo2(guests));
//			gop.setGuests(guests);
//			gops.add(gop);
//		}
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		model.addAttribute("printTime", DateUtils.format(new Date()));
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
//		model.addAttribute("groupCode", tg.getGroupCode());
//		model.addAttribute("imgPath", imgPath);
//		model.addAttribute("groupId", groupId);
//		model.addAttribute("groupCode", tg.getGroupCode());
//		model.addAttribute("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()
//				+ "小");
//		model.addAttribute("guide", guideString);
//		model.addAttribute(
//				"productName",
//				"【"
//						+ tg.getProductBrandName()
//						+ "】"
//						+ (tg.getProductName() == null ? "" : tg
//								.getProductName()));
//		model.addAttribute("gops",gops) ;
		
		String imgPath = settingCommon.getMyBizLogo(request);

		ToShoppingDetailPreviewResult result = groupOrderFacade.toShoppingDetailPreview1(groupId,
				WebUtils.getCurUser(request).getName());
		
		TourGroup tg = result.getTg();
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()+ "小");
		model.addAttribute("guide", result.getGuideString());
		model.addAttribute(
				"productName",
				"【"
						+ tg.getProductBrandName()
						+ "】"
						+ (tg.getProductName() == null ? "" : tg
								.getProductName()));
		model.addAttribute("gops",result.getGops()) ;
		
		return "sales/preview/individual_shopping_detail2";
	}
	
	//废代码 by gtp
//	public List<GroupOrderGuest> getGuestList(String guestInfo) {
//		
//		
//		return null;
//	}
	
	/**
	 * 散客购物明细表2
	 * 
	 * @param request
	 * @param groupId
	 * @return
	 */
	//@SuppressWarnings("unchecked")
	public String createShoppingDetail2(HttpServletRequest request, Integer groupId) {
		
		String url = request.getSession().getServletContext().getRealPath("/") 
				+ "/download/" + System.currentTimeMillis() + ".doc";
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		List<GroupOrder> orders = groupOrderService.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = groupOrderGuestService.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService.selectNumChildByOrderID(order.getId());
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大" + (numChild == null ? 0 : numChild) + "小");
//			gop.setPlace(order.getProvinceName() + order.getCityName());
//			List<GroupOrderGuest> guests = groupOrderGuestService.selectByOrderId(order.getId());
//			gop.setGuestInfo(getGuestInfo3(guests));
//			gop.setGuests(guests);
//			gops.add(gop);
//		}
		
		CreateShoppingDetailResult result=groupOrderFacade.createShoppingDetail2(groupId,WebUtils.getCurUser(request).getName());
		TourGroup tg = result.getTg();
		List<GroupOrderPrintPo> gops = result.getGops();
		String guideString = result.getGuideString();
		
		String realPath = request.getSession().getServletContext().getRealPath("/template/individual_shopping_detail2.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", tg.getGroupCode());
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tg.getGroupCode());
		map0.put("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild() + "小");
		map0.put("guide", guideString);
		map0.put("productName", "【" + tg.getProductBrandName() + "】" + (tg.getProductName() == null ? "" : tg.getProductName()));
		/**
		 * 客人信息
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		int i = 1;
		for (GroupOrderPrintPo po : gops) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("n", "" + i++);
			map.put("rm", po.getReceiveMode());
			map.put("pn", po.getPersonNum());
			map.put("kr", po.getGuestInfo());
			map.put("rj", "");
			map.put("yd", "");
			map.put("fc", "");
			map.put("y", "");
			map.put("c", "");
			map.put("hly", "");
			map.put("qt", "");
			map.put("bz", "");
			guestList.add(map);
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(guestList, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}
	/*	List<Map<String, Object>> guestList = new ArrayList<Map<String, Object>>();
		int i = 1;
		Map<String, Object> map = new HashMap<String, Object>();
		for (GroupOrderPrintPo po : gops) {
			map.put("n", "" + i++);
			map.put("rm", po.getReceiveMode());
			map.put("pn", po.getPersonNum());
			map.put("kr", po.getGuestInfo());
			List<Map<String, String>> forMapList = new ArrayList<Map<String,String>>();
			for (GroupOrderGuest guest : po.getGuests()) {
				Map<String, String>forMap = new HashMap<String, String>();
				forMap.put("mz", guest.getName());
				forMap.put("df", guest.getNativePlace());
				forMap.put("sfz", guest.getCertificateNum());
				forMap.put("rj", "");
				forMap.put("yd", "");
				forMap.put("fc", "");
				forMap.put("y", "");
				forMap.put("c", "");
				forMap.put("hly", "");
				forMap.put("qt", "");
				forMap.put("bz", "");
				forMapList.add(forMap);
			}
			map.put("aaa",forMapList);
		}
		guestList.add(map);
		System.out.println("值："+guestList);
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}*/
	
	
	/**
	 * 游客反馈单
	 */
	public String createtTickling(HttpServletRequest request, Integer groupId) {
		
//		String url = request.getSession().getServletContext().getRealPath("/")
//				+ "/download/" + System.currentTimeMillis() + ".doc";
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = order.getNumAdult();
//			Integer numChild = order.getNumChild();
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//					+ (numChild == null ? 0 : numChild) + "小");
//			gops.add(gop);
//		}
//		String realPath = request.getSession().getServletContext()
//				.getRealPath("/template/individual_guest_tickling.docx");
//		if(tg.getGroupMode()>0){
//			realPath = request.getSession().getServletContext()
//					.getRealPath("/template/team_guest_tickling.docx");
//		}
//		WordReporter export = new WordReporter(realPath);
//		try {
//			export.init();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		Map<String, Object> params1 = new HashMap<String, Object>();
//		params1.put("printTime", DateUtils.format(new Date()));
//		params1.put("printName", WebUtils.getCurUser(request).getName());
//		params1.put("groupCode", "");
//		if (imgPath != null) {
//			Map<String, String> picMap = new HashMap<String, String>();
//			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
//			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
//			picMap.put("type", "jpg");
//			picMap.put("path", imgPath);
//			params1.put("logo", picMap);
//		} else {
//			params1.put("logo", "");
//		}
//		/**
//		 * 第一个表格
//		 */
//		Map<String, Object> map0 = new HashMap<String, Object>();
//		map0.put("groupCode", tg.getGroupCode());
//		map0.put("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()
//				+ "小");
//		map0.put("guide", guideString);
//		map0.put(
//				"productName",
//				"【"
//						+ tg.getProductBrandName()
//						+ "】"
//						+ (tg.getProductName() == null ? "" : tg
//								.getProductName()));
//		/**
//		 * 反馈-客人信息
//		 */
//		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
//		if(tg.getGroupMode()<=0){
//			int i = 1;
//			for (GroupOrderPrintPo po : gops) {
//				Map<String, String> map = new HashMap<String, String>();
//				map.put("n", "" + i++);
//				map.put("rm", po.getReceiveMode());
//				map.put("pn", po.getPersonNum());
//				map.put("jj", "");
//				map.put("fw", "");
//				map.put("hj", "");
//				map.put("zl", "");
//				map.put("ychj", "");
//				map.put("yczl", "");
//				map.put("cltd", "");
//				map.put("clcm", "");
//				map.put("xcjd", "");
//				map.put("ywts", "");
//				map.put("krqm", "");
//				map.put("krdh", "");
//				map.put("jy", "");
//				guestList.add(map);
//			}
//		}
//		try {
//			export.export(params1);
//			export.export(map0, 0);
//			if(tg.getGroupMode()<=0){
//				export.export(guestList, 1);
//			}
//			export.generate(url);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return url;
		
		String url = request.getSession().getServletContext().getRealPath("/") + 
				"/download/"+ System.currentTimeMillis() + ".doc";
		
		CreatetTicklingResult result=groupOrderFacade.createtTickling(groupId);
		TourGroup tg = result.getTg();
		String guideString = result.getGuideString();
		List<GroupOrderPrintPo> gops = result.getGops();
		
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/individual_guest_tickling.docx");
		if (tg.getGroupMode() > 0) {
			realPath = request.getSession().getServletContext().getRealPath("/template/team_guest_tickling.docx");
		}
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", "");
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tg.getGroupCode());
		map0.put("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild() + "小");
		map0.put("guide", guideString);
		map0.put("productName","【" + tg.getProductBrandName() + "】" + (tg.getProductName() == null ? "" : tg.getProductName()));
		
		/**
		 * 反馈-客人信息
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		if (tg.getGroupMode() <= 0) {
			int i = 1;
			for (GroupOrderPrintPo po : gops) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("n", "" + i++);
				map.put("rm", po.getReceiveMode());
				map.put("pn", po.getPersonNum());
				map.put("jj", "");
				map.put("fw", "");
				map.put("hj", "");
				map.put("zl", "");
				map.put("ychj", "");
				map.put("yczl", "");
				map.put("cltd", "");
				map.put("clcm", "");
				map.put("xcjd", "");
				map.put("ywts", "");
				map.put("krqm", "");
				map.put("krdh", "");
				map.put("jy", "");
				guestList.add(map);
			}
		}
		
		try {
			export.export(params1);
			export.export(map0, 0);
			if (tg.getGroupMode() <= 0) {
				export.export(guestList, 1);
			}
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return url;
		
	}
	
	/**
	 * 散客订单-游客反馈单
	 */
	public String createtOrderTickling(HttpServletRequest request, Integer orderId) {
		
//		String url = request.getSession().getServletContext().getRealPath("/")
//				+ "/download/" + System.currentTimeMillis() + ".doc";
//		GroupOrder go = groupOrderService.selectByPrimaryKey(orderId) ;
//		TourGroup tg = new TourGroup() ;
//		List<BookingGuide> guides = new ArrayList<BookingGuide>();
//		String guideString = "";
//		if(go!=null&&go.getGroupId()!=null){
//			tg = tourGroupService.selectByPrimaryKey(go.getGroupId());
//			guides = bookingGuideService
//					.selectGuidesByGroupId(go.getGroupId());
//			if (guides.size() > 0) {
//				guideString = getGuides(guides);
//			}
//		}
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop =  new GroupOrderPrintPo();
//		gop.setReceiveMode(go.getReceiveMode());
//		Integer numAdult = go.getNumAdult();
//		Integer numChild = go.getNumChild();
//		gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//				+ (numChild == null ? 0 : numChild) + "小");
//		gops.add(gop);
//		String realPath = request.getSession().getServletContext()
//				.getRealPath("/template/individual_guest_tickling.docx");
//		WordReporter export = new WordReporter(realPath);
//		try {
//			export.init();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		Map<String, Object> params1 = new HashMap<String, Object>();
//		params1.put("printTime", DateUtils.format(new Date()));
//		params1.put("printName", WebUtils.getCurUser(request).getName());
//		params1.put("groupCode", "");
//		if (imgPath != null) {
//			Map<String, String> picMap = new HashMap<String, String>();
//			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
//			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
//			picMap.put("type", "jpg");
//			picMap.put("path", imgPath);
//			params1.put("logo", picMap);
//		} else {
//			params1.put("logo", "");
//		}
//		/**
//		 * 第一个表格
//		 */
//		Map<String, Object> map0 = new HashMap<String, Object>();
//		map0.put("groupCode", tg.getGroupCode());
//		map0.put("totalNum", numAdult+ "大" + numChild+ "小");
//		map0.put("guide", guideString);
//		map0.put("productName", "【" + tg.getProductBrandName() + "】" + (tg.getProductName() == null ? "" : tg.getProductName()));
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("n", "1");
//		map.put("rm", gop.getReceiveMode());
//		map.put("pn", gop.getPersonNum());
//		map.put("jj", "");
//		map.put("fw", "");
//		map.put("hj", "");
//		map.put("zl", "");
//		map.put("ychj", "");
//		map.put("yczl", "");
//		map.put("cltd", "");
//		map.put("clcm", "");
//		map.put("xcjd", "");
//		map.put("ywts", "");
//		map.put("krqm", "");
//		map.put("krdh", "");
//		map.put("jy", "");
//		try {
//			export.export(params1);
//			export.export(map0, 0);
//			export.export(map, 1);
//			export.generate(url);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return url;
		
		String url = request.getSession().getServletContext().getRealPath("/") + 
				"/download/" + System.currentTimeMillis() + ".doc";
		
		CreatetOrderTicklingResult result = groupOrderFacade.createtOrderTickling(orderId);

		TourGroup tg = result.getTg();
		String guideString = result.getGuideString();
		GroupOrderPrintPo gop = result.getGop();
		Integer numAdult = result.getNumAdult();
		Integer numChild = result.getNumChild();
		
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/individual_guest_tickling.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", "");
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tg.getGroupCode());
		map0.put("totalNum", numAdult + "大" + numChild + "小");
		map0.put("guide", guideString);
		map0.put("productName",
				"【" + tg.getProductBrandName() + "】" + (tg.getProductName() == null ? "" : tg.getProductName()));
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("n", "1");
		map.put("rm", gop.getReceiveMode());
		map.put("pn", gop.getPersonNum());
		map.put("jj", "");
		map.put("fw", "");
		map.put("hj", "");
		map.put("zl", "");
		map.put("ychj", "");
		map.put("yczl", "");
		map.put("cltd", "");
		map.put("clcm", "");
		map.put("xcjd", "");
		map.put("ywts", "");
		map.put("krqm", "");
		map.put("krdh", "");
		map.put("jy", "");
		
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return url;
	}

	/**
	 * 游客反馈单
	 */
	public String createtTeamGroupTickling(HttpServletRequest request, Integer groupId) {
		
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//		}
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gops = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gop = null;
//		for (GroupOrder order : orders) {
//			gop = new GroupOrderPrintPo();
//			gop.setReceiveMode(order.getReceiveMode());
//			Integer numAdult = groupOrderGuestService
//					.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService
//					.selectNumChildByOrderID(order.getId());
//			gop.setPersonNum((numAdult == null ? 0 : numAdult) + "大"
//					+ (numChild == null ? 0 : numChild) + "小");
//			gops.add(gop);
//		}
		
		CreatetTicklingResult result=groupOrderFacade.createtTeamGroupTickling(groupId);
		TourGroup tg = result.getTg();
		String guideString = result.getGuideString();
		List<GroupOrderPrintPo> gops = result.getGops();
		
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/teamGroup_guest_tickling.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", "");
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tg.getGroupCode());
		map0.put("totalNum", tg.getTotalAdult() + "大" + tg.getTotalChild()
				+ "小");
		map0.put("guide", guideString);
		map0.put(
				"productName",
				"【"
						+ tg.getProductBrandName()
						+ "】"
						+ (tg.getProductName() == null ? "" : tg
								.getProductName()));
		/**
		 * 反馈-客人信息
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		int i = 1;
		for (GroupOrderPrintPo po : gops) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("n", "" + i++);
			map.put("rm", po.getReceiveMode());
			map.put("pn", po.getPersonNum());
			map.put("jj", "");
			map.put("fw", "");
			map.put("hj", "");
			map.put("zl", "");
			map.put("ychj", "");
			map.put("yczl", "");
			map.put("cltd", "");
			map.put("clcm", "");
			map.put("xcjd", "");
			map.put("ywts", "");
			map.put("krqm", "");
			map.put("krdh", "");
			map.put("jy", "");
			guestList.add(map);
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(guestList, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return url;
	}
	/**
	 * 打印客人名单
	 * 
	 * @param request
	 * @param orderId
	 * @return
	 */
	public String createGuestNames(HttpServletRequest request, Integer groupId) {
		
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderGuest> guestAllList = new ArrayList<GroupOrderGuest>();
//		for (GroupOrder order : orders) {
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			guestAllList.addAll(guests);
//		}
		
		CreateGuestNamesResult result=groupOrderFacade.createGuestNames(groupId);
		TourGroup tg = result.getTg();
		List<GroupOrderGuest> guestAllList = result.getGuestAllList();
		
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/guest_names.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", tg.getGroupCode());
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		/**
		 * 客人名单
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		int i = 1 ;
		for (GroupOrderGuest guest : guestAllList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("num",""+i++);
			map.put("name", guest.getName());
			map.put("certificateNum", guest.getCertificateNum());
			map.put("age", (guest.getAge()==null?"": guest.getAge())+"");
			map.put("nativePlace", guest.getNativePlace()==null?"":guest.getNativePlace());
			map.put("mobile", guest.getMobile());
			guestList.add(map);
		}
		try {
			export.export(params1);
			export.export(guestList, 0);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 客人名单（有接送）
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "previewGuestWithTrans.htm")
	public String previewGuestWithTrans(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {

//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("operatorMobile",sysPlatformEmployeeFacade.findByEmployeeId(tourGroup.getOperatorId()).getPlatformEmployeePo().getMobile());
//		// 查询导游信息
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		String driverString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//			driverString = getDrivers(guides);
//		}
//		//预定车信息
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		StringBuilder sbsb = new StringBuilder() ;
//		for (BookingSupplier bs : bookingSuppliers) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			for (BookingSupplierDetail bsd : details) {
//				sbsb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//			}
//		}
//		driverString = sbsb.toString() ;
//		model.addAttribute("guideString", guideString);
//		model.addAttribute("driverString", driverString);
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gopp = null;
//		// 房量总计
//		String total = getHotelTotalNum(orders);
//		for (GroupOrder order : orders) {
//			// 拿到单条订单信息
//			gopp = new GroupOrderPrintPo();
//			gopp.setPlace((order.getProvinceName() == null ? "" : order
//					.getProvinceName())
//					+ (order.getCityName() == null ? "" : order.getCityName()));
//			gopp.setRemark(order.getRemarkInternal());
//			// 根据散客订单统计客人信息
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			gopp.setGuestInfo(getGuestInfo2(guests));
//			gopp.setGuests(guests);
//			gopp.setReceiveMode(order.getReceiveMode());
//			
//			gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order.getId(), 3);
//			StringBuilder sb = new StringBuilder();
//			for (GroupRequirement gsl : grogShopList) {
//				if (gsl.getHotelLevel() != null) {
//					sb.append(dicService.getById(gsl.getHotelLevel())
//							.getValue() + "\n");
//				}
//			}
//			gopp.setHotelLevel(sb.toString());
//			gopp.setHotelNum(getHotelNum(grogShopList));
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//					.selectByOrderId(order.getId());
//			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
//			// 根据散客订单统计送机信息
//			gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
//			// 省内交通
//			gopp.setTrans(getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}

		String imgPath = settingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		
		
		PreviewGuestWithTransResult result=groupOrderFacade.previewGuestWithTrans(groupId);
		
		model.addAttribute("tourGroup", result.getTourGroup());
		model.addAttribute("operatorMobile",result.getOperatorMobile());
		model.addAttribute("guideString", result.getGuideString());
		model.addAttribute("driverString", result.getDriverString());
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("orderList", result.getGopps());
		model.addAttribute("total", result.getTotal());
		
		return "sales/preview/guestWithTrans";
	}

	/**
	 * 客人名单（无接送）
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "previewGuestWithoutTrans.htm")
	public String previewGuestWithoutTrans(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {

//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tg);
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderGuest> guestAllList = new ArrayList<GroupOrderGuest>();
//		for (GroupOrder order : orders) {
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			guestAllList.addAll(guests);
//		}
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		model.addAttribute("imgPath", imgPath);
//		/**
//		 * 客人名单
//		 */
//		model.addAttribute("guestList", guestAllList);
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		
		PreviewGuestWithoutTransResult result=groupOrderFacade.previewGuestWithoutTrans(groupId);
		String imgPath = settingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		
		model.addAttribute("guestList", result.getGuestAllList());
		model.addAttribute("tourGroup", result.getTg());
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		
		return "sales/preview/guestWithoutTrans";
	}

	/**
	 * 预览散客导游
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "previewFitGuide.htm")
	public String previewFitGuide(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		
//		// 查询导游信息
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = getGuides(guides);
//		String driverString = getDrivers(guides);
//		//预定车信息
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		StringBuilder sbsb = new StringBuilder() ;
//		for (BookingSupplier bs : bookingSuppliers) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			for (BookingSupplierDetail bsd : details) {
//				sbsb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//			}
//		}
//		driverString = sbsb.toString() ;
//		model.addAttribute("guideString", guideString);
//		model.addAttribute("driverString", driverString);
//		// 团信息
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
//		model.addAttribute("operatorMobile",sysPlatformEmployeeFacade.findByEmployeeId(tourGroup.getOperatorId()).getPlatformEmployeePo().getMobile());
//		//改1
//		/**
//		 * 获取全陪，定制团一个团对应一个订单
//		 */
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(tourGroup.getId());
//		/**
//		 * logo图片
//		 */
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		model.addAttribute("imgPath", imgPath);
//		
//		GroupRouteVO groupRouteVO = groupRouteService
//				.findGroupRouteByGroupId(groupId);
//		List<GroupRouteDayVO> routeDayVOList = groupRouteVO
//				.getGroupRouteDayVOList();
//		
//		List<GroupOrder> orders1 = groupOrderService
//				.selectOrderByGroupId(tourGroup.getId());
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gopp = null;
//		for (GroupOrder order1 : orders1) {
//			// 拿到单条订单信息
//			gopp = new GroupOrderPrintPo();
//			gopp.setRemark(order1.getRemarkInternal());
//			gopp.setPlace((order1.getProvinceName() == null ? "" : order1
//					.getProvinceName())
//					+ (order1.getCityName() == null ? "" : order1.getCityName()));
//			gopp.setPersonNum(order1.getNumAdult()+"+"+order1.getNumChild());
//			// 根据散客订单统计客人信息
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order1.getId());
//			gopp.setGuestInfo(getGuestInfo2(guests));
//			gopp.setGuests(guests);
//			gopp.setReceiveMode(order1.getReceiveMode());
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order1.getId(), 3);
//			StringBuilder sb = new StringBuilder();
//			for (GroupRequirement gsl : grogShopList) {
//				if (gsl.getHotelLevel() != null) {
//					sb.append(dicService.getById(gsl.getHotelLevel())
//							.getValue() + "\n");
//				}
//			}
//			gopp.setHotelLevel(sb.toString());
//			gopp.setHotelNum(getHotelNum(grogShopList));
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//					.selectByOrderId(order1.getId());
//			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
//			// 根据散客订单统计送机信息
//			gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
//			// 省内交通
//			gopp.setTrans(getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}
//		model.addAttribute("orderList", gopps);
//
//		/**
//		 * 计调信息
//		 */
//		List<GroupGuidePrintPo> pos = new ArrayList<GroupGuidePrintPo>();
//		GroupGuidePrintPo po = null;
//		// 预定下接社信息
//		List<Map<String, String>> mapList = new ArrayList<Map<String, String>>();
//		List<BookingDelivery> deliveries = deliveryService
//				.getDeliveryListByGroupId(tourGroup.getId());
//		for (BookingDelivery bd : deliveries) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("下接社");
//			po.setSupplierName(bd.getSupplierName());
//			po.setContacktWay(bd.getContact() + "-" + bd.getContactMobile());
//			po.setPaymentWay("");
//			String dd = "";
//			if (bd.getDateArrival() != null) {
//				dd = com.yihg.erp.utils.DateUtils.format(bd.getDateArrival());
//			}
//			po.setDetail(dd + " " + "人数：" + bd.getPersonAdult() + "大"
//					+ bd.getPersonChild() + "小" + bd.getPersonGuide() + "陪");
//			pos.add(po);
//		}
//		// 预定购物
//		List<BookingShop> shops = shopService.getShopListByGroupId(tourGroup
//				.getId());
//		for (BookingShop bs : shops) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("购物店");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay("");
//			po.setPaymentWay("");
//			po.setDetail(bs.getShopDate());
//			pos.add(po);
//		}
//		/**
//		 * 预订房信息
//		 */
//		List<BookingSupplier> bs3 = bookingSupplierService
//				.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(),
//						3);
//		for (BookingSupplier bs : bs3) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("房");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact() + "-" + bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService
//					.selectByPrimaryBookId(bs.getId());
//			StringBuilder sb = new StringBuilder();
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "";
//				if (bsd.getItemDate() != null) {
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate());
//				}
//				sb.append(dd + " 【" + bsd.getType1Name() + "】 "
//						+ bsd.getItemPrice().toString().replace(".0", "")
//						+ "*(" + bsd.getItemNum().toString().replace(".0", "")
//						+ "-"
//						+ bsd.getItemNumMinus().toString().replace(".0", "")
//						+ ")");
//			}
//			po.setDetail(sb.toString());
//
//			pos.add(po);
//		}
//		/**
//		 * 预定车信息
//		 */
//		List<BookingSupplier> bs4 = bookingSupplierService
//				.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(),
//						4);
//		for (BookingSupplier bs : bs4) {
//			List<BookingSupplierDetail> details = detailService
//					.selectByPrimaryBookId(bs.getId());
//			StringBuilder sb = new StringBuilder();
//			for (BookingSupplierDetail bsd : details) {
//				po = new GroupGuidePrintPo();
//				po.setSupplierType("司机");
//				po.setSupplierName(bsd.getDriverName());
//				po.setContacktWay(bsd.getDriverTel());
//				po.setPaymentWay(bs.getCashType());
//				sb.append(bsd.getType1Name() + "," + bsd.getType2Name() + "座"
//						+ "," + bsd.getCarLisence() + "," + "价格："
//						+ bsd.getItemPrice());
//				if (bs.getRemark() != "" && bs.getRemark() != null) {
//					sb.append(",备注：" + bs.getRemark());
//				}
//				po.setDetail(sb.toString());
//				pos.add(po);
//			}
//		}
//		/**
//		 * 预定景区信息
//		 */
//		List<BookingSupplier> bs5 = bookingSupplierService
//				.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(),
//						5);
//		for (BookingSupplier bs : bs5) {
//			po = new GroupGuidePrintPo();
//			po.setSupplierType("景区");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact() + "-" + bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService
//					.selectByPrimaryBookId(bs.getId());
//			StringBuilder sb = new StringBuilder();
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "";
//				if (bsd.getItemDate() != null) {
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate());
//				}
//				sb.append(dd + " 【" + bsd.getType1Name() + "】 "
//						+ bsd.getItemPrice().toString().replace(".0", "")
//						+ "*(" + bsd.getItemNum().toString().replace(".0", "")
//						+ "-"
//						+ bsd.getItemNumMinus().toString().replace(".0", "")
//						+ ")");
//			}
//			po.setDetail(sb.toString());
//
//			pos.add(po);
//		}
//		/**
//		 * 组织打印数据
//		 */
//		for (GroupGuidePrintPo ggp : pos) {
//			Map<String, String> map = new HashMap<String, String>();
//			map.put("supplierType", ggp.getSupplierType());
//			map.put("supplierName", ggp.getSupplierName());
//			map.put("contactWay", ggp.getContacktWay());
//			map.put("paymentWay", ggp.getPaymentWay());
//			map.put("detail", ggp.getDetail());
//			mapList.add(map);
//		}
//		
//		model.addAttribute("routeDayVOList", routeDayVOList);
//		model.addAttribute("mapList", pos);
//		
//		List<BookingSupplier> hotelList = bookingSupplierService.getHotelInfoByGroupId(groupId) ;
//		for (BookingSupplier bs : hotelList) {
//			SupplierInfo supplierInfo = supplierInfoService.selectBySupplierId(bs.getSupplierId()) ;
//			bs.setCityName(supplierInfo.getCityName());
//		}
//		model.addAttribute("hotelList", hotelList);
		
		PreviewFitGuideResult result=groupOrderFacade.previewFitGuide(groupId);
		
		String imgPath = settingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		
		model.addAttribute("guideString", result.getGuideString());
		model.addAttribute("driverString", result.getDriverString());
		model.addAttribute("tourGroup", result.getTourGroup());
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("operatorMobile",result.getOperatorMobile());
		model.addAttribute("orderList", result.getGopps());
		model.addAttribute("routeDayVOList", result.getRouteDayVOList());
		model.addAttribute("mapList", result.getPos());
		model.addAttribute("hotelList", result.getHotelList());
		
		return "sales/preview/fitGuide";

	}

	/**
	 * 预览散客计调
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "previewFitTransfer.htm")
	public String previewFitTransfer(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {

//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		model.addAttribute("imgPath", imgPath);
//
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("operatormobile", sysPlatformEmployeeFacade.findByEmployeeId(tourGroup.getOperatorId()).getPlatformEmployeePo().getMobile());
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		String driverString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//			driverString = getDrivers(guides);
//		}
//		//预定车信息
//		List<BookingSupplier> bs4 = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		StringBuilder sbsb = new StringBuilder() ;
//		for (BookingSupplier bs : bs4) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			for (BookingSupplierDetail bsd : details) {
//				sbsb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//			}
//		}
//		driverString = sbsb.toString() ;
//		model.addAttribute("guideString", guideString);
//		model.addAttribute("driverString", driverString);
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gopp = null;
//		String total = getHotelTotalNum(orders);
//		for (GroupOrder order : orders) {
//			// 拿到单条订单信息
//			gopp = new GroupOrderPrintPo();
//			gopp.setSupplierName(order.getSupplierName()+"\n"+order.getContactName());
//			gopp.setReceiveMode(order.getReceiveMode());
//			
//			gopp.setSaleOperatorName(order.getSaleOperatorName());
//			gopp.setRemark(order.getRemarkInternal());
//			gopp.setPlace((order.getProvinceName() == null ? "" : order
//					.getProvinceName())
//					+ (order.getCityName() == null ? "" : order.getCityName()));
//			// 根据散客订单统计人数
//			/*Integer numAdult = groupOrderGuestService
//					.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService
//					.selectNumChildByOrderID(order.getId());*/
//			gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
//			// 根据散客订单统计客人信息
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			/*for (GroupOrderGuest guest : guests) {
//				if (guest.getIsLeader() == 1) {
//					gopp.setGuesStatic(guest.getName() + " " + guests.size()
//							+ "人" + "\n" + guest.getMobile());
//					break;
//				}
//			}
//			if (gopp.getGuesStatic() == null || gopp.getGuesStatic() == "") {
//				// 如果客人中没有领队，默认取一条数据显示
//				gopp.setGuesStatic(guests.get(0).getName() + "\n"
//						+ guests.get(0).getMobile());
//			}*/
//			gopp.setGuesStatic(order.getReceiveMode());
//			gopp.setGuestInfo(getGuestInfo2(guests));
//			gopp.setGuests(guests);
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order.getId(), 3);
//			StringBuilder sb = new StringBuilder();
//			for (GroupRequirement gsl : grogShopList) {
//				if (gsl.getHotelLevel() != null) {
//					sb.append(dicService.getById(gsl.getHotelLevel())
//							.getValue() + "\n");
//				}
//			}
//			gopp.setHotelLevel(sb.toString());
//			gopp.setHotelNum(getHotelNum(grogShopList));
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//					.selectByOrderId(order.getId());
//			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
//			// 根据散客订单统计送机信息
//			gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
//			// 省内交通
//			gopp.setTrans(getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}
//
//		model.addAttribute("orderList", gopps);
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
//		List<BookingDelivery> bds = deliveryService
//				.getDeliveryListByGroupId(groupId);
//		String deliveryDetail = getDeliveryInfo(bds);
//		model.addAttribute("deliveryDetail", deliveryDetail);
//		model.addAttribute("total", total);
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		
		PreviewFitTransferResult result=groupOrderFacade.previewFitTransfer(groupId);
		
		String imgPath = settingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		
		model.addAttribute("orderList", result.getGopps());
		model.addAttribute("deliveryDetail", result.getDeliveryDetail());
		model.addAttribute("total", result.getTotal());
		
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("imgPath", result.getImgPath());
		
		model.addAttribute("tourGroup", result.getTourGroup());
		model.addAttribute("guideString", result.getGuideString());
		model.addAttribute("driverString", result.getDriverString());
		model.addAttribute("operatormobile",result.getOperatormobile());
		
		return "sales/preview/fitTransfer";

	}

	/**
	 * 散客计调单
	 * 
	 * @param request
	 * @param groupId
	 * @return
	 */
	public String createIndividual(HttpServletRequest request, Integer groupId) {
//		/**
//		 * 地接社信息
//		 */
//		List<BookingDelivery> bds = deliveryService.getDeliveryListByGroupId(groupId);
//		String deliveryDetail = getDeliveryInfo(bds);
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		String guideString = "";
//		String driverString = "";
//		if (guides.size() > 0) {
//			guideString = getGuides(guides);
//			driverString = getDrivers(guides);
//		}
//		//预定车信息
//		List<BookingSupplier> bs4 = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		StringBuilder sbsb = new StringBuilder() ;
//		for (BookingSupplier bs : bs4) {
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			for (BookingSupplierDetail bsd : details) {
//				sbsb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//			}
//		}
//		driverString = sbsb.toString() ;
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		GroupOrderPrintPo gopp = null;
//		String total = getHotelTotalNum(orders) ;
//		for (GroupOrder order : orders) {
//			// 拿到单条订单信息
//			gopp = new GroupOrderPrintPo();
//			// gopp.setReceiveMode(order.getReceiveMode());
//			gopp.setSupplierName(order.getSupplierName()+"\n"+order.getContactName());
//			gopp.setSaleOperatorName(order.getSaleOperatorName());
//			gopp.setRemark(order.getRemarkInternal());
//			gopp.setPlace((order.getProvinceName() == null ? "" : order
//					.getProvinceName())
//					+ (order.getCityName() == null ? "" : order.getCityName()));
//			// 根据散客订单统计人数
//			/*Integer numAdult = groupOrderGuestService
//					.selectNumAdultByOrderID(order.getId());
//			Integer numChild = groupOrderGuestService
//					.selectNumChildByOrderID(order.getId());
//			gopp.setPersonNum((numAdult == null ? 0 : numAdult) + "+"
//					+ (numChild == null ? 0 : numChild));*/
//			gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
//			// 根据散客订单统计客人信息
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			/*for (GroupOrderGuest guest : guests) {
//				if (guest.getIsLeader() == 1) {
//					gopp.setGuesStatic(guest.getName() + " " + guests.size()
//							+ "人" + "\n" + guest.getMobile());
//					break;
//				}
//			}
//			if (gopp.getGuesStatic() == null || gopp.getGuesStatic() == "") {
//				// 如果客人中没有领队，默认取一条数据显示
//				gopp.setGuesStatic(guests.get(0).getName() + "\n"
//						+ guests.get(0).getMobile());
//			}*/
//			gopp.setGuesStatic(order.getReceiveMode());
//			gopp.setGuestInfo(getGuestInfo2(guests));
//
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order.getId(), 3);
//			StringBuilder sb = new StringBuilder();
//			for (GroupRequirement gsl : grogShopList) {
//				if (gsl.getHotelLevel() != null) {
//					sb.append(dicService.getById(gsl.getHotelLevel())
//							.getValue() + "\n");
//				}
//			}
//			gopp.setHotelLevel(sb.toString());
//			gopp.setHotelNum(getHotelNum(grogShopList));
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//					.selectByOrderId(order.getId());
//			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
//			// 根据散客订单统计送机信息
//			gopp.setAirOff(getAirInfo(groupOrderTransports, 1));
//			// 省内交通
//			gopp.setTrans(getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}
		
		CreateIndividualResult result=groupOrderFacade.createIndividual(groupId);
		
		String deliveryDetail = result.getDeliveryDetail();
		String driverString = result.getDriverString();
		List<GroupOrderPrintPo> gopps = result.getGopps();
		String guideString = result.getGuideString();
		String total = result.getTotal();
		TourGroup tourGroup = result.getTourGroup();

		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/individual_order.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}

		String imgPath = settingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", tourGroup.getGroupCode());
		map0.put("operatorName", tourGroup.getOperatorName());
		if (null != tourGroup.getDateStart()) {
			map0.put("ggt", DateUtils.format(tourGroup.getDateStart()));
		} else {
			map0.put("ggt", "");
		}
		map0.put("guide", guideString);
		map0.put("driver", driverString);
		map0.put("totalNum",
				tourGroup.getTotalAdult() + "大" + tourGroup.getTotalChild()
						+ "小");
		map0.put("productBrandName", tourGroup.getProductBrandName());
		map0.put("productName", tourGroup.getProductName());

		/*
		 * 第二个表格
		 */
		List<Map<String, String>> orderList = new ArrayList<Map<String, String>>();
		int i = 1;
		for (GroupOrderPrintPo po : gopps) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("num", "" + i++);
			map.put("supplierName", po.getSupplierName());
			map.put("salePerson", po.getSaleOperatorName());
			map.put("guestStatic", po.getGuesStatic());
			map.put("personNum", po.getPersonNum());
			map.put("place", po.getPlace());
			map.put("hotelLevel", po.getHotelLevel());
			map.put("hotelNum", po.getHotelNum());
			map.put("airPickUp", po.getAirPickup());
			map.put("airOff", po.getAirOff());
			map.put("trans", po.getTrans());
			map.put("guestInfo", po.getGuestInfo());
			map.put("remark", po.getRemark());
			orderList.add(map);
		}
		Map<String,String> hotelNumMap = new HashMap<String, String>() ;
		hotelNumMap.put("total", total) ;
		orderList.add(hotelNumMap) ;
		/**
		 * 第个三表格
		 */
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("remarkInternal", 1==tourGroup.getBizId()?tourGroup.getRemarkInternal():tourGroup.getRemark());
		map2.put("deliveryDetail", deliveryDetail);
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(orderList, 1,true);
			export.export(map2, 2);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

//	/**
//	 * 返回地接社信息
//	 */
//	public String getDeliveryInfo(List<BookingDelivery> bds) {
//		StringBuilder sb = new StringBuilder();
//		for (BookingDelivery bd : bds) {
//			sb.append(bd.getSupplierName() + " " + bd.getContact() + " "
//					+ bd.getContactMobile() + " " + "Tel:" + bd.getContactTel()
//					+ " " + "Fax:" + bd.getContactFax() + "\n");
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 返回客人信息
//	 * 
//	 * @param guests
//	 * @return
//	 */
//	public String getGuestInfo(List<GroupOrderGuest> guests) {
//		StringBuilder sb = new StringBuilder();
//		for (GroupOrderGuest guest : guests) {
//			sb.append(guest.getName() + " " + guest.getMobile() + "\n"
//					+ guest.getCertificateNum() + "\n");
//		}
//		return sb.toString();
//	}
//	
//	/**
//	 * 返回客人信息
//	 * 格式如下：
//	 * 	张三(13787654321)  530111198307276576   有手机号的显示方式
//	 *  李四  530111198307276576				 没有手机号的显示形式
//	 * @param guests
//	 * @return
//	 */
//	public String getGuestInfo2(List<GroupOrderGuest> guests) {
//		StringBuilder sb = new StringBuilder();
//		if(guests == null || guests.size() == 0){
//			return sb.toString();
//		}
//		
//		GroupOrderGuest guest = null;
//		for (int i = 0; i < guests.size(); i++) {
//			if(i > 0){
//				sb.append("\n");
//			}
//			guest = guests.get(i);
//			sb.append(guest.getName());
//			if(StringUtils.isNotEmpty(guest.getMobile())){
//				sb.append("【"+ guest.getMobile() +"】  ");
//			}
//			sb.append(guest.getCertificateNum());
//			
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 返回客人信息
//	 * 格式如下：
//	 * 	张三（客源地） 530111198307276576   
//	 * @param guests
//	 * @return
//	 */
//	public String getGuestInfo3(List<GroupOrderGuest> guests) {
//		StringBuilder sb = new StringBuilder();
//		if(guests == null || guests.size() == 0){
//			return sb.toString();
//		}
//		
//		GroupOrderGuest guest = null;
//		for (int i = 0; i < guests.size(); i++) {
//			if(i > 0){
//				sb.append("\n");
//			}
//			guest = guests.get(i);
//			sb.append(guest.getName());
//			if(StringUtils.isNotEmpty(guest.getNativePlace())){
//				sb.append("【"+ guest.getNativePlace() +"】  ");
//			}
//			sb.append(guest.getCertificateNum());
//			
//		}
//		return sb.toString();
//	}
//	/**
//	 * 返回客人信息(不包含电话号码)
//	 * 
//	 * @param guests
//	 * @return
//	 */
//	public String getGuestInfoNoPhone(List<GroupOrderGuest> guests) {
//		StringBuilder sb = new StringBuilder();
//		for (GroupOrderGuest guest : guests) {
//			sb.append(guest.getName() + " " + guest.getCertificateNum() + "\n");
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 统计单个订单酒店信息
//	 * 
//	 * @param grogShopList
//	 * @return
//	 */
//	public String getHotelInfo(List<GroupRequirement> grogShopList) {
//		StringBuilder sb = new StringBuilder();
//		if (grogShopList.size() > 0) {
//			String ll = "";
//			String sr = "";
//			String dr = "";
//			String tr = "";
//			GroupRequirement gr = grogShopList.get(0);
//			if (gr.getHotelLevel() != null) {
//				ll = dicService.getById(gr.getHotelLevel()).getValue() + "\n";
//			}
//			if (gr.getCountSingleRoom() != null && gr.getCountSingleRoom() != 0) {
//				sr = gr.getCountSingleRoom() + "单间" + " ";
//			}
//			if (gr.getCountDoubleRoom() != null && gr.getCountDoubleRoom() != 0) {
//				dr = gr.getCountDoubleRoom() + "标间" + " ";
//			}
//			if (gr.getCountTripleRoom() != null && gr.getCountTripleRoom() != 0) {
//				tr = gr.getCountTripleRoom() + "三人间";
//			}
//			sb.append(ll + sr + dr + tr);
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 统计所有订单酒店总房间数
//	 * 
//	 * @param grogShopList
//	 * @return
//	 */
//	public String getHotelTotalNum(List<GroupOrder> orders) {
//		StringBuilder sb = new StringBuilder();
//		Integer sr = 0;
//		Integer dr = 0;
//		Integer tr = 0;
//		Integer eb = 0;
//		Integer pf = 0;
//		for (GroupOrder order : orders) {
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order.getId(), 3);
//			for (GroupRequirement gr : grogShopList) {
//				if (gr.getCountSingleRoom() != null
//						&& gr.getCountSingleRoom() != 0) {
//					sr += gr.getCountSingleRoom();
//				}
//				if (gr.getCountDoubleRoom() != null
//						&& gr.getCountDoubleRoom() != 0) {
//					dr += gr.getCountDoubleRoom();
//				}
//				if (gr.getCountTripleRoom() != null
//						&& gr.getCountTripleRoom() != 0) {
//					tr += gr.getCountTripleRoom();
//				}
//				if (gr.getExtraBed() != null && gr.getExtraBed() != 0) {
//					eb += gr.getExtraBed();
//				}
//				if (gr.getPeiFang() != null && gr.getPeiFang() != 0) {
//					pf += gr.getPeiFang();
//				}
//			}
//		}
//
//		if (sr != 0) {
//			sb.append(sr + "单 ");
//		}
//		if (dr != 0) {
//			sb.append(dr + "标 ");
//		}
//		if (tr != 0) {
//			sb.append(tr + "三人间 ");
//		}
//		if (eb != 0) {
//			sb.append(eb + "加床 ");
//		}
//		if (pf != 0) {
//			sb.append(pf + "陪房 ");
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 统计单个订单酒店总房间数
//	 * 
//	 * @param grogShopList
//	 * @return
//	 */
//	public String getHotelNum(List<GroupRequirement> grogShopList) {
//		StringBuilder sb = new StringBuilder();
//		Integer sr = 0;
//		Integer dr = 0;
//		Integer tr = 0;
//		Integer eb = 0;
//		Integer pf = 0;
//		for (GroupRequirement gr : grogShopList) {
//			if (gr.getCountSingleRoom() != null && gr.getCountSingleRoom() != 0) {
//				sr += gr.getCountSingleRoom();
//			}
//			if (gr.getCountDoubleRoom() != null && gr.getCountDoubleRoom() != 0) {
//				dr += gr.getCountDoubleRoom();
//			}
//			if (gr.getCountTripleRoom() != null && gr.getCountTripleRoom() != 0) {
//				tr += gr.getCountTripleRoom();
//			}
//			if (gr.getExtraBed() != null && gr.getExtraBed() != 0) {
//				eb += gr.getExtraBed();
//			}
//			if (gr.getPeiFang() != null && gr.getPeiFang() != 0) {
//				pf += gr.getPeiFang();
//			}
//		}
//		if (sr != 0) {
//			sb.append(sr + "单 ");
//		}
//		if (dr != 0) {
//			sb.append(dr + "标 ");
//		}
//		if (tr != 0) {
//			sb.append(tr + "三人间 ");
//		}
//		if (eb != 0) {
//			sb.append(eb + "加床 ");
//		}
//		if (pf != 0) {
//			sb.append(pf + "陪房 ");
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 接送信息
//	 * 
//	 * @param groupOrderTransports
//	 * @param flag
//	 *            0表示接信息 1表示送信息
//	 * @return
//	 */
//	public String getAirInfo(List<GroupOrderTransport> groupOrderTransports,
//			Integer flag) {
//		StringBuilder sb = new StringBuilder();
//		if (flag == 0) {
//			for (GroupOrderTransport transport : groupOrderTransports) {
//				if (transport.getType() == 0 && transport.getSourceType() == 1) {
//					sb.append(
//						(transport.getDepartureCity()==null?"":transport.getDepartureCity()) + "/"
//						+ (transport.getArrivalCity()==null?"":transport.getArrivalCity()) + " "
//						+ (transport.getClassNo()==null?"":transport.getClassNo()) + " " 
//						+ " 发出时间："+(DateUtils.format(transport.getDepartureDate(),"MM-dd")==null?"":DateUtils.format(transport.getDepartureDate(),"MM-dd")) 
//						+ " "
//						+(transport.getDepartureTime()==null?"":transport.getDepartureTime()) + "\n");
//				}
//			}
//		}
//		if (flag == 1) {
//			for (GroupOrderTransport transport : groupOrderTransports) {
//				if (transport.getType() == 1 && transport.getSourceType() == 1) {
//					sb.append(
//						(transport.getDepartureCity()==null?"":transport.getDepartureCity()) + "/"
//						+ (transport.getArrivalCity()==null?"":transport.getArrivalCity()) + " "
//						+ (transport.getClassNo()==null?"":transport.getClassNo()) + " " 
//						+ " 发出时间："+(DateUtils.format(transport.getDepartureDate(),"MM-dd")==null?"":DateUtils.format(transport.getDepartureDate(),"MM-dd")) 
//						+ " "
//						+(transport.getDepartureTime()==null?"":transport.getDepartureTime()) + "\n");
//				}
//			}
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 省内交通
//	 * 
//	 * @param groupOrderTransports
//	 * @param flag
//	 *            0表示接信息 1表示送信息
//	 * @return
//	 */
//	public String getSourceType(List<GroupOrderTransport> groupOrderTransports) {
//		StringBuilder sb = new StringBuilder();
//		for (GroupOrderTransport transport : groupOrderTransports) {
//			if (transport.getSourceType() == 0) {
//				sb.append(
//						(transport.getDepartureCity()==null?"":transport.getDepartureCity()) + "/"
//						+ (transport.getArrivalCity()==null?"":transport.getArrivalCity()) + " "
//						+ (transport.getClassNo()==null?"":transport.getClassNo()) + " " 
//						+ " 发出时间："+ (DateUtils.format(transport.getDepartureDate(),"MM-dd")==null?"":DateUtils.format(transport.getDepartureDate(),"MM-dd")) 
//						+ " "
//						+(transport.getDepartureTime()==null?"":transport.getDepartureTime()) + "\n");
//			}
//		}
//		return sb.toString();
//	}
//	
//	public String getMD(String date) {
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//		SimpleDateFormat s = new SimpleDateFormat("MM-dd");
//		Date dd = null;
//		try {
//			dd = sdf.parse(date);
//		} catch (ParseException e) {
//			e.printStackTrace();
//			return date;
//		}
//		return s.format(dd);
//	}
//
//	public String getHM(String date) {
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//		SimpleDateFormat s = new SimpleDateFormat("HH:mm");
//		Date dd = null;
//		try {
//			dd = sdf.parse(date);
//		} catch (ParseException e) {
//			e.printStackTrace();
//			return "";
//		}
//		return s.format(dd);
//	}
//
//	/**
//	 * 客人姓名+身份证号
//	 * 
//	 * @param guests
//	 * @return
//	 */
//	public String getCertificateNums(List<GroupOrderGuest> guests) {
//		StringBuilder sb = new StringBuilder();
//		for (GroupOrderGuest guest : guests) {
//			sb.append(guest.getName() + " " + guest.getCertificateNum() + "\n");
//		}
//		return sb.toString();
//	}
//
//	/**
//	 * 组织所有导游信息
//	 * @param guides
//	 * @return
//	 */
//	public String getGuides(List<BookingGuide> guides){
//		StringBuilder sb = new StringBuilder();
//		SupplierGuide sg = null;
//		for (BookingGuide guide : guides) {
//			sg = guideService.getGuideInfoById(guide.getGuideId());
//			sb.append(guide.getGuideName()+" "+guide.getGuideMobile()+" "+sg.getLicenseNo()+"\n") ;
//		}
//		
//		return sb.toString() ;
//	}
//
//	/**
//	 * 组织所有司机信息
//	 */
//	public String getDrivers(List<BookingGuide> guides) {
//		StringBuilder sb = new StringBuilder();
//		for (BookingGuide guide : guides) {
//			BookingSupplierDetail bsd = bookingSupplierDetailService
//					.selectByPrimaryKey(guide.getBookingDetailId());
//			if (bsd != null) {
//				sb.append(bsd.getDriverName() + " " + bsd.getDriverTel() + "\n");
//			}
//		}
//		return sb.toString();
//	}


	@RequestMapping("/importGroupOrder")
	public String importTransferOrder(HttpServletRequest request, Model model) {
		Integer bizId = WebUtils.getCurBizId(request);

	/*	model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
*/
		ToDeliveryPriceListResult result=groupOrderFacade.toDeliveryPriceList(bizId);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());

		return "sales/groupOrder/importGroupOrder";
	}

	@RequestMapping("/importGroupOrderTable")
	public String importOrderTable(HttpServletRequest request, HttpServletResponse reponse,
								   Model model, GroupOrder groupOrder, String startTime, String endTime) {

		Map<String, Object> pm = WebUtils.getQueryParamters(request);
		PlatformOrgPo pop = WebUtils.getCurOrgInfo(request);
		Integer bizId = WebUtils.getCurBizId(request);
		Integer employeeId = WebUtils.getCurUser(request).getEmployeeId();
		String name = WebUtils.getCurUser(request).getName();

		ImportOrderTableDTO importOrderTableDTO = new ImportOrderTableDTO();
		importOrderTableDTO.setGroupOrder(groupOrder);
		importOrderTableDTO.setStartTime(startTime);
		importOrderTableDTO.setEndTime(endTime);
		importOrderTableDTO.setPm(pm);
		importOrderTableDTO.setPop(pop);
		importOrderTableDTO.setBizId(bizId);
		importOrderTableDTO.setEmployeeId(employeeId);
		importOrderTableDTO.setName(name);
		ImportOrderTableResult importOrderTableResult = groupOrderFacade.importOrderTable(importOrderTableDTO);
		model.addAttribute("curUser", WebUtils.getCurUser(request));
		model.addAttribute("page", importOrderTableResult.getPageBean());
		return "sales/groupOrder/importGroupOrderTable";
	}

	@RequestMapping("/saveTransferOrder")
	@ResponseBody
	public String saveTransferOrder(@RequestParam("orderIds[]") String[] orderIds,
									Integer saleOperatorId, String saleOperatorName,
									Integer operatorId,
									String operatorName, Integer supplierId,
									String supplierName, Integer orderType) {
		ImportOrderTableDTO importOrderTableDTO = new ImportOrderTableDTO();
		importOrderTableDTO.setOrderIds(orderIds);
		importOrderTableDTO.setSaleOperatorId(saleOperatorId);
		importOrderTableDTO.setSaleOperatorName(saleOperatorName);
		importOrderTableDTO.setOperatorId(operatorId);
		importOrderTableDTO.setOperatorName(operatorName);
		importOrderTableDTO.setSupplierId(supplierId);
		importOrderTableDTO.setSupplierName(supplierName);
		importOrderTableDTO.setOrderType(orderType);
		ImportOrderTableResult importOrderTableResult = groupOrderFacade.saveTransferOrder(importOrderTableDTO);
		if (importOrderTableResult.getGroupOrderId() > 0) {
			return successJson("msg", "数据导入成功！");
		} else {
			return errorJson("数据导入失败！");
		}
	}

	/**
	 * 删除订单信息(逻辑删)
	 *
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delTaobaoGroupOrder.do")
	@ResponseBody
	public String delTaobaoGroupOrder(HttpServletRequest request, HttpServletResponse reponse,
									  Integer id) {
//		if (airTicketRequestService.doesOrderhaveRequested(WebUtils.getCurBizId(request), id)) {
//			return errorJson("删除订单前请先取消机票申请。");
//		}
//		GroupOrder groupOrder = groupOrderService.findById(id);
//		taobaoOrderService.updateOrderId(id);									// 更新淘宝原始单OrderId为0
//		groupOrder.setState(-1);
//		groupOrderService.updateGroupOrder(groupOrder);
//		if(groupOrder.getGroupId()!=null){    									// 判断是否成团，团中有无订单，若无订单删除团。
//			List<GroupOrder> list =groupOrderService.selectSubOrderList(groupOrder.getGroupId());
//			if(list==null || list.size()<1){
//				TourGroup tourGroup=tourGroupService.selectByPrimaryKey(groupOrder.getGroupId());
//				tourGroup.setGroupState(-1);
//				tourGroupService.updateByPrimaryKeySelective(tourGroup);
//			}
//		}
//		if (groupOrder.getPriceId() != null) {
//
//			boolean updateStock = productGroupPriceService.updateStock(groupOrder.getPriceId(),
//					groupOrder.getSupplierId(),
//					-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
//
//			log.info("更新库存:" + updateStock);
//		}
//		bookingSupplierService.upateGroupIdAfterDelOrderFromGroup(id);
//		TaobaoStockLog sLog = taobaoStockService.selectStockLogAllByOrderId(id);  //判断是否存在淘宝产品库存，有则更新该单已售为0
//		if (sLog != null) {
//			taobaoStockService.delTaoBaoProductStock(sLog);
//		}
		ResultSupport resultSupport = groupOrderFacade.delTaobaoGroupOrder(WebUtils.getCurBizId(request),id);
		return resultSupport.isSuccess() ? successJson() : errorJson(resultSupport.getResultMsg());
	}
}
