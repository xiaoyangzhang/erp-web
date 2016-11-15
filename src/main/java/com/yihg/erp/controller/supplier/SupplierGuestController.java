package com.yihg.erp.controller.supplier;


import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierGuestDTO;
import com.yimayhd.erpcenter.facade.supplier.result.GuestLabelEditResult;
import com.yimayhd.erpcenter.facade.supplier.result.GuestLabelListResult;
import com.yimayhd.erpcenter.facade.supplier.result.WebResult;
import com.yimayhd.erpcenter.facade.supplier.service.SupplierGuestFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.SupplierGuest;

@Controller
@RequestMapping(value = "/supplierGuest")
public class SupplierGuestController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(SupplierGuestController.class);
	@Autowired
	private SupplierGuestFacade supplierGuestFacade;

	@Autowired
	private SysConfig config;
	
	/**
	 * 查询客人标签列表
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "guestLabelList.htm")
	public String guestLabelList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		GuestLabelListResult webResult = supplierGuestFacade.guestLabelList(WebUtils.getCurBizId(request));
		
		model.addAttribute("length", webResult.getLength());
		model.addAttribute("supplierGuestLabels", webResult.getSupplierGuestLabels());
		return "supplier/guest/guest-label-list";
	}
	
	/**
	 * 删除客人标签
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/deleteLabel.do")
	@ResponseBody
	public String deleteLabel(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer id) {
		try{
			if(StringUtils.isEmpty(id)){
				return errorJson("要删除的标签ID不能为空");
			}
			WebResult<Boolean> webResult = supplierGuestFacade.deleteLabel(id);
			if(webResult.isSuccess()){
				return successJson("msg", "操作成功");
			}else{
				return errorJson("操作失败");
			}
			
		}catch(Exception e){
			log.error(e.getMessage());
			return errorJson("操作失败");
		}	
	}
	
	/**
	 * 添加客人标签
	 * @param request
	 * @param reponse
	 * @param model
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/addLabel.do")
	@ResponseBody
	public String addLabel(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, String name) {
		try{
			WebResult<Boolean> webResult = supplierGuestFacade.addLabel(WebUtils.getCurBizId(request), name);
			if(webResult.isSuccess()){
				return successJson("msg", "添加成功");
			}else{
				return errorJson(webResult.getResultMsg());
			}
			
		}catch(Exception e){
			log.error(e.getMessage());
			return errorJson("操作失败");
		}	
	}
	/**
	 * 客人列表
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "guestList.htm")
	public String guestList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		
		GuestLabelListResult webResult = supplierGuestFacade.guestList(WebUtils.getCurBizId(request));
		model.addAttribute("supplierGuestLabels", webResult.getSupplierGuestLabels());
		model.addAttribute("length", webResult.getLength());
		return "supplier/guest/guest-list";
	}
	/**
	 * 客人列表展示
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @param chooseIds
	 * @return
	 */
	@RequestMapping(value = "guestList.do")
	public String guestList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,String chooseIds) {

		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		
		Set<Integer> ids = new HashSet<Integer>();
		if(!StringUtils.isEmpty(chooseIds) && !"undefined".equals(chooseIds)){
			String[] orgIdArr = chooseIds.split(",");
			for(String orgIdStr : orgIdArr){
				ids.add(Integer.valueOf(orgIdStr));
			}
			pm.put("ids", ids);
		}
		pageBean.setParameter(pm);
		WebResult<PageBean> webResult = supplierGuestFacade.guestListDo(pageBean);
		
		
		model.addAttribute("pageBean", webResult.getValue());
		return "supplier/guest/guest-list-table";
	}
	
	/**
	 * 删除客人
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/deleteGuest.do")
	@ResponseBody
	public String deleteGuest(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer id) {
		try{
			if(StringUtils.isEmpty(id)){
				return errorJson("操作失败");
			}
			
			WebResult<Boolean> webResult = supplierGuestFacade.deleteGuest(id);
			if(webResult.isSuccess()){
				return successJson("msg", "操作成功");
			}else{
				return errorJson("操作失败");
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	/**
	 * 查询客人旅游记录
	 * @param request
	 * @param reponse
	 * @param model
	 * @param idCard
	 * @return
	 */
	@RequestMapping(value = "selectTravelRecords.do")
	public String selectTravelRecords(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String idCard) {
		if(StringUtils.isEmpty(idCard)){
			return "supplier/guest/guest-travel-list";
		}
		
		WebResult<List<TourGroup>> webResult = supplierGuestFacade.selectTravelRecords(WebUtils.getCurBizId(request), idCard);
		
		model.addAttribute("groups", webResult.getValue());
		return "supplier/guest/guest-travel-list";
	}
	
	/**
	 * 添加客人
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "addGuest.htm")
	public String addGuest(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		GuestLabelListResult webResult = supplierGuestFacade.addGuest(WebUtils.getCurBizId(request), id);
		
		model.addAttribute("allProvince", webResult.getAllProvince());
		model.addAttribute("length", webResult.getLength());
		model.addAttribute("supplierGuestLabels", webResult.getSupplierGuestLabels());

		return "supplier/guest/edit-guest";
	}
	/**
	 * 修改客人
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "editGuest.htm")
	public String editGuest(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		
		GuestLabelEditResult webResult = supplierGuestFacade.editGuest(WebUtils.getCurBizId(request), id);
		SupplierGuest guest = webResult.getGuest();
		model.addAttribute("guest", guest);
		
		model.addAttribute("allProvince",webResult.getAllProvince());
		if (guest.getProvinceId() != null) {
			model.addAttribute("cityList", webResult.getCityList());
		}
		if (guest.getAdProvinceId() != null) {
			model.addAttribute("adCityList", webResult.getAdCityList());
		}
		
		model.addAttribute("length", webResult.getLength());
		model.addAttribute("supplierGuestLabels", webResult.getSupplierGuestLabels());

		return "supplier/guest/edit-guest";
	}
	/**
	 * 保存客人
	 * @param request
	 * @param reponse
	 * @param model
	 * @param guest
	 * @param choseIds
	 * @return
	 */
	@RequestMapping(value = "saveGuest.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGuest(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuest guest,String choseIds) {
		guest.setCreateTime(new Date());
		guest.setUserId(WebUtils.getCurUserId(request));
		guest.setUserName(WebUtils.getCurUser(request).getName());
		guest.setBizId(WebUtils.getCurBizId(request));
		SupplierGuestDTO guestDTO  = new SupplierGuestDTO();
		guestDTO.setSupplierGuest(guest);
		WebResult<Boolean> webResult = supplierGuestFacade.saveGuest(guestDTO, choseIds, WebUtils.getCurBizId(request));
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

}
