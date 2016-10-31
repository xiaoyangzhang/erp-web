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
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.result.DicListResult;
import org.erpcenterFacade.common.client.result.RegionResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.exception.ClientException;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.finance.api.FinanceGuideService;
import com.yihg.finance.po.FinanceGuide;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingDeliveryService;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingShopService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingGuideListCount;
import com.yihg.operation.po.BookingGuideListSelect;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.GroupOrderTransportService;
import com.yihg.sales.api.GroupRequirementService;
import com.yihg.sales.api.GroupRouteService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupRequirement;
import com.yihg.sales.po.GroupRoute;
import com.yihg.supplier.api.SupplierGuideService;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.constants.SupplierConstant;
import com.yihg.supplier.po.SupplierGuide;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.api.SysBizBankAccountService;
import com.yimayhd.erpcenter.facade.sales.query.BookingGuideQueryDTO;
import com.yimayhd.erpcenter.facade.sales.result.BookingGuideResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.WebResult;
import com.yimayhd.erpcenter.facade.sales.service.BookingGuideFacade;
/**
 * @author : xuzejun
 * @date : 2015年7月25日 下午2:31:01
 * @Description: 计调-导游
 */
@Controller
@RequestMapping("/bookingGuide")
public class BookingGuideController extends BaseController {
	@Autowired
	private SupplierGuideService guideService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private BookingGuideService bookingGuideService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private SupplierService supplierSerivce;
	@Autowired
	private BookingSupplierService bookingSupplierService;
	@Autowired
	private GroupRouteService routeService;
	@Autowired
	private BookingSupplierDetailService detailService;
	@Autowired
	private SysConfig config;
	@Autowired
	private FinanceGuideService financeGuideService;
	@Autowired
	private GroupOrderService groupOrderService;
	@Autowired
	private GroupRequirementService groupRequirementService;
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private GroupOrderGuestService groupOrderGuestService ;
	@Autowired
	private BookingDeliveryService deliveryService ;
	@Autowired
	private BookingShopService shopService ;
	@Autowired
	private BookingSupplierService supplierService ;
	@Autowired
	private DicService dicService ;
	@Autowired
	private GroupOrderTransportService groupOrderTransportService ;
	@Autowired
	private SysBizBankAccountService sysBizBankAccountService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private BookingGuideFacade bookingGuideFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model, HttpServletRequest request) {
//		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
//		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
	    DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
	}
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转导游页面
	 */
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toList(HttpServletRequest request,ModelMap model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "operation/guide/guide-list";
	}

	
	//TourGroup group,
	@RequestMapping(value = "/bookingGuideList.do")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String bookingGuideList(HttpServletRequest request, ModelMap model,com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if(group.getPage()==null){
			group.setPage(1);
		}
		if(group.getPageSize()==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(group.getPageSize());
		}
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
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
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(), 
				group.getOrgIds(), WebUtils.getCurBizId(request)));
		
		group.setSupplierType(Constants.GUIDE);
		group.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(group);
		pageBean.setPage(group.getPage());
		
