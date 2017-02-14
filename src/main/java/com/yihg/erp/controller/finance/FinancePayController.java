package com.yihg.erp.controller.finance;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.constant.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinancePay;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinancePayDetail;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.constants.Constants;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.supplier.service.SupplierFacade;
import com.yimayhd.erpresource.dal.constants.SupplierConstant;
import org.apache.commons.lang.StringUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.BasicCommonFacade;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.yimayhd.erpcenter.facade.finance.result.FinancePayResult;
import org.yimayhd.erpcenter.facade.finance.service.FinancePayDetailFacade;
import org.yimayhd.erpcenter.facade.finance.service.FinancePayFacade;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 财务收付款
 * @author admin-zsq
 * @create 2017年01月10日  上午10:55:42
 */
@Controller
@RequestMapping(value = "/financePay")
public class FinancePayController extends BaseController {
	

	@Autowired
	private BasicCommonFacade basicCommonFacade;
	@Autowired
	private FinancePayFacade financePayFacade;
	@Autowired
	private SupplierFacade supplierFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private FinancePayDetailFacade financePayDetailFacade;
	/**
	 * 财务-收款页面,原来FinanceController中的请求incomeRecordList.htm不在使用
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("incomePayRecord.htm")
	public String incomePayRecordList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model){
		//获取支付方式

		model.addAttribute("payTypeList", basicCommonFacade .getListByTypeCode(BasicConstants.CW_ZFFS));
		return "finance/incomePay/income-pay-list";
	}
	
	/**
	 * 财务-收款Table
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("incomePayRecordListTable.do")
	public String incomePayRecordListTable(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,
			Integer pageSize,Integer page){
		PageBean<FinancePay> pageBean = new PageBean<FinancePay>();
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
		//获取请求中的参数信息
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		
		pms.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pms);
		//获取收款数据
//		pageBean = financePayService.loadIncomePayRecordListPage(pageBean, WebUtils.getCurBizId(request));
		//获取收款总计
//		Map<String, Object> fp = financePayService.loadIncomePayRecordTotal(pageBean, WebUtils.getCurBizId(request));
		FinancePayResult result = financePayFacade.loadIncomePayRecordListPage(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("fp", result.getResultMap());
		return "finance/incomePay/income-pay-table";
	}
	
	/**
	 * 跳转到收款新增页面
	 */
	@RequestMapping(value = "incomePayAdd.htm")
	public String incomeAdd(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		//支付方式
		List<DicInfo> payTypeList = basicCommonFacade
				.getListByTypeCode(BasicConstants.CW_ZFFS);
		model.addAttribute("payTypeList", payTypeList);
		Integer biz_id = WebUtils.getCurBizId(request);
		
		//供应商类别
		model.addAttribute("supplierTypeMapIn", SupplierConstant.supplierTypeMapIn);
		//获取操作员
		PlatformEmployeePo employee = WebUtils.getCurUser(request);
		if (employee != null) {
			model.addAttribute("operatePerson", employee.getName());
		}
		if (payId != null) {
			model.addAttribute("pay", financePayFacade.selectPayById(payId));
		}else{
			model.addAttribute("currDate", new Date());
		}
		return "finance/incomePay/income-pay-add";
	}
	
