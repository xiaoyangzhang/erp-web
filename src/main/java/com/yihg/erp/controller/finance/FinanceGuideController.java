package com.yihg.erp.controller.finance;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.yimayhd.erpcenter.facade.finance.query.AddCommission2DTO;
import org.yimayhd.erpcenter.facade.finance.query.FinanceGuideAuditListDTO;
import org.yimayhd.erpcenter.facade.finance.query.PayGuideBillPlusDTO;
import org.yimayhd.erpcenter.facade.finance.query.PayRecordDetailsDTO;
import org.yimayhd.erpcenter.facade.finance.query.QuerySettleListPageDTO;
import org.yimayhd.erpcenter.facade.finance.query.SaveCommissionDTO;
import org.yimayhd.erpcenter.facade.finance.result.CommissionListResult;
import org.yimayhd.erpcenter.facade.finance.result.QuerySettleListPageResult;
import org.yimayhd.erpcenter.facade.finance.result.ResultSupport;
import org.yimayhd.erpcenter.facade.finance.result.SettleListResult;
import org.yimayhd.erpcenter.facade.finance.result.ToAddCommission2Result;
import org.yimayhd.erpcenter.facade.finance.result.ToAddCommissionResult;
import org.yimayhd.erpcenter.facade.finance.service.FinanceGuideFacade;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.utils.DateUtils;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinancePay;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TeamGroupVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpresource.dal.constants.BasicConstants;

/**
 * 导游报账
 * 
 * @author Jing.Zhuo
 * @create 2015年8月13日 下午12:12:13
 */
@Controller
@RequestMapping(value = "/finance/guide")
public class FinanceGuideController extends BaseController {
	
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
	@Autowired
	private FinanceGuideFacade financeGuideFacade; 
	
	
	/**
	 * 跳转审核页面
	 */
	@RequestMapping(value = "auditList.htm")
	public String auditList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/guide/audit-list";
	}
	
	@RequestMapping(value = "auditList.do")
	public String auditList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {
		
		
		FinanceGuideAuditListDTO dto = new FinanceGuideAuditListDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		if(page != null){
			dto.setPage(page);
		}
		if(pageSize != null){
			dto.setPageSize(pageSize);
		}
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setRp(rp);
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		dto.setSl(ssl);
		dto.setSsl(ssl);
		dto.setSvc(svc);
		PageBean pb = financeGuideFacade.auditList(dto);
		model.addAttribute("pageBean", pb);
		return rp;
	}
	
	/**
	 * 跳转到导游报账记录页面
	 */
	@RequestMapping(value = "payRecordList.htm")
	public String payRecordList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "finance/guide/pay-list";
	}
	
	/**
	 * 跳转到导游报账记录明细页面
	 */
	@RequestMapping(value = "payRecordDetails.htm")
	public String payRecordDetails(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, Integer payId, Integer type, boolean isDeduction) {
		
		List<Map<String, Object>> list = financeGuideFacade.payRecordDetails(payId, type, isDeduction);
		request.setAttribute("list", list);
		
		return "finance/guide/pay-detail-list-table";
	}
	
	/**
	 * 读取导游报账记录列表
	 */
	@RequestMapping(value = "payRecordListPage.do")
	public String payRecordListPage(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, Integer page, Integer pageSize) {
		
		PayRecordDetailsDTO dto = new PayRecordDetailsDTO();
		dto.setBizId(dto.getBizId());
		dto.setOrgIds(dto.getOrgIds());
		if(page != null){
			dto.setPage(page);
		}
		if(pageSize != null){
			dto.setPageSize(pageSize);
		}
		dto.setParamters(dto.getParamters());
		dto.setSaleOperatorIds(dto.getSaleOperatorIds());
		dto.setSet(dto.getSet());
		PageBean pb = financeGuideFacade.payRecordListPage(dto);
		model.addAttribute("pageBean", pb);
		return "finance/guide/pay-list-table";
	}

	/**
	 * 跳转结算页面
	 */
	@RequestMapping(value = "settleList.htm")
	public String settleList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		SettleListResult settleResult = financeGuideFacade.settleList(bizId);
		model.addAttribute("payTypeList", settleResult.getPayTypeList());
		model.addAttribute("bizAccountList", settleResult.getBizAccountList());
		model.addAttribute("bankList", settleResult.getBankList());
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/guide/settle-list";
	}

	/**
	 * 审核导游报账单
	 */
	@RequestMapping(value = "auditGuideBill.do")
	@ResponseBody
	@PostHandler
	public String auditGuideBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
			
		ResultSupport result = financeGuideFacade.auditGuideBill(billId);
		if(result.isSuccess()){
			return successJson("msg", "审核成功");
		}else{
			return errorJson(result.getResultMsg());
		}
	}
	
	/**
	 * 取消审核导游报账单
	 */
	@RequestMapping(value = "delAuditGuideBill.do")
	@ResponseBody
	@PostHandler
	public String delAuditGuideBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
		financeGuideFacade.delAuditGuideBill(billId);
		return null;
	}


	/**
	 * 驳回导游报账单
	 */
	@RequestMapping(value = "rejectGuideBill.do")
	@ResponseBody
	@PostHandler
	public String rejectGuideBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
		financeGuideFacade.rejectGuideBill(billId);
		return null;
	}

	/**
	 * 报账单付款
	 */
	@RequestMapping(value = "payGuideBill.do")
	@ResponseBody
	@PostHandler
	public String payGuideBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, FinancePay pay) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		pay.setUserId(emp.getEmployeeId());
		pay.setUserName(emp.getName());
		financeGuideFacade.payGuideBill(pay);
		return null;
	}
	
	/**
	 * 报账单付款-改
	 */
	@RequestMapping(value = "payGuideBillPlus.do")
	@ResponseBody
	@PostHandler
	public String payGuideBillPlus(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, FinancePay pay,String checkedArr) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		pay.setUserId(emp.getEmployeeId());
		pay.setUserName(emp.getName());
		pay.setBizId(emp.getBizId());
		
		PayGuideBillPlusDTO dto = new PayGuideBillPlusDTO();
		dto.setPay(pay);
		dto.setCheckedArr(checkedArr);
		financeGuideFacade.payGuideBillPlus(dto);
		return null;
	}
	
	/**
	 * 删除导游报账付款
	 */
	@RequestMapping(value = "deletePay.do")
	@ResponseBody
	@PostHandler
	public String deletePay(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		financeGuideFacade.deletePay(payId);
		return null;
	}
	
	/**
	 * 删除佣金发放付款记录
	 */
	@RequestMapping(value = "deleteCommPay.do")
	@ResponseBody
	@PostHandler
	public String deleteCommPay(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		financeGuideFacade.deleteCommPay(payId);
		return null;
	}
	
	/**
	 * 删除佣金扣除付款记录
	 */
	@RequestMapping(value = "deletePayCommDeduction.do")
	@ResponseBody
	@PostHandler
	public String deletePayCommDeduction(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		financeGuideFacade.deletePayCommDeduction(payId);
		return null;
	}
