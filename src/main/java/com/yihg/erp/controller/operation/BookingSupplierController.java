package com.yihg.erp.controller.operation;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.google.gson.Gson;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.exception.ClientException;
import com.yimayhd.erpcenter.common.util.NumberUtil;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplierDetail;
import com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.FinanceBillDetail;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRequirement;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupRouteDayVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupRouteVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.dal.sys.po.SysBizInfo;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.WebResult;
import com.yimayhd.erpcenter.facade.sales.result.operation.BookingSupplierResult;
import com.yimayhd.erpcenter.facade.sales.service.BookingSupplierFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.SupplierContract;
import com.yimayhd.erpresource.dal.po.SupplierContractPrice;
import com.yimayhd.erpresource.dal.po.SupplierItem;

@Controller
@RequestMapping("/booking")
public class BookingSupplierController extends BaseController {
	
	static Logger logger = LoggerFactory.getLogger(BookingSupplierController.class);
	
	@Autowired
	private SysConfig config;
	@Autowired
	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
//	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private BookingSupplierFacade bookingSupplierFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@Autowired
	private SysPlatformOrgFacade sysPlatformOrgFacade;
	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model, HttpServletRequest request) {
//		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
//		model.addAttribute("orgUserJsonStr", sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
	}

	@RequestMapping("/hotelList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_HOTEL)
	public String hotelList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.HOTEL);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);

		return "/operation/supplier/hotel/supplier-list";
		
	}
	
	@RequestMapping("/carList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_CAR)
	public String carList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.FLEET);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/car/supplier-list";
		
	}

	
	@RequestMapping("/eatList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_RESTANRANT)
	public String eatList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.RESTAURANT);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/eat/supplier-list";
		
	}

	@RequestMapping("/funList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_ENTERAINMENT)
	public String funList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.ENTERTAINMENT);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/fun/supplier-list";
		
	}

	@RequestMapping("/golfList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GOLF)
	public String golfList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.GOLF);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/golf/supplier-list";
		
	}

	@RequestMapping("/sightList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_SCENIC)
	public String sightList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.SCENICSPOT);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/sight/supplier-list";
		
	}

	@RequestMapping("/airTicketList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_AIRTICKET)
	public String airTicketList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.AIRTICKETAGENT);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/airTicket/supplier-list";
		
	}

	@RequestMapping("/trainTicketList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_TRAIN)
	public String trainTicketList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.TRAINTICKETAGENT);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/trainTicket/supplier-list";
		
	}

	@RequestMapping("/insuranceList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_INSURANCE)
	public String insuranceList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.INSURANCE);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/insurance/supplier-list";
		
	}

	@RequestMapping("/incomeList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_INCOME)
	public String incomeList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.OTHERINCOME);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/income/supplier-list";
		
	}

	@RequestMapping("/outcomeList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_OUTCOME)
	public String outcomeList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("supplierType", Constants.OTHEROUTCOME);
		model.addAttribute("page", page);
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "/operation/supplier/outcome/supplier-list";
		
	}

	/**
	 * 计调-领单
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @param page
	 * @return
	 */
	@RequestMapping("/receiveOrderList.htm")
	public String receiveOrderList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		model.addAttribute("dataUser", WebUtils.getDataUserIdString(request));
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		
		return "operation/receiveOrderList";
	}

	/**
	 * 领单-查询
	 *
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/receiveOrderList.do")
	public String receiveOrderListSelect(HttpServletRequest request, ModelMap model, Integer pageSize, Integer page) {
		PageBean pageBean = new PageBean();
		if (page == null) {
			pageBean.setPage(1);
		} else {
			pageBean.setPage(page);
		}
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		//Integer bizId = WebUtils.getCurBizId(request);
		Map paramters = WebUtils.getQueryParamters(request);
//		if (StringUtils.isBlank((String) paramters.get("saleOperatorIds")) && StringUtils.isNotBlank((String) paramters.get("orgIds"))) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = paramters.get("orgIds").toString().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				//group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//				paramters.put("saleOperatorIds", salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		String operatorIds = (String)paramters.get("saleOperatorIds");
		String orgIds = (String)paramters.get("orgIds");
		paramters.put("saleOperatorIds", productCommonFacade.setSaleOperatorIds(operatorIds, orgIds, WebUtils.getCurBizId(request)));
		pageBean.setParameter(paramters);
//		pageBean = financeBillService.selectreceiveOrderListSelectPage(pageBean, WebUtils.getCurBizId(request),
//				"", WebUtils.getDataUserIdSet(request));
		pageBean  = bookingSupplierFacade.selectreceiveOrderListSelectPage(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageBean", pageBean);
		
		//Integer bizId = WebUtils.getCurBizId(request);
//		List<DicInfo> billTypeList = dicService.getListByTypeCode(BasicConstants.LD_DJLX, WebUtils.getCurBizId(request));
		List<DicInfo> billTypeList = saleCommonFacade.getCouponListByTypeCode(WebUtils.getCurBizId(request));
		model.addAttribute("billTypeList", billTypeList);
		return "operation/receiveOrderList-table";
	}
	
	@RequestMapping(value = "apply.htm")
	public String apply(HttpServletRequest request, ModelMap model, String groupId, String guideId) {
//		List<FinanceBillDetail> financeBillDetailList = financeBillService.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), groupId, guideId);
		List<FinanceBillDetail> financeBillDetailList = bookingSupplierFacade.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), groupId, guideId);
		if (financeBillDetailList != null && financeBillDetailList.size() > 0) {
			Map financeBillDetail = (Map) financeBillDetailList.get(0);
			model.put("applicant", financeBillDetail.get("applicant"));
			model.put("appliTime", financeBillDetail.get("appli_time"));
			model.put("financeBillDetailList", financeBillDetailList);
		}
		
		//Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = saleCommonFacade.getCouponListByTypeCode(WebUtils.getCurBizId(request));
		model.addAttribute("billTypeList", billTypeList);
		
		return "operation/apply-list";
	}
	
	@RequestMapping(value = "applyPrint.htm")
	public String applyPrint(HttpServletRequest request, ModelMap model, String groupId, String guideId) {
//		List<FinanceBillDetail> financeBillDetailList = financeBillService.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), groupId, guideId);
		BookingSupplierResult result = bookingSupplierFacade.applyPrint(WebUtils.getCurBizId(request), groupId, guideId);
		List<FinanceBillDetail> financeBillDetailList = result.getFinanceBillDetails();
		if (financeBillDetailList != null && financeBillDetailList.size() > 0) {
			Map financeBillDetail = (Map) financeBillDetailList.get(0);
			model.put("applicant", financeBillDetail.get("applicant"));
			model.put("appliTime", financeBillDetail.get("appli_time"));
			model.put("financeBillDetailList", financeBillDetailList);
		}
//		TourGroup tour = tourGroupService.selectByPrimaryKey(Integer.parseInt(groupId));
		model.addAttribute("tour", result.getTourGroup());
		//Integer bizId = WebUtils.getCurBizId(request);
//		List<DicInfo> billTypeList = dicService.getListByTypeCode(BasicConstants.LD_DJLX, WebUtils.getCurBizId(request));
		List<DicInfo> billTypeList = saleCommonFacade.getCouponListByTypeCode(WebUtils.getCurBizId(request));

		model.addAttribute("billTypeList", billTypeList);
		
		return "operation/apply-print";
	}

	
//	private void fillData(List<BookingGroup> bookingGroupList, Integer type) {
//		if (bookingGroupList != null && bookingGroupList.size() > 0) {
//			for (BookingGroup group : bookingGroupList) {
//				if (group.getProductBrandName() != null) {
//					group.setProductName("【" + group.getProductBrandName() + "】" + group.getProductName());
//				}
//				//填充定制团的组团社名称
//				if (group.getSupplierId() != null) {
//					SupplierInfo supplierInfo = supplierSerivce.selectBySupplierId(group.getSupplierId());
//					if (supplierInfo != null) {
//						group.setSupplierName(supplierInfo.getNameFull());
//					}
//					//此处填充订单数和金额
//				} 
//				/*int count = bookingSupplierService.getBookingCountByGroupIdAndSupplierType(group.getGroupId(),type);
//				group.setCount(count);
//				BigDecimal priceSum = bookingSupplierService.getBookingPriceSumByGroupIdAndSupplierType(group.getGroupId(),type);
//				group.setPrice(priceSum);
//				group.setSupplierType(type);*/
//				
//			}
//		}
//	}

	/**
	 * 针对订单和订单详情一对多的对象
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @param supplierType
	 * @return
	 */
	
	@RequestMapping("hotelBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_HOTEL)
	public String hotelBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		
		bookingInfo(model, groupId, Constants.HOTEL);
		// 酒店星级
//		List<DicInfo> jdxjList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		List<DicInfo> jdxjList = saleCommonFacade.getHotelLevelListByTypeCode();
		model.addAttribute("jdxjList", jdxjList);
		return "operation/supplier/hotel/hotel-list-booking";
		
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupHotelBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupHotelBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		
		bookingInfo(model, groupId, Constants.HOTEL);
		// 酒店星级
//		List<DicInfo> jdxjList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		List<DicInfo> jdxjList = saleCommonFacade.getHotelLevelListByTypeCode();

		model.addAttribute("jdxjList", jdxjList);
		model.addAttribute("groupId", groupId);
		return "operation/supplier/hotel/group-hotel-list-booking";
		
	}

	/**
	 * 某个团的酒店计调订单预览
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupHotelDetailPreview.htm")
	public String groupHotelDetailPreview(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		Map paramMap = new HashMap();
		paramMap.put("set", WebUtils.getDataUserIdSet(request));
		paramMap.put("bizId", WebUtils.getCurBizId(request));
		paramMap.put("groupId", groupId);
//		List<Map<String, Object>> groupHotelBookings = tourGroupService.getGroupHotelBooking(paramMap);
//		List<BookingSupplier> bookingSuppliers = new ArrayList<BookingSupplier>();
//		
//		for (Map<String, Object> map : groupHotelBookings) {
//			BookingSupplier bSupplier = new BookingSupplier();
//			bSupplier.setSupplierName(map.get("supplierName") == null ? "" : map.get("supplierName").toString());
//			bSupplier.setRemark(map.get("remark") == null ? "" : map.get("remark").toString());
//			List<BookingSupplierDetail> bookingDetails = detailService.selectByPrimaryBookId((Integer) map.get("bookingId"));
//			bSupplier.setDetailList(bookingDetails);
//			bookingSuppliers.add(bSupplier);
//		}
		BookingSupplierResult result = bookingSupplierFacade.groupHotelDetailPreview(paramMap);
		model.addAttribute("bookingList", result.getBookingSuppliers());
		if (!CollectionUtils.isEmpty(result.getMapList())) {
			
			model.addAttribute("groupInfo", result.getMapList().get(0));
		}
		
		model.addAttribute("groupId", groupId);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("printTime", new Date());
		
		return "operation/supplier/hotel/group-hotel-detail-preview";
		
	}

	@RequestMapping("eatBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_RESTANRANT)
	public String eatBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.RESTAURANT);
		return "operation/supplier/eat/eat-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupEatBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupEatBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.RESTAURANT);
		return "operation/supplier/eat/group-eat-list-booking";
	}
	
	@RequestMapping("funBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_ENTERAINMENT)
	public String funBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.ENTERTAINMENT);
		return "operation/supplier/fun/fun-list-booking";
	}
	
	@RequestMapping("GolfBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GOLF)
	public String GolfBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.GOLF);
		return "operation/supplier/golf/golf-list-booking";
	}

	@RequestMapping("sightBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_SCENIC)
	public String sightBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.SCENICSPOT);
		return "operation/supplier/sight/sight-list-booking";
		
	}

	/**
	 * 给预定安排用
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupSightBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupSightBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.SCENICSPOT);
		return "operation/supplier/sight/group-sight-list-booking";
	}
	
	@RequestMapping("airTicketBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_AIRTICKET)
	public String airTicketBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.AIRTICKETAGENT);
		return "operation/supplier/airTicket/airTicket-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupAirTicketBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupAirTicketBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.AIRTICKETAGENT);
		return "operation/supplier/airTicket/group-airTicket-list-booking";
	}
	
	@RequestMapping("trainTicketBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_TRAIN)
	public String trainTicketBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.TRAINTICKETAGENT);
		return "operation/supplier/trainTicket/trainTicket-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupTrainTicketBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupTrainTicketBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.TRAINTICKETAGENT);
		return "operation/supplier/trainTicket/group-trainTicket-list-booking";
	}
	
	@RequestMapping("insuranceBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_INSURANCE)
	public String insuranceBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.INSURANCE);
		return "operation/supplier/insurance/insurance-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupInsuranceBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupInsuranceBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo(model, groupId, Constants.INSURANCE);
		return "operation/supplier/insurance/group-insurance-list-booking";
	}
	
	@RequestMapping("incomeBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_INCOME)
	public String incomeBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo2(model, groupId, Constants.OTHERINCOME);
		return "operation/supplier/income/income-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupIncomeBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupIncomeBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo2(model, groupId, Constants.OTHERINCOME);
		return "operation/supplier/income/group-income-list-booking";
	}
	
	@RequestMapping("outcomeBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_OUTCOME)
	public String outcomeBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo2(model, groupId, Constants.OTHEROUTCOME);
		return "operation/supplier/outcome/outcome-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupOutcomeBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupOutcomeBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo2(model, groupId, Constants.OTHEROUTCOME);
		return "operation/supplier/outcome/group-outcome-list-booking";
	}


	private void bookingInfo(ModelMap model, Integer groupId,
	                         Integer supplierType) {
//		Map<String, Object> data = bookingSupplierService.selectBookingInfo(groupId, supplierType);
		BookingSupplierResult result = bookingSupplierFacade.getBookingInfo(groupId, supplierType);
		model.addAttribute("groupCanEdit", result.isGroupAbleEdit());
		model.addAttribute("groupId", groupId);
		model.addAttribute("bookingInfo", result.getMapList().get(0));
	}

	/**
	 * 针对订单和订单详情一对一的对象：订车、支出、收入
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @param supplierType
	 * @return
	 */
	@RequestMapping("carBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_CAR)
	public String bookingInf(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo2(model, groupId, Constants.FLEET);
		// 车辆型号
//		List<DicInfo> ftcList = dicService
//				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		List<DicInfo> ftcList = saleCommonFacade.getCarListByTypeCode();
		model.addAttribute("ftcList", ftcList);
		return "operation/supplier/car/car-list-booking";
	}
	
	/**
	 * 计调管理-预定安排
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping("groupCarBookingInfo.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupCarBookingInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId) {
		bookingInfo2(model, groupId, Constants.FLEET);
		// 车辆型号
//		List<DicInfo> ftcList = dicService
//				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		List<DicInfo> ftcList = saleCommonFacade.getCarListByTypeCode();

		model.addAttribute("ftcList", ftcList);
		return "operation/supplier/car/group-car-list-booking";
	}
	
	
	private void bookingInfo2(ModelMap model, Integer groupId,
	                          Integer supplierType) {
//		Map<String, Object> datas = bookingSupplierService.selectBookingInfoPO(groupId, supplierType);
		BookingSupplierResult result = bookingSupplierFacade.getMoreBookingInfo(groupId, supplierType);
		model.addAttribute("groupCanEdit", result.isGroupAbleEdit());
		model.addAttribute("groupId", groupId);
		model.addAttribute("supplierType", supplierType);
		model.addAttribute("bookingInfo", result.getMapList().get(0));
	}

	/**
	 * 订车通知单预览
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @param supplierType
	 * @return
	 */
	@RequestMapping("toCarPreview.htm")
	public String toCarPreview(HttpServletRequest request, HttpServletResponse response, ModelMap model,
	                           Integer groupId) {
		
		// 车辆型号
//		List<DicInfo> ftcList = dicService
//				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		List<DicInfo> ftcList = saleCommonFacade.getCarListByTypeCode();

		model.addAttribute("ftcList", ftcList);
		BookingSupplierResult result = bookingSupplierFacade.toCarPreview(groupId, 4);
//		List<GroupRequirement> carList = groupRequirementService.selectByGroupIdAndType(groupId, 4);
		model.addAttribute("carList", result.getGroupRequirements());
		
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		//该团行程信息
//		GroupRouteVO vo = groupRouteService.findGroupRouteByGroupId(groupId);
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId);
		/**
		 * 发件方信息 --当前登陆人信息
		 */
		PlatformEmployeePo employee = sysPlatformEmployeeFacade.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();
		model.addAttribute("user_tel", employee.getMobile());
		
		//团操作计调
		TourGroup tg = result.getTourGroup();
		PlatformEmployeePo ee = sysPlatformEmployeeFacade.findByEmployeeId(tg.getOperatorId()).getPlatformEmployeePo();
		model.addAttribute("company", sysPlatformOrgFacade.findByOrgId(ee.getOrgId()).getPlatformOrgPo().getName()); // 当前单位
		model.addAttribute("user_name", ee.getName());
		model.addAttribute("user_fax", ee.getFax());
		GroupRouteVO vo = result.getRouteVO();
		List<GroupRouteDayVO> routeList = vo.getGroupRouteDayVOList();
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("routeList", routeList);
		model.addAttribute("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupCode", tg.getGroupCode());
		model.addAttribute("totalPersons", tg.getTotalAdult() + tg.getTotalChild() + tg.getTotalGuide());
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
		List<BookingGuide> guides = result.getbGuides();
		String guideString = "";
		if (guides.size() > 0) {
			guideString = getGuides(guides);
		}
		model.addAttribute("guideString", guideString);
//		List<BookingSupplierDetail> details = detailService.selectBookingSupplierDetailByGroupId(groupId);
		model.addAttribute("details", result.getDetailList());
		return "operation/supplier/car/group_car_preview";
	}
	
	@RequestMapping("toExport.do")
	public void toExport(Integer groupId,
	                     HttpServletRequest request, HttpServletResponse response) {
		try {
			// 处理中文文件名下载乱码
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		String path = "";
		String fileName = "";
		try {
			fileName = new String("订车通知单.doc".getBytes("UTF-8"),
					"iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		path = toCarExport(request, groupId);
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
	
	public String toCarExport(HttpServletRequest request, Integer groupId) {
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".docx";
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/carNotify.docx");
		WordReporter export = new WordReporter(realPath);

		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
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
		BookingSupplierResult result = bookingSupplierFacade.toCarPreview(groupId, 4);
		List<GroupRouteDayVO> routes = null;
		//该团行程信息
//		GroupRouteVO vo = groupRouteService.findGroupRouteByGroupId(groupId);
//		TourGroup group = tourGroupService.selectByPrimaryKey(groupId);
		GroupRouteVO vo = result.getRouteVO();
		if (null != vo) {
			routes = vo.getGroupRouteDayVOList();
		}
		Map<String, Object> map0 = new HashMap<String, Object>();
		TourGroup group = result.getTourGroup();
		// 当前登陆人
		PlatformEmployeePo employee = sysPlatformEmployeeFacade.findByEmployeeId(WebUtils.getCurUserId(request)).getPlatformEmployeePo();
		//团操作计调
		PlatformEmployeePo ee = sysPlatformEmployeeFacade.findByEmployeeId(group.getOperatorId()).getPlatformEmployeePo();
		map0.put("company", sysPlatformOrgFacade.findByOrgId(ee.getOrgId()).getPlatformOrgPo().getName()); // 当前单位
		map0.put("user_name", ee.getName());
		map0.put("user_fax", ee.getFax());
		
		params1.put("user_tel", employee.getMobile());
//		List<BookingGuide> guides = bookingGuideService
//				.selectGuidesByGroupId(groupId);
		List<BookingGuide> guides = result.getbGuides();
		String guideString = "";
		if (guides.size() > 0) {
			guideString = getGuides(guides);
		}
		map0.put("guideString", guideString);
		if (group != null) {
			map0.put("groupCode", group.getGroupCode());
			map0.put("totalPersons", group.getTotalAdult() + group.getTotalChild() + group.getTotalChild() + "");
		}
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		for (GroupRouteDayVO vvo : routes) {
			Map<String, String> map = new HashMap<String, String>();
			if (null != vvo.getGroupRoute().getGroupDate()) {
				map.put("day_num", com.yihg.erp.utils.DateUtils.format(vvo.getGroupRoute().getGroupDate()));
			} else {
				map.put("day_num", "");
			}
			map.put("route_desp", vvo.getGroupRoute().getRouteDesp());
			map.put("breakfast", vvo.getGroupRoute().getBreakfast());
			map.put("lunch", vvo.getGroupRoute().getLunch());
			map.put("supper", vvo.getGroupRoute().getSupper());
			map.put("hotel_name", vvo.getGroupRoute().getHotelName());
			routeList.add(map);
		}

		// 车辆型号
//		List<DicInfo> ftcList = dicService
//				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		List<DicInfo> ftcList = saleCommonFacade.getCarListByTypeCode();
//		List<GroupRequirement> cars = groupRequirementService.selectByGroupIdAndType(groupId, 4);
		List<Map<String, String>> carList = new ArrayList<Map<String, String>>();
		List<GroupRequirement> cars = result.getGroupRequirements();
		for (GroupRequirement gr : cars) {
			Map<String, String> map = new HashMap<String, String>();
			for (DicInfo dicInfo : ftcList) {
				if (dicInfo.getId() == Integer.parseInt(gr.getModelNum())) {
					map.put("carType", dicInfo.getValue());
				}
			}
			if (null == map.get("carType")) {
				map.put("carType", "");
			}
			map.put("seatCount", gr.getCountSeat() + "");
			map.put("startTime", gr.getRequireDate());
			map.put("endTime", gr.getRequireDateTo());
			map.put("carRemark", gr.getRemark());
			carList.add(map);
		}
//		List<BookingSupplierDetail> details = detailService.selectBookingSupplierDetailByGroupId(groupId);
		List<BookingSupplierDetail> details = result.getDetailList();
		List<Map<String, String>> detailsCar = new ArrayList<Map<String, String>>();
		for (BookingSupplierDetail bookingSupplierDetail : details) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("supplierName", bookingSupplierDetail.getSupplierName());
			map.put("type2Name", bookingSupplierDetail.getType2Name());
			map.put("itemDate", com.yihg.erp.utils.DateUtils.format(bookingSupplierDetail.getItemDate()));
			map.put("itemDateTo", com.yihg.erp.utils.DateUtils.format(bookingSupplierDetail.getItemDateTo()));
			map.put("type1Name", bookingSupplierDetail.getType1Name());
			map.put("carLisence", bookingSupplierDetail.getCarLisence());
			map.put("driverNameAndDriverTel", bookingSupplierDetail.getDriverName() + " " + bookingSupplierDetail.getDriverTel());
			map.put("itemPrice", NumberUtil.formatDouble(bookingSupplierDetail.getItemPrice()));
			detailsCar.add(map);
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(routeList, 1);
			export.export(carList, 2);
			export.export(detailsCar, 3);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 将需求订单表格加载到新增供应商页面
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param groupId
	 * @param supplierType
	 * @return
	 */
	@RequestMapping("bookingReq.htm")
	public String bookingReq(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer supplierType) {
		
//		Map<String, Object> datas = bookingSupplierService.selectBookingInfo(groupId, supplierType);
//		List<BookingSupplier> list = (List<BookingSupplier>) datas.get("bookingList");
//		List<GroupRequirement> list2 = (List<GroupRequirement>) datas.get("requirementInfos");
//		if (list2 != null && list2.size() > 0) {
//			
//			for (GroupRequirement req : list2) {
//				GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(req.getOrderId());
//				if (groupOrder != null) {
//					req.setNameFull(groupOrder.getOrderType() == 1 ? groupOrder.getSupplierName() : "散客团");
//					req.setReceiveMode(groupOrder.getReceiveMode() != null ? groupOrder.getReceiveMode() : "");
//				} else {
//					req.setNameFull("");
//					req.setReceiveMode("");
//					
//				}
//				
//			}
//			
//		}
		Map<String, Object> datas = bookingSupplierFacade.bookingInfoDetail(groupId, supplierType);
		model.addAttribute("bookingInfo", datas);
		
		if (supplierType != null && supplierType == 3) {
			// 酒店星级
//			List<DicInfo> jdxjList = dicService
//					.getListByTypeCode(BasicConstants.GYXX_JDXJ);
			List<DicInfo> jdxjList = saleCommonFacade.getHotelLevelListByTypeCode();
			model.addAttribute("jdxjList", jdxjList);
			return "operation/supplier/hotel/hotel-requirement";
		} else if (supplierType != null && supplierType == 2) {
			return "operation/supplier/eat/eat-requirement";
		} else if (supplierType != null && supplierType == 8) {
			return "operation/guide/guide-requirement";
		} else if (supplierType != null && supplierType == 9) {
			return "operation/supplier/airTicket/airTicket-requirement";
		} else if (supplierType != null && supplierType == 10) {
			return "operation/supplier/trainTicket/trainTicket-requirement";
		}

		return "";
	}

	@RequestMapping("bookingReq2.htm")
	public String bookingReq2(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer supplierType) {
		
//		Map<String, Object> datas = bookingSupplierService.selectBookingInfoPO(groupId, supplierType);
		Map<String, Object> datas = bookingSupplierFacade.moreBookingInfoDetail(groupId, supplierType);
		//List<BookingSupplierPO> list = (List<BookingSupplierPO>) datas.get("bookingList");
		
		//List<GroupRequirement> list2 = (List<GroupRequirement>) datas.get("requirementInfos");
		/*if (list!=null && list.size()>0) {
			for (BookingSupplierPO po:list) {
				if (list2!=null && list2.size()>0) {
					SupplierInfo supplierInfo = supplierSerivce
							.selectBySupplierId(po.getSupplierId());
					
					for (GroupRequirement groupReq : list2) {
						groupReq.setNameFull(supplierInfo.getNameFull());
					}
				}
			}
		}*/
		// 车辆型号
//		List<DicInfo> ftcList = dicService
//				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		List<DicInfo> ftcList = saleCommonFacade.getCarListByTypeCode();
		model.addAttribute("ftcList", ftcList);
		model.addAttribute("bookingInfo", datas);
		
		
		if (supplierType != null && supplierType == 4) {
			return "operation/supplier/car/car-requirement";
		}
		
		
		return "";
	}

	@RequestMapping("toAddHotel")
	//@RequiresPermissions(PermissionConstants.JDGL_HOTEL)
	public String toAddBookHotel(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId, Integer editType) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.HOTEL);
		//酒店类型
//		List<DicInfo> hotelType1 = dicService.getListByTypeCode(Constants.HOTEL_TYPE_CODE_1);
		List<DicInfo> hotelType1 = saleCommonFacade.getHotelTypeListByTypeCode();
		model.addAttribute("hotelType1", hotelType1);
		model.addAttribute("editType", editType);
		
		
		return "operation/supplier/hotel/hotel-add";
	}
	
	@RequestMapping("toAddCar")
	//@RequiresPermissions(PermissionConstants.JDGL_CAR)
	public String toAddBookCar(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.FLEET);
		//车型
//		List<DicInfo> CarTypes = dicService.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		List<DicInfo> CarTypes = saleCommonFacade.getCarListByTypeCode();
		model.addAttribute("carTypes", CarTypes);
		
		
		return "operation/supplier/car/car-add";
	}

	@RequestMapping("toAddFun")
	//@RequiresPermissions(PermissionConstants.JDGL_ENTERAINMENT)
	public String toAddBookFun(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.ENTERTAINMENT);
		//娱乐类型
//		List<DicInfo> funTypes = dicService.getListByTypeCode(Constants.ENTERTAINMENT_TYPE_CODE);
		List<DicInfo> funTypes = saleCommonFacade.getEntainmentListByTypeCode();
		model.addAttribute("funTypes", funTypes);
		
		
		return "operation/supplier/fun/fun-add";
	}

	@RequestMapping("toAddGolf")
	//@RequiresPermissions(PermissionConstants.JDGL_GOLF)
	public String toAddBookGolf(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.GOLF);
		//高尔夫类型
//		List<DicInfo> golfTypes = dicService.getListByTypeCode(Constants.GOLF_TYPE_CODE);
		List<DicInfo> golfTypes = saleCommonFacade.getGolfListByTypeCode();
		model.addAttribute("golfTypes", golfTypes);
		
		
		return "operation/supplier/golf/golf-add";
	}

	@RequestMapping("toAddSight")
	//@RequiresPermissions(PermissionConstants.JDGL_SCENIC)
	public String toAddBookSight(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.SCENICSPOT);
		//景区类型
		//List<DicInfo> sightTypes = dicService.getListByTypeCode(Constants.SCENICSPOT_TYPE_CODE);
		//model.addAttribute("sightTypes", sightTypes);
		
		
		return "operation/supplier/sight/sight-add";
	}

	@RequestMapping("toAddAirTicket")
	//@RequiresPermissions(PermissionConstants.JDGL_AIRTICKET)
	public String toAddBookAirTicket(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId, String orderId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.AIRTICKETAGENT);
		//机票
