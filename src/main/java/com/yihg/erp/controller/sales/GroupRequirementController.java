package com.yihg.erp.controller.sales;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.yihg.basic.api.DicService;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.sales.api.GroupRequirementService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupRequirement;
import com.yihg.sales.po.TourGroup;
import com.yihg.supplier.constants.Constants;

@Controller
@RequestMapping(value = "/groupRequirement")
public class GroupRequirementController extends BaseController{
	
	private static final Logger logger = LoggerFactory.getLogger(GroupRequirementController.class);

	@Autowired
	private GroupRequirementService groupRequirementService ;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private DicService dicService;
	
	/**
	 * 跳转到计调汇总
	 * @param request
	 * @param groupRequirement
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "/toRequirementList.htm")
	
	public String toRequirementList(HttpServletRequest request,GroupRequirement groupRequirement,Model model,Integer groupId,Integer operType){
		List<GroupRequirement> hotelList = groupRequirementService.selectByGroupIdAndType(groupId, Constants.HOTEL);
		List<GroupRequirement> airList = groupRequirementService.selectByGroupIdAndType(groupId, Constants.AIRTICKETAGENT);
		List<GroupRequirement> trainList = groupRequirementService.selectByGroupIdAndType(groupId, Constants.TRAINTICKETAGENT);
		List<GroupRequirement> fleetList = groupRequirementService.selectByGroupIdAndType(groupId, Constants.FLEET);
		List<GroupRequirement> guideList = groupRequirementService.selectByGroupIdAndType(groupId, Constants.GUIDE);
		List<GroupRequirement> restaurantList = groupRequirementService.selectByGroupIdAndType(groupId, Constants.RESTAURANT);
		if(hotelList!=null && hotelList.size()>0){
			for (GroupRequirement hotel : hotelList) {
				hotel.setHotelLevelName(dicService.getById(hotel.getHotelLevel()+"").getValue());
			}
		}
		
		model.addAttribute("hotelList", hotelList);
		model.addAttribute("airList", airList);
		model.addAttribute("trainList", trainList);
		model.addAttribute("fleetList", fleetList);
		model.addAttribute("guideList", guideList);
		model.addAttribute("restaurantList", restaurantList);
		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		model.addAttribute("tourGroup", tourGroup);
		List<DicInfo> cdcxList = dicService.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("cdcxList", cdcxList);
		model.addAttribute("operType", operType);
		
		return "sales/fitGroup/fitRequirementList";
	}
	
	
	/**
	 * 新增计调需求信息
	 * @param groupRequirement
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveGroupRequirement.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGroupRequirement(HttpServletRequest request,GroupRequirement groupRequirement,Model model){
		//groupRequirement.setOrderId(24); //测试数据
		groupRequirement.setCreateTime(new Date().getTime());
		groupRequirement.setCreatorId(WebUtils.getCurUserId(request));
		groupRequirement.setCreatorName(WebUtils.getCurUser(request).getName());
		groupRequirementService.insertSelective(groupRequirement) ;
		logger.info("添加计调需求信息成功");
		return successJson() ;
	}
	
	/**
	 * 修改计调需求信息回显数据
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "editGroupRequirement.do", method = RequestMethod.GET)
	@ResponseBody
	public String editGroupRequirement(Integer id,Model model){
		GroupRequirement groupRequirement = groupRequirementService.selectByPrimaryKey(id) ;
		Gson gson = new Gson();
		String string = gson.toJson(groupRequirement);
		logger.info("跳转到修改计调需求信息页面");
		return string ;
	}
	
	/**
	 * 保存计调需求修改数据
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/updateGroupRequirement", method = RequestMethod.POST)
	@ResponseBody
	public String updateGroupRequirement(GroupRequirement groupRequirement,Model model){
		groupRequirementService.updateByPrimaryKeySelective(groupRequirement) ;
		logger.info("修改计调需求信息成功");
		return successJson();
	}
	
	/**
	 * 删除计调需求信息
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/deleteGroupRequirementById", method = RequestMethod.GET)
	@ResponseBody
	public String deleteGroupRequirementById(Integer id,Model model){
		groupRequirementService.deleteByPrimaryKey(id) ;
		logger.info("删除计调需求信息成功");
		return successJson() ;
	}
}
