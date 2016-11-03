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
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.OpenPlatformConstannt;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.supplier.SupplierController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.MD5Util;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.erp.utils.WordReporter.NumberToCN;
import com.yimayhd.erpcenter.common.util.NumberUtil;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupSupplier;
import com.yimayhd.erpcenter.dal.product.vo.ProductSupplierCondition;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.AutocompleteInfo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrice;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrintPo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRequirement;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupPriceVo;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupRouteDayVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.OtherInfoVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.dal.sys.po.SysBizBankAccount;
import com.yimayhd.erpcenter.facade.sales.query.ChangeGroupDTO;
import com.yimayhd.erpcenter.facade.sales.query.CopyTourGroupDTO;
import com.yimayhd.erpcenter.facade.sales.query.FindTourGroupByConditionDTO;
import com.yimayhd.erpcenter.facade.sales.query.ProfitQueryByTourDTO;
import com.yimayhd.erpcenter.facade.sales.query.ToSKConfirmPreviewDTO;
import com.yimayhd.erpcenter.facade.sales.query.grouporder.ToOrderLockTableDTO;
import com.yimayhd.erpcenter.facade.sales.result.BookingProfitTableResult;
import com.yimayhd.erpcenter.facade.sales.result.FindTourGroupByConditionResult;
import com.yimayhd.erpcenter.facade.sales.result.GetPushInfoResult;
import com.yimayhd.erpcenter.facade.sales.result.ProfitQueryByTourResult;
import com.yimayhd.erpcenter.facade.sales.result.PushWapResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.ToAddTourGroupOrderResult;
import com.yimayhd.erpcenter.facade.sales.result.ToChangeGroupResult;
import com.yimayhd.erpcenter.facade.sales.result.ToGroupListResult;
import com.yimayhd.erpcenter.facade.sales.result.ToOtherInfoResult;
import com.yimayhd.erpcenter.facade.sales.result.ToPreviewResult;
import com.yimayhd.erpcenter.facade.sales.result.ToProfitQueryTableResult;
import com.yimayhd.erpcenter.facade.sales.result.ToSKChargePreviewResult;
import com.yimayhd.erpcenter.facade.sales.result.ToSKConfirmPreviewResult;
import com.yimayhd.erpcenter.facade.sales.result.ToSaleChargeResult;
import com.yimayhd.erpcenter.facade.sales.result.TogroupRequirementResult;
import com.yimayhd.erpcenter.facade.sales.result.grouporder.ToOrderLockListResult;
import com.yimayhd.erpcenter.facade.sales.service.TeamGroupFacade;
import com.yimayhd.erpcenter.facade.sales.service.TourGroupFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;
import com.yimayhd.erpresource.dal.po.SupplierContactMan;
import com.yimayhd.erpresource.dal.po.SupplierInfo;

@Controller
@RequestMapping(value = "/tourGroup")
public class TourGroupController extends BaseController {

	private static final Logger logger = LoggerFactory
			.getLogger(SupplierController.class);

	private static final org.apache.log4j.Logger log = org.apache.log4j.Logger
			.getLogger(TourGroupController.class);

	@Autowired
	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
	private SysPlatformOrgFacade sysPlatformOrgFacade;

//	@Autowired
//	private GroupProfitFacade  tourGroupProfitFacade;//利润
//	
//	@Autowired
//	private GroupOrderLockFacade groupOrderLockFacade;//锁单
	
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
//	@Autowired
//	private GroupQueryPrintFacade groupQueryPrintFacade;//查询打印

	@Autowired
	private TourGroupFacade tourGroupFacade;//