//		List<DicInfo> airTypes = dicService.getListByTypeCode(Constants.GYS_JP_LB);
		List<DicInfo> airTypes = saleCommonFacade.getAirTicketTypesByTypeCode();
		model.addAttribute("airTypes", airTypes);
		try {
			Integer intOrderId = Integer.parseInt(orderId);
			model.addAttribute("orderId", intOrderId);
		} catch (Exception e) {
			// do not put orderId
		}
		return "operation/supplier/airTicket/airTicket-add";
	}

	@RequestMapping("toAddTrainTicket")
	//@RequiresPermissions(PermissionConstants.JDGL_TRAIN)
	public String toAddBookTicket(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.TRAINTICKETAGENT);
		//火车票
//		List<DicInfo> trainTypes = dicService.getListByTypeCode(Constants.GYS_HCP_LB);
		List<DicInfo> trainTypes =saleCommonFacade.getTrainTicketTypesByTypeCode();
		model.addAttribute("trainTypes", trainTypes);
		
		
		return "operation/supplier/trainTicket/trainTicket-add";
	}

	@RequestMapping("toAddInsurance")
	//@RequiresPermissions(PermissionConstants.JDGL_INSURANCE)
	public String toAddBookInsurance(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.INSURANCE);
		//保险
//		List<DicInfo> insuranceTypes = dicService.getListByTypeCode(Constants.GYS_BX_XM);
		List<DicInfo> insuranceTypes = saleCommonFacade.getInsuranceItemsByTypeCode();
		model.addAttribute("insuranceTypes", insuranceTypes);
		
		
		return "operation/supplier/insurance/insurance-add";
	}

	@RequestMapping("toAddGuide")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toAddBookGuide(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.GUIDE);
		//导游
