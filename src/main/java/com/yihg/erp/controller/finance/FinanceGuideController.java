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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.CommonService;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.exception.ClientException;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceGuideService;
import com.yihg.finance.po.FinanceCommission;
import com.yihg.finance.po.FinancePay;
import com.yihg.images.util.DateUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.SupplierGuideService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierGuide;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.api.SysBizBankAccountService;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.SysBizBankAccount;

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
	private FinanceGuideService financeGuideService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SysBizBankAccountService sysBizBankAccountService;
	@Autowired
	private BookingGuideService bookingGuideService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private SupplierGuideService supplierGuideService;
	@Autowired
	private BookingSupplierDetailService bookingSupplierDetailService;
	@Autowired
	private ApplicationContext appContext;
	
	
	/**
	 * 跳转审核页面
	 */
	@RequestMapping(value = "auditList.htm")
	public String auditList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/guide/audit-list";
	}
	
	@RequestMapping(value = "auditList.do")
	public String auditList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {

		PageBean pb = new PageBean();
		pb.setPage(page);
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}
		pb.setPageSize(pageSize);
		//如果人员为空并且部门不为空，则取部门下的人id
		if(org.apache.commons.lang.StringUtils.isBlank(group.getSaleOperatorIds()) && org.apache.commons.lang.StringUtils.isNotBlank(group.getOrgIds())){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		Map<String,Object> pms  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pms.put("operator_id", group.getSaleOperatorIds());
		}
		pms.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pms);
		pb = getCommonService(svc).queryListPage(sl, pb);
		List<Map<String, Object>> results = pb.getResult();
		if(results != null){
			for(Map<String, Object> item : results){
				Integer groupId = Integer.parseInt(item.get("group_id").toString());
				Integer guideId = Integer.parseInt(item.get("guide_id").toString());
				Integer commTotal = financeGuideService.getCommisionTotalSum(groupId, guideId);
				item.put("comm_total", commTotal != null ? commTotal : 0);
			}
		}

		model.addAttribute("pageBean", pb);
		return rp;
	}
	
	/**
	 * 获取查询服务
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年8月18日 上午9:34:25
	 * @param svc
	 * @return
	 */
	private CommonService getCommonService(String svc) {
		if (org.apache.commons.lang.StringUtils.isBlank(svc)) {
			svc = "commonsaleService";
		}
		return appContext.getBean(svc, CommonService.class);
	}
	
	/**
	 * 跳转到导游报账记录页面
	 */
	@RequestMapping(value = "payRecordList.htm")
	public String payRecordList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "finance/guide/pay-list";
	}
	
	/**
	 * 跳转到导游报账记录明细页面
	 */
	@RequestMapping(value = "payRecordDetails.htm")
	public String payRecordDetails(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, Integer payId, Integer type, boolean isDeduction) {
		
		Map<String, Object> payMap = null;
		
		 //佣金报账
		if(type == 1){
			if(isDeduction){
				payMap = financeGuideService.selectCommPayDeductionInfo(payId);
			}else{
				payMap = financeGuideService.selectCommPayInfo(payId);
			}
		}
		//导游报账
		else if(type == 2){ 
			payMap = financeGuideService.selectGuidePayInfo(payId);
		}
		
		if(payMap != null){
			
			List<Map<String, Object>> list =null;
			if(type == 1){
				if(isDeduction){
					list = financeGuideService.selectCommPayDetailsDeductionByPayId(payId);
				}else{
					list = financeGuideService.selectCommPayDetailsByPayId(payId);
				}
			}else if(type == 2){
				list = financeGuideService.selectGuidePayDetailsByPayId(payId);
				if(list != null && list.size() > 0){
					Map<String, Object> item = null;
					for(int i = 0; i < list.size(); i++){
						item = list.get(i);
						Integer bookingId = Integer.parseInt(item.get("supplier_id").toString());
						Integer supType = Integer.parseInt(item.get("supplier_type").toString());
						String remark = item.get("remark") != null ? item.get("remark").toString() : "";
						List<BookingSupplierDetail> detailList = bookingSupplierDetailService.selectByPrimaryBookId(bookingId);
						String details = bookingSupplierDetailService.concatDetail(supType, remark, detailList);
						item.put("details", details);
					}
				}
			}
			request.setAttribute("list", list);
		}
		
		return "finance/guide/pay-detail-list-table";
	}
	
	/**
	 * 读取导游报账记录列表
	 */
	@RequestMapping(value = "payRecordListPage.do")
	public String payRecordListPage(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, Integer page, Integer pageSize) {
		PageBean pb = new PageBean();
		pb.setPage(page);
		if(pageSize==null){
			pb.setPageSize(Constants.PAGESIZE);
		}else{
			pb.setPageSize(pageSize);
		}
		String saleOperatorIds = request.getParameter("saleOperatorIds");
		String orgIds = request.getParameter("orgIds");
		//如果人员为空并且部门不为空，则取部门下的人id
		if(StringUtils.isEmpty(saleOperatorIds) && !StringUtils.isEmpty(orgIds)){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = orgIds.split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				saleOperatorIds = salesOperatorIds.substring(0, salesOperatorIds.length()-1);
			}
		}
		Map pm = WebUtils.getQueryParamters(request);
		pm.put("saleOperatorIds", saleOperatorIds);
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pm);
		pb = financeGuideService.selectGuideCashRecordListPage(pb);
		model.addAttribute("pageBean", pb);
		return "finance/guide/pay-list-table";
	}

	/**
	 * 跳转结算页面
	 */
	@RequestMapping(value = "settleList.htm")
	public String settleList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		Integer biz_id = WebUtils.getCurBizId(request);
		
		List<DicInfo> payTypeList = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS,biz_id);
		model.addAttribute("payTypeList", payTypeList);
		
		List<SysBizBankAccount> bizAccountList = sysBizBankAccountService.getListByBizId(biz_id);
		List<DicInfo> bankList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_BANK);
		model.addAttribute("bizAccountList", bizAccountList);
		model.addAttribute("bankList", bankList);
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
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
		try{
			financeGuideService.auditGuideBill(billId);
		}catch(ClientException ex){
			return errorJson(ex.getMessage());
		}catch(Exception ex){
			return errorJson("审核出错");
		}
		return successJson("msg", "审核成功");
	}
	
	/**
	 * 取消审核导游报账单
	 */
	@RequestMapping(value = "delAuditGuideBill.do")
	@ResponseBody
	@PostHandler
	public String delAuditGuideBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
		financeGuideService.delAuditGuideBill(billId);
		return null;
	}


	/**
	 * 驳回导游报账单
	 */
	@RequestMapping(value = "rejectGuideBill.do")
	@ResponseBody
	@PostHandler
	public String rejectGuideBill(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer billId) {
		financeGuideService.rejectGuideBill(billId);
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
		financeGuideService.payGuideBill(pay);
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
		financeGuideService.payGuideBill(pay,checkedArr,WebUtils.getCurUser(request).getName());
		
		//佣金发放付款
		pay.setBookingGuideId(null);
		financeGuideService.payCommBill(pay);
		
		//佣金扣除付款
		pay.setCommissionIds(pay.getCommissionDeductionIds());
		financeGuideService.payCommDeductionBill(pay);
		return null;
	}
	
	/**
	 * 删除导游报账付款
	 */
	@RequestMapping(value = "deletePay.do")
	@ResponseBody
	@PostHandler
	public String deletePay(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		financeGuideService.deletePayById(payId);
		return null;
	}
	
	/**
	 * 删除佣金发放付款记录
	 */
	@RequestMapping(value = "deleteCommPay.do")
	@ResponseBody
	@PostHandler
	public String deleteCommPay(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		financeGuideService.deletePayCommById(payId);
		return null;
	}
	
	/**
	 * 删除佣金扣除付款记录
	 */
	@RequestMapping(value = "deletePayCommDeduction.do")
	@ResponseBody
	@PostHandler
	public String deletePayCommDeduction(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		financeGuideService.deletePayCommDeductionById(payId);
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
		financeGuideService.submit(billId, 2);
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
	public String getUserNameList(HttpServletRequest request, HttpServletResponse reponse, String name) throws UnsupportedEncodingException{
 		List<Map<String,String>> list = financeGuideService.getGuideNameList(WebUtils.getCurBizId(request),java.net.URLDecoder.decode(name,"UTF-8"));
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
	public String shopDetailList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId) {
		List<FinanceCommission> comList = financeGuideService.selectCommissionByGroupId(groupId);
		List<BookingGuide> guideList = bookingGuideService.selectDistinctListByGroupId(groupId);
		List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("guideList", guideList);
		model.addAttribute("comList", comList);
		model.addAttribute("dicInfoList", dicInfoList);
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
		List<FinanceCommission> comList = financeGuideService.selectCommissionDeductionByGroupId(groupId);
		List<BookingGuide> guideList = bookingGuideService.selectDistinctListByGroupId(groupId);
		List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request));
		model.addAttribute("guideList", guideList);
		model.addAttribute("comList", comList);
		model.addAttribute("dicInfoList", dicInfoList);
		return "finance/commission/addCommissionDeduction";
	}
	
	@RequestMapping(value = "/addCommission2.htm")
	public String shopDetailList2(HttpServletRequest request,HttpServletResponse reponse,ModelMap model, Integer groupId,Integer guideId) {
		List<FinanceCommission> comList = financeGuideService.selectCommissionByGroupId(groupId);
		List<BookingGuide> guideList = bookingGuideService.selectDistinctListByGroupId(groupId);
		List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		List<DicInfo> dicInfoList2 = dicService.getListByTypeCode(BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request));
		
		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		if(guideId==null){
			if(guideList.size()>0){
				guideId=guideList.get(0).getGuideId();
			}
		}
		//根据团id和导游Id查询佣金
		List<FinanceCommission> financeCommissions = financeGuideService.getFinanceCommisionByGroupIdAndGuideId(WebUtils.getCurBizId(request),groupId,guideId);
		List<FinanceCommission> financeCommissionDeductions = financeGuideService.getFinanceCommisionDeductionByGroupIdAndGuideId(WebUtils.getCurBizId(request),groupId,guideId);
		//导游信息
		SupplierGuide supplierGuide = supplierGuideService.getGuideInfoById(guideId);
		
		model.addAttribute("supplierGuide", supplierGuide);
		model.addAttribute("financeCommissions", financeCommissions);
		model.addAttribute("financeCommissionDeductions", financeCommissionDeductions);
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("guideList", guideList);
		model.addAttribute("comList", comList);
		model.addAttribute("dicInfoList", dicInfoList);
		model.addAttribute("dicInfoList2", dicInfoList2);
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
		List<FinanceCommission> comList = financeGuideService.selectCommissionByGroupId(groupId);
		List<BookingGuide> guideList = bookingGuideService.selectDistinctListByGroupId(groupId);
		List<DicInfo> dicInfoList = dicService.getListByTypeCode(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("guideList", guideList);
		model.addAttribute("comList", comList);
		model.addAttribute("dicInfoList", dicInfoList);
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
		try{
			PlatformEmployeePo employ = WebUtils.getCurUser(request);
			if(StringUtils.isEmpty(content) || "[]".equals(content)){
				financeGuideService.deleteCommissionByGroupId(employ.getBizId(), groupId);
				return successJson("msg", "操作成功");
			}
			List<FinanceCommission> list = JSON.parseArray(content, FinanceCommission.class);
			financeGuideService.batchInsertCommission(employ.getBizId(), employ.getEmployeeId(), employ.getName(), list);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
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
		try{
			PlatformEmployeePo employ = WebUtils.getCurUser(request);
			if(StringUtils.isEmpty(content) || "[]".equals(content)){
				financeGuideService.deleteCommissionDeductionByGroupId(employ.getBizId(), groupId);
				return successJson("msg", "操作成功");
			}
			List<FinanceCommission> list = JSON.parseArray(content, FinanceCommission.class);
			financeGuideService.batchInsertCommissionDeduction(employ.getBizId(), employ.getEmployeeId(), employ.getName(), list);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
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
		try{
			if(StringUtils.isEmpty(id)){
				return errorJson("要删除的佣金ID不能为空");
			}
			financeGuideService.deleteByPrimaryKey(id);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	
	
	
	@RequestMapping(value = "/querySettleListPage.htm")
	public String querySettleListPage(HttpServletRequest request, ModelMap model,Integer pageSize,Integer page,TourGroupVO group) {
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
		if(org.apache.commons.lang.StringUtils.isBlank(group.getSaleOperatorIds()) && org.apache.commons.lang.StringUtils.isNotBlank(group.getOrgIds())){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		
		pageBean = financeGuideService.querySettleListPage(pageBean, WebUtils.getCurBizId(request));
		List<Map<String, Object>> results = pageBean.getResult();
		if(results != null){
			for(Map<String, Object> item : results){
				
				Integer groupId = Integer.parseInt(item.get("group_id").toString());
				Integer guideId = Integer.parseInt(item.get("guide_id").toString());
				Map<String, Object> commMap = financeGuideService.getCommisionTotalSumAndTotalCashSum(groupId, guideId);
				if(commMap != null){
					BigDecimal total = new BigDecimal(commMap.get("total").toString());
					BigDecimal totalCash = new BigDecimal(commMap.get("total_cash").toString());
					item.put("comm_total", total);
					item.put("comm_total_cash", totalCash);
				}else{
					item.put("comm_total", 0);
					item.put("comm_total_cash", 0);
				}
			}
		}
		
		BigDecimal sumTotalAmount = financeGuideService.getSumTotal(pageBean, WebUtils.getCurBizId(request));
		BigDecimal sumTotalCash = financeGuideService.getSumTotalCash(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("sumTotalAmount", sumTotalAmount);
		model.addAttribute("sumTotalCash", sumTotalCash);
		
		Map<String, Object>	allCommTotalMap = financeGuideService.getAllTotalSumAndTotalCashSum(pageBean);
		if(allCommTotalMap != null){
			BigDecimal total = new BigDecimal(allCommTotalMap.get("total").toString());
			BigDecimal totalCash = new BigDecimal(allCommTotalMap.get("total_cash").toString());
			model.addAttribute("sumCommTotal", total);
			model.addAttribute("sumCommTotalCash", totalCash);
		}
		
		model.addAttribute("pageBean", pageBean);
		
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
		financeGuideService.payCommBill(pay);
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
		financeGuideService.payCommDeductionBill(pay);
		return null;
	}
}
