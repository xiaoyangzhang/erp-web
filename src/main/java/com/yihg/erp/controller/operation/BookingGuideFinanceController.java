package com.yihg.erp.controller.operation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.result.RegionResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingDelivery;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuideListCount;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuideListSelect;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier;
import com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingGuidesVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrintPo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.operation.query.BookingGuideQueryDTO;
import com.yimayhd.erpcenter.facade.operation.result.BookingGuideResult;
import com.yimayhd.erpcenter.facade.operation.result.ResultSupport;
import com.yimayhd.erpcenter.facade.operation.result.WebResult;
import com.yimayhd.erpcenter.facade.operation.service.BookingGuideFacade;
import com.yimayhd.erpcenter.facade.operation.service.BookingGuideFinanceFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.SupplierGuide;
/**
 * @author : xuzejun
 * @date : 2015年7月25日 下午2:31:01
 * @Description: 计调-导游报账单
 */
@Controller
@RequestMapping("/bookingGuideFinance")
public class BookingGuideFinanceController extends BaseController {
	@Autowired
	private SysConfig config;
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private BookingGuideFinanceFacade bookingGuideFinanceFacade;
	@Autowired
	private BookingGuideFacade bookingGuideFacade;
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转导游页面
	 */
	@RequestMapping(value = "/list.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toList(HttpServletRequest request,ModelMap model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "operation/guideFinance/guide-list";
	}
	
	//TourGroup group,
	@RequestMapping(value = "/bookingGuideList.do")
	//@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String bookingGuideList(HttpServletRequest request, ModelMap model,TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if(group.getPage()==null){
			group.setPage(1);
		}
		if(group.getPageSize()==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(group.getPageSize());
		}
		Map paramters = WebUtils.getQueryParamters(request);
//		if(StringUtils.isBlank((String)paramters.get("saleOperatorIds")) && StringUtils.isNotBlank((String)paramters.get("orgIds"))){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = paramters.get("orgIds").toString().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		String operatorIds = (String)paramters.get("saleOperatorIds");
		String orgIds = (String)paramters.get("orgIds");
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(operatorIds, orgIds, WebUtils.getCurBizId(request)));
		group.setSupplierType(Constants.GUIDE);
		group.setBizId(WebUtils.getCurBizId(request));
		
		pageBean.setParameter(group);
		pageBean.setPage(group.getPage());
		
		pageBean = bookingGuideFinanceFacade.getGuideGroupList2(pageBean, group, WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		return "operation/guideFinance/guide-listView";
	}
	
	/**
	 * @author : zhoumi
	 * @date : 2016年9月6日 
	 * @Description: 跳转导游订单审核页面
	 */
	@RequestMapping(value = "/lockList.htm")
	public String lockList(HttpServletRequest request,ModelMap model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "operation/guideFinance/guide-lock-list";
	}
	

	@RequestMapping(value = "/lockListTable.do")
	public String lockListTable(HttpServletRequest request, ModelMap model,TourGroupVO group) {
		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String,Boolean> optMap = user.getOptMap();
		model.addAttribute("optMap_LOCK", optMap.containsKey(PermissionConstants.JDGL_DYJDSH.concat("_").concat(PermissionConstants.JDGL_GUIDE_LOCK)));
		model.addAttribute("optMap_UNLOCK", optMap.containsKey(PermissionConstants.JDGL_DYJDSH.concat("_").concat(PermissionConstants.JDGL_GUIDE_UNLOCK)));
		PageBean pageBean = new PageBean();
		if(group.getPage()==null){
			group.setPage(1);
		}
		if(group.getPageSize()==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(group.getPageSize());
		}
		Map paramters = WebUtils.getQueryParamters(request);
//		if(StringUtils.isBlank((String)paramters.get("saleOperatorIds")) && StringUtils.isNotBlank((String)paramters.get("orgIds"))){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = paramters.get("orgIds").toString().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		String operatorIds = (String)paramters.get("saleOperatorIds");
		String orgIds = (String)paramters.get("orgIds");
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(operatorIds, orgIds, WebUtils.getCurBizId(request)));
		
		group.setSupplierType(Constants.GUIDE);
		group.setBizId(WebUtils.getCurBizId(request));
		
		pageBean.setParameter(group);
		pageBean.setPage(group.getPage());
		
		pageBean = bookingGuideFinanceFacade.getGuideGroupList2(pageBean, group, WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		return "operation/guideFinance/guide-lock-listView";
	}
	
	@RequestMapping(value = "/changeStateLock.do")
	public String changeStateLock(HttpServletRequest request,Integer groupId) {
//		bookingGuideService.updateStateLock(groupId);
		ResultSupport resultSupport = bookingGuideFinanceFacade.changeStateLock(groupId);
		return "operation/guideFinance/guide-lock-list";
	}
	
	@RequestMapping(value = "/changeStateUnlock.do")
	public String changeStateUnlock(HttpServletRequest request,Integer groupId) {
//		bookingGuideService.updateStateUnlock(groupId);
		ResultSupport resultSupport = bookingGuideFinanceFacade.changeStateUnlock(groupId);
		return "operation/guideFinance/guide-lock-list";
	}
	