//		List<DicInfo> guideTypes = dicService.getListByTypeCode(Constants.GUIDE_TYPE_CODE);
		List<DicInfo> guideTypes = saleCommonFacade.getGuideListByTypeCode();
		model.addAttribute("guideTypes", guideTypes);
		
		
		return "operation/guide/edit-guide";
	}

	@RequestMapping("toAddEat")
	//@RequiresPermissions(PermissionConstants.JDGL_RESTANRANT)
	public String toAddBookEat(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.RESTAURANT);
		//餐厅
//		List<DicInfo> resTypes = dicService.getListByTypeCode(Constants.RESTAURANT_TYPE_CODE);
		List<DicInfo> resTypes = saleCommonFacade.getEatListByTypeCode();
		model.addAttribute("resTypes", resTypes);
		
		
		return "operation/supplier/eat/eat-add";
	}

	@RequestMapping("/hotelList.do")
	@RequiresPermissions(PermissionConstants.JDGL_HOTEL)
	public String hotelList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryHotelSupplierList(request, response, model, group, Constants.HOTEL);
		
	}
	
	private String queryHotelSupplierList(HttpServletRequest request,
	                                      HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                      Integer hotel) {
		
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
		
		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
		}*/
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//酒店				
//		pageBean = tourGroupService.getHotelGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		pageBean = bookingSupplierFacade.getHotelGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		List result = pageBean.getResult();
		if (result != null && result.size() > 0) {
			for (Object object : result) {
				List<BookingGuide> guideList = new ArrayList<BookingGuide>();
				BookingGroup bGroup = (BookingGroup) object;
				BookingGuide bGuide = new BookingGuide();
				//获取查询得到的导游id数组
				String[] guideIdArr = bGroup.getGuideIdArr();
				if (guideIdArr != null) {
					for (String ids : guideIdArr) {
						bGuide.setGuideId(Integer.parseInt(ids));
					}
				}
				//获取查询得到的导游name数组
				String[] guideNameArr = bGroup.getGuideNameArr();
				if (guideNameArr != null) {
					for (String name : guideNameArr) {
						bGuide.setGuideName(name.replace("-", "<br/>"));
					}
				}
				guideList.add(bGuide);
				bGroup.setGuideList(guideList);
			}
		}
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.HOTEL);
		return "operation/supplier/hotel/supplier-list-table";
	}

	@RequestMapping("/carList.do")
	@RequiresPermissions(PermissionConstants.JDGL_CAR)
	public String carList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryFleetSupplierList(request, response, model, group);
		
	}

	@RequestMapping("/eatList.do")
	@RequiresPermissions(PermissionConstants.JDGL_RESTANRANT)
	public String eatList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryRestaurntSupplierList(request, response, model, group, Constants.RESTAURANT);
		
	}
	
	private String queryRestaurntSupplierList(HttpServletRequest request,
	                                          HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                          Integer restaurant) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
		
		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//餐厅			
