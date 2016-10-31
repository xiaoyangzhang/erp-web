package com.yihg.erp.controller.sales;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.common.exception.ClientException;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingDelivery;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SalesVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.facade.sales.result.InitGroupResult;
import com.yimayhd.erpcenter.facade.sales.service.InitGroupFacade;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;


@Controller
@RequestMapping(value = "/initGroup")
public class InitGroupController extends BaseController {

	@Autowired
	private InitGroupFacade initGroupFacade;

	
	@RequestMapping("initGroupList.htm")
	public String initGroupList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		/*Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "sales/initGroup/initGroupList";*/
		Integer bizId = WebUtils.getCurBizId(request);
		InitGroupResult initGroupResult = initGroupFacade.qualityList(bizId);
		model.addAttribute("orgJsonStr", initGroupResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", initGroupResult.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "sales/initGroup/initGroupList";
	}
	
	
	@RequestMapping(value = "/initGroupList.do")
	public String initGroupList(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group,String guideName) {
		/*PageBean pageBean = new PageBean();
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
		//如果人员为空并且部门不为空，则取部门下的人id
		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = tourGroupService.selectInitGroupList(pageBean);
		model.addAttribute("pageBean", pageBean);
		
		return "sales/initGroup/initGroupList-table";*/

		InitGroupResult initGroupResult = initGroupFacade.initGroupList(pageSize,page,group, guideName, WebUtils.getQueryParamters(request), WebUtils.getDataUserIdSet(request), WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", initGroupResult.getPageBean());

		return "sales/initGroup/initGroupList-table";
	}
	

	
	@RequestMapping(value = "getInitGroupList.htm")
	public String getInitGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer groupId) {
		/*List<GroupOrder> orderList =null;
		List<BookingDelivery> bookingDeliveryList =null;
		List<BookingSupplier> hotelList = null;
		List<BookingSupplier> restaurantList = null;
		
		List<BookingSupplier> fleetList = null;
		List<BookingSupplier> scenicsportList = null;
		List<BookingSupplier> insuranceList = null;
		List<BookingSupplier> airticketList = null;
		List<BookingSupplier> trainList = null;
		
		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		if(tourGroup!=null){
			orderList = groupOrderService.selectInitOrderList(WebUtils.getCurBizId(request), tourGroup.getId());
			bookingDeliveryList = bookingDeliveryService.selectInitDeliveryList(tourGroup.getId());
			hotelList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.HOTEL);
			restaurantList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.RESTAURANT);
			
			fleetList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.FLEET);
			scenicsportList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.SCENICSPOT);
			insuranceList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.INSURANCE);
			airticketList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.AIRTICKETAGENT);
			trainList = bookingSupplierService.selectByGroupIdAndSupplierType(groupId,Constants.TRAINTICKETAGENT);
		}
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("orderList", orderList);
		model.addAttribute("bookingDeliveryList", bookingDeliveryList);
		model.addAttribute("hotelList", hotelList);
		model.addAttribute("restaurantList", restaurantList);
		
		model.addAttribute("fleetList", fleetList);
		model.addAttribute("scenicsportList", scenicsportList);
		model.addAttribute("insuranceList", insuranceList);
		model.addAttribute("airticketList", airticketList);
		model.addAttribute("trainList", trainList);
		return "sales/initGroup/initGroupInfo";*/
		InitGroupResult initGroupResult = initGroupFacade.getInitGroupList(groupId, WebUtils.getCurBizId(request));
		model.addAttribute("tourGroup", initGroupResult.getTourGroup());
		model.addAttribute("orderList", initGroupResult.getOrderList());
		model.addAttribute("bookingDeliveryList", initGroupResult.getBookingDeliveryList());
		model.addAttribute("hotelList", initGroupResult.getHotelList());
		model.addAttribute("restaurantList", initGroupResult.getRestaurantList());

		model.addAttribute("fleetList", initGroupResult.getFleetList());
		model.addAttribute("scenicsportList", initGroupResult.getScenicsportList());
		model.addAttribute("insuranceList", initGroupResult.getInsuranceList());
		model.addAttribute("airticketList", initGroupResult.getAirticketList());
		model.addAttribute("trainList", initGroupResult.getTrainList());
		return "sales/initGroup/initGroupInfo";
	}
	
	@RequestMapping(value = "saveInitGroupInfo.do")
	@ResponseBody
	public String saveInitGroupInfo(HttpServletRequest request,HttpServletResponse reponse,SalesVO salesVO){
	/*	String result = chargeOption(salesVO);
		if(result!=null){
			return errorJson(result);
		}
		groupOrderService.saveInitGroupInfo(WebUtils.getCurBizId(request), salesVO,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName());
		return successJson();*/

		String result = chargeOption(salesVO);
		if(result!=null){
			return errorJson(result);
		}
		InitGroupResult initGroupResult = initGroupFacade.saveInitGroupInfo(salesVO,WebUtils.getCurBizId(request), WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName());
		return successJson();
	}

