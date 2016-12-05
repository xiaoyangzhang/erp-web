package com.yihg.erp.controller.agency;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.erpcenterFacade.common.client.query.BrandQueryDTO;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.BrandQueryResult;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.common.GroupCodeUtil;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroupComment;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.FitGroupInfoVO;
import com.yimayhd.erpcenter.facade.sales.query.AgencyOrderQueryDTO;
import com.yimayhd.erpcenter.facade.sales.result.AgencyOrderResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.service.AgencyFitFacade;
import com.yimayhd.erpcenter.facade.sales.service.AgencyFitGroupFacade;

@Controller
@RequestMapping(value = "/agencyFitGroup")
public class AgencyFitGroupController extends BaseController {

	@Autowired
	private SysConfig config;
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private AgencyFitGroupFacade agencyFitGroupFacade;
	@Autowired
	private AgencyFitFacade agencyFitFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
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
		String[] split = ids.split(",");
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
		ResultSupport resultSupport = agencyFitGroupFacade.secMergeGroup(groupId, split);
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败");
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
//		tourGroupService.updateByPrimaryKeySelective(tourGroup);
		ResultSupport resultSupport = agencyFitGroupFacade.updateByPrimaryKeySelective(tourGroup);
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败");
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
//		tourGroupService.delFitTourGroup(groupId);
		ResultSupport resultSupport = agencyFitGroupFacade.delFitTour(groupId);
		return resultSupport.isSuccess() ?  successJson() : errorJson(resultSupport.getResultMsg());
		
	}

	@RequestMapping(value = "toSecImpNotGroupList.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_ORDER)
	public String toSecImpNotGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder,
			Integer gid) {
		if (groupOrder.getReqType() != null && groupOrder.getReqType() == 0) {
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
			groupOrder.setDateType(1);
		}
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		pageBean.setPage(groupOrder.getPage()==null?1:groupOrder.getPage());
		pageBean.setParameter(groupOrder);
//		pageBean = groupOrderService.selectNotGroupListPage(pageBean,
//				WebUtils.getCurBizId(request),
//				WebUtils.getDataUserIdSet(request));
//		List<GroupOrder> result = pageBean.getResult();
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
//		model.addAttribute("pp", pp);
		pageBean = agencyFitFacade.toImpNotGroupList(pageBean, WebUtils.getCurBizId(request), WebUtils.getDataUserIdSet(request));
//		List<GroupOrder> result = pageBean.getResult();
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult pp = productCommonFacade.brandQuery(brandQueryDTO);
		model.addAttribute("pp", pp.getBrandList());
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("groupId", gid);
		model.addAttribute("page", pageBean);
		return "agency/fitGroup/secImpNotGroupOrder";
	}
	
	@RequestMapping(value = "updateFitGroupInfo.do")
	@ResponseBody
	public String updateFitGroupInfo(HttpServletRequest request,FitGroupInfoVO fitGroupInfoVO){
//		TourGroup tourGroup = fitGroupInfoVO.getTourGroup();
//		TourGroup group=tourGroupService.selectByPrimaryKey(fitGroupInfoVO.getTourGroup().getId());
//		ProductInfo productInfo = productInfoService.findProductInfoById(fitGroupInfoVO.getTourGroup().getProductId());
////		tourGroup.setGroupCode(GroupCodeUtil.getCode(tourGroup.getGroupCode(), tourGroup.getGroupCodeMark()));
//		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
//		tourGroup.setGroupCode(GroupCodeUtil.getCodeForAgency(settingCommon.getMyBizCode(request),tourGroup.getGroupCode(), tourGroup.getGroupCodeMark(),productInfo==null?"":productInfo.getCode(),sdf1.format(group.getDateStart()),sdf1.format(group.getDateEnd())));
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
		ResultSupport resultSupport = agencyFitGroupFacade.updateFitGroupInfo(fitGroupInfoVO, WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName());
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
		ResultSupport resultSupport = agencyFitGroupFacade.delFitOrder(id);
		return successJson();
	}

	@RequestMapping(value = "toFitGroupInfo.htm")
	public String toFitGroupInfo(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId,
			Integer operType) {
		//operType=0查看   ||  operType=1编辑
//		FitGroupInfoVO fitGroupInfoVO = fitGroupService
//				.selectFitGroupInfoById(groupId);
		FitGroupInfoVO fitGroupInfoVO = agencyFitGroupFacade.selectFitGroupInfoById(groupId);
		model.addAttribute("fitGroupInfoVO", fitGroupInfoVO);
		model.addAttribute("operType", operType);
//		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
//				WebUtils.getCurBizId(request));
//		model.addAttribute("ppList", pp);
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult pp = productCommonFacade.brandQuery(brandQueryDTO);
		model.addAttribute("ppList", pp.getBrandList());
		model.addAttribute("config", config);
		return "agency/fitGroup/fitGroupInfo";
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
	@RequiresPermissions(PermissionConstants.AGENCY_SK_GROUP)
	public String toFitGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, TourGroup tourGroup) {
		if (null == tourGroup.getStartTime() && null == tourGroup.getEndTime()) {
			Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1, 0, 0, 0);
			tourGroup.setStartTime(c.getTime());
			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			tourGroup.setEndTime(c.getTime());

		}
		if (null == tourGroup.getGroupState()) {
			tourGroup.setGroupState(-2);
		}
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(tourGroup.getPageSize() == null ? Constants.PAGESIZE
				: tourGroup.getPageSize());
		pageBean.setPage(tourGroup.getPage());

		// 如果人员为空并且部门不为空，则取部门下的人id
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
		Integer bizId = WebUtils.getCurBizId(request);
		tourGroup.setOperatorIds(productCommonFacade.setSaleOperatorIds(tourGroup.getOperatorIds(),tourGroup.getOrgIds(), bizId));
		pageBean.setParameter(tourGroup);
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
		AgencyOrderQueryDTO queryDTO = new AgencyOrderQueryDTO();
		queryDTO.setTourGroup(tourGroup);
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setPageBean(pageBean);
		AgencyOrderResult result = agencyFitGroupFacade.toFitGroupList(queryDTO);
		model.addAttribute("group", result.getTourGroup());
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "agency/fitGroup/fitGroupList";
	}
	
	/**
	 * 跳转到出团备注编辑页面
	 */
	@RequestMapping(value = "toEditGroupComment.htm")
	public String toEditGroupComment(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, int groupId) {
//		TourGroup g = tourGroupService.selectByPrimaryKey(groupId);
		ArrayList<Integer> groupIds = new ArrayList<Integer>();
		groupIds.add(groupId);
		Integer bizId = WebUtils.getCurBizId(request);
//		List<TourGroupComment> commentList = tourGroupService.getTourGroupComments(bizId, groupIds);
		AgencyOrderResult result = agencyFitGroupFacade.toEditGroupComment(bizId, groupIds);
		if (CollectionUtils.isEmpty(result.getGroupComments())){
			model.addAttribute("comment", new TourGroupComment());
		}else {
			model.addAttribute("comment", result.getGroupComments().get(0));
		}
		model.addAttribute("group", result.getTourGroup());
		return "agency/fitGroup/editGroupComment";
	}
	
	@RequestMapping(value = "saveGroupComment.do")
	@ResponseBody
	public String saveGroupComment(HttpServletRequest request, HttpServletResponse reponse, TourGroupComment comment){
		comment.setBizId(WebUtils.getCurBizId(request));
//		tourGroupService.updateTourGroupComment(WebUtils.getCurBizId(request), comment);
		ResultSupport resultSupport = agencyFitGroupFacade.updateTourGroupComment(WebUtils.getCurBizId(request), comment);
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败"); 
	}
	
	
	
	@RequestMapping(value = "test.do")
	@ResponseBody
	public String test(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		Integer groupId= 1613;
		TourGroupComment comment = new TourGroupComment();
		comment.setBizId(WebUtils.getCurBizId(request));
		comment.setGroupId(groupId);
		comment.setGroupComment("出团说明 测试111");
		comment.setGroupNotice("注意事项1222");
//		tourGroupService.updateTourGroupComment(WebUtils.getCurBizId(request), comment);
//		
//		return "";
		ResultSupport resultSupport = agencyFitGroupFacade.updateTourGroupComment(WebUtils.getCurBizId(request), comment);
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败"); 

	}
	
	@RequestMapping(value = "toGroupNoticePreview.htm")
	public String toSKConfirmPreview(HttpServletRequest request, Integer groupId, Model model) {
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Integer bizId = WebUtils.getCurBizId(request);
		ArrayList<Integer> groupIds = new ArrayList<Integer>();
		groupIds.add(groupId);
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		List<TourGroupComment> comments = tourGroupService.getTourGroupComments(bizId, groupIds);
		AgencyOrderResult result = agencyFitGroupFacade.toSKConfirmPreview(bizId, groupIds);
		List<TourGroupComment> comments = result.getGroupComments();
		TourGroupComment comment;
		if (!CollectionUtils.isEmpty(comments)){
			comment = comments.get(0);
		}else {
			comment = new TourGroupComment();
		}
		
//		List<GroupRoute> routeList = routeService.selectByGroupId(tourGroup.getId());
		List<GroupRoute> routeList = result.getGroupRoutes();
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("routeList", routeList) ;
		model.addAttribute("comment", comment);
		model.addAttribute("tourGroup", result.getTourGroup());

		return "agency/preview/groupNotice";
	}
	

	@RequestMapping(value = "/toGroupNoticeExport.htm")
	public void toExportSKWord(HttpServletRequest request,HttpServletResponse response, Integer groupId){
		Integer bizId = WebUtils.getCurBizId(request);
		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/CTTZ" + System.currentTimeMillis() + ".docx";
		String imgPath = bizSettingCommon.getMyBizLogo(request);
//		TourGroup tour = tourGroupService.selectByPrimaryKey(groupId);
//		List<GroupRoute> routeList = routeService.selectByGroupId(groupId);
		ArrayList<Integer> groupIds = new ArrayList<Integer>();
		groupIds.add(groupId);
//		List<TourGroupComment> comments = tourGroupService.getTourGroupComments(bizId, groupIds);
		AgencyOrderResult result = agencyFitGroupFacade.toSKConfirmPreview(bizId, groupIds);
		List<TourGroupComment> comments = result.getGroupComments();
		String groupComment = "";
		String groupNotice = "";
		if (!CollectionUtils.isEmpty(comments)){
			groupComment=comments.get(0).getGroupComment();
			groupNotice=comments.get(0).getGroupNotice();
		}

		Map<String, Object> params = new HashMap<String, Object>();
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
		
		//params.put("logo", imgPath);
		TourGroup tour = result.getTourGroup();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy年MM月dd日");
		String dateStart = sdf1.format(tour.getDateStart());
		params.put("dateStart", dateStart);
		params.put("groupCode", tour.getGroupCode());
		params.put("groupNotice", groupNotice);
		Map<String, Object> table0 = new HashMap<String, Object>();
		Map<String, Object> table1 = new HashMap<String, Object>();
		table0.put("groupComment", groupComment);
		table1.put("productName", "“"+tour.getProductBrandName()+"”"+ tour.getProductName());
		
		/*填入行程*/
		List<GroupRoute> routeList = result.getGroupRoutes();
		SimpleDateFormat sdf2 = new SimpleDateFormat("MM月dd日");
		List<Map<String, String>> routeListExport = new ArrayList<Map<String,String>>();
		for(GroupRoute route: routeList){
			Map<String, String> routeExport = new HashMap<String, String>();
			routeExport.put("groupDate", sdf2.format(route.getGroupDate()));
			routeExport.put("routeDesp", route.getRouteDesp());
			routeExport.put("breakfast", route.getBreakfast());
			routeExport.put("lunch", route.getLunch());
			routeExport.put("supper", route.getSupper());
			routeExport.put("hotelName", route.getHotelName());
			routeListExport.add(routeExport);
		}
		
		String realPath = request.getSession().getServletContext().getRealPath("/template/group_notice.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
			export.export(params);
			export.export(table0, 0);
			export.export(table1, 1);
			export.export(routeListExport, 2);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
			return ;
		}
		
		
		
		String fileName;
		try{
			fileName = new String("出团通知.docx".getBytes("UTF-8"),"iso-8859-1");
		}catch (UnsupportedEncodingException e){
			e.printStackTrace();
			return ;
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

}