//		pageBean = tourGroupService.getRestaurantGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		pageBean = bookingSupplierFacade.getRestaurantGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.RESTAURANT);
		return "operation/supplier/eat/supplier-list-table";
	}

	@RequestMapping("/funList.do")
	@RequiresPermissions(PermissionConstants.JDGL_ENTERAINMENT)
	public String funList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryEntertainmentSupplierList(request, response, model, group, Constants.ENTERTAINMENT);
		
	}
	
	private String queryEntertainmentSupplierList(HttpServletRequest request,
	                                              HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                              Integer entertainment) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
		
		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//娱乐			
		pageBean = bookingSupplierFacade.getEntertaimentGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.ENTERTAINMENT);
		return "operation/supplier/fun/supplier-list-table";
	}

	@RequestMapping("/golfList.do")
	@RequiresPermissions(PermissionConstants.JDGL_GOLF)
	public String golfList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryGolfSupplierList(request, response, model, group, Constants.GOLF);
		
	}
	
	private String queryGolfSupplierList(HttpServletRequest request,
	                                     HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                     Integer golf) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//高尔夫			
		pageBean = bookingSupplierFacade.getGolfGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.GOLF);
		return "operation/supplier/golf/supplier-list-table";
	}

	@RequestMapping("/sightList.do")
	@RequiresPermissions(PermissionConstants.JDGL_SCENIC)
	public String sightList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return querySightSupplierList(request, response, model, group, Constants.SCENICSPOT);
		
	}
	
	private String querySightSupplierList(HttpServletRequest request,
	                                      HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                      Integer scenicspot) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//门票			
		pageBean = bookingSupplierFacade.getSightGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.SCENICSPOT);
		return "operation/supplier/sight/supplier-list-table";
	}

	@RequestMapping("/airTicketList.do")
	@RequiresPermissions(PermissionConstants.JDGL_AIRTICKET)
	public String airTicketList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryAirTicketSupplierList(request, response, model, group, Constants.AIRTICKETAGENT);
		
	}
	
	private String queryAirTicketSupplierList(HttpServletRequest request,
	                                          HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                          Integer airticketagent) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//机票			
		pageBean = bookingSupplierFacade.getAirTicketGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.AIRTICKETAGENT);
		return "operation/supplier/airTicket/supplier-list-table";
	}

	@RequestMapping("/trainTicketList.do")
	@RequiresPermissions(PermissionConstants.JDGL_TRAIN)
	public String trainTicketList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryTrainTicketSupplierList(request, response, model, group, Constants.TRAINTICKETAGENT);
		
	}
	
	private String queryTrainTicketSupplierList(HttpServletRequest request,
	                                            HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                            Integer trainticketagent) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//火车票			
		pageBean = bookingSupplierFacade.getTrainTicketGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.TRAINTICKETAGENT);
		return "operation/supplier/trainTicket/supplier-list-table";
	}

	@RequestMapping("/insuranceList.do")
	@RequiresPermissions(PermissionConstants.JDGL_INSURANCE)
	public String insuranceList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryInsuranceSupplierList(request, response, model, group, Constants.INSURANCE);
		
	}
	
	private String queryInsuranceSupplierList(HttpServletRequest request,
	                                          HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                          Integer insurance) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//保险			
		pageBean = bookingSupplierFacade.getInsuranceGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.INSURANCE);
		return "operation/supplier/insurance/supplier-list-table";
	}

	@RequestMapping("/incomeList.do")
	@RequiresPermissions(PermissionConstants.JDGL_INCOME)
	public String incomeList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryIncomeSupplierList(request, response, model, group, Constants.OTHERINCOME);
		
	}
	
	private String queryIncomeSupplierList(HttpServletRequest request,
	                                       HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                       Integer otherincome) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));

		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//收入		
		pageBean = bookingSupplierFacade.getIncomeGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.OTHERINCOME);
		return "operation/supplier/income/supplier-list-table";
	}

	@RequestMapping("/outcomeList.do")
	@RequiresPermissions(PermissionConstants.JDGL_OUTCOME)
	public String outcomeList2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		return queryOutcomeSupplierList(request, response, model, group, Constants.OTHEROUTCOME);
		
	}
	
	private String queryOutcomeSupplierList(HttpServletRequest request,
	                                        HttpServletResponse response, ModelMap model, TourGroupVO tourGroup,
	                                        Integer otheroutcome) {
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));
		/*if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			
			tourGroup.setSupplierName(tourGroup.getSupplierContent());
							
		}*/
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//支出		
//		pageBean = tourGroupService.getOutcomeGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		pageBean = bookingSupplierFacade.getOutcomeGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.OTHEROUTCOME);
		return "operation/supplier/outcome/supplier-list-table";
	}

	/**
	 * 跳转到供应商编辑或新增页面
	 *
	 * @param model
	 * @param groupId
	 * @param bookingId
	 */
	private void toAddSupplier(ModelMap model, Integer groupId, Integer bookingId, Integer bizId) {
//		if (bookingId != null) {
//			BookingSupplier supplier = bookingSupplierService.selectByPrimaryKey(bookingId);
//			
//			List<BookingSupplierDetail> detailList = detailService.selectByPrimaryBookId(bookingId);
		BookingSupplierResult result = bookingSupplierFacade.toEditSupplier(groupId,  bookingId);
			model.addAttribute("supplier", result.getBookingSupplier());
			model.addAttribute("bookingDetailList", result.getDetailList());
			
			model.addAttribute("bookingId", bookingId);
//			if (supplier.getSupplierType().equals(Constants.SCENICSPOT)) {
//				List<SupplierItem> supplierItems = itemService.findSupplierItemBySupplierId(supplier.getSupplierId());
				model.addAttribute("supplierItems", result.getSupplierItems());
//			}
//		}
		
		model.addAttribute("groupId", groupId);
//		if (groupId != null) {
//			List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
			model.put("bookingGuides",result.getbGuides());
//		}
		
		//从字典中查询结算方式
//		List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		List<DicInfo> cashTypes = saleCommonFacade.getSettleWayListByTypeCode(bizId);
		model.addAttribute("cashTypes", cashTypes);
	}

	/**
	 * 查看供应商信息
	 *
	 * @param model
	 * @param groupId
	 * @param bookingId
	 */
	@RequestMapping("viewSupplier.do")
	public String viewSupplier(ModelMap model, Integer groupId, HttpServletRequest request, Integer supplierId,
	                           Integer bookingId) {
		Integer bizId = WebUtils.getCurBizId(request);
		BookingSupplierResult result = bookingSupplierFacade.viewSupplier(groupId,bookingId);
		BookingSupplier supplier = result.getBookingSupplier();
//		if (bookingId != null) {
//			supplier = bookingSupplierService.selectByPrimaryKey(bookingId);
//			
//			List<BookingSupplierDetail> detailList = detailService.selectByPrimaryBookId(bookingId);
			model.addAttribute("supplier", supplier);
			model.addAttribute("bookingDetailList", result.getDetailList());
			
//		}
		
//		List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
		model.put("bookingGuides", result.getbGuides());
		
		//从字典中查询结算方式
//		List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		List<DicInfo> cashTypes = saleCommonFacade.getSettleWayListByTypeCode(bizId);

		model.addAttribute("groupId", groupId);
		
		model.addAttribute("flag", 1);

		model.addAttribute("cashTypes", cashTypes);
		model.addAttribute("bookingId", bookingId);
		if (supplier != null) {
			if (supplier.getSupplierType() == 2) {
//				List<DicInfo> eatTypes = dicService.getListByTypeCode(Constants.RESTAURANT_TYPE_CODE);
				List<DicInfo> eatTypes = saleCommonFacade.getEatListByTypeCode();
				model.addAttribute("resTypes", eatTypes);
				return "operation/supplier/eat/eat-add";
			} else if (supplier.getSupplierType() == 3) {
//				List<DicInfo> hotelTypes = dicService.getListByTypeCode(Constants.HOTEL_TYPE_CODE_1);
				List<DicInfo> hotelTypes = saleCommonFacade.getHotelTypeListByTypeCode();
				model.addAttribute("hotelType1", hotelTypes);
				return "operation/supplier/hotel/hotel-add";
			} else if (supplier.getSupplierType() == 4) {
				//车型
//				List<DicInfo> CarTypes = dicService.getListByTypeCode(Constants.FLEET_TYPE_CODE);
				List<DicInfo> CarTypes = saleCommonFacade.getCarListByTypeCode();
				model.addAttribute("carTypes", CarTypes);
				return "operation/supplier/car/car-add";
			} else if (supplier.getSupplierType() == 5) {
//				List<SupplierItem> sightTypes = itemService.findSupplierItemBySupplierId(supplier.getSupplierId());
				model.addAttribute("supplierItems", result.getSupplierItems());
				return "operation/supplier/sight/sight-add";
			} else if (supplier.getSupplierType() == 7) {
				List<DicInfo> funTypes = saleCommonFacade.getEntainmentListByTypeCode();
//				List<DicInfo> funTypes = dicService.getListByTypeCode(Constants.ENTERTAINMENT_TYPE_CODE);
				model.addAttribute("funTypes", funTypes);
				return "operation/supplier/fun/fun-add";
			} else if (supplier.getSupplierType() == 8) {
				return "operation/guide/edit-guide";
			} else if (supplier.getSupplierType() == 9) {
				List<DicInfo> airTypes = saleCommonFacade.getAirticketListByTypeCode();
//				List<DicInfo> airTypes = dicService.getListByTypeCode(Constants.AIRTICKET_TYPE_CODE);
				model.addAttribute("airTypes", airTypes);
				return "operation/supplier/airTicket/airTicket-add";
			} else if (supplier.getSupplierType() == 10) {
//				List<DicInfo> trainTypes = dicService.getListByTypeCode(Constants.TRAINTICKET_TYPE_CODE);
				List<DicInfo> trainTypes = saleCommonFacade.getTrainTicketListByTypeCode();
				model.addAttribute("trainTypes", trainTypes);
				return "operation/supplier/trainTicket/trainTicket-add";
			} else if (supplier.getSupplierType() == 11) {
//				List<DicInfo> golfTypes = dicService.getListByTypeCode(Constants.GOLF_TYPE_CODE);
				List<DicInfo> golfTypes = saleCommonFacade.getGolfListByTypeCode();
				model.addAttribute("golfTypes", golfTypes);
				return "operation/supplier/golf/golf-add";
			} else if (supplier.getSupplierType() == 120) {
				List<DicInfo> otherItems = saleCommonFacade.getOtherListByTypeCode();
//				List<DicInfo> otherItems = dicService.getListByTypeCode(Constants.OTHER_TYPE_CODE);
				model.addAttribute("otherItems", otherItems);
				return "operation/supplier/income/income-add";
			} else if (supplier.getSupplierType() == 121) {
				List<DicInfo> otherItems = saleCommonFacade.getOtherListByTypeCode();
//				List<DicInfo> otherItems = dicService.getListByTypeCode(Constants.OTHER_TYPE_CODE);
				model.addAttribute("otherItems", otherItems);
				return "operation/supplier/outcome/outcome-add";
			} else if (supplier.getSupplierType() == 15) {
				List<DicInfo> insuranceTypes = saleCommonFacade.getInsuranceListByTypeCode();
//				List<DicInfo> insuranceTypes = dicService.getListByTypeCode(Constants.INSURANCE_TYPE_CODE);
				model.addAttribute("insuranceTypes", insuranceTypes);
				return "operation/supplier/insurance/insurance-add";
			}
			
		}
		return null;
	}

	private String queryFleetSupplierList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
	                                      TourGroupVO tourGroup) {
		// 根据供应商类型查询当前登录商家所属的供应商
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
		
		if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			/*Pattern pattern = Pattern.compile("^[\u4e00-\u9fa5|WJ]{1}[A-Z0-9]{6}$");
			Matcher matcher = pattern.matcher(tourGroup.getSupplierContent());					
			if(matcher.matches()){*/
			tourGroup.setCarLisence(tourGroup.getSupplierContent());
			/*}
			else {
				tourGroup.setDriverName(tourGroup.getSupplierContent());
			}*/
		}
