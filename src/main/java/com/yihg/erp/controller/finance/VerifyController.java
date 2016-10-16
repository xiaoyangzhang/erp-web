
package com.yihg.erp.controller.finance;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.CommonService;
import com.yihg.basic.exception.ClientException;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceVerifyService;
import com.yihg.finance.po.FinanceVerify;
import com.yihg.finance.po.FinanceVerifyDetail;
import com.yihg.images.util.DateUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingDeliveryPriceService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.po.BookingDeliveryPrice;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.sales.api.GroupOrderPriceService;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.constants.Constants;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.po.PlatformEmployeePo;

/**
 * 对账管理
 * 
 * @author GUO.HONGFEI
 * @create 2015年10月9日 上午9:47:42
 */
@Controller
@RequestMapping(value = "/verify")
public class VerifyController extends BaseController {

	@Autowired
	private FinanceVerifyService financeVerifyService;
	
	@Resource
	private BizSettingCommon bizSettingCommon;
	
	@Autowired
	private GroupOrderPriceService	groupOrderPriceService;
	
	@Autowired
	private BookingDeliveryPriceService	bookingDeliveryPriceService;
	
	@Autowired
	private BookingSupplierDetailService bookingSupplierDetailService;
	
	@Autowired
	private PlatformOrgService orgService;
	
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	
	@Autowired
	private ApplicationContext appContext;

