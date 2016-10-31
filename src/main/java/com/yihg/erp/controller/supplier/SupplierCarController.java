package com.yihg.erp.controller.supplier;

import java.text.SimpleDateFormat;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierCarVODTO;
import com.yimayhd.erpcenter.facade.supplier.result.EditSupplierCarResult;
import com.yimayhd.erpcenter.facade.supplier.result.SupplierCarListResult;
import com.yimayhd.erpcenter.facade.supplier.result.WebResult;
import com.yimayhd.erpcenter.facade.supplier.service.SupplierCarFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.SupplierCar;
import com.yimayhd.erpresource.dal.vo.SupplierCarVO;

@Controller
@RequestMapping(value = "/supplierCar")
public class SupplierCarController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(SupplierCarController.class);
	@Autowired
	private SupplierCarFacade supplierCarFacade;

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
		SupplierCarListResult webResult = supplierCarFacade.toSupplierCarList(WebUtils.getCurBizId(request), pageBean);
		PageBean page = webResult.getPageBean();
		
		model.addAttribute("voList", webResult.getVoList());
		model.addAttribute("config", config);
		model.addAttribute("page", page);
		model.addAttribute("supplierCar", supplierCar);
		model.addAttribute("carType", webResult.getDicInfos());
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
		SupplierCarListResult webResult = supplierCarFacade.toAllSupplierCarList(pageBean);
		model.addAttribute("voList", webResult.getVoList());
		model.addAttribute("config", config);
		model.addAttribute("page", webResult.getPageBean());
		model.addAttribute("supplierCar", supplierCar);
		model.addAttribute("carType", webResult.getDicInfos());
		return "supplier/car/impSupplierCarList";
	}

	@RequestMapping(value = "delCarRelation.do")
	@ResponseBody
	public String delCarRelation(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<Boolean> webResult = supplierCarFacade.delCarRelation(WebUtils.getCurBizId(request), id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	@RequestMapping(value = "toAddSupplierCar.htm")
	public String toAddSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		WebResult<List<DicInfo>> webResult = supplierCarFacade.toAddSupplierCar(Constants.FLEET_TYPE_CODE);
		
		model.addAttribute("carType", webResult.getValue());
		return "supplier/car/addSupplierCar";
	}

	@RequestMapping(value = "addSupplierCar.do")
	@ResponseBody
	public String addSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierCarVO supplierCarVO) {
		SupplierCarVODTO supplierCarVODTO = new SupplierCarVODTO();
		supplierCarVODTO.setSupplierCarVO(supplierCarVO);
		WebResult<Integer> webResult = supplierCarFacade.addSupplierCar(WebUtils.getCurBizId(request), supplierCarVODTO);
		if(webResult.isSuccess()){
			return successJson("id",webResult.getValue()+"");
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
		
	}

	@RequestMapping(value = "toEditSupplierCar.htm")
	public String toEditSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		EditSupplierCarResult webResult = supplierCarFacade.toEditSupplierCar(id, Constants.FLEET_TYPE_CODE);
		
		model.addAttribute("carType", webResult.getList());
		model.addAttribute("config", config);
		return "supplier/car/editSupplierCar";
	}

	@RequestMapping(value = "editSupplierCar.do")
	@ResponseBody
	public String editSupplierCar(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierCarVO supplierCarVO) {
		SupplierCarVODTO supplierCarVODTO = new SupplierCarVODTO();
		supplierCarVODTO.setSupplierCarVO(supplierCarVO);
		WebResult<Boolean> webResult = supplierCarFacade.editSupplierCar(supplierCarVODTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	@RequestMapping(value = "addRelation.do")
	@ResponseBody
	public String addRelation(HttpServletRequest request,
			HttpServletResponse reponse, String ids) {
		
		WebResult<Boolean> webResult = supplierCarFacade.addRelation(ids, WebUtils.getCurBizId(request));
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
	}

}