//		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds()) && StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds = "";
//			for (Integer usrId : set) {
//				salesOperatorIds += usrId + ",";
//			}
//			if (!salesOperatorIds.equals("")) {
//				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
//			}
//		}
		tourGroup.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getSaleOperatorIds(), tourGroup.getOrgIds(), WebUtils.getCurBizId(request)));
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//车队				
//		pageBean = tourGroupService.getFleetGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		bookingSupplierFacade.getFleetGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
		List result = pageBean.getResult();
		if (result != null && result.size() > 0) {
			for (Object object : result) {
				List<BookingGuide> guideList = new ArrayList<BookingGuide>();
				BookingGroup bGroup = (BookingGroup) object;
				BookingGuide bGuide = new BookingGuide();
				//获取查询得到的导游id数组				
				String[] guideIdArr = bGroup.getGuideIdArr();
				if (guideIdArr != null) {
					for (String ids : guideIdArr) {
						bGuide.setGuideId(Integer.parseInt(ids));
					}
				}
				//获取查询得到的导游name数组
				String[] guideNameArr = bGroup.getGuideNameArr();
				if (guideNameArr != null) {
					for (String name : guideNameArr) {
						bGuide.setGuideName(name.replace("-", "<br/>"));
					}
				}
				guideList.add(bGuide);
				bGroup.setGuideList(guideList);
			}
		}
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", Constants.FLEET);
		return "operation/supplier/car/supplier-list-table";
	}
	
	//暂时没用
	private String querySupplierList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
	                                 TourGroupVO tourGroup, Integer supplierType) {
		
		// 根据供应商类型查询当前登录商家所属的供应商
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		PageBean pageBean = new PageBean();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
			
		}
		
		if (StringUtils.isNotBlank(tourGroup.getSupplierContent())) {
			Pattern pattern = Pattern.compile("^[\u4e00-\u9fa5|WJ]{1}[A-Z0-9]{6}$");
			Matcher matcher = pattern.matcher(tourGroup.getSupplierContent());
			if (tourGroup.getSupplierType() == 8) {
				tourGroup.setGuideName(tourGroup.getSupplierContent());
			} else if (tourGroup.getSupplierType() == 4) {
				if (matcher.matches()) {
					tourGroup.setCarLisence(tourGroup.getSupplierContent());
				} else {
					tourGroup.setDriverName(tourGroup.getSupplierContent());
				}
			} else {
				tourGroup.setSupplierName(tourGroup.getSupplierContent());
			}
		}
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		
		//车队