//
//	/**
//	 * 提交到计调
//	 */
//	@RequestMapping(value = "submit2op.do")
//	@ResponseBody
//	@PostHandler
//	public String submit2op(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
//		financeGuideService.submit(billId, 1);
//		return null;
//	}
	
	/**
	 * 提交到财务
	 */
	@RequestMapping(value = "submit2fin.do")
	@ResponseBody
	@PostHandler
	public String submit2fin(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
		financeGuideFacade.submit2fin(billId);
		return null;
	}
	
	/**
	 * 获取导游列表
	 * @param request
	 * @param reponse
	 * @param name
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "getGuideNameList.do" ,method = RequestMethod.GET)
	@ResponseBody
	public String getUserNameList(HttpServletRequest request, HttpServletResponse reponse, String name){
 		List<Map<String,String>> list = financeGuideFacade.getGuideNameList(WebUtils.getCurBizId(request), name);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}
	
	/**
	 * 跳转到发放佣金录入页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/addCommission.htm")
	public String addCommission(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId) {
		
		ToAddCommissionResult result = financeGuideFacade.addCommission(WebUtils.getCurBizId(request), groupId, BasicConstants.YJ_XMLX);
		model.addAttribute("guideList", result.getGuideList());
		model.addAttribute("comList", result.getComList());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		return "finance/commission/add-commission";
	}
	
	/**
	 * 跳转到扣除佣金录入页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/addCommissionDeduction.htm")
	public String addCommissionDeduction(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId) {
		
		ToAddCommissionResult result = financeGuideFacade.addCommission(WebUtils.getCurBizId(request), groupId, BasicConstants.YJ_KKXM);
		
		model.addAttribute("guideList", result.getGuideList());
		model.addAttribute("comList", result.getComList());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		return "finance/commission/addCommissionDeduction";
	}
	
	@RequestMapping(value = "/addCommission2.htm")
	public String addCommission2(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId,Integer guideId) {
		AddCommission2DTO dto = new AddCommission2DTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGroupId(groupId);
		dto.setGuideId(guideId);
		ToAddCommission2Result result = financeGuideFacade.addCommission2(dto);
		
		model.addAttribute("supplierGuide", result.getSupplierGuide());
		model.addAttribute("financeCommissions", result.getFinanceCommissions());
		model.addAttribute("financeCommissionDeductions", result.getFinanceCommissionDeductions());
		model.addAttribute("tourGroup", result.getTourGroup());
		model.addAttribute("guideList", result.getGuideList());
		model.addAttribute("comList", result.getComList());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		model.addAttribute("dicInfoList2", result.getDicInfoList2());
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/commission/add-commission2";
	}
	
	/**
	 * 跳转到导游佣金列表页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/commissionList.htm")
	public String commissionList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId) {
		
		CommissionListResult result = financeGuideFacade.commissionList(WebUtils.getCurBizId(request), groupId);
		model.addAttribute("guideList", result.getGuideList());
		model.addAttribute("comList", result.getComList());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		return "finance/commission/commission-list";
	}
	
	/**
	 * 添加导游发放佣金
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCommission.do")
	@ResponseBody
	public String saveCommission(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId, String content) {
		
		PlatformEmployeePo employ = WebUtils.getCurUser(request);
		
		SaveCommissionDTO dto = new SaveCommissionDTO();
		dto.setBizId(employ.getBizId());
		dto.setContent(content);
		dto.setEmployeeId(employ.getEmployeeId());
		dto.setEmployeeName(employ.getName());
		dto.setGroupId(groupId);
		ResultSupport result = financeGuideFacade.saveCommission(dto);
		
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}
		return errorJson("操作失败");
	}
	
	/**
	 * 添加导游扣除佣金
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCommissionDeduction.do")
	@ResponseBody
	public String saveCommissionDeduction(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId, String content) {
		
		PlatformEmployeePo employ = WebUtils.getCurUser(request);
		SaveCommissionDTO dto = new SaveCommissionDTO();
		dto.setBizId(employ.getBizId());
		dto.setContent(content);
		dto.setEmployeeId(employ.getEmployeeId());
		dto.setEmployeeName(employ.getName());
		dto.setGroupId(groupId);
		ResultSupport result = financeGuideFacade.saveCommissionDeduction(dto);
		
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}
		return errorJson("操作失败");
	}
	
	/**
	 * 删除导游佣金
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/deleteCommission.do")
	@ResponseBody
	public String deleteCommission(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer id) {
		
		ResultSupport result = financeGuideFacade.deleteCommission(id);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}
		return successJson("msg", result.getResultMsg());
	}
	
	
	
	@RequestMapping(value = "/querySettleListPage.htm")
	public String querySettleListPage(HttpServletRequest request, ModelMap model,Integer pageSize,Integer page,TourGroupVO group) {
		
		QuerySettleListPageDTO dto = new QuerySettleListPageDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		if(page != null){
			dto.setPage(page);
		}
		if(pageSize != null){
			dto.setPageSize(pageSize);
		}
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		QuerySettleListPageResult result = financeGuideFacade.querySettleListPage(dto);
		
		model.addAttribute("sumTotalAmount", result.getSumTotalAmount());
		model.addAttribute("sumTotalCash", result.getSumTotalCash());
		model.addAttribute("sumCommTotal", result.getSumCommTotal());
		model.addAttribute("sumCommTotalCash", result.getSumCommTotalCash());
		model.addAttribute("pageBean", result.getPageBean());
		
		return "finance/guide/settle-list-table";
	}
	
	/**
	 * 购物佣金发放付款
	 */
	@RequestMapping(value = "payCommBill.do")
	@ResponseBody
	@PostHandler
	public String payCommBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, FinancePay pay) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		pay.setUserId(emp.getEmployeeId());
		pay.setUserName(emp.getName());
		pay.setBizId(emp.getBizId());
		financeGuideFacade.payCommBill(pay);
		return null;
	}
	
	/**
	 * 购物佣金扣除付款
	 */
	@RequestMapping(value = "payCommDeductionBill.do")
	@ResponseBody
	@PostHandler
	public String payCommDeductionBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, FinancePay pay) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		pay.setUserId(emp.getEmployeeId());
		pay.setUserName(emp.getName());
		pay.setBizId(emp.getBizId());
		financeGuideFacade.payCommDeductionBill(pay);
		return null;
	}
}