	/**
	 * 请求供应商账户列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sid
	 * @return
	 */
	@RequestMapping(value = "/querySupplierBankAccountList.do", method = RequestMethod.GET)
	@ResponseBody
	public String querySupplierBankAccountList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer sid) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("accountList", supplierFacade.selectBankBySupplierId(sid));
		return JSON.toJSONString(map);
	}
	
	/**
	 * 保存新增收款信息
	 * @param request
	 * @param reponse
	 * @param model
	 * @param pay
	 * @return
	 */
	@RequestMapping(value = "incomePaySave.do")
	@ResponseBody
	public String incomePaySave(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, FinancePay financePay){
		PlatformEmployeePo empBean = WebUtils.getCurUser(request);
		financePay.setUserId(empBean.getEmployeeId());
		financePay.setUserName(empBean.getName());
		financePay.setBizId(WebUtils.getCurBizId(request));
		financePay.setCreateTime(new Date().getTime());
		boolean isInsert = financePay.getId() == null ? true : false; 
		int supplier_id;
		if(isInsert){
			financePay.setType(0);  //供应商订单付款
			//插入收款信息，并返回插入的ID
			supplier_id = financePayFacade.insertIncomePay(financePay);
		}else{
			//更新收款信息，并返回插入的ID
			supplier_id = financePay.getId();
			financePayFacade.updateIncomePay(financePay);
		}
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("supplierId", supplier_id);

        return successJson(map);
	}
	
	/**
	 * 添加订单
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "incomeOrderPayAddList.htm")
	public String incomeOrderPayAddList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "finance/incomePay/income-pay-order-list";
	}
	
	/**
	 * 添加订单Table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @param group
	 * @return
	 */
	@RequestMapping(value = "/incomeOrderPayAddListTable.do")
	public String incomeOrderPayAddListTable(HttpServletRequest request, ModelMap model, 
			Integer pageSize, Integer page, TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		String salesOperatorIds = productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(),group.getOrgIds(),WebUtils.getCurBizId(request));
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(StringUtils.isNotEmpty(salesOperatorIds)){
			pm.put("saleOperatorIds", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financePayFacade.loadIncomePayAddTableListPage(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("size", pageBean.getResult().size());
		return "finance/incomePay/income-pay-order-list-table";
	}
	
	/**
	 * 选择订单后加载订单到新增或编辑页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "loadOrderPayTable.do")
	public String loadOrderPayTable(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,String ids,Integer supplierType,String payId){
		Map<String, Object> mapObj= financePayFacade.findOrderToIncomePayList(ids, supplierType, payId);
		model.addAttribute("list", mapObj);
		return "finance/incomePay/income-pay-list-table";
		
	}
	
	/**
	 * 将选中的订单信息插入子表中
	 * @param request
	 * @param reponse
	 * @param model
	 * @param pay
	 * @return
	 */
	@RequestMapping(value = "incomePayDetailInsert.do")
	@ResponseBody
	public String incomePayDetailInsert(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, Integer supplierType,Integer payId,String details){
		
		List<FinancePayDetail> fPDetails = JSON.parseArray(details, FinancePayDetail.class);
//		if(fPDetails != null && fPDetails.size() > 0){
//			boolean isInsert = payId == null ? true : false;
//			for (FinancePayDetail fpd : fPDetails) {
//				fpd.setPayId(payId);
//				if(isInsert){
//					financePayDetailService.insertFinancePayDetail(fpd);
//				}else {
//					FinancePayDetail detailBean = financePayDetailService.selectByPayIdAndLocOrderId(payId, fpd.getLocOrderId());
//					if(detailBean != null){
//						detailBean.setCash(fpd.getCash());
//						financePayDetailService.updateFinancePayDetail(detailBean);
//					}else{
//						financePayDetailService.insertFinancePayDetail(fpd);
//					}
//				}
//			}
//
//			//汇总，到业务表的total_cash
//			financePayService.batchUpdateTotalCash(payId, supplierType);
//		}
		financePayFacade.batchUpdateTotalCash(payId,supplierType,fPDetails);
		return successJson();
	}
	
	/**
	 * 收款记录查看页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param payId
	 * @return
	 */
	@RequestMapping(value = "incomeView.htm")
	public String incomeView(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		//获取操作员
		PlatformEmployeePo employee = WebUtils.getCurUser(request);
		if (employee != null) {
			model.addAttribute("operatePerson", employee.getName());
		}
		model.addAttribute("pay", financePayFacade.loadByPrimaryKey(payId));
		return "finance/incomePay/income-pay-view";
	}
	
	
	/**
	 * 点击移除时，删除单条订单信息
	 * @param request
	 * @param reponse
	 * @param model
	 * @param OrderId 订单ID
	 * @param payId 收款ID
	 * @return
	 */
	@RequestMapping(value = "deletePayDetailOrder.do")
	@ResponseBody
	public String deletePayDetailOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer orderId,Integer payId){
		financePayDetailFacade.deleteByPayIdAndOrder(payId, orderId);
		return successJson();
	}
	
	/**
	 * 点击删除选中时，批量删除收款订单信息
	 * @param request
	 * @param reponse
	 * @param model
	 * @param dataOrder 订单ID，包含多条订单
	 * @param payId 收款ID
	 * @return
	 */
	@RequestMapping(value = "batchDelPayDetailOrder.do")
	@ResponseBody
	public String batchDelPayDetailOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,String dataOrder,Integer payId){
		Set<Integer> locOrderIdSet = new HashSet<Integer>();
        String[] orderIdsArr = dataOrder.split(",");
        for (String orderIdStr : orderIdsArr) {
        	locOrderIdSet.add(Integer.valueOf(orderIdStr));
        }
		financePayDetailFacade.batchDeleteByPayIdLocOrderId(payId, locOrderIdSet);
		return successJson();
	}
	
	/**
	 * 删除财务-收款
	 */
	@RequestMapping(value = "deleteFinancePay.do")
	@ResponseBody
	@PostHandler
	public String deleteFinancePay(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		try { 
//			financePayService.deletePayById(id);
//			financePayDetailService.deleteByPayId(id);
			financePayFacade.deletePayById(id);
			return successJson("msg", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("操作失败");
		}
	}
	
	/**
	 * 财务-付款页面,原来FinanceController中的请求incomeRecordList.htm不在使用
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("paymentRecord.htm")
	public String PaymentRecordList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model){
		//获取支付方式
		List<DicInfo> payTypeList = basicCommonFacade .getListByTypeCode(BasicConstants.CW_ZFFS);
		model.addAttribute("payTypeList", payTypeList);
		return "finance/incomePay/payment-list";
	}
	
	/**
	 * 财务-付款Table
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("paymentRecordListTable.do")
	public String paymentRecordListTable(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,
			Integer pageSize,Integer page){
		PageBean<FinancePay> pageBean = new PageBean<FinancePay>();
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
		//获取请求中的参数信息
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		
		pms.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pms);
		//获取收款数据
//		pageBean = fi.loadIncomePayRecordListPage(pageBean, WebUtils.getCurBizId(request));
		//获取收款总计
//		Map<String, Object> fp = financePayService.loadIncomePayRecordTotal(pageBean, WebUtils.getCurBizId(request));
		FinancePayResult result = financePayFacade.loadIncomePayRecordListPage(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("fp", result.getResultMap());
		return "finance/incomePay/payment-table";
	}
	
	/**
	 * 跳转到付款新增页面
	 */
	@RequestMapping(value = "paymentAdd.htm")
	public String paymentAdd(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		//支付方式
		List<DicInfo> payTypeList = basicCommonFacade
				.getListByTypeCode(BasicConstants.CW_ZFFS);
		model.addAttribute("payTypeList", payTypeList);
		Integer biz_id = WebUtils.getCurBizId(request);
		
		//供应商类别
		model.addAttribute("supplierTypeMapPay", SupplierConstant.supplierTypeMapPay);
		//获取操作员
		PlatformEmployeePo employee = WebUtils.getCurUser(request);
		if (employee != null) {
			model.addAttribute("operatePerson", employee.getName());
		}
		if (payId != null) {
			model.addAttribute("pay", financePayFacade.selectPayById(payId));
		}else{
			model.addAttribute("currDate", new Date());
		}
		return "finance/incomePay/payment-add";
	}
	
	/**
	 * 付款记录查看页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param payId
	 * @return
	 */
	@RequestMapping(value = "paymentView.htm")
	public String paymentView(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		//获取操作员
		PlatformEmployeePo employee = WebUtils.getCurUser(request);
		if (employee != null) {
			model.addAttribute("operatePerson", employee.getName());
		}
		model.addAttribute("pay", financePayFacade.loadByPrimaryKey(payId));
		return "finance/incomePay/payment-view";
	}
	
	/**
	 * 添加订单-付款
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "paymentOrderPayAddList.htm")
	public String paymentOrderPayAddList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
		return "finance/incomePay/payment-order-list";
	}
	
	/**
	 * 添加订单Table-付款
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @param group
	 * @return
	 */
	@RequestMapping(value = "/paymentOrderAddListTable.do")
	public String paymentOrderAddListTable(HttpServletRequest request, ModelMap model, 
			Integer pageSize, Integer page, TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		String salesOperatorIds = productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(),group.getOrgIds(),WebUtils.getCurBizId(request));
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(StringUtils.isNotEmpty(salesOperatorIds)){
			pm.put("saleOperatorIds", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financePayFacade.loadIncomePayAddTableListPage(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("size", pageBean.getResult().size());
		return "finance/incomePay/payment-order-list-table";
	}
	
	/**
	 * 保存新增付款信息
	 * @param request
	 * @param reponse
	 * @param model
	 * @param pay
	 * @return
	 */
	@RequestMapping(value = "paymentSave.do")
	@ResponseBody
	public String paymentSave(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, FinancePay financePay){
		PlatformEmployeePo empBean = WebUtils.getCurUser(request);
		financePay.setUserId(empBean.getEmployeeId());
		financePay.setUserName(empBean.getName());
		financePay.setBizId(WebUtils.getCurBizId(request));
		financePay.setCreateTime(new Date().getTime());
		boolean isInsert = financePay.getId() == null ? true : false; 
		int supplier_id;
		if(isInsert){
			financePay.setType(0);  //供应商订单付款
			//插入收款信息，并返回插入的ID
			supplier_id = financePayFacade.insertIncomePay(financePay);
		}else{
			//更新收款信息，并返回插入的ID
			supplier_id = financePay.getId();
			financePayFacade.updateIncomePay(financePay);
		}
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("supplierId", supplier_id);

        return successJson(map);
	}
	
	@RequestMapping(value = "paymentDetailInsert.do")
	@ResponseBody
	public String paymentDetailInsert(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, Integer supplierType,Integer payId,String details){
		
		List<FinancePayDetail> fPDetails = JSON.parseArray(details, FinancePayDetail.class);
//		if(fPDetails != null && fPDetails.size() > 0){
//			boolean isInsert = payId == null ? true : false;
//			for (FinancePayDetail fpd : fPDetails) {
//				fpd.setPayId(payId);
//				if(isInsert){
//					financePayDetailService.insertFinancePayDetail(fpd);
//				}else {
//					FinancePayDetail detailBean = financePayDetailService.selectByPayIdAndLocOrderId(payId, fpd.getLocOrderId());
//					if(detailBean != null){
//						detailBean.setCash(fpd.getCash());
//						financePayDetailService.updateFinancePayDetail(detailBean);
//					}else{
//						financePayDetailService.insertFinancePayDetail(fpd);
//					}
//				}
//			}
//
//			//汇总，到业务表的total_cash
//			financePayService.batchUpdateTotalCash(payId, supplierType);
//		}
		financePayFacade.batchUpdateTotalCash(payId,supplierType,fPDetails);
		
		return successJson();
	}

}