	private String chargeOption(SalesVO salesVO) {
		if(null!=salesVO.getGroupOrderList()){
			List<GroupOrder> list = salesVO.getGroupOrderList();
			Integer temp = 0;
			for (int i = 0; i < list.size() - 1; i++)
			{
				temp = list.get(i).getSupplierId();
				for (int j = i + 1; j < list.size(); j++)
				{
					if (temp.intValue()==list.get(j).getSupplierId().intValue())
					{
						return "含有相同的组团社:"+list.get(j).getSupplierName();
					}
				}
			}
		}
		if(null!=salesVO.getDeliveryList()){
			
			List<BookingDelivery> list2 = salesVO.getDeliveryList();
			Integer temp2 = 0;
			for (int i = 0; i < list2.size() - 1; i++)
			{
				temp2 = list2.get(i).getSupplierId();
				for (int j = i + 1; j < list2.size(); j++)
				{
					if (temp2.intValue()==list2.get(j).getSupplierId().intValue())
					{
						return "含有相同的地接社:"+list2.get(j).getSupplierName();
					}
				}
			}
		}
        
        if(null!=salesVO.getHotelList()){
			
        	List<BookingSupplier> list3 = salesVO.getHotelList();
        	Integer temp3 = 0;
        	for (int i = 0; i < list3.size() - 1; i++)
        	{
        		temp3 = list3.get(i).getSupplierId();
        		for (int j = i + 1; j < list3.size(); j++)
        		{
        			if (temp3.intValue()==list3.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的酒店:"+list3.get(j).getSupplierName();
        			}
        		}
        	}
		}
        if(null!=salesVO.getRestaurantList()){
			
        	List<BookingSupplier> list4 = salesVO.getRestaurantList();
        	Integer temp4 = 0;
        	for (int i = 0; i < list4.size() - 1; i++)
        	{
        		temp4 = list4.get(i).getSupplierId();
        		for (int j = i + 1; j < list4.size(); j++)
        		{
        			if (temp4.intValue()==list4.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的餐厅:"+list4.get(j).getSupplierName();
        			}
        		}
        	}
		}        
        if(null!=salesVO.getFleetList()){
			
        	List<BookingSupplier> list5 = salesVO.getFleetList();
        	Integer temp5 = 0;
        	for (int i = 0; i < list5.size() - 1; i++)
        	{
        		temp5 = list5.get(i).getSupplierId();
        		for (int j = i + 1; j < list5.size(); j++)
        		{
        			if (temp5.intValue()==list5.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的车队:"+list5.get(j).getSupplierName();
        			}
        		}
        	}
		}        
        if(null!=salesVO.getScenicsportList()){
			
        	List<BookingSupplier> list6 = salesVO.getScenicsportList();
        	Integer temp6 = 0;
        	for (int i = 0; i < list6.size() - 1; i++)
        	{
        		temp6 = list6.get(i).getSupplierId();
        		for (int j = i + 1; j < list6.size(); j++)
        		{
        			if (temp6.intValue()==list6.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的景点:"+list6.get(j).getSupplierName();
        			}
        		}
        	}
		}       
        if(null!=salesVO.getInsuranceList()){
			
        	List<BookingSupplier> list7 = salesVO.getInsuranceList();
        	Integer temp7 = 0;
        	for (int i = 0; i < list7.size() - 1; i++)
        	{
        		temp7 = list7.get(i).getSupplierId();
        		for (int j = i + 1; j < list7.size(); j++)
        		{
        			if (temp7.intValue()==list7.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的保险:"+list7.get(j).getSupplierName();
        			}
        		}
        	}
		}       
        if(null!=salesVO.getAirticketList()){
			
        	List<BookingSupplier> list8 = salesVO.getAirticketList();
        	Integer temp8 = 0;
        	for (int i = 0; i < list8.size() - 1; i++)
        	{
        		temp8 = list8.get(i).getSupplierId();
        		for (int j = i + 1; j < list8.size(); j++)
        		{
        			if (temp8.intValue()==list8.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的机票:"+list8.get(j).getSupplierName();
        			}
        		}
        	}
		}        
        if(null!=salesVO.getTrainList()){
        	List<BookingSupplier> list9 = salesVO.getTrainList();
        	Integer temp9 = 0;
        	for (int i = 0; i < list9.size() - 1; i++)
        	{
        		temp9 = list9.get(i).getSupplierId();
        		for (int j = i + 1; j < list9.size(); j++)
        		{
        			if (temp9.intValue()==list9.get(j).getSupplierId().intValue())
        			{
        				return "含有相同的火车票:"+list9.get(j).getSupplierName();
        			}
        		}
        	}
		}       
        
		return null;
	}


	@RequestMapping(value = "/deleteInitGroupInfo.do",method = RequestMethod.POST)
	@ResponseBody
	public String deleteInitGroupInfo(Integer groupId) {
	/*
		try{
			tourGroupService.deleteInitGroupInfo(groupId);
		}catch(ClientException ex){
			return errorJson(ex.getMessage());
		}catch(Exception ex){
			return errorJson("操作失败！");
		}
		return successJson();*/

		try{
			InitGroupResult initGroupResult = initGroupFacade.deleteInitGroupInfo(groupId);
		}catch(ClientException ex){
			return errorJson(ex.getMessage());
		}catch(Exception ex){
			return errorJson("操作失败！");
		}
		return successJson();

	}
	
}
