package com.yihg.erp.controller.supplier;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javassist.expr.NewArray;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.supplier.api.ConsultService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.GuestConsult;
import com.yihg.supplier.po.GuestConsultFollow;
import com.yihg.sys.po.PlatformEmployeePo;
@Controller
@RequestMapping("/consult")
public class ConsultController extends BaseController {

	@Autowired
	private DicService dicService;
	@Autowired
	private ConsultService consultService;
	@Autowired
	private RegionService regionService;
	/**
	 * 客户咨询登记
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("/consultGuestList.htm")
	public String consultGuestList(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		//意向游玩
		List<DicInfo> intentionDestList = dicService.getListByTypeCode(Constants.MSGL_YXYW,WebUtils.getCurBizId(request));
		//信息渠道
		List<DicInfo> infoSourceList = dicService.getListByTypeCode(Constants.MSGL_XXQD,WebUtils.getCurBizId(request));
		model.addAttribute("intentionDestList", intentionDestList);
		model.addAttribute("infoSourceList", infoSourceList);
		return "supplier/consult/consultGuestList";
		
	}
	@RequestMapping("consultGuestList.do")
	public String consultGuestListTable(HttpServletRequest request,HttpServletResponse response,ModelMap model,GuestConsult consult,Integer page,Integer pageSize){
		PageBean pageBean=new PageBean();
		if (page==null) {
			pageBean.setPage(1);
		}
		else {
			
			pageBean.setPage(page);
		}
		if (pageSize==null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		}else {
			
			pageBean.setPageSize(pageSize);
		}
		pageBean.setParameter(consult);
		pageBean = consultService.getGuestConsultList(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("page", pageBean);
		return "supplier/consult/consultGuestTable";
		
	}
	@RequestMapping("addConsult.htm")
	public String addConsult(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		List<DicInfo> guestSources = dicService.getListByTypeCode(Constants.MSGL_KRLY,WebUtils.getCurBizId(request));
		model.addAttribute("guestSources", guestSources);
		List<DicInfo> intentionDests = dicService.getListByTypeCode(Constants.MSGL_YXYW,WebUtils.getCurBizId(request));
		model.addAttribute("intentionDests", intentionDests);
		List<DicInfo> infoSources = dicService.getListByTypeCode(Constants.MSGL_XXQD,WebUtils.getCurBizId(request));
		model.addAttribute("infoSources", infoSources);
		model.addAttribute("curDate", new Date());
		return "/supplier/consult/addConsult";
		
	}
	@RequestMapping("followConsult.htm")
	public String followConsult(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer guestId){
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		List<DicInfo> guestSources = dicService.getListByTypeCode(Constants.MSGL_KRLY,WebUtils.getCurBizId(request));
		model.addAttribute("guestSources", guestSources);
		List<DicInfo> intentionDests = dicService.getListByTypeCode(Constants.MSGL_YXYW,WebUtils.getCurBizId(request));
		model.addAttribute("intentionDests", intentionDests);
		List<DicInfo> infoSources = dicService.getListByTypeCode(Constants.MSGL_XXQD,WebUtils.getCurBizId(request));
		model.addAttribute("infoSources", infoSources);
		List<DicInfo> followWays = dicService.getListByTypeCode(Constants.MSGL_GJFS,WebUtils.getCurBizId(request));
		model.addAttribute("followWays", followWays);
		GuestConsult guestConsult = consultService.selectGuestConsultByPrimaryKey(guestId);
		model.addAttribute("guestConsult", guestConsult);
		List<GuestConsultFollow> consultFollows = consultService.selectConsultFollowByConsultId(guestId, WebUtils.getCurBizId(request));
		model.addAttribute("consultFollows", consultFollows);
		if (guestConsult.getProvinceId()!=null) {
			
			List<RegionInfo> cityList = regionService.getRegionById(guestConsult.getProvinceId().toString());
			model.addAttribute("cityList", cityList);
		}
		
		model.addAttribute("guestId", guestId);
		return "/supplier/consult/followConsult";
		
	}
	@RequestMapping("viewConsult.htm")
	public String viewConsult(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer guestId){
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		List<DicInfo> guestSources = dicService.getListByTypeCode(Constants.MSGL_KRLY,WebUtils.getCurBizId(request));
		model.addAttribute("guestSources", guestSources);
		List<DicInfo> intentionDests = dicService.getListByTypeCode(Constants.MSGL_YXYW,WebUtils.getCurBizId(request));
		model.addAttribute("intentionDests", intentionDests);
		List<DicInfo> infoSources = dicService.getListByTypeCode(Constants.MSGL_XXQD,WebUtils.getCurBizId(request));
		model.addAttribute("infoSources", infoSources);
		GuestConsult guestConsult = consultService.selectGuestConsultByPrimaryKey(guestId);
		model.addAttribute("guestConsult", guestConsult);
		if (guestConsult.getProvinceId()!=null) {
			
			List<RegionInfo> cityList = regionService.getRegionById(guestConsult.getProvinceId().toString());
			model.addAttribute("cityList", cityList);
		}
		return "/supplier/consult/viewConsult";
		
	}
	/**
	 * 验证咨询客户的唯一性
	 * @param request
	 * @param model
	 * @param phone
	 * @return
	 */
	@RequestMapping("/commons/validetePhone.htm")
	@ResponseBody
	public String validatePhone(HttpServletRequest request,ModelMap model,String phone){
		return consultService.validatePhone(phone)>0?"false":"true";
		//return phone;
		
	}
	/**
	 * 保存咨询客户
	 * @param request
	 * @param response
	 * @param model
	 * @param guestConsult
	 * @return
	 */
	@RequestMapping("saveConsultGuest.do")
	@ResponseBody
	public String saveConsultGuest(HttpServletRequest request,HttpServletResponse response,ModelMap model,GuestConsult guestConsult){
		guestConsult.setBizId(WebUtils.getCurBizId(request));
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		guestConsult.setReceiverId(curUser.getEmployeeId());
		guestConsult.setReceiverName(curUser.getName());
		return consultService.save(guestConsult)>0?successJson():errorJson("保存失败");
		//return successJson();
		
	}
	@RequestMapping("delConsultGuest.do")
	@ResponseBody
	public String delConsultGuest(HttpServletRequest request,HttpServletResponse response,Integer guestId){
		return consultService.delConsultGuest(guestId)>0?successJson():errorJson("删除失败");
	}
	/**
	 * 保存咨询跟进情况
	 * @param request
	 * @param response
	 * @param model
	 * @param type
	 * @param follow
	 * @return
	 */
	@RequestMapping("saveConsultFollow.do")
	@ResponseBody
	public String saveConsultFollow(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer type,GuestConsultFollow follow){
		follow.setBizId(WebUtils.getCurBizId(request));
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		follow.setFollowerId(curUser.getEmployeeId());
		follow.setFollowerName(curUser.getName());
		
		 try {
			 consultService.save(follow,type);
			// Map<String, Object> map=new HashMap<String, Object>();
			// map.put("id", followId);
			 return successJson();
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("保存失败");
		}
		
	}
}
