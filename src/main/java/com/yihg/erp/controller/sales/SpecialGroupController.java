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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.MergeGroupOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SpecialGroupOrderVO;
import com.yimayhd.erpcenter.facade.sales.result.ToAddSpecialGroupResult;
import com.yimayhd.erpcenter.facade.sales.service.SpecialGroupFacade;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.common.MergeGroupUtils;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;

@Controller
@RequestMapping("/specialGroup")
public class SpecialGroupController extends BaseController {
	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private SpecialGroupFacade specialGroupFacade;
	@Autowired
	private BizSettingCommon bizSettingCommon;
	/**
	 * 跳转到一地散添加页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toAddSpecialGroup.htm")
	public String toAddSpecialGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model){
		/*model.addAttribute("operType", 1);
		GroupOrder groupOrder  = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		SpecialGroupOrderVO  vo = new SpecialGroupOrderVO();
		vo.setGroupOrder(groupOrder);
		model.addAttribute("vo", vo);
		int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		model.addAttribute("config", config);
		return "sales/specialGroup/specialGroupInfo";*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.toAddSpecialGroup(WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName(), WebUtils.getCurBizId(request));
		model.addAttribute("operType", 1);
		model.addAttribute("vo", toAddSpecialGroupResult.getSpecialGroupOrderVO());
		model.addAttribute("jdxjList", toAddSpecialGroupResult.getJdxjList());
		model.addAttribute("jtfsList", toAddSpecialGroupResult.getJtfsList());
		model.addAttribute("zjlxList", toAddSpecialGroupResult.getZjlxList());
		model.addAttribute("sourceTypeList", toAddSpecialGroupResult.getSourceTypeList());
		model.addAttribute("allProvince", toAddSpecialGroupResult.getAllProvince());
		model.addAttribute("lysfxmList", toAddSpecialGroupResult.getLysfxmList());
		model.addAttribute("config", config);
		return "sales/specialGroup/specialGroupInfo";
	}
	@RequestMapping(value = "toEditSpecialGroup.htm")
	public String toEditSpecialGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id,Integer operType){
		/*if(operType==null){
			operType=1;
		}
		model.addAttribute("operType", operType);
		SpecialGroupOrderVO  vo= specialGroupOrderService.selectSpeciaOrderlInfoByOrderId(id);
		model.addAttribute("vo", vo);
		List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("config", config);
		List<RegionInfo> cityList = null;
		if(vo.getGroupOrder().getProvinceId()!=null && vo.getGroupOrder().getProvinceId()!=-1){
			cityList=regionService.getRegionById(vo.getGroupOrder().getProvinceId()+"");
		}
		model.addAttribute("allCity", cityList);
		String guideStr="";
		List<GroupOrderGuest> guestList = groupOrderGuestService.selectByOrderId(id);
		if(guestList!=null){
			for (GroupOrderGuest groupOrderGuest : guestList) {
				if(groupOrderGuest.getType()==3){
					guideStr=("".equals(guideStr)?"":(guideStr+" | "))+groupOrderGuest.getName()+" "+groupOrderGuest.getMobile();
				}
			}
		}
		model.addAttribute("guideStr", guideStr);
		
		
		
		return "sales/specialGroup/specialGroupInfo";*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.toEditSpecialGroup( id,operType, WebUtils.getCurBizId(request));
		if(operType==null){
			operType=1;
		}
		model.addAttribute("operType", operType);
		model.addAttribute("vo", toAddSpecialGroupResult.getSpecialGroupOrderVO());
		model.addAttribute("jdxjList", toAddSpecialGroupResult.getJdxjList());
		model.addAttribute("zjlxList", toAddSpecialGroupResult.getZjlxList());
		model.addAttribute("lysfxmList", toAddSpecialGroupResult.getLysfxmList());
		model.addAttribute("jtfsList", toAddSpecialGroupResult.getJtfsList());
		model.addAttribute("sourceTypeList", toAddSpecialGroupResult.getSourceTypeList());
		model.addAttribute("allProvince", toAddSpecialGroupResult.getAllProvince());
		model.addAttribute("config", config);
		model.addAttribute("allCity", toAddSpecialGroupResult.getCityList());
		model.addAttribute("guideStr", toAddSpecialGroupResult.getGuideStr());
		return "sales/specialGroup/specialGroupInfo";
	}
	
	@RequestMapping(value = "saveSpecialGroup.do")
	@ResponseBody
	public String saveSpecialGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,SpecialGroupOrderVO vo) throws ParseException{
	/*	if(vo.getGroupOrder().getId()==null){
			vo.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
		}
		Integer orderId = specialGroupOrderService.saveOrUpdateSpecialOrderInfo(vo,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(),WebUtils.getCurBizId(request));
		return successJson("groupId",orderId+"");*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.saveSpecialGroup( vo, WebUtils.getCurUser(request).getOrgId(),  WebUtils.getCurBizId(request),  WebUtils.getCurUserId(request),  WebUtils.getCurUser(request).getName());
		return successJson("groupId",toAddSpecialGroupResult.getOrderId()+"");
	}
	
	
	@RequestMapping(value = "toSpecialGroupList.htm")
	public String toSpecialGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model){
		/*List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		
		Integer bizId = WebUtils.getCurBizId(request);		
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "sales/specialGroup/specialGroupList";*/
		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.toSpecialGroupList(WebUtils.getCurBizId(request));
		model.addAttribute("pp", toAddSpecialGroupResult.getDicInfoList());
		model.addAttribute("allProvince", toAddSpecialGroupResult.getAllProvince());
		model.addAttribute("sourceTypeList", toAddSpecialGroupResult.getSourceTypeList());
		model.addAttribute("orgJsonStr",toAddSpecialGroupResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",toAddSpecialGroupResult.getOrgUserJsonStr());
		return "sales/specialGroup/specialGroupList";
	}
	
