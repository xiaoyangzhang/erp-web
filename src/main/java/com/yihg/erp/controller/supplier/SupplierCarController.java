package com.yihg.erp.controller.supplier;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.basic.api.DicService;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.supplier.api.SupplierCarService;
import com.yihg.supplier.api.SupplierImgService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierCar;
import com.yihg.supplier.vo.SupplierCarVO;

@Controller
@RequestMapping(value = "/supplierCar")
public class SupplierCarController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(SupplierCarController.class);
	@Autowired
	private SupplierCarService supplierCarService;
	@Autowired
	private SupplierImgService supplierImgService;
	@Autowired
	private DicService dicService;

	@Autowired
	private SysConfig config;

	@RequestMapping(value = "toSupplierCarList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_CAR_PROFILE)
	public String toSupplierCarList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierCar supplierCar) {
		
		PageBean pageBean = new PageBean();
		pageBean.setParameter(supplierCar);
		pageBean.setPage(supplierCar.getPage());
		pageBean.setPageSize(supplierCar.getPageSize());
		PageBean page = supplierCarService.selectPrivateCarListPage(pageBean,
				WebUtils.getCurBizId(request));
		List<SupplierCarVO> voList = new ArrayList<SupplierCarVO>();
		List<SupplierCar> result = page.getResult();
		if (result != null && result.size() > 0) {
			for (SupplierCar sc : result) {
				SupplierCarVO scv = new SupplierCarVO();
				scv.setSupplierCar(sc);
				scv.setImgList(supplierImgService.selectBySupplierCommentImgId(
						sc.getId(), 5));
				voList.add(scv);
			}
		}
		model.addAttribute("voList", voList);
		model.addAttribute("config", config);
		model.addAttribute("page", page);
		model.addAttribute("supplierCar", supplierCar);
		List<DicInfo> list = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("carType", list);
		return "supplier/car/privateSupplierCarList";
	}

	@RequestMapping(value = "toAllSupplierCarList.htm")
	public String toAllSupplierCarList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierCar supplierCar) {
		PageBean pageBean = new PageBean();
		if(null==supplierCar.getBuyStart()&& null==supplierCar.getBuyEnd()){
			Calendar c=Calendar.getInstance();
			int year=c.get(Calendar.YEAR);
			int month=c.get(Calendar.MONTH);
			SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1);
			supplierCar.setBuyStart(c.getTime());
			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			supplierCar.setBuyEnd(c.getTime());
			
		}
		pageBean.setParameter(supplierCar);
		pageBean.setPage(supplierCar.getPage());
		pageBean.setPageSize(supplierCar.getPageSize());
		PageBean page = supplierCarService.selectAllCarListPage(pageBean);
		List<SupplierCarVO> voList = new ArrayList<SupplierCarVO>();
		List<SupplierCar> result = page.getResult();
		if (result != null && result.size() > 0) {
			for (SupplierCar sc : result) {
				SupplierCarVO scv = new SupplierCarVO();
				scv.setSupplierCar(sc);
				scv.setImgList(supplierImgService.selectBySupplierCommentImgId(
						sc.getId(), 5));
				voList.add(scv);
			}
		}
		model.addAttribute("voList", voList);
		model.addAttribute("config", config);
		model.addAttribute("page", page);
		model.addAttribute("supplierCar", supplierCar);
		List<DicInfo> list = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("carType", list);
		return "supplier/car/impSupplierCarList";
	}

	@RequestMapping(value = "delCarRelation.do")
	@ResponseBody
	public String delCarRelation(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		supplierCarService.delSupplierCar(id, WebUtils.getCurBizId(request));
		return successJson();
	}

	@RequestMapping(value = "toAddSupplierCar.htm")
	public String toAddSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<DicInfo> list = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("carType", list);
		return "supplier/car/addSupplierCar";
	}

	@RequestMapping(value = "addSupplierCar.do")
	@ResponseBody
	public String addSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierCarVO supplierCarVO) {
		
		supplierCarVO.getSupplierCar().setTypeName(dicService.getById(supplierCarVO.getSupplierCar().getTypeId()+"").getValue());
		int id = supplierCarService.insertSupplierCar(supplierCarVO,
				WebUtils.getCurBizId(request));
		
		return successJson("id",id+"");
	}

	@RequestMapping(value = "toEditSupplierCar.htm")
	public String toEditSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		SupplierCarVO supplierCarVO = supplierCarService.selectById(id);
		model.addAttribute("supplierCarVO", supplierCarVO);
		List<DicInfo> list = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("carType", list);
		model.addAttribute("config", config);
		return "supplier/car/editSupplierCar";
	}

	@RequestMapping(value = "editSupplierCar.do")
	@ResponseBody
	public String editSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierCarVO supplierCarVO) {
		supplierCarVO.getSupplierCar().setTypeName(dicService.getById(supplierCarVO.getSupplierCar().getTypeId()+"").getValue());
		supplierCarService.updateSupplierCar(supplierCarVO);
		return successJson();
	}

	@RequestMapping(value = "addRelation.do")
	@ResponseBody
	public String addRelation(HttpServletRequest request,
			HttpServletResponse reponse, String ids) {
		supplierCarService.addRelation(ids, WebUtils.getCurBizId(request));
		return successJson();
	}

}
