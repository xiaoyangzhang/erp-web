package com.yihg.erp.controller.agency;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.result.RegionResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TeamGroupVO;
import com.yimayhd.erpcenter.facade.sales.query.FindTourGroupByConditionDTO;
import com.yimayhd.erpcenter.facade.sales.query.ToAddTeamGroupInfoDTO;
import com.yimayhd.erpcenter.facade.sales.result.AgencyOrderResult;
import com.yimayhd.erpcenter.facade.sales.result.FindTourGroupByConditionResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.ToAddTeamGroupInfoResult;
import com.yimayhd.erpcenter.facade.sales.result.ToRequirementResult;
import com.yimayhd.erpcenter.facade.sales.result.WebResult;
import com.yimayhd.erpcenter.facade.sales.service.AgencyTeamFacade;
import com.yimayhd.erpcenter.facade.sales.service.TeamGroupFacade;

@Controller
@RequestMapping(value = "/agencyTeam")
public class AgencyTeamController extends BaseController {
	private static final Logger log = LoggerFactory.getLogger(AgencyTeamController.class);

	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private AgencyTeamFacade agencyTeamFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@Autowired
	private TeamGroupFacade teamGroupFacade;
	/**
	 * 组团销售：团队订单（未确认团、已确认团）
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toGroupList.htm")
	@RequiresPermissions(PermissionConstants.XSGL_TDGL_ZTS)
	public String toGroupList(HttpServletRequest request, Model model) {
		Integer bizId = WebUtils.getCurBizId(request);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince",regionResult.getRegionList());
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		List<DicInfo> sourceTypeList = saleCommonFacade.getGuestSourceTypes(bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		return "agency/teamGroup/groupList";
	}
	
	/**
	 * 计调管理：团队订单（未确认团、已确认团）
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toOperateGroupList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_TDGL_ZTS)
	public String toOperateGroupList(HttpServletRequest request, Model model) {
		Integer bizId = WebUtils.getCurBizId(request);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("allProvince", allProvince);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		RegionResult regionResult = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince",regionResult.getRegionList());
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "agency/teamGroup/groupList";
	}
	
	/**
	 * 获取团队列表数据
	 * 
	 * @param request
	 * @param groupOrder
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("findTourGroupLoadModel.do")
	// @RequiresPermissions(PermissionConstants.XSGL_TDGL_ZTS)
	public String findTourGroupByConditionLoadModel(HttpServletRequest request,
			GroupOrder groupOrder, Model model, Boolean isSales) throws ParseException {

	//	PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();

//		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
//				: groupOrder.getPageSize());
//		pageBean.setPage(groupOrder.getPage());

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
//		groupOrder.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(groupOrder.getSaleOperatorIds(),
//				groupOrder.getOrgIds(), WebUtils.getCurBizId(request)));
//		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//			if (groupOrder.getStartTime() != null
//					&& groupOrder.getStartTime() != "") {
//				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime())
//						.getTime() + "");
//			}
//			if (groupOrder.getEndTime() != null
//					&& groupOrder.getEndTime() != "") {
//				Calendar calendar = new GregorianCalendar();
//				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
//				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
//				groupOrder.setEndTime(calendar.getTime().getTime() + "");
//			}
//		}
		Integer listType = isSales != null && isSales.booleanValue() ? 1 : 0; 
	//	pageBean.setParameter(groupOrder);
		FindTourGroupByConditionDTO queryDTO = new FindTourGroupByConditionDTO();
		queryDTO.setCurBizId(WebUtils.getCurBizId(request));
		queryDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setOperatorType(listType);
		queryDTO.setGroupOrder(groupOrder);
		FindTourGroupByConditionResult result = teamGroupFacade.findTourGroupByConditionLoadModel(queryDTO);
//		pageBean = groupOrderService.selectByConListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request), listType);
		
//		Integer pageTotalAudit = 0;
//		Integer pageTotalChild = 0;
//		Integer pageTotalGuide = 0;
//		List<GroupOrder> orderList = pageBean.getResult();
//		if (!CollectionUtils.isEmpty(orderList)) {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//			for (GroupOrder groupOrder2 : orderList) {
//				if (groupOrder2.getCreateTime() != null) {
//					Long createTime = groupOrder2.getTourGroup()
//							.getCreateTime();
//					String dateStr = sdf.format(createTime);
//					groupOrder2.getTourGroup().setCreateTimeStr(dateStr);
//				}
//				if (groupOrder2.getTourGroup().getUpdateTime() != null) {
//					Long updateTime = groupOrder2.getTourGroup()
//							.getUpdateTime();
//					String dateStr = sdf.format(updateTime);
//					groupOrder2.getTourGroup().setUpdateTimeStr(dateStr);
//				} else {
//					groupOrder2.getTourGroup().setUpdateTimeStr("无");
//					groupOrder2.getTourGroup().setUpdateName("无");
//				}
//				pageTotalAudit += groupOrder2.getNumAdult();
//				pageTotalChild += groupOrder2.getNumChild();
//				pageTotalGuide += groupOrder2.getNumGuide();
//			}
//		}

		model.addAttribute("pageTotalAudit", result.getPageTotalAudit());
		model.addAttribute("pageTotalChild", result.getPageTotalChild());
		model.addAttribute("pageTotalGuide", result.getPageTotalGuide());
//		GroupOrder order = groupOrderService.selectTotalByCon(groupOrder,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request), listType);
		GroupOrder order = result.getGroupOrder();
		model.addAttribute("totalAudit",
				order == null ? 0 : order.getNumAdult());
		model.addAttribute("totalChild",
				order == null ? 0 : order.getNumChild());
		model.addAttribute("totalGuide",
				order == null ? 0 : order.getNumGuide());

		/**
		 * 根据组团社id获取组团社名称
		 */
		List<GroupOrder> groupList = result.getPageBean().getResult();
		model.addAttribute("groupList", result.getPageBean().getResult());
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("page", result.getPageBean());

