package com.yihg.erp.controller.supplier;


import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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

import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.basic.util.NumberUtil;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.po.BookingGuide;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.SupplierGuestService;
import com.yihg.supplier.api.SupplierImgService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierGuest;
import com.yihg.supplier.po.SupplierGuestLabel;
import com.yihg.supplier.po.SupplierGuide;

@Controller
@RequestMapping(value = "/supplierGuest")
public class SupplierGuestController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(SupplierGuestController.class);
	@Autowired
	private SupplierGuestService supplierGuestService;
	@Autowired
	private SupplierImgService supplierImgService;
	@Autowired
	private DicService dicService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private RegionService regionService;

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
		List<List<SupplierGuestLabel>> lists = new ArrayList<List<SupplierGuestLabel>>();
		PageBean pageBean = new PageBean();
		List<SupplierGuestLabel> supplierGuestLabels = supplierGuestService.selectSupplierGuestLabelList(WebUtils.getCurBizId(request));
		double dou = (double)supplierGuestLabels.size()/5;
		int length = (int)Math.ceil(dou);
		for(int i=0;i<length;i++){
			pageBean.setPage(i+1);
			pageBean.setPageSize(5);
			List<SupplierGuestLabel> supplier = supplierGuestService.selectSupplierGuestLabelListPage(WebUtils.getCurBizId(request),pageBean);
			lists.add(supplier);
		}
		model.addAttribute("length", length);
		model.addAttribute("supplierGuestLabels", lists);
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
			supplierGuestService.deleteByPrimaryKey(id);
			supplierGuestService.deleteRelationsByLabelId(id);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
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
			if(StringUtils.isEmpty(name)){
				return errorJson("标签名称不能为空");
			}
			SupplierGuestLabel extLabel = supplierGuestService.selectLabelByName(WebUtils.getCurBizId(request),name.trim());
			if(null!=extLabel){
				return errorJson("此标签已存在");
			}
			SupplierGuestLabel label = new SupplierGuestLabel();
			label.setBizId(WebUtils.getCurBizId(request));
			label.setName(name.trim());
			label.setNum(0);
			label.setCreateTime(System.currentTimeMillis());
			supplierGuestService.addGuestLabel(label);
			return successJson("msg", "添加成功");
		}catch(Exception e){
			e.printStackTrace();
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
		//标签
		List<List<SupplierGuestLabel>> lists = new ArrayList<List<SupplierGuestLabel>>();
		PageBean pageBean = new PageBean();
		List<SupplierGuestLabel> supplierGuestLabels = supplierGuestService.selectSupplierGuestLabelList(WebUtils.getCurBizId(request));
		double dou = (double)supplierGuestLabels.size()/9;
		int length = (int)Math.ceil(dou);
		for(int i=0;i<length;i++){
			pageBean.setPage(i+1);
			pageBean.setPageSize(9);
			List<SupplierGuestLabel> supplier = supplierGuestService.selectSupplierGuestLabelListPage(WebUtils.getCurBizId(request),pageBean);
			lists.add(supplier);
		}
		model.addAttribute("supplierGuestLabels", lists);
		model.addAttribute("length", length);
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
		pageBean = supplierGuestService.selectSupplierGuestListPage(pageBean);
		
		model.addAttribute("pageBean", pageBean);
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
			supplierGuestService.deleteByGuestPrimaryKey(id);
			supplierGuestService.deleteRelationsByGuestId(id);
			//统计标签人数
			supplierGuestService.tjLabelNum();
			return successJson("msg", "操作成功");
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
		List<TourGroup> groups = tourGroupService.selectTravelRecordsByIdCard(idCard.trim(),WebUtils.getCurBizId(request));
		
		model.addAttribute("groups", groups);
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
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		//每行5个显示标签
		List<List<SupplierGuestLabel>> lists = new ArrayList<List<SupplierGuestLabel>>();
		PageBean pageBean = new PageBean();
		List<SupplierGuestLabel> supplierGuestLabels = supplierGuestService.selectSupplierGuestLabelList(WebUtils.getCurBizId(request));
		double dou = (double)supplierGuestLabels.size()/5;
		int length = (int)Math.ceil(dou);
		for(int i=0;i<length;i++){
			pageBean.setPage(i+1);
			pageBean.setPageSize(5);
			List<SupplierGuestLabel> supplier = supplierGuestService.selectSupplierGuestLabelListPage(WebUtils.getCurBizId(request),pageBean);
			lists.add(supplier);
		}
		model.addAttribute("length", length);
		model.addAttribute("supplierGuestLabels", lists);

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
		SupplierGuest guest = supplierGuestService.selectGuestListById(id);
		
		model.addAttribute("guest", guest);
		
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		if (guest.getProvinceId() != null) {
			List<RegionInfo> cityList = regionService.getRegionById(guest
					.getProvinceId() + "");
			model.addAttribute("cityList", cityList);
		}
		if (guest.getAdProvinceId() != null) {
			List<RegionInfo> adCityList = regionService.getRegionById(guest
					.getAdProvinceId() + "");
			model.addAttribute("adCityList", adCityList);
		}
		
		//每行5个显示标签
		List<List<SupplierGuestLabel>> lists = new ArrayList<List<SupplierGuestLabel>>();
		PageBean pageBean = new PageBean();
		List<SupplierGuestLabel> supplierGuestLabels = supplierGuestService.selectSupplierGuestLabelList(WebUtils.getCurBizId(request));
		double dou = (double)supplierGuestLabels.size()/5;
		int length = (int)Math.ceil(dou);
		for(int i=0;i<length;i++){
			pageBean.setPage(i+1);
			pageBean.setPageSize(5);
			List<SupplierGuestLabel> supplier = supplierGuestService.selectSupplierGuestLabelListPage(WebUtils.getCurBizId(request),pageBean);
			for (SupplierGuestLabel supplierGuestLabel : supplier) {
				Map<String,Object> lation = supplierGuestService.selectGuestLabelRelationByGuestIdAndLabelId(id,supplierGuestLabel.getId());
				if(null != lation){
					supplierGuestLabel.setChoose(true);
				}
			}
			
			lists.add(supplier);
		}
		model.addAttribute("length", length);
		model.addAttribute("supplierGuestLabels", lists);

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
		SupplierGuest supplierGuest = supplierGuestService.selectGuestByMobile(WebUtils.getCurBizId(request),guest.getMobile(),guest.getId());
		if(null!=supplierGuest){
			return errorJson("已存在应用此手机的乘客！");
		}
		if (guest.getId() != null) {
			supplierGuestService.deleteRelationsByGuestId(guest.getId());
			supplierGuestService.updateGuest(guest);
			
		} else {
			int id = supplierGuestService.addGuestInfo(guest);
		}
		//添加关系
		SupplierGuest supp = supplierGuestService.selectGuestByMobile(WebUtils.getCurBizId(request),guest.getMobile(),null);
		if(!StringUtils.isEmpty(choseIds)){
			String ids[] =choseIds.split(",");
			for(int i=0;i<ids.length;i++){
				supplierGuestService.insertRelation(supp.getId(),ids[i]);
			}
		}
		//统计标签人数
		supplierGuestService.tjLabelNum();
		return successJson();
	}

}
