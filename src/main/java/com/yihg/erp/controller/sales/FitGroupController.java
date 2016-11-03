package com.yihg.erp.controller.sales;

import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

//import com.yihg.basic.contants.BasicConstants;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.GroupCodeUtil;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
//import com.yihg.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.FitGroupInfoVO;
import com.yimayhd.erpcenter.facade.sales.query.FitGroupInfoQueryDTO;
import com.yimayhd.erpcenter.facade.sales.query.FitGroupInfoUpdateDTO;
import com.yimayhd.erpcenter.facade.sales.query.FitTotalSKGroupQueryDTO;
import com.yimayhd.erpcenter.facade.sales.query.FitUpdateTourGroupDTO;
import com.yimayhd.erpcenter.facade.sales.query.grouporder.ToSecImpNotGroupListDTO;
import com.yimayhd.erpcenter.facade.sales.result.BaseStateResult;
import com.yimayhd.erpcenter.facade.sales.result.FitGroupInfoQueryResult;
import com.yimayhd.erpcenter.facade.sales.result.FitTotalSKGroupQueryResult;
import com.yimayhd.erpcenter.facade.sales.result.grouporder.ToSecImpNotGroupListResult;
import com.yimayhd.erpcenter.facade.sales.service.FitGroupFacade;

@Controller
@RequestMapping(value = "/fitGroup")
public class FitGroupController extends BaseController {

////	@Autowired
////	private PlatformOrgService orgService;
//	@Autowired
//	private DicService dicService;
	
	//FIXME 好像是应用web中的东西，暂放
	@Autowired
	private SysConfig config;
	
//	@Autowired
//	private FitGroupService fitGroupService;
//	@Autowired
//	private TourGroupService tourGroupService;
//	@Autowired
//	private GroupOrderService groupOrderService;
////	@Autowired
////	private PlatformEmployeeService platformEmployeeService;
//	@Autowired
//	private FinanceService financeService;
////	@Autowired
////	private BookingGuideService bookingGuideService;
//	@Autowired
//	private BookingSupplierService bookingSupplierService ;
	
	@Autowired
	private FitGroupFacade fitGroupFacade;
	
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
//		List<GroupOrder> glist = groupOrderService
//				.selectOrderByGroupId(groupId);
//		List<String> datelist = new ArrayList<String>();
//		List<Integer> productlist = new ArrayList<Integer>();
//		List<Integer> statelist = new ArrayList<Integer>();
//		if (glist != null && glist.size() > 0) {
//			datelist.add(glist.get(0).getDepartureDate());
//		}
//		String[] split = ids.split(",");
//		for (String id : split) {
//			datelist.add(groupOrderService.findById(Integer.parseInt(id))
//					.getDepartureDate());
//			productlist.add(groupOrderService.findById(Integer.parseInt(id))
//					.getProductId());
//			statelist.add(groupOrderService.findById(Integer.parseInt(id))
//					.getStateFinance());
//		}
//		for (String str : split) {
//			tourGroupService.addFitOrder(groupId, Integer.parseInt(str));
//		}
//		return successJson();
		
		fitGroupFacade.addOrderToTourGroup(groupId,ids);
		