//	private void fillData(List<BookingGroup> bookingGroupList){
//		if(bookingGroupList!=null&&bookingGroupList.size()>0){
//			for(BookingGroup group : bookingGroupList){
//				if(group.getProductBrandName()!=null){
//					group.setProductName("【"+group.getProductBrandName()+"】"+group.getProductName());
//				}
//				//填充定制团的组团社名称
//				if(group.getSupplierId()!=null){
//					SupplierInfo supplierInfo = supplierSerivce.selectBySupplierId(group.getSupplierId());
//					if(supplierInfo!=null){
//						group.setSupplierName(supplierInfo.getNameFull());
//					}
//				}
//				//TODO:此处填充订单数和金额
//				group.setCount(bookingGuideService.getSelectCountByGruopId(group.getGroupId()));
//				group.setGuideList(bookingGuideService.selectGuidesByGroupId(group.getGroupId()));
//				
//			}
//		}
//	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转导游列表下拉详情
	 */
	@RequestMapping(value = "/guideDetailList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String guideDetailList( ModelMap model,Integer groupId) {
//		TourGroup tg = tourGroupService.selectByPrimaryKey(groupId) ;
		BookingGuideResult result = bookingGuideFinanceFacade.guideDetailList(groupId);
		model.addAttribute("groupMode", result.getTourGroup().getGroupMode());
		model.addAttribute("groupId", groupId);
		//查询需求订单
//		List<GroupRequirement> groupRequirements = groupRequirementService.selectByGroupIdAndType(groupId, Constants.GUIDE);
//		if (groupRequirements!=null && groupRequirements.size()>0) {
//			GroupOrder groupOrder = groupOrderService
//					.selectByPrimaryKey(groupRequirements.get(0).getOrderId());
//			for (GroupRequirement req : groupRequirements) {
//				if (groupOrder!=null) {
//					req.setNameFull(groupOrder.getSupplierName());
//				}
//			}
//		}
//		List<BookingGuidesVO> vo = bookingGuideService.selectBookingGuideVoByGroupId(groupId);
		model.addAttribute("vo", result.getBookingGuidesVOs());
		model.addAttribute("groupRequirements", result.getGroupRequirements());
		return "operation/guideFinance/guide-listViewDetail";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转导游页面
	 */
	@RequestMapping(value = "/guideDetailListView.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String guideDetailListView( ModelMap model,Integer groupId) {
		model.addAttribute("groupId", groupId);
//		List<BookingGuidesVO> vo = bookingGuideService.selectBookingGuideVoByGroupId(groupId);
		List<BookingGuidesVO> guidesVOs = bookingGuideFinanceFacade.guideDetailListView(groupId);
		model.addAttribute("vo", guidesVOs);
		return "operation/guideFinance/guide-detaillistView";
	}
	
	
	@RequestMapping(value = "/toGuideDetailListView.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toGuideDetailListView( ModelMap model,Integer groupId) {
		model.addAttribute("groupId", groupId);
//		List<BookingGuidesVO> vo = bookingGuideService.selectBookingGuideVoByGroupId(groupId);
		List<BookingGuidesVO> guidesVOs = bookingGuideFinanceFacade.guideDetailListView(groupId);

		model.addAttribute("vo", guidesVOs);
		model.addAttribute("view",1);
		return "operation/guideFinance/guide-detaillistView";
	}
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增导游，保存
	 */
	@RequestMapping(value = "/saveGuide.do")
	@ResponseBody
	public String saveGuide(HttpServletRequest request, ModelMap model,BookingGuidesVO guideVO) {
		BookingGuide guide = guideVO.getGuide();
		if(guide.getId()==null){
//			int No = bookingGuideService.getBookingCountByTime();
//			guide.setBookingNo(bizSettingCommon.getMyBizCode(request)+Constants.GUIDE+new SimpleDateFormat("yyMMdd").format(new Date())+(No+100));
			guide.setUserId(WebUtils.getCurUserId(request));
			guide.setUserName(WebUtils.getCurUser(request).getName());
			guide.setCreateTime(System.currentTimeMillis());
			guide.setBookingDate(new Date());
			guide.setIsDefault((byte)0);
		}
//		return bookingGuideService.insertSelective(guideVO)>0?successJson("id",guide.getGroupId()+""):errorJson("操作失败！");
		WebResult<Map<Object,Object>> result = bookingGuideFinanceFacade.saveGuide(guideVO, bizSettingCommon.getMyBizCode(request));
		return result.isSuccess() ? successJson("id",""+result.getValue().get("id")) : errorJson("操作失败！");
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增导游，保存
	 */
	@RequestMapping(value = "/toEditGuideView.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toEditGuideView( ModelMap model,Integer groupId,Integer id) {
//		if(id!=null){
//			BookingGuidesVO vo = bookingGuideService.selectBookingGuideVoByGroupIdAndId(id);
		BookingGuideResult result = bookingGuideFinanceFacade.toEditGuideView(groupId, id);
			model.addAttribute("vo", result.getGuidesVO());
//		}
//		List<BookingSupplierDetail> driverList = detailService.getDriversByGroupIdAndType(groupId,Constants.FLEET);
		model.addAttribute("driverList", result.getSupplierDetails());
		model.addAttribute("groupId", groupId);
		return "operation/guideFinance/edit-guide";
	}
	

	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午3:58:42
	 * @Description: 选择导游
	 */
	@RequestMapping(value = "impGuideList.htm")	
	public String impGuideList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,SupplierGuide guide,Integer page,Integer pageSize){
		Integer bizId = WebUtils.getCurBizId(request);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", regionResult.getRegionList());
		//loadGuideList(model,guide,page,pageSize,bizId);
		model.addAttribute("images_source", config.getImages200Url());
		return "operation/guideFinance/imp-guideList";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午4:02:30
	 * @Description: 导游查询结果
	 */
	@RequestMapping(value = "impGuideList.do",method=RequestMethod.POST)
	public String queryImpGuideList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,SupplierGuide guide,Integer page,Integer pageSize){
		Integer bizId = WebUtils.getCurBizId(request);
		loadGuideList(model,guide,page,pageSize,bizId);
		model.addAttribute("images_source", config.getImages200Url());
		return "operation/guideFinance/imp-guideListView";
	}	
	
	private void loadGuideList(ModelMap model,SupplierGuide guide,Integer page,Integer pageSize,Integer bizId){
		if(page==null){
			page = 1;
		}
		if(pageSize==null){
			pageSize = Constants.PAGESIZE;
		}
//		PageBean pageBean = guideService.getGuideListByBizId(guide,bizId, page, pageSize);
		BookingGuideQueryDTO queryDTO = new BookingGuideQueryDTO();
		queryDTO.setBizId(bizId);
		queryDTO.setPage(page);
		queryDTO.setPageSize(pageSize);
		queryDTO.setSupplierGuide(guide);
		PageBean pageBean = bookingGuideFacade.getGuideListByBizId(queryDTO);
		model.addAttribute("pageBean", pageBean);
	
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 设置默认
	 */
	@RequestMapping(value = "/defTetailGuide.do",method = RequestMethod.POST)
	@ResponseBody
	public String defTetailGuide(Integer id,Integer groupId) {
//		bookingGuideService.updateBygroupId(groupId);
//		BookingGuide g = new BookingGuide();
//		g.setId(id);
//		g.setIsDefault((byte)1);
//		return bookingGuideService.updateByPrimaryKeySelective(g)>0?successJson():errorJson("操作失败！");
		BookingGuide g = new BookingGuide();
		g.setId(id);
		g.setIsDefault((byte)1);
		ResultSupport resultSupport = bookingGuideFacade.defTetailGuide(g, groupId);
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败！");
	}
	
	
	
	/**
	 * 打印
	 * @param request
	 * @param response
	 * @param guideId
	 * @return
	 *//*
	@RequestMapping(value = "/download.htm")
	public String download(HttpServletRequest request,HttpServletResponse response,Integer guideId) {
		WordReporter exporter = new WordReporter(request.getSession().getServletContext().getRealPath("/")+"template/booking_guide.docx");
		try {
			exporter.init();
			//查询导游信息
			BookingGuide guide = bookingGuideService.selectByPrimaryKey(guideId);			
			//团信息
			TourGroup groupInfo = tourGroupService.selectByPrimaryKey(guide.getGroupId());
			Map<String,Object> groupMap = new HashMap<String,Object>();
			Map<String,Object> remarkMap = new HashMap<String,Object>();
			groupMap.put("groupType", groupInfo.getGroupMode()==0?"散客":"团队");//类型
			groupMap.put("totaladult", groupInfo.getTotalAdult().toString());//大人
			groupMap.put("totalchild", groupInfo.getTotalChild().toString());//小孩
			groupMap.put("groupcode", groupInfo.getGroupCode());//团号
			groupMap.put("conAcc", groupInfo.getTotalGuide().toString());//全陪
			if(!StringUtils.isEmpty(groupInfo.getProductBrandName())){
				groupMap.put("groupName","【"+groupInfo.getProductBrandName()+"】"+groupInfo.getProductName());//线路
			}
			//司机
			StringBuffer drivers = new StringBuffer();
			List<BookingSupplier> bookingSuppliers =bookingSupplierService.getDriverByGroupIdAndType(Constants.FLEET, guide.getGroupId());
			for (BookingSupplier bookingSupplier : bookingSuppliers) {
				List<BookingSupplierDetail> supplierDetails = detailService.selectByPrimaryBookId(bookingSupplier.getId());
				for (int i = 0; i < supplierDetails.size(); i++) {
					String driver = supplierDetails.get(i).getDriverName()+"-"+supplierDetails.get(i).getDriverTel();
						if(i!=supplierDetails.size()){
							drivers.append(driver+"、");
						}else{
							drivers.append(driver);
						}
					
				}
			}
			groupMap.put("drivers", drivers.toString().equals("")?"无":drivers.toString().substring(0, drivers.toString().length()-1));
			//计调员
			groupMap.put("operatorName", groupInfo.getOperatorName());
			//全陪
			StringBuffer accompanys = new StringBuffer();
			//领队
			StringBuffer leaders = new StringBuffer();
			List<GroupOrder> groupOrders = tourGroupService.selectOrderAndGuestInfoByGroupId(guide.getGroupId());
			//导游
			groupMap.put("guideInfo", guide.getGuideName()+"-"+guide.getGuideMobile());
			remarkMap.put("serviceStandard", groupInfo.getServiceStandard());
			remarkMap.put("remark", guide.getRemark());
			
			for (GroupOrder groupOrder : groupOrders) {
				List<GroupOrderGuest> guests = groupOrder.getGroupOrderGuestList();
				for (int i = 0; i < guests.size(); i++) {
					//全陪信息
						if(guests.get(i).getType()==3){
								String accompany =guests.get(i).getName()+"-"+guests.get(i).getMobile();
								accompanys.append(accompany+"、");
						}
						//领队	
						if(guests.get(i).getIsLeader()==1){
							String leader =guests.get(i).getName()+"-"+guests.get(i).getMobile();
							leaders.append(leader+"、");
			}
				
			}
			}
				groupMap.put("accompanys", accompanys.toString().equals("")?"无":accompanys.toString().substring(0, accompanys.toString().length()-1));
				groupMap.put("leaders", leaders.toString().equals("")?"无":leaders.toString().substring(0,leaders.toString().length()-1));
			
			
			//行程
			List<GroupRoute> routeList = routeService.selectByGroupId(guide.getGroupId());
			List<Map<String,String>> routeMapList = new ArrayList<Map<String,String>>();
			if(routeList!=null && routeList.size()>0){
				for(GroupRoute route:routeList){
					Map<String,String> routeMap = new HashMap<String,String>();
					Date date = DateUtils.addDays(groupInfo.getDateStart(), route.getDayNum());
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					routeMap.put("day", sdf.format(date));
					routeMap.put("routedesp", route.getRouteDesp());
					routeMap.put("isbreakfast",route.getBreakfast());
					routeMap.put("islunch",route.getLunch());
					routeMap.put("issupper",route.getSupper());
					routeMap.put("hotelname",route.getHotelName());
					routeMapList.add(routeMap);
				}
			}
			
			
			//其他logo、打印时间
			Map<String,Object> otherMap = new HashMap<String,Object>();
			String p = bizSettingCommon.getMyBizLogo(request);//WebUtils.getCurBizLogo(config.getImgServerUrl(), request);
			if(p!=null){
				Map<String,String> picMap = new HashMap<String,String>();
				picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);//经测试520可以占一行
				picMap.put("height",BizConfigConstant.BIZ_LOGO_HEIGHT);
				picMap.put("type", "jpg");
				picMap.put("path", p);
				otherMap.put("logo", picMap);
			}else{
				otherMap.put("logo", "");
			}
			
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
			otherMap.put("print_time", df.format(new Date()));
			
			exporter.export(otherMap);
			exporter.export(groupMap, 0);
			exporter.export(routeMapList, 1);
			exporter.export(remarkMap, 2);
			
			
			
			
			String url=request.getSession().getServletContext().getRealPath("/")+"/download/"+System.currentTimeMillis()+".doc";
			exporter.generate(url);
			//下载
			String path = url;
			String fileName = "";
			
				try {
					fileName = new String("出团单.doc".getBytes("UTF-8"),
							"iso-8859-1");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}// 为了解决中文名称乱码问题
			
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
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		
		}catch (Exception e) {
			
			e.printStackTrace();
		}
		
		
		return null;
	}*/
	
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月13日 上午11:51:09
	 * @Description: 报账单
	 */
	@RequestMapping(value = "/finance.htm")
	public String finance(Integer groupId,Integer bookingId,ModelMap model,Integer fromfin){
//		BookingGuide guide = bookingGuideService.selectByPrimaryKey(bookingId);
		BookingGuideResult result = bookingGuideFacade.guideFinance(groupId, bookingId);
		if(result.getBookingGuide() != null){
//			List<FinanceGuide> list = financeGuideService.selectListByGroupIdAndBookingId(groupId, bookingId);
//			/*Integer[] supplierType ={Constants.SCENICSPOT,Constants.HOTEL,Constants.RESTAURANT,Constants.FLEET,Constants.OTHERINCOME,Constants.OTHEROUTCOME};*/
//			TourGroup group = tourGroupService.selectByPrimaryKey(groupId);//团信息
//			BookingGuidesVO guidesVo = bookingGuideService.selectBookingGuideVoByGroupIdAndId(bookingId);
			String supplierName = "";
//			//团队才有组团社
//					if(group!=null && group.getGroupMode()>0){
//						List<GroupOrder> listg = groupOrderService.selectOrderByGroupId(groupId);
//						if(listg!=null && listg.size()>0){
//							supplierName=listg.get(0).getSupplierName();
//						}
//					}
			if(null != result.getOrderList() && null!= result.getOrderList().get(0)){
				model.addAttribute("supplierName",result.getOrderList().get(0).getSupplierName());
			}
			model.addAttribute("guidesVo", result.getGuidesVO());
			model.addAttribute("group", result.getTourGroup());
			BigDecimal count=new BigDecimal(0);
			List<FinanceGuide> list = result.getFinanceGuides();
			for (FinanceGuide l : list) {
					if(l.getSupplierType().equals(Constants.OTHERINCOME)){
						count=count.subtract(l.getTotal());
					}else{
						count=count.add(l.getTotal());
					}
			}
			model.addAttribute("count", count);
			model.addAttribute("list", list);
			model.addAttribute("groupId", groupId);
			model.addAttribute("bookingId", bookingId);
			model.addAttribute("fromfin", fromfin);
		}
		return "operation/guideFinance/guide-finance";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月13日 上午11:51:09
	 * @Description: 报账单
	 */
	@RequestMapping(value = "/financeSupplierView.htm")
	public String financeSupplierView(FinanceGuide financeGuide,ModelMap model){
//		List<BookingSupplier> list = financeGuideService.getFinanceSupplierByFinanceGuide(financeGuide);
//		BookingGuide guide= bookingGuideService.selectByPrimaryKey(financeGuide.getBookingId());
		BookingGuideResult result = bookingGuideFacade.financeSupplierView(financeGuide);
		List<BookingSupplier> bookingSuppliers = result.getBookingSuppliers();
		
		BigDecimal count=new BigDecimal(0);
		if (!CollectionUtils.isEmpty(bookingSuppliers)) {
			
			for (BookingSupplier l : bookingSuppliers) {
				if(l.getSupplierType().equals(Constants.OTHERINCOME)){
					count=count.subtract(l.getFtotal());
				}else{
					count=count.add(l.getFtotal());
				}
			}
		}
//		getSupplierDetail(list);
		model.addAttribute("count", count);
		model.addAttribute("list", bookingSuppliers);
		BookingGuide guide = result.getBookingGuide();
		model.addAttribute("stateFinance", guide.getStateFinance());
		model.addAttribute("financeGuide", financeGuide);
		return "operation/guideFinance/guide-financeSupplier";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月14日 下午1:46:32
	 * @Description: 关联   id为1排除已经有的
	 */
	@RequestMapping(value = "/getFinanceSupplierView.htm")
	public String financeRelevanceSupplierView(FinanceGuide financeGuide,ModelMap model){
//		List<BookingSupplier> list = financeGuideService.getFinanceSupplierByFinanceGuide(financeGuide);
		//StringBuffer sb = new StringBuffer();
//		getSupplierDetail(list);
		List<BookingSupplier> list = bookingGuideFacade.getFinanceSupplierByFinanceGuide(financeGuide);

		model.addAttribute("list", list);
		model.addAttribute("financeGuide", financeGuide);
		return "operation/guideFinance/imp-guide-financeSupplier";
	}

//	private void getSupplierDetail(List<BookingSupplier> list) {
//	
//		for (BookingSupplier bookingSupplier : list) {
//			List<BookingSupplierDetail> supplierDetails = detailService.selectByPrimaryBookId(bookingSupplier.getId());
//			//for (BookingSupplierDetail bookingSupplierDetail : supplierDetails) {
//			List<String> str = new ArrayList<String>();
//				for (int i = 0; i < supplierDetails.size(); i++) {
//				
//				if(bookingSupplier.getId().equals(supplierDetails.get(i).getBookingId())){
//					if(bookingSupplier.getSupplierType().equals(Constants.SCENICSPOT)){//景点
//						//门票：日期 + 项目 + 单价*（数量-免去）
//						str.add(com.yihg.erp.utils.DateUtils.format(supplierDetails.get(i).getItemDate())+" "+supplierDetails.get(i).getType1Name()+" "+supplierDetails.get(i).getItemPrice()+"*"+"("+supplierDetails.get(i).getItemNum()+"-"+supplierDetails.get(i).getItemNumMinus()+")");/*+(bookingSupplierDetail.getItemNum()-bookingSupplierDetail.getItemNumMinus());*/
//					}else if (bookingSupplier.getSupplierType().equals(Constants.HOTEL)) {//用房
//						//入住日期 + 类别（房型）  单价*(数量-名去)
//						str.add(com.yihg.erp.utils.DateUtils.format(supplierDetails.get(i).getItemDate())+" "+supplierDetails.get(i).getType1Name()+"("+(null==supplierDetails.get(i).getType2Name()?"":supplierDetails.get(i).getType2Name())+")"+" "+supplierDetails.get(i).getItemPrice()+"*"+"("+supplierDetails.get(i).getItemNum()+"-"+supplierDetails.get(i).getItemNumMinus()+")");
//					}else if (bookingSupplier.getSupplierType().equals(Constants.RESTAURANT)) {//用餐
//						//用餐日期 + 餐厅（类别）  单价*(数量-名去)
//						str.add(com.yihg.erp.utils.DateUtils.format(supplierDetails.get(i).getItemDate())+" "+supplierDetails.get(i).getType1Name()+"("+(null==supplierDetails.get(i).getType2Name()?"":supplierDetails.get(i).getType2Name())+")"+" "+supplierDetails.get(i).getItemPrice()+"*"+"("+supplierDetails.get(i).getItemNum()+"-"+supplierDetails.get(i).getItemNumMinus()+")");
//					}else if (bookingSupplier.getSupplierType().equals(Constants.FLEET)) {//用车
//						//车型（座位数）+车牌号 司机 + 联系方式
//						str.add(supplierDetails.get(i).getType1Name()+"("+supplierDetails.get(i).getType2Name()+")"+" "+supplierDetails.get(i).getCarLisence()+" "+supplierDetails.get(i).getDriverName()+" "+supplierDetails.get(i).getDriverTel());
//					}else if (bookingSupplier.getSupplierType().equals(Constants.OTHERINCOME)) {//其他收入
//						//项目  价格*数量  备注
//						str.add(supplierDetails.get(i).getType1Name()+" "+supplierDetails.get(i).getItemPrice()+"*"+supplierDetails.get(i).getItemNum()+" "+bookingSupplier.getRemark());
//					}else if (bookingSupplier.getSupplierType().equals(Constants.OTHEROUTCOME)) {//其他支出
//						//项目  价格*数量  备注
//						str.add(supplierDetails.get(i).getType1Name()+" "+supplierDetails.get(i).getItemPrice()+"*"+supplierDetails.get(i).getItemNum()+" "+bookingSupplier.getRemark());
//					}
//					
//				}
//				bookingSupplier.setSupplierDetail(str);
//			}
//			
//			
//		}
//	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月14日 下午5:32:09
	 * @Description: 保存报账单
	 */
	@RequestMapping(value = "/financeSave.do",method = RequestMethod.POST)
	@ResponseBody
	public String financeSave(String data) {
		List<FinanceGuide> financeGuides = JSONArray.parseArray(data, FinanceGuide.class);
//		BookingGuide guide = bookingGuideService.selectByPrimaryKey(list.get(0).getBookingId());
//		if(guide.getStateFinance()!=null && guide.getStateFinance().equals(1)){
//			return errorJson("已审核！");
//		}
//		try{
//			financeGuideService.financeBatchSave(list);
//		}catch(Exception ex){
//			return errorJson("操作失败！");
//		}
		ResultSupport resultSupport = bookingGuideFinanceFacade.financeSave(financeGuides);
		return resultSupport.isSuccess() ?  successJson() : errorJson(resultSupport.getResultMsg());
	}
	
	/**
	 * 删除导游报账
	 * @param groupId
	 * @param id
	 * @param bookingId
	 * @return
	 */
	@RequestMapping(value = "/delFinance.do",method = RequestMethod.POST)
	@ResponseBody
	public String delFinance(Integer groupId, Integer bookingIdLink,Integer bookingId) {
		
//		financeGuideService.financeDelete(groupId, bookingIdLink, bookingId);
		BookingGuideQueryDTO queryDTO = new BookingGuideQueryDTO();
		queryDTO.setGroupId(groupId);
		queryDTO.setBookingIdLink(bookingIdLink);
		queryDTO.setBookingGuideId(bookingId);
		ResultSupport delFinance = bookingGuideFacade.delFinance(queryDTO);
		return successJson();
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月26日 上午10:47:34
	 * @Description: 带团统计
	 */
	@RequestMapping(value = "/listCount.htm")
	public String toListCount(HttpServletRequest request) {
		return "operation/guideFinance/guide-list-count";
	}
	
	
	@RequestMapping(value = "/bookingGuideListCount.do")
	public String bookingGuideListCount(HttpServletRequest request, ModelMap model,BookingGuideListCount guide,Integer pageSize,Integer page) {
		PageBean pageBean = new PageBean();
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setParameter(guide);
//		pageBean = bookingGuideService.selectBookingGuideListCountListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
//		List<BookingGuideListCount> resultList = pageBean.getResult();
//		if(resultList!=null&&resultList.size()>0){
//			for (BookingGuideListCount bookingGuideListCount : resultList) {
//				SupplierGuide guideInfo = guideService.getGuideInfoById(bookingGuideListCount.getGuideId());
//				if(guideInfo!=null){
//					bookingGuideListCount.setGuideNo(guideInfo.getLicenseNo());
//				}
//			}
//		}
		pageBean = bookingGuideFinanceFacade.bookingGuideList(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		return "operation/guideFinance/guide-list-countView";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月26日 上午10:47:34
	 * @Description: 带团查询
	 */
	@RequestMapping(value = "/listSelect.htm")
	public String toListSelect(HttpServletRequest request) {
		return "operation/guideFinance/guide-list-select";
	}
	
	
	
	@RequestMapping(value = "/bookingGuideListSelect.do")
	public String bookingGuideListSelect(HttpServletRequest request, ModelMap model,BookingGuideListSelect guide,Integer pageSize,Integer page) {
		PageBean pageBean = new PageBean();
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setParameter(guide);
//		pageBean = bookingGuideService.selectBookingGuideListSelectListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		pageBean = bookingGuideFacade.bookingGuideListSelect(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));

		model.addAttribute("page", pageBean);
		return "operation/guideFinance/guide-list-selectView";
	}
	
	/**
	 * 打印导游出团单
	 * @param groupId 团id
	 * @param num num==1表示打印团出团单，num==2表示打印散客出团单
	 * @param request
	 * @param response
	 */
	@RequestMapping("download.htm")
	public void downloadFile(Integer guideId, Integer num,
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
			path = createGroupOrder(request, guideId,num);
			try {
				fileName = new String("导游接团通知单-团队单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}// 为了解决中文名称乱码问题
		} else if (num == 2) {
			try {
				fileName = new String("导游接团通知单-散客单.doc".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			path = createGroupOrder(request, guideId,num);
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
	 * 团队出团单,散客出团单
	 * @param request
	 * @param groupId
	 * @return
	 */
	public String createGroupOrder(HttpServletRequest request,Integer guideId,Integer num){
		String realPath = "" ;
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		BookingGuideResult result = bookingGuideFinanceFacade.createGroupOrder(guideId, num);
		TourGroup tourGroup = result.getTourGroup();
		BookingGuide bookingGuide = result.getBookingGuide();
		//查询导游信息
//		BookingGuide bookingGuide = bookingGuideService.selectByPrimaryKey(guideId);			
		//团信息
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(bookingGuide.getGroupId());
		/**
		 * 获取全陪，定制团一个团对应一个订单
		 */
		String accompanys = "" ;
		List<GroupOrderGuest> guests = result.getGuestGuides();
//		List<GroupOrder> orders = groupOrderService.selectOrderByGroupId(tourGroup.getId()) ;
//		GroupOrder order = orders.get(0) ;
//		List<GroupOrderGuest> guests = groupOrderGuestService.selectByOrderId(order.getId()) ;
		for (GroupOrderGuest guest : guests) { 
			if(guest.getType()==3){
				accompanys = guest.getName()+"-"+guest.getMobile() ;
				break ;
			}
		}
		if(num==2){
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/guide_Group_Individual.docx");
		}else{
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/guide_Group_Team.docx");
		}
		
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		/**
		 * logo图片
		 */
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
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
		map0.put("groupCode",tourGroup.getGroupCode());
		map0.put("personNum",tourGroup.getTotalAdult()+"大"+tourGroup.getTotalChild()+"小"+tourGroup.getTotalGuide()+"陪");
		map0.put("operatorName",tourGroup.getOperatorName());
		map0.put("startTime",new SimpleDateFormat("yyyy-MM-dd").format(tourGroup.getDateStart()));
		map0.put("tourGuide",bookingGuide.getGuideName()+"-"+bookingGuide.getGuideMobile());
		map0.put("productName","【"+tourGroup.getProductBrandName()+"】"+tourGroup.getProductName());
		
		/**
		 * 行程列表
		 */
		List<GroupRoute> routeList = result.getGroupRoutes();
//		List<GroupRoute> routeList = routeService.selectByGroupId(bookingGuide.getGroupId());
		List<Map<String,String>> routeMapList = new ArrayList<Map<String,String>>();
		if(!CollectionUtils.isEmpty(routeList)){
			for(GroupRoute route:routeList){
				Map<String,String> routeMap = new HashMap<String,String>();
				Date date = DateUtils.addDays(tourGroup.getDateStart(), route.getDayNum()==null?0:(route.getDayNum()-1));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				routeMap.put("dayNum", sdf.format(date));
				routeMap.put("routeDesp", route.getRouteDesp());
				routeMap.put("breakfast",route.getBreakfast());
				routeMap.put("lunch",route.getLunch());
				routeMap.put("supper",route.getSupper());
				routeMap.put("hotelName",route.getHotelName());
				routeMapList.add(routeMap);
			}
		}
		
		/**
		 * 备注信息
		 */
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("serviceStandard",tourGroup.getServiceStandard());
		map2.put("remark",tourGroup.getRemark());
		map2.put("remarkInternal",tourGroup.getRemarkInternal());
		
		/**
		 * 计调信息
		 */
		List<GroupGuidePrintPo> pos = result.getGroupGuides(); ;
		GroupGuidePrintPo po = null ;
		//预定下接社信息
		List<Map<String,String>> mapList = new ArrayList<Map<String,String>>();
//		List<BookingDelivery> deliveries = deliveryService.getDeliveryListByGroupId(tourGroup.getId()) ;
		List<BookingDelivery> deliveries = result.getBookingDeliveries();
		for (BookingDelivery bd : deliveries) {
			po = new  com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo();
			po.setSupplierType("下接社");
			po.setSupplierName(bd.getSupplierName());
			po.setContacktWay(bd.getContact()+"-"+bd.getContactMobile());
			po.setPaymentWay("");
			String dd = "" ;
			if(bd.getDateArrival()!=null){
				dd=com.yihg.erp.utils.DateUtils.format(bd.getDateArrival()) ;
			}
			po.setDetail(dd+" "+"人数："+bd.getPersonAdult()+"大"+bd.getPersonChild()+"小"+bd.getPersonGuide()+"陪");
			pos.add(po) ;
		}
		//预定购物
//		List<BookingShop> shops = shopService.getShopListByGroupId(tourGroup.getId()) ;
		List<BookingShop> shops = result.getBookingShops();
		for (BookingShop bs : shops) {
			po = new  GroupGuidePrintPo();
			po.setSupplierType("购物店");
			po.setSupplierName(bs.getSupplierName());
			po.setContacktWay("");
			po.setPaymentWay("");
			po.setDetail(bs.getShopDate());
			pos.add(po) ;
		}
		/**
		 * 预订房信息
		 */
//		List<BookingSupplier> bs3 = supplierService.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(), 3) ;
//		for (BookingSupplier bs : bs3) {
//			po = new  GroupGuidePrintPo();
//			po.setSupplierType("房");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact()+"-"+bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			StringBuilder sb = new StringBuilder() ;
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "" ;
//				if(bsd.getItemDate()!=null){
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate()) ;
//				}
//				sb.append(dd+
//						" 【"+bsd.getType1Name()+"】 "+
//						bsd.getItemPrice().toString().replace(".0","")+
//						"*("+bsd.getItemNum().toString().replace(".0","")+
//						"-"+bsd.getItemNumMinus().toString().replace(".0","")+")");
//			}
//			po.setDetail(sb.toString());
//			
//			pos.add(po) ;
//		}
		/**
		 * 预定车信息
		 */
//		List<BookingSupplier> bs4 = supplierService.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(), 4) ;
//		for (BookingSupplier bs : bs4) {
//			po = new  GroupGuidePrintPo();
//			po.setSupplierType("车");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact()+"-"+bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			StringBuilder sb = new StringBuilder() ;
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "" ;
//				if(bsd.getItemDate()!=null){
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate()) ;
//				}
//				sb.append(dd+
//						" 【"+bsd.getType1Name()+"】 "+
//						bsd.getItemPrice().toString().replace(".0","")+
//						"*("+bsd.getItemNum().toString().replace(".0","")+
//						"-"+(bsd.getItemNumMinus()==null?0:bsd.getItemNumMinus().toString().replace(".0",""))+")");
//			}
//			po.setDetail(sb.toString());
//			
//			pos.add(po) ;
//		}
		/**
		 * 预定景区信息
		 */
//		List<BookingSupplier> bs5 = supplierService.getBookingSupplierByGroupIdAndSupplierType(tourGroup.getId(), 5) ;
//		for (BookingSupplier bs : bs5) {
//			po = new  GroupGuidePrintPo();
//			po.setSupplierType("景区");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay(bs.getContact()+"-"+bs.getContactMobile());
//			po.setPaymentWay(bs.getCashType());
//			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//			StringBuilder sb = new StringBuilder() ;
//			for (BookingSupplierDetail bsd : details) {
//				String dd = "" ;
//				if(bsd.getItemDate()!=null){
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate()) ;
//				}
//				sb.append(dd+
//						" 【"+bsd.getType1Name()+"】 "+
//						bsd.getItemPrice().toString().replace(".0","")+
//						"*("+bsd.getItemNum().toString().replace(".0","")+
//						"-"+bsd.getItemNumMinus().toString().replace(".0","")+")");
//			}
//			po.setDetail(sb.toString());
//			
//			pos.add(po) ;
//		}
		/**
		 * 组织打印数据
		 */
		for (GroupGuidePrintPo ggp : pos) {
			Map<String,String> map = new HashMap<String,String>();
			map.put("supplierType",ggp.getSupplierType()) ;
			map.put("supplierName",ggp.getSupplierName()) ;
			map.put("contactWay", ggp.getContacktWay()) ;
			map.put("paymentWay", ggp.getPaymentWay()) ;
			map.put("detail", ggp.getDetail()) ;
			mapList.add(map) ;
		}
		List<Map<String, String>> orderList = new ArrayList<Map<String, String>>();
		if(num==2){
			List<GroupOrderPrintPo> gopps = result.getGroupOrderPrints();
//			List<GroupOrder> orders1 = groupOrderService.selectOrderByGroupId(tourGroup.getId()) ;
//			List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>() ;
//			GroupOrderPrintPo gopp = null ;
//			for (GroupOrder order1 : orders1) {
			for (GroupOrderPrintPo gopp : gopps) {
				
				//拿到单条订单信息
//				gopp = new GroupOrderPrintPo() ;
				/*gopp.setSupplierName(order.getSupplierName()) ;
				gopp.setSaleOperatorName(order.getSaleOperatorName()) ;*/
//				gopp.setRemark(order.getRemark());
				
				//根据散客订单统计人数
//				Integer numAdult = groupOrderGuestService.selectNumAdultByOrderID(order1.getId()) ;
//				Integer numChild = groupOrderGuestService.selectNumChildByOrderID(order1.getId()) ;
//				gopp.setPersonNum(numAdult+"大"+numChild+"小");
				//根据散客订单统计客人信息
//				List<GroupOrderGuest> guests1 = groupOrderGuestService.selectByOrderId(order1.getId()) ;
				List<GroupOrderGuest> guests1 = gopp.getGuests();
				gopp.setGuestInfo(getGuestInfo(guests1)) ;
				//根据散客订单统计酒店信息
//				List<GroupRequirement> grogShopList = groupRequirementService
//						.selectByOrderAndType(order1.getId(), 3);
//				gopp.setHotelInfo(getHotelInfo(grogShopList));
				//根据散客订单统计接机信息
//				List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//						.selectByOrderId(order1.getId());
				List<GroupOrderTransport> groupOrderTransports = gopp.getOrderTransports();
				gopp.setAirPickup(getAirInfo(groupOrderTransports, 0)) ;
				//根据散客订单统计送机信息
				gopp.setAirOff(getAirInfo(groupOrderTransports,1));
				gopps.add(gopp) ;
//			}
			}
			
//			orderList = new ArrayList<Map<String, String>>();
			int i = 0 ;
			for (GroupOrderPrintPo po1: gopps) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("num",""+i++) ;
				/*map.put("supplierName",po1.getSupplierName()) ;
				map.put("salePerson",po1.getSaleOperatorName()) ;*/
				map.put("personNum",po1.getPersonNum()) ;
				map.put("guestInfo",po1.getGuestInfo()) ;
				map.put("hotelInfo",po1.getHotelInfo()) ;
				map.put("airPickUp",po1.getAirPickup()) ;
				map.put("airOff", po1.getAirOff()) ;
				map.put("remark", po1.getRemark()) ;
				orderList.add(map);
			}
		}
		
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(routeMapList,1);
			export.export(map2, 2);
			export.export(mapList, 3);
//			if(num==2){
//				export.export(orderList, 4);
//			}
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}
	
	/**
	 * 返回客人信息
	 * 
	 * @param guests
	 * @return
	 */
	public String getGuestInfo(List<GroupOrderGuest> guests) {
		StringBuilder sb = new StringBuilder();
		for (GroupOrderGuest guest : guests) {
			sb.append(guest.getName() + " " + guest.getMobile() + " "
					+ guest.getCertificateNum() + ";");
		}
		return sb.toString();
	}

	/**
	 * 返回酒店信息
	 * 
	 * @param grogShopList
	 * @return
	 */
//	public String getHotelInfo(List<GroupRequirement> grogShopList) {
//		StringBuilder sb = new StringBuilder();
//		for (GroupRequirement groupRequirement : grogShopList) {
//			sb.append(groupRequirement.getRequireDate() + " "
//					+ dicService.getById(groupRequirement.getHotelLevel()).getValue() + " "
//					+ groupRequirement.getCountSingleRoom() + "单间" + " "
//					+ groupRequirement.getCountDoubleRoom() + "标间" + " "
//					+ groupRequirement.getCountTripleRoom() + "三人间");
//		}
//		return sb.toString();
//	}

	/**
	 * 接送信息
	 * 
	 * @param groupOrderTransports
	 * @param flag
	 * 0表示接信息 1表示送信息
	 * @return
	 */
	public String getAirInfo(List<GroupOrderTransport> groupOrderTransports,
			Integer flag) {
		StringBuilder sb = new StringBuilder();
		if (flag == 0) {
			for (GroupOrderTransport transport : groupOrderTransports) {
				sb.append(transport.getArrivalTime() + " "
						+ transport.getClassNo() + ";");
			}
		}
		if (flag == 1) {
			for (GroupOrderTransport transport : groupOrderTransports) {
				sb.append(transport.getDepartureTime() + " "
						+ transport.getClassNo() + ";");
			}
		}
		return sb.toString();
	}
}