	@RequestMapping(value = "getSpecialGroupData.do")
	public String getSpecialGroupData(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,GroupOrder groupOrder) throws ParseException{
		
		getSpecialGroupsData(request, model, groupOrder);
		return "sales/specialGroup/specialGroupList_table";
		
	}
	private void getSpecialGroupsData(HttpServletRequest request,
			ModelMap model, GroupOrder groupOrder) throws ParseException {
		/*if(groupOrder.getDateType()!=null && groupOrder.getDateType()==2){
			SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
			if(!"".equals(groupOrder.getStartTime())){
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime()).getTime()+"");
			}
			if(!"".equals(groupOrder.getEndTime())){
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
			
		}
		
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
		PageBean page = new PageBean();
		page.setParameter(groupOrder);
		page.setPage(groupOrder.getPage()==null?1:groupOrder.getPage());
		page.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		page =groupOrderService.selectSpecialOrderListPage(page, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		
		List<GroupOrder> list = page.getResult();
		Integer pageTotalAudit=0;
		Integer pageTotalChild=0;
		Integer pageTotalGuide=0;
		BigDecimal pageTotal=new BigDecimal(0);
		if(page.getResult()!=null && page.getResult().size()>0){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (GroupOrder groupOrder2 : list) {
				pageTotalAudit+=groupOrder2.getNumAdult()==null?0:groupOrder2.getNumAdult();
				pageTotalChild+=groupOrder2.getNumChild()==null?0:groupOrder2.getNumChild();
				pageTotalGuide+=groupOrder2.getNumGuide()==null?0:groupOrder2.getNumGuide();
				pageTotal =pageTotal.add(groupOrder2.getTotal()==null?new BigDecimal(0):groupOrder2.getTotal());
				Long createTime = groupOrder2.getCreateTime();
				String dateStr = sdf.format(createTime);
				groupOrder2.setCreateTimeStr(dateStr);
			}
		}
		model.addAttribute("pageTotalAudit", pageTotalAudit);
		model.addAttribute("pageTotalChild",pageTotalChild);
		model.addAttribute("pageTotalGuide",pageTotalGuide);
		model.addAttribute("pageTotal", pageTotal);
		model.addAttribute("page", page);
		GroupOrder go = groupOrderService.selectTotalSpecialOrder(groupOrder, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("totalAudit", go.getNumAdult());
		model.addAttribute("totalChild", go.getNumChild());
		model.addAttribute("totalGuide", go.getNumGuide());
		model.addAttribute("total", go.getTotal());*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.getSpecialGroupData( groupOrder,WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageTotalAudit", toAddSpecialGroupResult.getPageTotalAudit());
		model.addAttribute("pageTotalChild",toAddSpecialGroupResult.getPageTotalChild());
		model.addAttribute("pageTotalGuide",toAddSpecialGroupResult.getPageTotalGuide());
		model.addAttribute("pageTotal", toAddSpecialGroupResult.getPageTotal());
		model.addAttribute("page", toAddSpecialGroupResult.getPage());
		model.addAttribute("totalAudit", toAddSpecialGroupResult.getGroupOrder().getNumAdult());
		model.addAttribute("totalChild", toAddSpecialGroupResult.getGroupOrder().getNumChild());
		model.addAttribute("totalGuide", toAddSpecialGroupResult.getGroupOrder().getNumGuide());
		model.addAttribute("total", toAddSpecialGroupResult.getGroupOrder().getTotal());
	}
	/**
	 * 一地散订单打印预览
	 * @param response
	 * @param request
	 * @param model
	 * @param groupOrder
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping("specialGroupPreview.htm")
	public String specialGroupPreview(HttpServletResponse response,HttpServletRequest request,ModelMap model,GroupOrder groupOrder) throws ParseException{
		groupOrder.setPageSize(100000);
		getSpecialGroupsData(request, model, groupOrder);
		model.addAttribute("printTime", com.yihg.erp.utils.DateUtils.format(new Date()));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		return "sales/specialGroup/special-group-print";

	}
	@RequestMapping(value = "getSpecialGroup.do")
	public String getSpecialGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, TourGroup tourGroup,
			Integer tid) throws ParseException{
		/*if (tid != null) {
			GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(tid);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

			tourGroup.setEndTime(sdf.parse(groupOrder.getDepartureDate()));
		}
		tourGroup.setGroupMode(-1);
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
		return "sales/specialGroup/toInsertFitGroupList";*/
		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.getSpecialGroup(tourGroup,  tid,  WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", toAddSpecialGroupResult.getPage());
		model.addAttribute("tourGroup", toAddSpecialGroupResult.getTourGroup());
		return "sales/specialGroup/toInsertFitGroupList";
	}
	
	
	
	
	/**
	 * 跳转到并团页面(一地散)
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
	/*	List<GroupOrder> list = new ArrayList<GroupOrder>();
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
		return "sales/specialGroup/mergeGroup";*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.toMergeGroup(ids);
		model.addAttribute("list", toAddSpecialGroupResult.getGroupOrderList());
		model.addAttribute("ids", ids);
		return "sales/specialGroup/mergeGroup";
	}
	
	
	@RequestMapping(value = "mergetGroup.do")
	@ResponseBody
	public String mergetGroup(HttpServletRequest request,
			HttpServletResponse reponse,MergeGroupOrderVO mergeGroupOrderVO) throws ParseException{
		
		/*SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
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
		specialGroupOrderService.mergetGroup(result, WebUtils.getCurBizId(request),
				WebUtils.getCurUserId(request), WebUtils.getCurUser(request)
						.getName(), settingCommon.getMyBizCode(request));
		
		return successJson();*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.mergetGroup(mergeGroupOrderVO,WebUtils.getCurBizId(request),WebUtils.getCurUser(request).getOrgId(),WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName());
		return successJson();
	}
	
	/**
	 * 跳转到并团新增订单列表(一地散)
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
		/*if (null == groupOrder.getEndTime()
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
		groupOrder.setState(2);
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage()==null?1:groupOrder.getPage());
		pageBean.setParameter(groupOrder);
		pageBean =groupOrderService.selectSpecialOrderListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("page", pageBean);
		return "sales/specialGroup/impNotGroupOrder";*/


		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.toImpNotGroupList( groupOrder,  idLists,  WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
		model.addAttribute("pp", toAddSpecialGroupResult.getDicInfoList());
		model.addAttribute("groupOrder", toAddSpecialGroupResult.getGroupOrder());
		model.addAttribute("page", toAddSpecialGroupResult.getPage());
		model.addAttribute("idLists", idLists);
		return "sales/specialGroup/impNotGroupOrder";
	}
	
	
	@RequestMapping(value = "insertGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroup(HttpServletRequest request,
			HttpServletResponse reponse, Integer id, String code) {

		/*TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
		if (tourGroup == null) {
			return errorJson("未查到该团号对应的散客团信息!");
		}
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(id);
		groupOrder.setGroupId(tourGroup.getId());
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

		return successJson();*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.insertGroup( id, code);
		return successJson();

	}
	
	@RequestMapping(value = "insertGroupMany.do", method = RequestMethod.POST)
	@ResponseBody
	public String insertGroupMany(HttpServletRequest request,
			HttpServletResponse reponse, String ids, String code) {

		/*TourGroup tourGroup = tourGroupService.selectByGroupCode(code);
		if (tourGroup == null) {
			return errorJson("未查到该团号对应的散客团信息!");
		}
		String[] split = ids.split(",");
		for (String str : split) {
			GroupOrder groupOrder = groupOrderService
					.selectByPrimaryKey(Integer.parseInt(str));
			groupOrder.setGroupId(tourGroup.getId());
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
		}
		return successJson();*/
		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.insertGroupMany( ids,  code);
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
		/*String[] split = ids.split(",");
		List<String> datelist = new ArrayList<String>();
		for (String id : split) {
			GroupOrder groupOrder = groupOrderService.findById(Integer
					.parseInt(id));
			datelist.add(groupOrder.getDepartureDate());
			List<GroupOrderGuest> guestList = groupOrderGuestService
					.selectByOrderId(Integer.parseInt(id));
//			if (guestList == null || guestList.size() == 0) {
//				return errorJson("订单号:" + groupOrder.getOrderNo()
//						+ "无客人信息,无法并团!");
//			}

		}

		if (!MergeGroupUtils.hasSame(datelist)) {
			return errorJson("发团日期一致的订单才允许加入到团中!");
		}
		return successJson();*/


		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.beforeInsertGroup(ids);
		if (!MergeGroupUtils.hasSame(toAddSpecialGroupResult.getDatelist())) {
			return errorJson("发团日期一致的订单才允许加入到团中!");
		}
		return successJson();
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
	/*	String[] split = ids.split(",");
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
		if (!MergeGroupUtils.hasSame(brandlist)) {
			return errorJson("产品品牌一致的订单才允许并团!");
		}

		return successJson();*/

		ToAddSpecialGroupResult toAddSpecialGroupResult = specialGroupFacade.judgeMergeGroup(ids);
		if (!MergeGroupUtils.hasSame(toAddSpecialGroupResult.getDatelist())) {
			return errorJson("发团日期一致的订单才允许并团!");
		}
		if (!MergeGroupUtils.hasSame(toAddSpecialGroupResult.getBrandlist())) {
			return errorJson("产品品牌一致的订单才允许并团!");
		}

		return successJson();
	}

}
