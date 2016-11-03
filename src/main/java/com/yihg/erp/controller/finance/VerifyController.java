
package com.yihg.erp.controller.finance;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.yimayhd.erpcenter.facade.finance.query.DeleteVerifyDetialDTO;
import org.yimayhd.erpcenter.facade.finance.query.QueryVerifyDetailDTO;
import org.yimayhd.erpcenter.facade.finance.query.QueryVerifyDetailTempDTO;
import org.yimayhd.erpcenter.facade.finance.query.SaveVerifyDetailDTO;
import org.yimayhd.erpcenter.facade.finance.query.SearchListDTO;
import org.yimayhd.erpcenter.facade.finance.query.UpdateVerifyDetailDTO;
import org.yimayhd.erpcenter.facade.finance.result.QueryVerifyDetailResult;
import org.yimayhd.erpcenter.facade.finance.result.ResultSupport;
import org.yimayhd.erpcenter.facade.finance.result.VerifyDetailResult;
import org.yimayhd.erpcenter.facade.finance.service.VerifyFacade;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.util.DateUtils;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinanceVerify;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpresource.dal.exception.ClientException;

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
	private ProductCommonFacade productCommonFacade;
	
	@Autowired
	private ApplicationContext appContext;
	
	@Autowired
	private VerifyFacade verifyFacade;
	
	@Resource
	private BizSettingCommon bizSettingCommon;
	
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
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("supplierType", supplierType);
		
		
		return "finance/verify/search-list";
	}
	
	@RequestMapping(value = "searchList.do")
	public String searchList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, TourGroupVO group) {
		
		SearchListDTO dto = new SearchListDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(page);
		dto.setPageSize(pageSize);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setRp(rp);
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		dto.setSl(ssl);
		dto.setSsl(ssl);
		dto.setSvc(svc);
		PageBean pb = verifyFacade.searchList(dto);
		model.addAttribute("pageBean", pb);
		return rp;
	}
	
	/**
	 * 修改对账单状态
	 */
	@RequestMapping(value = "/changeStatus.do",method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String changeStatus(HttpServletRequest request, String id){
		verifyFacade.changeStatus(id);
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
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "finance/verify/add-verify-detail";
	}
	
	/**
	 * 跳转到对账单详情页面
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "verifyDetail.htm")
	public String verifyDetail(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String verifyId) {
		
		VerifyDetailResult result = verifyFacade.verifyDetail(WebUtils.getCurBizId(request), verifyId);
		
		model.put("verify", result.getVerify());
		model.put("total_price", result.getTotalPrice());
		model.put("total_cash", result.getTotalCash());
		model.put("total_not", result.getTotalNot());
		model.put("total_adjust", result.getTotalAdjust());
		
		return "finance/verify/verify-detail";
	}
	
	/**
	 * 跳转到对账单详情打印页面
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "verifyDetailPrint.htm")
	public String verifyDetailPrint(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String verifyId) {
		
		VerifyDetailResult result = verifyFacade.verifyDetail(WebUtils.getCurBizId(request), verifyId);
		
		model.put("verify", result.getVerify());
		model.put("total_price", result.getTotalPrice());
		model.put("total_cash", result.getTotalCash());
		model.put("total_not", result.getTotalNot());
		model.put("total_adjust", result.getTotalAdjust());
		
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
		
		QueryVerifyDetailDTO dto = new QueryVerifyDetailDTO();
		dto.setBizId(bizId);
		dto.setVerifyId(verifyId);
		dto.setSet(WebUtils.getDataUserIdSet(request));
		QueryVerifyDetailResult result = verifyFacade.queryVerifyDetail(dto);
		model.put("verify", result.getVerify());
		model.put("financeVerifyDetailList", result.getFinanceVerifyDetailList());
		
		return "finance/verify/verify-detail-table";
	}
	
	/**
	 * 跳转到对账单详情页面
	 */
	@RequestMapping(value = "queyrVerifyDetailTemp.do")
	public String queyrVerifyDetailTemp(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, 
			Integer page, Integer pageSize) {
		
		QueryVerifyDetailTempDTO dto = new QueryVerifyDetailTempDTO();
		if(page != null){
			dto.setPage(page);
		}
		if(pageSize != null){
			dto.setPageSize(pageSize);
		}
		dto.setParamters(WebUtils.getQueryParamters(request));
		PageBean pageBean = verifyFacade.queyrVerifyDetailTemp(dto);
		model.put("pageBean", pageBean);
		return "finance/verify/verify-detail-table-temp";
	}
	
	/**
	 * 跳转到对账单-订单详情页面
	 */
	@RequestMapping(value = "queryVerifyDetailOrders.do")
	public String queryVerifyDetailOrders(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, 
			Integer page, Integer pageSize) {
		
		QueryVerifyDetailTempDTO dto = new QueryVerifyDetailTempDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		if(page != null){
			dto.setPage(page);
		}
		if(pageSize != null){
			dto.setPageSize(pageSize);
		}
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSet(WebUtils.getDataUserIdSet(request));
		PageBean pageBean = verifyFacade.queryVerifyDetailOrders(dto);
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
			
			ResultSupport result = verifyFacade.saveVerifyRecord(verify, bizCode);
			
			return successJson("verifyId", result.getResultMsg());
			
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
		List<Map<String,String>> list = verifyFacade.getSupplierNameList(bizId, supplierType, supplierName);
		
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
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		DeleteVerifyDetialDTO dto = new DeleteVerifyDetialDTO();
		dto.setBizId(bizId);
		dto.setDetailId(detailId);
		dto.setTotal(totalAdjust);
		dto.setTotalAdjust(totalAdjust);
		dto.setTotalCash(totalCash);
		dto.setVerifyId(verifyId);
		
		ResultSupport result = verifyFacade.deleteVerifyDetail(dto);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
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
			
		Integer bizId = WebUtils.getCurBizId(request);
		ResultSupport result = verifyFacade.deleteVerify(bizId, id);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
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
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		SaveVerifyDetailDTO dto = new SaveVerifyDetailDTO();
		dto.setBizId(bizId);
		dto.setSupplierType(supplierType);
		dto.setVerifyId(verifyId);
		dto.setIds(ids);
		
		ResultSupport result = verifyFacade.saveVerifyDetail(dto);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
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
		Integer bizId = WebUtils.getCurBizId(request);
		
		UpdateVerifyDetailDTO dto = new UpdateVerifyDetailDTO();
		dto.setBizId(bizId);
		dto.setRecords(records);
		dto.setSupplierType(supplierType);
		dto.setVerifyId(verifyId);
		
		ResultSupport result = verifyFacade.updateVerifyDetail(dto);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
			return errorJson("操作失败");
		}
	}
}
