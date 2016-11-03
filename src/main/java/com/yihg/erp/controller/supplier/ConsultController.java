package com.yihg.erp.controller.supplier;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.supplier.query.GuestConsultDTO;
import com.yimayhd.erpcenter.facade.supplier.query.GuestConsultFollowDTO;
import com.yimayhd.erpcenter.facade.supplier.result.ConsultGuestListResult;
import com.yimayhd.erpcenter.facade.supplier.result.FollowConsultResult;
import com.yimayhd.erpcenter.facade.supplier.result.WebResult;
import com.yimayhd.erpcenter.facade.supplier.service.ConsultFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.GuestConsult;
import com.yimayhd.erpresource.dal.po.GuestConsultFollow;
@Controller
@RequestMapping("/consult")
public class ConsultController extends BaseController {
	
	private static final Logger log = LoggerFactory
			.getLogger(ConsultController.class);

	@Autowired
	private ConsultFacade consultFacade;
	/**
	 * 客户咨询登记
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("/consultGuestList.htm")
	public String consultGuestList(HttpServletRequest request,HttpServletResponse response,ModelMap model){
//		//意向游玩
//		List<DicInfo> intentionDestList = dicService.getListByTypeCode(Constants.MSGL_YXYW,WebUtils.getCurBizId(request));
//		//信息渠道
//		List<DicInfo> infoSourceList = dicService.getListByTypeCode(Constants.MSGL_XXQD,WebUtils.getCurBizId(request));
		ConsultGuestListResult result = consultFacade.consultGuestList(Constants.MSGL_YXYW, Constants.MSGL_XXQD, WebUtils.getCurBizId(request));
		model.addAttribute("intentionDestList", result.getIntentionDestList());
		model.addAttribute("infoSourceList", result.getInfoSourceList());
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
		WebResult<PageBean> result = consultFacade.getGuestConsultList(pageBean, WebUtils.getCurBizId(request));
		pageBean = result.getValue();
		model.addAttribute("page", pageBean);
		return "supplier/consult/consultGuestTable";
		
	}
	@RequestMapping("addConsult.htm")
	public String addConsult(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		
		FollowConsultResult result = consultFacade.addConsult(Constants.MSGL_KRLY, Constants.MSGL_YXYW, Constants.MSGL_XXQD, WebUtils.getCurBizId(request));
		
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("guestSources", result.getGuestSources());
		model.addAttribute("intentionDests", result.getIntentionDests());
		model.addAttribute("infoSources", result.getInfoSources());
		model.addAttribute("curDate", new Date());
		return "/supplier/consult/addConsult";
		
	}
	@RequestMapping("followConsult.htm")
	public String followConsult(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer guestId){
		FollowConsultResult result = consultFacade.followConsult(Constants.MSGL_KRLY, Constants.MSGL_YXYW, Constants.MSGL_XXQD, Constants.MSGL_GJFS, guestId, WebUtils.getCurBizId(request));
		
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("guestSources", result.getGuestSources());
		model.addAttribute("intentionDests", result.getIntentionDests());
		model.addAttribute("infoSources", result.getInfoSources());
		model.addAttribute("followWays", result.getFollowWays());
		model.addAttribute("guestConsult", result.getGuestConsult());
		model.addAttribute("consultFollows", result.getConsultFollows());
		if (result.getGuestConsult().getProvinceId()!=null) {
			
			model.addAttribute("cityList", result.getCityList());
		}
		
		model.addAttribute("guestId", guestId);
		return "/supplier/consult/followConsult";
		
	}
	@RequestMapping("viewConsult.htm")
	public String viewConsult(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer guestId){
		FollowConsultResult webResult = consultFacade.viewConsult(Constants.MSGL_KRLY, Constants.MSGL_YXYW, Constants.MSGL_XXQD, guestId, WebUtils.getCurBizId(request));
		
		model.addAttribute("allProvince", webResult.getAllProvince());
		model.addAttribute("guestSources", webResult.getGuestSources());
		model.addAttribute("intentionDests", webResult.getIntentionDests());
		model.addAttribute("infoSources", webResult.getInfoSources());
		GuestConsult guestConsult = webResult.getGuestConsult();
		model.addAttribute("guestConsult", guestConsult);
		if (guestConsult.getProvinceId()!=null) {
			
			model.addAttribute("cityList", webResult.getCityList());
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
		return consultFacade.validatePhone(phone);
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
		GuestConsultDTO guestConsultDTO = new GuestConsultDTO();
		guestConsultDTO.setGuestConsult(guestConsult);
		WebResult<Integer> webResult = consultFacade.saveConsultGuest(guestConsultDTO);
		if(webResult.isSuccess()){
			return webResult.getValue()>0?successJson():errorJson("保存失败");
		}else{
			return errorJson("保存失败");
		}
		
		//return successJson();
		
	}
	@RequestMapping("delConsultGuest.do")
	@ResponseBody
	public String delConsultGuest(HttpServletRequest request,HttpServletResponse response,Integer guestId){
		return consultFacade.delConsultGuest(guestId)>0?successJson():errorJson("删除失败");
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
			 GuestConsultFollowDTO followDTO = new GuestConsultFollowDTO();
			 followDTO.setGuestConsultFollow(follow);
			 return consultFacade.saveConsultFollow(type,followDTO)>0?successJson():errorJson("删除失败");
		} catch (Exception e) {
			log.error(e.getMessage());
			return errorJson("保存失败");
		}
		
	}
}