//		if (supplierType.equals(Constants.FLEET)) {
//			pageBean = tourGroupService.getFleetGroupList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
//		} else {
//			pageBean = tourGroupService.getGroupInfoList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request));
//			//	selectGroupListPage(pageBean, WebUtils.getCurBizId(request),);
//			fillData(pageBean.getResult(), supplierType);
//			if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
//				for (BookingGroup bGroup : (List<BookingGroup>) pageBean.getResult()) {
//					
//					List<GroupOrder> gOrders = groupOrderService
//							.selectOrderByGroupId(bGroup.getGroupId());
//					bGroup.setGroupOrderList(gOrders);
//					List<BookingSupplierPO> supplierPOs = bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(bGroup.getGroupId(), supplierType, null, null, null);
//					bGroup.setBookingSuppliers(supplierPOs);
//					
//				}
//			}
//		}
		pageBean = bookingSupplierFacade.querySupplierList(pageBean, tourGroup, WebUtils.getDataUserIdSet(request), supplierType);
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("supplierType", supplierType);
		return "operation/supplier/supplier-list-table";
		
	}

	/**
	 * 保存新增订房单
	 *
	 * @param request
	 * @param reponse
	 * @param booking
	 * @param groupId
	 * @param supplierType
	 * @param supplierId
	 * @return
	 * @throws ParseException s
	 */
	@RequestMapping("saveSupplier.do")
	@ResponseBody
	public String saveBooking(HttpServletRequest request, HttpServletResponse reponse, String bookingJson, String financeGuideJson) {
		BookingSupplier bookingSupplier = JSON.parseObject(bookingJson, BookingSupplier.class);
		
		//如果未并团，则不对团进行校验
//		if (bookingSupplier.getGroupId() != null && bookingSupplier.getGroupId() != 0) {
//			if (!tourGroupService.checkGroupCanEdit(bookingSupplier.getGroupId())) {
//				return errorJson("该团已审核或封存，不允许修改该信息");
//			}
//		}
		
		
		
//		String bookingNo = null;
//		if (bookingSupplier.getId() == null) {
//			int count = bookingSupplierService.getBookingCountByTypeAndTime(bookingSupplier.getSupplierType());
			String code = bizSettingCommon.getMyBizCode(request);
//			bookingNo = code + Constants.SUPPLIERSHORTCODEMAP.get(bookingSupplier.getSupplierType()) + new SimpleDateFormat("yyMMdd").format(new Date()) + (count + 100);
//			bookingSupplier.setCreateTime((new Date()).getTime());
//		}
		//设置预订员
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		bookingSupplier.setUserId(curUser.getEmployeeId());
		bookingSupplier.setUserName(curUser.getName());
		
		
		//产生日志（主表）
		//TODO 待完善
//		List<LogOperator> logList = new ArrayList<LogOperator>();
//		if (bookingSupplier.getId() == null) {
//			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "booking_supplier", bookingSupplier.getId(), 0
//					,String.format("创建酒店订单,商家:%s", bookingSupplier.getSupplierName()), bookingSupplier, null)); 
//		}else{
//			BookingSupplier orginBS = bookingSupplierService.selectByPrimaryKey(bookingSupplier.getId());
//			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(), LOG_ACTION.UPDATE, "booking_supplier", bookingSupplier.getId(), 0
//					,String.format("修改酒店订单,商家:%s", bookingSupplier.getSupplierName()), bookingSupplier, orginBS));
//		}
//		//产生日志 明细表
//		if (bookingSupplier.getId() != null) {
//			for (BookingSupplierDetail detail : bookingSupplier.getDetailList()) {
//				detail.setBookingId(bookingSupplier.getId());
//			}
//			List<BookingSupplierDetail> orginDb = detailService.selectByPrimaryBookId(bookingSupplier.getId());
//			List<LogOperator> tmpList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "booking_supplier_detail", bookingSupplier.getId(), bookingSupplier.getDetailList(), orginDb);
//			logList.addAll(tmpList);
//		}
//		logService.insert(logList);
		
//		int id = bookingSupplierService.save(bookingSupplier, bookingNo);
//		BookingSupplier supplier = bookingSupplierService.selectByPrimaryKey(id);
		FinanceGuide financeGuide = null;
		if (StringUtils.isNotEmpty(financeGuideJson)) {
//			//导游报账
			financeGuide = JSONArray.parseObject(financeGuideJson, FinanceGuide.class);
//			financeGuide.setBookingIdLink(supplier.getId());
//			financeGuide.setSupplierType(supplier.getSupplierType());
//			financeGuide.setGroupId(supplier.getGroupId());
//			financeGuideService.financeSave(financeGuide);
		}
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("bookingId", id);
//		map.put("groupId", bookingSupplier.getGroupId());
//		map.put("stateBooking", supplier.getStateBooking());
		WebResult<Map<String,Object>> result = bookingSupplierFacade.saveBooking(bookingSupplier, financeGuide, code, curUser);
		return result.isSuccess() ? successJson(result.getValue()) : errorJson(result.getResultMsg());
		
	}

	/**
	 * 根据id删除订房单详情表的数据
	 *
	 * @param request
	 * @param reponse
	 * @param detailId
	 * @return
	 */
	@RequestMapping("delDetail.do")
	@ResponseBody
	public String delDetail(HttpServletRequest request, HttpServletResponse reponse, Integer detailId) {
//		BookingSupplierDetail detail = detailService.selectByPrimaryKey(detailId);
//		BookingSupplier bookingSupplier = bookingSupplierService.selectByPrimaryKey(detail.getBookingId());
//		List<BookingSupplierDetail> SupplierDetails = detailService.selectByPrimaryBookId(detail.getBookingId());
//		if (SupplierDetails != null && SupplierDetails.size() > 0) {
//			bookingSupplier.setTotalCash(bookingSupplier.getTotalCash().subtract(new BigDecimal(detail.getItemTotal())));
//			detailService.deleteByPrimaryKey(detailId);
//			bookingSupplierService.updateByPrimaryKeySelective(bookingSupplier);
//		} else {
//			bookingSupplier.setTotal(bookingSupplier.getTotal().subtract(new BigDecimal(1)));
//			bookingSupplier.setTotalCash(bookingSupplier.getTotalCash().subtract(new BigDecimal(detail.getItemTotal())));
//			detailService.deleteByPrimaryKey(detailId);
//			bookingSupplierService.updateByPrimaryKeySelective(bookingSupplier);
//
//		}
		ResultSupport resultSupport = bookingSupplierFacade.delDetail(detailId);
		return successJson();
		
	}

	@RequestMapping("delBookingSupplier.do")
	@ResponseBody
	public String delBookingSupplier(HttpServletRequest request, HttpServletResponse reponse, Integer bookingId) {
		
		try {
//			bookingSupplierService.deleteSupplierWithFinanceByPrimaryKey(bookingId, true);
			ResultSupport resultSupport = bookingSupplierFacade.delBookingSupplier(bookingId, true);
		} catch (ClientException cx) {
			return errorJson(cx.getMessage());
		} catch (Exception ex) {
			return errorJson("删除失败");
		}
		return successJson();
	}
	
	@RequestMapping("editIncome.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_INCOME)
	public String incomeEdit(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId, Integer bookingId) {
		loadInAndOutcomeData(request, model, groupId, bookingId, 1);
		return "operation/supplier/income/income-add";
	}
	
	@RequestMapping("editOutcome.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_OUTCOME)
	public String outcomeEdit(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId, Integer bookingId) {
		loadInAndOutcomeData(request, model, groupId, bookingId, 2);
		return "operation/supplier/outcome/outcome-add";
	}
	
	private void loadInAndOutcomeData(HttpServletRequest request, ModelMap model, Integer groupId, Integer bookingId, Integer subType) {
		BookingSupplier supplier = null;
		List<BookingSupplierDetail> details = null;
		List<DicInfo> cashTypes = null;
		Integer bizId = WebUtils.getCurBizId(request);
		BookingSupplierResult result = null;
		if (bookingId != null) {
			result = bookingSupplierFacade.loadInAndOutcomeData(bookingId, groupId);
			supplier = result.getBookingSupplier();
			details = result.getDetailList();
			
//			supplier = bookingSupplierService.selectByPrimaryKey(bookingId);
//			details = detailService.selectByPrimaryBookId(bookingId);
		} else {
			supplier = new BookingSupplier();
			supplier.setGroupId(groupId);
			supplier.setFinanceTotal(new BigDecimal(0));
			if (subType == 1) {
				supplier.setSupplierType(Constants.OTHERINCOME);
			} else {
				supplier.setSupplierType(Constants.OTHEROUTCOME);
			}
			supplier.setSubType(subType);
			details = new ArrayList<BookingSupplierDetail>();
		}
		if (subType.intValue() == 1) {
//			cashTypes = dicService.getListByTypeCode(BasicConstants.QTSR_JSFS, bizId);
			
		} else {
//			cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		}
		
		model.addAttribute("supplier", supplier);
		model.addAttribute("flag", 0);
		model.addAttribute("groupId", groupId);
		model.addAttribute("bookingDetailList", details);
		
		model.addAttribute("cashTypes", cashTypes);
		List<DicInfo> otherItems = null;
		if (Constants.OTHEROUTCOME.equals(supplier.getSupplierType())) {
//			otherItems = dicService
//					.getListByTypeCode(Constants.OTHER_TYPE_CODE);
			otherItems = saleCommonFacade.getOtherListByTypeCode();
		} else {
//			otherItems = dicService.getListByTypeCode(BasicConstants.GYS_QT_SR);
			otherItems = saleCommonFacade.getIncomeTypeListByTypeCode();
		}
		
//		List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
		List<BookingGuide> bookingGuides = result.getbGuides();
		model.put("bookingGuides", bookingGuides);
		
		model.addAttribute("otherItems", otherItems);
	}

	/**
	 * 点击页面的确认按钮，修改确认状态
	 *
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping("stateConfirm.do")
	@ResponseBody
	public String stateConfirm(HttpServletRequest request, HttpServletResponse reponse, Integer id) {
//		bookingSupplierService.stateConfirm(id);
		ResultSupport resultSupport = bookingSupplierFacade.stateConfirm(id);
		return successJson();
		
	}

	/**
	 * 导出订房单
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @param bookingId
	 * @return
	 */
	@RequestMapping(value = "download.htm")
	public String bookingSupplierExport(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer bookingId) {
		SysBizInfo bizInfo = WebUtils.getCurBizInfo(request);
		PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
//		BookingSupplier supplier = bookingSupplierService.selectByPrimaryKey(bookingId);
		BookingSupplierResult result = bookingSupplierFacade.bookingSupplierExport(bookingId, bizInfo.getId());
		BookingSupplier supplier = result.getBookingSupplier();
		WordReporter exporter = null;
		if (supplier.getSupplierType() == 4) {
			exporter = new WordReporter(request.getSession().getServletContext().getRealPath("/") + "template/booking_fleet.docx");
		} else {
			exporter = new WordReporter(request.getSession().getServletContext().getRealPath("/") + "template/booking_common.docx");
		}
		try {
			exporter.init();
			//旅行社信息
			Map<String, Object> agencyMap = new HashMap<String, Object>();
			Map<String, Object> groupMap = new HashMap<String, Object>();
			Map<String, Object> otherMap = new HashMap<String, Object>();
			List<Map<String, String>> supplierMapList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> routeMapList = new ArrayList<Map<String, String>>();
			Map<String, Object> remarkMap = new HashMap<String, Object>();
			routeMapList = getGroupBookingDetail(request, bookingId, bizInfo,
					userInfo, supplier, agencyMap, groupMap, otherMap,
					supplierMapList, routeMapList, remarkMap, result);
			String p = bizSettingCommon.getMyBizLogo(request);
			if (p != null) {
				Map<String, String> picMap = new HashMap<String, String>();
				picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);//经测试416可以占一行
				picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
				picMap.put("type", "jpg");
				picMap.put("path",
						p);
				otherMap.put("logo", picMap);
			} else {
				otherMap.put("logo", "");
			}
			String url = request.getSession().getServletContext().getRealPath("/") + "download/" + System.currentTimeMillis() + ".doc";
			if (supplier.getSupplierType() == 4) {
				
				exporter.export(otherMap);
				exporter.export(agencyMap, 0);
				exporter.export(groupMap, 1);
				exporter.export(supplierMapList, 2, true);
				exporter.export(routeMapList, 3);
				exporter.export(remarkMap, 4);
				exporter.generate(url);
			} else {
				exporter.export(otherMap);
				exporter.export(agencyMap, 0);
				exporter.export(groupMap, 1);
				exporter.export(supplierMapList, 2, true);
				exporter.export(remarkMap, 3);
				exporter.generate(url);
			}
			//下载
			String path = url;
			String fileName = "";
			
			try {
				fileName = new String("供应商确认单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}// 为了解决中文名称乱码问题
			
			response.setCharacterEncoding("utf-8");
			response.setContentType("application/msword"); // word格式
			try {
				response.setHeader("Cache-Control", "no-cache");
				response.setHeader("Pragma", "no-cache");
				response.setDateHeader("expires", -1);
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
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			new File(url).delete();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 计调订单预览和打印功能公用方法
	 *
	 * @param request
	 * @param bookingId
	 * @param bizInfo
	 * @param userInfo
	 * @param supplier
	 * @param agencyMap
	 * @param groupMap
	 * @param otherMap
	 * @param supplierMapList
	 * @param routeMapList
	 * @param remarkMap
	 * @return
	 */
	private List<Map<String, String>> getGroupBookingDetail(
			HttpServletRequest request, Integer bookingId, SysBizInfo bizInfo,
			PlatformEmployeePo userInfo, BookingSupplier supplier,
			Map<String, Object> agencyMap, Map<String, Object> groupMap,
			Map<String, Object> otherMap,
			List<Map<String, String>> supplierMapList,
			List<Map<String, String>> routeMapList,
			Map<String, Object> remarkMap,BookingSupplierResult result) {
		agencyMap.put("supplier_name", supplier.getSupplierName());
		agencyMap.put("contact", supplier.getContact());
		agencyMap.put("contact_tel", supplier.getContactMobile());
		agencyMap.put("contact_fax", supplier.getContactFax());
		agencyMap.put("company", WebUtils.getCurOrgInfo(request).getName());
		agencyMap.put("user_name", userInfo.getName());
		agencyMap.put("user_tel", userInfo.getMobile());
		agencyMap.put("user_fax", userInfo.getFax());
		//团信息
//		TourGroup groupInfo = tourGroupService.selectByPrimaryKey(supplier.getGroupId());
		TourGroup groupInfo = result.getTourGroup();
		//groupMap.put("company", bizInfo.getName());
		groupMap.put("totaladult", groupInfo.getTotalAdult().toString());
		groupMap.put("totalchild", groupInfo.getTotalChild().toString());
		groupMap.put("groupcode", groupInfo.getGroupCode());
		groupMap.put("totalcg", groupInfo.getTotalGuide().toString());
		//导游
//		BookingGuide guide = guideService.selectByGroupId(supplier.getGroupId());
		BookingGuide guide = result.getbGuides().get(0);
		groupMap.put("guide_name", (guide == null || guide.getGuideName() == null) ? ""
				: guide.getGuideName());
		groupMap.put("guide_tel", (guide == null || guide.getGuideMobile() == null) ? ""
				: guide.getGuideMobile());
		//订单详情
//		List<BookingSupplierDetail> detailList = detailService.selectByPrimaryBookId(bookingId);
		List<BookingSupplierDetail> detailList = result.getDetailList();
		if (detailList != null && detailList.size() > 0) {
			int index = 1;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			for (BookingSupplierDetail detail : detailList) {
				Map<String, String> detailMap = new HashMap<String, String>();
				if (supplier.getSupplierType().equals(Constants.FLEET)) {
					detailMap.put("seq", (index++) + "");
					detailMap.put("car", supplier.getSupplierName());
					if (supplier.getSupplierType() == 4) {
						detailMap
								.put("day",
										(detail.getItemDate() == null ? ""
												: sdf.format(detail
												.getItemDate()))
												+ "~"
												+ (detail.getItemDateTo() == null ? ""
												: sdf.format(detail
												.getItemDateTo())));
					} else {
						detailMap.put("day",
								sdf.format(detail.getItemDate()));
					}
					detailMap.put("type", detail.getType1Name());
					detailMap.put("seat", detail.getType2Name());
					detailMap.put("lisence", detail.getCarLisence());
					detailMap.put("drivername", detail.getDriverName());
					detailMap.put("drivertel", detail.getDriverTel());
					detailMap.put("total_price", detail.getItemTotal().doubleValue() + ""
					);
					supplierMapList.add(detailMap);
				} else {
					detailMap.put("seq", (index++) + "");
					detailMap.put("day", detail.getItemDate() == null ? " " : sdf.format(detail.getItemDate()));
					detailMap.put("type", detail.getType1Name());
					detailMap.put("item_num", detail.getItemNum() + "");
					detailMap.put("num_minus", null == detail.getItemNumMinus() ? 0 + "" : (detail.getItemNumMinus() + ""));
					detailMap.put("unit_price", detail.getItemPrice().doubleValue() + "");
					detailMap.put("total_price", detail.getItemTotal().doubleValue() + "");
					supplierMapList.add(detailMap);
				}
			}
		}
		
		//备注
		remarkMap.put("remark", supplier.getRemark());
		//客人名单
		//酒店
		if (supplier.getSupplierType().equals(Constants.HOTEL)) {
			//团队不输出，散客输出
			if (groupInfo.getGroupMode() == 0) {
//				List<String> hotelList = tourGroupService.selectGroupRequirementByGroupId(supplier.getGroupId(), Constants.HOTEL);
				List<String> hotelList = result.getStrList();
				remarkMap.put("customers", toGetGuestString2(hotelList));
			} else {
				remarkMap.put("customers", "");
			}
		}
		//其他供应商
		else {
			Map parameters = new HashMap();
			parameters.put("groupId", supplier.getGroupId());
			parameters.put("supplierId", supplier.getSupplierId());
			parameters.put("bizId", bizInfo.getId());
//			List<GroupOrderGuest> guests = guestService.getGroupOrderGuests(parameters);
			remarkMap.put("customers",result.getCustomers() );
		}
		//其他logo、打印时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
		otherMap.put("print_time", df.format(new Date()));
		if (supplier.getSupplierType() == 2) {
			otherMap.put("supplierType", "订餐");
		}
		if (supplier.getSupplierType() == 3) {
			otherMap.put("supplierType", "订房");
		}
		if (supplier.getSupplierType() == 4) {
			otherMap.put("supplierType", "订车");
			//行程
			//List<Map<String, String>> routeMapList2=new ArrayList<Map<String,String>>();
			List<GroupRoute> groupRoutes = result.getGroupRoutes();
			routeMapList = getRouteMapList(groupInfo.getId(), groupInfo.getDateStart(), groupRoutes);
			//routeMapList=routeMapList2;
		}
		if (supplier.getSupplierType() == 5) {
			otherMap.put("supplierType", "订票");
		}
		if (supplier.getSupplierType() == 7) {
			otherMap.put("supplierType", "娱乐");
		}
		
		if (supplier.getSupplierType() == 9) {
			otherMap.put("supplierType", "机票");
		}
		if (supplier.getSupplierType() == 10) {
			otherMap.put("supplierType", "火车票");
		}
		if (supplier.getSupplierType() == 11) {
			otherMap.put("supplierType", "高尔夫");
		}
		if (supplier.getSupplierType() == 120) {
			otherMap.put("supplierType", "其他收入");
		}
		if (supplier.getSupplierType() == 121) {
			otherMap.put("supplierType", "其他支出");
		}
		if (supplier.getSupplierType() == 15) {
			otherMap.put("supplierType", "保险");
		}
		return routeMapList;
	}

	/**
	 * 将酒店订单中的订单信息拼成一个字符串
	 *
	 * @param hotelList
	 * @return
	 */
	private String toGetGuestString2(List<String> hotelList) {
		StringBuilder sBuilder = new StringBuilder();
		if (hotelList != null && hotelList.size() > 0) {
			for (String hotelStr : hotelList) {
				sBuilder.append(hotelStr);
				sBuilder.append("\n");
			}
			return sBuilder.toString();
		} else {
			return "";

		}
	}

	public List<Map<String, String>> getRouteMapList(Integer groupId, Date dateStart,List<GroupRoute> routeList) {
		/**
		 * 行程列表
		 */
//		List<GroupRoute> routeList = routeService.selectByGroupId(groupId);
		List<Map<String, String>> routeMapList = new ArrayList<Map<String, String>>();
		if (!CollectionUtils.isEmpty(routeList)) {
			for (GroupRoute route : routeList) {
				Map<String, String> routeMap = new HashMap<String, String>();
				Date date = DateUtils.addDays(dateStart, route.getDayNum() == null ? 0 : (route.getDayNum() - 1));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				routeMap.put("day", sdf.format(date));
				routeMap.put("routedesp", route.getRouteDesp());
				routeMap.put("isbreakfast", route.getBreakfast());
				routeMap.put("islunch", route.getLunch());
				routeMap.put("issupper", route.getSupper());
				routeMap.put("hotelname", route.getHotelName());
				routeMapList.add(routeMap);
			}
		}
		return routeMapList;
	}

	/**
	 * 多个旅客信息拼成一个字符串
	 *
	 * @param guests
	 * @return
	 */
//	private String toGetGuestString(List<GroupOrderGuest> guests) {
//		StringBuilder sb = new StringBuilder();
//		String gender = "男";
//		String certificateName = "身份证";
//		for (GroupOrderGuest guest : guests) {
//			if (guest.getGender() != 1) {
//				gender = "女";
//			}
//			List<DicInfo> certificateTypeList = dicService
//					.getListByTypeCode(BasicConstants.GYXX_ZJLX);
//			for (DicInfo dicInfo : certificateTypeList) {
//				if (dicInfo.getId() == guest.getCertificateTypeId()) {
//					certificateName = dicInfo.getValue();
//				}
//			}
//			sb.append(guest.getName() + " " + gender + "  " + certificateName
//					+ "  " + guest.getCertificateNum() + ";");
//		}
//		return sb.toString();
//	}

	//保存车辆的计调价格
	@RequestMapping(value = "/savePrice.htm")
	@ResponseBody
	public String savePrice(Integer id, BigDecimal price) {
		BookingSupplier bs = new BookingSupplier();
		bs.setId(id);
		bs.setOperatePrice(price);
//		bookingSupplierService.updateByPrimaryKeySelective(bs);
//		bs = bookingSupplierService.selectByPrimaryKey(id);
		bs = bookingSupplierFacade.savePrice(bs);
		Gson gson = new Gson();
		String string = gson.toJson(bs);
		return string;
	}
	
	/***
	 * 批量保存领单明细
	 *
	 * @param request
	 * @param reponse
	 * @param detailListJson
	 * @return
	 */
	@RequestMapping("batchSaveBillDetail.do")
	@ResponseBody
	public String batchSaveBillDetail(HttpServletRequest request, HttpServletResponse reponse, String json) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
		try {
//			financeBillService.batchInsertBillDetail(bizId, userInfo.getName(), json);
			ResultSupport resultSupport = bookingSupplierFacade.batchSaveBillDetail(bizId, userInfo.getName(), json);
			return successJson();
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("操作失败");
		}
	}
	
	@RequestMapping("deleteBill.do")
	@ResponseBody
	public String deleteBill(HttpServletRequest request, HttpServletResponse reponse, Integer groupId, Integer guideId) {
		Integer bizId = WebUtils.getCurBizId(request);
		try {
//			financeBillService.deleteBillOrder(bizId, groupId, guideId);
			ResultSupport resultSupport = bookingSupplierFacade.deleteBill(bizId, guideId, groupId);
			return successJson();
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("操作失败");
		}
	}

	//根据新增时所选商家ID加载该商家项目
	@RequestMapping("selectItems.htm")
	@ResponseBody
	public String selectItems(Integer supplierId) {
//		List<SupplierItem> supplierItems = itemService.findSupplierItemBySupplierId(supplierId);
		List<SupplierItem> supplierItems = bookingSupplierFacade.selectItems(supplierId);
		return JSON.toJSONString(supplierItems, SerializerFeature.WriteNullStringAsEmpty);
		//return null;
		
	}

	@RequestMapping("searchName.htm")
	@ResponseBody
	public String searchName(HttpServletRequest request, HttpServletResponse reponse, String userName) {
		List<PlatformEmployeePo> employee = sysPlatformEmployeeFacade.getEmployeeListByName(WebUtils.getCurBizId(request), userName).getPlatformEmployeePos();
		return JSON.toJSONString(employee);
		
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

	@RequestMapping("selectCashType.htm")
	@ResponseBody
	public String selectCashType(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer supplierId, Integer groupId) {
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		List<SupplierContract> contracts = contractService.getContractsBySupplierIdAndDate(WebUtils.getCurBizId(request), supplierId, tourGroup.getDateStart());
		List<SupplierContract> contracts = bookingSupplierFacade.selectCashType(WebUtils.getCurBizId(request), supplierId, groupId);
		Map<String, Object> map = new HashMap<String, Object>();
		if (!CollectionUtils.isEmpty(contracts)) {
			
			map.put("cashTypeId", contracts.get(0).getSettlementMethod());
		} else {

			map.put("cashTypeId", null);
		}
		return successJson(map);
		
	}

	@RequestMapping("bookingDetailPreview.htm")
	public String bookingDetailPreview(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer bookingId) {
		SysBizInfo bizInfo = WebUtils.getCurBizInfo(request);
		PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
//		BookingSupplier supplier = bookingSupplierService.selectByPrimaryKey(bookingId);
		BookingSupplierResult result = bookingSupplierFacade.bookingSupplierExport(bookingId, bizInfo.getId());
		BookingSupplier supplier = result.getBookingSupplier();
		Map<String, Object> agencyMap = new HashMap<String, Object>();
		Map<String, Object> groupMap = new HashMap<String, Object>();
		Map<String, Object> otherMap = new HashMap<String, Object>();
		List<Map<String, String>> supplierMapList = new ArrayList<Map<String, String>>();
		List<Map<String, String>> routeMapList = new ArrayList<Map<String, String>>();
		Map<String, Object> remarkMap = new HashMap<String, Object>();
		
		routeMapList = getGroupBookingDetail(request, bookingId, bizInfo, userInfo, supplier, agencyMap, groupMap, otherMap, supplierMapList, routeMapList, remarkMap,result);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("agencyMap", agencyMap);
		model.addAttribute("groupMap", groupMap);
		model.addAttribute("otherMap", otherMap);
		model.addAttribute("remarkMap", remarkMap);
		model.addAttribute("routeMapList", routeMapList);
		model.addAttribute("supplierMapList", supplierMapList);
		model.addAttribute("bookingId", bookingId);

		//model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		
		if (supplier.getSupplierType() == 4) {
			return "operation/supplier/car/fleetDetailPreview";
		} else {
			return "operation/supplier/bookingDetailPreview";
		}
		//return "operation/supplier/bookingDetailPreview";
		
	}

	@RequestMapping("exportExcel.do")
	public void exportExcel(HttpServletRequest request, HttpServletResponse response, Integer groupId) {
		Map paramMap = new HashMap();
		paramMap.put("set", WebUtils.getDataUserIdSet(request));
		paramMap.put("bizId", WebUtils.getCurBizId(request));
		paramMap.put("groupId", groupId);
//		List<Map<String, Object>> groupHotelBookings = tourGroupService.getGroupHotelBooking(paramMap);
//		List<BookingSupplier> bookingSuppliers = new ArrayList<BookingSupplier>();
//
//		for (Map<String, Object> map : groupHotelBookings) {
//			BookingSupplier bSupplier = new BookingSupplier();
//			bSupplier.setSupplierName(map.get("supplierName") == null ? "" : map.get("supplierName").toString());
//			bSupplier.setRemark(map.get("remark") == null ? "" : map.get("remark").toString());
//			List<BookingSupplierDetail> bookingDetails = detailService.selectByPrimaryBookId((Integer) map.get("bookingId"));
//			bSupplier.setDetailList(bookingDetails);
//			bookingSuppliers.add(bSupplier);
//		}
		BookingSupplierResult result = bookingSupplierFacade.exportBookingHotel(paramMap);
		List<Map<String, Object>> groupHotelBookings = result.getMapList();
		List<BookingSupplier> bookingSuppliers = result.getBookingSuppliers();
		
		String path = "";
//		BigDecimal total = new BigDecimal(0);
//		BigDecimal totalNum = new BigDecimal(0);
//		BigDecimal totalNumMinus = new BigDecimal(0);
		double total = 0;
		double totalNum = 0;
		double totalNumMinus = 0;
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/group_booking.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			//CellRangeAddress cRangeAddress=null;
			int index = 0;
			int createRow = 5;
			int size = 0;
//			cRangeAddress=new CellRangeAddress(2, 3, 1, 3);
//			sheet.addMergedRegion(cRangeAddress);
//			row=sheet.getRow(2);
//			cc=row.createCell(1);
//			cc.setCellValue(groupHotelBookings.get(0).get("groupCode").toString());
//			cc.setCellStyle(cellStyle);
//			cRangeAddress=new CellRangeAddress(2, 3, 5,8 );
//			sheet.addMergedRegion(cRangeAddress);
//			row=sheet.getRow(2);
//			cc=row.createCell(3);
//			cc.setCellValue(groupHotelBookings.get(0).get("totalAdult").toString()+"大"+groupHotelBookings.get(0).get("totalChild").toString()+"小");
//			cc.setCellStyle(cellStyle);

//			Iterator<Cell> cellIterator = row.cellIterator();
//			while(cellIterator.hasNext()){
//				System.out.println(cellIterator.next().getStringCellValue());
//			}
			
			row = sheet.createRow(index + 2);
			cc = row.createCell(0);
			cc.setCellValue("团号");
			cc.setCellStyle(cellStyle);
			sheet.addMergedRegion(new CellRangeAddress(2, 2, 1, 3));
//			cc = row.createCell(1);
//			cc.setCellStyle(cellStyle);
			cc = row.createCell(1);
			cc.setCellValue(groupHotelBookings.get(0).get("groupCode").toString());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(2);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(3);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(4);
			cc.setCellValue("人数");
			cc.setCellStyle(cellStyle);
//			cc = row.createCell(5);
//			cc.setCellStyle(cellStyle);
			sheet.addMergedRegion(new CellRangeAddress(2, 2, 5, 8));
			cc = row.createCell(5);
			cc.setCellValue(groupHotelBookings.get(0).get("totalAdult").toString() + "大" + groupHotelBookings.get(0).get("totalChild").toString() + "小");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(6);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(7);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(8);
			cc.setCellStyle(cellStyle);
			
			row = sheet.createRow(index + 3);
			cc = row.createCell(0);
			cc.setCellValue("产品");
			cc.setCellStyle(cellStyle);
//			cc = row.createCell(1);
//			cc.setCellStyle(cellStyle);
			sheet.addMergedRegion(new CellRangeAddress(3, 3, 1, 3));
			cc = row.createCell(1);
			cc.setCellValue(groupHotelBookings.get(0).get("productBrandName").toString() + "-" + groupHotelBookings.get(0).get("productName").toString());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(2);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(3);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(4);
			cc.setCellValue("计调");
			cc.setCellStyle(cellStyle);
//			cc = row.createCell(5);
//			cc.setCellStyle(cellStyle);
			sheet.addMergedRegion(new CellRangeAddress(3, 3, 5, 8));
			cc = row.createCell(5);
			cc.setCellValue(groupHotelBookings.get(0).get("operatorName").toString());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(6);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(7);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(8);
			cc.setCellStyle(cellStyle);
			for (BookingSupplier supplier : bookingSuppliers) {
				if (supplier.getDetailList() == null || supplier.getDetailList().size() == 0) {
					row = sheet.createRow(index + 5);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);
					cc = row.createCell(1);
					cc.setCellValue(supplier.getSupplierName());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(2);
					cc.setCellValue(supplier.getRemark());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(3);
					cc.setCellValue("");
					cc.setCellStyle(styleLeft);
					cc = row.createCell(4);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(5);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(6);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(7);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(8);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					index++;
				} else {
					for (BookingSupplierDetail detail : supplier.getDetailList()) {
						row = sheet.createRow(index + 5);
						cc = row.createCell(0);
						cc.setCellValue(index + 1);
						cc.setCellStyle(cellStyle);
						cc = row.createCell(1);
						cc.setCellValue(supplier.getSupplierName());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(2);
						cc.setCellValue(supplier.getRemark());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(3);
						cc.setCellValue(new SimpleDateFormat("yyyy-MM-dd").format(detail.getItemDate()));
						cc.setCellStyle(styleLeft);
						cc = row.createCell(4);
						cc.setCellValue(detail.getType1Name());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(5);
						cc.setCellValue(detail.getItemPrice().toString());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(6);
						cc.setCellValue(detail.getItemNum().toString());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(7);
						cc.setCellValue(detail.getItemNumMinus().toString());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(8);
//						BigDecimal itemNum = new BigDecimal(0);
//						itemNum = itemNum.add((BigDecimal) );
						cc.setCellValue(detail.getItemTotal().toString());
						cc.setCellStyle(cellStyle);
						index++;
//						total = total.add((BigDecimal) map.get("itemTotal"));
//						totalNum = totalNum.add((BigDecimal) map.get("itemNum"));
//						totalNumMinus = totalNumMinus.add((BigDecimal) map
//								.get("itemNumMinus"));
						total += detail.getItemTotal();
						totalNum += detail.getItemNum();
						totalNumMinus += detail.getItemNumMinus();
					}
					for (int i = 0; i < 9; i++) {
						if (i != 3 && i != 4 && i != 5 && i != 6 && i != 7 && i != 8) {
							sheet.addMergedRegion(new CellRangeAddress(createRow, createRow + supplier.getDetailList().size() - 1, i, i));
							
						}
					}
				}
				createRow += supplier.getDetailList().size();
				size += supplier.getDetailList().size();
			}
			row = sheet.createRow(size + 5); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellValue(String.valueOf(totalNum));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(7);
			cc.setCellValue(String.valueOf(totalNumMinus));
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(String.valueOf(total));
			cc.setCellStyle(styleRight);
			
			CellRangeAddress region = new CellRangeAddress(
					size + 6, size + 6, 0, 8);
			sheet.addMergedRegion(region);
			row = sheet.createRow(size + 6);
			cc = row.createCell(0);
			cc.setCellValue(/*"打印人：" + WebUtils.getCurUser(request).getName()
					+ */" 打印时间："
					+ com.yihg.erp.utils.DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download(path, request, response);
		
	}

	private void download(String path, HttpServletRequest request,
	                      HttpServletResponse response) {
		try {
			// path是指欲下载的文件的路径。
			File file = new File(path);
			// 取得文件名。
			String fileName = "";
			try {
				fileName = new String("计调订房单.xlsx".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

			/*
			 * //解决IE浏览器下下载文件名乱码问题 if
			 * (request.getHeader("USER-AGENT").indexOf("msie") > -1){ fileName
			 * = new URLEncoder().encode(fileName) ; }
			 */
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename="
					+ fileName);
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(
					response.getOutputStream());
			response.setContentType("application/vnd.ms-excel;charset=gb2312");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
			file.delete();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	@RequestMapping(value = "/roomTypeList.do")
	@ResponseBody
	public String findRoomTypeBySupplierId(HttpServletRequest request, Integer supplierId) {
		// 获取当前供应商协议加载配置值
		String bizConfigValue = WebUtils.getBizConfigValue(request, "BOOKING_HOTEL_CONTRACTLODING");

		Integer bizId = WebUtils.getCurBizId(request);
		if ("1".equals(bizConfigValue)) { // 加载协议值为1 使用协议
			// 根据 商家(bizId) 供应商(supplierId) 获得协议信息
//			SupplierContract supplierContract = contractService.getSupplierContractByBizIdAndSupplierId(bizId, supplierId);
			List<SupplierContractPrice> supplierContractPriceList = bookingSupplierFacade.findRoomTypeBySupplierId(bizId, supplierId);
		
				// 根据供应商ID 获得协议
//				List<SupplierContractPrice> supplierContractPriceList = contractService.getContractPriceListByContractId(supplierContract.getId());
				
				Map<String, Object> map = new HashMap<String, Object>();
				if (!CollectionUtils.isEmpty(supplierContractPriceList)) {
					map.put("roomTypeId", supplierContractPriceList);
				} else {
					map.put("roomTypeId", null);
				}
				return successJson(map);
			}
		
		return successJson("");
	}
}