//		pageBean = tourGroupService.getGuideGroupList(pageBean, group, WebUtils.getDataUserIdSet(request));
		//fillData(pageBean.getResult());
		pageBean = bookingGuideFacade.getGuideGroupList(pageBean, group, WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		return "operation/guide/guide-listView";
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
		//TourGroup tg = tourGroupService.selectByPrimaryKey(groupId) ;
		BookingGuideResult result = bookingGuideFacade.guideDetailList(groupId);
		model.addAttribute("groupMode", result.getTourGroup().getGroupMode());
		model.addAttribute("groupId", groupId);
		//查询需求订单
		//List<GroupRequirement> groupRequirements = groupRequirementService.selectByGroupIdAndType(groupId, Constants.GUIDE);
		/*if (groupRequirements!=null && groupRequirements.size()>0) {
			GroupOrder groupOrder = groupOrderService
					.selectByPrimaryKey(groupRequirements.get(0).getOrderId());
			for (GroupRequirement req : groupRequirements) {
				if (groupOrder!=null) {
					req.setNameFull(groupOrder.getOrderType()==1?groupOrder.getSupplierName():"散客团");
				}
			}
		}*/
		//List<BookingGuidesVO> vo = bookingGuideService.selectBookingGuideVoByGroupId(groupId);
		model.addAttribute("vo", result.getBookingGuidesVOs());
		model.addAttribute("groupRequirements",result.getGroupRequirements());
		return "operation/guide/guide-listViewDetail";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转导游页面
	 */
	@RequestMapping(value = "/guideDetailListView.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String guideDetailListView( ModelMap model,Integer groupId) {
		BookingGuideResult result = bookingGuideFacade.guideDetailListView(groupId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupCanEdit", result.isGroupAbleEdit());
		//List<BookingGuidesVO> vo = bookingGuideService.selectBookingGuideVoByGroupId(groupId);
		model.addAttribute("vo", result.getBookingGuidesVOs());
		return "operation/guide/guide-detaillistView";
	}
	
	/**
	 * 跳转到转移领单页面
	 */
	@RequestMapping(value = "{groupId}/{guideId}/{mguideId}")
	@ResponseBody
	public String exchanged(@PathVariable Integer groupId, @PathVariable Integer guideId, @PathVariable Integer mguideId, Integer id ){
//		Map<String, Object> map = new HashMap<String, Object>();
//		//TODO 此方法不全
//		bookingGuideService.changeShop(groupId, guideId,mguideId,id);
//		financeGuideService.changeGroup(groupId, guideId,mguideId);
//		map.put("flag", true);
//		map.put("msg", "转移成功");
		BookingGuideQueryDTO queryDTO = new BookingGuideQueryDTO();
		queryDTO.setBookingGuideId(id);
		queryDTO.setGroupId(groupId);
		queryDTO.setGuideId(guideId);
		queryDTO.setmGuideId(mguideId);
		Map<String, Object> map = bookingGuideFacade.moveCoupon(queryDTO);
		return successJson(map);
	}
	
	@RequestMapping(value = "/toGuideDetailListView.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toGuideDetailListView( ModelMap model,Integer groupId) {
		model.addAttribute("groupId", groupId);
		//List<BookingGuidesVO> vo = bookingGuideService.selectBookingGuideVoByGroupId(groupId);
		BookingGuideResult result = bookingGuideFacade.toGuideDetailListView(groupId);
		model.addAttribute("vo", result.getBookingGuidesVOs());
		model.addAttribute("view",1);
		return "operation/guide/guide-detaillistView";
	}
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增导游，保存
	 */
	@RequestMapping(value = "/saveGuide.do")
	@ResponseBody
	public String saveGuide(HttpServletRequest request, ModelMap model,com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingGuidesVO guideVO) {
		com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide guide = guideVO.getGuide();
//		List<BookingGuide> list = bookingGuideService.selectGuidesByGroupId(guide.getGroupId());
//
//		if(!tourGroupService.checkGroupCanEdit(guide.getGroupId())){
//			return errorJson("该团已审核或封存，不允许修改该信息");
//		}
//		if(guide.getId()==null){//新增
//			for (BookingGuide bookingGuide : list) {
//				if(guide.getGuideId().intValue()==bookingGuide.getGuideId().intValue()){
//					return errorJson("该团已安排此导游，不允许重复安排！");
//				}
//			}
//			int No = bookingGuideService.getBookingCountByTime();
//			guide.setBookingNo(bizSettingCommon.getMyBizCode(request)+Constants.GUIDE+new SimpleDateFormat("yyMMdd").format(new Date())+(No+100));
			guide.setUserId(WebUtils.getCurUserId(request));
			guide.setUserName(WebUtils.getCurUser(request).getName());
//			guide.setCreateTime(System.currentTimeMillis());
//			guide.setBookingDate(new Date());
			//guide.setIsDefault((byte)0);
//		}
		WebResult<Map<String,Object>> result = bookingGuideFacade.saveGuide(guideVO, bizSettingCommon.getMyBizCode(request));
//		return bookingGuideService.insertSelective(guideVO)>0?successJson("id",guide.getGroupId()+""):errorJson("操作失败！");
		return result.isSuccess() ? successJson("id",result.getValue().get("id")+"") : errorJson(result.getResultMsg());
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增导游，保存
	 */
	@RequestMapping(value = "/toEditGuideView.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUIDE)
	public String toEditGuideView( ModelMap model,Integer groupId,Integer id,String add) {
//		if(id!=null){
//			BookingGuidesVO vo = bookingGuideService.selectBookingGuideVoByGroupIdAndId(id);
		BookingGuideResult result = bookingGuideFacade.toEditGuideView(groupId, id);
			model.addAttribute("vo", result.getGuidesVO());
//		}
//		List<BookingSupplierDetail> driverList = detailService.getDriversByGroupIdAndType(groupId,Constants.FLEET);
		model.addAttribute("driverList", result.getSupplierDetails());
		model.addAttribute("groupId", groupId);
//		//查询出团时间和团结束时间
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		model.addAttribute("group", result.getTourGroup());
		model.addAttribute("add", add);
		return "operation/guide/edit-guide";
	}
	

	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午3:58:42
	 * @Description: 选择导游
	 */
	@RequestMapping(value = "impGuideList.htm")	
	public String impGuideList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,SupplierGuide guide,Integer page,Integer pageSize){
		Integer bizId = WebUtils.getCurBizId(request);
		//List<RegionInfo> allProvince = regionService.getAllProvince();
		RegionResult result = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", result.getRegionList());
		//loadGuideList(model,guide,page,pageSize,bizId);
		model.addAttribute("images_source", config.getImages200Url());
		return "operation/guide/imp-guideList";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午4:02:30
	 * @Description: 导游查询结果
	 */
	@RequestMapping(value = "impGuideList.do",method=RequestMethod.POST)
	public String queryImpGuideList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,com.yimayhd.erpresource.dal.po.SupplierGuide guide,Integer page,Integer pageSize){
		Integer bizId = WebUtils.getCurBizId(request);
		loadGuideList(model,guide,page,pageSize,bizId);
		model.addAttribute("images_source", config.getImages200Url());
		return "operation/guide/imp-guideListView";
	}	
	
	private void loadGuideList(ModelMap model,com.yimayhd.erpresource.dal.po.SupplierGuide guide,Integer page,Integer pageSize,Integer bizId){
		if(page==null){
			page = 1;
		}
		if(pageSize==null){
			pageSize = Constants.PAGESIZE;
		}
		//PageBean pageBean = guideService.getGuideListByBizId(guide,bizId, page, pageSize);
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
	 * @Description: 删除导游信息
	 */
	@RequestMapping(value = "/deletetailGuide.do",method = RequestMethod.POST)
	@ResponseBody
	public String deldetailGuide(Integer id) {
		
		try{
			//bookingGuideService.deleteByPrimaryKey(id);
			ResultSupport resultSupport = bookingGuideFacade.deldetailGuide(id);
		}catch(ClientException ex){
			return errorJson(ex.getMessage());
		}catch(Exception ex){
			return errorJson("操作失败！");
		}
		return successJson();

	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 设置默认
	 */
	@RequestMapping(value = "/defTetailGuide.do",method = RequestMethod.POST)
	@ResponseBody
	public String defTetailGuide(Integer id,Integer groupId) {
		//bookingGuideService.updateBygroupId(groupId);
		com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide g = new com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide();
		g.setId(id);
		g.setIsDefault((byte)1);
		//return bookingGuideService.updateByPrimaryKeySelective(g)>0?successJson():errorJson("操作失败！");
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
	public String finance(Integer groupId,Integer bookingId,ModelMap model,Integer fromfin,HttpServletRequest request){
		//List<FinanceGuide> list = financeGuideService.selectListByGroupIdAndBookingId(groupId, bookingId);
		/*Integer[] supplierType ={Constants.SCENICSPOT,Constants.HOTEL,Constants.RESTAURANT,Constants.FLEET,Constants.OTHERINCOME,Constants.OTHEROUTCOME};*/
//		TourGroup group = tourGroupService.selectByPrimaryKey(groupId);//团信息
//		BookingGuidesVO guidesVo = bookingGuideService.selectBookingGuideVoByGroupIdAndId(bookingId);
		BookingGuideResult result = bookingGuideFacade.financeBill(groupId, bookingId);
		String supplierName = "";
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder> orderList = result.getOrderList();
		//团队才有组团社
//				if(group!=null && group.getGroupMode()>0){
//					List<GroupOrder> listg = groupOrderService.selectOrderByGroupId(groupId);
					if(!CollectionUtils.isEmpty(orderList)){
						supplierName=orderList.get(0).getSupplierName();
					}
//				}
		model.addAttribute("supplierName",supplierName);
		model.addAttribute("guidesVo", result.getGuidesVO());
		model.addAttribute("group", result.getTourGroup());
		BigDecimal count=new BigDecimal(0);
		List<com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide> financeGuides = result.getFinanceGuides();
		for (com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide l : financeGuides) {
			if(l.getSupplierType().equals(Constants.OTHERINCOME)){
				count=count.subtract(l.getTotal());
			}else{
				count=count.add(l.getTotal());
			}
		}
//		List<FinanceCommission> financeCommissionList = financeGuideService.getFinanceCommisionByGroupIdAndGuideId(WebUtils.getCurBizId(request),groupId,guidesVo.getGuide().getGuideId());
//		model.addAttribute("financeCommissionList", financeCommissionList);
//		//计算购物佣金总和
//		BigDecimal countCommision=new BigDecimal(0);
//		for (FinanceCommission financeCommission : financeCommissionList) {
//			countCommision=countCommision.add(financeCommission.getTotal());
//		}
//		model.addAttribute("countCommision", countCommision);
//		count = count.add(countCommision);
		model.addAttribute("count", count);
		model.addAttribute("list", financeGuides);
		model.addAttribute("groupId", groupId);
		model.addAttribute("bookingId", bookingId);
		model.addAttribute("fromfin", fromfin);
		
		return "operation/guide/guide-finance";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月13日 上午11:51:09
	 * @Description: 报账单
	 */
	@RequestMapping(value = "/financeSupplierView.htm")
	public String financeSupplierView(com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide financeGuide,ModelMap model){
//		List<BookingSupplier> list = financeGuideService.getFinanceSupplierByFinanceGuide(financeGuide);
//		BookingGuide guide= bookingGuideService.selectByPrimaryKey(financeGuide.getBookingId());
		BookingGuideResult result = bookingGuideFacade.financeSupplierView(financeGuide);
		BigDecimal count=new BigDecimal(0);
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier> bookingSuppliers = result.getBookingSuppliers();
		for (com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier l : bookingSuppliers) {
				count=count.add(l.getFtotal());
		}
//		getSupplierDetail(bookingSuppliers);
		model.addAttribute("count", count);
		model.addAttribute("list", bookingSuppliers);
		com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide guide = result.getBookingGuide();
		model.addAttribute("stateFinance", guide.getStateFinance());
		//stateBooking报账状态，只有未报账的才能关联和删除订单
		model.addAttribute("stateBooking", guide.getStateBooking()==null ? 0:guide.getStateBooking());
		model.addAttribute("financeGuide", financeGuide);
		return "operation/guide/guide-financeSupplier";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月14日 下午1:46:32
	 * @Description: 关联   id为1排除已经有的
	 */
	@RequestMapping(value = "/getFinanceSupplierView.htm")
	public String financeRelevanceSupplierView(com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide financeGuide,ModelMap model){
//		List<BookingSupplier> list = financeGuideService.getFinanceSupplierByFinanceGuide(financeGuide);
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier> list = bookingGuideFacade.getFinanceSupplierByFinanceGuide(financeGuide);
		//StringBuffer sb = new StringBuffer();
//		getSupplierDetail(list);
		model.addAttribute("list", list);
		model.addAttribute("financeGuide", financeGuide);
		return "operation/guide/imp-guide-financeSupplier";
	}

	private void getSupplierDetail(List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier> list) {
	
		for (com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier bookingSupplier : list) {
			List<BookingSupplierDetail> supplierDetails = detailService.selectByPrimaryBookId(bookingSupplier.getId());
			//for (BookingSupplierDetail bookingSupplierDetail : supplierDetails) {
			List<String> str = new ArrayList<String>();
				for (int i = 0; i < supplierDetails.size(); i++) {
				
				if(bookingSupplier.getId().equals(supplierDetails.get(i).getBookingId())){
					if(bookingSupplier.getSupplierType().equals(Constants.SCENICSPOT)){//景点
						//门票：日期 + 项目 + 单价*（数量-免去）
						str.add(com.yihg.erp.utils.DateUtils.format(supplierDetails.get(i).getItemDate())+" "+supplierDetails.get(i).getType1Name()+" "+supplierDetails.get(i).getItemPrice()+"*"+"("+supplierDetails.get(i).getItemNum()+"-"+supplierDetails.get(i).getItemNumMinus()+")");/*+(bookingSupplierDetail.getItemNum()-bookingSupplierDetail.getItemNumMinus());*/
					}else if (bookingSupplier.getSupplierType().equals(Constants.HOTEL)) {//用房
						//入住日期 + 类别（房型）  单价*(数量-名去)
						str.add(com.yihg.erp.utils.DateUtils.format(supplierDetails.get(i).getItemDate())+" "+supplierDetails.get(i).getType1Name()+"("+(null==supplierDetails.get(i).getType2Name()?"":supplierDetails.get(i).getType2Name())+")"+" "+supplierDetails.get(i).getItemPrice()+"*"+"("+supplierDetails.get(i).getItemNum()+"-"+supplierDetails.get(i).getItemNumMinus()+")"+" "+supplierDetails.get(i).getItemBrief());
					}else if (bookingSupplier.getSupplierType().equals(Constants.RESTAURANT)) {//用餐
						//用餐日期 + 餐厅（类别）  单价*(数量-名去)
						str.add(com.yihg.erp.utils.DateUtils.format(supplierDetails.get(i).getItemDate())+" "+supplierDetails.get(i).getType1Name()+"("+(null==supplierDetails.get(i).getType2Name()?"":supplierDetails.get(i).getType2Name())+")"+" "+supplierDetails.get(i).getItemPrice()+"*"+"("+supplierDetails.get(i).getItemNum()+"-"+supplierDetails.get(i).getItemNumMinus()+")");
					}else if (bookingSupplier.getSupplierType().equals(Constants.FLEET)) {//用车
						//车型（座位数）+车牌号 司机 + 联系方式
						str.add(supplierDetails.get(i).getType1Name()+"("+supplierDetails.get(i).getType2Name()+")"+" "+supplierDetails.get(i).getCarLisence()+" "+supplierDetails.get(i).getDriverName()+" "+supplierDetails.get(i).getDriverTel());
					}else if (bookingSupplier.getSupplierType().equals(Constants.OTHERINCOME)) {//其他收入
						//项目  价格*数量  备注
						str.add(supplierDetails.get(i).getType1Name()+" "+supplierDetails.get(i).getItemPrice()+"*"+supplierDetails.get(i).getItemNum()+" "+bookingSupplier.getRemark());
					}else if (bookingSupplier.getSupplierType().equals(Constants.OTHEROUTCOME)) {//其他支出
						//项目  价格*数量  备注
						str.add(supplierDetails.get(i).getType1Name()+" "+supplierDetails.get(i).getItemPrice()+"*"+supplierDetails.get(i).getItemNum()+" "+bookingSupplier.getRemark());
					}
					
				}
				bookingSupplier.setSupplierDetail(str);
			}
			
			
		}
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月14日 下午5:32:09
	 * @Description: 保存报账单
	 */
	@RequestMapping(value = "/financeSave.do",method = RequestMethod.POST)
	@ResponseBody
	public String financeSave(String data) {
		List<com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide> list = JSONArray.parseArray(data, com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide.class);
//		BookingGuide guide = bookingGuideService.selectByPrimaryKey(list.get(0).getBookingId());
//		if(guide.getStateFinance()!=null && guide.getStateFinance().equals(1)){
//			return errorJson("已审核！");
//		}
//		return financeGuideService.save(list) >0?successJson():errorJson("操作失败！");
		ResultSupport resultSupport = bookingGuideFacade.financeSave(list);
		return resultSupport.isSuccess() ? successJson() : errorJson(resultSupport.getResultMsg());
	}
	/**
	 * @author : xuzejun
	 * @date : 2015年8月14日 下午5:51:22
	 * @Description: 删除
	 */
	@RequestMapping(value = "/delFinance.do",method = RequestMethod.POST)
	@ResponseBody
	public String delFinance(Integer groupId, Integer bookingIdLink,Integer bookingId) {
		//financeGuideService.financeDelete(groupId, bookingIdLink, bookingId);
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
		return "operation/guide/guide-list-count";
	}
	
	
	@RequestMapping(value = "/bookingGuideListCount.do")
	public String bookingGuideListCount(HttpServletRequest request, ModelMap model,BookingGuideListCount guide,Integer pageSize,Integer page,GroupOrder order) {
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
//		if(StringUtils.isBlank(order.getSaleOperatorIds()) && StringUtils.isNotBlank(order.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = order.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				order.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		
		Integer bizId=WebUtils.getCurBizId(request);
		Set<Integer> sets = WebUtils.getDataUserIdSet(request);
		//pageBean = bookingGuideService.selectBookingGuideListCountListPage(pageBean, bizId,sets);
		/*List<BookingGuideListCount> resultList = pageBean.getResult();
		if(resultList!=null&&resultList.size()>0){
			for (BookingGuideListCount bookingGuideListCount : resultList) {
				SupplierGuide guideInfo = guideService.getGuideInfoById(bookingGuideListCount.getGuideId());
				if(guideInfo!=null){
					bookingGuideListCount.setGuideNo(guideInfo.getLicenseNo());
				}
			}
		}*/

		//Map totalMap= bookingGuideService.getBookingGuideTotalCount(pageBean, bizId,sets);
		BookingGuideResult result = bookingGuideFacade.bookingGuideListCount(pageBean, bizId, sets);
		Map<Object, Object> totalMap = result.getMap();
		Integer state0 = TypeUtils.castToInt(totalMap.get("state0"));
		//Integer state1 = TypeUtils.castToInt(totalMap.get("state1"));
		Integer state2 = TypeUtils.castToInt(totalMap.get("state2"));
		Integer groupCount = TypeUtils.castToInt(totalMap.get("groupCount"));
		Integer adult = TypeUtils.castToInt(totalMap.get("adult"));
		Double jh = TypeUtils.castToDouble(totalMap.get("jh"));
		//BigDecimal sj = new BigDecimal(TypeUtils.castToDouble(totalMap.get("sj")));
		Double sj = TypeUtils.castToDouble(totalMap.get("sj"));
		model.addAttribute("state0", state0);
		//model.addAttribute("state1", state1);
		model.addAttribute("state2", state2);
		model.addAttribute("groupCount", groupCount);
		model.addAttribute("adult", adult);
		model.addAttribute("jh", jh);
		model.addAttribute("sj", sj);
		model.addAttribute("page", result.getPageBean());
		return "operation/guide/guide-list-countView";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年8月26日 上午10:47:34
	 * @Description: 带团查询
	 */
	@RequestMapping(value = "/listSelect.htm")
	public String toListSelect(HttpServletRequest request) {
		return "operation/guide/guide-list-select";
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
		//pageBean = bookingGuideService.selectBookingGuideListSelectListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		pageBean = bookingGuideFacade.bookingGuideListSelect(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		return "operation/guide/guide-list-selectView";
	}
	
	/**
	 * 打印导游出团单
	 * @param groupId 团id
	 * @param num num==1表示打印团出团单，num==2表示打印散客出团单
	 * @param request
	 * @param response
	 */
	@RequestMapping("download.htm")
	public void downloadFile(Integer guideId, Integer num,Integer groupId,
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
			fileName = new String("导游接团单.doc".getBytes("UTF-8"),
					"iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		if (num == 3) {//导游单行程单
			path = createGroupOrder(request,groupId,num); //团队、散客出团单
		}else{
			path = createGroupOrder(request,guideId,num); //导游出团单
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
	public String getGuestNameAndMobile(List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest> list){
		StringBuilder sb = new StringBuilder() ;
		for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest guest : list) {
			sb.append(guest.getName()+" "+guest.getMobile()+"\n") ;
		}
		return sb.toString() ;
	}
	@RequestMapping("previewGuideRoute.htm")
	public String previewGuideRoute(HttpServletRequest request,Model model,Integer id,Integer num){
		com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup tourGroup = null ;
		BookingGuide bookingGuide = null ;
		String guestGuideString = "" ;
		String guestIsLeaderString ="" ;
		String driverString ="" ;
		String trans = "" ;
		// 查询导游信息
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide> guides = null;
		String guideString = "" ;
		BookingGuideResult result = null;
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo> ggpp = null ;
		if(num==3){
		    result = bookingGuideFacade.getGroupRouteInfo(id);
//			tourGroup = tourGroupService.selectByPrimaryKey(id);
//			guides = bookingGuideService.selectGuidesByGroupId(id);
			tourGroup = result.getTourGroup();
			guides = result.getBookingGuides();
			guestGuideString = getGuestNameAndMobile(result.getGuestGuides()) ;
			guestIsLeaderString = getGuestNameAndMobile(result.getGuestLeaders()) ;
//			if(guides.size()>0){
//				guideString = getGuides(guides) ;
				guideString = result.getGuideString();
				model.addAttribute("tourGuide",guideString);
//			}
//			//预定车信息
//			List<BookingSupplier> bs4 = supplierService.getBookingSupplierByGroupIdAndSupplierType(id, 4) ;
//			StringBuilder sb = new StringBuilder() ;
//			for (BookingSupplier bs : bs4) {
//				List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//				for (BookingSupplierDetail bsd : details) {
//					sb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//				}
//			}
//			driverString = sb.toString() ;
			driverString = result.getDriverString();
//			//接送信息
//			List<GroupOrderTransport> gots = groupOrderTransportService.selectByGroupId(id) ;
			List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> gots = result.getOrderTransports();
			trans = "接机："+getAirInfo(gots, 0)+"\n"
				   +"送机："+getAirInfo(gots, 1)+"\n"
				   +"省内交通："+getSourceType(gots) ;
			ggpp = getOperatorInfo(tourGroup.getId(),null,num) ;
		}else {
			//查询导游信息
			//bookingGuide = bookingGuideService.selectByPrimaryKey(id);			
			//团信息
			//tourGroup = tourGroupService.selectByPrimaryKey(bookingGuide.getGroupId());
			result = bookingGuideFacade.getGroupRouteInfo(id);
			guestGuideString = getGuestNameAndMobile(result.getGuestGuides()) ;
			guestIsLeaderString = getGuestNameAndMobile(result.getGuestLeaders()) ;
			
			/**
			 * 如果该导游下面有结对司机，就显示结对司机，如果没有就显示团下面的所有司机
			 */
//			BookingSupplierDetail bsd = detailService.selectByPrimaryKey(bookingGuide.getBookingDetailId()) ;
//			StringBuilder sb = new StringBuilder() ;
//			if(null!=bsd && null!=bsd.getDriverId()){
//				sb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//				driverString = sb.toString() ;
//			}else{
//				//查询团下所有预定车信息
//				List<BookingSupplier> bs4 = supplierService.getBookingSupplierByGroupIdAndSupplierType(bookingGuide.getGroupId(), 4) ;
//				for (BookingSupplier bs : bs4) {
//					List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//					for (BookingSupplierDetail bsd1 : details) {
//						sb.append(bsd1.getDriverName()+" "+bsd1.getDriverTel()+" "+bsd1.getCarLisence()+"\n") ;
//					}
//				}
				driverString = result.getDriverString();
//			}
			//接送信息
		//	List<GroupOrderTransport> gots = groupOrderTransportService.selectByGroupId(tourGroup.getId()) ;
				List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> gots = result.getOrderTransports();
			trans = "接机："+getAirInfo(gots, 0)+"\n"
					   +"送机："+getAirInfo(gots, 1)+"\n"
					   +"省内交通："+getSourceType(gots) ;
			com.yimayhd.erpresource.dal.po.SupplierGuide sg = result.getSupplierGuide();
			model.addAttribute("tourGuide",bookingGuide.getGuideName()+" "+bookingGuide.getGuideMobile()+" "+sg.getLicenseNo());
			ggpp = getOperatorInfo(tourGroup.getId(),bookingGuide.getBookingDetailId(),num) ;
		}
		if(tourGroup==null){
			tourGroup = new com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup() ;
		}
		if(bookingGuide==null){
			bookingGuide = new BookingGuide() ;
		}
		//logo图片
		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		if(num==3){
//			model.addAttribute("tourGuide",guideString);
//		}else{
//			SupplierGuide sg = guideService.getGuideInfoById(bookingGuide.getGuideId());
//			model.addAttribute("tourGuide",bookingGuide.getGuideName()+" "+bookingGuide.getGuideMobile()+" "+sg.getLicenseNo());
//		}
		//行程
//		List<GroupRoute> routeList = routeService.selectByGroupId(tourGroup.getId());
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute> routeList = result.getGroupRoutes();
		//商家信息
//		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo> ggpp = null ;
//		if(num==3){
//			ggpp = getOperatorInfo(tourGroup.getId(),null,num) ;
//		}else{
//			ggpp = getOperatorInfo(tourGroup.getId(),bookingGuide.getBookingDetailId(),num) ;
//		}
		model.addAttribute("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("routeList", routeList) ;
		model.addAttribute("imgPath", imgPath) ;
		model.addAttribute("tourGroup", tourGroup) ;
		model.addAttribute("operatorMobile",result.getMobile());
		model.addAttribute("ggpp", ggpp) ;
		model.addAttribute("guestGuideString", guestGuideString) ;
		model.addAttribute("guestIsLeaderString", guestIsLeaderString) ;
		model.addAttribute("driverString", driverString) ;
		model.addAttribute("trans", trans) ;
		model.addAttribute("num", num) ;
		model.addAttribute("id", id) ;
		
		return "sales/preview/guide_group_team" ;
	}
	
	/**
	 * 导游团队出团单,导游散客出团单
	 * @param request
	 * @param groupId
	 * @return
	 */
	public String createGroupOrder(HttpServletRequest request,Integer id,Integer num){
		String realPath = "" ;
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/" + System.currentTimeMillis() + ".doc";
		com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup tourGroup = null ;
		com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide bookingGuide = null ;
		// 查询导游信息
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide> guides = null;
		String guideString = "" ;
		String guestGuideString = "" ;
		String guestIsLeaderString ="" ;
		String driverString ="" ;
		String trans = "" ;
		BookingGuideResult result = null;
		//团信息
		Map<String, Object> map0 = new HashMap<String, Object>();
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo> ggpp = null ;
		if(num==3){
			result = bookingGuideFacade.getGroupRouteInfo(id);
//			tourGroup = tourGroupService.selectByPrimaryKey(id);
//			guides = bookingGuideService.selectGuidesByGroupId(id);
			tourGroup = result.getTourGroup();
			ggpp = getOperatorInfo(tourGroup.getId(),null,num) ;
			guides = result.getBookingGuides();
			guestGuideString = getGuestNameAndMobile(result.getGuestGuides()) ;
			guestIsLeaderString = getGuestNameAndMobile(result.getGuestLeaders()) ;
//			if(guides.size()>0){
//				guideString = getGuides(guides) ;
			guideString = result.getGuideString();
//			}
			//预定车信息
//			List<BookingSupplier> bs4 = supplierService.getBookingSupplierByGroupIdAndSupplierType(id, 4) ;
//			StringBuilder sb = new StringBuilder() ;
//			if(num==3){
//				for (BookingSupplier bs : bs4) {
//					List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//					for (BookingSupplierDetail bsd : details) {
//						sb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//					}
//				}
//			}
			driverString = result.getDriverString();
//			List<GroupOrderTransport> gots = groupOrderTransportService.selectByGroupId(id) ;
			List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> gots = result.getOrderTransports();
			trans = "接机："+getAirInfo(gots, 0)+"\n"
					   +"送机："+getAirInfo(gots, 1)+"\n"
					   +"省内交通："+getSourceType(gots) ;
			map0.put("tourGuide",guideString);
		}else {
			result = bookingGuideFacade.getGroupRouteInfo(id);
			bookingGuide = result.getBookingGuide();
			tourGroup = result.getTourGroup();
			ggpp = getOperatorInfo(tourGroup.getId(),bookingGuide.getBookingDetailId(),num) ;
			//查询导游信息
//			bookingGuide = bookingGuideService.selectByPrimaryKey(id);			
			//团信息
//			tourGroup = tourGroupService.selectByPrimaryKey(bookingGuide.getGroupId());
			guestGuideString = getGuestNameAndMobile(result.getGuestGuides()) ;
			guestIsLeaderString = getGuestNameAndMobile(result.getGuestLeaders()) ;
		
			/**
			 * 如果该导游下面有结对司机，就显示结对司机，如果没有就显示团下面的所有司机
			 */
//			BookingSupplierDetail bsd = detailService.selectByPrimaryKey(id) ;
			StringBuilder sb = new StringBuilder() ;
//			if(null!=bsd && null!=bsd.getDriverId()){
//				sb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+" "+bsd.getCarLisence()+"\n") ;
//				driverString = sb.toString() ;
//			}else{
//				//查询团下所有预定车信息
//				List<BookingSupplier> bs4 = supplierService.getBookingSupplierByGroupIdAndSupplierType(bookingGuide.getGroupId(), 4) ;
//				StringBuilder sb1 = new StringBuilder() ;
//				for (BookingSupplier bs : bs4) {
//					List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//					for (BookingSupplierDetail bsd1 : details) {
//						sb.append(bsd1.getDriverName()+" "+bsd1.getDriverTel()+" "+bsd1.getCarLisence()+"\n") ;
//					}
//				}
//				driverString = sb1.toString() ;
//			}
			driverString = result.getDriverString();
//			List<GroupOrderTransport> gots = groupOrderTransportService.selectByGroupId(tourGroup.getId()) ;
			List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> gots = result.getOrderTransports();
			trans = "接机："+getAirInfo(gots, 0)+"\n"
					   +"送机："+getAirInfo(gots, 1)+"\n"
					   +"省内交通："+getSourceType(gots) ;
			map0.put("tourGuide",bookingGuide.getGuideName()+" "+bookingGuide.getGuideMobile());
		}
		if(tourGroup==null){
			tourGroup = new com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup() ;
		}
		if(bookingGuide==null){
			bookingGuide = new com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide() ;
		}
		realPath = request.getSession().getServletContext()
				.getRealPath("/template/guide_team_Team.docx");
		if(null!=tourGroup && tourGroup.getGroupMode()>0){
			realPath = request.getSession().getServletContext()
					.getRealPath("/template/guide_Group_Team.docx");
		}
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		//logo图片
		Map<String, Object> params = new HashMap<String, Object>();
		setLogo(params, request);
		//团信息
//		Map<String, Object> map0 = new HashMap<String, Object>();
		map0.put("groupCode",tourGroup.getGroupCode());
		map0.put("personNum",tourGroup.getTotalAdult()+"大"+tourGroup.getTotalChild()+"小"+tourGroup.getTotalGuide()+"陪");
		map0.put("operatorName",tourGroup.getOperatorName());
		map0.put("operatorMobile",platformEmployeeService.findByEmployeeId(tourGroup.getOperatorId()).getMobile());
		map0.put("startTime",com.yihg.erp.utils.DateUtils.format(tourGroup.getDateStart()));
		map0.put("guestGuideString",guestGuideString);
		map0.put("guestIsLeaderString",guestIsLeaderString);
		map0.put("driverString",driverString);
		
		//如果是团队、散客导游行程单，显示全部导游
//		if(num==3){
//			map0.put("tourGuide",guideString);
//		}else{
//			map0.put("tourGuide",bookingGuide.getGuideName()+" "+bookingGuide.getGuideMobile());
//		}
		
		map0.put("productName", "【"+tourGroup.getProductBrandName()+"】"+tourGroup.getProductName()) ;
		//计调信息
//		List<GroupGuidePrintPo> ggpp = null ;
//		if(num==3){
//			ggpp = getOperatorInfo(tourGroup.getId(),null,num) ;
//		}else{
//			ggpp = getOperatorInfo(tourGroup.getId(),bookingGuide.getBookingDetailId(),num) ;
//		}
		
		List<Map<String,String>> mapList = new ArrayList<Map<String,String>>();
		for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo ggp : ggpp) {
			Map<String,String> map = new HashMap<String,String>();
			map.put("supplierType",ggp.getSupplierType()) ;
			map.put("supplierName",ggp.getSupplierName()) ;
			map.put("contactWay", ggp.getContacktWay()) ;
			map.put("paymentWay", ggp.getPaymentWay()) ;
			map.put("detail", ggp.getDetail()) ;
			mapList.add(map) ;
		}
		//行程
		List<Map<String,String>>  routeMapList =  getRouteMapList(tourGroup.getId(), tourGroup.getDateStart()) ;
		//备注信息
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("trans",trans);
		map2.put("serviceStandard",tourGroup.getServiceStandard());
		map2.put("remark",tourGroup.getRemark());
		map2.put("remarkInternal",tourGroup.getRemarkInternal());
		try {
			export.export(params);
			export.export(map0, 0);
			export.export(routeMapList,1);
			export.export(map2, 2);
			export.export(mapList, 3);
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
	public String getGuestInfo(List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest> guests) {
		StringBuilder sb = new StringBuilder();
		for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest guest : guests) {
			sb.append(guest.getName() + " " + guest.getMobile() + " "
					+ guest.getCertificateNum() + "/n");
		}
		return sb.toString();
	}

	/**
	 * 返回酒店信息
	 * 
	 * @param grogShopList
	 * @return
	 */
	public String getHotelInfo(List<GroupRequirement> grogShopList) {
		StringBuilder sb = new StringBuilder();
		for (GroupRequirement groupRequirement : grogShopList) {
			sb.append(groupRequirement.getRequireDate() + " "
					+ dicService.getById(groupRequirement.getHotelLevel()).getValue() + " "
					+ groupRequirement.getCountSingleRoom() + "单间" + " "
					+ groupRequirement.getCountDoubleRoom() + "标间" + " "
					+ groupRequirement.getCountTripleRoom() + "三人间");
		}
		return sb.toString();
	}

	/**
	 * 接送信息
	 * 
	 * @param gots
	 * @param flag
	 *            0表示接信息 1表示送信息
	 * @return
	 */
	public String getAirInfo(List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> gots,
			Integer flag) {
		StringBuilder sb = new StringBuilder();
		if (flag == 0) {
			for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport transport : gots) {
				if (transport.getType() == 0 && transport.getSourceType() == 1) {
					sb.append(
						(transport.getDepartureCity()==null?"":transport.getDepartureCity()) + "/"
						+ (transport.getArrivalCity()==null?"":transport.getArrivalCity()) + " "
						+ (transport.getClassNo()==null?"":transport.getClassNo()) + " " 
						+ " 发出时间："+(com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(),"MM-dd")==null?"":com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(),"MM-dd")) 
						+ " "
						+(transport.getDepartureTime()==null?"":transport.getDepartureTime()) + "\n");
				}
			}
		}
		if (flag == 1) {
			for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport transport : gots) {
				if (transport.getType() == 1 && transport.getSourceType() == 1) {
					sb.append(
						(transport.getDepartureCity()==null?"":transport.getDepartureCity()) + "/"
						+ (transport.getArrivalCity()==null?"":transport.getArrivalCity()) + " "
						+ (transport.getClassNo()==null?"":transport.getClassNo()) + " " 
						+ " 发出时间："+(com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(),"MM-dd")==null?"":com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(),"MM-dd")) 
						+ " "
						+(transport.getDepartureTime()==null?"":transport.getDepartureTime()) + "\n");
				}
			}
		}
		return sb.toString();
	}

	/**
	 * 省内交通
	 * 
	 * @param gots
	 * @param flag
	 *            0表示接信息 1表示送信息
	 * @return
	 */
	public String getSourceType(List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> gots) {
		StringBuilder sb = new StringBuilder();
		for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport transport : gots) {
			if (transport.getSourceType() == 0) {
				sb.append(
						(transport.getDepartureCity()==null?"":transport.getDepartureCity()) + "/"
						+ (transport.getArrivalCity()==null?"":transport.getArrivalCity()) + " "
						+ (transport.getClassNo()==null?"":transport.getClassNo()) + " " 
						+ " 发出时间："+ (com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(),"MM-dd")==null?"":com.yihg.erp.utils.DateUtils.format(transport.getDepartureDate(),"MM-dd")) 
						+ " "
						+(transport.getDepartureTime()==null?"":transport.getDepartureTime()) + "\n");
			}
		}
		return sb.toString();
	}
	
	/**
	 * 根据团ID和团开始日期查询当前团的行程信息
	 * @param groupId 团id
	 * @param dateStart 团开始日期
	 * @return 
	 */
	public List<Map<String,String>> getRouteMapList(Integer groupId,Date dateStart){
		/**
		 * 行程列表
		 */
		List<GroupRoute> routeList = routeService.selectByGroupId(groupId);
		List<Map<String,String>> routeMapList = new ArrayList<Map<String,String>>();
		if(routeList!=null && routeList.size()>0){
			for(GroupRoute route:routeList){
				Map<String,String> routeMap = new HashMap<String,String>();
				Date date = DateUtils.addDays(dateStart, route.getDayNum()==null?0:(route.getDayNum()-1));
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
		return routeMapList ;
	}
	
	/**
	 * 商家类别统计，下接社，预定购物，预定房，景区，车
	 * @param groupId 团id
	 * @return
	 */
	public List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo> getOperatorInfo(Integer groupId,Integer id,Integer num){
//		List<GroupGuidePrintPo> pos = new ArrayList<GroupGuidePrintPo>() ;
//		GroupGuidePrintPo po = null ;
//		//预定下接社信息
//		List<BookingDelivery> deliveries = deliveryService.getDeliveryListByGroupId(groupId) ;
//		for (BookingDelivery bd : deliveries) {
//			po = new  GroupGuidePrintPo();
//			po.setSupplierType("下接社");
//			po.setSupplierName(bd.getSupplierName());
//			po.setContacktWay(bd.getContact()+"-"+bd.getContactMobile());
//			po.setPaymentWay("");
//			String dd = "" ;
//			if(bd.getDateArrival()!=null){
//				dd=com.yihg.erp.utils.DateUtils.format(bd.getDateArrival()) ;
//			}
//			po.setDetail(dd+" "+"人数："+bd.getPersonAdult()+"大"+bd.getPersonChild()+"小"+bd.getPersonGuide()+"陪"+"\n");
//			pos.add(po) ;
//		}
//		/*//预定购物
//		List<BookingShop> shops = shopService.getShopListByGroupId(groupId) ;
//		for (BookingShop bs : shops) {
//			po = new  GroupGuidePrintPo();
//			po.setSupplierType("购物店");
//			po.setSupplierName(bs.getSupplierName());
//			po.setContacktWay("");
//			po.setPaymentWay("");
//			po.setDetail(bs.getShopDate());
//			pos.add(po) ;
//		}*/
//		//预订房信息
//		List<BookingSupplier> bs3 = supplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 3) ;
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
//					
//					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate()) ;
//				}
//				sb.append(dd+
//						" 【"+bsd.getType1Name()+"】 "+
//						"("+bsd.getItemNum().toString().replace(".0","")+
//						"-"+bsd.getItemNumMinus().toString().replace(".0","")+")" +"\n");
//			}
//			po.setDetail(sb.toString());
//			pos.add(po) ;
//		}
//		//预定车信息
//		List<BookingSupplier> bs4 = supplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//		if(num==3){
//			for (BookingSupplier bs : bs4) {
//				List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//				StringBuilder sb = new StringBuilder() ;
//				for (BookingSupplierDetail bsd : details) {
//					po = new  GroupGuidePrintPo();
//					po.setSupplierType("司机");
//					po.setSupplierName(bsd.getDriverName());
//					po.setContacktWay(bsd.getDriverTel());
//					po.setPaymentWay(bs.getCashType());
//					if(null!=bs.getRemark() && (!"".equals(bs.getRemark()))){
//						sb.append(bsd.getType1Name()+","+bsd.getType2Name()+"座"+","+bsd.getCarLisence()+",备注："+bs.getRemark()+"\n") ;
//					}else{
//						sb.append(bsd.getType1Name()+","+bsd.getType2Name()+"座"+","+bsd.getCarLisence()+"\n") ;
//					}
//					po.setDetail(sb.toString());
//					pos.add(po) ;
//				}
//			}
//		}else{
//			BookingSupplierDetail bsd = detailService.selectByPrimaryKey(id) ;
//			if(bsd!=null){
//				BookingSupplier bs = bookingSupplierService.selectByPrimaryKey(bsd.getBookingId()) ;
//				StringBuilder sb = new StringBuilder() ;
//				po = new  GroupGuidePrintPo();
//				po.setSupplierType("司机");
//				po.setSupplierName(bsd.getDriverName());
//				po.setContacktWay(bsd.getDriverTel());
//				po.setPaymentWay(bs.getCashType());
//				if(bs.getRemark()!=""&&bs.getRemark()!=null){
//					sb.append(bsd.getType1Name()+","+bsd.getType2Name()+"座"+","+bsd.getCarLisence()+",备注："+bs.getRemark()+"\n") ;
//				}else{
//					sb.append(bsd.getType1Name()+","+bsd.getType2Name()+"座"+","+bsd.getCarLisence()+"\n") ;
//				}
//				po.setDetail(sb.toString());
//				pos.add(po) ;
//			}else{
//				List<BookingSupplier> bsList = supplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 4) ;
//				for (BookingSupplier bs : bsList) {
//					List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
//					StringBuilder sb = new StringBuilder() ;
//					for (BookingSupplierDetail detail : details) {
//						po = new  GroupGuidePrintPo();
//						po.setSupplierType("司机");
//						po.setSupplierName(detail.getDriverName());
//						po.setContacktWay(detail.getDriverTel());
//						po.setPaymentWay(bs.getCashType());
//						if(null!=bs.getRemark() && (!"".equals(bs.getRemark()))){
//							sb.append(detail.getType1Name()+","+detail.getType2Name()+"座"+","+detail.getCarLisence()+",备注："+bs.getRemark()+"\n") ;
//						}else{
//							sb.append(detail.getType1Name()+","+detail.getType2Name()+"座"+","+detail.getCarLisence()+"\n") ;
//						}
//						po.setDetail(sb.toString());
//						pos.add(po) ;
//					}
//				}
//			}
//		}
		
		/*//预定景区信息
		List<BookingSupplier> bs5 = supplierService.getBookingSupplierByGroupIdAndSupplierType(groupId, 5) ;
		for (BookingSupplier bs : bs5) {
			po = new  GroupGuidePrintPo();
			po.setSupplierType("景区");
			po.setSupplierName(bs.getSupplierName());
			po.setContacktWay(bs.getContact()+"-"+bs.getContactMobile());
			po.setPaymentWay(bs.getCashType());
			List<BookingSupplierDetail> details = detailService.selectByPrimaryBookId(bs.getId()) ;
			StringBuilder sb = new StringBuilder() ;
			for (BookingSupplierDetail bsd : details) {
				String dd = "" ;
				if(bsd.getItemDate()!=null){
					dd = com.yihg.erp.utils.DateUtils.format(bsd.getItemDate()) ;
				}
				sb.append(dd+
						" 【"+bsd.getType1Name()+"】 "+
						bsd.getItemPrice().toString().replace(".0","")+
						"*("+bsd.getItemNum().toString().replace(".0","")+
						"-"+bsd.getItemNumMinus().toString().replace(".0","")+")");
			}
			po.setDetail(sb.toString());
			
			pos.add(po) ;
		}*/
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupGuidePrintPo> pos = bookingGuideFacade.getOperatorInfo(groupId, id, num);
		return pos ;
	}
	/**
	 * 组织指定表格的数据list，将数据保存在一个对象list中，方便遍历
	 * @param groupId 团id
	 * @return
	 */
	public List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrintPo> getPrintPoList(Integer groupId){
//		List<GroupOrder> orders = groupOrderService.selectOrderByGroupId(groupId) ;
//		List<GroupOrderPrintPo> gopps = new ArrayList<GroupOrderPrintPo>() ;
//		GroupOrderPrintPo gopp = null ;
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrintPo> gopps = bookingGuideFacade.getPrintPoList(groupId);
		for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrintPo gopp : gopps) {
			com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder order = gopp.getGroupOrder();
//		}
//		for (GroupOrder order : orders) {
			//拿到单条订单信息
//			gopp = new GroupOrderPrintPo() ;
//			gopp.setRemark(order.getRemark());
			//根据散客订单统计人数
//			Integer numAdult = groupOrderGuestService.selectNumAdultByOrderID(order.getId()) ;
//			Integer numChild = groupOrderGuestService.selectNumChildByOrderID(order.getId()) ;
//			gopp.setPersonNum(numAdult+"大"+numChild+"小");
			//根据散客订单统计客人信息
//			List<GroupOrderGuest> guests1 = groupOrderGuestService.selectByOrderId(order.getId()) ;
			List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest> guests = gopp.getGuests();
			gopp.setGuestInfo(getGuestInfo(guests)) ;
			//根据散客订单统计酒店信息
//			List<GroupRequirement> grogShopList = groupRequirementService
//					.selectByOrderAndType(order.getId(), 3);
//			gopp.setHotelInfo(getHotelInfo(grogShopList));
			//根据散客订单统计接机信息
//			List<GroupOrderTransport> groupOrderTransports = groupOrderTransportService
//					.selectByOrderId(order.getId());
			List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> groupOrderTransports = gopp.getOrderTransports();
			gopp.setAirPickup(getAirInfo(groupOrderTransports, 0)) ;
			//根据散客订单统计送机信息
			gopp.setAirOff(getAirInfo(groupOrderTransports,1));
			gopps.add(gopp) ;
		}
		return gopps ;
	}
	
	/**
	 * 打印单的logo标识设置，打印人和打印时间设置
	 * @param params
	 * @param request
	 */
	public void setLogo(Map<String, Object> params,HttpServletRequest request){
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		params.put("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params.put("logo", picMap);
		} else {
			params.put("logo", "");
		}
		params.put("printName", WebUtils.getCurUser(request).getName()) ;
	}
	
	/**
	 * 组织所有导游信息
	 * @param guides
	 * @return
	 */
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
	/**
	 * 组织所有司机信息
	 */
//	public String getDrivers(List<BookingGuide> guides) {
//		StringBuilder sb = new StringBuilder();
//		for (BookingGuide guide : guides) {
//			BookingSupplierDetail bsd = detailService
//					.selectByPrimaryKey(guide.getBookingDetailId());
//			sb.append(bsd.getDriverName()+" "+bsd.getDriverTel()+"\n") ;
//		}
//		return sb.toString() ;
//	}
	
	/**
	 * 导游报账单打印
	 * @param groupId
	 * @param bookingId
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/printDetail.htm")
	public String printDetail(Integer groupId,Integer bookingId,ModelMap model,HttpServletRequest request){
//		TourGroup group = tourGroupService.selectByPrimaryKey(groupId);//团信息
//		BookingGuidesVO guidesVo = bookingGuideService.selectBookingGuideVoByGroupIdAndId(bookingId);
//		
//		HashMap<Object, Object> map =new HashMap<Object, Object>();
//		FinanceGuide financeGuide =new FinanceGuide();
//		financeGuide.setBookingId(bookingId);
//		financeGuide.setGroupId(groupId);
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.selectByGroupId(groupId);
//		for (BookingSupplier bookingSupplier : bookingSuppliers) {
//			financeGuide.setSupplierType(bookingSupplier.getSupplierType());
//			List<BookingSupplier> bookingSupplierList = financeGuideService.getFinanceSupplierByFinanceGuide(financeGuide);
//			getSupplierDetail(bookingSupplierList);
//			map.put(bookingSupplier.getSupplierType(), bookingSupplierList);
//		}
		BookingGuideResult result = bookingGuideFacade.printDetail(groupId, bookingId, WebUtils.getCurBizId(request));
		model.addAttribute("guideName", result.getGuidesVO().getGuide().getGuideName()==null?"":result.getGuidesVO().getGuide().getGuideName());
		model.addAttribute("guideTel", result.getGuidesVO().getGuide().getGuideMobile()==null?"":result.getGuidesVO().getGuide().getGuideMobile());
//		if(null!=guidesVo.getGuide()){
//			SupplierGuide supplierGuide = guideService.getGuideInfoById(guidesVo.getGuide().getGuideId());
			model.addAttribute("bankAccount", result.getSupplierGuide().getBankAccount()==null?"":result.getSupplierGuide().getBankAccount());
//		}
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("printTime", com.yihg.erp.utils.DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		model.addAttribute("group", result.getTourGroup());
		model.addAttribute("map", result.getMap());
		model.addAttribute("supplierTypeMap",SupplierConstant.supplierTypeMap);
		
//		List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
//		List<FinanceCommission> financeCommissionList = financeGuideService.getFinanceCommisionByGroupIdAndGuideId(WebUtils.getCurBizId(request),groupId,guidesVo.getGuide().getGuideId());
		List<com.yimayhd.erpcenter.dal.basic.po.DicInfo> dicInfoList = saleCommonFacade.getCommissionItemListByTypeCode(WebUtils.getCurBizId(request));

		model.addAttribute("dicInfoList", dicInfoList);
		model.addAttribute("financeCommissionList", result.getFinanceCommissions());
		
		return "operation/guide/guide-finance-print";
	}
	
	/**
	 * 导游报账审核购物佣金计算
	 * @param financeGuide
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/financeSupplierGuideView.htm")
	public String financeSupplierGuideView(com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceGuide financeGuide,ModelMap model,HttpServletRequest request){
//		BookingGuide guide= bookingGuideService.selectByPrimaryKey(financeGuide.getBookingId());
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.selectByGroupId(financeGuide.getGroupId());
//		HashMap<Object, Object> map =new HashMap<Object, Object>();
//		for (BookingSupplier bookingSupplier : bookingSuppliers) {
//			financeGuide.setSupplierType(bookingSupplier.getSupplierType());
//			List<BookingSupplier> bookingSupplierList = financeGuideService.getFinanceSupplierByFinanceGuide(financeGuide);
//			//getSupplierDetail(bookingSupplierList);
//			map.put(bookingSupplier.getSupplierType(), bookingSupplierList);
//		}
		BookingGuideResult result = bookingGuideFacade.financeSupplierGuideView(financeGuide, WebUtils.getCurBizId(request));
		model.addAttribute("supplierTypeMap",SupplierConstant.supplierTypeMap);
		
		//List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		List<com.yimayhd.erpcenter.dal.basic.po.DicInfo> dicInfoList = saleCommonFacade.getCommissionItemListByTypeCode(WebUtils.getCurBizId(request));
//		List<FinanceCommission> financeCommissionList = financeGuideService.getFinanceCommisionByGroupIdAndGuideId(WebUtils.getCurBizId(request),financeGuide.getGroupId(),guide.getGuideId());
		model.addAttribute("dicInfoList", dicInfoList);
		List<com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceCommission> financeCommissionList = result.getFinanceCommissions();
		model.addAttribute("financeCommissionList", financeCommissionList);
		BigDecimal count=new BigDecimal(0);
		for (com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceCommission financeCommission : financeCommissionList) {
			count=count.add(financeCommission.getTotal());
		}
		model.addAttribute("count", count);
		
		return "operation/guide/guide-financeSupplierCommsion";
	}
	
	@RequestMapping(value = "/paymentDetail.htm")
	public String paymentDetail(Integer groupId,Integer bookingId,ModelMap model,HttpServletRequest request){
//		TourGroup group = tourGroupService.selectByPrimaryKey(groupId);//团信息
//		BookingGuidesVO guidesVo = bookingGuideService.selectBookingGuideVoByGroupIdAndId(bookingId);
		
		HashMap<Object, Object> map =new HashMap<Object, Object>();
		FinanceGuide financeGuide =new FinanceGuide();
		financeGuide.setBookingId(bookingId);
		financeGuide.setGroupId(groupId);
//		List<BookingSupplier> bookingSuppliers = bookingSupplierService.selectByGroupId(groupId);
//		for (BookingSupplier bookingSupplier : bookingSuppliers) {
//			financeGuide.setSupplierType(bookingSupplier.getSupplierType());
//			List<BookingSupplier> bookingSupplierList = financeGuideService.getFinanceSupplier(financeGuide);
//			getSupplierDetail(bookingSupplierList);
//			map.put(bookingSupplier.getSupplierType(), bookingSupplierList);
//		}
		
//		PageBean commPageBean = new PageBean();
//		Map<String,Object> commMap  = new HashMap<String, Object>();
//		commMap.put("groupId", groupId);
//		commMap.put("guideId", guidesVo.getGuide().getGuideId());
//		commPageBean.setParameter(commMap);
		BookingGuideResult result = bookingGuideFacade.paymentDetail(groupId, bookingId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("guideId", result.getGuidesVO().getGuide().getGuideId());
		
//		List<FinanceCommission> guideComms = financeGuideService.getCommisions(commPageBean);
		model.addAttribute("guideComms", result.getFinanceCommissions());
		
//		List<FinanceCommission> guideCommDeductions = financeGuideService.getCommisionDeductions(commPageBean);
		model.addAttribute("guideCommDeductions", result.getGuideCommDeductions());
		
		model.addAttribute("guideName", result.getGuidesVO().getGuide().getGuideName());
		model.addAttribute("group", result.getTourGroup());
		model.addAttribute("map", map);
		model.addAttribute("supplierTypeMap",SupplierConstant.supplierTypeMap);
		
//		List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		//List<com.yimayhd.erpcenter.dal.basic.po.DicInfo> dicInfoList = saleCommonFacade.getCommissionItemListByTypeCode(WebUtils.getCurBizId(request));

		DicListResult dicListResult = saleCommonFacade.getDicList(WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicListResult.getCommissionTypes());
		
//		List<DicInfo> bankList = dicService
//				.getListByTypeCode(BasicConstants.SUPPLIER_BANK);
		model.addAttribute("bankList", dicListResult.getBankList());
//		List<DicInfo> payTypeList = dicService.getListByTypeCode(BasicConstants.CW_ZFFS);
		model.addAttribute("payTypeList", dicListResult.getPayChannels());
		
//		List<SysBizBankAccount> bizAccountList = sysBizBankAccountService.getListByBizId(WebUtils.getCurBizId(request));
		model.addAttribute("bizAccountList", dicListResult.getBizAccountList());
		
		model.addAttribute("pay_user_name",WebUtils.getCurUser(request).getName());
		
		return "operation/guide/guide-finance-payment";
	}
	
}
