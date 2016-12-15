package com.yihg.erp.controller.sales;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TeamGroupVO;
import com.yimayhd.erpcenter.facade.sales.query.*;
import com.yimayhd.erpcenter.facade.sales.result.*;
import com.yimayhd.erpcenter.facade.sales.service.TeamGroupFacade;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.json.JSONString;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.common.GroupCodeUtil;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;


@Controller
@RequestMapping(value = "/teamGroup")
public class TeamGroupController extends BaseController {


	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private TeamGroupFacade teamGroupFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	 @InitBinder  
	  public void initListBinder(WebDataBinder binder)  
	  {  
	      // 设置需要包裹的元素个数，默认为256  
	      binder.setAutoGrowCollectionLimit(1024);  
	  }  

	
	/**
	 * 客人名单导入
	 * @param file
	 * @param orderId
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/upload.do")  
	@ResponseBody
	public String upload(@RequestParam(value = "file", required = false) MultipartFile file,
			HttpServletRequest request, ModelMap model) {  
		String path = request.getSession().getServletContext().getRealPath("upload");  
        if(null==file){
        	 return errorJson(JSONArray.toJSONString("请上传文件！")) ; 
        }
        String fileName = file.getOriginalFilename();  
        if(!fileName.endsWith(".xlsx")){
        	return errorJson(JSONArray.toJSONString("文件格式不支持，请上传 xlsx格式excel文件")) ; 
        }
        String tempFileName = System.currentTimeMillis()+".xlsx" ;
        File targetFile = new File(path, tempFileName);  
        if(!targetFile.exists()){  
            targetFile.mkdirs();  
        }  
        //保存  
        try {  
            file.transferTo(targetFile);  
            List<GroupOrderGuest> list = new ArrayList<GroupOrderGuest>() ;
    		GroupOrderGuest gog = null ;
    		Workbook wb = new XSSFWorkbook(targetFile) ;
    		Sheet sheet = wb.getSheetAt(0) ;
    		Row row = null ;
    		Cell cell = null ;
    		for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
    			gog = new GroupOrderGuest() ;
    			row = sheet.getRow(rowIndex) ;
    			cell = row.getCell(0) ;
    			if(null!=cell){
    				cell.setCellType(1) ;
    				gog.setName(cell.getStringCellValue());
    			}else if(row.getCell(1)!=null||row.getCell(2)!=null||row.getCell(3)!=null){
    				wb.close();
    				return errorJson("excel中第"+rowIndex+"行姓名为空") ;
    			}
    			cell = row.getCell(1) ;
    			if(null!=cell){
    				cell.setCellType(1) ;
    				for (GroupOrderGuest guest : list) {
        				if(guest.getCertificateNum().equals(cell.getStringCellValue())){
        					wb.close();
            				return errorJson("excel中第"+rowIndex+"行身份证号码重复") ;
        				}
        			}
    				gog.setCertificateNum(cell.getStringCellValue());
    			}else if(row.getCell(0)!=null||row.getCell(2)!=null||row.getCell(3)!=null){
    				wb.close();
    				return errorJson("excel中第"+rowIndex+"行身份证号码为空") ;
    			}
    			cell = row.getCell(2) ;
    			if(null!=cell){
    				cell.setCellType(1) ;
    				gog.setMobile(cell.getStringCellValue());
    			}else{
    				gog.setMobile("");
    			}
    			cell = row.getCell(3) ;
    			if(null!=cell){
    				cell.setCellType(1) ;
    				gog.setRemark(cell.getStringCellValue());
    			}else{
    				gog.setRemark("");
    			}
    			list.add(gog) ;
    		}
    		wb.close();
            targetFile.delete();
            return successJson("guestString",JSONArray.toJSONString(list)) ;
        } catch (Exception e) {
            e.printStackTrace();
            return errorJson(JSONArray.toJSONString("服务器忙！请稍后再试。。。。。。")) ; 
        }  
    } 
	
	@RequestMapping("download.do")
	public void download(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 处理中文文件名下载乱码
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		String path = request.getSession().getServletContext().getRealPath("/")+"/download/guestModelImport.xlsx";
		String fileName = "";
		try {
			fileName = new String("model.xlsx".getBytes("UTF-8"), "iso-8859-1");
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
	}
	/**
	 * 团查询管理页面（未确认团、已确认团）
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toGroupList.htm")
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String toGroupList(HttpServletRequest request, Model model) {
		Integer bizId = WebUtils.getCurBizId(request);
//		List<RegionInfo> allProvince = regionService.getAllProvince();
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
//		model.addAttribute("orgJsonStr",
//				orgService.getComponentOrgTreeJsonStr(bizId));
//		model.addAttribute("orgUserJsonStr",
//				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
//		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);

		ToGroupListResult toGroupListResult = teamGroupFacade.toGroupList(bizId);
		model.addAttribute("allProvince", toGroupListResult.getAllProvince());
		model.addAttribute("orgJsonStr",toGroupListResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",toGroupListResult.getOrgUserJsonStr());
		model.addAttribute("sourceTypeList", toGroupListResult.getSourceTypeList());
		return "sales/teamGroup/groupList";
	}

	@RequestMapping(value = "toAddTeamGroupInfo.htm")
	public String toAddTeamGroupInfo(HttpServletRequest request, Model model) {
/*		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		TeamGroupVO teamGroupVO = new TeamGroupVO();
		teamGroupVO.setGroupOrder(groupOrder);
		model.addAttribute("teamGroupVO", teamGroupVO);
		int bizId = WebUtils.getCurBizId(request);
		// 收费类型
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("config", config);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, WebUtils.getCurBizId(request));
		model.addAttribute("lysfxmList", lysfxmList);
		model.addAttribute("operType", "1");
		model.addAttribute("isEdit", false);*/

		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		int bizId = WebUtils.getCurBizId(request);
		TeamGroupVO teamGroupVO = new TeamGroupVO();
		teamGroupVO.setGroupOrder(groupOrder);
		model.addAttribute("teamGroupVO", teamGroupVO);
		ToAddTeamGroupInfoDTO toAddTeamGroupInfoDTO = new ToAddTeamGroupInfoDTO();
		toAddTeamGroupInfoDTO.setGroupOrder(groupOrder);
		toAddTeamGroupInfoDTO.setCurBizId(bizId);
		ToAddTeamGroupInfoResult toAddTeamGroupInfoResult = teamGroupFacade.toAddTeamGroupInfo(toAddTeamGroupInfoDTO);
		model.addAttribute("typeList", toAddTeamGroupInfoResult.getTypeList());
		model.addAttribute("sourceTypeList", toAddTeamGroupInfoResult.getSourceTypeList());
		model.addAttribute("allProvince", toAddTeamGroupInfoResult.getAllProvince());
		model.addAttribute("config", config);
		model.addAttribute("jtfsList", toAddTeamGroupInfoResult.getJtfsList());
		model.addAttribute("zjlxList", toAddTeamGroupInfoResult.getZjlxList());
		model.addAttribute("lysfxmList", toAddTeamGroupInfoResult.getLysfxmList());
		model.addAttribute("operType", "1");
		model.addAttribute("isEdit", false);
		return "sales/teamGroup/teamGroupInfo";

	}

	@RequestMapping(value = "toEditTeamGroupInfo.htm")
	public String toEditTeamGroupInfo(HttpServletRequest request, Model model,
			Integer groupId, Integer operType) {
	/*	model.addAttribute("isEdit", true);
		model.addAttribute("operType", operType);
		TeamGroupVO teamGroupVO = teamGroupService.selectTeamGroupVOByGroupId(groupId, WebUtils.getCurBizId(request));
		model.addAttribute("teamGroupVO", teamGroupVO);
		
		int bizId = WebUtils.getCurBizId(request);
		
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE,bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("config", config);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, WebUtils.getCurBizId(request));
		model.addAttribute("lysfxmList", lysfxmList);
		List<RegionInfo> cityList = null;
		if (teamGroupVO.getGroupOrder().getProvinceId() != null
				&& teamGroupVO.getGroupOrder().getProvinceId() != -1) {
			cityList = regionService.getRegionById(teamGroupVO.getGroupOrder()
					.getProvinceId() + "");
		}
		model.addAttribute("allCity", cityList);
		String guideStr="";
		List<GroupOrderGuest> guestList = groupOrderGuestService.selectByOrderId(teamGroupVO.getGroupOrder().getId());
		if(guestList!=null){
			for (GroupOrderGuest groupOrderGuest : guestList) {
				if(groupOrderGuest.getType()==3){
					guideStr=("".equals(guideStr)?"":(guideStr+" | "))+groupOrderGuest.getName()+" "+groupOrderGuest.getMobile();
				}
			}
		}
		model.addAttribute("guideStr", guideStr);*/


		int bizId = WebUtils.getCurBizId(request);
		ToEditTeamGroupInfoDTO toEditTeamGroupInfoDTO = new ToEditTeamGroupInfoDTO();
		toEditTeamGroupInfoDTO.setGroupId(groupId);
		toEditTeamGroupInfoDTO.setCurBizId(WebUtils.getCurBizId(request));
		toEditTeamGroupInfoDTO.setBizId(bizId);
		ToEditTeamGroupInfoResult toEditTeamGroupInfoResult = teamGroupFacade.toEditTeamGroupInfo(toEditTeamGroupInfoDTO);
		model.addAttribute("isEdit", true);
		model.addAttribute("operType", operType);
		model.addAttribute("teamGroupVO", toEditTeamGroupInfoResult.getTeamGroupVO());
		model.addAttribute("typeList", toEditTeamGroupInfoResult.getTypeList());
		model.addAttribute("sourceTypeList", toEditTeamGroupInfoResult.getSourceTypeList());
		model.addAttribute("allProvince", toEditTeamGroupInfoResult.getAllProvince());
		model.addAttribute("config", config);
		model.addAttribute("jtfsList", toEditTeamGroupInfoResult.getJtfsList());
		model.addAttribute("zjlxList", toEditTeamGroupInfoResult.getZjlxList());
		model.addAttribute("lysfxmList", toEditTeamGroupInfoResult.getLysfxmList());
		model.addAttribute("allCity", toEditTeamGroupInfoResult.getCityList());
		model.addAttribute("guideStr", toEditTeamGroupInfoResult.getGuideStr());
		return "sales/teamGroup/teamGroupInfo";
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
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	@ResponseBody
	public String findTourGroupByConditionLoadModel(HttpServletRequest request, Integer rows,Integer pageSize, Integer page,
			GroupOrder groupOrder, Model model) throws ParseException {
		String sidx = request.getParameter("sidx");//来获得排序的列名，
		String sord = request.getParameter("sord");//来获得排序方式
		groupOrder.setSidx(sidx);
		groupOrder.setSord(sord);
		FindTourGroupByConditionDTO queryDTO = new FindTourGroupByConditionDTO();
		queryDTO.setRows(rows);
		queryDTO.setPage(page);
		queryDTO.setPageSize(pageSize);
		queryDTO.setCurBizId(WebUtils.getCurBizId(request));
		queryDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setGroupOrder(groupOrder);
		FindTourGroupByConditionResult result = teamGroupFacade.findTourGroupByConditionLoadModel(queryDTO);

		model.addAttribute("pageTotalAudit", result.getPageTotalAudit());
		model.addAttribute("pageTotalChild", result.getPageTotalChild());
		model.addAttribute("pageTotalGuide", result.getPageTotalGuide());

		GroupOrder order = result.getGroupOrder();
		model.addAttribute("totalAudit", result.getTotalAudit());
		model.addAttribute("totalChild",result.getTotalChild());
		model.addAttribute("totalGuide", result.getPageTotalGuide());

//		*//**
//		 * 根据组团社id获取组团社名称
//		 *//*
		List<GroupOrder> groupList = result.getPageBean().getResult();
		model.addAttribute("groupList", groupList);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("pageBean", result.getPageBean());
		return JSON.toJSONString( result.getPageBean());
		//return "sales/teamGroup/groupTable";
	}

	@RequestMapping(value = "saveTeamGroupInfo.do")
	@ResponseBody
	public String saveTeamGroupInfo(HttpServletRequest request,
									TeamGroupVO teamGroupVO) throws ParseException {
		if(teamGroupVO.getTourGroup().getId()==null){
			teamGroupVO.getTourGroup().setGroupCode(settingCommon.getMyBizCode(request));
			teamGroupVO.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
		}else{
			TourGroup tourGroup = teamGroupVO.getTourGroup();
			tourGroup.setGroupCode(GroupCodeUtil.getCode(tourGroup.getGroupCode(), tourGroup.getGroupCodeMark()));
		}
		//TeamGroupVO tgv = teamGroupService.saveOrUpdateTeamGroupVO(WebUtils.getCurBizId(request), WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName(), teamGroupVO);
		SaveTeamGroupInfoDTO saveTeamGroupInfoDTO = new SaveTeamGroupInfoDTO();
		saveTeamGroupInfoDTO.setCurBizId(WebUtils.getCurBizId(request));
		saveTeamGroupInfoDTO.setCurUserId(WebUtils.getCurUserId(request));
		saveTeamGroupInfoDTO.setCurUserName(WebUtils.getCurUser(request).getName());
		saveTeamGroupInfoDTO.setTeamGroupVO(teamGroupVO);
		SaveTeamGroupInfoResult saveTeamGroupInfoResult = teamGroupFacade.saveTeamGroupInfo(saveTeamGroupInfoDTO);
		if(null != saveTeamGroupInfoResult.getTeamGroupVO() && null != saveTeamGroupInfoResult.getTeamGroupVO().getTourGroup()){
			return successJson("groupId",saveTeamGroupInfoResult.getTeamGroupVO().getTourGroup().getId()+"");
		}
		return errorJson("保存失败");
	}

	/**
	 * 跳转到组团新增中计调需求页面
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toRequirement.htm", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	public String toRequirement(Integer orderId,Model model,Integer operType) {

	/*	GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(orderId);
		// 车辆型号
		List<DicInfo> ftcList = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("ftcList", ftcList);
		// 酒店星级
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		// 酒店信息
		List<GroupRequirement> hotelList = groupRequirementService
				.selectByOrderAndType(orderId, 3);
		model.addAttribute("hotelList", hotelList);
		// 车队信息
		List<GroupRequirement> fleetList = groupRequirementService
				.selectByOrderAndType(orderId, 4);
		model.addAttribute("fleetList", fleetList);
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
		model.addAttribute("groupId", groupOrder.getGroupId());
		model.addAttribute("operType",operType);*/

		ToRequirementResult toRequirementResult = teamGroupFacade.toRequirement(orderId, operType);
		model.addAttribute("ftcList", toRequirementResult.getFtcList());
		model.addAttribute("jdxjList", toRequirementResult.getJdxjList());
		model.addAttribute("hotelList", toRequirementResult.getHotelList());
		model.addAttribute("fleetList", toRequirementResult.getFleetList());
		model.addAttribute("airTicketList", toRequirementResult.getAirTicketList());
		model.addAttribute("railwayTicketList", toRequirementResult.getRailwayTicketList());
		model.addAttribute("guideList", toRequirementResult.getGuideList());
		model.addAttribute("restaurantList", toRequirementResult.getRestaurantList());
		model.addAttribute("orderId", orderId);
		model.addAttribute("groupId", toRequirementResult.getGroupId());
		model.addAttribute("operType",operType);
		return "sales/teamGroup/groupRequirement";
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
		/*
		if(financeService.hasAuditOrder(groupId)){
			return errorJson("该团有已审核的订单,不允许删除！");
		}

		if(financeService.hasPayOrIncomeRecord(groupId)){
			return errorJson("该团有收付款记录,不允许删除！");
		}
		if (airTicketRequestService.doesOrderhaveRequested(WebUtils.getCurBizId(request), orderId)){
			return errorJson("删除订单前请先取消机票申请。");
		}
		if(financeService.hasHotelOrder(groupId)){
			return errorJson("该团有酒、车队订单,不允许删除！");
		}
		int i = tourGroupService.deleteTourGroupById(groupId, orderId);
		if (i == 1) {
			return successJson();
		} else {
			return errorJson("服务器忙！");
		}*/
		
		String result = teamGroupFacade.deleteGroupOrderById(orderId,groupId,WebUtils.getCurBizId(request)); 
		if(StringUtils.isNotEmpty(result) && "成功".equals(result)){
			return successJson();
		}
		return errorJson(result);

	}

	@RequestMapping(value = "/saveRequireMent.do")
	@ResponseBody
	public String saveRequireMent(HttpServletRequest request,TeamGroupVO teamGroupVO){
		//teamGroupService.saveOrUpdateRequirement(teamGroupVO, WebUtils.getCurBizId(request), WebUtils.getCurUser(request).getName());
		SaveRequireMentDTO saveRequireMentDTO = new SaveRequireMentDTO();
		saveRequireMentDTO.setTeamGroupVO(teamGroupVO);
		saveRequireMentDTO.setCurBizId(WebUtils.getCurBizId(request));
		saveRequireMentDTO.setCurUserName(WebUtils.getCurUser(request).getName());
		ResultSupport resultSupport = teamGroupFacade.saveRequireMent(saveRequireMentDTO);
		if(resultSupport.isSuccess()) {
			return successJson();
		}else{
			return errorJson(resultSupport.getResultMsg());
		}
	}

	@RequestMapping("findTourGroupLoadFooter.do")
	@RequiresPermissions(PermissionConstants.SALE_TEAM_GROUP)
	@ResponseBody
	public String findTourGroupLoadFooter(HttpServletRequest request, Integer pageSize, Integer page,
										  GroupOrder groupOrder, Model model) throws ParseException {
		FindTourGroupLoadFooterDTO findTourGroupLoadFooterDTO = new FindTourGroupLoadFooterDTO();
		findTourGroupLoadFooterDTO.setPage(page);
		findTourGroupLoadFooterDTO.setPageSize(pageSize);
		findTourGroupLoadFooterDTO.setGroupOrder(groupOrder);
		findTourGroupLoadFooterDTO.setBizId(WebUtils.getCurBizId(request));
		findTourGroupLoadFooterDTO.setDataUserIds(WebUtils.getDataUserIdSet(request));
		FindTourGroupLoadFooterResult findTourGroupLoadFooterResult = teamGroupFacade.findTourGroupLoadFooter(findTourGroupLoadFooterDTO);

		System.out.println("--pageBean--"+JSON.toJSONString(findTourGroupLoadFooterResult.getGroupOrder()));
		return JSON.toJSONString(findTourGroupLoadFooterResult.getGroupOrder());
		//return "sales/teamGroup/groupTable";
	}

}