		return "agency/teamGroup/groupTable";
	}
	
	@RequestMapping(value = "toEditTeamGroupInfo.htm")
	public String toEditTeamGroupInfo(HttpServletRequest request, Model model,
			Integer groupId, Integer operType) {
		model.addAttribute("isEdit", true);
		model.addAttribute("operType", operType);
		AgencyOrderResult result = agencyTeamFacade.toEditTeamGroupInfo(groupId,WebUtils.getCurBizId(request));
//		TeamGroupVO teamGroupVO = teamGroupFacade.selectTeamGroupVOByGroupId(groupId, WebUtils.getCurBizId(request));
		model.addAttribute("teamGroupVO", result.getTeamGroupVO());
		int bizId = WebUtils.getCurBizId(request);
//		List<DicInfo> typeList = dicService				
//				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);		
		List<DicInfo> typeList = saleCommonFacade.getTeamTypesByTypeCode(bizId);
		model.addAttribute("typeList", typeList);
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_AGENCY_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", saleCommonFacade.getGuestSourceTypes(bizId));
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", productCommonFacade.queryProvinces().getRegionList());
		model.addAttribute("config", config);
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", saleCommonFacade.getTransportListByTypeCode(bizId));
//		List<DicInfo> zjlxList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", saleCommonFacade.getCertificateTypesByTypeCode());
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
//				BasicConstants.GYXX_LYSFXM, WebUtils.getCurBizId(request));
		model.addAttribute("lysfxmList", saleCommonFacade.getFeeItems2(bizId));
//		List<RegionInfo> cityList = null;
//		if (teamGroupVO.getGroupOrder().getProvinceId() != null
//				&& teamGroupVO.getGroupOrder().getProvinceId() != -1) {
//			cityList = regionService.getRegionById(teamGroupVO.getGroupOrder()
//					.getProvinceId() + "");
//		}
		model.addAttribute("allCity", result.getRegionList());
//		String guideStr="";
//		List<GroupOrderGuest> guestList = groupOrderGuestService.selectByOrderId(teamGroupVO.getGroupOrder().getId());
//		if(guestList!=null){
//			for (GroupOrderGuest groupOrderGuest : guestList) {
//				if(groupOrderGuest.getType()==3){
//					guideStr=("".equals(guideStr)?"":(guideStr+" | "))+groupOrderGuest.getName()+" "+groupOrderGuest.getMobile();
//				}
//			}
//		}
		model.addAttribute("guideStr", result.getGuideStr());
		
//		List<Map<String, Object>> payDetails = financeService.selectDetailByLocOrderId(teamGroupVO.getGroupOrder().getId());
		
//		if(payDetails != null && payDetails.size() > 0){
//			Map<String, Object> detail = null;
//			for(int i = 0; i < payDetails.size(); i++){
//				detail = payDetails.get(i);
//				Object userId = detail.get("user_id"); 
//				if(userId == null){
//					continue;
//				}
//				PlatformEmployeePo employeePo = platformEmployeeService.findByEmployeeId(Integer.parseInt(userId.toString()));
//				PlatformOrgPo orgPo = orgService.findByOrgId(employeePo.getOrgId());
//				detail.put("department", orgPo.getName());
//			}
//		}
		model.addAttribute("payDetails", result.getMapList());
		
//		List<DicInfo> guestSource = dicService
//				.getListByTypeCode(BasicConstants.GYXX_GUESTSOURCE,bizId);
		model.addAttribute("guestSource", saleCommonFacade.getGuestSourcesByTypeCode(bizId));
		
		return "agency/teamGroup/teamGroupInfo";
	}
	
	@RequestMapping(value = "toAddTeamGroupInfo.htm")
	public String toAddTeamGroupInfo(HttpServletRequest request, Model model) {
		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		TeamGroupVO teamGroupVO = new TeamGroupVO();
		teamGroupVO.setGroupOrder(groupOrder);
		model.addAttribute("teamGroupVO", teamGroupVO);
		int bizId = WebUtils.getCurBizId(request);
		ToAddTeamGroupInfoDTO queryDTO = new ToAddTeamGroupInfoDTO();
		queryDTO.setCurBizId(bizId);
		queryDTO.setGroupOrder(groupOrder);
		ToAddTeamGroupInfoResult result = teamGroupFacade.toAddTeamGroupInfo(queryDTO);
		// 收费类型
//		List<DicInfo> typeList = dicService
//				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		model.addAttribute("typeList", result.getTypeList());
//		List<DicInfo> sourceTypeList = dicService
//				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
//		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("config", config);
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", result.getJtfsList());
//		List<DicInfo> zjlxList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", result.getZjlxList());
//		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
//				BasicConstants.GYXX_LYSFXM, WebUtils.getCurBizId(request));
		queryDTO.setCurBizId(bizId);
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("operType", "1");
		model.addAttribute("isEdit", false);
		model.addAttribute("guestSource", saleCommonFacade.getGuestSourcesByTypeCode(bizId));
		return "agency/teamGroup/teamGroupInfo";

	}
	
	/**
	 * 删除订单
	 * 
	 * @param orderId
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/deleteGroupOrderById")
	@ResponseBody
	public String deleteGroupOrderById(HttpServletRequest request, Integer orderId, Integer groupId,
			Model model) {
		
//		if(financeService.hasAuditOrder(groupId)){
//			return errorJson("该团有已审核的订单,不允许删除！");
//		}
//		
//		if(financeService.hasPayOrIncomeRecord(groupId)){
//			return errorJson("该团有收付款记录,不允许删除！");
//		}
//		if (airTicketRequestService.doesOrderhaveRequested(WebUtils.getCurBizId(request), orderId)){
//			return errorJson("删除订单前请先取消机票申请。");
//		}
//		
//		int i = tourGroupService.deleteTourGroupById(groupId, orderId);
//		if (i == 1) {
//			return successJson();
//		} else {
//			return errorJson("服务器忙！");
//		}
		ResultSupport result = agencyTeamFacade.deleteGroupOrderById(orderId, groupId, WebUtils.getCurBizId(request));
		return result.isSuccess() ? successJson() : errorJson(result.getResultMsg());
	}
	
	@RequestMapping(value = "saveTeamGroupInfo.do")
	@ResponseBody
	public String saveTeamGroupInfo(HttpServletRequest request,
			TeamGroupVO teamGroupVO) throws ParseException {
		
//		ProductInfo productInfo = productInfoService.findProductInfoById(teamGroupVO.getGroupOrder().getProductId());
		
		if(teamGroupVO.getTourGroup().getId()==null){
			teamGroupVO.getTourGroup().setGroupCode(settingCommon.getMyBizCode(request));
			teamGroupVO.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
//			if(productInfo != null){
//				teamGroupVO.setProductCode(productInfo.getCode());
//			}
		}
//		else{	
//			TourGroup tourGroup = teamGroupVO.getTourGroup();
//			TourGroup group=tourGroupService.selectByPrimaryKey(tourGroup.getId());
//			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			
//			String productInfoCode = "";
//			if(productInfo != null){
//				String brandName = productInfo.getBrandName() != null ? productInfo.getBrandName() : "";
//				String nameCity = productInfo.getNameCity() != null ? productInfo.getNameCity() : "";
//				GroupOrder order = teamGroupVO.getGroupOrder();
//				if(order != null && brandName.equals(order.getProductBrandName()) && nameCity.equals(order.getProductName())){
//					productInfoCode = productInfo.getCode();
//				}
//			}
//			
//			tourGroup.setGroupCode(GroupCodeUtil.getCodeForAgency(settingCommon.getMyBizCode(request),
//					tourGroup.getGroupCode(), tourGroup.getGroupCodeMark(),productInfoCode,
//							sdf1.format(group.getDateStart()),sdf1.format(group.getDateEnd())));
//		}
		
		teamGroupVO.setAgency(true);
//		TeamGroupVO tgv = teamGroupFacade.saveOrUpdateTeamGroupVO(WebUtils.getCurBizId(request), WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName(), teamGroupVO);
		WebResult<Integer> result = agencyTeamFacade.saveTeamGroupInfo(teamGroupVO, WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getName(),
				WebUtils.getCurUserId(request), settingCommon.getMyBizCode(request));
		return successJson("groupId",result.getValue()+"");
	}
	
	/**
	 * 跳转到组团新增中计调需求页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toRequirement.htm", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.XSGL_TDGL_ZTS)
	public String toRequirement(Integer orderId,Model model,Integer operType) {

		ToRequirementResult result = teamGroupFacade.toRequirement(orderId, operType);
//		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
//		// 车辆型号
//		List<DicInfo> ftcList = dicService
//				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("ftcList", result.getFtcList());
//		// 酒店星级
//		List<DicInfo> jdxjList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", result.getJdxjList());
//		// 酒店信息
//		List<GroupRequirement> hotelList = groupRequirementService
//				.selectByOrderAndType(orderId, 3);
		model.addAttribute("hotelList", result.getHotelList());
//		// 车队信息
//		List<GroupRequirement> fleetList = groupRequirementService
//				.selectByOrderAndType(orderId, 4);
		model.addAttribute("fleetList", result.getFleetList());
//		// 机票信息
//		List<GroupRequirement> airTicketList = groupRequirementService
//				.selectByOrderAndType(orderId, 9);
		model.addAttribute("airTicketList", result.getAirTicketList());
//		// 火车信息
//		List<GroupRequirement> railwayTicketList = groupRequirementService
//				.selectByOrderAndType(orderId, 10);
		model.addAttribute("railwayTicketList", result.getRailwayTicketList());
//		// 导游信息
//		List<GroupRequirement> guideList = groupRequirementService
//				.selectByOrderAndType(orderId, 8);
		model.addAttribute("guideList", result.getGuideList());
//		// 餐厅信息
//		List<GroupRequirement> restaurantList = groupRequirementService
//				.selectByOrderAndType(orderId, 2);
		model.addAttribute("restaurantList", result.getRestaurantList());
		model.addAttribute("orderId", orderId);
		model.addAttribute("groupId", result.getGroupId());
		model.addAttribute("operType",operType);
		return "agency/teamGroup/groupRequirement";
	}
	
	@RequestMapping(value = "/saveRequireMent.do")
	@ResponseBody
	public String saveRequireMent(HttpServletRequest request,TeamGroupVO teamGroupVO){
//		teamGroupService.saveOrUpdateRequirement(teamGroupVO, WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getName());
		ResultSupport resultSupport = teamGroupFacade.saveOrUpdateRequirement(teamGroupVO, WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getName());
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败");
	}
}
