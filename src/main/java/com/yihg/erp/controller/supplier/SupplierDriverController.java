package com.yihg.erp.controller.supplier;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierDriverDTO;
import com.yimayhd.erpcenter.facade.supplier.result.DriverEditResult;
import com.yimayhd.erpcenter.facade.supplier.result.WebResult;
import com.yimayhd.erpcenter.facade.supplier.service.SupplierDriverFacade;
import com.yimayhd.erpresource.dal.po.SupplierDriver;

@Controller
@RequestMapping(value = "/supplier/driver")
public class SupplierDriverController extends BaseController {

	@Autowired
	private SupplierDriverFacade supplierDriverFacade;
	@Autowired
	private SysConfig config;

	@RequestMapping(value = "driverList.htm")
	public String driverList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, SupplierDriver driver, Integer page, Integer pageSize) {
		WebResult<List<RegionInfo>> webResult = supplierDriverFacade.driverList();
		model.addAttribute("allProvince", webResult.getValue());
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		return "supplier/driver/driver-list";
	}

	@RequestMapping(value = "editDriver.htm")
	public String driverEdit(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id) {

		DriverEditResult webResult = supplierDriverFacade.driverEdit(id);
		model.addAttribute("mzList", webResult.getMzList());
		model.addAttribute("djList", webResult.getDjList());
		model.addAttribute("xjpdList", webResult.getXjpdList());
		model.addAttribute("shdtrsList", webResult.getShdtrsList());
		model.addAttribute("carList", webResult.getCarList());

		model.addAttribute("allProvince", webResult.getAllProvince());
		SupplierDriver driver = null;
		driver = webResult.getDriver();
		model.addAttribute("driver", driver);
		if (driver != null) {
			if (driver.getProvinceId() != null) {
				model.addAttribute("cityList", webResult.getCityList());
			}
			if (driver.getCityId() != null) {
				model.addAttribute("areaList", webResult.getAreaList());
			}
			if (driver.getAreaId() != null) {
				model.addAttribute("townList", webResult.getTownList());
			}
		}
		return "supplier/driver/edit-driver";
	}
	
	@RequestMapping(value = "driverDetail.htm")
	public String driverDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id) {

		
		DriverEditResult webResult = supplierDriverFacade.driverDetail(id);
		model.addAttribute("mzList", webResult.getMzList());
		model.addAttribute("djList", webResult.getDjList());
		model.addAttribute("xjpdList", webResult.getXjpdList());
		model.addAttribute("shdtrsList", webResult.getShdtrsList());
		model.addAttribute("carList", webResult.getCarList());

		model.addAttribute("allProvince", webResult.getAllProvince());
		SupplierDriver driver = null;
		driver = webResult.getDriver();
		model.addAttribute("driver", driver);
		if (driver != null) {
			if (driver.getProvinceId() != null) {
				model.addAttribute("cityList", webResult.getCityList());
			}
			if (driver.getCityId() != null) {
				model.addAttribute("areaList", webResult.getAreaList());
			}
			if (driver.getAreaId() != null) {
				model.addAttribute("townList", webResult.getTownList());
			}
		}
		
		return "supplier/driver/driver-detail";
	}
	
	@RequestMapping(value = "saveDriver.do", method = RequestMethod.POST)
	@ResponseBody
	public String driverSave(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, SupplierDriver driver) {
		SupplierDriverDTO driverDTO = new SupplierDriverDTO();
		driverDTO.setSupplierDriver(driver);
		WebResult<Map<String,Object>> webResult = supplierDriverFacade.driverSave(driverDTO, WebUtils.getCurBizId(request));
		if(webResult.isSuccess()){
			return successJson("id", String.valueOf(webResult.getValue().get("id")), "isAdd", String.valueOf(webResult.getValue().get("isAdd")));
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	@RequestMapping(value = "deleteDriver.do", method = RequestMethod.POST)
	public void driverDelete(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, SupplierDriver driver) {
		supplierDriverFacade.driverDelete(Integer.parseInt(request.getParameter("id")));
	}

	@ResponseBody
	@PostHandler
	@RequestMapping(value = "joinDriver.do", method = RequestMethod.POST)
	public String joinDriver(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String ids) {
		WebResult<Boolean> webResult = supplierDriverFacade.joinDriver(WebUtils.getCurBizId(request), ids);
		if(webResult.isSuccess()){
			return null;
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	@ResponseBody
	@PostHandler
	@RequestMapping(value = "cancelJoinDriver.do", method = RequestMethod.POST)
	public String cancelJoinDriver(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer driverId) {
		WebResult<Boolean> webResult = supplierDriverFacade.cancelJoinDriver(WebUtils.getCurBizId(request), driverId);
		if(webResult.isSuccess()){
			return null;
		}else{
			return errorJson(webResult.getResultMsg());
		}
	}
}