		return successJson();
	}

	
	/**
	 * 修改散客团信息
	 * 
	 * @param request
	 * @param reponse
	 * @param tourGroup
	 * @return
	 */
	@RequestMapping(value = "changeState.do")
	@ResponseBody
	public String changeState(HttpServletRequest request,
			HttpServletResponse reponse, TourGroup tourGroup) {
//		if(tourGroup.getGroupState()==2){
//			List<FinanceCommission> fc1=groupOrderService.selectFinanceCommissionByGroupId(tourGroup.getId());
//			if (fc1 != null && fc1.size() > 0) {
//						return "该团已有购物及佣金被审核！";
//			}
//			List<FinanceCommission> fc2=groupOrderService.selectFCByGroupId(tourGroup.getId());
//			if (fc2 != null && fc2.size() > 0) {
//						return "该团已有购物及佣金被审核！";
//			}
//			}
//		tourGroupService.updateByPrimaryKeySelective(tourGroup);
//		return successJson();
		
		FitUpdateTourGroupDTO fitUpdateTourGroupDTO=new FitUpdateTourGroupDTO();
		fitUpdateTourGroupDTO.setTourGroup(tourGroup);
		
		BaseStateResult result = fitGroupFacade.updateFitTourGroup(fitUpdateTourGroupDTO);
		if(!result.isSuccess()){
			errorJson(result.getError());
		}
		return successJson();
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
		
//		if(financeService.hasAuditOrder(groupId)){
//			return errorJson("该团有已审核的订单,不允许删除！");
//		}
//		
//		if(financeService.hasPayOrIncomeRecord(groupId)){
//			return errorJson("该团有收付款记录,不允许删除！");
//		}
//		if(financeService.hasHotelOrder(groupId)){
//			return errorJson("该团有酒、车队订单,不允许删除！");
//		}
//		tourGroupService.delFitTourGroup(groupId);
//		return successJson();
		
		BaseStateResult result = fitGroupFacade.delFitTourGroup(groupId);
		if(!result.isSuccess()){
			errorJson(result.getError());
		}
		return successJson();
		
	}

	//合团
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
//		pageBean.setPage(groupOrder.getPage()==null?1:groupOrder.getPage());
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
		
		
		ToSecImpNotGroupListResult result=fitGroupFacade.toSecImpNotGroupList(toSecImpNotGroupListDTO);
		
		model.addAttribute("pp", result.getPp());
		model.addAttribute("groupOrder", result.getGroupOrder());
		model.addAttribute("groupId", gid);
		model.addAttribute("page", result.getPageBean());
	
		return "sales/fitGroup/secImpNotGroupOrder";
	}
	
	@RequestMapping(value = "updateFitGroupInfo.do")
	@ResponseBody
	public String updateFitGroupInfo(HttpServletRequest request,FitGroupInfoVO fitGroupInfoVO){
		
//		TourGroup tourGroup = fitGroupInfoVO.getTourGroup();
//		TourGroup group=tourGroupService.selectByPrimaryKey(fitGroupInfoVO.getTourGroup().getId());
//		tourGroup.setGroupCode(GroupCodeUtil.getCode(tourGroup.getGroupCode(), tourGroup.getGroupCodeMark()));
//		fitGroupService.updateFitGroupInfo(fitGroupInfoVO,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName());
//		if(!group.getOperatorId().equals(tourGroup.getOperatorId())){
//			
//			List<GroupOrder> orderList = groupOrderService.selectOrderByGroupIdAndBizId(group.getId(), group.getBizId());
//			if(orderList!=null){
//				for (GroupOrder groupOrder : orderList) {
//					groupOrder.setOperatorId(tourGroup.getOperatorId());
//					groupOrder.setOperatorName(tourGroup.getOperatorName());
//					groupOrderService.updateGroupOrder(groupOrder);
//				}
//			}
//		}
		
		TourGroup   tourGroup = fitGroupInfoVO.getTourGroup();
		tourGroup.setGroupCode(GroupCodeUtil.getCode(tourGroup.getGroupCode(), tourGroup.getGroupCodeMark()));
		
		
		Integer userId = WebUtils.getCurUserId(request);
		String userName = WebUtils.getCurUser(request).getName();
		
		FitGroupInfoUpdateDTO fitGroupInfoUpdateDTO=new FitGroupInfoUpdateDTO();
		fitGroupInfoUpdateDTO.setUserId(userId);
		fitGroupInfoUpdateDTO.setUserName(userName);
		fitGroupInfoUpdateDTO.setFitGroupInfoVO(fitGroupInfoVO);
		
		fitGroupFacade.updateFitGroupInfo(fitGroupInfoUpdateDTO);
		
		return  successJson();
	}
	
	/**
	 * 从散客团里删除散客订单
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delFitOrder.do")
	@ResponseBody
	public String delFitOrder(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		
//		tourGroupService.delFitOrder(id);
//		bookingSupplierService.upateGroupIdAfterDelOrderFromGroup(id);
		
		fitGroupFacade.delFitOrder(id);
		
		return successJson();
	}
	
	
	/**
	 * 从散客团里批量删除散客订单
	 * 
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delFitOrderMany.do")
	@ResponseBody
	public String delFitOrderMany(HttpServletRequest request,
			HttpServletResponse reponse, String ids) {
		
//		String[] split = ids.split(",");
//		for (int i = 0; i < split.length; i++) {
//			tourGroupService.delFitOrder(Integer.parseInt(split[i]));
//			bookingSupplierService.upateGroupIdAfterDelOrderFromGroup(Integer.parseInt(split[i]));
//		}
		
		fitGroupFacade.delFitOrderBatch(ids);
		
		return successJson();
	}
	

	@RequestMapping(value = "toFitGroupInfo.htm")
	public String toFitGroupInfo(HttpServletRequest request,
			HttpServletResponse reponse, 
			ModelMap model, 
			Integer groupId,
			Integer operType) {

//		//operType=0查看   ||  operType=1编辑
//		FitGroupInfoVO fitGroupInfoVO = fitGroupService
//				.selectFitGroupInfoById(groupId);
//		model.addAttribute("fitGroupInfoVO", fitGroupInfoVO);
//		model.addAttribute("operType", operType);
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
//		model.addAttribute("ppList", pp);
//		model.addAttribute("config", config);
		
		FitGroupInfoQueryDTO fitGroupInfoQueryDTO=new FitGroupInfoQueryDTO();
		fitGroupInfoQueryDTO.setCurBizId(WebUtils.getCurBizId(request));
		fitGroupInfoQueryDTO.setGroupId(groupId);
		fitGroupInfoQueryDTO.setTypeCode(BasicConstants.CPXL_PP);
		
		FitGroupInfoQueryResult result = fitGroupFacade.toFitGroupInfo(fitGroupInfoQueryDTO);
		
		model.addAttribute("fitGroupInfoVO", result.getFitGroupInfoVO());
		model.addAttribute("operType", operType);
		model.addAttribute("ppList", result.getPp());
		model.addAttribute("config", config);
		
		return "sales/fitGroup/fitGroupInfo";
	}

	/**
	 * 跳转到散客团列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param tourGroup
	 * @return
	 */
	@RequestMapping(value = "toFitGroupList.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_TEAM)
	public String toFitGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, TourGroup tourGroup) {
		
//		if (null == tourGroup.getStartTime() && null == tourGroup.getEndTime()) {
//			Calendar c = Calendar.getInstance();
//			int year = c.get(Calendar.YEAR);
//			int month = c.get(Calendar.MONTH);
//			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//			c.set(year, month, 1, 0, 0, 0);
//			tourGroup.setStartTime(c.getTime());
//			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
//			tourGroup.setEndTime(c.getTime());
//
//		}
//		if (null == tourGroup.getGroupState()) {
//			tourGroup.setGroupState(-2);
//		}
//		PageBean pageBean = new PageBean();
//		pageBean.setPageSize(tourGroup.getPageSize() == null ? Constants.PAGESIZE
//				: tourGroup.getPageSize());
//		pageBean.setPage(tourGroup.getPage());
//
//		// 如果人员为空并且部门不为空，则取部门下的人id
//		if (StringUtils.isBlank(tourGroup.getOperatorIds())
//				&& StringUtils.isNotBlank(tourGroup.getOrgIds())) {
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = tourGroup.getOrgIds().split(",");
//			for (String orgIdStr : orgIdArr) {
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(
//					WebUtils.getCurBizId(request), set);
//			String operatorIds = "";
//			for (Integer usrId : set) {
//				operatorIds += usrId + ",";
//			}
//			if (!operatorIds.equals("")) {
//				tourGroup.setOperatorIds(operatorIds.substring(0,
//						operatorIds.length() - 1));
//			}
//		}
//		pageBean.setParameter(tourGroup);
//		pageBean = tourGroupService.selectSKGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		
//		List<TourGroup> result = pageBean.getResult();
//		if (result != null && result.size() > 0) {
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//			for (TourGroup t : result) {
//				if (t.getCreateTime() != null) {
//					Long createTime = t.getCreateTime();
//					String dateStr = sdf.format(createTime);
//					t.setCreateTimeStr(dateStr);
//				}
//				if (t.getUpdateTime() != null) {
//					Long updateTime = t.getUpdateTime();
//					String dateStr = sdf.format(updateTime);
//					t.setUpdateTimeStr(dateStr);
//				} else {
//					t.setUpdateTimeStr("无");
//					t.setUpdateName("无");
//				}
//				List<BookingGuide> guideList = bookingGuideService.selectGuidesByGroupId(t.getId());
//				t.setGuideList(guideList);
//			}
//		}
//		
//		TourGroup group = tourGroupService.selectTotalSKGroup(tourGroup,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		model.addAttribute("group", group);
//		model.addAttribute("page", pageBean);
//		model.addAttribute("tourGroup", tourGroup);
//		Integer bizId = WebUtils.getCurBizId(request);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
//		return "sales/fitGroup/fitGroupList";
		
		
		Integer bizId = WebUtils.getCurBizId(request);
		Set<Integer> userIdSet = WebUtils.getDataUserIdSet(request);
		
		FitTotalSKGroupQueryDTO  totalSKGroupQueryDTO=new FitTotalSKGroupQueryDTO();
		totalSKGroupQueryDTO.setBizId(bizId);
		totalSKGroupQueryDTO.setTourGroup(tourGroup);
		totalSKGroupQueryDTO.setUserIdSet(userIdSet);
		
		FitTotalSKGroupQueryResult result=fitGroupFacade.toFitGroupList(totalSKGroupQueryDTO);
		
		model.addAttribute("group", result.getGroup());
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("tourGroup", result.getTourGroup());		
		model.addAttribute("orgJsonStr",result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "sales/fitGroup/fitGroupList";
	}
}
