package com.yihg.erp.controller.supplier;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.supplier.api.SupplierDriverService;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.po.SupplierDriver;

@Controller
@RequestMapping(value = "/supplier/driver")
public class SupplierDriverController extends BaseController {

	@Autowired
	private SupplierService supplierService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SupplierDriverService driverService;
	@Autowired
	private SysConfig config;

	@RequestMapping(value = "driverList.htm")
	public String driverList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, SupplierDriver driver, Integer page, Integer pageSize) {
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		return "supplier/driver/driver-list";
	}

	@RequestMapping(value = "editDriver.htm")
	public String driverEdit(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id) {

		List<DicInfo> mzList = dicService.getListByTypeCode(BasicConstants.GYXX_MZ);
		List<DicInfo> djList = dicService.getListByTypeCode(BasicConstants.DYXX_DJ);
		List<DicInfo> xjpdList = dicService.getListByTypeCode(BasicConstants.DYXX_XJPD);
		List<DicInfo> shdtrsList = dicService.getListByTypeCode(BasicConstants.DYXX_SHDTRS);
		List<DicInfo> carList = dicService.getListByTypeCode(BasicConstants.GYS_SJ_ZJCX);
		model.addAttribute("mzList", mzList);
		model.addAttribute("djList", djList);
		model.addAttribute("xjpdList", xjpdList);
		model.addAttribute("shdtrsList", shdtrsList);
		model.addAttribute("carList", carList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		SupplierDriver driver = null;
		driver = driverService.getDriverInfoById(id);
		model.addAttribute("driver", driver);
		if (driver != null) {
			if (driver.getProvinceId() != null) {
				List<RegionInfo> cityList = regionService.getRegionById(driver.getProvinceId() + "");
				model.addAttribute("cityList", cityList);
			}
			if (driver.getCityId() != null) {
				List<RegionInfo> areaList = regionService.getRegionById(driver.getCityId() + "");
				model.addAttribute("areaList", areaList);
			}
			if (driver.getAreaId() != null) {
				List<RegionInfo> townList = regionService.getRegionById(driver.getAreaId() + "");
				model.addAttribute("townList", townList);
			}
		}
		return "supplier/driver/edit-driver";
	}
	
	@RequestMapping(value = "driverDetail.htm")
	public String driverDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id) {

		List<DicInfo> mzList = dicService.getListByTypeCode(BasicConstants.GYXX_MZ);
		List<DicInfo> djList = dicService.getListByTypeCode(BasicConstants.DYXX_DJ);
		List<DicInfo> xjpdList = dicService.getListByTypeCode(BasicConstants.DYXX_XJPD);
		List<DicInfo> shdtrsList = dicService.getListByTypeCode(BasicConstants.DYXX_SHDTRS);
		List<DicInfo> carList = dicService.getListByTypeCode(BasicConstants.GYS_SJ_ZJCX);
		model.addAttribute("mzList", mzList);
		model.addAttribute("djList", djList);
		model.addAttribute("xjpdList", xjpdList);
		model.addAttribute("shdtrsList", shdtrsList);
		model.addAttribute("carList", carList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		SupplierDriver driver = null;
		driver = driverService.getDriverInfoById(id);
		model.addAttribute("driver", driver);
		if (driver != null) {
			if (driver.getProvinceId() != null) {
				List<RegionInfo> cityList = regionService.getRegionById(driver.getProvinceId() + "");
				model.addAttribute("cityList", cityList);
			}
			if (driver.getCityId() != null) {
				List<RegionInfo> areaList = regionService.getRegionById(driver.getCityId() + "");
				model.addAttribute("areaList", areaList);
			}
			if (driver.getAreaId() != null) {
				List<RegionInfo> townList = regionService.getRegionById(driver.getAreaId() + "");
				model.addAttribute("townList", townList);
			}
		}
		return "supplier/driver/driver-detail";
	}
	
	@RequestMapping(value = "saveDriver.do", method = RequestMethod.POST)
	@ResponseBody
	public String driverSave(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, SupplierDriver driver) {
		
		int id = 0;
		boolean isAdd = false;
		if (driver.getId() != null) {
			driverService.updateDriverInfo(driver);
		} else {
			id = driverService.addDriverInfoAndRelation(driver, WebUtils.getCurBizId(request));
			isAdd = true;
		}
		return successJson("id", String.valueOf(id), "isAdd", String.valueOf(isAdd));
	}

	@RequestMapping(value = "deleteDriver.do", method = RequestMethod.POST)
	public void driverDelete(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, SupplierDriver driver) {
		driverService.deleteByPrimaryKey(Integer.parseInt(request.getParameter("id")));
	}

	@ResponseBody
	@PostHandler
	@RequestMapping(value = "joinDriver.do", method = RequestMethod.POST)
	public String joinDriver(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String ids) {
		driverService.addBizDriverRelation(WebUtils.getCurBizId(request), null, StringUtils.split(ids, ','));
		return null;
	}

	@ResponseBody
	@PostHandler
	@RequestMapping(value = "cancelJoinDriver.do", method = RequestMethod.POST)
	public String cancelJoinDriver(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer driverId) {
		driverService.deleteBizDriverRelation(WebUtils.getCurBizId(request), driverId);
		return null;
	}
}