	/**
	 * 跳转到对账单页面
	 */
	@RequestMapping(value = "verifyList.htm")
	public String verifyList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,String supplierType) {
		model.addAttribute("supplierType", supplierType);
		return "finance/verify/verify-list";
	}
	
	/**
	 * 跳转到对账单查询页面
	 */
	@RequestMapping(value = "searchList.htm")
	public String searchList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,String supplierType) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("supplierType", supplierType);
		return "finance/verify/search-list";
	}
	
	@RequestMapping(value = "searchList.do")
	public String searchList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {

		PageBean pb = new PageBean();
		pb.setPage(page);
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}
		pb.setPageSize(pageSize);
		//如果人员为空并且部门不为空，则取部门下的人id
		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
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
		if (StringUtils.isBlank(svc)) {
			svc = "commonsaleService";
		}
		return appContext.getBean(svc, CommonService.class);
	}
	
	/**
	 * 修改对账单状态
	 */
	@RequestMapping(value = "/changeStatus.do",method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String changeStatus(HttpServletRequest request, String id){
		financeVerifyService.changeStatus(id);
		return null;
	}
	
	/**
	 * 跳转到新增对账单页面
	 */
	@RequestMapping(value = "addVerifyRecord.htm")
	public String addVerifyRecord(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		return "finance/verify/add-verify-record";
	}
	
	/**
	 * 跳转到添加订单页面
	 */
	@RequestMapping(value = "addVerifyDetail.htm")
	public String addVerifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "finance/verify/add-verify-detail";
	}
	
	/**
	 * 跳转到对账单详情页面
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "verifyDetail.htm")
	public String verifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String verifyId) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		FinanceVerify verify = financeVerifyService.selectVerify(bizId, verifyId);
		model.put("verify", verify);
		
		List<FinanceVerifyDetail> financeVerifyDetailSum = financeVerifyService.selectVerifyDetailSum(bizId, verifyId,verify.getSupplierType());
		if(financeVerifyDetailSum != null && financeVerifyDetailSum.size()>0){
			Map map= (Map) financeVerifyDetailSum.get(0);
			if(map != null){
				model.put("total_price", map.get("total_price"));
				model.put("total_cash", map.get("total_cash"));
				BigDecimal total_price = (BigDecimal)map.get("total_price");
				BigDecimal total_cash = (BigDecimal)map.get("total_cash");
				if(null==total_price){
					total_price=new BigDecimal(0);
				}
				if(null==total_cash){
					total_cash=new BigDecimal(0);
				}
				model.put("total_not",total_price.subtract(total_cash));
				model.put("total_adjust", map.get("total_adjust"));
			}
		}
		return "finance/verify/verify-detail";
	}
	
	/**
	 * 跳转到对账单详情打印页面
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "verifyDetailPrint.htm")
	public String verifyDetailPrint(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String verifyId) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		FinanceVerify verify = financeVerifyService.selectVerify(bizId, verifyId);
		model.put("verify", verify);
		
		List<FinanceVerifyDetail> financeVerifyDetailSum = financeVerifyService.selectVerifyDetailSum(bizId, verifyId,verify.getSupplierType());
		if(financeVerifyDetailSum != null && financeVerifyDetailSum.size()>0){
			Map map= (Map) financeVerifyDetailSum.get(0);
			if(map != null){
				model.put("total_price", map.get("total_price"));
				model.put("total_cash", map.get("total_cash"));
				BigDecimal total_price = (BigDecimal)map.get("total_price");
				BigDecimal total_cash = (BigDecimal)map.get("total_cash");
				if(null==total_price){
					total_price=new BigDecimal(0);
				}
				if(null==total_cash){
					total_cash=new BigDecimal(0);
				}
				model.put("total_not",total_price.subtract(total_cash));
				model.put("total_adjust", map.get("total_adjust"));
			}
		}
		
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		
		return "finance/verify/verify-detail-print";
	}
	
	/**
	 * 跳转到对账单详情页面
	 */
	@RequestMapping(value = "queyrVerifyDetail.do")
	public String queyrVerifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String verifyId) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		FinanceVerify verify = financeVerifyService.selectVerify(bizId, verifyId);
		model.put("verify", verify);
		
		Integer supplierType = verify.getSupplierType();
		List<Map<String, Object>> financeVerifyDetailList = financeVerifyService.selectVerifyDetailPage(bizId, verifyId, supplierType, WebUtils.getDataUserIdSet(request));
		
		if(financeVerifyDetailList != null && financeVerifyDetailList.size() > 0){
			
			Map<String, Object> map = null;
			for(int i = 0; i < financeVerifyDetailList.size(); i++){
				map = financeVerifyDetailList.get(i);
				Integer bookingId = map.get("booking_id") != null ? Integer.parseInt(map.get("booking_id").toString()) : 0;
				String details = "";
				if(Constants.TRAVELAGENCY.equals(supplierType)){
					List<GroupOrderPrice> priceList = groupOrderPriceService.selectByOrderAndType(bookingId, 0);
					details = groupOrderPriceService.concatDetail(priceList);
				}else if(Constants.LOCALTRAVEL.equals(supplierType)){
					List<BookingDeliveryPrice> priceList = bookingDeliveryPriceService.getPriceListByBookingId(bookingId);
					details = bookingDeliveryPriceService.concatDetail(priceList);
				}else{
					String remark = map.get("remark") != null ? map.get("remark").toString() : "";
					List<BookingSupplierDetail> detailList = bookingSupplierDetailService.selectByPrimaryBookId(bookingId);
					details = bookingSupplierDetailService.concatDetail(supplierType, remark, detailList);
				}
				
				map.put("details", details);
			}
		}
		model.put("financeVerifyDetailList", financeVerifyDetailList);
		return "finance/verify/verify-detail-table";
	}
	
	/**
	 * 跳转到对账单详情页面
	 */
	@RequestMapping(value = "queyrVerifyDetailTemp.do")
	public String queyrVerifyDetailTemp(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer page,
			Integer pageSize) {
		
		PageBean pageBean = new PageBean();
		pageBean.setPage(page);
		if(pageSize == null){
			pageSize = Constants.PAGESIZE;
		}
		pageBean.setPageSize(pageSize);
		pageBean.setParameter(WebUtils.getQueryParamters(request));
		pageBean = financeVerifyService.selectVerifyDetailOrderListPage(pageBean);
		model.put("pageBean", pageBean);
		return "finance/verify/verify-detail-table-temp";
	}
	
	/**
	 * 跳转到对账单-订单详情页面
	 */
	@RequestMapping(value = "queryVerifyDetailOrders.do")
	public String queryVerifyDetailOrders(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer page,
			Integer pageSize) {
		
		PageBean pageBean = new PageBean();
		pageBean.setPage(page);
		if(pageSize == null){
			pageSize = Constants.PAGESIZE;
		}
		pageBean.setPageSize(pageSize);
		Map<String, Object> pm = WebUtils.getQueryParamters(request);
		pm.put("set", WebUtils.getDataUserIdSet(request));
		
		Object orgIds = pm.get("orgIds");
		if(orgIds != null && StringUtils.isNotBlank(orgIds.toString())){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = orgIds.toString().split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				pm.put("saleOperatorIds", salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		
		pageBean.setParameter(pm);
		pageBean = financeVerifyService.selectVerifyDetailOrderListPage(pageBean);
		model.put("pageBean", pageBean);
		return "finance/verify/add-verify-detail-table";
	}
	
	
	/**
	 * 新增对账单
	 */
	@RequestMapping("saveVerifyRecord.do")
	@ResponseBody
	public String saveVerifyRecord(HttpServletRequest request, HttpServletResponse reponse, 
			Integer supplierType, String supplierName, String startTime, String endTime){
		try{
			
			Integer bizId = WebUtils.getCurBizId(request);
			String bizCode = bizSettingCommon.getMyBizCode(request);
			PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
			
			FinanceVerify verify = new FinanceVerify();
			verify.setVerifyState(0);
			Date dateStart = DateUtils.parse(startTime, DateUtils.FORMAT_SHORT);
			verify.setDateStart(dateStart);
			Date dateEnd = DateUtils.parse(endTime, DateUtils.FORMAT_SHORT);
			verify.setDateEnd(dateEnd);
			verify.setSupplierType(supplierType);
			verify.setBizId(bizId);
			verify.setSupplierName(supplierName);
			verify.setUserId(userInfo.getEmployeeId());
			verify.setUserName(userInfo.getName());
			
			Integer verifyId = financeVerifyService.insert(verify, bizCode);
			
			return successJson("verifyId", verifyId+"");
			
		}catch(ClientException e){
			e.printStackTrace();
			return errorJson(e.getMessage());
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	
	/**
	 * 获取供应商列表
	 * @param request
	 * @param reponse
	 * @param name
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "getSupplierNameList.do" ,method = RequestMethod.GET)
	@ResponseBody
	public String getSupplierNameList(HttpServletRequest request, HttpServletResponse reponse, Integer supplierType, String supplierName) throws UnsupportedEncodingException{
 		
		Integer bizId = WebUtils.getCurBizId(request);
		supplierName = java.net.URLDecoder.decode(supplierName,"UTF-8");
		List<Map<String,String>> list = financeVerifyService.getSupplierNameList(bizId, supplierType, supplierName);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}
	
	/**
	 * 删除对账单详情
	 * @param request
	 * @param reponse
	 * @param model
	 */
	@RequestMapping(value = "deleteVerifyDetail.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteVerifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, 
			Integer verifyId, Integer detailId, BigDecimal total, BigDecimal totalCash, BigDecimal totalAdjust) {
		
		try{
			Integer bizId = WebUtils.getCurBizId(request);
			financeVerifyService.deleteVerifyDetail(bizId, verifyId, detailId, total, totalCash, totalAdjust);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	
	/**
	 * 删除对账单
	 * @param request
	 * @param reponse
	 * @param model
	 */
	@RequestMapping(value = "deleteVerify.do")
	@ResponseBody
	public String deleteVerify(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id) {
		try{
			Integer bizId = WebUtils.getCurBizId(request);
			financeVerifyService.deleteVerifyAndDetail(bizId, id);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	
	/**
	 * 批量添加对账单详情
	 */
	@RequestMapping(value = "saveVerifyDetail.do")
	@ResponseBody
	@PostHandler
	public String saveVerifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer supplierType, Integer verifyId, String ids) {
		try{
			
			Integer bizId = WebUtils.getCurBizId(request);
			financeVerifyService.insertDetail(bizId, supplierType, verifyId, ids);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	
	/**
	 * 批量添加对账单详情
	 */
	@RequestMapping(value = "updateVerifyDetail.do")
	@ResponseBody
	@PostHandler
	public String updateVerifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer supplierType, Integer verifyId, String records) {
		try{
			Integer bizId = WebUtils.getCurBizId(request);
			financeVerifyService.updateDetail(bizId, supplierType, verifyId, records);
			return successJson("msg", "操作成功");
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
}