	@Autowired
	private TeamGroupFacade teamGroupFacade;//

	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model, HttpServletRequest request) {
		//model.addAttribute("orgJsonStr", SysPlatformOrgFacade.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
		//model.addAttribute("orgUserJsonStr", sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult departmentTuneQueryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", departmentTuneQueryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", departmentTuneQueryResult.getOrgUserJsonStr());

	}
	/**
	 * 变更团
	 * 
	 * @param request
	 * @param groupId
	 * @param
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toChangeGroup.htm")
	public String toChangeGroup(HttpServletRequest request, Integer groupId,
			Model model) {
		model.addAttribute("groupId", groupId);

		/*TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		List<GroupOrder> orderList = null;
		tourGroup.setGroupCode(tourGroup.getGroupCode() + "变更");
		tourGroup.setGroupCodeMark(tourGroup.getGroupCodeMark());

		if (tourGroup.getGroupMode() == 0 || tourGroup.getGroupMode() == -1 || tourGroup.getGroupMode() > 0) {
			orderList = groupOrderService.selectOrderByGroupId(groupId);
		}
		model.addAttribute("orderList", orderList);
		model.addAttribute("tourGroup", tourGroup);*/

		ToChangeGroupResult toChangeGroupResult = tourGroupFacade.toChangeGroup(groupId);
		model.addAttribute("orderList", toChangeGroupResult.getOrderList());
		model.addAttribute("tourGroup", toChangeGroupResult.getTourGroup());

		return "sales/tourGroup/changeGroupInfo";
	}

	@RequestMapping(value = "/changeGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public String changeGroup(HttpServletRequest request, TourGroup tourGroup,
			Integer groupId, String orderIds,String info) throws Exception {
		/*groupId = tourGroupService.changeGroup(groupId, tourGroup, orderIds,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(),info);
		financeService.calcTourGroupAmount(groupId);                         // 增加计算
		TourGroup group = tourGroupService.selectByPrimaryKey(groupId); */
		ChangeGroupDTO changeGroupDTO = new ChangeGroupDTO();
		changeGroupDTO.setGroupId(groupId);
		changeGroupDTO.setOrderIds(orderIds);
		changeGroupDTO.setInfo(info);
		changeGroupDTO.setCurUserId(WebUtils.getCurUserId(request));
		changeGroupDTO.setCurUserName(WebUtils.getCurUser(request).getName());
		ToChangeGroupResult toChangeGroupResult = tourGroupFacade.changeGroup(changeGroupDTO);
		return successJson("groupId", toChangeGroupResult.getGroupId() + "", "mode",
				toChangeGroupResult.getTourGroup().getGroupMode() + "");
	}

	/**
	 * 复制为新团
	 * 
	 * @param request
	 * @param groupId
	 * @param orderId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toCopyTourGroup.htm")
	public String toCopyTourGroup(HttpServletRequest request, Integer groupId,
			Integer orderId, Model model) {

		/**
		 * 操作计调和销售计调默认为当前登陆用户
		 */
		model.addAttribute("groupId", groupId);
		model.addAttribute("orderId", orderId);
		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		model.addAttribute("groupOrder", groupOrder);
		return "sales/tourGroup/copyGroupInfo";
	}

	@RequestMapping(value = "/copyTourGroup.do")
	@ResponseBody
	public String copyTourGroup(HttpServletRequest request, String info,
			Integer orderId, Integer groupId, GroupOrder groupOrder,
			TourGroup tourGroup) {

		/*TourGroup group = tourGroupService.selectByPrimaryKey(groupId);
		group.setId(null);
		group.setCreateTime(System.currentTimeMillis());
		group.setTotalAdult(tourGroup.getTotalAdult());
		group.setTotalChild(tourGroup.getTotalChild());
		group.setTotalGuide(tourGroup.getTotalGuide());
		group.setGroupCode(settingCommon.getMyBizCode(request));//
		group.setGroupState(0); // 团状态，默认为0
		group.setDateStart(tourGroup.getDateStart());
		group.setDateEnd(tourGroup.getDateEnd());
		group.setTotalIncome(new BigDecimal(0));
		group.setTotalIncomeCash(new BigDecimal(0));
		group.setTotalCostCash(new BigDecimal(0));
		GroupOrder go = groupOrderService.selectByPrimaryKey(orderId);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		go.setDepartureDate(sdf.format(tourGroup.getDateStart()));
		go.setId(null);
		go.setCreateTime(System.currentTimeMillis());
		go.setSaleOperatorId(groupOrder.getSaleOperatorId());
		go.setSaleOperatorName(groupOrder.getSaleOperatorName());
		go.setOperatorId(groupOrder.getOperatorId());
		go.setOperatorName(groupOrder.getOperatorName());
		go.setContactName(groupOrder.getContactName());
		go.setContactTel(groupOrder.getContactMobile());
		go.setContactMobile(groupOrder.getContactMobile());
		go.setContactFax(groupOrder.getContactFax());
		go.setStateFinance(0);
		go.setOrderNo(settingCommon.getMyBizCode(request));// 订单号调用接口获取
		go.setNumAdult(tourGroup.getTotalAdult());
		go.setNumChild(tourGroup.getTotalChild());
		go.setNumGuide(tourGroup.getTotalGuide());
		go.setSupplierName(groupOrder.getSupplierName());
		go.setSupplierId(groupOrder.getSupplierId());
		go.setTotalCash(new BigDecimal(0));
		tourGroupService.copyGroup(group, go, groupId, orderId, info,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName());
*/
		CopyTourGroupDTO copyTourGroupDTO = new CopyTourGroupDTO();
		copyTourGroupDTO.setInfo(info);
		copyTourGroupDTO.setOrderId(orderId);
		copyTourGroupDTO.setGroupId(groupId);
		copyTourGroupDTO.setGroupOrder(groupOrder);
		copyTourGroupDTO.setTourGroup(tourGroup);
		teamGroupFacade.copyTourGroup(copyTourGroupDTO);
		return successJson();
	}

	@RequestMapping(value = "/getPushInfo.htm")
	public String getPushInfo(HttpServletRequest request, Model model,
			Integer groupId) {
		/*TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		model.addAttribute("tourGroup", tourGroup);
		GroupRouteVO groupRouteVO = groupRouteService
				.findGroupRouteByGroupId(groupId);
		List<GroupRouteDayVO> routeDayVOList = groupRouteVO
				.getGroupRouteDayVOList();
		model.addAttribute("routeList", routeDayVOList);

		List<GroupOrderGuest> guestList = new ArrayList<GroupOrderGuest>();
		List<GroupOrder> groupOrdrList = groupOrderService
				.selectOrderByGroupId(groupId);
		for (GroupOrder groupOrder : groupOrdrList) {
			List<GroupOrderGuest> selectByOrderId = groupOrderGuestService
					.selectByOrderId(groupOrder.getId());
			guestList.addAll(selectByOrderId);
		}

		model.addAttribute("guestList", guestList);

		BookingGuide guide = bookingGuideService.selectByGroupId(groupId);
		BookingSupplierDetail supplierDetail = null;
		if (guide != null) {
			supplierDetail = bookingSupplierDetailService
					.selectByPrimaryKey(guide.getBookingDetailId());
		}
		List<BookingSupplierDetail> driverList = bookingSupplierDetailService
				.getDriversByGroupIdAndType(groupId, Constants.FLEET);
		List<BookingShop> bookingShops = bookingShopService
				.getShopListByGroupId(groupId);
		List<BookingGuide> guides = bookingGuideService
				.selectGuidesByGroupId(groupId);
		model.addAttribute("bookingShops", bookingShops);
		model.addAttribute("guide", guide);
		model.addAttribute("supplierDetail", supplierDetail);
		model.addAttribute("groupId", groupId);
		model.addAttribute("driverList", driverList);
		model.addAttribute("guides", guides);*/
		GetPushInfoResult getPushInfoResult = tourGroupFacade.getPushInfo(groupId);
		model.addAttribute("tourGroup", getPushInfoResult.getTourGroup());
		model.addAttribute("routeList", getPushInfoResult.getRouteDayVOList());
		model.addAttribute("guestList", getPushInfoResult.getGuestList());
		model.addAttribute("bookingShops", getPushInfoResult.getBookingShops());
		model.addAttribute("guide", getPushInfoResult.getGuide());
		model.addAttribute("supplierDetail", getPushInfoResult.getSupplierDetail());
		model.addAttribute("groupId", groupId);
		model.addAttribute("driverList", getPushInfoResult.getDriverList());
		model.addAttribute("guides", getPushInfoResult.getGuides());

		return "sales/tourGroup/pushInfo";
	}

	@RequestMapping(value = "/updateGuide.do")
	@ResponseBody
	public String updateGuide(HttpServletRequest request, ModelMap model,
			Integer groupId, Integer driverId, Integer guideId) {
		/*BookingGuide guide = new BookingGuide();
		if (driverId == null) {
			driverId = -1;
		}
		guide.setId(guideId);
		guide.setBookingDetailId(driverId);
		guide.setGroupId(groupId);
		bookingGuideService.updateByPrimaryKeySelective(guide);*/
		ResultSupport resultSupport = tourGroupFacade.updateGuide(groupId, driverId,guideId);
		return successJson();
	}

	@RequestMapping(value = "/updateShop.do")
	@ResponseBody
	public String updateShop(HttpServletRequest request, ModelMap model,
			String guideName, Integer guideId, Integer shopId) {
	/*	if (guideId == null) {
			guideId = -1;
		}
		BookingShop bs = new BookingShop();
		bs.setId(shopId);
		bs.setGuideId(guideId);
		bs.setGuideName(guideName);
		bookingShopService.updateByPrimaryKeySelective(bs);*/
		ResultSupport resultSupport = tourGroupFacade.updateShop(guideName, guideId, shopId);
		return successJson();
	}

	@RequestMapping(value = "/pushInfo.do")
	@ResponseBody
	public String pushInfo(HttpServletRequest request, Integer groupId) {
		/*TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);

		List<Customer> customerList = new ArrayList<Customer>();

		// PlatformEmployeePo user = sysPlatformEmployeeFacade
		// .findByEmployeeId(tourGroup.getOperatorId());
		// Customer ct = new Customer();
		// ct.setName(user.getName());
		// ct.setMobile(user.getMobile());
		// ct.setGender((byte) user.getGender().intValue());
		// ct.setType((byte) 3);
		// ct.setBizId(WebUtils.getCurBizId(request));
		// customerList.add(ct);

		List<TravelHistoryRoute> travelHistoryRouteList = new ArrayList<TravelHistoryRoute>();
		List<GroupOrder> groupOrdrList = groupOrderService
				.selectOrderByGroupId(groupId);

		for (int i = 0; i < groupOrdrList.size(); i++) {

			List<GroupOrderGuest> selectByOrderId = groupOrderGuestService
					.selectByOrderId(groupOrdrList.get(i).getId());

			if (selectByOrderId != null && selectByOrderId.size() > 0) {
				for (GroupOrderGuest groupOrderGuest : selectByOrderId) {
					Customer customer = new Customer();
					customer.setName(groupOrderGuest.getName());
					customer.setMobile(groupOrderGuest.getMobile());
					customer.setAge(groupOrderGuest.getAge());
					customer.setGender((byte) groupOrderGuest.getGender()
							.intValue());
					customer.setIdentityNo(groupOrderGuest.getCertificateNum());
					customer.setIdentityType((byte) groupOrderGuest
							.getCertificateTypeId().intValue());
					customer.setNativePlaceName(groupOrderGuest
							.getNativePlace());
					customer.setNote(groupOrderGuest.getRemark());
					customer.setType((byte) 1);
					customer.setBizId(WebUtils.getCurBizId(request));
					customerList.add(customer);

					TravelHistoryRoute thr = new TravelHistoryRoute();
					thr.setGroupId(groupId);
					thr.setCreatorName(groupOrderGuest.getName());
					thr.setGroupDate(tourGroup.getDateStart());
					thr.setCreatorIdentity(groupOrderGuest.getCertificateNum());
					thr.setTotalDays(tourGroup.getDaynum());
					thr.setBizId(WebUtils.getCurBizId(request));
					thr.setCreateTime(new Timestamp(System.currentTimeMillis()));
					thr.setRouteTitle(tourGroup.getProductBrandName());
					thr.setRouteName(tourGroup.getProductName());
					thr.setUserType(1);
					thr.setFamilyNo(i + 1);
					travelHistoryRouteList.add(thr);
				}
			}

		}

		BookingGuide guide = bookingGuideService.selectByGroupId(groupId);
		if (guide != null) {
			SupplierGuide supplierGuide = supplierGuideService
					.getGuideInfoById(guide.getGuideId());
			Customer customer = new Customer();
			customer.setName(supplierGuide.getName());
			customer.setMobile(supplierGuide.getMobile());
			customer.setGender((byte) supplierGuide.getGender().intValue());
			customer.setIdentityNo(supplierGuide.getIdCardNo());
			customer.setNativePlaceName(supplierGuide.getNativePlace());
			customer.setType((byte) 2);
			customer.setBizId(WebUtils.getCurBizId(request));
			customerList.add(customer);

			TravelHistoryRoute thr = new TravelHistoryRoute();
			thr.setGroupId(groupId);
			thr.setCreatorName(supplierGuide.getName());
			thr.setGroupDate(tourGroup.getDateStart());
			thr.setCreatorIdentity(supplierGuide.getIdCardNo());
			thr.setTotalDays(tourGroup.getDaynum());
			thr.setBizId(WebUtils.getCurBizId(request));
			thr.setCreateTime(new Timestamp(System.currentTimeMillis()));
			thr.setRouteTitle(tourGroup.getProductBrandName());
			thr.setRouteName(tourGroup.getProductName());
			thr.setUserType(2);
			travelHistoryRouteList.add(thr);

		}

		try {
			customerService.batchInsertCustomer(customerList);
		} catch (Exception e) {
			log.error("推送APP错误信息:" + e.getMessage());
			return errorJson("推送信息失败,请检查客人信息是否正确");
		}

		try {
			travelHistoryRouteService.batchInsertTravelHistoryRoute(
					travelHistoryRouteList, groupId);
		} catch (Exception e) {
			log.error("推送APP错误信息:" + e.getMessage());
			return errorJson("推送信息失败,请检查行程信息是否正确");
		}*/

		ResultSupport resultSupport = tourGroupFacade.pushInfo(groupId);
		return successJson();

	}

	@RequestMapping(value = "/pushWap.do")
	@ResponseBody
	public String pushWap(HttpServletRequest request, Integer groupId) {
		/*TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		
		//团信息
		AssistantGroupVO groupVo = new AssistantGroupVO();
		AssistantGroup g = new AssistantGroup();
		List<AssistantGroupOrder> orderList = new ArrayList<AssistantGroupOrder>();
		List<AssistantGroupOrderGuest> orderGuestList = new ArrayList<AssistantGroupOrderGuest>();
		List<AssistantGroupOrderTransport> orderTransportList = new ArrayList<AssistantGroupOrderTransport>();
		List<AssistantGroupGuide> guideList = new ArrayList<AssistantGroupGuide>();
		List<AssistantGroupRoute> routeList = new ArrayList<AssistantGroupRoute>();
		List<AssistantGroupRouteSupplier> routeSupplierList = new ArrayList<AssistantGroupRouteSupplier>();
		List<AssistantGroupRouteAttachment> routeAttachList = new ArrayList<AssistantGroupRouteAttachment>();
		
		groupVo.setGroup(g);
		groupVo.setOrderList(orderList);
		groupVo.setOrderGuestList(orderGuestList);
		groupVo.setOrderTransportList(orderTransportList);
		groupVo.setGuideList(guideList);
		groupVo.setRouteList(routeList);
		groupVo.setRouteSupplierList(routeSupplierList);
		groupVo.setRouteAttachmentList(routeAttachList);
		
		
		//group赋值
		g.setBizId(tourGroup.getBizId());
		g.setId(0);
		g.setGroupId(groupId);
		g.setGroupMode(tourGroup.getGroupMode());
		g.setGroupCode(tourGroup.getGroupCode());
		g.setProductBrandName(tourGroup.getProductBrandName());
		g.setProductName(tourGroup.getProductName());
		g.setDaynum(tourGroup.getDaynum());
		g.setDateStart(DateUtils.format(tourGroup.getDateStart(), "yyyy-MM-dd"));
		g.setDateEnd(DateUtils.format(tourGroup.getDateEnd(),"yyyy-MM-dd"));
		g.setTotalAdult(tourGroup.getTotalAdult());
		g.setTotalChild(tourGroup.getTotalChild());
		g.setTotalGuide(tourGroup.getTotalGuide());
		g.setWarmNotice(tourGroup.getWarmNotice());
		g.setOperatorName(tourGroup.getOperatorName());
		g.setUpdateState(1);
		g.setUpdateTime(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		
		//groupOrder赋值
		List<GroupOrder> groupOrdrList = groupOrderService.selectOrderByGroupId(groupId);
		for (int i = 0; i < groupOrdrList.size(); i++) {
			GroupOrder ord = groupOrdrList.get(i);
			//订单信息
			AssistantGroupOrder ord1 = new AssistantGroupOrder();
			ord1.setId(0);
			ord1.setOrderId(ord.getId());
			ord1.setBizId(ord.getBizId());
			ord1.setGroupId(ord.getGroupId());
			ord1.setOrderType(ord.getOrderType());
			ord1.setSupplierName(ord.getSupplierName());
			ord1.setContactName(ord.getContactName());
			ord1.setContactTel(ord.getContactTel());
			ord1.setContactMobile(ord.getContactMobile());
			ord1.setSaleOperatorName(ord.getSaleOperatorName());
			ord1.setNumAdult(ord.getNumAdult());
			ord1.setNumChild(ord.getNumChild());
			ord1.setNumGuide(ord.getNumGuide());
			ord1.setDepartureDate(ord.getDepartureDate());
			ord1.setProductBrandName(ord.getProductBrandName());
			ord1.setProductName(ord.getProductName());
			ord1.setReceiveMode(ord.getReceiveMode());
			ord1.setState(ord.getState());
			ord1.setProvinceName(ord.getProvinceName());
			ord1.setCityName(ord.getCityName());
			orderList.add(ord1);
			
			//客人
			List<GroupOrderGuest> guestList = groupOrderGuestService.selectByOrderId(ord.getId());
			if (guestList != null && guestList.size() > 0) {
				for (GroupOrderGuest item : guestList) {
					AssistantGroupOrderGuest guest = new AssistantGroupOrderGuest();
					guest.setId(0);
					guest.setGroupId(tourGroup.getId());
					guest.setOrderId(item.getOrderId());
					guest.setName(item.getName());
					guest.setType(item.getType());
					guest.setCertificateNum(item.getCertificateNum());
					guest.setGender(item.getGender());
					guest.setMobile(item.getMobile());
					guest.setNativePlace(item.getNativePlace());
					guest.setAge(item.getAge());
					guest.setCareer(item.getCareer());
					guest.setIsSingleRoom(item.getIsSingleRoom());
					guest.setIsLeader(item.getIsLeader());
					guest.setIsGuide(item.getIsGuide()==null?0:item.getIsGuide());
					guest.setRemark(item.getRemark());
					orderGuestList.add(guest);
				}
			}
			//接送交通
			List<GroupOrderTransport> transList =  groupOrderTransportService.selectByOrderId(ord.getId());
			if (transList != null && transList.size() > 0) {
				for (GroupOrderTransport item : transList) {
					AssistantGroupOrderTransport trans = new AssistantGroupOrderTransport();
					trans.setId(0);
					trans.setGroupId(tourGroup.getId());
					trans.setOrderId(item.getOrderId());
					trans.setClassNo(item.getClassNo());
					trans.setDepartureCity(item.getDepartureCity());
					trans.setDepartureDate("".equals(item.getArrivalDate())?"": DateUtils.format(item.getDepartureDate()));
					trans.setDepartureTime(item.getDepartureTime());
					trans.setArrivalCity(item.getArrivalCity());
					trans.setArrivalDate("".equals(item.getArrivalDate())?"": DateUtils.format(item.getArrivalDate()));
					trans.setArrivalTime(item.getArrivalTime());
					trans.setTrans_type(item.getType());
					
					orderTransportList.add(trans);
				}
			}
			
			//TODO 订单行程 暂时先不做 
			
		}

		//guideList 司机及导游
		List<BookingGuide> gList = bookingGuideService.selectGuidesByGroupId(groupId);
		if (gList != null && gList.size() > 0) {
			for (BookingGuide item : gList) {
				AssistantGroupGuide gGuide = new AssistantGroupGuide();
				gGuide.setId(0);
				gGuide.setGroupId(groupId);
				gGuide.setGuideId(item.getGuideId());
				gGuide.setGuideName(item.getGuideName());
				gGuide.setState(item.getIsDefault());
				
				gGuide.setGuideGender(0);
				gGuide.setGuidePhoto("");
				gGuide.setGuideMobile("");
				gGuide.setGuideCertificateNo("");
				gGuide.setGuideLicenseNo("");
				gGuide.setDriverGender(0);
				gGuide.setDriverName("");
				gGuide.setDriverMobile("");
				gGuide.setDriverLicenseCar("");
				gGuide.setDriverPhoto("");
				gGuide.setDriverCompany("");
				gGuide.setDriverId(null == item.getDriverId()?0:item.getDriverId());
				
				SupplierGuide guideInfo = supplierGuideService.getGuideInfoById(item.getGuideId()); //数据库读取导游信息
				if (null != guideInfo){
					gGuide.setGuideMobile(guideInfo.getMobile());
					gGuide.setGuideCertificateNo(guideInfo.getIdCardNo());
					gGuide.setGuideLicenseNo(guideInfo.getLicenseNo());
					gGuide.setGuideGender(guideInfo.getGender()==0?1:0);  //导游基础信息1女，0男， 接口数据：0女，1男
				}
				if (null != item.getDriverId()){
					SupplierDriver sDriver = supplierDriverService.getDriverInfoById(item.getDriverId());//司机信息
					if (sDriver != null){
						gGuide.setDriverName(sDriver.getName());
						gGuide.setDriverMobile(sDriver.getMobile());
						gGuide.setDriverGender(sDriver.getGender()==0?1:0);  //司机基础信息1女，0男， 接口数据：0女，1男
					}
				}
				if (null != item.getBookingDetailId()){
					//车牌号
					BookingSupplierDetail bookingSupplierDetail = bookingSupplierDetailService.selectByPrimaryKey(item.getBookingDetailId());
					if (null != bookingSupplierDetail){
						gGuide.setDriverLicenseCar(bookingSupplierDetail.getCarLisence()); 
						//车队
						BookingSupplier bs = bookingSupplierService.selectByPrimaryKey(bookingSupplierDetail.getBookingId());
						gGuide.setDriverCompany(bs.getSupplierName());
					}
				}
				guideList.add(gGuide);
			}
		}
		
		//routeList 行程线路    
		List<GroupRoute> rlist = groupRouteService.selectByGroupId(groupId);
		if (rlist != null && rlist.size() > 0) {
			for (GroupRoute item : rlist) {
				AssistantGroupRoute gRoute = new AssistantGroupRoute();
				gRoute.setId(0);
				gRoute.setRouteId(item.getId());
				gRoute.setOrderId(0);
				gRoute.setGroupId(groupId);
				gRoute.setDayNum(item.getDayNum());
				gRoute.setGroupDate(DateUtils.format(item.getGroupDate()));
				gRoute.setBreakfast(item.getBreakfast());
				gRoute.setLunch(item.getLunch());
				gRoute.setSupper(item.getSupper());
				gRoute.setHotelName(item.getHotelName());
				gRoute.setRouteDesp(item.getRouteDesp());
				gRoute.setRouteTip(item.getRouteTip());
				
				routeList.add(gRoute);
			}
		}
		
		//routeSupplierList 行程路线每天的商家 
		List<GroupRouteSupplier> gslist = groupRouteService.selectGroupRouteSupplierByGroupId(groupId);
		if (gslist != null && gslist.size() > 0) {
			for (GroupRouteSupplier item : gslist) {
				AssistantGroupRouteSupplier gs = new AssistantGroupRouteSupplier();
				gs.setId(0);
				gs.setGroupId(groupId);
				gs.setOrderId(0);
				gs.setRouteId(item.getRouteId());
				gs.setSupplierType(item.getSupplierType());
				gs.setSupplierId(item.getSupplierId());
				gs.setSupplierName(item.getSupplierName());
				
				routeSupplierList.add(gs);
			}
		}


		//routeAttachList 行程路线每天图片
		List<GroupRouteAttachment> galist = groupRouteService.selectAttachmentByGroupId(groupId);
		if (galist != null && galist.size() > 0) {
			for (GroupRouteAttachment item : galist) {
				AssistantGroupRouteAttachment ra = new AssistantGroupRouteAttachment();
				ra.setId(0);
				ra.setGroupId(groupId);
				ra.setOrderId(0);
				ra.setRouteId(item.getObjId());
				ra.setName(item.getName());
				ra.setPath(item.getPath());
				routeAttachList.add(ra);
			}
		}
		
		//团行程用到的供应商及图片信息
		AssistantSupplierVO supplierVo = new AssistantSupplierVO();
		List<AssistantSupplier> supplierList = new ArrayList<AssistantSupplier>();
		List<AssistantSupplierImgType> supplierImgTypeList = new ArrayList<AssistantSupplierImgType>();
		List<AssistantSupplierImg> supplierImgList = new ArrayList<AssistantSupplierImg>();
		supplierVo.setSupplier(supplierList);
		supplierVo.setSupplierImgTypes(supplierImgTypeList);
		supplierVo.setSupplierImgs(supplierImgList);
		
		Set<Integer> supplierIds = new HashSet<Integer>();
		for(AssistantGroupRouteSupplier item : routeSupplierList){
			supplierIds.add(item.getSupplierId());
		}
		if (supplierIds.isEmpty())
			supplierIds.add(new Integer(0));
		
		List<SupplierInfo> supList = supplierService.selectSupplierListByIds(supplierIds);
		List<SupplierImgType>imgTypeList = supplierService.selectImgTypeBySupplierIds(supplierIds);
		List<SupplierImg> imgList = imgService.selectImgBySupplierIds(supplierIds);
		for(SupplierInfo item: supList){
			AssistantSupplier as = new AssistantSupplier();
			as.setId(0);
			as.setSupplierId(item.getId());
			as.setSupplierType(item.getSupplierType());
			as.setNameFull(item.getNameFull());
			as.setNameEn(item.getNameEn());
			as.setLevel("");
			as.setProvinceName(item.getProvinceName());
			as.setCityName(item.getCityName());
			as.setAreaName(item.getAreaName());
			as.setTownName(item.getTownName());
			as.setAddress(item.getAddress());
			as.setWebsite(item.getWebsite());
			as.setPositionLat(item.getPositionLat());
			as.setPositionLon(item.getPositionLon());
			as.setIntroBrief(item.getIntroBrief());
			as.setIntroTip(item.getIntroTip());
			as.setState(item.getState());
			supplierList.add(as);
		}
		for(SupplierImgType item: imgTypeList){
			AssistantSupplierImgType st = new AssistantSupplierImgType();
			st.setId(0);
			st.setImgtypeId(item.getId());
			st.setSupplierId(item.getSupplierId());
			st.setBussinessType(item.getBussinessType());
			st.setTypeCode(item.getTypeCode());
			st.setTypeName(item.getTypeName());
			supplierImgTypeList.add(st);
			
			for(SupplierImg imItem: imgList){
				if (imItem.getObjId().equals(item.getId())){
					AssistantSupplierImg im = new AssistantSupplierImg();
					im.setId(0);
					im.setImgId(imItem.getId());
					im.setImgName(imItem.getImgName());
					im.setImgPath(imItem.getImgPath());
					im.setImgtypeId(item.getId());
					supplierImgList.add(im);
				}
			}
		}
				
		String resultString = "{result: 'success',resultCode: '0',msg: ''}";
		try {
			String appKey = OpenPlatformConstannt.openAPI_AssistantMap.get("appKey");
			String secretKey = OpenPlatformConstannt.openAPI_AssistantMap.get("secretKey");
			String timeStamp = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
			String jsonStr = JSON.toJSONString(groupVo);
			String supplierInfo = JSON.toJSONString(supplierVo);
			//签名
			Map<String, String> params = new HashMap<String, String>();
	        params.put("appKey", appKey);
	        params.put("timestamp", timeStamp);
	        String getSign = MD5Util.getSign_Taobao(secretKey, params);
	        
	        // 访问接口
	        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
	        HttpPost httpPost = new HttpPost(OpenPlatformConstannt.openAPI_AssistantMap.get("Url") 
	                + OpenPlatformConstannt.openAPI_AssistantMap.get("pushMethod"));
	        
	        // 设置连接超时时间
	        RequestConfig requestConfig = RequestConfig.custom()
	                .setConnectTimeout(5000).setConnectionRequestTimeout(1000)
	                .setSocketTimeout(5000).build();
	        httpPost.setConfig(requestConfig);
	        
	        // 访问参数
	        List<NameValuePair> nameValuePairList = new ArrayList<NameValuePair>();
	        nameValuePairList.add(new BasicNameValuePair("appKey", appKey));
	        nameValuePairList.add(new BasicNameValuePair("timestamp", timeStamp));
	        nameValuePairList.add(new BasicNameValuePair("sign", getSign));
	        nameValuePairList.add(new BasicNameValuePair("jsonStr", jsonStr));
	        nameValuePairList.add(new BasicNameValuePair("supplierInfo", supplierInfo));
	        httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList, "utf-8"));

	        CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);
	        
	        try {
	            HttpEntity httpEntity = closeableHttpResponse.getEntity();
	            resultString = EntityUtils.toString(httpEntity);
	        } finally {
	            closeableHttpResponse.close();
	        }
	        
		} catch (Exception e) {
			log.error("推送APP错误信息:" + e.getMessage());
			return errorJson("推送信息失败"+e.getMessage());
		}*/

		PushWapResult pushWapResult = tourGroupFacade.pushWap(groupId);
		String resultString = "{result: 'success',resultCode: '0',msg: ''}";
		try {
			String appKey = OpenPlatformConstannt.openAPI_AssistantMap.get("appKey");
			String secretKey = OpenPlatformConstannt.openAPI_AssistantMap.get("secretKey");
			String timeStamp = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
			String jsonStr = JSON.toJSONString(pushWapResult.getGroupVo());
			String supplierInfo = JSON.toJSONString(pushWapResult.getSupplierVo());
			//签名
			Map<String, String> params = new HashMap<String, String>();
			params.put("appKey", appKey);
			params.put("timestamp", timeStamp);
			String getSign = MD5Util.getSign_Taobao(secretKey, params);

			// 访问接口
			CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(OpenPlatformConstannt.openAPI_AssistantMap.get("Url")
					+ OpenPlatformConstannt.openAPI_AssistantMap.get("pushMethod"));

			// 设置连接超时时间
			RequestConfig requestConfig = RequestConfig.custom()
					.setConnectTimeout(5000).setConnectionRequestTimeout(1000)
					.setSocketTimeout(5000).build();
			httpPost.setConfig(requestConfig);

			// 访问参数
			List<NameValuePair> nameValuePairList = new ArrayList<NameValuePair>();
			nameValuePairList.add(new BasicNameValuePair("appKey", appKey));
			nameValuePairList.add(new BasicNameValuePair("timestamp", timeStamp));
			nameValuePairList.add(new BasicNameValuePair("sign", getSign));
			nameValuePairList.add(new BasicNameValuePair("jsonStr", jsonStr));
			nameValuePairList.add(new BasicNameValuePair("supplierInfo", supplierInfo));
			httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList, "utf-8"));

			CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);

			try {
				HttpEntity httpEntity = closeableHttpResponse.getEntity();
				resultString = EntityUtils.toString(httpEntity);
			} finally {
				closeableHttpResponse.close();
			}

		} catch (Exception e) {
			log.error("推送APP错误信息:" + e.getMessage());
			return errorJson("推送信息失败"+e.getMessage());
		}
		return resultString;

	}
	
	/**
	 * 根据groupID返回团信息的json格式数据
	 * 
	 * @param request
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "/toEditGroup.do")
	@ResponseBody
	public String toEditGroup(HttpServletRequest request, Integer groupId) {
		/*TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		Gson gson = new Gson();
		String json = gson.toJson(tourGroup);*/

		ToChangeGroupResult toChangeGroupResult = tourGroupFacade.toEditGroup(groupId);
		Gson gson = new Gson();
		String json = gson.toJson(toChangeGroupResult.getTourGroup());
		return json;
	}

	/**
	 * 跳转到新增或修改旅行团订单页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toAddTourGroupOrder", method = RequestMethod.GET)
	// @RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String toAddTourGroupOrder(HttpServletRequest request,
			Integer groupId, Integer orderId, Model model, Integer state) {
		/**
		 * 如果订单id==null,团id!=null，多查询一次订单id
		 */
	/*	if (orderId == null && groupId != null) {
			// 定制团中团和订单一对一的关系
			List<GroupOrder> orders = groupOrderService
					.selectOrderByGroupId(groupId);
			if (orders.size() > 0) {
				// 防止别人调错，多加一层验证
				if (orders.get(0).getOrderType() == 1) {
					orderId = orders.get(0).getId();
				}
			}
		}

		int bizId = WebUtils.getCurBizId(request);
		// 收费类型
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		GroupOrder groupOrder = null;
		TourGroup tourGroup = null;
		if (orderId != null) {
			Map<String, Object> map = tourGroupService
					.selectByGroupOrderId(orderId);
			groupOrder = (GroupOrder) map.get("groupOrder");
			tourGroup = (TourGroup) map.get("tourGroup");
			if (null != state && state.equals(4)) {
				*//**
				 * state=0的时候，只能查看，所以可以在这里设置财务状态等于1，财务状态=1的时候也只能查看
				 *//*
				model.addAttribute("stateFinance", 1);
				model.addAttribute("state", state);
			} else {
				if (null != groupOrder.getStateFinance()) {
					model.addAttribute("stateFinance",
							groupOrder.getStateFinance());
				} else {
					model.addAttribute("stateFinance", 0);
				}
				*//**
				 * 将团状态放到model中是为了：当团状态为已确认团的时候，控制成本为不可维护
				 *//*
				model.addAttribute("state", state);
			}
			List<RegionInfo> cityList = null;
			if (groupOrder.getProvinceId() != null
					&& groupOrder.getProvinceId() != -1) {
				cityList = regionService.getRegionById(groupOrder
						.getProvinceId() + "");
			}
			model.addAttribute("allCity", cityList);
		} else if (groupId != null && orderId == null) {
			*//**
			 * 操作计调和销售计调默认为当前登陆用户
			 *//*
			groupOrder = new GroupOrder();
			tourGroup = tourGroupService.selectByPrimaryKey(groupId);
			groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
			*//**
			 * 新增的时候财务默认状态未审核
			 *//*
			if (null != state && state.equals(4)) {
				model.addAttribute("stateFinance", 1);
			} else {
				model.addAttribute("stateFinance", 0);
				model.addAttribute("state", state);
			}
		} else {
			*//**
			 * 操作计调和销售计调默认为当前登陆用户
			 *//*
			groupOrder = new GroupOrder();
			tourGroup = new TourGroup();
			groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
			groupOrder.setOperatorId(WebUtils.getCurUserId(request));
			groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
			groupOrder.setSaleOperatorName(WebUtils.getCurUser(request)
					.getName());
			*//**
			 * 新增的时候财务默认状态未审核
			 *//*
			if (null != state && state.equals(4)) {
				model.addAttribute("stateFinance", 1);
			} else {
				model.addAttribute("stateFinance", 0);
				model.addAttribute("state", state);
			}
		}
		model.addAttribute("typeList", typeList);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("tourGroup", tourGroup);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);*/


		ToAddTourGroupOrderResult toAddTourGroupOrderResult = tourGroupFacade.toAddTourGroupOrder(groupId, orderId, state, WebUtils.getCurUser(request).getName(), WebUtils.getCurUserId(request), WebUtils.getCurBizId(request));
		model.addAttribute("allCity", toAddTourGroupOrderResult.getCityList());
		model.addAttribute("stateFinance", toAddTourGroupOrderResult.getStateFinance());
		model.addAttribute("state", toAddTourGroupOrderResult.getState());
		model.addAttribute("typeList", toAddTourGroupOrderResult.getTypeList());
		model.addAttribute("groupOrder", toAddTourGroupOrderResult.getGroupOrder());
		model.addAttribute("tourGroup", toAddTourGroupOrderResult.getTourGroup());
		model.addAttribute("sourceTypeList", toAddTourGroupOrderResult.getSourceTypeList());
		model.addAttribute("allProvince", toAddTourGroupOrderResult.getAllProvince());

		logger.info("跳转到添加旅行团订单信息页面");
		return "sales/tourGroup/groupOrderDetail";
	}

	/**
	 * 保存或修改旅行团订单信息
	 * 
	 * @param tourGroup
	 * @param groupOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveTourGroupOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveTourGroupOrder(HttpServletRequest request,
			TourGroup tourGroup, GroupOrder groupOrder, Model model) {
	/*	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

		 // 页面传过来的订单id不为空的时候新增，为空的时候修改

		if (groupOrder.getId() == null) {
			tourGroup.setBizId(WebUtils.getCurBizId(request)); // 用当前登陆用户ID表示商家ID
			tourGroup.setGroupCode(settingCommon.getMyBizCode(request));//
			tourGroup.setGroupState(0); // 团状态，默认为0
			tourGroup.setCreateTime(new Date().getTime()); // 创建时间
			groupOrder.setBizId(WebUtils.getCurBizId(request)); // 用当前登陆用户ID表示商家ID
			groupOrder.setState(1);
			groupOrder.setBizId(WebUtils.getCurBizId(request));
			groupOrder.setOrderNo(settingCommon.getMyBizCode(request));// 订单号调用接口获取
			groupOrder.setCreatorId(groupOrder.getOperatorId()); // 操作人和操作计调相同
			groupOrder.setCreatorName(groupOrder.getOperatorName());
			groupOrder.setCreateTime(new Date().getTime()); // 创建时间
			groupOrder.setOrderType(1); // 定制团订单
			groupOrder = tourGroupService
					.insertSelective(tourGroup, groupOrder);
			logger.info("后台保存旅行团和旅行团订单信息成功");
		} else {
			tourGroup.setId(groupOrder.getGroupId());
			TourGroup tourGroup2 = tourGroupService
					.selectByPrimaryKey(tourGroup.getId());
			if (tourGroup.getDateStart().compareTo(tourGroup2.getDateStart()) != 0) {
				tourGroup.setGroupCode(settingCommon.getMyBizCode(request));
				List<GroupRoute> list = groupRouteService
						.selectByGroupId(tourGroup.getId());
				if (list != null && list.size() > 0) {
					Date startTime = tourGroup.getDateStart();
					Calendar cal = Calendar.getInstance();
					cal.setTime(startTime);
					cal.add(Calendar.DAY_OF_MONTH, +(list.size() - 1));
					Date time = cal.getTime();
					tourGroup.setDateEnd(time);
				}
				groupOrder.setOrderNo(settingCommon.getMyBizCode(request));
			} else {
				tourGroup
						.setGroupCode(GroupCodeUtil.getCode(
								tourGroup2.getGroupCode(),
								tourGroup.getGroupCodeMark()));
			}
			tourGroup.setUpdateId(WebUtils.getCurUserId(request));
			tourGroup.setUpdateName(WebUtils.getCurUser(request).getName());
			tourGroup.setUpdateTime(System.currentTimeMillis());
			groupOrder = tourGroupService.updateByPrimaryKeySelective(
					tourGroup, groupOrder);
			logger.info("后台更新旅行团和旅行团订单信息成功");
		}
		Gson gson = new Gson();
		String string = gson.toJson(groupOrder);*/

		ToChangeGroupResult toChangeGroupResult = tourGroupFacade.saveTourGroupOrder(tourGroup, groupOrder, WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getOrgId(), WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName());
		Gson gson = new Gson();
		String string = gson.toJson(toChangeGroupResult.getGroupOrde());
		return string;
	}

	@RequestMapping(value = "/unifiedSaveOtherInfo.do")
	@ResponseBody
	public String unifiedSaveOtherInfo(HttpServletRequest request,
			OtherInfoVO otherInfoVO) {

		/*List<GroupOrderPrice> priceList = otherInfoVO.getGroupOrderPriceList();
		if (priceList != null && priceList.size() > 0) {
			for (GroupOrderPrice groupOrderPrice : priceList) {
				groupOrderPrice.setCreateTime(System.currentTimeMillis());
				groupOrderPrice.setRowState(0);
				groupOrderPrice.setItemName(dicService.getById(
						groupOrderPrice.getItemId() + "").getValue());
				groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
				groupOrderPrice.setCreatorName(WebUtils.getCurUser(request)
						.getName());
				groupOrderPriceService.insertSelective(groupOrderPrice);
			}
		}
		List<GroupOrderTransport> tranList = otherInfoVO
				.getGroupOrderTransportList();
		if (tranList != null && tranList.size() > 0) {
			for (GroupOrderTransport groupOrderTransport : tranList) {
				groupOrderTransport.setCreateTime(System.currentTimeMillis());
				groupOrderTransportService.insertSelective(groupOrderTransport);
			}
		}

		List<GroupOrderPrice> costList = otherInfoVO.getGroupOrderCostList();
		if (costList != null && costList.size() > 0) {
			for (GroupOrderPrice groupOrderPrice : costList) {
				groupOrderPrice.setCreateTime(System.currentTimeMillis());
				groupOrderPrice.setRowState(0);
				groupOrderPrice.setItemName(dicService.getById(
						groupOrderPrice.getItemId() + "").getValue());
				groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
				groupOrderPrice.setCreatorName(WebUtils.getCurUser(request)
						.getName());
				groupOrderPriceService.insertSelective(groupOrderPrice);
			}
		}

		List<GroupOrderGuest> guestList = otherInfoVO.getGroupOrderGuestList();
		if (guestList != null && guestList.size() > 0) {
			for (GroupOrderGuest groupOrderGuest : guestList) {
				groupOrderGuestService.insertSelective(groupOrderGuest);
			}
		}*/

		ResultSupport resultSupport = tourGroupFacade.unifiedSaveOtherInfo(otherInfoVO, WebUtils.getCurUser(request).getName(), WebUtils.getCurUserId(request));
		return successJson();

	}

	/**
	 * 跳转到组团新增中其他信息页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toOtherInfo", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String toOtherInfo(HttpServletRequest request, Integer orderId,
			Integer stateFinance, Model model, Integer state) {

		/*int bizId = WebUtils.getCurBizId(request);
		
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);

		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);

		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);

		// 0表示收入
		List<GroupOrderPrice> groupOrderPricesZero = groupOrderPriceService
				.selectByOrderAndType(orderId, 0);
		model.addAttribute("incomeList", groupOrderPricesZero);
		// 1表示成本
		List<GroupOrderPrice> groupOrderPricesOne = groupOrderPriceService
				.selectByOrderAndType(orderId, 1);
		model.addAttribute("costList", groupOrderPricesOne);

		// 接送信息
		List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
				.selectByOrderId(orderId);
		model.addAttribute("groupOrderTransports", groupOrderTransports);

		// 客人列表
		List<GroupOrderGuest> groupOrderGuests = groupOrderGuestService
				.selectByOrderId(orderId);
		// StringBuilder sb = new StringBuilder();
		for (GroupOrderGuest guest : groupOrderGuests) {
			List<GroupOrderGuest> guests = groupOrderGuestService
					.getGuestByGuestCertificateNum(guest.getCertificateNum(),
							guest.getOrderId());
			guest.setHistoryNum(guests.size());
			// sb.append(guest.getCertificateNum()+",") ;
		}
		*//* model.addAttribute("cerNums", sb.toString()); *//*
		model.addAttribute("groupOrderGuests", groupOrderGuests);
		model.addAttribute("orderId", orderId);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("stateFinance", stateFinance);
		model.addAttribute("groupId", groupOrder.getGroupId());
		model.addAttribute("state", state);
		logger.info("跳转到添加旅行团其他信息页面");*/

		ToOtherInfoResult toOtherInfoResult = tourGroupFacade.toOtherInfo(orderId, stateFinance, state, WebUtils.getCurBizId(request));
		model.addAttribute("jtfsList", toOtherInfoResult.getJtfsList());
		model.addAttribute("zjlxList", toOtherInfoResult.getZjlxList());
		model.addAttribute("lysfxmList", toOtherInfoResult.getLysfxmList());
		model.addAttribute("incomeList", toOtherInfoResult.getGroupOrderPricesZero());
		model.addAttribute("costList", toOtherInfoResult.getGroupOrderPricesOne());
		model.addAttribute("groupOrderTransports", toOtherInfoResult.getGroupOrderTransports());
		model.addAttribute("groupOrderGuests", toOtherInfoResult.getGroupOrderGuests());
		model.addAttribute("orderId", orderId);
		model.addAttribute("groupOrder", toOtherInfoResult.getGroupOrder());
		model.addAttribute("stateFinance", stateFinance);
		model.addAttribute("groupId", toOtherInfoResult.getGroupOrder().getId());
		model.addAttribute("state", state);
		return "sales/tourGroup/otherInfo";
	}

	/**
	 * 跳转到组团新增中计调需求页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/togroupRequirement", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String togroupRequirement(Integer orderId, Integer stateFinance,
			Model model, Integer state) {

		/*GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		// 车辆型号
		List<DicInfo> ftcList = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("ftcList", ftcList);
		// 酒店星级
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		// 酒店信息
		List<GroupRequirement> grogShopList = groupRequirementService
				.selectByOrderAndType(orderId, 3);
		model.addAttribute("grogShopList", grogShopList);
		// 车队信息
		List<GroupRequirement> motorcadeList = groupRequirementService
				.selectByOrderAndType(orderId, 4);
		model.addAttribute("motorcadeList", motorcadeList);
		// 机票信息
		List<GroupRequirement> airTicketList = groupRequirementService
				.selectByOrderAndType(orderId, 9);
		model.addAttribute("airTicketList", airTicketList);
		// 火车信息
		List<GroupRequirement> railwayTicketList = groupRequirementService
				.selectByOrderAndType(orderId, 10);
		model.addAttribute("railwayTicketList", railwayTicketList);
		// 导游信息
		List<GroupRequirement> guideList = groupRequirementService
				.selectByOrderAndType(orderId, 8);
		model.addAttribute("guideList", guideList);
		// 餐厅信息
		List<GroupRequirement> restaurantList = groupRequirementService
				.selectByOrderAndType(orderId, 2);
		model.addAttribute("restaurantList", restaurantList);
		model.addAttribute("orderId", orderId);
		model.addAttribute("stateFinance", stateFinance);
		model.addAttribute("groupId", groupOrder.getGroupId());
		model.addAttribute("state", state);
		logger.info("跳转到添加旅行团计调需求页面");*/

		TogroupRequirementResult togroupRequirementResult = tourGroupFacade.togroupRequirement(orderId, stateFinance,state);
		model.addAttribute("ftcList", togroupRequirementResult.getFtcList());
		model.addAttribute("jdxjList", togroupRequirementResult.getJdxjList());
		// 酒店信息
		model.addAttribute("grogShopList", togroupRequirementResult.getGrogShopList());
		// 车队信息
		model.addAttribute("motorcadeList", togroupRequirementResult.getMotorcadeList());
		// 机票信息
		model.addAttribute("airTicketList", togroupRequirementResult.getAirTicketList());
		// 火车信息
		model.addAttribute("railwayTicketList", togroupRequirementResult.getRailwayTicketList());
		// 导游信息
		model.addAttribute("guideList", togroupRequirementResult.getGuideList());
		// 餐厅信息
		model.addAttribute("restaurantList", togroupRequirementResult.getRestaurantList());
		model.addAttribute("orderId", orderId);
		model.addAttribute("stateFinance", stateFinance);
		model.addAttribute("groupId", togroupRequirementResult.getGroupId());
		model.addAttribute("state", state);
		return "sales/tourGroup/groupRequirement";
	}

	/**
	 * 团查询管理页面（未确认团、已确认团）
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toGroupList.htm")
	public String toGroupList(HttpServletRequest request, Model model) {
	/*	Integer bizId = WebUtils.getCurBizId(request);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));*/
		ToGroupListResult toGroupListResult = teamGroupFacade.toGroupList(WebUtils.getCurBizId(request));
		model.addAttribute("allProvince", toGroupListResult.getAllProvince());
		model.addAttribute("orgJsonStr",
				toGroupListResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",
				toGroupListResult.getOrgUserJsonStr());
		return "sales/tourGroup/groupList";
	}

	/**
	 * 旅行团条件查询
	 * 
	 * @param request
	 * @param groupOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "findTourGroupByCondition.htm")
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String findTourGroupByCondition(HttpServletRequest request,
			String yesOrNo, GroupOrder groupOrder, Model model) {
	/*	List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		*//**
		 * yesOrNo 确认团和未确认团的标记
		 *//*
		String url = "sales/tourGroup/groupOrderManageUnconfirmed";
		if (null != yesOrNo && yesOrNo.equals("yes")) {
			url = "sales/tourGroup/groupOrderManageConfirmed";
		}
		// 团开始日期默认当前月第一天到最后一天
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		// 获取当前月第一天：
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, 0);
		c.set(Calendar.DAY_OF_MONTH, 1);// 设置为1号,当前日期既为本月第一天
		String first = format.format(c.getTime());
		model.addAttribute("first", first);
		// 获取当前月最后一天
		Calendar ca = Calendar.getInstance();
		ca.set(Calendar.DAY_OF_MONTH,
				ca.getActualMaximum(Calendar.DAY_OF_MONTH));
		String last = format.format(ca.getTime());
		model.addAttribute("last", last);

		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));*/

		ToGroupListResult toGroupListResult = tourGroupFacade.findTourGroupByCondition(yesOrNo, groupOrder, WebUtils.getCurBizId(request));
		String url = "sales/tourGroup/groupOrderManageUnconfirmed";
		if (null != yesOrNo && yesOrNo.equals("yes")) {
			url = "sales/tourGroup/groupOrderManageConfirmed";
		}
		// 团开始日期默认当前月第一天到最后一天
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		// 获取当前月第一天：
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, 0);
		c.set(Calendar.DAY_OF_MONTH, 1);// 设置为1号,当前日期既为本月第一天
		String first = format.format(c.getTime());
		model.addAttribute("first", first);
		// 获取当前月最后一天
		Calendar ca = Calendar.getInstance();
		ca.set(Calendar.DAY_OF_MONTH,
				ca.getActualMaximum(Calendar.DAY_OF_MONTH));
		String last = format.format(ca.getTime());
		model.addAttribute("last", last);
		model.addAttribute("allProvince", toGroupListResult.getAllProvince());
		model.addAttribute("orgJsonStr",toGroupListResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",toGroupListResult.getOrgUserJsonStr());
		return url;
	}

	@RequestMapping("findTourGroupLoadModel.do")
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String findTourGroupByConditionLoadModel(HttpServletRequest request,
			GroupOrder groupOrder, Model model) throws ParseException {

/*
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();

		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage());

		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
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
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (groupOrder.getStartTime() != null
					&& groupOrder.getStartTime() != "") {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime())
						.getTime() + "");
			}
			if (groupOrder.getEndTime() != null
					&& groupOrder.getEndTime() != "") {
				Calendar calendar = new GregorianCalendar();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
		}
		pageBean.setParameter(groupOrder);
		pageBean = groupOrderService.selectByConListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request), 0);
		Integer pageTotalAudit = 0;
		Integer pageTotalChild = 0;
		Integer pageTotalGuide = 0;
		List<GroupOrder> result = pageBean.getResult();
		if (result != null && result.size() > 0) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (GroupOrder groupOrder2 : result) {
				if (groupOrder2.getCreateTime() != null) {
					Long createTime = groupOrder2.getTourGroup()
							.getCreateTime();
					String dateStr = sdf.format(createTime);
					groupOrder2.getTourGroup().setCreateTimeStr(dateStr);
				}
				if (groupOrder2.getTourGroup().getUpdateTime() != null) {
					Long updateTime = groupOrder2.getTourGroup()
							.getUpdateTime();
					String dateStr = sdf.format(updateTime);
					groupOrder2.getTourGroup().setUpdateTimeStr(dateStr);
				} else {
					groupOrder2.getTourGroup().setUpdateTimeStr("无");
					groupOrder2.getTourGroup().setUpdateName("无");
				}
				pageTotalAudit += groupOrder2.getNumAdult();
				pageTotalChild += groupOrder2.getNumChild();
				pageTotalGuide += groupOrder2.getNumGuide();
			}
		}

		model.addAttribute("pageTotalAudit", pageTotalAudit);
		model.addAttribute("pageTotalChild", pageTotalChild);
		model.addAttribute("pageTotalGuide", pageTotalGuide);
		GroupOrder order = groupOrderService.selectTotalByCon(groupOrder,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request), 0);

		model.addAttribute("totalAudit",
				order == null ? 0 : order.getNumAdult());
		model.addAttribute("totalChild",
				order == null ? 0 : order.getNumChild());
		model.addAttribute("totalGuide",
				order == null ? 0 : order.getNumGuide());

		*//**
		 * 根据组团社id获取组团社名称
		 *//*
		List<GroupOrder> groupList = pageBean.getResult();
		model.addAttribute("groupList", groupList);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("page", pageBean);*/

		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();

		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage());

		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
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
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (groupOrder.getStartTime() != null
					&& groupOrder.getStartTime() != "") {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime())
						.getTime() + "");
			}
			if (groupOrder.getEndTime() != null
					&& groupOrder.getEndTime() != "") {
				Calendar calendar = new GregorianCalendar();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
		}
		pageBean.setParameter(groupOrder);

		FindTourGroupByConditionDTO findTourGroupByConditionDTO = new FindTourGroupByConditionDTO();
		findTourGroupByConditionDTO.setGroupOrder(groupOrder);
		findTourGroupByConditionDTO.setCurBizId(WebUtils.getCurBizId(request));
		findTourGroupByConditionDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		FindTourGroupByConditionResult findTourGroupByConditionResult = teamGroupFacade.findTourGroupByConditionLoadModel(findTourGroupByConditionDTO);

		model.addAttribute("pageTotalAudit", findTourGroupByConditionResult.getPageTotalAudit());
		model.addAttribute("pageTotalChild", findTourGroupByConditionResult.getPageTotalChild());
		model.addAttribute("pageTotalGuide", findTourGroupByConditionResult.getPageTotalGuide());

		model.addAttribute("totalAudit",findTourGroupByConditionResult.getOrder() == null ? 0 : findTourGroupByConditionResult.getOrder().getNumAdult());
		model.addAttribute("totalChild",findTourGroupByConditionResult.getOrder() == null ? 0 : findTourGroupByConditionResult.getOrder().getNumChild());
		model.addAttribute("totalGuide",findTourGroupByConditionResult.getOrder() == null ? 0 : findTourGroupByConditionResult.getOrder().getNumGuide());

		model.addAttribute("groupList", findTourGroupByConditionResult.getPageBean().getResult());
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("page", findTourGroupByConditionResult.getPageBean());
		return "sales/tourGroup/groupTable";
	}

	/**
	 * 订单打印
	 * 
	 * @param orderId
	 * @param request
	 * @param response
	 */
	@RequestMapping("download.htm")
	public void downloadFile(Integer orderId, Integer num,Integer agency,
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
			path = createSalesConfirm(request, orderId,agency);
			try {
				fileName = new String("确认单.doc".getBytes("UTF-8"), "iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}// 为了解决中文名称乱码问题
		} else if (num == 2) {
			try {
				fileName = new String("结算单.doc".getBytes("UTF-8"), "iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createSalesCharge(request, orderId);
		} else if (num == 3) {
			try {
				fileName = new String("客人名单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createGuestNames(request, orderId);
		} else if (num == 4) {
			// 销售确认单-无行程
			try {
				fileName = new String("确认单-无行程.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createSalesConfirmNoRoute(request, orderId);
		} else if (num == 5) {
			// 销售价格单-无行程
			try {
				fileName = new String("结算单-无行程.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createSalesChargeNoRoute(request, orderId);
		}else if (num == 6) {
			// 境内旅游合同
			try {
				fileName = new String("境内旅游合同.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = saleTravelContract(request, orderId);
		}else if (num == 7) {
			// 旅游综合保障计划投保书
			try {
				fileName = new String("旅游综合保障计划投保书.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = saleInsurance(request, orderId);
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
			os.flush();
			os.close();
			file.delete();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * ---------------------------------订单打印部分----------------------------------
	 * ----
	 **/
	/**
	 * 生成销售订单
	 * 
	 * @param
	 * @return
	 */
	public String createSalesConfirm(HttpServletRequest request, Integer orderId,Integer agency) {
		/*String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		List<GroupOrderPrice> prices = groupOrderPriceService
				.selectByOrder(orderId);
		if(agency!=1){
			GroupOrderPrice gop = new GroupOrderPrice();
			gop.setItemName(com.yihg.sales.constants.Constants.PRICETYPE);
			gop.setUnitPrice(com.yihg.sales.constants.Constants.PRICE);
			gop.setNumTimes(com.yihg.sales.constants.Constants.TIMES);
			gop.setNumPerson(new Double(groupOrderService.selectTotalNumByOrderId(orderId)))  ;
			gop.setTotalPrice(gop.getUnitPrice()*gop.getNumPerson());
			prices.add(gop) ;
		}
		List<GroupRoute> routes = groupRouteService.selectByOrderId(orderId);
		SupplierInfo supplier = supplierService.selectBySupplierId(groupOrder
				.getSupplierId());
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_confirm.docx");
		if (groupOrder.getOrderType() != 1) {
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/sales_skconfirm.docx");
		}
		if(agency==1){
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/agency_sales_confirm.docx");
		}
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		*//**
		 * logo图标和标题
		 *//*
		*//*
		 * String imgPath = WebUtils.getCurBizLogo(config.getImgServerUrl(),
		 * request);
		 *//*
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("product", groupOrder.getProductName());
		params1.put("printName", WebUtils.getCurUser(request).getName());
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

		Map<String, Object> map0 = new HashMap<String, Object>();
		// 收件方信息
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		// 发件方信息（定制团显示为销售）
		// 销售计调的组织机构信息
		PlatformEmployeePo employee = sysPlatformEmployeeFacade
				.findByEmployeeId(groupOrder.getSaleOperatorId()).getPlatformEmployeePo();
		map0.put("company", orgService.findByOrgId(employee.getOrgId())
				.getName()); // 当前单位
		map0.put("user_name", employee.getName());
		map0.put("user_tel", employee.getMobile());
		map0.put("user_fax", employee.getFax());

		// 统计订单下的全陪
		String guestGuideString = "";
		// 订单所属团下的所有导游
		String guideString = "";
		// 根据散客订单统计客人信息
		List<BookingGuide> guides = null;
		if (null != groupOrder.getGroupId()) {
			guides = bookingGuideService.selectGuidesByGroupId(groupOrder
					.getGroupId());
			StringBuilder sb = new StringBuilder();
			SupplierGuide sg = null;
			for (BookingGuide guide : guides) {
				sg = guideService.getGuideInfoById(guide.getGuideId());
				sb.append(guide.getGuideName() + " " + guide.getGuideMobile()
						+ " " + sg.getLicenseNo() + "\n");
			}
			guideString = sb.toString();
		}

		if (guests.size() > 0) {
			StringBuilder sb = new StringBuilder();
			for (GroupOrderGuest guest : guests) {
				if (guest.getType() == 3) {
					sb.append(guest.getName() + " " + guest.getMobile());
				}
			}
			guestGuideString = sb.toString();
		}
		Map<String, Object> map1 = new HashMap<String, Object>();
		if (null == groupOrder.getTourGroup()) {
			map1.put("groupCode", "");
		} else {
			map1.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		}
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("departureDate", groupOrder.getDepartureDate());
		map1.put("receiveMode", groupOrder.getReceiveMode());
		map1.put(
				"place",
				(groupOrder.getProvinceName() == null ? "" : groupOrder
						.getProvinceName())
						+ (groupOrder.getCityName() == null ? "" : groupOrder
								.getCityName()));
		map1.put("guideString", guideString);
		map1.put("guestGuideString", guestGuideString);
		map1.put("productName",
				"【"
						+ (groupOrder.getProductBrandName() == null ? ""
								: groupOrder.getProductBrandName())
						+ "】"
						+ (groupOrder.getProductName() == null ? ""
								: groupOrder.getProductName()));

		*//**
		 * 行程列表表格
		 *//*
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		for (GroupRoute groupRoute : routes) {
			Map<String, String> map = new HashMap<String, String>();
			if (null != groupRoute.getGroupDate()) {
				map.put("day_num", DateUtils.format(groupRoute.getGroupDate()));
			} else {
				map.put("day_num", "");
			}
			map.put("route_desp", groupRoute.getRouteDesp());
			map.put("breakfast", groupRoute.getBreakfast());
			map.put("lunch", groupRoute.getLunch());
			map.put("supper", groupRoute.getSupper());
			map.put("hotel_name", groupRoute.getHotelName());
			routeList.add(map);
		}
		*//**
		 * 收入表格
		 *//*
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+NumberUtil.formatDouble(totalNum)+",已收:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}

		*//**
		 * 客人信息
		 *//*
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();

		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("mobile", (guests.get(x).getMobile() == null ? "" : guests
					.get(x).getMobile()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			map.put("age", (guests.get(x).getAge() == null ? "" : guests.get(x)
					.getAge()) + "");
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			map.put("place", (guests.get(x).getNativePlace() == null ? ""
					: guests.get(x).getNativePlace()));
			guestList.add(map);
		}
		Map<String, Object> map6 = new HashMap<String, Object>();
		// 根据散客订单统计酒店信息
		List<GroupRequirement> grogShopList = groupRequirementService
				.selectByOrderAndType(groupOrder.getId(), 3);
		// 根据散客订单统计接机信息
		List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
				.selectByOrderId(groupOrder.getId());
		if (null != grogShopList && grogShopList.size() > 0) {
			map6.put("hotelNum", getHotelNum(grogShopList));
		} else {
			map6.put("hotelNum", "");
		}
		if(agency!=1){
			if (null != groupOrderTransports && groupOrderTransports.size() > 0) {
				map6.put("upAndOff", "接机：" + getAirInfo(groupOrderTransports, 0)
						+ "\n" + "送机：" + getAirInfo(groupOrderTransports, 1) + "\n"
						+ "省内交通：" + getSourceType(groupOrderTransports));
			} else {
				map6.put("upAndOff", "");
			}
		}
		map6.put("Remark", groupOrder.getRemark());
		map6.put("Service", groupOrder.getServiceStandard());
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			export.export(routeList, 2);
			if(agency!=1){
				export.export(priceList, 3, true);
			}else{
				export.export(priceList, 3);
			}
			
			if (groupOrder.getOrderType() != 1 && agency!=1) {
				export.export(guestList, 4);
				export.export(map6, 5);
			} else {
				export.export(map6, 4);
			}
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/



		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";

		ToPreviewResult toPreviewResult = tourGroupFacade.createSalesConfirm(orderId, agency, WebUtils.getCurBizId(request));
		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		List<GroupOrderPrice> prices = toPreviewResult.getPriceList();
		List<GroupRoute> routes = toPreviewResult.getRouteList();
		SupplierInfo supplier = toPreviewResult.getSupplier();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_confirm.docx");
		if (groupOrder.getOrderType() != 1) {
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/sales_skconfirm.docx");
		}
		if(agency==1){
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/agency_sales_confirm.docx");
		}
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}

		// logo图标和标题
		String imgPath = toPreviewResult.getImgPath();
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("product", groupOrder.getProductName());
		params1.put("printName", WebUtils.getCurUser(request).getName());
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

		Map<String, Object> map0 = new HashMap<String, Object>();
		// 收件方信息
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		// 发件方信息（定制团显示为销售）
		// 销售计调的组织机构信息
		PlatformEmployeePo employee = toPreviewResult.getEmployee();
		map0.put("company", toPreviewResult.getCompany()); // 当前单位
		map0.put("user_name", employee.getName());
		map0.put("user_tel", employee.getMobile());
		map0.put("user_fax", employee.getFax());

		// 统计订单下的全陪
		String guestGuideString = toPreviewResult.getGuestGuideString();
		// 订单所属团下的所有导游
		String guideString = toPreviewResult.getGuideString();
		// 根据散客订单统计客人信息

		Map<String, Object> map1 = new HashMap<String, Object>();
		if (null == groupOrder.getTourGroup()) {
			map1.put("groupCode", "");
		} else {
			map1.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		}
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("departureDate", groupOrder.getDepartureDate());
		map1.put("receiveMode", groupOrder.getReceiveMode());
		map1.put(
				"place",
				(groupOrder.getProvinceName() == null ? "" : groupOrder
						.getProvinceName())
						+ (groupOrder.getCityName() == null ? "" : groupOrder
								.getCityName()));
		map1.put("guideString", guideString);
		map1.put("guestGuideString", guestGuideString);
		map1.put("productName",
				"【"
						+ (groupOrder.getProductBrandName() == null ? ""
								: groupOrder.getProductBrandName())
						+ "】"
						+ (groupOrder.getProductName() == null ? ""
								: groupOrder.getProductName()));


		// 行程列表表格
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		for (GroupRoute groupRoute : routes) {
			Map<String, String> map = new HashMap<String, String>();
			if (null != groupRoute.getGroupDate()) {
				map.put("day_num", DateUtils.format(groupRoute.getGroupDate()));
			} else {
				map.put("day_num", "");
			}
			map.put("route_desp", groupRoute.getRouteDesp());
			map.put("breakfast", groupRoute.getBreakfast());
			map.put("lunch", groupRoute.getLunch());
			map.put("supper", groupRoute.getSupper());
			map.put("hotel_name", groupRoute.getHotelName());
			routeList.add(map);
		}

		// 收入表格

		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+NumberUtil.formatDouble(totalNum)+",已收:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}


		// 客人信息

		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();

		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("mobile", (guests.get(x).getMobile() == null ? "" : guests
					.get(x).getMobile()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			map.put("age", (guests.get(x).getAge() == null ? "" : guests.get(x)
					.getAge()) + "");
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			map.put("place", (guests.get(x).getNativePlace() == null ? ""
					: guests.get(x).getNativePlace()));
			guestList.add(map);
		}
		Map<String, Object> map6 = new HashMap<String, Object>();
		// 根据散客订单统计酒店信息
		List<GroupRequirement> grogShopList = toPreviewResult.getGrogShopList();
		// 根据散客订单统计接机信息
		List<GroupOrderTransport> groupOrderTransports = toPreviewResult.getGroupOrderTransports();
		if (null != grogShopList && grogShopList.size() > 0) {
			map6.put("hotelNum", getHotelNum(grogShopList));
		} else {
			map6.put("hotelNum", "");
		}
		if(agency!=1){
			if (null != groupOrderTransports && groupOrderTransports.size() > 0) {
				map6.put("upAndOff", "接机：" + getAirInfo(groupOrderTransports, 0)
						+ "\n" + "送机：" + getAirInfo(groupOrderTransports, 1) + "\n"
						+ "省内交通：" + getSourceType(groupOrderTransports));
			} else {
				map6.put("upAndOff", "");
			}
		}
		map6.put("Remark", groupOrder.getRemark());
		map6.put("Service", groupOrder.getServiceStandard());
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			export.export(routeList, 2);
			if(agency!=1){
				export.export(priceList, 3, true);
			}else{
				export.export(priceList, 3);
			}

			if (groupOrder.getOrderType() != 1 && agency!=1) {
				export.export(guestList, 4);
				export.export(map6, 5);
			} else {
				export.export(map6, 4);
			}
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 销售价格单-无行程
	 * 
	 * @param request
	 * @param orderId
	 * @return
	 */
	public String createSalesChargeNoRoute(HttpServletRequest request,
			Integer orderId) {
		/*String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		List<GroupOrderPrice> prices = groupOrderPriceService
				.selectByOrder(orderId);
		GroupOrderPrice gop = new GroupOrderPrice();
		gop.setItemName(com.yihg.sales.constants.Constants.PRICETYPE);
		gop.setUnitPrice(com.yihg.sales.constants.Constants.PRICE);
		gop.setNumTimes(com.yihg.sales.constants.Constants.TIMES);
		gop.setNumPerson(new Double(groupOrderService.selectTotalNumByOrderId(orderId)))  ;
		gop.setTotalPrice(gop.getUnitPrice()*gop.getNumPerson());
		prices.add(gop) ;
		List<GroupRoute> routes = groupRouteService.selectByOrderId(orderId);
		PlatformEmployeePo employeePo = WebUtils.getCurUser(request);
		SupplierInfo supplier = supplierService.selectBySupplierId(groupOrder
				.getSupplierId());
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_charge_noRoute.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("product", groupOrder.getProductName());
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

		*//**
		 * 第一个表格
		 *//*
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		map0.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		map0.put("user_name", employeePo.getName());
		map0.put("user_tel", employeePo.getMobile());
		map0.put("user_fax", employeePo.getFax());
		*//**
		 * 第二个表格
		 *//*
		Map<String, Object> map1 = new HashMap<String, Object>();
		if (null == groupOrder.getTourGroup()) {
			map1.put("group_code", "待定");
		} else {
			map1.put("group_code", groupOrder.getTourGroup().getGroupCode());
		}
		map1.put("supplier_code", groupOrder.getSupplierCode());
		map1.put("departure_date", groupOrder.getDepartureDate());
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("guest_guide", toGetGuideString(guests)); // 姓名和电话
		map1.put("guest_leader", toGetLeaderString(guests)); // 姓名和电话
		*//**
		 * 第三个表格
		 *//*
		*//**
		 * 行程列表表格
		 *//*
		*//*
		 * List<Map<String, String>> routeList = new ArrayList<Map<String,
		 * String>>(); for (GroupRoute groupRoute : routes) { Map<String,
		 * String> map = new HashMap<String, String>(); if
		 * (groupRoute.getGroupDate() != null) { map.put("day_num",
		 * DateUtils.format(groupRoute.getGroupDate())); } else {
		 * map.put("day_num", ""); } map.put("route_desp",
		 * groupRoute.getRouteDesp()); map.put("breakfast",
		 * groupRoute.getBreakfast()); map.put("lunch", groupRoute.getLunch());
		 * map.put("supper", groupRoute.getSupper()); map.put("hotel_name",
		 * groupRoute.getHotelName()); routeList.add(map); }
		 *//*
		*//**
		 * 第四个表格
		 *//*
		*//**
		 * 成本表格
		 *//*
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+NumberUtil.formatDouble(totalNum)+",已付:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}

		*//**
		 * 第四个表格
		 *//*
		List<SysBizBankAccount> sysBizBankAccountList = bizBankAccountService
				.getListByBizId(WebUtils.getCurBizId(request));
		List<Map<String, String>> sbba = new ArrayList<Map<String, String>>();
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("account_type",
					sysBizBankAccount.getAccountType() == 1 ? "个人账户" : "对公账户");
			map.put("account_name", sysBizBankAccount.getAccountName());
			map.put("bank_account", sysBizBankAccount.getBankAccount());
			map.put("account_no", sysBizBankAccount.getAccountNo());
			sbba.add(map);
		}
		*//**
		 * 第五个表格
		 *//*
		Map<String, Object> map5 = new HashMap<String, Object>();
		if (null != groupOrder.getTourGroup()) {
			map5.put("Remark", groupOrder.getRemark());
			map5.put("Service", groupOrder.getServiceStandard());
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			// export.export(routeList, 2);
			export.export(priceList, 2, true);
			export.export(sbba, 3);
			export.export(map5, 4);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/


		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		ToPreviewResult toPreviewResult = tourGroupFacade.createSalesChargeNoRoute(orderId,  WebUtils.getCurBizId(request));
		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		List<GroupOrderPrice> prices = toPreviewResult.getPriceList();
		List<GroupRoute> routes = toPreviewResult.getRouteList();
		PlatformEmployeePo employeePo = WebUtils.getCurUser(request);
		SupplierInfo supplier = toPreviewResult.getSupplier();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_charge_noRoute.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = toPreviewResult.getImgPath();
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("product", groupOrder.getProductName());
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
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		map0.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		map0.put("user_name", employeePo.getName());
		map0.put("user_tel", employeePo.getMobile());
		map0.put("user_fax", employeePo.getFax());
		/**
		 * 第二个表格
		 */
		Map<String, Object> map1 = new HashMap<String, Object>();
		if (null == groupOrder.getTourGroup()) {
			map1.put("group_code", "待定");
		} else {
			map1.put("group_code", groupOrder.getTourGroup().getGroupCode());
		}
		map1.put("supplier_code", groupOrder.getSupplierCode());
		map1.put("departure_date", groupOrder.getDepartureDate());
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("guest_guide", toGetGuideString(guests)); // 姓名和电话
		map1.put("guest_leader", toGetLeaderString(guests)); // 姓名和电话
		/**
		 * 第三个表格
		 */
		/**
		 * 行程列表表格
		 */
		/*
		 * List<Map<String, String>> routeList = new ArrayList<Map<String,
		 * String>>(); for (GroupRoute groupRoute : routes) { Map<String,
		 * String> map = new HashMap<String, String>(); if
		 * (groupRoute.getGroupDate() != null) { map.put("day_num",
		 * DateUtils.format(groupRoute.getGroupDate())); } else {
		 * map.put("day_num", ""); } map.put("route_desp",
		 * groupRoute.getRouteDesp()); map.put("breakfast",
		 * groupRoute.getBreakfast()); map.put("lunch", groupRoute.getLunch());
		 * map.put("supper", groupRoute.getSupper()); map.put("hotel_name",
		 * groupRoute.getHotelName()); routeList.add(map); }
		 */
		/**
		 * 第四个表格
		 */
		/**
		 * 成本表格
		 */
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+NumberUtil.formatDouble(totalNum)+",已付:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}

		/**
		 * 第四个表格
		 */
		List<SysBizBankAccount> sysBizBankAccountList = toPreviewResult.getSysBizBankAccountList();
		List<Map<String, String>> sbba = new ArrayList<Map<String, String>>();
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("account_type",
					sysBizBankAccount.getAccountType() == 1 ? "个人账户" : "对公账户");
			map.put("account_name", sysBizBankAccount.getAccountName());
			map.put("bank_account", sysBizBankAccount.getBankAccount());
			map.put("account_no", sysBizBankAccount.getAccountNo());
			sbba.add(map);
		}
		/**
		 * 第五个表格
		 */
		Map<String, Object> map5 = new HashMap<String, Object>();
		if (null != groupOrder.getTourGroup()) {
			map5.put("Remark", groupOrder.getRemark());
			map5.put("Service", groupOrder.getServiceStandard());
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			// export.export(routeList, 2);
			export.export(priceList, 2, true);
			export.export(sbba, 3);
			export.export(map5, 4);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 生成销售订单确认单-无行程
	 * 
	 * @param
	 * @return
	 */
	public String createSalesConfirmNoRoute(HttpServletRequest request,
			Integer orderId) {
		/*String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		List<GroupOrderPrice> prices = groupOrderPriceService
				.selectByOrder(orderId);
		GroupOrderPrice gop = new GroupOrderPrice();
		gop.setItemName(com.yihg.sales.constants.Constants.PRICETYPE);
		gop.setUnitPrice(com.yihg.sales.constants.Constants.PRICE);
		gop.setNumTimes(com.yihg.sales.constants.Constants.TIMES);
		gop.setNumPerson(new Double(groupOrderService.selectTotalNumByOrderId(orderId)))  ;
		gop.setTotalPrice(gop.getUnitPrice()*gop.getNumPerson());
		prices.add(gop) ;
		SupplierInfo supplier = supplierService.selectBySupplierId(groupOrder
				.getSupplierId());

		PlatformEmployeePo employee = sysPlatformEmployeeFacade
				.findByEmployeeId(groupOrder.getSaleOperatorId()).getPlatformEmployeePo();

		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_confirm_noRoute.docx");
		if (groupOrder.getOrderType() != 1) {
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/sales_skconfirm_noRoute.docx");
		}
		WordReporter export = new WordReporter(realPath);

		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		*//**
		 * logo图标和标题
		 *//*
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("product", groupOrder.getProductName());
		params1.put("seal", "");
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

		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		map0.put("company", orgService.findByOrgId(employee.getOrgId()).getName()); // 当前单位
		map0.put("user_name", employee.getName());
		map0.put("user_tel", employee.getMobile());
		map0.put("user_fax", employee.getFax());

		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("supplier_code", groupOrder.getSupplierCode());
		if (null == groupOrder.getTourGroup()) {
			map1.put("groupCode", "待定");
		} else {
			map1.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		}

		// 统计订单下的全陪
		String guestGuideString = "";
		// 订单所属团下的所有导游
		String guideString = "";
		// 根据散客订单统计客人信息
		List<BookingGuide> guides = null;
		if (null != groupOrder.getGroupId()) {
			guides = bookingGuideService.selectGuidesByGroupId(groupOrder
					.getGroupId());
			StringBuilder sb = new StringBuilder();
			SupplierGuide sg = null;
			for (BookingGuide guide : guides) {
				sg = guideService.getGuideInfoById(guide.getGuideId());
				sb.append(guide.getGuideName() + " " + guide.getGuideMobile()
						+ " " + sg.getLicenseNo() + "\n");
			}
			guideString = sb.toString();
		}

		if (guests.size() > 0) {
			StringBuilder sb = new StringBuilder();
			for (GroupOrderGuest guest : guests) {
				if (guest.getType() == 3) {
					sb.append(guest.getName() + " " + guest.getMobile());
				}
			}
			guestGuideString = sb.toString();
		}
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("departureDate", groupOrder.getDepartureDate());
		map1.put("receiveMode", groupOrder.getReceiveMode());
		map1.put(
				"place",
				(groupOrder.getProvinceName() == null ? "" : groupOrder
						.getProvinceName())
						+ (groupOrder.getCityName() == null ? "" : groupOrder
								.getCityName()));
		map1.put("guideString", guideString);
		map1.put("guestGuideString", guestGuideString);
		map1.put("productName",
				"【"
						+ (groupOrder.getProductBrandName() == null ? ""
								: groupOrder.getProductBrandName())
						+ "】"
						+ (groupOrder.getProductName() == null ? ""
								: groupOrder.getProductName()));

		*//**
		 * 收入表格
		 *//*
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+NumberUtil.formatDouble(totalNum)+",已收:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}
		*//**//**
		 * 客人信息
		 *//**//*
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("mobile", (guests.get(x).getMobile() == null ? "" : guests
					.get(x).getMobile()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			map.put("age", (guests.get(x).getAge() == null ? "" : guests.get(x)
					.getAge()) + "");
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			map.put("place", (guests.get(x).getNativePlace() == null ? ""
					: guests.get(x).getNativePlace()));
			guestList.add(map);
		}

		Map<String, Object> map5 = new HashMap<String, Object>();
		// 根据散客订单统计酒店信息
		List<GroupRequirement> grogShopList = groupRequirementService
				.selectByOrderAndType(groupOrder.getId(), 3);
		// 根据散客订单统计接机信息
		List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
				.selectByOrderId(groupOrder.getId());
		if (null != grogShopList && grogShopList.size() > 0) {
			map5.put("hotelNum", getHotelNum(grogShopList));
		} else {
			map5.put("hotelNum", "");
		}
		if (null != groupOrderTransports && groupOrderTransports.size() > 0) {
			map5.put("upAndOff", "接机：" + getAirInfo(groupOrderTransports, 0)
					+ "\n" + "送机：" + getAirInfo(groupOrderTransports, 1) + "\n"
					+ "省内交通：" + getSourceType(groupOrderTransports));
		} else {
			map5.put("upAndOff", "");
		}
		map5.put("Remark", groupOrder.getRemark());
		map5.put("Service", groupOrder.getServiceStandard());
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			export.export(priceList, 2, true);
			if (groupOrder.getOrderType() != 1) {
				export.export(guestList, 3);
				export.export(map5, 4);
			} else {
				export.export(map5, 3);
			}

			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/




		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		ToPreviewResult toPreviewResult = tourGroupFacade.createSalesConfirmNoRoute(orderId, WebUtils.getCurBizId(request));
		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		List<GroupOrderPrice> prices = toPreviewResult.getPriceList();
		SupplierInfo supplier = toPreviewResult.getSupplier();
		PlatformEmployeePo employee = toPreviewResult.getEmployee();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_confirm_noRoute.docx");
		if (groupOrder.getOrderType() != 1) {
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/sales_skconfirm_noRoute.docx");
		}
		WordReporter export = new WordReporter(realPath);

		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		/**
		 * logo图标和标题
		 */
		String imgPath = toPreviewResult.getImgPath();
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("product", groupOrder.getProductName());
		params1.put("seal", "");
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

		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		map0.put("company", toPreviewResult.getCompany()); // 当前单位
		map0.put("user_name", employee.getName());
		map0.put("user_tel", employee.getMobile());
		map0.put("user_fax", employee.getFax());

		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("supplier_code", groupOrder.getSupplierCode());
		if (null == groupOrder.getTourGroup()) {
			map1.put("groupCode", "待定");
		} else {
			map1.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		}

		// 统计订单下的全陪
		String guestGuideString = toPreviewResult.getGuestGuideString();
		// 订单所属团下的所有导游
		String guideString = toPreviewResult.getGuideString();
		// 根据散客订单统计客人信息

		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("departureDate", groupOrder.getDepartureDate());
		map1.put("receiveMode", groupOrder.getReceiveMode());
		map1.put(
				"place",
				(groupOrder.getProvinceName() == null ? "" : groupOrder
						.getProvinceName())
						+ (groupOrder.getCityName() == null ? "" : groupOrder
						.getCityName()));
		map1.put("guideString", guideString);
		map1.put("guestGuideString", guestGuideString);
		map1.put("productName",
				"【"
						+ (groupOrder.getProductBrandName() == null ? ""
						: groupOrder.getProductBrandName())
						+ "】"
						+ (groupOrder.getProductName() == null ? ""
						: groupOrder.getProductName()));

		/**
		 * 收入表格
		 */
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+NumberUtil.formatDouble(totalNum)+",已收:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}
		/**
		 * 客人信息
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("mobile", (guests.get(x).getMobile() == null ? "" : guests
					.get(x).getMobile()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			map.put("age", (guests.get(x).getAge() == null ? "" : guests.get(x)
					.getAge()) + "");
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			map.put("place", (guests.get(x).getNativePlace() == null ? ""
					: guests.get(x).getNativePlace()));
			guestList.add(map);
		}

		Map<String, Object> map5 = new HashMap<String, Object>();
		// 根据散客订单统计酒店信息
		List<GroupRequirement> grogShopList = toPreviewResult.getGrogShopList();
		// 根据散客订单统计接机信息
		List<GroupOrderTransport> groupOrderTransports = toPreviewResult.getGroupOrderTransports();
		if (null != grogShopList && grogShopList.size() > 0) {
			map5.put("hotelNum", getHotelNum(grogShopList));
		} else {
			map5.put("hotelNum", "");
		}
		if (null != groupOrderTransports && groupOrderTransports.size() > 0) {
			map5.put("upAndOff", "接机：" + getAirInfo(groupOrderTransports, 0)
					+ "\n" + "送机：" + getAirInfo(groupOrderTransports, 1) + "\n"
					+ "省内交通：" + getSourceType(groupOrderTransports));
		} else {
			map5.put("upAndOff", "");
		}
		map5.put("Remark", groupOrder.getRemark());
		map5.put("Service", groupOrder.getServiceStandard());
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			export.export(priceList, 2, true);
			if (groupOrder.getOrderType() != 1) {
				export.export(guestList, 3);
				export.export(map5, 4);
			} else {
				export.export(map5, 3);
			}

			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 销售价格单
	 * 
	 * @param request
	 * @param orderId
	 * @return
	 */
	public String createSalesCharge(HttpServletRequest request, Integer orderId) {
	/*	String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		List<GroupOrderPrice> prices = groupOrderPriceService
				.selectByOrder(orderId);
		GroupOrderPrice gop = new GroupOrderPrice();
		gop.setItemName(com.yihg.sales.constants.Constants.PRICETYPE);
		gop.setUnitPrice(com.yihg.sales.constants.Constants.PRICE);
		gop.setNumTimes(com.yihg.sales.constants.Constants.TIMES);
		gop.setNumPerson(new Double(groupOrderService.selectTotalNumByOrderId(orderId)))  ;
		gop.setTotalPrice(gop.getUnitPrice()*gop.getNumPerson());
		prices.add(gop) ;
		List<GroupRoute> routes = groupRouteService.selectByOrderId(orderId);
		PlatformEmployeePo employeePo = WebUtils.getCurUser(request);
		SupplierInfo supplier = supplierService.selectBySupplierId(groupOrder
				.getSupplierId());
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_charge.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("product", groupOrder.getProductName());
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

		*//**
		 * 第一个表格
		 *//*
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		map0.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		map0.put("user_name", employeePo.getName());
		map0.put("user_tel", employeePo.getMobile());
		map0.put("user_fax", employeePo.getFax());
		*//**
		 * 第二个表格
		 *//*
		Map<String, Object> map1 = new HashMap<String, Object>();
		if (null == groupOrder.getTourGroup()) {
			map1.put("group_code", "待定");
		} else {
			map1.put("group_code", groupOrder.getTourGroup().getGroupCode());
		}
		map1.put("supplier_code", groupOrder.getSupplierCode());
		map1.put("departure_date", groupOrder.getDepartureDate());
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("guest_guide", toGetGuideString(guests)); // 姓名和电话
		map1.put("guest_leader", toGetLeaderString(guests)); // 姓名和电话
		*//**
		 * 第三个表格
		 *//*
		*//**
		 * 行程列表表格
		 *//*
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		for (GroupRoute groupRoute : routes) {
			Map<String, String> map = new HashMap<String, String>();
			if (groupRoute.getGroupDate() != null) {
				map.put("day_num", DateUtils.format(groupRoute.getGroupDate()));
			} else {
				map.put("day_num", "");
			}
			map.put("route_desp", groupRoute.getRouteDesp());
			map.put("breakfast", groupRoute.getBreakfast());
			map.put("lunch", groupRoute.getLunch());
			map.put("supper", groupRoute.getSupper());
			map.put("hotel_name", groupRoute.getHotelName());
			routeList.add(map);
		}
		*//**
		 * 成本表格
		 *//*
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+ NumberUtil.formatDouble(totalNum)+",已收:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}

		*//**
		 * 第四个表格
		 *//*
		List<SysBizBankAccount> sysBizBankAccountList = bizBankAccountService
				.getListByBizId(WebUtils.getCurBizId(request));
		List<Map<String, String>> sbba = new ArrayList<Map<String, String>>();
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("account_type",
					sysBizBankAccount.getAccountType() == 1 ? "个人账户" : "对公账户");
			map.put("account_name", sysBizBankAccount.getAccountName());
			map.put("bank_account", sysBizBankAccount.getBankAccount());
			map.put("account_no", sysBizBankAccount.getAccountNo());
			sbba.add(map);
		}
		*//**
		 * 第五个表格
		 *//*
		Map<String, Object> map5 = new HashMap<String, Object>();
		if (null != groupOrder.getTourGroup()) {
			map5.put("Remark", groupOrder.getRemark());
			map5.put("Service", groupOrder.getServiceStandard());
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			export.export(routeList, 2);
			export.export(priceList, 3, true);
			export.export(sbba, 4);
			export.export(map5, 5);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/


		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		ToPreviewResult toPreviewResult = tourGroupFacade.createSalesCharge(orderId, WebUtils.getCurBizId(request));

		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		List<GroupOrderPrice> prices = toPreviewResult.getPriceList();
		List<GroupRoute> routes = toPreviewResult.getRouteList();
		PlatformEmployeePo employeePo = WebUtils.getCurUser(request);
		SupplierInfo supplier = toPreviewResult.getSupplier();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/sales_charge.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = toPreviewResult.getImgPath();
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("print_time", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("product", groupOrder.getProductName());
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
		map0.put("supplier_name", supplier.getNameShort());
		map0.put("contact", groupOrder.getContactName());
		map0.put("contact_tel", groupOrder.getContactTel());
		map0.put("contact_fax", groupOrder.getContactFax());
		map0.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		map0.put("user_name", employeePo.getName());
		map0.put("user_tel", employeePo.getMobile());
		map0.put("user_fax", employeePo.getFax());
		/**
		 * 第二个表格
		 */
		Map<String, Object> map1 = new HashMap<String, Object>();
		if (null == groupOrder.getTourGroup()) {
			map1.put("group_code", "待定");
		} else {
			map1.put("group_code", groupOrder.getTourGroup().getGroupCode());
		}
		map1.put("supplier_code", groupOrder.getSupplierCode());
		map1.put("departure_date", groupOrder.getDepartureDate());
		map1.put("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		map1.put("guest_guide", toGetGuideString(guests)); // 姓名和电话
		map1.put("guest_leader", toGetLeaderString(guests)); // 姓名和电话
		/**
		 * 第三个表格
		 */
		/**
		 * 行程列表表格
		 */
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		for (GroupRoute groupRoute : routes) {
			Map<String, String> map = new HashMap<String, String>();
			if (groupRoute.getGroupDate() != null) {
				map.put("day_num", DateUtils.format(groupRoute.getGroupDate()));
			} else {
				map.put("day_num", "");
			}
			map.put("route_desp", groupRoute.getRouteDesp());
			map.put("breakfast", groupRoute.getBreakfast());
			map.put("lunch", groupRoute.getLunch());
			map.put("supper", groupRoute.getSupper());
			map.put("hotel_name", groupRoute.getHotelName());
			routeList.add(map);
		}
		/**
		 * 成本表格
		 */
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		if (null != prices && prices.size() > 0) {
			for (GroupOrderPrice price : prices) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("seq", "" + i++);
				map.put("item_name", price.getItemName());
				map.put("remark", price.getRemark());
				map.put("unit_price",
						NumberUtil.formatDouble(price.getUnitPrice()));
				map.put("num_times",
						NumberUtil.formatDouble(price.getNumTimes()));
				map.put("num_person",
						NumberUtil.formatDouble(price.getNumPerson()));
				map.put("total_price",
						NumberUtil.formatDouble(price.getTotalPrice()));
				totalNum += new Double(NumberUtil.formatDouble(price
						.getUnitPrice()
						* price.getNumTimes()
						* price.getNumPerson()));
				priceList.add(map);
			}
			Map<String, String> priceTotalMap = new HashMap<String, String>() ;
			priceTotalMap.put("total","应收:"+ NumberUtil.formatDouble(totalNum)+",已收:"+
					NumberUtil.formatDouble(prices.get(prices.size()-1).getTotalPrice())+
					",余额:" +(NumberUtil.formatDouble(totalNum-prices.get(prices.size()-1).getTotalPrice()))) ;
			priceList.add(priceTotalMap) ;
		}else {
			Map<String, String> priceTotalMap = new HashMap<String, String>();
			priceTotalMap.put("total", " ");
			priceList.add(priceTotalMap);
		}

		/**
		 * 第四个表格
		 */
		List<SysBizBankAccount> sysBizBankAccountList = toPreviewResult.getSysBizBankAccountList();
		List<Map<String, String>> sbba = new ArrayList<Map<String, String>>();
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("account_type",
					sysBizBankAccount.getAccountType() == 1 ? "个人账户" : "对公账户");
			map.put("account_name", sysBizBankAccount.getAccountName());
			map.put("bank_account", sysBizBankAccount.getBankAccount());
			map.put("account_no", sysBizBankAccount.getAccountNo());
			sbba.add(map);
		}
		/**
		 * 第五个表格
		 */
		Map<String, Object> map5 = new HashMap<String, Object>();
		if (null != groupOrder.getTourGroup()) {
			map5.put("Remark", groupOrder.getRemark());
			map5.put("Service", groupOrder.getServiceStandard());
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			export.export(routeList, 2);
			export.export(priceList, 3, true);
			export.export(sbba, 4);
			export.export(map5, 5);
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
	public String createGuestNames(HttpServletRequest request, Integer orderId) {
		/*String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/guest_names.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", groupOrder.getTourGroup().getGroupCode());
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
		*//**
		 * 客人名单
		 *//*
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (GroupOrderGuest guest : guests) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("name", guest.getName());
			map.put("certificateNum", guest.getCertificateNum());
			guestList.add(map);
		}

		try {
			export.export(params1);
			export.export(guestList, 0);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/



		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		ToPreviewResult toPreviewResult = tourGroupFacade.createGuestNames(orderId, WebUtils.getCurBizId(request));
		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/guest_names.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = toPreviewResult.getImgPath();
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
		params1.put("groupCode", groupOrder.getTourGroup().getGroupCode());
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
		for (GroupOrderGuest guest : guests) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("name", guest.getName());
			map.put("certificateNum", guest.getCertificateNum());
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
	 * 打印境内旅游合同
	 * 
	 * @param request
	 * @param orderId
	 * @return
	 */
	public String saleTravelContract(HttpServletRequest request, Integer orderId) {
	/*	String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		GroupRoute groupRoute=groupRouteService.selectDayNumAndMaxday(orderId);
		GroupOrderGuest genderSum=groupOrderGuestService.selectGenderSum(orderId);
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/travel_contract.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		map0.put("person",(groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide())+ "");
		map0.put("child", groupOrder.getNumChild()+ "");
		map0.put("man", genderSum.getMan()+"");
		map0.put("woman", genderSum.getWoman()+"");
		map0.put("total", NumberUtil.formatDouble(groupOrder.getTotal())+"");
		map0.put("totals", NumberToCN.number2CNMontrayUnit(groupOrder.getTotal()));
		
		*//**
		 * 参团名单
		 *//*
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("mobile", (guests.get(x).getMobile() == null ? "" : guests
					.get(x).getMobile()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			map.put("age", (guests.get(x).getAge() == null ? "" : guests.get(x)
					.getAge()) + "");
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			guestList.add(map);
		}
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("groupCode1", groupOrder.getTourGroup().getGroupCode());
		map1.put("person1",(groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide())+ "");
		map1.put("child1", groupOrder.getNumChild()+ "");
		map1.put("departureDate", groupOrder.getDepartureDate());
		map1.put("man1", genderSum.getMan()+"");
		map1.put("woman1", genderSum.getWoman()+"");
		map1.put("maxDay",groupRoute.getMaxDay() );
		map1.put("numDay",groupRoute.getNumDay()+"");
		map1.put("numNig",(groupRoute.getNumDay()-1)+"");
		map1.put("total1", NumberUtil.formatDouble(groupOrder.getTotal())+"");
		map1.put("totals1", NumberToCN.number2CNMontrayUnit(groupOrder.getTotal()));
		try {
			export.export(map0);
			export.export(guestList, 1);
			export.export(map1,2);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/



		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		ToPreviewResult toPreviewResult = tourGroupFacade.saleTravelContract(orderId, WebUtils.getCurBizId(request));
		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		GroupRoute groupRoute=toPreviewResult.getGroupRoute();
		GroupOrderGuest genderSum=toPreviewResult.getGroupOrderGuest();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/travel_contract.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		map0.put("person",(groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide())+ "");
		map0.put("child", groupOrder.getNumChild()+ "");
		map0.put("man", genderSum.getMan()+"");
		map0.put("woman", genderSum.getWoman()+"");
		map0.put("total", NumberUtil.formatDouble(groupOrder.getTotal())+"");
		map0.put("totals", NumberToCN.number2CNMontrayUnit(groupOrder.getTotal()));

		/**
		 * 参团名单
		 */
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("mobile", (guests.get(x).getMobile() == null ? "" : guests
					.get(x).getMobile()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			map.put("age", (guests.get(x).getAge() == null ? "" : guests.get(x)
					.getAge()) + "");
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			guestList.add(map);
		}

		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("groupCode1", groupOrder.getTourGroup().getGroupCode());
		map1.put("person1",(groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide())+ "");
		map1.put("child1", groupOrder.getNumChild()+ "");
		map1.put("departureDate", groupOrder.getDepartureDate());
		map1.put("man1", genderSum.getMan()+"");
		map1.put("woman1", genderSum.getWoman()+"");
		map1.put("maxDay",groupRoute.getMaxDay() );
		map1.put("numDay",groupRoute.getNumDay()+"");
		map1.put("numNig",(groupRoute.getNumDay()-1)+"");
		map1.put("total1", NumberUtil.formatDouble(groupOrder.getTotal())+"");
		map1.put("totals1", NumberToCN.number2CNMontrayUnit(groupOrder.getTotal()));
		try {
			export.export(map0);
			export.export(guestList, 1);
			export.export(map1,2);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 旅游综合保障计划投保书
	 * 
	 * @param request
	 * @param orderId
	 * @return
	 */
	public String saleInsurance(HttpServletRequest request, Integer orderId) {
		/*String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		GroupRoute groupRoute=groupRouteService.selectDayNumAndMaxday(orderId);
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/insurance.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		map0.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		map0.put("person",(groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide())+ "");
		map0.put("child", groupOrder.getNumChild()+ "");
		map0.put("departureDate", groupOrder.getDepartureDate());
		map0.put("maxDay",groupRoute.getMaxDay() );
		map0.put("numDay",groupRoute.getNumDay()+"");
		map0.put("numNig",(groupRoute.getNumDay()-1)+"");
		map0.put("total", groupOrder.getTotal()+"");
		map0.put("printTime", DateUtils.format(new Date()));
		map0.put("operator",WebUtils.getCurUser(request).getName());
		map0.put("opTel",WebUtils.getCurUser(request).getMobile());
		map0.put("guide", groupOrder.getNumGuide()+ "");
		
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("number", x+1+"");
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			map.put("nativePlace", (guests.get(x).getNativePlace() == null ? "" : guests
					.get(x).getNativePlace()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			guestList.add(map);
		}
		try {
			export.export(map0,0);
			export.export(guestList, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;*/



		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		ToPreviewResult toPreviewResult = tourGroupFacade.saleInsurance(orderId, WebUtils.getCurBizId(request));
		GroupOrder groupOrder = toPreviewResult.getGroupOrder();
		List<GroupOrderGuest> guests = toPreviewResult.getGuests();
		GroupRoute groupRoute=toPreviewResult.getGroupRoute();
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/insurance.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		map0.put("groupCode", groupOrder.getTourGroup().getGroupCode());
		map0.put("person",(groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide())+ "");
		map0.put("child", groupOrder.getNumChild()+ "");
		map0.put("departureDate", groupOrder.getDepartureDate());
		map0.put("maxDay",groupRoute.getMaxDay() );
		map0.put("numDay",groupRoute.getNumDay()+"");
		map0.put("numNig",(groupRoute.getNumDay()-1)+"");
		map0.put("total", groupOrder.getTotal()+"");
		map0.put("printTime", DateUtils.format(new Date()));
		map0.put("operator",WebUtils.getCurUser(request).getName());
		map0.put("opTel",WebUtils.getCurUser(request).getMobile());
		map0.put("guide", groupOrder.getNumGuide()+ "");

		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		for (int x = 0; x < guests.size(); x++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("number", x+1+"");
			map.put("guestName", (guests.get(x).getName() == null ? "" : guests
					.get(x).getName()));
			map.put("cerNum", (guests.get(x).getCertificateNum() == null ? ""
					: guests.get(x).getCertificateNum()));
			map.put("nativePlace", (guests.get(x).getNativePlace() == null ? "" : guests
					.get(x).getNativePlace()));
			map.put("gender", guests.get(x).getGender() == 1 ? "男" : "女");
			guestList.add(map);
		}
		try {
			export.export(map0,0);
			export.export(guestList, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}
	
	/**
	 * 多个旅客信息拼成一个字符串
	 * 
	 * @param guests
	 * @return
	 */
	public String toGetGuestString(List<GroupOrderGuest> guests) {
		StringBuilder sb = new StringBuilder();
		String gender = "男";
		for (GroupOrderGuest guest : guests) {
			if (guest.getGender() == 0) {
				gender = "女";
			} else {
				gender = "男";
			}
			sb.append(guest.getName() + " " + gender + "  "
					+ guest.getCertificateNum() + "、");
		}
		return sb.toString();
	}

	/**
	 * 获取全陪人员的姓名和电话
	 * 
	 * @param guests
	 * @return
	 */
	public String toGetGuideString(List<GroupOrderGuest> guests) {
		StringBuilder sb = new StringBuilder();
		for (GroupOrderGuest guest : guests) {
			if (guest.getType() == 3) {
				sb.append(guest.getName() + " " + guest.getMobile() + "\n");
			}
		}
		return sb.toString();
	}

	/**
	 * 获取领队人员的姓名和电话
	 * 
	 * @param guests
	 * @return
	 */
	public String toGetLeaderString(List<GroupOrderGuest> guests) {
		StringBuilder sb = new StringBuilder();
		for (GroupOrderGuest guest : guests) {
			if (guest.getIsLeader() == 1) {
				sb.append(guest.getName() + " " + guest.getMobile());
			}
		}
		return sb.toString();
	}

	@RequestMapping(value = "/toProfitList.htm")
	public String toProfitList(HttpServletRequest request, Model model) {
		return "sales/profit/profitList";
	}

	/**
	 * 按订单查询预算利润(地接版)
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toProfitQueryList.htm")
	public String toProfitQueryList(HttpServletRequest request, Model model) {
		
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
//		model.addAttribute("bizId",bizId) ;
//		return "sales/profit/profitQuery";
		
		//FIXME 这里和GroupOrder公共 可以考虑抽取
		Integer bizId = WebUtils.getCurBizId(request);
		
		ToOrderLockListResult result = tourGroupFacade.toOrderLockList(bizId);

		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("orgJsonStr",result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId",bizId) ;
		
		return "sales/profit/profitQuery";
	}

	/**
	 * 预算利润查询分页(按订单)(地接版)
	 * 
	 * @param request
	 * @param model
	 * @param order
	 * @return
	 */
	@RequestMapping(value = "/toProfitQueryTable.htm")
	@RequiresPermissions(PermissionConstants.SALE_TEAM_PROFIT)
	public String toProfitQueryTable(HttpServletRequest request, Model model,
			GroupOrder order) {
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
//		pageBean = groupOrderService.selectProfitByConListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		GroupOrder staticInfo = groupOrderService.selectProfitByCon(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		GroupOrder groupOrder = groupOrderService.selectProfitByConAndMode(
//				pageBean, WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		model.addAttribute("groupOrder", groupOrder);
//		model.addAttribute("staticInfo", staticInfo);
//		model.addAttribute("page", pageBean);
//		model.addAttribute("groupList", pageBean.getResult());
//		return "sales/profit/profitQueryTable";
		
		//FIXME 这个共用了一次
		ToOrderLockTableDTO orderLockTableDTO=new ToOrderLockTableDTO();
		orderLockTableDTO.setBizId(WebUtils.getCurBizId(request));
		orderLockTableDTO.setOrder(order);
		orderLockTableDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		
		ToProfitQueryTableResult result = tourGroupFacade.toProfitQueryTable(orderLockTableDTO);
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("staticInfo", result.getStaticInfo());
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("groupList", result.getPageBean().getResult());
	
		return "sales/profit/profitQueryTable";
	}
	
	/**
	 * 预算利润查询分页(按订单)(组团版)
	 * 
	 * @param request
	 * @param model
	 * @param order
	 * @return
	 */
	@RequestMapping(value = "/toProfitQueryTableZT.htm")
	@RequiresPermissions(PermissionConstants.ZT_LRCX)
	public String toProfitQueryTableZT(HttpServletRequest request, Model model,
			GroupOrder order) {
		/*PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		pageBean.setPage(order.getPage());
		pageBean.setPageSize(order.getPageSize() == null ? Constants.PAGESIZE
				: order.getPageSize());
		pageBean.setParameter(order);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(order.getSaleOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean = groupOrderService.selectProfitByConListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		GroupOrder staticInfo = groupOrderService.selectProfitByCon(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		GroupOrder groupOrder = groupOrderService.selectProfitByConAndMode(
				pageBean, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("staticInfo", staticInfo);
		model.addAttribute("page", pageBean);
		model.addAttribute("groupList", pageBean.getResult());
		return "sales/profit/profitQueryTable";*/

		ToPreviewResult toPreviewResult = tourGroupFacade.toProfitQueryTableZT( order,WebUtils.getDataUserIdSet(request) ,"", WebUtils.getCurBizId(request));
		model.addAttribute("groupOrder", toPreviewResult.getGroupOrder());
		model.addAttribute("staticInfo", toPreviewResult.getStaticInfo());
		model.addAttribute("page", toPreviewResult.getPageBean());
		model.addAttribute("groupList", toPreviewResult.getPageBean().getResult());
		return "sales/profit/profitQueryTable";
	}
	
	/**
	 * 按团查询预算利润
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toProfitQueryListByTour.htm")
	public String toProfitQueryListByTour(HttpServletRequest request,
			Model model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(bizId));
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO=new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr",result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "sales/profit/profitQueryByTour";
	}

	/**
	 * 按团查询预算利润
	 * 
	 * @param request
	 * @param model
	 * @param tour
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value = "/toProfitQueryTableByTour.htm")
	public String toProfitQueryTableByTour(HttpServletRequest request,
			Model model, TourGroup tour, Integer page, Integer pageSize) {
//		PageBean<TourGroup> pageBean = new PageBean<TourGroup>();
//		pageBean.setPage(page);
//		if (pageSize == null) {
//			pageSize = Constants.PAGESIZE;
//		}
//		pageBean.setPageSize(pageSize);
//		pageBean.setParameter(tour);
//		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(tour.getSaleOperatorIds())
//				&& StringUtils.isNotBlank(tour.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tour.getOrgIds().split(",");
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
//				tour.setSaleOperatorIds(salesOperatorIds.substring(0,
//						salesOperatorIds.length() - 1));
//			}
//		}
//		pageBean = tourGroupService.selectProfitByTourConListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		// 统计成人、小孩、全陪
//		PageBean<TourGroup> pb = tourGroupService.selectProfitByTourCon(
//				pageBean, WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//
//		// 总成本、总收入
//		TourGroup group = tourGroupService.selectProfitByTourConAndMode(
//				pageBean, WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		if (group == null) {
//			group = new TourGroup();
//			group.setIncome(new BigDecimal(0));
//			group.setTotalBudget(new BigDecimal(0));
//		}
//		model.addAttribute("page", pageBean);
//		model.addAttribute("groupList", pageBean.getResult());
//		model.addAttribute("pb", pb.getResult());
//		model.addAttribute("totalBudget", group.getTotalBudget());
//		model.addAttribute("totalIncome", group.getIncome());
				
		ProfitQueryByTourDTO profitQueryByTourDTO=new ProfitQueryByTourDTO();
		profitQueryByTourDTO.setBizId(WebUtils.getCurBizId(request));
		profitQueryByTourDTO.setTour(tour);
		profitQueryByTourDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		profitQueryByTourDTO.setPage(page);
		profitQueryByTourDTO.setPageSize(pageSize);
		
		ProfitQueryByTourResult profitQueryByTourResult=tourGroupFacade.toProfitQueryTableByTour(profitQueryByTourDTO);
		
		model.addAttribute("page", profitQueryByTourResult.getPageBean());
		model.addAttribute("groupList", profitQueryByTourResult.getPageBean().getResult());
		model.addAttribute("pb",profitQueryByTourResult.getPb().getResult());
		model.addAttribute("totalBudget", profitQueryByTourResult.getGroup().getTotalBudget());
		model.addAttribute("totalIncome", profitQueryByTourResult.getGroup().getIncome());
		
		return "sales/profit/profitQueryTableByTour";
	}

	/**
	 * 返回客人信息(不包含电话号码)
	 * 
	 * @param guests
	 * @return
	 */
	public String getGuestInfoNoPhone(List<GroupOrderGuest> guests) {
		StringBuilder sb = new StringBuilder();
		for (GroupOrderGuest guest : guests) {
			sb.append(guest.getName() + " " + guest.getCertificateNum() + "\n");
		}
		return sb.toString();
	}

	/**
	 * 返回酒店信息（不包含星级）
	 * 
	 * @param grogShopList
	 * @return
	 */
	public String getHotelNum(List<GroupRequirement> grogShopList) {
		StringBuilder sb = new StringBuilder();
		if (grogShopList.size() > 0) {
			String sr = "";
			String dr = "";
			String tr = "";
			String eb = "";
			String pf = "";
			GroupRequirement gr = grogShopList.get(0);
			if (gr.getCountSingleRoom() != null && gr.getCountSingleRoom() != 0) {
				sr = gr.getCountSingleRoom() + "单间" + " ";
			}
			if (gr.getCountDoubleRoom() != null && gr.getCountDoubleRoom() != 0) {
				dr = gr.getCountDoubleRoom() + "标间" + " ";
			}
			if (gr.getCountTripleRoom() != null && gr.getCountTripleRoom() != 0) {
				tr = gr.getCountTripleRoom() + "三人间" + "";
			}
			if (gr.getExtraBed() != null && gr.getExtraBed() != 0) {
				eb = gr.getExtraBed() + "加床" + "";
			}
			if (gr.getPeiFang() != null && gr.getPeiFang() != 0) {
				pf = gr.getPeiFang() + "陪房";
			}
			sb.append(sr + dr + tr + eb + pf);
		}
		return sb.toString();
	}

	/**
	 * 接送信息
	 * 
	 * @param groupOrderTransports
	 * @param flag
	 *            0表示接信息 1表示送信息
	 * @return
	 */
	public String getAirInfo(List<GroupOrderTransport> groupOrderTransports,
			Integer flag) {
		StringBuilder sb = new StringBuilder();
		if (flag == 0) {
			for (GroupOrderTransport transport : groupOrderTransports) {
				if (transport.getType() == 0 && transport.getSourceType() == 1) {
					sb.append((transport.getDepartureCity() == null ? ""
							: transport.getDepartureCity())
							+ "/"
							+ (transport.getArrivalCity() == null ? ""
									: transport.getArrivalCity())
							+ " "
							+ (transport.getClassNo() == null ? "" : transport
									.getClassNo())
							+ " "
							+ " 发出时间："
							+ (DateUtils.format(transport.getDepartureDate(),
									"MM-dd") == null ? "" : DateUtils.format(
									transport.getDepartureDate(), "MM-dd"))
							+ " "
							+ (transport.getDepartureTime() == null ? ""
									: transport.getDepartureTime()) + "\n");
				}
			}
		}
		if (flag == 1) {
			for (GroupOrderTransport transport : groupOrderTransports) {
				if (transport.getType() == 1 && transport.getSourceType() == 1) {
					sb.append((transport.getDepartureCity() == null ? ""
							: transport.getDepartureCity())
							+ "/"
							+ (transport.getArrivalCity() == null ? ""
									: transport.getArrivalCity())
							+ " "
							+ (transport.getClassNo() == null ? "" : transport
									.getClassNo())
							+ " "
							+ " 发出时间："
							+ (DateUtils.format(transport.getDepartureDate(),
									"MM-dd") == null ? "" : DateUtils.format(
									transport.getDepartureDate(), "MM-dd"))
							+ " "
							+ (transport.getDepartureTime() == null ? ""
									: transport.getDepartureTime()) + "\n");
				}
			}
		}
		return sb.toString();
	}

	/**
	 * 省内交通
	 * 
	 * @param groupOrderTransports
	 * @param
	 *
	 * @return
	 */
	public String getSourceType(List<GroupOrderTransport> groupOrderTransports) {
		StringBuilder sb = new StringBuilder();
		for (GroupOrderTransport transport : groupOrderTransports) {
			if (transport.getSourceType() == 0) {
				sb.append((transport.getDepartureCity() == null ? ""
						: transport.getDepartureCity())
						+ "/"
						+ (transport.getArrivalCity() == null ? "" : transport
								.getArrivalCity())
						+ " "
						+ (transport.getClassNo() == null ? "" : transport
								.getClassNo())
						+ " "
						+ " 发出时间："
						+ (DateUtils.format(transport.getDepartureDate(),
								"MM-dd") == null ? "" : DateUtils.format(
								transport.getDepartureDate(), "MM-dd"))
						+ " "
						+ (transport.getDepartureTime() == null ? ""
								: transport.getDepartureTime()) + "\n");
			}
		}
		return sb.toString();
	}

	public String getMD(String date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		SimpleDateFormat sd = new SimpleDateFormat("MM-dd HH:mm");
		SimpleDateFormat s = new SimpleDateFormat("MM-dd");
		Date dd = null;
		try {
			dd = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
			try {
				dd = sd.parse(date);
			} catch (ParseException e1) {
				e1.printStackTrace();
				return date;
			}
		}
		return s.format(dd);
	}

	public String getHM(String date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		SimpleDateFormat sd = new SimpleDateFormat("MM-dd HH:mm");
		SimpleDateFormat s = new SimpleDateFormat("HH:mm");
		Date dd = null;
		try {
			dd = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
			try {
				dd = sd.parse(date);
			} catch (ParseException e1) {
				e1.printStackTrace();
				return date;
			}
		}
		return s.format(dd);
	}

	@RequestMapping(value = "/getSupplier", method = RequestMethod.POST)
	@ResponseBody
	public String getSupplier(HttpServletRequest request,
			HttpServletResponse response, String prefixText, String supplierType) {
	/*	List<SupplierInfo> supplierInfos = supplierService
				.findSupplierListByTypeAndName(supplierType, prefixText,
						WebUtils.getCurBizId(request));
		List<AutocompleteInfo> infoList = new ArrayList<AutocompleteInfo>();
		AutocompleteInfo info = null;
		for (SupplierInfo supplier : supplierInfos) {
			if(supplier.getState()==1){
			info = new AutocompleteInfo();
			info.setId(supplier.getId() + "");
			info.setText(supplier.getNameFull());
			infoList.add(info);
			}
		}
		return JSON.toJSONString(infoList);*/

		ToPreviewResult toPreviewResult = tourGroupFacade.getSupplier(prefixText, supplierType, WebUtils.getCurBizId(request));
		List<SupplierInfo> supplierInfos = toPreviewResult.getSupplierInfos();
		List<AutocompleteInfo> infoList = new ArrayList<AutocompleteInfo>();
		AutocompleteInfo info = null;
		for (SupplierInfo supplier : supplierInfos) {
			if(supplier.getState()==1){
				info = new AutocompleteInfo();
				info.setId(supplier.getId() + "");
				info.setText(supplier.getNameFull());
				infoList.add(info);
			}
		}
		return JSON.toJSONString(infoList);
	}

	@RequestMapping(value = "/getPriceSupplierName", method = RequestMethod.POST)
	@ResponseBody
	public String getSupplierName(HttpServletRequest request,
			HttpServletResponse response, String keyword, Integer productId) {

		/*ProductSupplierCondition psc = new ProductSupplierCondition();
		psc.setPageSize(10);
		psc.setSupplierName(keyword);
		psc.setProductId(productId);
		List<ProductGroupSupplier> supplierList = productGroupSupplierService
				.selectSupplierList(psc);
		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", supplierList);
		json.put("success", "true");
		return JSON.toJSONString(json);*/


		ProductSupplierCondition psc = new ProductSupplierCondition();
		psc.setPageSize(10);
		psc.setSupplierName(keyword);
		psc.setProductId(productId);
		ToPreviewResult toPreviewResult = tourGroupFacade.getPriceSupplierName(keyword, productId, 0);
		List<ProductGroupSupplier> supplierList = toPreviewResult.getSupplierList();
		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", supplierList);
		json.put("success", "true");
		return JSON.toJSONString(json);
	}

	@RequestMapping(value = "/getPriceSupplierNameForAgency", method = RequestMethod.POST)
	@ResponseBody
	public String getSupplierNameForAgency(HttpServletRequest request,
			HttpServletResponse response, String keyword, Integer groupId,
			Integer priceId, String supplierType) throws IllegalAccessException, InvocationTargetException {
	/*	List<ProductGroupSupplierVo> groupSuppliersList = null;
		ProductGroup group = productGroupService.getGroupInfoById(groupId);
		HashMap<String, Object> json = new HashMap<String, Object>();
		if (group.getGroupSetting() == 0) {
			groupSuppliersList = productGroupSupplierService.selectProductGroupSupplierVos(groupId, priceId);
			json.put("result", groupSuppliersList);
			json.put("type", 0);
		}else{
			List<SupplierInfo> supplierInfos = supplierService
					.findSupplierListByTypeAndName(supplierType, keyword,
							WebUtils.getCurBizId(request));
			json.put("result", supplierInfos);
			json.put("type", 1);
		}
		json.put("success", "true");
		return JSON.toJSONString(json);*/

		ToPreviewResult toPreviewResult = tourGroupFacade.getSupplierNameForAgency( keyword,  groupId,  priceId,  supplierType,  WebUtils.getCurBizId(request));
		toPreviewResult.getJson().put("success", "true");
		return JSON.toJSONString(toPreviewResult.getJson());
	}

	@RequestMapping(value = "/getSupplierName", method = RequestMethod.POST)
	@ResponseBody
	public String getSupplierName(HttpServletRequest request,
			HttpServletResponse response, String keyword, String supplierType) {
		/*List<SupplierInfo> supplierInfos = supplierService
				.findSupplierListByTypeAndName(supplierType, keyword,
						WebUtils.getCurBizId(request));

		if(supplierInfos!=null){
			Iterator<SupplierInfo> iterator = supplierInfos.iterator();
			while(iterator.hasNext()){
				SupplierInfo next = iterator.next();
				if(next.getState()!=1){
					iterator.remove();
				}
			}
		}
		
		
		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", supplierInfos);
		json.put("success", "true");
		return JSON.toJSONString(json);*/


		ToPreviewResult toPreviewResult = tourGroupFacade.getSupplierName( keyword,  supplierType,  WebUtils.getCurBizId(request));
		List<SupplierInfo> supplierInfos = toPreviewResult.getSupplierInfos();
		if(supplierInfos!=null){
			Iterator<SupplierInfo> iterator = supplierInfos.iterator();
			while(iterator.hasNext()){
				SupplierInfo next = iterator.next();
				if(next.getState()!=1){
					iterator.remove();
				}
			}
		}


		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", supplierInfos);
		json.put("success", "true");
		return JSON.toJSONString(json);
	}

	@RequestMapping(value = "/getSupplierAndContact", method = RequestMethod.POST)
	@ResponseBody
	public String getSupplierAndContact(HttpServletRequest request,
			HttpServletResponse response, String prefixText, Integer supplierId) {
		/*List<SupplierContactMan> list = supplierService
				.selectPrivateManBySupplierIdAndName(
						WebUtils.getCurBizId(request), supplierId, prefixText);
		List<AutocompleteInfo> infoList = new ArrayList<AutocompleteInfo>();
		AutocompleteInfo info = null;
		for (SupplierContactMan contact : list) {
			info = new AutocompleteInfo();
			info.setId(contact.getMobile());
			info.setText(contact.getName());
			info.setTag(contact.getTel() + "@" + contact.getFax());
			infoList.add(info);
		}
		return JSON.toJSONString(infoList);
*/
		ToPreviewResult toPreviewResult = tourGroupFacade.getSupplierAndContact( prefixText,  supplierId,   WebUtils.getCurBizId(request));
		List<SupplierContactMan> list = toPreviewResult.getSupplierContactManList();
		List<AutocompleteInfo> infoList = new ArrayList<AutocompleteInfo>();
		AutocompleteInfo info = null;
		for (SupplierContactMan contact : list) {
			info = new AutocompleteInfo();
			info.setId(contact.getMobile());
			info.setText(contact.getName());
			info.setTag(contact.getTel() + "@" + contact.getFax());
			infoList.add(info);
		}
		return JSON.toJSONString(infoList);
	}

	@RequestMapping(value = "/getContactName", method = RequestMethod.POST)
	@ResponseBody
	public String getContactName(HttpServletRequest request,
			HttpServletResponse response, String keyword, Integer supplierId) {
	/*	List<SupplierContactMan> list = supplierService
				.selectPrivateManBySupplierIdAndName(
						WebUtils.getCurBizId(request), supplierId, keyword);
		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", list);
		json.put("success", "true");
		return JSON.toJSONString(json);*/

		ToPreviewResult toPreviewResult = tourGroupFacade.getContactName( keyword,  supplierId,   WebUtils.getCurBizId(request));
		List<SupplierContactMan> list = toPreviewResult.getSupplierContactManList();
		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", list);
		json.put("success", "true");
		return JSON.toJSONString(json);
	}

	@RequestMapping(value = "/validatorSupplier", method = RequestMethod.POST)
	@ResponseBody
	public String validatorSupplier(HttpServletRequest request,
			String supplierName, Integer supplierId) {
		// if (supplierName == null) {
		// return errorJson("请选择供应商！");
	/*	if (StringUtils.isBlank(supplierName)) {
			return errorJson("商家不能不空，请选择！");
		}
		if (supplierId == null) {
			// return errorJson("该供应商不存在！");
			return errorJson(supplierName + "不存在，请选择！");
		}
		SupplierInfo supplier = supplierService.selectBySupplierId(supplierId);
		if (!supplier.getNameFull().equals(supplierName)) {
			// return errorJson("该供应商不存在！");
			// } else {
			return errorJson(supplierName + "不存在，请重新选择！");
		} else if (supplier.getState().intValue() != 1) {
			return errorJson(supplierName + "不可用，请重新选择！");
		} else {
			return successJson();
		}


		if (StringUtils.isBlank(supplierName)) {
			return errorJson("商家不能不空，请选择！");
		}
		if (supplierId == null) {
			// return errorJson("该供应商不存在！");
			return errorJson(supplierName + "不存在，请选择！");
		}*/

		ToPreviewResult toPreviewResult = tourGroupFacade.validatorSupplier(supplierName, supplierId);
		SupplierInfo supplier = toPreviewResult.getSupplier();
		if (!supplier.getNameFull().equals(supplierName)) {
			// return errorJson("该供应商不存在！");
			// } else {
			return errorJson(supplierName + "不存在，请重新选择！");
		} else if (supplier.getState().intValue() != 1) {
			return errorJson(supplierName + "不可用，请重新选择！");
		} else {
			return successJson();
		}
	}

	@RequestMapping(value = "/getSelSupplier", method = RequestMethod.POST)
	@ResponseBody
	public String getSelSupplier(HttpServletRequest request, Integer groupId,
			Integer priceId, String prefixText, String supplierType) {
	/*	List<ProductGroupSupplierVo> groupSuppliersList = productGroupSupplierService
				.selectProductGroupSupplierVos(groupId, priceId);
		List<AutocompleteInfo> infoList = new ArrayList<AutocompleteInfo>();
		AutocompleteInfo info = null;
		for (ProductGroupSupplierVo vo : groupSuppliersList) {
			info = new AutocompleteInfo();
			info.setId(vo.getGroupId() + "");
			info.setText(vo.getSupplierName());
			infoList.add(info);
		}
		return JSON.toJSONString(infoList);*/
		ToPreviewResult toPreviewResult = tourGroupFacade.getSelSupplier( groupId,  priceId,  prefixText,  supplierType);
		return JSON.toJSONString(toPreviewResult.getInfoList());
	}

	/**
	 * 打印预览部分
	 */
	@RequestMapping(value = "/toPreview.htm")
	public String toPreview(HttpServletRequest request, Model model,
			Integer orderId, Integer num,Integer agency) {
		/*if(null==agency){
			agency = 0 ;
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		SupplierInfo supplier = supplierService.selectBySupplierId(groupOrder
				.getSupplierId());

		PlatformEmployeePo employee = sysPlatformEmployeeFacade
				.findByEmployeeId(groupOrder.getSaleOperatorId()).getPlatformEmployeePo();

		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		List<GroupOrderPrice> priceList = groupOrderPriceService
				.selectByOrder(orderId);
		if(agency!=1){
			GroupOrderPrice gop = new GroupOrderPrice();
			gop.setItemName(com.yihg.sales.constants.Constants.PRICETYPE);
			gop.setUnitPrice(com.yihg.sales.constants.Constants.PRICE);
			gop.setNumTimes(com.yihg.sales.constants.Constants.TIMES);
			gop.setNumPerson(new Double(groupOrderService.selectTotalNumByOrderId(orderId)))  ;
			gop.setTotalPrice(gop.getUnitPrice()*gop.getNumPerson());
			priceList.add(gop) ;
		}
		
		List<GroupRoute> routeList = groupRouteService.selectByOrderId(orderId);
		
		// 客人接送信息
		GroupOrderPrintPo gopp = new GroupOrderPrintPo();
		gopp.setSupplierName(groupOrder.getSupplierName());
		gopp.setSaleOperatorName(groupOrder.getSaleOperatorName());
		gopp.setRemark(groupOrder.getRemark());
		gopp.setPlace((groupOrder.getProvinceName() == null ? "" : groupOrder
				.getProvinceName())
				+ (groupOrder.getCityName() == null ? "" : groupOrder
						.getCityName()));
		// 根据散客订单统计人数
		Integer numAdult = groupOrderGuestService
				.selectNumAdultByOrderID(groupOrder.getId());
		Integer numChild = groupOrderGuestService
				.selectNumChildByOrderID(groupOrder.getId());
		Integer numGuide = groupOrderGuestService
				.selectNumGuideByOrderID(groupOrder.getId());
		gopp.setPersonNum(numAdult + "+" + numChild + "+" + numGuide);
		// 统计订单下的全陪
		String guestGuideString = "";
		// 订单所属团下的所有导游
		String guideString = "";
		// 根据散客订单统计客人信息
		List<BookingGuide> guides = null;
		if (null != groupOrder.getGroupId()) {
			guides = bookingGuideService.selectGuidesByGroupId(groupOrder
					.getGroupId());
			StringBuilder sb = new StringBuilder();
			SupplierGuide sg = null;
			for (BookingGuide guide : guides) {
				sg = guideService.getGuideInfoById(guide.getGuideId());
				sb.append(guide.getGuideName() + " " + guide.getGuideMobile()
						+ " " + sg.getLicenseNo() + "\n");
			}
			guideString = sb.toString();
		}

		if (guests.size() > 0) {
			StringBuilder sb = new StringBuilder();
			for (GroupOrderGuest guest : guests) {
				if (guest.getType() == 3) {
					sb.append(guest.getName() + " " + guest.getMobile());
				}
			}
			guestGuideString = sb.toString();
			for (GroupOrderGuest guest : guests) {
				if (guest.getIsLeader() == 1) {
					gopp.setGuesStatic(guest.getName() + "\n"
							+ guest.getMobile());
					break;
				}
			}
			if (gopp.getGuestInfo() == null || gopp.getGuestInfo() == "") {
				// 如果客人中没有领队，默认取一条数据显示
				gopp.setGuesStatic(guests.get(0).getName() + "\n"
						+ guests.get(0).getMobile());
			}
			// gopp.setGuestInfo(getGuestInfoNoPhone(guests));
		}

		// 根据散客订单统计酒店信息
		List<GroupRequirement> grogShopList = groupRequirementService
				.selectByOrderAndType(groupOrder.getId(), 3);
		if (grogShopList.size() > 0) {
			if (grogShopList.get(0).getHotelLevel() != null && grogShopList.get(0).getHotelLevel() !="" ) {
				DicInfo info = dicService.getById(grogShopList.get(0).getHotelLevel());
				if(info!=null){
					gopp.setHotelLevel(info.getValue()+ "\n");
				}
			}
			gopp.setHotelNum(getHotelNum(grogShopList));
		}
		// 省外交通
		// 根据散客订单统计接机信息
		List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
				.selectByOrderId(groupOrder.getId());
		gopp.setAirPickup(getAirInfo(groupOrderTransports, 0));
		// 根据散客订单统计送机信息
		gopp.setAirOff(getAirInfo(groupOrderTransports, 1));

		// 省内交通
		gopp.setTrans(getSourceType(groupOrderTransports));
		model.addAttribute("agency", agency);
		model.addAttribute("guideString", guideString);
		model.addAttribute("guestGuideString", guestGuideString);
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("supplier", supplier);
		model.addAttribute("company",
				orgService.findByOrgId(employee.getOrgId()).getName()); // 当前单位
		model.addAttribute("employee", employee);
		model.addAttribute("person","");
		model.addAttribute("routeList", routeList);
		if (null != priceList && priceList.size() > 0) {
			model.addAttribute("otherPrice", priceList
					.get(priceList.size() - 1).getTotalPrice());
		} else {
			model.addAttribute("otherPrice", 0);
		}

		model.addAttribute("priceList", priceList);
		model.addAttribute("gopp", gopp);
		model.addAttribute("guestList", toGetGuestString(guests));
		model.addAttribute("orderId", orderId);
		model.addAttribute("guests", guests);
		model.addAttribute("orderType", groupOrder.getOrderType());
		model.addAttribute("hotelNum", getHotelNum(grogShopList));
		model.addAttribute("upAndOff",
				"接机：" + getAirInfo(groupOrderTransports, 0) + "\n" + "送机："
						+ getAirInfo(groupOrderTransports, 1) + "\n" + "省内:"
						+ getSourceType(groupOrderTransports));
		model.addAttribute("bankCount", getBankInfo(request));
		String url = "sales/preview/preview";
		if (num != 1) {
			url = "sales/preview/sales_confirm_noRoute";
		}
		return url;*/

		ToPreviewResult toPreviewResult = tourGroupFacade.toPreview( orderId,  num,  agency,  WebUtils.getCurBizId(request));
		model.addAttribute("agency", agency);
		model.addAttribute("guideString", toPreviewResult.getGuideString());
		model.addAttribute("guestGuideString", toPreviewResult.getGuestGuideString());
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("imgPath", toPreviewResult.getImgPath());
		model.addAttribute("groupOrder", toPreviewResult.getGroupOrder());
		model.addAttribute("supplier", toPreviewResult.getSupplier());
		model.addAttribute("company",toPreviewResult.getCompany()); // 当前单位
		model.addAttribute("employee", toPreviewResult.getEmployee());
		model.addAttribute("person","");
		model.addAttribute("routeList", toPreviewResult.getRouteList());
		if (null != toPreviewResult.getPriceList() && toPreviewResult.getPriceList().size() > 0) {
			model.addAttribute("otherPrice", toPreviewResult.getPriceList()
					.get(toPreviewResult.getPriceList().size() - 1).getTotalPrice());
		} else {
			model.addAttribute("otherPrice", 0);
		}

		model.addAttribute("priceList", toPreviewResult.getPriceList());
		model.addAttribute("gopp", toPreviewResult.getGopp());
		model.addAttribute("guestList", toGetGuestString(toPreviewResult.getGuests()));
		model.addAttribute("orderId", orderId);
		model.addAttribute("guests", toPreviewResult.getGuests());
		model.addAttribute("orderType", toPreviewResult.getGroupOrder().getOrderType());
		model.addAttribute("hotelNum", getHotelNum(toPreviewResult.getGrogShopList()));
		model.addAttribute("upAndOff",
				"接机：" + getAirInfo(toPreviewResult.getGroupOrderTransports(), 0) + "\n" + "送机："
						+ getAirInfo(toPreviewResult.getGroupOrderTransports(), 1) + "\n" + "省内:"
						+ getSourceType(toPreviewResult.getGroupOrderTransports()));
		model.addAttribute("bankCount", getBankInfo(request));
		String url = "sales/preview/preview";
		if (num != 1) {
			url = "sales/preview/sales_confirm_noRoute";
		}
		return url;
	}

	@RequestMapping(value = "/toSaleCharge.htm")
	public String toSaleCharge(HttpServletRequest request, Model model,
			Integer orderId, Integer num) {
		/*String imgPath = bizSettingCommon.getMyBizLogo(request);
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		SupplierInfo supplier = supplierService.selectBySupplierId(groupOrder
				.getSupplierId());

		PlatformEmployeePo employee = sysPlatformEmployeeFacade
				.findByEmployeeId(groupOrder.getSaleOperatorId()).getPlatformEmployeePo();

		List<GroupOrderGuest> guests = groupOrderGuestService
				.selectByOrderId(orderId);
		List<GroupOrderPrice> priceList = groupOrderPriceService
				.selectByOrder(orderId);
		GroupOrderPrice gop = new GroupOrderPrice();
		gop.setItemName(com.yihg.sales.constants.Constants.PRICETYPE);
		gop.setUnitPrice(com.yihg.sales.constants.Constants.PRICE);
		gop.setNumTimes(com.yihg.sales.constants.Constants.TIMES);
		gop.setNumPerson(new Double(groupOrderService.selectTotalNumByOrderId(orderId)))  ;
		gop.setTotalPrice(gop.getUnitPrice()*gop.getNumPerson());
		priceList.add(gop) ;
		List<GroupRoute> routeList = groupRouteService.selectByOrderId(orderId);
		List<SysBizBankAccount> accountList = bizBankAccountService
				.getListByBizId(WebUtils.getCurBizId(request));
		if (null != priceList && priceList.size() > 0) {
			model.addAttribute("otherPrice", priceList
					.get(priceList.size() - 1).getTotalPrice());
		} else {
			model.addAttribute("otherPrice", 0);
		}
		model.addAttribute("person",groupOrder.getNumAdult()+"+"+groupOrder.getNumChild()+"+"+groupOrder.getNumGuide());
		model.addAttribute("guest_guide", toGetGuideString(guests)); // 姓名和电话
		model.addAttribute("guest_leader", toGetLeaderString(guests)); // 姓名和电话
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("supplier", supplier);
		model.addAttribute("company",
				orgService.findByOrgId(employee.getOrgId()).getName()); // 当前单位
		model.addAttribute("employee", employee);
		model.addAttribute("routeList", routeList);
		model.addAttribute("priceList", priceList);
		model.addAttribute("guestList", toGetGuestString(guests));
		model.addAttribute("orderId", orderId);
		model.addAttribute("accountList", accountList);
		String url = "sales/preview/sales_charge";
		if (num != 2) {
			url = "sales/preview/sales_charge_noRoute";
		}
		return url;*/

		ToSaleChargeResult toPreviewResult = tourGroupFacade.toSaleCharge( orderId,  num, WebUtils.getCurUserId(request), WebUtils.getCurBizId(request));
		model.addAttribute("person", toPreviewResult.getGroupOrder().getNumAdult() + "+" + toPreviewResult.getGroupOrder().getNumChild() + "+" + toPreviewResult.getGroupOrder().getNumGuide());
		model.addAttribute("guest_guide", toGetGuideString(toPreviewResult.getGuests())); // 姓名和电话
		model.addAttribute("guest_leader", toGetLeaderString(toPreviewResult.getGuests())); // 姓名和电话
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("imgPath", toPreviewResult.getImgPath());
		model.addAttribute("groupOrder", toPreviewResult.getGroupOrder());
		model.addAttribute("supplier", toPreviewResult.getSupplier());
		model.addAttribute("company",toPreviewResult.getCompany()); // 当前单位
		model.addAttribute("employee", toPreviewResult.getEmployee());
		model.addAttribute("routeList", toPreviewResult.getRouteList());
		model.addAttribute("priceList", toPreviewResult.getPriceList());
		model.addAttribute("guestList", toGetGuestString(toPreviewResult.getGuests()));
		model.addAttribute("orderId", orderId);
		model.addAttribute("accountList", toPreviewResult.getAccountList());
		String url = "sales/preview/sales_charge";
		if (num != 2) {
			url = "sales/preview/sales_charge_noRoute";
		}
		return url;


	}

	/**
	 * 散客确认单预览
	 * 
	 * @param request
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toSKConfirmPreview.htm")
	public String toSKConfirmPreview(HttpServletRequest request,
			Integer groupId, Integer supplierId, Model model) {
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		TourGroup tour = tourGroupService.selectByPrimaryKey(groupId);
//		PlatformEmployeePo po = sysPlatformEmployeeFacade
//				.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();
//		po.setOrgName(orgService.findByOrgId(po.getOrgId()).getName());
//		List<GroupOrder> suppliers = groupOrderService
//				.selectSupplierByGroupId(groupId);
//		SupplierInfo supplierInfo = null;
//		List<SupplierInfo> supplierList = new ArrayList<SupplierInfo>();
//
//		for (GroupOrder order : suppliers) {
//			supplierInfo = supplierService.selectBySupplierId(order
//					.getSupplierId());
//			supplierList.add(supplierInfo);
//		}
//		// 行程
//		GroupOrder supplier = null;
//		if (null == supplierId && supplierList.size() > 0) {
//			supplierId = supplierList.get(0).getId();
//		}
//		GroupRouteVO vo = groupRouteService
//				.findGroupRouteByGroupIdAndSupplierId(groupId, supplierId);
//
//		List<GroupRouteDayVO> groupRouteDayVOs = vo.getGroupRouteDayVOList();
//
//		List<GroupPriceVo> vos = groupOrderService
//				.selectSupplierByGroupIdAndSupplierId(groupId, supplierId);
//
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupIdAndBizIdAndSupplierId(groupId, supplierId,
//						WebUtils.getCurBizId(request));
//		for (GroupOrder groupOrder : orders) {
//			if (groupOrder.getSupplierId() == supplierId) {
//				supplier = groupOrder;
//			}
//		}
//		GroupOrderPrintPo gopp = null;
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//		for (GroupOrder order : orders) {
//			List<GroupOrderGuest> guests = groupOrderGuestService
//					.selectByOrderId(order.getId());
//			gopp = new GroupOrderPrintPo();
//			// 客人接送信息
//			gopp.setSupplierName(order.getSupplierName());
//			gopp.setSaleOperatorName(order.getSaleOperatorName());
//			gopp.setRemark(order.getRemarkInternal());
//			gopp.setPlace((order.getProvinceName() == null ? "" : order
//					.getProvinceName())
//					+ (order.getCityName() == null ? "" : order.getCityName()));
//			gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
//			// 根据散客订单统计客人信息
//			if (guests.size() > 0) {
//				gopp.setCertificateNums(getGuestInfoNoPhone(guests));
//				for (GroupOrderGuest guest : guests) {
//					if (guest.getIsLeader() == 1) {
//						gopp.setGuesStatic(guest.getName() + "\n"
//								+ guest.getMobile());
//						break;
//					}
//				}
//				/*
//				if (gopp.getGuestInfo() == null || gopp.getGuestInfo() == "") {
//					// 如果客人中没有领队，默认取一条数据显示
//					gopp.setGuesStatic(guests.get(0).getName() + "\n"
//							+ guests.get(0).getMobile());
//				}*/
//			}
//			
//			gopp.setReceiveMode(order.getReceiveMode());
//			// 根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order.getId(), 3);
//			if (grogShopList.size() > 0) {
//				if (grogShopList.get(0).getHotelLevel() != null) {
//					gopp.setHotelLevel(dicService.getById(
//							grogShopList.get(0).getHotelLevel()).getValue()
//							+ "\n");
//				}
//				gopp.setHotelNum(getHotelNum(grogShopList));
//			}
//			// 省外交通
//			// 根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//					.selectByOrderId(order.getId());
//			gopp.setAirPickup("接机：" + getAirInfo(groupOrderTransports, 0));
//			// 根据散客订单统计送机信息
//			gopp.setAirOff("送机：" + getAirInfo(groupOrderTransports, 1));
//
//			// 省内交通
//			gopp.setTrans("省内：" + getSourceType(groupOrderTransports));
//			gopps.add(gopp);
//		}
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
//		model.addAttribute("supplier", supplier);
//		model.addAttribute("groupId", groupId);
//		model.addAttribute("supplierId", supplierId);
//		model.addAttribute("guide", getGuides(guides));
//		Collections.reverse(gopps);
//		model.addAttribute("gopps", gopps);
//		model.addAttribute("vos", vos);
//		model.addAttribute("guides", guides);
//		model.addAttribute("groupRouteDayVOs", groupRouteDayVOs);
//		model.addAttribute("supplierList", supplierList);
//		model.addAttribute("po", po);
//		model.addAttribute("imgPath", imgPath);
//		model.addAttribute("tour", tour);
//		model.addAttribute("printTime", DateUtils.format(new Date()));
//		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		
		ToSKConfirmPreviewDTO toSKConfirmPreviewDTO=new ToSKConfirmPreviewDTO();
		toSKConfirmPreviewDTO.setCurBizId(WebUtils.getCurBizId(request));
		toSKConfirmPreviewDTO.setCurUserId(WebUtils.getCurUserId(request));
		toSKConfirmPreviewDTO.setGroupId(groupId);
		toSKConfirmPreviewDTO.setSupplierId(supplierId);
		
		ToSKConfirmPreviewResult result = tourGroupFacade.toSKConfirmPreview(toSKConfirmPreviewDTO);
		
		model.addAttribute("supplier", result.getSupplier());
		model.addAttribute("groupId", groupId);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("guide", result.getGuide());
		
		List<GroupOrderPrintPo> gopps=result.getGopps();
		Collections.reverse(gopps);
		model.addAttribute("gopps", gopps);
		
		model.addAttribute("vos", result.getVos());
		model.addAttribute("guides", result.getGuides());
		model.addAttribute("groupRouteDayVOs", result.getGroupRouteDayVOs());
		model.addAttribute("supplierList", result.getSupplierList());
		model.addAttribute("po", result.getPo());
		model.addAttribute("imgPath", result.getImgPath());
		model.addAttribute("tour", result.getTour());
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		
		return "sales/preview/skconfirm";
	}

	/**
	 * 散客结算单预览
	 * 
	 * @param request
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toSKChargePreview.htm")
	public String toSKChargePreview(HttpServletRequest request,
			Integer groupId, Integer supplierId, Model model) {
	/*	String imgPath = bizSettingCommon.getMyBizLogo(request);
		TourGroup tour = tourGroupService.selectByPrimaryKey(groupId);
		PlatformEmployeePo po = sysPlatformEmployeeFacade
				.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();
		po.setOrgName(orgService.findByOrgId(po.getOrgId()).getName());
		List<GroupOrder> suppliers = groupOrderService
				.selectSupplierByGroupId(groupId);
		SupplierInfo supplierInfo = null;
		List<SupplierInfo> supplierList = new ArrayList<SupplierInfo>();

		for (GroupOrder order : suppliers) {
			supplierInfo = supplierService.selectBySupplierId(order
					.getSupplierId());
			supplierList.add(supplierInfo);
		}
		// 行程
		GroupOrder supplier = null;
		if (null == supplierId && supplierList.size() > 0) {
			supplierId = supplierList.get(0).getId();
		}
		GroupRouteVO vo = groupRouteService
				.findGroupRouteByGroupIdAndSupplierId(groupId, supplierId);

		// List<GroupRouteDayVO> groupRouteDayVOs = vo.getGroupRouteDayVOList();

		List<GroupPriceVo> vos = groupOrderService
				.selectSupplierByGroupIdAndSupplierId(groupId, supplierId);

		List<GroupOrder> orders = groupOrderService
				.selectOrderByGroupIdAndBizIdAndSupplierId(groupId, supplierId,
						WebUtils.getCurBizId(request));
		for (GroupOrder groupOrder : orders) {
			if (groupOrder.getSupplierId() == supplierId) {
				supplier = groupOrder;
			}
		}
		GroupOrderPrintPo gopp = null;
		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
		for (GroupOrder order : orders) {
			List<GroupOrderGuest> guests = groupOrderGuestService
					.selectByOrderId(order.getId());
			gopp = new GroupOrderPrintPo();
			// 客人接送信息
			gopp.setSupplierName(order.getSupplierName());
			gopp.setSaleOperatorName(order.getSaleOperatorName());
			gopp.setRemark(order.getRemarkInternal());
			gopp.setPlace((order.getProvinceName() == null ? "" : order
					.getProvinceName())
					+ (order.getCityName() == null ? "" : order.getCityName()));
			gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
			// 根据散客订单统计客人信息
			if (guests.size() > 0) {
				gopp.setCertificateNums(getGuestInfoNoPhone(guests));
			}
			gopp.setReceiveMode(order.getReceiveMode());
			// 根据散客订单统计酒店信息
			List<GroupRequirement> grogShopList = groupRequirementService
					.selectByOrderAndType(order.getId(), 3);
			if (grogShopList.size() > 0) {
				if (grogShopList.get(0).getHotelLevel() != null) {
					gopp.setHotelLevel(dicService.getById(
							grogShopList.get(0).getHotelLevel()).getValue()
							+ "\n");
				}
				gopp.setHotelNum(getHotelNum(grogShopList));
			}
			// 省外交通
			// 根据散客订单统计接机信息
			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
					.selectByOrderId(order.getId());
			gopp.setAirPickup("接机：" + getAirInfo(groupOrderTransports, 0));
			// 根据散客订单统计送机信息
			gopp.setAirOff("送机：" + getAirInfo(groupOrderTransports, 1));

			// 省内交通
			gopp.setTrans("省内：" + getSourceType(groupOrderTransports));
			gopps.add(gopp);
		}
		List<BookingGuide> guides = bookingGuideService
				.selectGuidesByGroupId(groupId);
		model.addAttribute("supplier", supplier);
		model.addAttribute("groupId", groupId);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("guide", getGuides(guides));
		Collections.reverse(gopps);
		model.addAttribute("gopps", gopps);
		model.addAttribute("vos", vos);
		model.addAttribute("guides", guides);
		// model.addAttribute("groupRouteDayVOs", groupRouteDayVOs);
		model.addAttribute("supplierList", supplierList);
		model.addAttribute("po", po);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("tour", tour);
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "sales/preview/skcharge";*/

		ToSKChargePreviewResult toSKChargePreviewResult = tourGroupFacade.toSKChargePreview( groupId,  WebUtils.getCurUserId(request),  WebUtils.getCurUserId(request),  supplierId);

		model.addAttribute("supplier", toSKChargePreviewResult.getSupplier());
		model.addAttribute("groupId", groupId);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("guide", getGuides(toSKChargePreviewResult.getGuides()));
		Collections.reverse(toSKChargePreviewResult.getGopps());
		model.addAttribute("gopps", toSKChargePreviewResult.getGopps());
		model.addAttribute("vos", toSKChargePreviewResult.getVos());
		model.addAttribute("guides", toSKChargePreviewResult.getGuides());
		// model.addAttribute("groupRouteDayVOs", groupRouteDayVOs);
		model.addAttribute("supplierList", toSKChargePreviewResult.getSupplier());
		model.addAttribute("po", toSKChargePreviewResult.getPo());
		model.addAttribute("imgPath", toSKChargePreviewResult.getImgPath());
		model.addAttribute("tour", toSKChargePreviewResult.getTour());
		model.addAttribute("printTime", DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "sales/preview/skcharge";
	}

	/**
	 * 散客团确认单导出word--散客团结算单（无行程）
	 * 
	 * @param request
	 * @param response
	 * @param groupId
	 * @param supplierId
	 */
	@RequestMapping(value = "/toSKConfirmPreviewExport.htm")
	public void toExportSKWord(HttpServletRequest request,
			HttpServletResponse response, Integer groupId, Integer supplierId,
			Integer num) {
//		String url = request.getSession().getServletContext().getRealPath("/")
//				+ "/download/" + System.currentTimeMillis() + ".doc";
//		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		TourGroup tour = tourGroupService.selectByPrimaryKey(groupId);
//		PlatformEmployeePo po = sysPlatformEmployeeFacade
//				.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();
//		po.setOrgName(orgService.findByOrgId(po.getOrgId()).getName());
//		List<GroupOrder> suppliers = groupOrderService
//				.selectSupplierByGroupId(groupId);
//		SupplierInfo supplierInfo = null;
//		List<SupplierInfo> supplierList = new ArrayList<SupplierInfo>();
//
//		for (GroupOrder order : suppliers) {
//			supplierInfo = supplierService.selectBySupplierId(order
//					.getSupplierId());
//			supplierList.add(supplierInfo);
//		}
//		// 行程
//		GroupOrder supplier = null;
//		if (supplierId == null) {
//			supplierId = supplierList.get(0).getId();
//
//		}
//		GroupRouteVO vo = new GroupRouteVO();
//		List<GroupRouteDayVO> groupRouteDayVOs = new ArrayList<GroupRouteDayVO>();
//		if (num != 1) {
//			vo = groupRouteService.findGroupRouteByGroupIdAndSupplierId(
//					groupId, supplierId);
//			groupRouteDayVOs = vo.getGroupRouteDayVOList();
//		}
//		List<GroupPriceVo> vos = groupOrderService
//				.selectSupplierByGroupIdAndSupplierId(groupId, supplierId);
//		List<GroupOrder> orders = groupOrderService
//				.selectOrderByGroupIdAndBizIdAndSupplierId(groupId, supplierId,
//						WebUtils.getCurBizId(request));
//		for (GroupOrder groupOrder : orders) {
//
//			if (groupOrder.getSupplierId().doubleValue() == supplierId
//					.doubleValue()) {
//				supplier = groupOrder;
//			}
//
//			GroupOrderPrintPo gopp = null;
//			List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>();
//			for (GroupOrder order : orders) {
//				List<GroupOrderGuest> guests = groupOrderGuestService
//						.selectByOrderId(order.getId());
//				gopp = new GroupOrderPrintPo();
//				// 客人接送信息
//				gopp.setSupplierName(order.getSupplierName());
//				gopp.setSaleOperatorName(order.getSaleOperatorName());
//				gopp.setRemark(order.getRemarkInternal());
//				gopp.setPlace((order.getProvinceName() == null ? "" : order
//						.getProvinceName())
//						+ (order.getCityName() == null ? "" : order
//								.getCityName()));
//				gopp.setPersonNum(order.getNumAdult()+"+"+order.getNumChild());
//				// 根据散客订单统计客人信息
//				if (guests.size() > 0) {
//					gopp.setCertificateNums(getGuestInfoNoPhone(guests));
//				}
//				gopp.setReceiveMode(order.getReceiveMode());
//				// 根据散客订单统计酒店信息
//				List<GroupRequirement> grogShopList = groupRequirementService
//						.selectByOrderAndType(order.getId(), 3);
//				if (grogShopList.size() > 0) {
//					if (grogShopList.get(0).getHotelLevel() != null) {
//						gopp.setHotelLevel(dicService.getById(
//								grogShopList.get(0).getHotelLevel()).getValue()
//								+ "\n");
//					}
//					gopp.setHotelNum(getHotelNum(grogShopList));
//				}
//				// 省外交通
//				// 根据散客订单统计接机信息
//				List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//						.selectByOrderId(order.getId());
//				gopp.setAirPickup("接机：" + getAirInfo(groupOrderTransports, 0));
//				// 根据散客订单统计送机信息
//				gopp.setAirOff("送机：" + getAirInfo(groupOrderTransports, 1));
//
//				// 省内交通
//				gopp.setTrans("省内：" + getSourceType(groupOrderTransports));
//				gopps.add(gopp);
//			}
//			List<BookingGuide> guides = bookingGuideService
//					.selectGuidesByGroupId(groupId);
//			String realPath = request.getSession().getServletContext()
//					.getRealPath("/template/skConfirm.docx");
//			if (1 == num) {
//				realPath = request.getSession().getServletContext()
//						.getRealPath("/template/skCharge.docx");
//			}
//			WordReporter export = new WordReporter(realPath);
//			try {
//				export.init();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//			Map<String, Object> params1 = new HashMap<String, Object>();
//			params1.put("printTime", DateUtils.format(new Date()));
//			params1.put("printName", WebUtils.getCurUser(request).getName());
//			if (imgPath != null) {
//				Map<String, String> picMap = new HashMap<String, String>();
//				picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
//				picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
//				picMap.put("type", "jpg");
//				picMap.put("path", imgPath);
//				params1.put("logo", picMap);
//			} else {
//				params1.put("logo", "");
//			}
//			Map<String, Object> map0 = new HashMap<String, Object>();
//			// 收件方信息
//			map0.put("supplier_name", supplier.getSupplierName());
//			map0.put("contact", supplier.getContactName());
//			map0.put("contact_tel", supplier.getContactTel());
//			map0.put("contact_fax", supplier.getContactFax());
//			// 发件方信息（定制团显示为销售）
//			// 销售计调的组织机构信息
//			PlatformEmployeePo employee = sysPlatformEmployeeFacade
//					.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();
//			map0.put("company", orgService.findByOrgId(employee.getOrgId())
//					.getName()); // 当前单位
//			map0.put("user_name", employee.getName());
//			map0.put("user_tel", employee.getMobile());
//			map0.put("user_fax", employee.getFax());
//
//			Map<String, Object> map1 = new HashMap<String, Object>();
//			map1.put("groupCode", tour.getGroupCode());
//			map1.put("dateStart", DateUtils.format(tour.getDateStart()));
//			map1.put("person",
//					tour.getTotalAdult() + "+" + tour.getTotalChild());
//			map1.put("guide", getGuides(guides));
//			map1.put("productName", "【" + tour.getProductBrandName() + "】"
//					+ tour.getProductName());
//			/**
//			 * 行程列表表格
//			 */
//			List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
//			if (num != 1) {
//				for (GroupRouteDayVO groupRoute : groupRouteDayVOs) {
//					Map<String, String> map = new HashMap<String, String>();
//					if (null != groupRoute.getGroupRoute().getGroupDate()) {
//						map.put("day_num", DateUtils.format(groupRoute
//								.getGroupRoute().getGroupDate()));
//					} else {
//						map.put("day_num", "");
//					}
//					map.put("route_desp", groupRoute.getGroupRoute()
//							.getRouteDesp());
//					map.put("breakfast", groupRoute.getGroupRoute()
//							.getBreakfast());
//					map.put("lunch", groupRoute.getGroupRoute().getLunch());
//					map.put("supper", groupRoute.getGroupRoute().getSupper());
//					map.put("hotel_name", groupRoute.getGroupRoute()
//							.getHotelName());
//					routeList.add(map);
//				}
//			}
//			/**
//			 * 收入表格
//			 */
//			List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
//			Double totalNum = new Double(0);
//			int i = 1;
//			for (int j = 0; j <= vos.size(); j++) {
//				Map<String, String> map = new HashMap<String, String>();
//				if (j != vos.size()) {
//					map.put("numOne", "" + i++);
//					map.put("receivedMode", vos.get(j).getReceiveMode());
//					map.put("priceDetail", vos.get(j).getPriceDetail());
//					map.put("totalPrice", vos.get(j).getTotalPrice().toString()
//							.replace(".0", ""));
//					totalNum += vos.get(j).getTotalPrice();
//				} else {
//					map.put("numOne", "");
//					map.put("receivedMode", "总计：");
//					map.put("priceDetail", "");
//					map.put("totalPrice", totalNum.toString().replace(".0", ""));
//				}
//				priceList.add(map);
//			}
//
//			Map<String, Object> map4 = new HashMap<String, Object>();
//			if (null != tour) {
//				map4.put("remarkTwo", tour.getRemark());
//				map4.put("service", tour.getServiceStandard());
//			}
//			List<Map<String, String>> goppsList = new ArrayList<Map<String, String>>();
//			int x = 1;
//			Collections.reverse(gopps);
//			for (int j = 0; j < gopps.size(); j++) {
//				Map<String, String> map5 = new HashMap<String, String>();
//				map5.put("numTwo", "" + x++);
//				map5.put("guest", gopps.get(j).getReceiveMode());
//				map5.put("persons", gopps.get(j).getPersonNum());
//				map5.put("place", gopps.get(j).getPlace());
//				map5.put("hotelLevle", gopps.get(j).getHotelLevel());
//				map5.put("hotelNum", gopps.get(j).getHotelNum());
//				map5.put("trans", gopps.get(j).getAirPickup()
//						+ gopps.get(j).getAirOff() + gopps.get(j).getTrans());
//				map5.put("cerNum", gopps.get(j).getCertificateNums());
//				map5.put("remarkOne", gopps.get(j).getRemark());
//				goppsList.add(map5);
//			}
//			try {
//				export.export(params1);
//				export.export(map0, 0);
//				export.export(map1, 1);
//				if (num != 1) {
//					export.export(routeList, 2);
//					export.export(priceList, 3);
//					export.export(goppsList, 4);
//					export.export(map4, 5);
//				} else {
//					export.export(priceList, 2);
//					export.export(goppsList, 3);
//					export.export(map4, 4);
//				}
//				export.generate(url);
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//
//			try {
//				request.setCharacterEncoding("UTF-8");
//			} catch (UnsupportedEncodingException e1) {
//				e1.printStackTrace();
//			}
//			String fileName = "";
//			try {
//				fileName = new String("散客确认单.doc".getBytes("UTF-8"),
//						"iso-8859-1");
//				if (1 == num) {
//					fileName = new String("散客结算单.doc".getBytes("UTF-8"),
//							"iso-8859-1");
//				}
//			} catch (UnsupportedEncodingException e) {
//				e.printStackTrace();
//			}
//			response.setCharacterEncoding("utf-8");
//			response.setContentType("application/msword"); // word格式
//			try {
//				response.setHeader("Content-Disposition",
//						"attachment; filename=" + fileName);
//				File file = new File(url);
//				InputStream inputStream = new FileInputStream(file);
//				OutputStream os = response.getOutputStream();
//				byte[] b = new byte[1024];
//				int length;
//				while ((length = inputStream.read(b)) > 0) {
//					os.write(b, 0, length);
//				}
//				inputStream.close();
//				os.flush();
//				os.close();
//				file.delete();
//			} catch (FileNotFoundException e) {
//				e.printStackTrace();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}

		
		
		ToSKConfirmPreviewDTO toSKConfirmPreviewDTO=new ToSKConfirmPreviewDTO();
		toSKConfirmPreviewDTO.setCurBizId(WebUtils.getCurBizId(request));
		toSKConfirmPreviewDTO.setCurUserId(WebUtils.getCurUserId(request));
		toSKConfirmPreviewDTO.setGroupId(groupId);
		toSKConfirmPreviewDTO.setSupplierId(supplierId);
		
		ToSKConfirmPreviewResult result = tourGroupFacade.toSKConfirmPreview(toSKConfirmPreviewDTO);
		
		String url = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis() + ".doc";
		
		String imgPath = result.getImgPath();
		GroupOrder supplier = result.getSupplier();
		TourGroup tour = result.getTour();
		String guideStr = result.getGuide();
		List<GroupRouteDayVO> groupRouteDayVOs = result.getGroupRouteDayVOs();
		List<GroupPriceVo> vos = result.getVos();
		List<GroupOrderPrintPo> gopps = result.getGopps();

		String realPath = request.getSession().getServletContext().getRealPath("/template/skConfirm.docx");
		if (1 == num) {
			realPath = request.getSession().getServletContext().getRealPath("/template/skCharge.docx");
		}
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", DateUtils.format(new Date()));
		params1.put("printName", WebUtils.getCurUser(request).getName());
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
		Map<String, Object> map0 = new HashMap<String, Object>();
		// 收件方信息
		map0.put("supplier_name", supplier.getSupplierName());
		map0.put("contact", supplier.getContactName());
		map0.put("contact_tel", supplier.getContactTel());
		map0.put("contact_fax", supplier.getContactFax());
		// 发件方信息（定制团显示为销售）
		// 销售计调的组织机构信息
		PlatformEmployeePo employee = sysPlatformEmployeeFacade.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();

		//FIXME 待修复
		map0.put("company", sysPlatformOrgFacade.findByOrgId(employee.getOrgId()).getPlatformOrgPo().getName()); // 当前单位

		map0.put("user_name", employee.getName());
		map0.put("user_tel", employee.getMobile());
		map0.put("user_fax", employee.getFax());

		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("groupCode", tour.getGroupCode());
		map1.put("dateStart", DateUtils.format(tour.getDateStart()));
		map1.put("person", tour.getTotalAdult() + "+" + tour.getTotalChild());
		//map1.put("guide", getGuides(guides));
		map1.put("guide",guideStr);
		map1.put("productName", "【" + tour.getProductBrandName() + "】" + tour.getProductName());
		/**
		 * 行程列表表格
		 */
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		if (num != 1) {
			for (GroupRouteDayVO groupRoute : groupRouteDayVOs) {
				Map<String, String> map = new HashMap<String, String>();
				if (null != groupRoute.getGroupRoute().getGroupDate()) {
					map.put("day_num", DateUtils.format(groupRoute.getGroupRoute().getGroupDate()));
				} else {
					map.put("day_num", "");
				}
				map.put("route_desp", groupRoute.getGroupRoute().getRouteDesp());
				map.put("breakfast", groupRoute.getGroupRoute().getBreakfast());
				map.put("lunch", groupRoute.getGroupRoute().getLunch());
				map.put("supper", groupRoute.getGroupRoute().getSupper());
				map.put("hotel_name", groupRoute.getGroupRoute().getHotelName());
				routeList.add(map);
			}
		}
		/**
		 * 收入表格
		 */
		List<Map<String, String>> priceList = new ArrayList<Map<String, String>>();
		Double totalNum = new Double(0);
		int i = 1;
		for (int j = 0; j <= vos.size(); j++) {
			Map<String, String> map = new HashMap<String, String>();
			if (j != vos.size()) {
				map.put("numOne", "" + i++);
				map.put("receivedMode", vos.get(j).getReceiveMode());
				map.put("priceDetail", vos.get(j).getPriceDetail());
				map.put("totalPrice", vos.get(j).getTotalPrice().toString().replace(".0", ""));
				totalNum += vos.get(j).getTotalPrice();
			} else {
				map.put("numOne", "");
				map.put("receivedMode", "总计：");
				map.put("priceDetail", "");
				map.put("totalPrice", totalNum.toString().replace(".0", ""));
			}
			priceList.add(map);
		}

		Map<String, Object> map4 = new HashMap<String, Object>();
		if (null != tour) {
			map4.put("remarkTwo", tour.getRemark());
			map4.put("service", tour.getServiceStandard());
		}
		List<Map<String, String>> goppsList = new ArrayList<Map<String, String>>();
		int x = 1;
		Collections.reverse(gopps);
		for (int j = 0; j < gopps.size(); j++) {
			Map<String, String> map5 = new HashMap<String, String>();
			map5.put("numTwo", "" + x++);
			map5.put("guest", gopps.get(j).getReceiveMode());
			map5.put("persons", gopps.get(j).getPersonNum());
			map5.put("place", gopps.get(j).getPlace());
			map5.put("hotelLevle", gopps.get(j).getHotelLevel());
			map5.put("hotelNum", gopps.get(j).getHotelNum());
			map5.put("trans", gopps.get(j).getAirPickup() + gopps.get(j).getAirOff() + gopps.get(j).getTrans());
			map5.put("cerNum", gopps.get(j).getCertificateNums());
			map5.put("remarkOne", gopps.get(j).getRemark());
			goppsList.add(map5);
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(map1, 1);
			if (num != 1) {
				export.export(routeList, 2);
				export.export(priceList, 3);
				export.export(goppsList, 4);
				export.export(map4, 5);
			} else {
				export.export(priceList, 2);
				export.export(goppsList, 3);
				export.export(map4, 4);
			}
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("散客确认单.doc".getBytes("UTF-8"), "iso-8859-1");
			if (1 == num) {
				fileName = new String("散客结算单.doc".getBytes("UTF-8"), "iso-8859-1");
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/msword"); // word格式
		try {
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			File file = new File(url);
			InputStream inputStream = new FileInputStream(file);
			OutputStream os = response.getOutputStream();
			byte[] b = new byte[1024];
			int length;
			while ((length = inputStream.read(b)) > 0) {
				os.write(b, 0, length);
			}
			inputStream.close();
			os.flush();
			os.close();
			file.delete();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/getSupplierInfo", method = RequestMethod.POST)
	@ResponseBody
	public String getSupplierInfo(HttpServletRequest request,
			Integer supplierId, Model model) {
		/*SupplierInfo supplierInfo = supplierService
				.selectBySupplierId(supplierId);
		Gson gson = new Gson();
		String string = gson.toJson(supplierInfo);
		return string;*/
		BookingProfitTableResult bookingProfitTableResult = tourGroupFacade.getSupplierInfo(supplierId);
		//SupplierInfo supplierInfo = supplierService
		//		.selectBySupplierId(supplierId);
		SupplierInfo supplierInfo = bookingProfitTableResult.getSupplierInfo();
				Gson gson = new Gson();
		String string = gson.toJson(supplierInfo);
		return string;
	}

	/**
	 * 组织所有导游信息
	 * 
	 * @param guides
	 * @return
	 */
	public String getGuides(List<BookingGuide> guides) {
		StringBuilder sb = new StringBuilder();
		for (BookingGuide guide : guides) {
			sb.append(guide.getGuideName() + " " + guide.getGuideMobile()
					+ "\n");
		}
		return sb.toString();
	}
	
	public String getBankInfo(HttpServletRequest request){
	/*	List<SysBizBankAccount> sysBizBankAccountList = bizBankAccountService
				.getListByBizId(WebUtils.getCurBizId(request));
		StringBuilder sb = new StringBuilder() ;
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			sb.append("类别:"
					+ (sysBizBankAccount.getAccountType() == 1 ? "个人账户"
							: "对公账户") + " 银行名称："
					+ sysBizBankAccount.getBankName()
					+ sysBizBankAccount.getBankAccount() + " 开户全称："
					+ sysBizBankAccount.getAccountName() + " 公司账号："
					+ sysBizBankAccount.getAccountNo() + "\n");
		}
		return sb.toString() ;*/
		BookingProfitTableResult bookingProfitTableResult = tourGroupFacade.getBankInfo(WebUtils.getCurBizId(request));
		List<SysBizBankAccount> sysBizBankAccountList = bookingProfitTableResult.getSysBizBankAccountList();
		StringBuilder sb = new StringBuilder() ;
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			sb.append("类别:"
					+ (sysBizBankAccount.getAccountType() == 1 ? "个人账户"
					: "对公账户") + " 银行名称："
					+ sysBizBankAccount.getBankName()
					+ sysBizBankAccount.getBankAccount() + " 开户全称："
					+ sysBizBankAccount.getAccountName() + " 公司账号："
					+ sysBizBankAccount.getAccountNo() + "\n");
		}
		return sb.toString() ;
	}
	@RequestMapping("bookingProfit.htm")
	public String bookingProfitList(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		return "/sales/bookingProfit/bookingProfitList";
		
	}
	@RequestMapping("bookingProfit.do")
	public String bookingProfitTable(HttpServletRequest request,HttpServletResponse response,ModelMap model,TourGroup tourGroup){
	/*	PageBean pageBean=new PageBean();
		if (tourGroup.getPage()==null) {
			pageBean.setPage(1);
		}
		else {
			
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize()==null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		}
		else {
			pageBean.setPageSize(tourGroup.getPageSize());
		}
		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds())
				&& StringUtils.isNotBlank(tourGroup.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = tourGroup.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String operatorIds = "";
			for (Integer usrId : set) {
				operatorIds += usrId + ",";
			}
			if (!operatorIds.equals("")) {
				tourGroup.setSaleOperatorIds(operatorIds.substring(0,
						operatorIds.length() - 1));
			}
		}
		pageBean.setParameter(tourGroup);
		model.addAttribute("sum", tourGroupService.selectBookingProfitTotal(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request)));
		pageBean= tourGroupService.selectBookingProfitList(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		List result = pageBean.getResult();
		if (result !=null && result.size()>0) {
			for (Object obj : result) {
			 TourGroup	tGroup=(TourGroup)obj;
			 //List<GroupOrder> groupOrderList = tGroup.getGroupOrderList();
			 //if (groupOrderList !=null && groupOrderList.size()>0) {
				 if (tGroup.getGroupMode()<1) {
					tGroup.setSupplierName("散客团");
				}
//				else {
//					tGroup.setSupplierName(groupOrderList.get(0).getSupplierName()==null?"":groupOrderList.get(0).getSupplierName());
//				}
//				 for (GroupOrder gOrder : groupOrderList) {
//					List<GroupOrderPrice> orderPrices = gOrder.getOrderPrices();
//					if (orderPrices !=null && orderPrices.size()>0) {
//						tGroup.setTotalBudget(orderPrices.get(0).getTotalPrice()==null?new BigDecimal(0):new BigDecimal(orderPrices.get(0).getTotalPrice()));
//					}
//				}
			//}
			}
		}
		model.addAttribute("page", pageBean);*/

		BookingProfitTableResult bookingProfitTableResult = tourGroupFacade.bookingProfitTable(tourGroup, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		model.addAttribute("sum", bookingProfitTableResult.getSum());
		model.addAttribute("page", bookingProfitTableResult.getPageBean());
		return "/sales/bookingProfit/bookingProfitTable";
		
	}
}
