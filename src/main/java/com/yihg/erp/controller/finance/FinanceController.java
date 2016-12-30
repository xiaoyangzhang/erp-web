package com.yihg.erp.controller.finance;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yihg.erp.common.YihgTemplateFreemarkerService;
import com.yihg.erp.utils.ObjectUtils;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.InfoBean;
import com.yimayhd.erpcenter.facade.sales.service.TourGroupFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.yimayhd.erpcenter.facade.finance.query.*;
import org.yimayhd.erpcenter.facade.finance.result.*;
import org.yimayhd.erpcenter.facade.finance.service.FinanceFacade;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.util.NumberUtil;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinancePay;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingDelivery;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplierDetail;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrice;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpresource.dal.constants.SupplierConstant;

/**
 * 财务管理
 * 
 * @author Jing.Zhuo
 * @create 2015年7月28日 上午10:55:42
 */
@Controller
@RequestMapping(value = "/finance")
public class FinanceController extends BaseController {

	
	@Resource
	private BizSettingCommon bizSettingCommon;
	
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
	@Autowired
	private FinanceFacade financeFacade;
	@Autowired
	private TourGroupFacade tourGroupFacade;
	@Autowired
	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
	@Autowired
	private YihgTemplateFreemarkerService yihgTemplateFreemarkerService;

	
	DecimalFormat df = new DecimalFormat("0.##");
	
	/**
	 * 此方法用来维护团金额的一致性
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "calcTourGroupAmount.do")
	@ResponseBody
	public String calcTourGroupAmount(HttpServletRequest request,HttpServletResponse reponse, ModelMap model, Integer groupId){
		
		ResultSupport result = financeFacade.calcTourGroupAmount(groupId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", result.isSuccess());
		if(result.isSuccess()){
			map.put("msg", "calculate over!");
		}else{
			map.put("msg", "calculate failure!");
		}
		
		return JSON.toJSONString(map);
	}
	
	/**
	 * 此方法用来批量维护团金额的一致性
	 * @param request
	 * @param reponse
	 * @param model
	 * @param startTime 出团开始日期
	 * @param endTime	出团结束日期
	 * @param bizId
	 * @return
	 */
	@RequestMapping(value = "batchCalcTourGroupAmount.do")
	@ResponseBody
	public String batchCalcTourGroupAmount(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer bizId){
		
		Map paramters = WebUtils.getRequestParamters(request);
		ResultSupport result = financeFacade.batchCalcTourGroupAmount(bizId, paramters);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", result.isSuccess());
		if(result.isSuccess()){
			map.put("msg", result.getResultMsg());
		}else{
			map.put("msg", "calculate failure!");
		}
		
		return JSON.toJSONString(map);
	}
	
	/**
	 * 此方法用来批量维护 单条 booking_supplier total_cash的数据
	 * @param request
	 * @param reponse
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping(value = "calcBookingSupplierTotalCash.do")
	@ResponseBody
	public String calcBookingSupplierTotalCash(HttpServletRequest request, HttpServletResponse reponse, Integer bookingSupplierId) throws IOException{
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(bookingSupplierId == null){
			map.put("success", "false");
			map.put("msg", "请输入bookingSupplierId!");
			return JSON.toJSONString(map);
		}
		
		String startDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		ResultSupport result = financeFacade.calcBookingSupplierTotalCash(bookingSupplierId);
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		
		map.put("success", result.isSuccess());
		if(result.isSuccess()){
			map.put("startDate", startDate);
			map.put("endDate", endDate);
			map.put("msg", "calculate over!");
		}else{
			map.put("msg", "calculate failure!");
		}
		
		return JSON.toJSONString(map);
	}
	
	/**
	 * 此方法用来批量维护booking_supplier total_cash的数据
	 * @param request
	 * @param reponse
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping(value = "batchCalcBookingSupplierTotalCash.do")
	@ResponseBody
	public String batchCalcBookingSupplierTotalCash(HttpServletRequest request, HttpServletResponse reponse) throws IOException{
		
		reponse.setContentType("text/html;charset=utf-8");
		PrintWriter out = reponse.getWriter();
		out.write("正在计算");
		out.flush();
		
		String startDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		List<BookingSupplier> results = financeFacade.getBookingSupplierIdList();
		
		if(results != null && results.size() > 0){
			BookingSupplier bookingSupplier = null;
			for(int i = 0; i < results.size(); i++){
				bookingSupplier = results.get(i);
				financeFacade.calcBookingSupplierTotalCash(bookingSupplier.getId());
				
				if (i%100==0){
					out.write(".");
					out.flush();
				}
			}
		}
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		out.write("<br/>计算完成！共计算"+ results.size() +"条订单。开始时间："+ startDate +", 结束时间："+ endDate);
		out.flush();
		out.close();
		
		return null;
	}
	
	/**
	 * 此方法用来批量维护 单条 group_order total_cash的数据
	 * @param request
	 * @param reponse
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping(value = "calcGroupOrderTotalCash.do")
	@ResponseBody
	public String calcGroupOrderTotalCash(HttpServletRequest request, HttpServletResponse reponse, Integer groupOrderId) throws IOException{
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(groupOrderId == null){
			map.put("success", "false");
			map.put("msg", "请输入groupOrderId!");
			return JSON.toJSONString(map);
		}
		
		String startDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		ResultSupport result = financeFacade.calcGroupOrderTotalCash(groupOrderId);
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		
		map.put("success", result.isSuccess());
		if(result.isSuccess()){
			map.put("startDate", startDate);
			map.put("endDate", endDate);
			map.put("msg", "calculate over!");
		}else{
			map.put("msg", "calculate failure!");
		}
		
		return JSON.toJSONString(map);
	}
	
	/**
	 * 此方法用来批量维护group_order total_cash的数据
	 * @param request
	 * @param reponse
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping(value = "batchCalcGroupOrderTotalCash.do")
	@ResponseBody
	public String batchCalcGroupOrderTotalCash(HttpServletRequest request, HttpServletResponse reponse, Integer supplierId) throws IOException{
		
		reponse.setContentType("text/html;charset=utf-8");
		PrintWriter out = reponse.getWriter();
		out.write("正在计算");
		out.flush();
		
		String startDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		List<GroupOrder> results = financeFacade.getGroupOrderIdList(supplierId);
		
		if(results != null && results.size() > 0){
			GroupOrder order = null;
			for(int i = 0; i < results.size(); i++){
				order = results.get(i);
				financeFacade.calcGroupOrderTotalCash(order.getId());
				
				if (i%100==0){
					out.write(".");
					out.flush();
				}
			}
		}
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		out.write("<br/>计算完成！共计算"+ results.size() +"条订单。开始时间："+ startDate +", 结束时间："+ endDate);
		out.flush();
		out.close();
		
		return null;
	}
	
	@RequestMapping(value = "calcGroupTotalCash.do")
	@ResponseBody
	public String calcGroupTotalCash(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId){
		long time = System.currentTimeMillis();
		ResultSupport result = financeFacade.calcGroupTotalCash(groupId);
        time = System.currentTimeMillis() - time;
        
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", result.isSuccess());
		if(result.isSuccess()){
			map.put("msg", "completed!");
			map.put("result", "groupId="+groupId.toString()+", process times="+Long.toString(time)+" ms");
		}else{
			map.put("msg", "calculate failure!");
		}
		return JSON.toJSONString(map);
	}
	
	@RequestMapping(value = "calcGroupTotalCashBath.do")
	@ResponseBody
	public String calcGroupTotalCashBath(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String startTime, String endTime,
			Integer bizId) throws IOException{
		
		reponse.setContentType("text/html;charset=utf-8");
		PrintWriter out = reponse.getWriter();
		out.write("正在计算");
		out.flush();
		
		String startDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		List<TourGroup> results = financeFacade.selectGroupByDateZone(startTime, endTime, bizId);
		
		if(results != null && results.size() > 0){
			TourGroup tg = null;
			for(int i = 0; i < results.size(); i++){
				tg = results.get(i);
				financeFacade.calcGroupTotalCash(tg.getId());
				
				if (i%100==0){
					out.write(".");
					out.flush();
				}
			}
		}
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		out.write("<br/>计算完成！共计算"+ results.size() +"条订单。开始时间："+ startDate +", 结束时间："+ endDate);
		out.flush();
		out.close();
		
		return null;
	}
	
	/**
	 * 跳转到收款明细页面
	 */
	@RequestMapping(value = "inrecord.htm")
	public String inrecord(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("sup_type_map_in", SupplierConstant.supplierTypeMapIn);
		model.addAttribute("sup_type_map_pay", SupplierConstant.supplierTypeMapPay);
		return "finance/record/income-list";
	}

	/**
	 * 跳转到付款明细页面
	 */
	@RequestMapping(value = "payrecord.htm")
	public String payrecord(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("sup_type_map_pay", SupplierConstant.supplierTypeMapPay);
		return "finance/record/pay-list";
	}

	/**
	 * 跳转到结算单页面
	 */
	@RequestMapping(value = "settleList.htm")
	public String settleList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = financeFacade.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/settle-list";
	}
	
	/**
	 * 跳转到行程助手推送页面
	 */
	@RequestMapping(value = "pushWapList.htm")
	public String pushWapList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = financeFacade.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/pushWapList";
	}
	
	/**
	 * 行程助手推送
	 * 
	 * @author zhoumi
	 * @param sl
	 *            sqlId
	 * @param rp
	 *            返回页面
	 * @param svc
	 *            在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "pushWapList_table.htm")
	public String pushWapList_table(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {

		
		PushWapListTableDTO queryDTO = new PushWapListTableDTO();
		if(page != null){
			queryDTO.setPage(page);
		}
		if(pageSize != null){
			queryDTO.setPageSize(pageSize);
		}
		queryDTO.setOrgIds(group.getOrgIds());
		queryDTO.setSaleOperatorIds(group.getSaleOperatorIds());
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setParameters(WebUtils.getQueryParamters(request));
		queryDTO.setRp(rp);
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setSl(sl);
		queryDTO.setSsl(ssl);
		queryDTO.setSvc(svc);
		QueryPushWapListTableResult result = financeFacade.pushWapListTable(queryDTO);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("guideMap", result.getGuideMap());
		model.addAttribute("sum", result.getSum());
		
		return "finance/pushWapList_table";
	}
	
	
	/**
	 * 结算单审核预览
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @return
	 */
	@RequestMapping("statementCheckPreview.htm")
	public String statementCheckPreview(HttpServletRequest request, HttpServletResponse response,
			ModelMap model, TourGroupVO group, String sl, String svc){
		
		StatementCheckPreviewDTO queryDTO = new StatementCheckPreviewDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setOrgIds(group.getOrgIds());
		queryDTO.setParamters(WebUtils.getQueryParamters(request));
		queryDTO.setSaleOperatorIds(group.getSaleOperatorIds());
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setSl(sl);
		queryDTO.setSvc(svc);
		
		StatementCheckPreviewResult result = financeFacade.statementCheckPreview(queryDTO);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("guideMap", result.getGuideMap());
		return "finance/statementCheckPreview";
		
	}
	@RequestMapping("statementCheckExportExcel.htm")
	public void statementCheckExportExcel(HttpServletRequest request,HttpServletResponse response,TourGroupVO group,String sl,String svc){
		
		StatementCheckPreviewDTO queryDTO = new StatementCheckPreviewDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setOrgIds(group.getOrgIds());
		queryDTO.setParamters(WebUtils.getQueryParamters(request));
		queryDTO.setSaleOperatorIds(group.getSaleOperatorIds());
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setSl(sl);
		queryDTO.setSvc(svc);
		StatementCheckPreviewResult result = financeFacade.statementCheckPreview(queryDTO);

		PageBean pb = result.getPageBean();
		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		if(result.getGuideMap() != null){
			guideMap = result.getGuideMap();
		}
		
		Map item = null;
		String path = "";
		Integer guideCount = 0;
		Integer adultCount = 0;
		Integer childCount = 0;
		BigDecimal incomeTotal=new BigDecimal(0);
		BigDecimal outcomeTotal=new BigDecimal(0);
		BigDecimal profitTotal=new BigDecimal(0);
		try {

			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/tourGroupProfit.xlsx");

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			int index = 0;
			for (int i=0;i<pb.getResult().size();i++) {
				 item =(Map) pb.getResult().get(i);
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue(item.get("group_code") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue("【"+item.get("product_brand_name") + "】"+item.get("product_name"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue((item.get("total_adult") == null?"0":item.get("total_adult")) + "大" + (item.get("total_child")
						== null?"0":item.get("total_child"))+ "小" + (item.get("total_guide") == null?"0":item.get("total_guide")) + "陪");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue(item.get("operator_name") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				for (Map.Entry<Integer, String> entry : guideMap.entrySet()) {
					if (TypeUtils.castToInt(item.get("id")) .equals( entry.getKey())) {
						
						cc.setCellValue(entry.getValue());
					}
				}
				cc.setCellStyle(styleLeft);
				cc = row.createCell(6);
				
				cc.setCellValue( item.get("date_start") == null?"":new SimpleDateFormat("MM-dd").format(TypeUtils.castToDate(item.get("date_start"))) 
						+ "/"+(item.get("date_end") == null?"":new SimpleDateFormat("MM-dd").format(TypeUtils.castToDate(item.get("date_end")))));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(7);
				
				if (TypeUtils.castToInt(item.get("group_state")) == 0) {
					
					cc.setCellValue("未确认");
				}
				else if (TypeUtils.castToInt(item.get("group_state")) == 1 && item.get("date_start") != null && (System.currentTimeMillis()-TypeUtils.castToDate(item.get("date_start")).getTime()<0)) {
					
					cc.setCellValue("已确认（待出团）");
				}
				else if (TypeUtils.castToInt(item.get("group_state")) == 1 && item.get("date_end") != null
						&& (System.currentTimeMillis()-TypeUtils.castToDate(item.get("date_end")).getTime()>0)) {
					
					cc.setCellValue("已确认（已离开）");
				}
				else if (TypeUtils.castToInt(item.get("group_state")) == 1 && item.get("date_end") != null && item.get("date_start") != null
						&& (System.currentTimeMillis()-TypeUtils.castToDate(item.get("date_end")).getTime()>0) && (System.currentTimeMillis()-TypeUtils.castToDate(item.get("date_end")).getTime()<0)) {
					
					cc.setCellValue("已确认（行程中）");
				}
				else if (TypeUtils.castToInt(item.get("group_state")) == 2) {
					
					cc.setCellValue("废弃");
				}
				else if (TypeUtils.castToInt(item.get("group_state")) == 3) {
					
					cc.setCellValue("已审核");
				}
				else if (TypeUtils.castToInt(item.get("group_state")) == 4) {
					
					cc.setCellValue("封存");
				}
				cc.setCellStyle(styleLeft);
				cc = row.createCell(8);
				cc.setCellValue(item.get("audit_user") == null?"":item.get("audit_user")+"");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(9);
				cc.setCellValue(TypeUtils.castToBigDecimal(item.get("total_income") == null?0:item.get("total_income")).doubleValue());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(10);
				cc.setCellValue(TypeUtils.castToBigDecimal(item.get("total_cost") == null?0:item.get("total_cost")).doubleValue());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(11);
				cc.setCellValue(TypeUtils.castToBigDecimal(item.get("total_profit") == null?0:item.get("total_profit")).doubleValue());
				cc.setCellStyle(styleLeft);
				index++;
				guideCount += TypeUtils.castToInt(item.get("total_guide") == null?0:item.get("total_guide"));
				adultCount += TypeUtils.castToInt(item.get("total_adult") == null?0:item.get("total_adult"));
				childCount += TypeUtils.castToInt(item.get("total_child") == null?0:item.get("total_child"));
				 incomeTotal =incomeTotal.add(NumberUtil.parseObj2Num(item.get("total_income") == null?0:item.get("total_income")));
				 outcomeTotal = outcomeTotal.add(NumberUtil.parseObj2Num(item.get("total_cost") == null?0:item.get("total_cost")));
				 profitTotal = profitTotal.add(NumberUtil.parseObj2Num(item.get("total_profit") == null?0:item.get("total_profit")));

			}
			
			row = sheet.createRow(pb.getResult().size() + 1); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellValue(adultCount+ "大"
					+ childCount + "小" + guideCount
					+ "陪");
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellStyle(styleRight);
			cc = row.createCell(9);
			cc.setCellValue(incomeTotal.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(outcomeTotal.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellValue(profitTotal.doubleValue());
			cc.setCellStyle(styleRight);

			CellRangeAddress region = new CellRangeAddress(
					pb.getResult().size() + 2,
					pb.getResult().size() + 2, 0, 11);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 2);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download(path, request, response);
	}
	private void download(String path, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			// path是指欲下载的文件的路径。
			File file = new File(path);
			// 取得文件名。
			String fileName = "";
			try {
				fileName = new String("结算单审核.xlsx".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

			/*
			 * //解决IE浏览器下下载文件名乱码问题 if
			 * (request.getHeader("USER-AGENT").indexOf("msie") > -1){ fileName
			 * = new URLEncoder().encode(fileName) ; }
			 */
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename="
					+ fileName);
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(
					response.getOutputStream());
			response.setContentType("application/vnd.ms-excel;charset=gb2312");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
			file.delete();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}
	/**
	 * 跳转到结算单封存页面
	 */
	@RequestMapping(value = "settleSealList.htm")
	public String settleSealList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = financeFacade.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("bizId", bizId); // 过滤B商家
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/seal/settle-list";
	}
	
	@RequestMapping(value = "settleSealList.do")
	public String settleSealList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {
		
		SettleSealListDTO queryDTO = new SettleSealListDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setOrgIds(group.getOrgIds());
		if(page != null){
			queryDTO.setPage(page);
		}
		if(pageSize != null){
			queryDTO.setPageSize(pageSize);
		}
		queryDTO.setParamters(WebUtils.getQueryParamters(request));
		queryDTO.setRp(rp);
		queryDTO.setSaleOperatorIds(group.getSaleOperatorIds());
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		queryDTO.setSl(sl);
		queryDTO.setSsl(ssl);
		queryDTO.setSvc(svc);
		SettleSealListResult result = financeFacade.settleSealList(queryDTO);
		model.addAttribute("guideMap", result.getGuideMap());
		model.addAttribute("pageBean", result.getPageBean());
		return rp;
	}


	/**
	 * 跳转到收款记录详情页面
	 */
	@RequestMapping(value = "incomeView.htm")
	public String incomeView(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		
		IncomeOrPayDTO dto = new IncomeOrPayDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setPayId(payId);
		IncomeOrPaytResult result = financeFacade.incomeView(dto);
		model.addAttribute("pay", result.getPay());
		model.addAttribute("bizAccountList", result.getBizAccountList());
		model.addAttribute("payTypeList", result.getPayTypeList());
		model.addAttribute("supplierTypeMapIn", SupplierConstant.supplierTypeMapIn);
		model.addAttribute("supplierTypeMapPay", SupplierConstant.supplierTypeMapPay);
		
		PlatformEmployeePo employee = WebUtils.getCurUser(request);
		if (employee != null) {
			model.addAttribute("operatePerson", employee.getName());
		}
		
		return "finance/cash/income-view";
	}

	/**
	 * 跳转到付款记录详情页面
	 */
	@RequestMapping(value = "payView.htm")
	public String payView(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		
		IncomeOrPayDTO dto = new IncomeOrPayDTO();
		dto.setPayId(payId);
		IncomeOrPaytResult result = financeFacade.payView(dto);
		model.addAttribute("pay", result.getPay());
		return "finance/cash/pay-view";
	}

	/**
	 * 跳转到收款订单关联页面
	 */
	@RequestMapping(value = "incomeJoinList.htm")
	public String incomeJoinList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/cash/income-join-list";
	}
	
	/**
	 * 跳转到收款订单关联页面列表
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/incomeJoinTableList.do")
	public String incomeJoinTableList(HttpServletRequest request, ModelMap model, 
			Integer pageSize, Integer page, TourGroupVO group) {
		
		IncomeJoinTableListDTO queryDTO = new IncomeJoinTableListDTO();
		queryDTO.setBizId(WebUtils.getCurBizId(request));
		queryDTO.setOrgIds(group.getOrgIds());
		if(page != null){
			queryDTO.setPage(page);
		}
		if(pageSize != null){
			queryDTO.setPageSize(pageSize);
		}
		queryDTO.setParamters(WebUtils.getQueryParamters(request));
		queryDTO.setSaleOperatorIds(group.getSaleOperatorIds());
		queryDTO.setSet(WebUtils.getDataUserIdSet(request));
		
		PageBean pageBean = financeFacade.incomeJoinTableList(queryDTO);
		model.addAttribute("pageBean", pageBean);
		
		return "finance/cash/income-join-list-table";
	}

	/**
	 * 跳转到付款订单关联页面
	 */
	@RequestMapping(value = "payJoinList.htm")
	public String payJoinList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("start_min", DateUtils.getMonthFirstDay());
		model.addAttribute("start_max", DateUtils.getMonthLastDay());
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/cash/pay-join-list";
	}

	/**
	 * 跳转到收款新增页面
	 */
	@RequestMapping(value = "incomeAdd.htm")
	public String incomeAdd(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		
		IncomeOrPayDTO dto = new IncomeOrPayDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setPayId(payId);
		
		IncomeOrPaytResult result = financeFacade.incomeAdd(dto);
		this.handResponse(request, model, result);
		
		if (payId != null) {
			model.addAttribute("pay", result.getPay());
		}else{
			model.addAttribute("currDate", new Date());
		}
		return "finance/cash/income-add";
	}

	/**
	 * 跳转到付款新增页面
	 */
	@RequestMapping(value = "payAdd.htm")
	public String payAdd(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer payId) {
		IncomeOrPayDTO dto = new IncomeOrPayDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setPayId(payId);
		
		IncomeOrPaytResult result = financeFacade.incomeAdd(dto);
		this.handResponse(request, model, result);
		if (payId != null) {
			model.addAttribute("pay", result.getPay());
		}else{
			model.addAttribute("currDate", new Date());
		}
		return "finance/cash/pay-add";
	}

	/**
	 * 跳转收款记录页面
	 */
	@RequestMapping(value = "incomeRecordList.htm")
	public String incomeRecordList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		
		IncomeOrPayDTO dto = new IncomeOrPayDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		
		IncomeOrPaytResult result = financeFacade.incomeRecordList(dto);
		this.handResponse(request, model, result);
		
		return "finance/cash/income-list";
	}

	/**
	 * 跳转付款记录页面
	 */
	@RequestMapping(value = "payRecordList.htm")
	public String cashRecordList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		IncomeOrPayDTO dto = new IncomeOrPayDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		
		IncomeOrPaytResult result = financeFacade.payRecordList(dto);
		this.handResponse(request, model, result);
		return "finance/cash/pay-list";
	}

	/**
	 * 跳转到收款审核
	 */
	@RequestMapping(value = "auditList.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String auditList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId) {
		model.addAttribute("group", financeFacade.auditList(groupId));
		return "finance/audit-list";
	}

	/**
	 * 跳转到审核汇总页面
	 */
	@RequestMapping(value = "auditGroup.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String auditGroup(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAllAttributes(financeFacade.queryAuditViewInfo(groupId, bizId));
		return "finance/audit-group";
	}
	
	/**
	 * 跳转到审核汇总页面
	 */
	@RequestMapping(value = "auditGroupList.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String auditGroupList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAllAttributes(financeFacade.queryAuditViewInfo(groupId, bizId));
		return "finance/audit-group-list";
	}
	
	/**
	 * 跳转到审核汇总打印页面
	 */
	@RequestMapping(value = "auditGroupListPrint.htm")
	public String auditGroupListPrint(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAllAttributes(financeFacade.queryAuditViewInfo(groupId, bizId));
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/audit-group-list-print";
	}

	/**
	 * 跳转到审核查询页面
	 */
	@RequestMapping(value = "aduditStatisticsList.htm")
	public String aduditStatisticsList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = financeFacade.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/aduditStatisticsList-list";
	}
	
	@RequestMapping(value = "aduditStatisticsList.do")
	public String aduditStatisticsList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {
		
		AduditStatisticsListDTO dto = new AduditStatisticsListDTO();
		
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
		dto.setSl(sl);
		dto.setSsl(ssl);
		dto.setSvc(svc);
		PageBean pb = financeFacade.aduditStatisticsList(dto);
		model.addAttribute("pageBean", pb);
		
		return rp;
	}

	/**
	 * 获取审核人列表
	 * 
	 * @param request
	 * @param reponse
	 * @param name
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "getAuditUserList.do", method = RequestMethod.GET)
	@ResponseBody
	public String getAuditUserList(HttpServletRequest request, HttpServletResponse reponse, String name)
			throws UnsupportedEncodingException {
		
		List<Map<String, String>> list = financeFacade.getAuditUserList(java.net.URLDecoder.decode(name, "UTF-8"), 
				WebUtils.getCurBizId(request));
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}

	/**
	 * 跳转到操作记录页面
	 */
	@RequestMapping(value = "operateLog.htm")
	public String operateLog(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		List<TourGroup> operateLogs = financeFacade.operateLog(groupId);
		model.addAttribute("operateLogs", operateLogs);
		return "finance/operate-log";
	}

	/**
	 * 批量审核
	 */
	@RequestMapping(value = "audit.do")
	@ResponseBody
	@PostHandler
	public String audit(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId,
			String feeType, String checkedIds, String unCheckedIds,
			String comCheckedIds, String comUnCheckedIds, String financeGuides,
			String priceCheckedIds, String priceUnCheckedIds) {
		
		
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		AuditDTO dto = new AuditDTO();
		dto.setGroupId(groupId);
		dto.setFeeType(feeType);
		dto.setCheckedIds(checkedIds);
		dto.setUnCheckedIds(unCheckedIds);
		dto.setComCheckedIds(comCheckedIds);
		dto.setComUnCheckedIds(comUnCheckedIds);
		dto.setFinanceGuides(financeGuides);
		dto.setPriceCheckedIds(priceCheckedIds);
		dto.setPriceUnCheckedIds(priceUnCheckedIds);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		
		financeFacade.audit(dto);
		return null;
	}
	
	/**
	 * 批量审核
	 */
	@RequestMapping(value = "auditList.do")
	@ResponseBody
	@PostHandler
	public String auditList(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, String data, String financeGuides) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		
		AuditListDTO dto = new AuditListDTO();
		dto.setData(data);
		dto.setFinanceGuides(financeGuides);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		
		financeFacade.auditList(dto);
		return null;
	}

	/**
	 * 结算单审核
	 */
	@RequestMapping(value = "finAudit.do")
	@ResponseBody
	@PostHandler
	public String finAudit(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer groupId) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		
		FinAuditDTO dto = new FinAuditDTO();
		dto.setGroupId(groupId);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		financeFacade.finAudit(dto);
		return null;
	}

	/**
	 * 结算单取消审核
	 */
	@RequestMapping(value = "finUnAudit.do")
	@ResponseBody
	@PostHandler
	public String finUnAudit(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		
		FinAuditDTO dto = new FinAuditDTO();
		dto.setGroupId(groupId);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		financeFacade.finUnAudit(dto);
		return null;
	}

	/**
	 * 批量封存
	 */
	@RequestMapping(value = "batchSeal.do")
	@ResponseBody
	@PostHandler
	public String batchSeal(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String groupIds) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		UnsealDTO dto = new UnsealDTO();
		dto.setGroupIds(groupIds);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		financeFacade.batchSeal(dto);
		return null;
	}

	/**
	 * 解封
	 */
	@RequestMapping(value = "unseal.do")
	@ResponseBody
	@PostHandler
	public String unseal(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, String groupId) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		
		UnsealDTO dto = new UnsealDTO();
		dto.setGroupIds(groupId);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		financeFacade.unseal(dto);
		return null;
	}

	/**
	 * 付款/收款
	 */
	/**
	 * @param request
	 * @param reponse
	 * @param model
	 * @param pay
	 * @return
	 */
	@RequestMapping(value = "pay.do")
	@ResponseBody
	@PostHandler
	public String pay(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, FinancePay pay) {
		
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		PayDTO dto = new PayDTO();
		dto.setFinancePay(pay);
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		return financeFacade.pay(dto);
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
		map.put("accountList", financeFacade.querySupplierBankAccountList(sid));
		return JSON.toJSONString(map);
	}

	private void handResponse(HttpServletRequest request, ModelMap model, IncomeOrPaytResult result) {
		
		model.addAttribute("payTypeList", result.getPayTypeList());
		model.addAttribute("bizAccountList", result.getBizAccountList());
		model.addAttribute("supplierTypeMapIn", SupplierConstant.supplierTypeMapIn);
		model.addAttribute("supplierTypeMapPay", SupplierConstant.supplierTypeMapPay);
		PlatformEmployeePo employee = WebUtils.getCurUser(request);
		if (employee != null) {
			model.addAttribute("operatePerson", employee.getName());
		}
	}

	/**
	 * 导出财务核算单
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param bookingId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "financeChargeDownload.htm")
	public String financeChargeExport(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, Integer groupId)
			throws Exception {
		WordReporter exporter = new WordReporter(request.getSession()
				.getServletContext()
				.getRealPath("/template/finance_charge.docx"));
		exporter.init();

		String blankStr = "";
		String doubleBlankStr = "  ";
		String multiStr = "*";
		String minusStr = "-";
		String equalStr = "=";
		String leftBracket = "(";
		String rigthBracket = ")";

		String group_code = "group_code";
		String person_num = "person_num";
		String type = "type";
		String supplier_name = "supplier_name";
		String desc = "desc";
		String total = "tot";
		String receive = "re";
		String unreceive = "un";
		String cash_type = "cash_type";
		
		TourGroupDetiailsResult result = financeFacade.getTourGroupDetails(groupId);
		
		// 旅行团信息
		TourGroup tourGroup = result.getTourGroup();

		Integer totalAdult = tourGroup.getTotalAdult(), totalChild = tourGroup
				.getTotalChild(), totalGuide = tourGroup.getTotalGuide();
		int total_person_num = (totalAdult == null ? 0 : totalAdult.intValue())
				+ (totalChild == null ? 0 : totalChild.intValue());
		int groupState = tourGroup.getGroupState();
		Map<String, Object> groupMap = new HashMap<String, Object>();
		groupMap.put(group_code, tourGroup.getGroupCode());
		groupMap.put("operator_name", tourGroup.getOperatorName());

		StringBuilder personStr = new StringBuilder();
		if (totalAdult != null) {
			personStr.append(totalAdult + "大");
		}
		if (totalChild != null) {
			personStr.append(totalChild + "小");
		}
		if (totalGuide != null) {
			personStr.append(totalGuide + "陪");
		}
		groupMap.put(person_num, personStr.toString());
		groupMap.put("date_start", DateUtils.format(tourGroup.getDateStart()));
		groupMap.put("product_brand_name", tourGroup.getProductBrandName());
		groupMap.put("product_name", tourGroup.getProductName());
		groupMap.put("group_state", groupState == 0 ? "未确认"
				: (groupState == 1 ? "已确认" : (groupState == 2 ? "作废" : "封存")));
		// 团类型
		groupMap.put("group_mode", tourGroup.getGroupMode() == 0 ? "散客" : "团队");
		// 除表格外替换信息
		Map<String, Object> commonMap = new HashMap<String, Object>();
		commonMap.put(group_code, tourGroup.getGroupCode());
		String print_time = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		commonMap.put("print_time", print_time);
		// 销售订单
		List<GroupOrder> orderList = result.getOrderList();
		// 购物店收入
		List<BookingShop> shoppingList = result.getShoppingList();
		// 其他收入
		List<BookingSupplier> otherList = result.getOtherList();
		// 地接社支出
		List<BookingDelivery> deliveryList = result.getDeliveryList();
		// 供应商支出
		List<BookingSupplier> paymentList = result.getPaymentList();

		// 总计
		Map<String, Object> totalMap = new HashMap<String, Object>();
		totalMap.put("total_income", tourGroup.getTotalIncome() == null ? "0"
				: String.valueOf(tourGroup.getTotalIncome().intValue()));
		totalMap.put("total_cost", tourGroup.getTotalCost() == null ? "0"
				: String.valueOf(tourGroup.getTotalCost().intValue()));
		totalMap.put(person_num, total_person_num + blankStr);
		BigDecimal total_profit = tourGroup.getTotalIncome().subtract(
				tourGroup.getTotalCost());
		totalMap.put("total_profit", String.valueOf(total_profit.intValue()));
		totalMap.put("ave_profit", String.valueOf(total_person_num == 0 ? "0"
				: total_profit.divide(new BigDecimal(total_person_num), 2,
						RoundingMode.HALF_UP)));

		// group_code及print_time
		exporter.export(commonMap);

		// 销售-旅行团
		exporter.export(groupMap, 0);

		// 团款收入
		List<Map<String, String>> orderSwitcherList = new ArrayList<Map<String, String>>();
		for (GroupOrder order : orderList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "团款");
			map.put(supplier_name, order.getSupplierName());
			int numAdult = order.getNumAdult() == null ? 0 : order
					.getNumAdult();
			int numChild = order.getNumChild() == null ? 0 : order
					.getNumChild();
			map.put(person_num, (numAdult + numChild) + blankStr);
			List<GroupOrderPrice> priceList = financeFacade.getOrderPriceByOrder(order.getId());
			int i = 1;
			StringBuilder descStr = new StringBuilder();
			for (GroupOrderPrice orderPrice : priceList) {
				int uniPrice = orderPrice.getUnitPrice() == null ? 0
						: orderPrice.getUnitPrice().intValue();
				int numPerson = orderPrice.getNumPerson() == null ? 0
						: orderPrice.getNumPerson().intValue();
				int numTimes = orderPrice.getNumTimes() == null ? 0
						: orderPrice.getNumTimes().intValue();
				int totalFee = uniPrice * numPerson * numTimes;
				String itemName = orderPrice.getItemName();
				String remark = orderPrice.getRemark();
				if (i > 1) {
					descStr.append("，\n");
				}
				descStr.append(doubleBlankStr
						+ (StringUtils.isBlank(itemName) ? blankStr : itemName)
						+ doubleBlankStr
						+ (StringUtils.isBlank(remark) ? blankStr : remark)
						+ doubleBlankStr + uniPrice + multiStr + numPerson
						+ multiStr + numTimes + equalStr + totalFee);
				i++;
			}
			map.put(desc, descStr.toString());
			BigDecimal t1 = order.getTotal();
			BigDecimal t2 = order.getTotalCash();
			map.put(total,
					t1 == null ? blankStr : WordReporter.getPoint2(t1
							.doubleValue()));
			map.put(receive,
					t2 == null ? blankStr : WordReporter.getPoint2(t2
							.doubleValue()));
			map.put(unreceive, t1 == null || t2 == null ? blankStr
					: WordReporter.getPoint2(t1.subtract(t2).doubleValue()));
			orderSwitcherList.add(map);
		}
		if (orderSwitcherList.size() == 0) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "无");
			map.put(supplier_name, "无");
			map.put(person_num, "无");
			map.put(desc, "无");
			map.put(total, "无");
			map.put(receive, "无");
			map.put(unreceive, "无");
			orderSwitcherList.add(map);
		}
		exporter.export(orderSwitcherList, 1);

		// 购物店收入
		List<Map<String, String>> shoppingSwitcherList = new ArrayList<Map<String, String>>();
		for (BookingShop shop : shoppingList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "购物");
			map.put(supplier_name, shop.getSupplierName());
			map.put("shop_date", shop.getShopDate());
			BigDecimal totalFace = shop.getTotalFace();
			BigDecimal totalRepay = shop.getTotalRepay();
			BigDecimal personRepayTotal = shop.getPersonRepayTotal();

			String totalFaceStr = "";
			if (totalFace != null) {
				totalFaceStr = WordReporter.getPoint2(totalFace.doubleValue());
			}
			map.put("total_face", totalFaceStr);

			String totalRepayStr = "";
			if (totalRepay != null) {
				totalRepayStr = WordReporter
						.getPoint2(totalRepay.doubleValue());
			}
			map.put("total_repay", totalRepayStr);

			String personRepayTotalStr = "";
			if (personRepayTotal != null) {
				personRepayTotalStr = WordReporter.getPoint2(personRepayTotal
						.doubleValue());
			}
			map.put("p_repay", personRepayTotalStr);
			BigDecimal total_fee = totalRepay == null
					|| personRepayTotal == null ? BigDecimal.ZERO : totalRepay
					.add(personRepayTotal);
			map.put(total, WordReporter.getPoint2(total_fee.doubleValue()));
			BigDecimal totalCash = shop.getTotalCash() == null ? BigDecimal.ZERO
					: shop.getTotalCash();
			map.put(receive, WordReporter.getPoint2(totalCash.doubleValue()));
			map.put(unreceive, WordReporter.getPoint2(total_fee.subtract(
					totalCash).doubleValue()));
			shoppingSwitcherList.add(map);
		}
		if (shoppingSwitcherList.size() == 0) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "无");
			map.put(supplier_name, "无");
			map.put("shop_date", "无");
			map.put("total_face", "无");
			map.put("total_repay", "无");
			map.put("p_repay", "无");
			map.put(total, "无");
			map.put(receive, "无");
			map.put(unreceive, "无");
			shoppingSwitcherList.add(map);
		}
		exporter.export(shoppingSwitcherList, 2);

		// 其他收入
		List<Map<String, String>> otherSwitcherList = new ArrayList<Map<String, String>>();
		for (BookingSupplier bookingSupplier : otherList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "其他收入");
			map.put(supplier_name, bookingSupplier.getSupplierName());
			map.put(cash_type, bookingSupplier.getCashType() == null ? ""
					: bookingSupplier.getCashType());

			List<BookingSupplierDetail> detailList = financeFacade.getBookingSupplierDetailById(bookingSupplier.getId());
			int i = 1;
			StringBuilder descStr = new StringBuilder();
			for (BookingSupplierDetail detail : detailList) {
				int item_num = detail.getItemNum() == null ? 0 : detail
						.getItemNum().intValue();
				int item_num_minus = detail.getItemNumMinus() == null ? 0
						: detail.getItemNumMinus().intValue();
				int item_price = detail.getItemPrice() == null ? 0 : detail
						.getItemPrice().intValue();
				int totalFee = (item_num - item_num_minus) * item_price;
				if (i > 1) {
					descStr.append("，\n");
				}

				descStr.append(DateUtils.format(detail.getItemDate())
						+ doubleBlankStr);
				descStr.append("【");
				descStr.append(detail.getType1Name());
				if (detail.getType2Name() != null
						&& !"".equals(detail.getType2Name())
						&& detail.getCarLisence() == null) {
					descStr.append("." + detail.getType2Name());
				}
				if (detail.getCarLisence() != null
						&& !"".equals(detail.getCarLisence())) {
					descStr.append("." + detail.getType2Name() + "座");
					descStr.append("." + detail.getCarLisence());
				}
				descStr.append("】" + doubleBlankStr);
				if (detail.getItemBrief() != null
						&& !"".equals(detail.getItemBrief())) {
					descStr.append(detail.getItemBrief() + doubleBlankStr);
				}
				descStr.append(leftBracket + item_num + minusStr
						+ item_num_minus + rigthBracket + multiStr + item_price
						+ equalStr + totalFee);
				if (detail.getDriverName() != null
						&& detail.getDriverTel() != null) {
					descStr.append("\n司机： " + detail.getDriverName() + " "
							+ detail.getDriverTel() + "\n");
				}

				i++;
			}
			map.put(desc, descStr.toString());
			BigDecimal t1 = bookingSupplier.getTotal() == null ? BigDecimal.ZERO
					: bookingSupplier.getTotal();
			BigDecimal t2 = bookingSupplier.getTotalCash() == null ? BigDecimal.ZERO
					: bookingSupplier.getTotalCash();
			map.put(total, WordReporter.getPoint2(t1.doubleValue()));
			map.put(receive, WordReporter.getPoint2(t2.doubleValue()));
			map.put(unreceive, t1 == null || t2 == null ? blankStr
					: WordReporter.getPoint2(t1.subtract(t2).doubleValue()));
			otherSwitcherList.add(map);
		}
		if (otherSwitcherList.size() == 0) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "无");
			map.put(supplier_name, "无");
			map.put(cash_type, "无");
			map.put(desc, "无");
			map.put(total, "无");
			map.put(receive, "无");
			map.put(unreceive, "无");
			otherSwitcherList.add(map);
		}
		exporter.export(otherSwitcherList, 3);

		// 地接社支出
		List<Map<String, String>> paymentSwitcherList = new ArrayList<Map<String, String>>();
		for (BookingDelivery delivery : deliveryList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, SupplierConstant.supplierTypeMap.get(financeFacade.getSupplierById(delivery.getSupplierId()).getSupplierType()));
			map.put(supplier_name, delivery.getSupplierName());
			map.put(cash_type, "");
			BigDecimal t1 = delivery.getTotal();
			BigDecimal t2 = delivery.getTotalCash();
			map.put(total,
					t1 == null ? blankStr : WordReporter.getPoint2(t1
							.doubleValue()));
			map.put(receive,
					t2 == null ? blankStr : WordReporter.getPoint2(t2
							.doubleValue()));
			map.put(unreceive, t1 == null || t2 == null ? blankStr
					: WordReporter.getPoint2(t1.subtract(t2).doubleValue()));
			StringBuilder descStr = new StringBuilder();
			descStr.append(DateUtils.format(delivery.getDateArrival())
					+ doubleBlankStr);
			if (delivery.getPersonAdult() != null) {
				descStr.append(delivery.getPersonAdult() + "大");
			}
			if (delivery.getPersonChild() != null) {
				descStr.append(delivery.getPersonChild() + "小");
			}
			if (delivery.getPersonGuide() != null) {
				descStr.append(delivery.getPersonGuide() + "陪");
			}
			map.put(desc, descStr.toString());
			paymentSwitcherList.add(map);
		}
		// 商家支出
		for (BookingSupplier bookingSupplier : paymentList) {
			if (bookingSupplier.getSupplierType().equals(
					com.yimayhd.erpcenter.dal.sales.client.constants.Constants.OTHER)) {
				continue;
			}
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, SupplierConstant.supplierTypeMap.get(financeFacade.getSupplierById(bookingSupplier.getSupplierId()).getSupplierType()));
			map.put(supplier_name, bookingSupplier.getSupplierName());
			map.put(cash_type, bookingSupplier.getCashType() == null ? blankStr
					: bookingSupplier.getCashType());
			BigDecimal t1 = bookingSupplier.getTotal();
			BigDecimal t2 = bookingSupplier.getTotalCash();
			map.put(total,
					t1 == null ? blankStr : WordReporter.getPoint2(t1
							.doubleValue()));
			map.put(receive,
					t2 == null ? blankStr : WordReporter.getPoint2(t2
							.doubleValue()));
			map.put(unreceive, t1 == null || t2 == null ? blankStr
					: WordReporter.getPoint2(t1.subtract(t2).doubleValue()));
			List<BookingSupplierDetail> detailList = financeFacade.getBookingSupplierDetailById(bookingSupplier.getId());
			int i = 1;
			StringBuilder descStr = new StringBuilder();
			for (BookingSupplierDetail detail : detailList) {
				int item_num = detail.getItemNum() == null ? 0 : detail
						.getItemNum().intValue();
				int item_num_minus = detail.getItemNumMinus() == null ? 0
						: detail.getItemNumMinus().intValue();
				int item_price = detail.getItemPrice() == null ? 0 : detail
						.getItemPrice().intValue();
				int totalFee = (item_num - item_num_minus) * item_price;
				if (i > 1) {
					descStr.append("，\n");
				}
				descStr.append(DateUtils.format(detail.getItemDate())
						+ doubleBlankStr);
				descStr.append("【");
				descStr.append(detail.getType1Name());
				if (detail.getCarLisence() != null
						&& !"".equals(detail.getCarLisence())) {
					descStr.append("." + detail.getType2Name() + "座");
					descStr.append("." + detail.getCarLisence());
				}
				descStr.append("】" + doubleBlankStr);
				if (detail.getItemBrief() != null
						&& !"".equals(detail.getItemBrief())) {
					descStr.append(detail.getItemBrief() + doubleBlankStr);
				}
				descStr.append(leftBracket + item_num + minusStr
						+ item_num_minus + rigthBracket + multiStr + item_price
						+ equalStr + totalFee);
				if (detail.getDriverName() != null
						&& detail.getDriverTel() != null) {
					descStr.append("\n司机： " + detail.getDriverName() + " "
							+ detail.getDriverTel() + "\n");
				}

				i++;
			}
			map.put(desc, descStr.toString());
			paymentSwitcherList.add(map);
		}
		if (paymentSwitcherList.size() == 0) {
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, "无");
			map.put(supplier_name, "无");
			map.put(cash_type, "无");
			map.put(total, "无");
			map.put(receive, "无");
			map.put(unreceive, "无");
			map.put(desc, "无");
			paymentSwitcherList.add(map);
		}
		exporter.export(paymentSwitcherList, 4);
		// 利润（总计）
		exporter.export(totalMap, 5);

		String url = request.getSession().getServletContext().getRealPath("/")
				+ "download/" + tourGroup.getGroupCode() + "_checking_"
				+ System.currentTimeMillis() + ".doc";
		exporter.generate(url);

		// 下载
		String fileName = new String(
				(tourGroup.getGroupCode() + "_checking.doc").getBytes("UTF-8"),
				"iso-8859-1");
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/msword"); // word格式
		response.setHeader("Content-Disposition", "attachment; filename="
				+ fileName);
		File file = new File(url);
		InputStream inputStream = new FileInputStream(file);
		OutputStream os = response.getOutputStream();
		byte[] b = new byte[10240];
		int length;
		while ((length = inputStream.read(b)) > 0) {
			os.write(b, 0, length);
		}
		inputStream.close();
		os.close();
		new File(url).delete();

		return null;
	}

	/**
	 * 领单列表
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @param page
	 * @return
	 */
	@RequestMapping("/billList.htm")
	public String receiveOrderList(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroup group, Integer page) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", bizId); // 过滤B商家
		
		return "finance/bill/receiveBillList";
	}

	/**
	 * 领单-查询
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/billList.do")
	public String receiveOrderListSelect(HttpServletRequest request, ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		ReceiveOrderListSelectDTO dto = new ReceiveOrderListSelectDTO();
		dto.setBizId(bizId);
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
		
		ReceiveOrderListSelectResult result = financeFacade.receiveOrderListSelect(dto);
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("billTypeList", result.getBillTypeList());
		return "finance/bill/receiveBillList-table";
	}

	/**
	 * 获取申请人列表
	 * 
	 * @param request
	 * @param reponse
	 * @param name
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "fuzzyApplicantList.do", method = RequestMethod.GET)
	@ResponseBody
	public String fuzzyApplicantList(HttpServletRequest request, HttpServletResponse reponse, String name){
		
		List<Map<String, String>> list = financeFacade.fuzzyApplicantList(WebUtils.getCurBizId(request), name);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}

	/**
	 * 派单
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("/diatributeBill.htm")
	public String diatributeBill(HttpServletRequest request, HttpServletResponse response, ModelMap model, String id,
			String guideId, String groupCode) {
		
		DiatributeBillDTO dto = new DiatributeBillDTO();
		
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGroupCode(groupCode);
		dto.setGuideId(guideId);
		dto.setId(id);
		
		DiatributeBillResult result = financeFacade.diatributeBill(dto);
		model.put("guideName", result.getGuideName());
		model.put("applicant", result.getApplicant());
		model.put("appliTime", result.getAppliTime());
		model.put("financeBillDetailList", result.getFinanceBillDetailList());
		model.put("nowDate", result.getNowDate());
		model.addAttribute("billTypeList", result.getBillTypeList());

		return "finance/bill/distributeBill";
	}

	/**
	 * 销单
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("/verifyBill.htm")
	public String verifyBill(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String id, String guideId, String groupCode) {
		
		VerifyBillDTO dto = new VerifyBillDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGroupCode(groupCode);
		dto.setGuideId(guideId);
		dto.setId(id);
		VerifyBillResult result = financeFacade.verifyBill(dto);
		
		model.put("guideName", result.getGuideName());
		model.put("applicant", result.getApplicant());
		model.put("appliTime", result.getAppliTime());
		model.put("apprTime", result.getApprTime());
		model.put("financeBillDetailList", result.getFinanceBillDetailList());
		model.put("nowDate", result.getNowDate());
		model.addAttribute("billTypeList", result.getBillTypeList());
		return "finance/bill/verifyBill";
	}

	/**
	 * 查单
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("/checkBill.htm")
	public String checkBill(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String id,
			String guideId, String groupCode, String appliState) {
		
		CheckBillDTO dto = new CheckBillDTO();
		dto.setAppliState(appliState);
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGroupCode(groupCode);
		dto.setGuideId(guideId);
		dto.setId(id);
		
		CheckBillResult result = financeFacade.checkBill(dto);
		
		model.put("guideName", result.getGuideName());
		model.put("applicant", result.getApplicant());
		model.put("appliTime", result.getAppliTime());
		model.put("apprTime", result.getApprTime());
		model.put("veriTime", result.getVeriTime());
		model.put("appliState", appliState);
		model.put("financeBillDetailList", result.getFinanceBillDetailList());
		model.addAttribute("billTypeList", result.getBillTypeList());
		return "finance/bill/checkBill";
	}
	
	/**
	 * 查单-打印
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("/checkBillPrint.htm")
	public String checkBillPrint(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String id,
			String guideId, String groupCode, String appliState) {
		
		CheckBillDTO dto = new CheckBillDTO();
		dto.setAppliState(appliState);
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGroupCode(groupCode);
		dto.setGuideId(guideId);
		dto.setId(id);
		CheckBillResult result = financeFacade.checkBillPrint(dto);
		
		model.put("guideName", result.getGuideName());
		model.put("applicant", result.getApplicant());
		model.put("appliTime", result.getAppliTime());
		model.put("apprTime", result.getApprTime());
		model.put("veriTime", result.getVeriTime());
		model.put("appliState", appliState);
		model.put("financeBillDetailList", result.getFinanceBillDetailList());
		model.addAttribute("tour", result.getTourGroup());
		model.addAttribute("billTypeList", result.getBillTypeList());
		return "finance/bill/checkBillPrint";
	}


	/**
	 * 派单保存
	 * 
	 * @param request
	 * @param billList
	 * @return
	 */
	@RequestMapping(value = "/saveDistributeBill.do", method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String saveDistributeBill(HttpServletRequest request,
			String billList, String groupId, String guideId, String type) {
		
		SaveDistributeBillDTO dto = new SaveDistributeBillDTO();
		dto.setBillList(billList);
		if(StringUtils.isNotEmpty(groupId)){
			dto.setGroupId(Integer.parseInt(groupId));
		}
		if(StringUtils.isNotEmpty(guideId)){
			dto.setGuideId(Integer.parseInt(guideId));
		}
		dto.setLoginName(WebUtils.getCurUser(request).getLoginName());
		dto.setType(type);
		
		financeFacade.saveDistributeBill(dto);
		return null;
	}

	/**
	 * 销单保存
	 * 
	 * @param request
	 * @param billList
	 * @return
	 */
	@RequestMapping(value = "/saveVerifyBill.do", method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String saveVerifyBill(HttpServletRequest request, String billList,
			String groupId, String guideId, String type) {
		
		SaveVerifyBillDTO dto = new SaveVerifyBillDTO();
		dto.setBillList(billList);
		if(StringUtils.isNotEmpty(groupId)){
			dto.setGroupId(Integer.parseInt(groupId));
		}
		if(StringUtils.isNotEmpty(guideId)){
			dto.setGuideId(Integer.parseInt(guideId));
		}
		dto.setLoginName(WebUtils.getCurUser(request).getLoginName());
		dto.setType(type);
		financeFacade.saveVerifyBill(dto);
		return null;
	}
	
	/**
	 * 取消销单
	 * 
	 * @param request
	 * @param billList
	 * @return
	 */
	@RequestMapping(value = "/delVerify.do", method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String delVerify(HttpServletRequest request, String order_id,String type) {
		financeFacade.delVerify(order_id, type);
		return null;
	}
	
	/**
	 * 取消领单
	 * 
	 * @param request
	 * @param billList
	 * @return
	 */
	@RequestMapping(value = "/delReceived.do", method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String delReceived(HttpServletRequest request, String group_id,String guide_id) {
		financeFacade.delReceived(group_id,guide_id);
		return null;
	}

	/**
	 * 获取操作员列表
	 * 
	 * @param request
	 * @param reponse
	 * @param name
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "getUserNameList.do", method = RequestMethod.GET)
	@ResponseBody
	public String getUserNameList(HttpServletRequest request,HttpServletResponse reponse, String name){
		
		List<Map<String, String>> list = financeFacade.getUserNameList(WebUtils.getCurBizId(request), name);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}

	/**
	 * 结算单审核分页查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午7:30:42
	 * @param sl
	 *            sqlId
	 * @param rp
	 *            返回页面
	 * @param svc
	 *            在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "settleListPage.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String settleListPage(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {
		
		SettleListPageDTO dto = new SettleListPageDTO();
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
		dto.setSl(sl);
		dto.setSsl(ssl);
		dto.setSvc(svc);
		
		SettleListPageResult result = financeFacade.settleListPage(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("guideMap", result.getGuideMap());
		model.addAttribute("sum", result.getSumMap());
		
		return "finance/settle-list-table";
	}

	/**
	 * 结算单审核列表查询
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年7月27日 下午7:30:42
	 * @param sl
	 *            sqlId
	 * @param rp
	 *            返回页面
	 * @param svc
	 *            在Spring中声明的服务BeanID
	 * @return
	 */
	@RequestMapping(value = "querySettleList.htm")
//	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String querySettleList(HttpServletRequest request,HttpServletResponse reponse, 
			ModelMap model, String sl, String rp,String svc,String edit) {
		
		
		QuerySettleListDTO dto = new QuerySettleListDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setEdit(edit);
		dto.setFeeType(request.getParameter("feeType"));
		dto.setGroupId(request.getParameter("groupId"));
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setRp(rp);
		dto.setSl(sl);
		
		String supType = request.getParameter("supType");
		if(StringUtils.isNotEmpty(supType)){
			dto.setSupType(Integer.parseInt(supType));
		}
		dto.setSvc(svc);
		
		QuerySettleListResult result = financeFacade.querySettleList(dto);
		
		model.addAttribute("list", result.getList());
		model.put("bookingGuides", result.getBookingGuides());
		model.addAttribute("cashTypes", result.getCashTypes());
		
		return rp;
	}
	
	/**
	 * 删除财务-收款付款
	 */
	@RequestMapping(value = "deleteFinancePay.do")
	@ResponseBody
	@PostHandler
	public String deleteFinancePay(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id) {
		
		ResultSupport result = financeFacade.deleteFinancePay(id);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
			return errorJson("操作失败");
		}
	}

	/**
	 * 删除财务-收款付款详情
	 */
	@RequestMapping(value = "deleteFinancePayDetail.do")
	@ResponseBody
	@PostHandler
	public String deleteFinancePayDetail(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, Integer supplierType, Integer locOrderId, Integer payId) {
		ResultSupport result = financeFacade.deleteFinancePayDetail(supplierType, locOrderId, payId);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
			return errorJson("操作失败");
		}
	}
	
	/**
	 * 批量删除财务-收款付款详情
	 */
	@RequestMapping(value = "batchDeleteFinancePayDetail.do")
	@ResponseBody
	@PostHandler
	public String batchDeleteFinancePayDetail(HttpServletRequest request, HttpServletResponse reponse, 
			ModelMap model, Integer supplierType, String locOrderIds, Integer payId) {
		
		if(StringUtils.isEmpty(locOrderIds)){
			return successJson("msg", "操作成功");
		}
		
		ResultSupport result = financeFacade.batchDeleteFinancePayDetail(supplierType, locOrderIds, payId);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
			return errorJson("操作失败");
		}
	}

	/**
	 * 购物审核
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("shopVerifyList.htm")
	public String shopVerifyList(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/shopVerify/shopVerifyList";
	}

	/**
	 * 购物审核列表
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/toBookingShopVerifyList.do")
	public String toBookingShopVerifyList(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group,String guideName) {
		
		ToBookingShopVerifyListDTO dto = new ToBookingShopVerifyListDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGuideName(guideName);
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
		
		ToBookingShopVerifyListlResult result = financeFacade.toBookingShopVerifyList(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("map", result.getSumMap());
		model.addAttribute("supplierGuides", result.getSupplierGuides());

		return "finance/shopVerify/shopVerifyList-table";
	}
	
	/**
	 * 购物审核打印
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/toBookingShopVerifyPrint.do")
	public String toBookingShopVerifyPrint(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group,String guideName) {
		
		
		ToBookingShopVerifyListDTO dto = new ToBookingShopVerifyListDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setGuideName(guideName);
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(100000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		
		ToBookingShopVerifyListlResult result = financeFacade.toBookingShopVerifyList(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("map", result.getSumMap());
		model.addAttribute("supplierGuides", result.getSupplierGuides());
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));

		return "finance/shopVerify/shopVerifyList-print";
	}

	/**
	 * 批量审核购物店
	 */
	@RequestMapping(value = "auditShop.do")
	@ResponseBody
	public String auditShop(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String checkedIds, String unCheckedIds) {
		
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		
		AuditShopDTO dto = new AuditShopDTO();
		dto.setCheckedIds(checkedIds);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		dto.setUnCheckedIds(unCheckedIds);
		
		financeFacade.auditShop(dto);
		return null;
	}

	/**
	 * 购物佣金发放统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("shopCommissionStatsList.htm")
	public String shopStatisticsList(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		String projectTypeJsonStr = financeFacade.shopCommissionStatsList(bizId);
		
		model.addAttribute("projectTypeJsonStr", projectTypeJsonStr);
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/commission/shopCommissionStats-list";
	}
	
	/**
	 * 购物佣金扣除统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("shopCommissionDeductionStatsList.htm")
	public String shopCommissionDeductionStatsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		String projectTypeJsonStr = financeFacade.shopCommissionDeductionStatsList(bizId);
		
		model.addAttribute("projectTypeJsonStr", projectTypeJsonStr);
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "finance/commission/shopCommissionDeductionStats-list";
	}

	@RequestMapping("viewShopCommissionStatsList.htm")
	public String viewhopStatisticsList(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("bizId", bizId);
		
		ViewShopCommissionStatsListResult viewResult = financeFacade.viewShopCommissionStatsList(bizId);
		model.addAttribute("pp", viewResult.getBrand());
		model.addAttribute("projectTypeJsonStr", viewResult.getProjectTypeJsonStr());
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "finance/commission/viewShopCommissionStats-list";
	}
	
	@RequestMapping("viewShopCommissionDeductionStatsList.htm")
	public String viewShopCommissionDeductionStatsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("bizId", bizId);
		
		ViewShopCommissionStatsListResult viewResult = financeFacade.viewShopCommissionDeductionStatsList(bizId);
		model.addAttribute("pp", viewResult.getBrand());
		model.addAttribute("projectTypeJsonStr", viewResult.getProjectTypeJsonStr());
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "finance/commission/viewShopCommissionDeductionStats-list";
	}

	/**
	 * 购物佣金发放统计列表
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/queryShopCommissionStats.do")
	public String toShopStatisticsList(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		
		QueryShopCommissionStatsDTO dto = new QueryShopCommissionStatsDTO();
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
		
		QueryShopCommissionStatsResult result = financeFacade.queryShopCommissionStats(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		model.addAttribute("sums", result.getSums());

		return "finance/commission/shopCommissionStats-table";
	}
	
	/**
	 * 购物佣金扣除统计列表
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/queryShopCommissionDeductionStats.do")
	public String queryShopCommissionDeductionStats(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		QueryShopCommissionStatsDTO dto = new QueryShopCommissionStatsDTO();
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
		
		QueryShopCommissionStatsResult result = financeFacade.queryShopCommissionDeductionStats(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		model.addAttribute("sums", result.getSums());

		return "finance/commission/shopCommissionDeductionStats-table";
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/queryShopCommissionStats2.do")
	public String toShopStatisticsList2(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		QueryShopCommissionStatsDTO dto = new QueryShopCommissionStatsDTO();
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
		
		QueryShopCommissionStatsResult result = financeFacade.queryShopCommissionStats2(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		model.addAttribute("sums", result.getSums());


		return "finance/commission/viewShopCommissionStats-table";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/queryShopCommissionDeductionStats2.do")
	public String queryShopCommissionDeductionStats2(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		QueryShopCommissionStatsDTO dto = new QueryShopCommissionStatsDTO();
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
		
		QueryShopCommissionStatsResult result = financeFacade.queryShopCommissionDeductionStats2(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());
		model.addAttribute("sums", result.getSums());
		return "finance/commission/viewShopCommissionDeductionStats-table";
	}

	/**
	 * 批量审核购物发放佣金
	 */
	@RequestMapping(value = "auditComm.do")
	@ResponseBody
	public String auditComm(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String checkedIds, String unCheckedIds) {
		
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		
		AuditCommDTO dto = new AuditCommDTO();
		dto.setCheckedIds(checkedIds);
		dto.setUnCheckedIds(unCheckedIds);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		
		financeFacade.auditComm(dto);
		return null;
	}
	
	/**
	 * 批量审核购物扣除佣金
	 */
	@RequestMapping(value = "auditCommDeduction.do")
	@ResponseBody
	public String auditCommDeduction(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String checkedIds, String unCheckedIds) {
		
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		AuditCommDTO dto = new AuditCommDTO();
		dto.setCheckedIds(checkedIds);
		dto.setUnCheckedIds(unCheckedIds);
		dto.setEmployeeId(emp.getEmployeeId());
		dto.setEmployeeName(emp.getName());
		
		financeFacade.auditCommDeduction(dto);
		return null;
	}

	/**
	 * 跳转到购物佣金发放结算页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/settleCommissionList.htm")
	public String settleCommissionList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		SettleCommissionListResult settleResult = financeFacade.settleCommissionList(bizId, groupId);
		
		model.addAttribute("payTypeList", settleResult.getPayTypeList());
		model.addAttribute("bizAccountList", settleResult.getBizAccountList());
		model.addAttribute("bankList", settleResult.getBankList());
		model.addAttribute("guideList", settleResult.getGuideList());
		model.addAttribute("projectTypeJsonStr", settleResult.getProjectTypeJsonStr());
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/commission/settle-list";
	}
	
	/**
	 * 跳转到购物佣金扣除结算页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/settleCommissionDeductionList.htm")
	public String settleCommissionDeductionList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {

		Integer bizId = WebUtils.getCurBizId(request);
		
		SettleCommissionListResult settleResult = financeFacade.settleCommissionDeductionList(bizId, groupId);
		
		model.addAttribute("payTypeList", settleResult.getPayTypeList());
		model.addAttribute("bizAccountList", settleResult.getBizAccountList());
		model.addAttribute("bankList", settleResult.getBankList());
		model.addAttribute("guideList", settleResult.getGuideList());
		model.addAttribute("projectTypeJsonStr", settleResult.getProjectTypeJsonStr());
		
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		
		return "finance/commission/settle-deduction-list";
	}

	/**
	 * 购物佣金发放统计列表
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/querySettleCommission.do")
	public String querySettleCommission(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		
		QuerySettleCommissionDTO dto = new QuerySettleCommissionDTO();
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
		
		QuerySettleCommissionResult result = financeFacade.querySettleCommission(dto);
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());

		return "finance/commission/settle-list-table";
	}
	
	/**
	 * 购物佣金发放统计列表
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/querySettleCommissionDeduction.do")
	public String querySettleCommissionDeduction(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		QuerySettleCommissionDTO dto = new QuerySettleCommissionDTO();
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
		
		QuerySettleCommissionResult result = financeFacade.querySettleCommissionDeduction(dto);
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());

		return "finance/commission/settle-deduction-list-table";
	}
	
	/**
	 * 科目汇总表1
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("subjectSummary.htm")
	public String subjectSummary(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", bizId); // 过滤B商家
		model.addAttribute("sup_type_map",SupplierConstant.supplierTypeSubjectSummary);
		
		return "finance/subjectSummary/subjectSummaryList";
	}
	
	/**
	 * 科目汇总表1
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/subjectSummary.do")
	public String subjectSummary(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group){
		
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
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
		SubjectSummaryResult result = financeFacade.subjectSummary(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());

		return "finance/subjectSummary/subjectSummaryList-table";
	}
	
	/**
	 * 科目汇总表1 打印
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @return
	 */
	@RequestMapping("sumjectSummaryPrint.htm")
	public String sumjectSummaryPrint(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,TourGroupVO group) {
		
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(1000000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		SubjectSummaryResult result = financeFacade.subjectSummary(dto);
		
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/subjectSummary/subjectSummary-print";
	}
	
	
	@RequestMapping(value = "/sumjectSummaryExcl.do")
	@ResponseBody
	public void sumjectSummaryExcl(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(1000000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		SubjectSummaryResult result = financeFacade.subjectSummary(dto);
		
		List list = result.getPageBean().getResult();
		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/subjectSummary.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
	        CellStyle cellStyle = wb.createCellStyle();
	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
	        CellStyle styleLeft = wb.createCellStyle();
	        styleLeft.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleLeft.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleLeft.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleLeft.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
	        
	        CellStyle styleRight = wb.createCellStyle();
	        styleRight.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleRight.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleRight.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleRight.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0) ; //获取到第一个sheet
			Row row = null;
			Cell cc = null ;
			// 遍历集合数据，产生数据行  
			
	        Iterator<Map<String,Object>> it = list.iterator();  
		    int index = 0;  
		    BigDecimal sum_dy_total =new BigDecimal(0);
		    BigDecimal sum_gs_total =new BigDecimal(0);
		    BigDecimal sum_qd_total =new BigDecimal(0);
		    BigDecimal sum_qt_total =new BigDecimal(0);
		    while (it.hasNext()){ 
		    	//book
		    	Map<String,Object> book = it.next() ;
		    	
		       //从第三行开始，前两行分别为标题和列明
		       row = sheet.createRow(index+3);
		       //第一列：序号
		       cc = row.createCell(0);
		       cc.setCellValue(index+1);
		       cc.setCellStyle(cellStyle);
		       
		       //第二列：商家名称
		       cc = row.createCell(1);
		       cc.setCellValue(book.get("supplier_name")==null?"":book.get("supplier_name").toString());
		       cc.setCellStyle(cellStyle);
		       
		       //第三列：应付（导游现付）
		       cc = row.createCell(2);
		       BigDecimal dy_total = book.get("dy_total")!=null?new BigDecimal(book.get("dy_total").toString()):new BigDecimal(0);
		       cc.setCellValue(dy_total.intValue());
		       cc.setCellStyle(styleLeft);
		       
		       //第四列：应付（公司现付）
		       cc = row.createCell(3);
		       BigDecimal gs_total = book.get("gs_total") != null ? new BigDecimal(book.get("gs_total").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(gs_total));
		       cc.setCellStyle(styleLeft);
		       
		       //第五列：应付（签单月结）
		       cc = row.createCell(4);
		       BigDecimal qd_total = book.get("qd_total") != null ? new BigDecimal(book.get("qd_total").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(qd_total));
		       cc.setCellStyle(styleLeft);
		       
		       //第六列：应付（其它）
		       cc = row.createCell(5);
		       BigDecimal qt_total = book.get("qt_total") != null ? new BigDecimal(book.get("qt_total").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(qt_total));
		       cc.setCellStyle(styleLeft);
		       
		       //第七列：合计
		       cc = row.createCell(6);
		       cc.setCellValue(df.format(gs_total.add(qd_total).add(qt_total).add(dy_total)));
		       cc.setCellStyle(styleLeft);
		       
		       
		       index++; 
		       
		       sum_dy_total = sum_dy_total.add(dy_total);
		       sum_gs_total = sum_gs_total.add(gs_total);
		       sum_qd_total = sum_qd_total.add(qd_total);
		       sum_qt_total = sum_qt_total.add(qt_total);
		    }
		    row = sheet.createRow(index+3); //加合计行
		    cc = row.createCell(0);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(1);
		    cc.setCellValue("合计："); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(2);
		    cc.setCellValue(sum_dy_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(3);
		    cc.setCellValue(sum_gs_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(4);
		    cc.setCellValue(sum_qd_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(5);
		    cc.setCellValue(sum_qt_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(6);
		    cc.setCellValue(sum_dy_total.add(sum_gs_total).add(sum_qd_total).add(sum_qt_total).intValue()); 
		    cc.setCellStyle(styleRight);
		    CellRangeAddress region = new CellRangeAddress(index+4, index+5, 0, 13) ;
		    sheet.addMergedRegion(region) ;
		    row = sheet.createRow(index+4); //打印信息
		    cc = row.createCell(0);
		    cc.setCellValue("打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path=request.getSession().getServletContext().getRealPath("/")+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
	    	wb.write(out);
	    	out.close();
	    	wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download(path, response,"subjectSummaryBook.xlsx");
	}
	
	private void download(String path, HttpServletResponse response,String name) {  
        try {  
            // path是指欲下载的文件的路径。  
        	File file = new File(path);  
            // 取得文件名。  
        	String fileName = "";
    		try {
    			fileName = new String(name.getBytes("UTF-8"),
    					"iso-8859-1");
    		} catch (UnsupportedEncodingException e) {
    			e.printStackTrace();
    		}
            // 以流的形式下载文件。  
            InputStream fis = new BufferedInputStream(new FileInputStream(path));  
            byte[] buffer = new byte[fis.available()];  
            fis.read(buffer);  
            fis.close();  
            // 清空response  
            response.reset();  
            // 设置response的Header  
            response.addHeader("Content-Disposition", "attachment;filename="  
                    + new String(fileName.getBytes()));  
            response.addHeader("Content-Length", "" + file.length());  
            OutputStream toClient = new BufferedOutputStream(  
                    response.getOutputStream());  
            response.setContentType("application/vnd.ms-excel;charset=utf-8");  
            toClient.write(buffer);  
            toClient.flush();  
            toClient.close();
            file.delete() ;
        } catch (IOException ex) {
        	ex.printStackTrace();  
        }  
    }  
	
	
	/**
	 * 科目汇总表2
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("subjectSummary2.htm")
	public String subjectSummary2(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", bizId); // 过滤B商家
		model.addAttribute("sup_type_map",SupplierConstant.supplierTypeSubjectSummaryQT);
		return "finance/subjectSummary/subjectSummary2List";
	}
	
	/**
	 * 科目汇总表2
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/subjectSummary2.do")
	public String subjectSummary2(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group){
		
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
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
		SubjectSummaryResult result = financeFacade.subjectSummary2(dto);
		
		model.addAttribute("pageBean", result.getPageBean());

		return "finance/subjectSummary/subjectSummary2List-table";
	}
	
	
	/**
	 * 科目汇总表2 打印
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @return
	 */
	@RequestMapping("sumjectSummary2Print.htm")
	public String sumjectSummary2Print(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,TourGroupVO group) {
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(1000000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		SubjectSummaryResult result = financeFacade.subjectSummary2(dto);

		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/subjectSummary/subjectSummary2-print";
	}
	
	@RequestMapping(value = "/sumjectSummary2Excl.do")
	@ResponseBody
	public void sumjectSummary2Excl(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(1000000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		SubjectSummaryResult result = financeFacade.subjectSummary2(dto);
		
		
		PageBean pageBean = result.getPageBean();
		//合计
		PageBean pageBean2 = new PageBean();
		List list = pageBean.getResult();
		
		pageBean2 = result.getPageBeanSum();
		List list2 = pageBean2.getResult();
		Map<String, Object> sum_result =null;
		if(list2!=null){
			sum_result = (Map<String,Object>)list2.get(0);
		}

		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/subjectSummary2.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
	        CellStyle cellStyle = wb.createCellStyle();
	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
	        CellStyle styleLeft = wb.createCellStyle();
	        styleLeft.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleLeft.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleLeft.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleLeft.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
	        
	        CellStyle styleRight = wb.createCellStyle();
	        styleRight.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleRight.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleRight.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleRight.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0) ; //获取到第一个sheet
			Row row = null;
			Cell cc = null ;
			// 遍历集合数据，产生数据行  
			
	        Iterator<Map<String,Object>> it = list.iterator();  
		    int index = 0;  
		    while (it.hasNext()){ 
		    	//book
		    	Map<String,Object> book = it.next() ;
		    	
		       //从第三行开始，前两行分别为标题和列明
		       row = sheet.createRow(index+2);
		       //第一列：序号
		       cc = row.createCell(0);
		       cc.setCellValue(index+1);
		       cc.setCellStyle(cellStyle);
		       
		       //第二列：商家名称
		       cc = row.createCell(1);
		       cc.setCellValue(book.get("supplier_name")==null?"":book.get("supplier_name").toString());
		       cc.setCellStyle(cellStyle);
		       
		       //第三列：应付（
		       cc = row.createCell(2);
		       BigDecimal total = book.get("total")!=null?new BigDecimal(book.get("total").toString()):new BigDecimal(0);
		       cc.setCellValue(total.intValue());
		       cc.setCellStyle(styleLeft);
		       
		       //第四列：已付
		       cc = row.createCell(3);
		       BigDecimal total_cash = book.get("total_cash") != null ? new BigDecimal(book.get("total_cash").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(total_cash));
		       cc.setCellStyle(styleLeft);
		       
		       //第五列：期末余额
		       cc = row.createCell(4);
		       cc.setCellValue(total.subtract(total_cash).intValue());
		       cc.setCellStyle(styleLeft);
		       
		       index++; 
		       
		    }
		    BigDecimal hj = sum_result==null?new BigDecimal(0):new BigDecimal(sum_result.get("total").toString());
		    BigDecimal hj2 = sum_result==null?new BigDecimal(0):new BigDecimal(sum_result.get("total_cash").toString());
		    
		    row = sheet.createRow(index+2); //加合计行
		    cc = row.createCell(0);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(1);
		    cc.setCellValue("合计："); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(2);
		    cc.setCellValue(hj.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(3);
		    cc.setCellValue(hj2.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(4);
		    cc.setCellValue(hj.subtract(hj2).intValue()); 
		    cc.setCellStyle(styleRight);
		   
		    CellRangeAddress region = new CellRangeAddress(index+3, index+4, 0, 13) ;
		    sheet.addMergedRegion(region) ;
		    row = sheet.createRow(index+3); //打印信息
		    cc = row.createCell(0);
		    cc.setCellValue("打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path=request.getSession().getServletContext().getRealPath("/")+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
	    	wb.write(out);
	    	out.close();
	    	wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download(path, response,"subjectSummaryBook2.xlsx");
	}
	
	
	/**
	 * 科目汇总表3
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("subjectSummary3.htm")
	public String subjectSummary3(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId", bizId); // 过滤B商家
		return "finance/subjectSummary/subjectSummary3List";
	}
	
	/**
	 * 科目汇总表3
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/subjectSummary3.do")
	public String subjectSummary3(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group){
		
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
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
		SubjectSummaryResult result = financeFacade.subjectSummary3(dto);
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("dicInfoList", result.getDicInfoList());

		return "finance/subjectSummary/subjectSummary3List-table";
	}
	
	/**
	 * 科目汇总表3 打印
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @return
	 */
	@RequestMapping("sumjectSummaryPrint3.htm")
	public String sumjectSummaryPrint3(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,TourGroupVO group) {
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(1000000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		SubjectSummaryResult result = financeFacade.subjectSummary3(dto);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/subjectSummary/subjectSummary3-print";
	}
	
	
	@RequestMapping(value = "/sumjectSummaryExcl3.do")
	@ResponseBody
	public void sumjectSummaryExcl3(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
		SubjectSummaryDTO dto = new SubjectSummaryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrgIds(group.getOrgIds());
		dto.setPage(1);
		dto.setPageSize(1000000);
		dto.setParamters(WebUtils.getQueryParamters(request));
		dto.setSaleOperatorIds(group.getSaleOperatorIds());
		dto.setSet(WebUtils.getDataUserIdSet(request));
		SubjectSummaryResult result = financeFacade.subjectSummary3(dto);
		
		List list = result.getPageBean().getResult();
		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/subjectSummary3.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
	        CellStyle cellStyle = wb.createCellStyle();
	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
	        CellStyle styleLeft = wb.createCellStyle();
	        styleLeft.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleLeft.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleLeft.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleLeft.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
	        
	        CellStyle styleRight = wb.createCellStyle();
	        styleRight.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleRight.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleRight.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleRight.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0) ; //获取到第一个sheet
			Row row = null;
			Cell cc = null ;
			// 遍历集合数据，产生数据行  
			
	        Iterator<Map<String,Object>> it = list.iterator();  
		    int index = 0;  
		    BigDecimal sum_dy_total =new BigDecimal(0);
		    BigDecimal sum_gs_total =new BigDecimal(0);
		    BigDecimal sum_qt_total =new BigDecimal(0);
		    while (it.hasNext()){ 
		    	//book
		    	Map<String,Object> book = it.next() ;
		    	
		       //从第三行开始，前两行分别为标题和列明
		       row = sheet.createRow(index+3);
		       //第一列：序号
		       cc = row.createCell(0);
		       cc.setCellValue(index+1);
		       cc.setCellStyle(cellStyle);
		       
		       //第二列：商家名称
		       cc = row.createCell(1);
		       cc.setCellValue(book.get("supplier_name")==null?"":book.get("supplier_name").toString());
		       cc.setCellStyle(cellStyle);
		       
		       //第三列：应付（导游现收）
		       cc = row.createCell(2);
		       BigDecimal dy_total = book.get("dy_total")!=null?new BigDecimal(book.get("dy_total").toString()):new BigDecimal(0);
		       cc.setCellValue(dy_total.intValue());
		       cc.setCellStyle(styleLeft);
		       
		       //第四列：应付（公司现收）
		       cc = row.createCell(3);
		       BigDecimal gs_total = book.get("gs_total") != null ? new BigDecimal(book.get("gs_total").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(gs_total));
		       cc.setCellStyle(styleLeft);
		       
		       //第五列：应付（其它）
		       cc = row.createCell(4);
		       BigDecimal qt_total = book.get("qt_total") != null ? new BigDecimal(book.get("qt_total").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(qt_total));
		       cc.setCellStyle(styleLeft);
		       
		       //第六列：合计
		       cc = row.createCell(5);
		       cc.setCellValue(df.format(gs_total.add(qt_total).add(dy_total)));
		       cc.setCellStyle(styleLeft);
		       
		       
		       index++; 
		       
		       sum_dy_total = sum_dy_total.add(dy_total);
		       sum_gs_total = sum_gs_total.add(gs_total);
		       sum_qt_total = sum_qt_total.add(qt_total);
		    }
		    row = sheet.createRow(index+3); //加合计行
		    cc = row.createCell(0);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(1);
		    cc.setCellValue("合计："); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(2);
		    cc.setCellValue(sum_dy_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(3);
		    cc.setCellValue(sum_gs_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(4);
		    cc.setCellValue(sum_qt_total.intValue()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(5);
		    cc.setCellValue(sum_dy_total.add(sum_gs_total).add(sum_qt_total).intValue()); 
		    cc.setCellStyle(styleRight);
		    CellRangeAddress region = new CellRangeAddress(index+4, index+5, 0, 13) ;
		    sheet.addMergedRegion(region) ;
		    row = sheet.createRow(index+4); //打印信息
		    cc = row.createCell(0);
		    cc.setCellValue("打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path=request.getSession().getServletContext().getRealPath("/")+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
	    	wb.write(out);
	    	out.close();
	    	wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download(path, response,"subjectSummaryBook3.xlsx");
	}


	/**
	 * 结算单审核导出Excel功能
	 * @return
	 */
	@RequestMapping(value = "queryAuditGroupExcelList.htm")
	public void queryAuditGroupExcelList(HttpServletRequest request,HttpServletResponse response,
										 HttpServletResponse reponse, ModelMap model, Integer groupId) {

		Integer bizId = WebUtils.getCurBizId(request);
		//获取到团信息
		Map map= financeFacade.queryAuditViewInfo(groupId, bizId);

		Map groupMap = (Map) map.get("group");//获取到团信息
		//获取销售单
		Map<String, Object> pm = WebUtils.getQueryParamters(request);
		ExportTravelListTableDTO exportTravelListTableDTO = new ExportTravelListTableDTO();
		exportTravelListTableDTO.setParameters(pm);
		ExportTravelListTableResult exportTravelListTableResult = financeFacade.queryAuditGroupExcelList(exportTravelListTableDTO);
		List<Map<String, Object>> orderList = exportTravelListTableResult.getOrderList();

		//获取地接社
		//List<InfoBean>	del_list = (List) map.get("del");
		List<Map<String, Object>> deliveryList = exportTravelListTableResult.getDeliveryList();

		//获取地接社，餐厅，酒店，车队，景区，其他，保险
		List<InfoBean>	list = (List) map.get("sup");

		Map<String, Object> order_pm = WebUtils.getQueryParamters(request);
		List<Map<String, Object>> supplierList = exportTravelListTableResult.getSupplierList();

		//其他收入
		List<Map<String, Object>> otherIncomeList = exportTravelListTableResult.getOtherIncomeList();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		System.out.println("supplierList="+supplierList);
		String path = "";
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/financeAuditGroupList.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			XSSFFont createFont = wb.createFont();
			createFont.setFontName("微软雅黑");
			createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
			createFont.setFontHeightInPoints((short) 12);

			XSSFFont tableIndex = wb.createFont();
			tableIndex.setFontName("宋体");
			tableIndex.setFontHeightInPoints((short) 11);

			CellStyle cellStyleFont = wb.createCellStyle();
			cellStyleFont.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyleFont.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyleFont.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyleFont.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyleFont.setAlignment(CellStyle.ALIGN_LEFT); // 居中
			XSSFFont font = wb.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
			cellStyleFont.setFont(font);

			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleFontCenter = wb.createCellStyle();
			styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontCenter.setFont(createFont);

			CellStyle styleFontTable = wb.createCellStyle();
			styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			int index = 0;

			//1、团信息
			if(groupMap.size()>0){
				row = sheet.createRow(index + 3);
				cc = row.createCell(0);
				cc.setCellValue("团号");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue((String)groupMap.get("group_code"));//团号
				cc.setCellStyle(styleLeft);

				cc = row.createCell(2);
				cc.setCellValue("计调");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue((String)groupMap.get("operator_name"));//计调
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("人数");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(groupMap.get("total_adult")+"+"+groupMap.get("total_child")+"+"+groupMap.get("total_guide"));//人数
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue("状态");//
				cc.setCellStyle(cellStyle);

				Integer num = (Integer)groupMap.get("group_state");
				if(num==0){
					cc = row.createCell(7);
					cc.setCellValue("未确认");//未确认
					cc.setCellStyle(cellStyle);
				}else if(num==1){
					cc = row.createCell(7);
					cc.setCellValue("已确认");//已确认
					cc.setCellStyle(cellStyle);
				}else if(num==2){
					cc = row.createCell(7);
					cc.setCellValue("作废");//作废
					cc.setCellStyle(cellStyle);
				}else if(num==3){
					cc = row.createCell(7);
					cc.setCellValue("已审核");//已审核
					cc.setCellStyle(cellStyle);
				}else {
					cc = row.createCell(7);
					cc.setCellValue("已封存");//已封存
					cc.setCellStyle(cellStyle);
				}

				cc = row.createCell(8);
				cc.setCellValue("产品名称");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(9);
				cc.setCellValue("【"+groupMap.get("product_brand_name")+"】"+groupMap.get("product_name"));//产品名称
				cc.setCellStyle(styleLeft);

				row = sheet.createRow(index + 4);
				cc = row.createCell(0);
				cc.setCellValue("收入");//
				cc.setCellStyle(cellStyle);

				BigDecimal total_income = (BigDecimal) groupMap.get("total_income");
				BigDecimal total_income_shop = (BigDecimal) groupMap.get("total_income_shop");
				cc = row.createCell(1);
				cc.setCellValue(df.format(total_income.add(total_income_shop)));//收入
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("支出");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue(df.format(groupMap.get("total_cost")));//支出
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("单团利润");//
				cc.setCellStyle(cellStyle);

				BigDecimal total_profit = (BigDecimal) groupMap.get("total_profit");
				cc = row.createCell(5);
				cc.setCellValue(df.format(total_profit.add(total_income_shop)));//单团利润
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue("人均利润");//
				cc.setCellStyle(cellStyle);

				Integer person_num = (Integer) groupMap.get("person_num");
				BigDecimal sum = total_profit.add(total_income_shop);
				if(person_num.intValue()==0){
					cc = row.createCell(7);
					cc.setCellValue(df.format(sum));//人均利润 = 单团利润
					cc.setCellStyle(cellStyle);
				}else {
					cc = row.createCell(7);
					cc.setCellValue(df.format(sum.divide(new BigDecimal(person_num),2, RoundingMode.HALF_UP)));//人均利润
					cc.setCellStyle(cellStyle);
				}

				cc = row.createCell(8);
				cc.setCellValue("起始日期");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(9);
				cc.setCellValue(groupMap.get("date_start")+"~"+groupMap.get("date_end"));//起始日期
				cc.setCellStyle(styleLeft);
			}
			//2、销售单
			index=0;
			if(orderList != null && orderList.size() > 0 ){
				for(Map<String, Object> item : orderList){
					row = sheet.createRow(index +9);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)item.get("supplier_name"));//组团社
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue((String)item.get("sale_operator_name"));//销售
					cc.setCellStyle(cellStyle);

					cc = row.createCell(3);
					cc.setCellValue((String)item.get("receive_mode"));//接站牌
					cc.setCellStyle(styleLeft);

					cc = row.createCell(4);
					cc.setCellValue(item.get("num_adult")+"+"+item.get("num_child")+"+"+item.get("num_guide"));//人数
					cc.setCellStyle(cellStyle);

					String total = df.format(item.get("total"));
					if(!"".equals(total)){
						cc = row.createCell(5);
						cc.setCellValue(total);//金额
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(5);
						cc.setCellValue(0);//金额
						cc.setCellStyle(cellStyle);
					}

					String total_cash = df.format(item.get("total_cash"));
					if(!"".equals(total_cash)){
						cc = row.createCell(6);
						cc.setCellValue(total_cash);//已收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(6);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}

					String balance = df.format(item.get("balance"));
					if(!"".equals(total_cash)){
						cc = row.createCell(7);
						cc.setCellValue(balance);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(7);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumTotal = new BigDecimal(0);
				BigDecimal sumTotalCost = new BigDecimal(0);
				BigDecimal sumBalance = new BigDecimal(0);
				for(int i=0; i<orderList.size(); i++) {
					Map<String,Object> sumMap = orderList.get(i);
					String total = df.format(sumMap.get("total"));
					if(!"".equals(total)){
						sumTotal = sumTotal.add((BigDecimal)sumMap.get("total"));
					}else {
						sumTotal = new BigDecimal(0);
					}

					String totalCash = df.format(sumMap.get("total_cash"));
					if(!"".equals(totalCash)){
						sumTotalCost = sumTotalCost.add((BigDecimal)sumMap.get("total_cash"));
					}else {
						sumTotalCost = new BigDecimal(0);
					}

					String balance = df.format(sumMap.get("balance"));
					if(!"".equals(balance)){
						sumBalance = sumBalance.add((BigDecimal)sumMap.get("balance"));
					}else {
						sumBalance = new BigDecimal(0);
					}
				}
				row = sheet.createRow(index + orderList.size()+9); // 加合计行
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellStyle(styleRight);

				cc = row.createCell(4);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue(df.format(sumTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(7);
				cc.setCellValue(df.format(sumBalance));
				cc.setCellStyle(cellStyle);

			}

			//3、地接社
			index=0;
			if(deliveryList != null && deliveryList.size()>0){

				CellRangeAddress region = new CellRangeAddress(index +orderList.size()+11,
						index +orderList.size()+11, 0, 5);
				sheet.addMergedRegion(region);
				row = sheet.createRow(index +orderList.size()+11);
				cc = row.createCell(0);
				cc.setCellValue("地接社");
				cc.setCellStyle(cellStyleFont);

				row = sheet.createRow(index +orderList.size()+12);
				cc = row.createCell(0);
				cc.setCellValue("序号");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue("商家");//商家
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("日期");//日期
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue("金额");//成本/金额
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("已收");//已收
				cc.setCellStyle(cellStyle);


				cc = row.createCell(5);
				cc.setCellValue("未收");//未收
				cc.setCellStyle(cellStyle);

				for(Map<String, Object> delItem : deliveryList){
					row = sheet.createRow(index +orderList.size()+13);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)delItem.get("supplier_name"));//商家
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue((String)delItem.get("create_date"));//日期
					cc.setCellStyle(styleLeft);

					if(delItem.get("total") == null){
						cc = row.createCell(3);
						cc.setCellValue(0);//成本/金额
						cc.setCellStyle(styleLeft);
					}else{
						String t_totalCash = df.format(delItem.get("total"));
						if("".equals(t_totalCash)){
							cc = row.createCell(3);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(3);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					if(delItem.get("total_cash") == null){
						cc = row.createCell(4);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}else{
						String t_totalCash = df.format(delItem.get("total_cash"));
						if("".equals(t_totalCash)){
							cc = row.createCell(4);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(4);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					String b_balance = df.format(delItem.get("balance"));
					if("".equals(b_balance)){
						cc = row.createCell(5);
						cc.setCellValue(0);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(5);
						cc.setCellValue(b_balance);//未收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumDelTotal = new BigDecimal(0);
				BigDecimal sumDelTotalCost = new BigDecimal(0);
				BigDecimal sumDelBalance = new BigDecimal(0);
				for(int i=0; i<deliveryList.size(); i++) {
					Map<String,Object> sumDel = deliveryList.get(i);

					if(sumDel.get("total") == null){
						sumDelTotal = new BigDecimal(0);
					}else{
						String total = df.format(sumDel.get("total"));
						if(!"".equals(total)){
							sumDelTotal = sumDelTotal.add((BigDecimal)sumDel.get("total"));
						}else {
							sumDelTotal = new BigDecimal(0);
						}
					}
					if(sumDel.get("total_cash") == null){
						sumDelTotalCost = new BigDecimal(0);
					}else{
						String totalCash = df.format(sumDel.get("total_cash"));
						if(!"".equals(totalCash)){
							sumDelTotalCost = sumDelTotalCost.add((BigDecimal)sumDel.get("total_cash"));
						}else {
							sumDelTotalCost = new BigDecimal(0);
						}
					}

					if(sumDel.get("balance") == null){
						sumDelBalance = new BigDecimal(0);
					}else{
						String balance = df.format(sumDel.get("balance"));
						if(!"".equals(balance)){
							sumDelBalance = sumDelBalance.add((BigDecimal)sumDel.get("balance"));
						}else {
							sumDelBalance = new BigDecimal(0);
						}
					}
				}

				if(orderList.size()==1){
					row = sheet.createRow(index +orderList.size()+14);
				}
				if(orderList.size()>1){
					row = sheet.createRow(index +orderList.size()+15);
				}
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellValue(df.format(sumDelTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue(df.format(sumDelTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumDelBalance));
				cc.setCellStyle(cellStyle);
			}

			//4、其他收入
			index=0;
			if(otherIncomeList.size() > 0 && otherIncomeList.size()>0){
				if(deliveryList.size() == 0){
					CellRangeAddress region = new CellRangeAddress(index +orderList.size()+11,
							index +orderList.size()+11, 0, 5);
					sheet.addMergedRegion(region);
					row = sheet.createRow(index +orderList.size()+11);
				}else {
					CellRangeAddress region = new CellRangeAddress(index +orderList.size()+deliveryList.size()+15,
							index +orderList.size()+deliveryList.size()+15, 0, 5);
					sheet.addMergedRegion(region);
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+15);
				}

				cc = row.createCell(0);
				cc.setCellValue("其他收入");
				cc.setCellStyle(cellStyleFont);

				if(deliveryList .size() == 0){
					row = sheet.createRow(index +orderList.size()+12);
				}else {
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+16);
				}
				cc = row.createCell(0);
				cc.setCellValue("序号");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue("商家");//商家
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("日期");//日期
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue("金额");//成本/金额
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("已收");//已收
				cc.setCellStyle(cellStyle);


				cc = row.createCell(5);
				cc.setCellValue("未收");//未收
				cc.setCellStyle(cellStyle);

				for(Map<String, Object> otherMap : otherIncomeList){
					if(deliveryList .size() == 0){
						row = sheet.createRow(index +orderList.size()+13);
					}else {
						row = sheet.createRow(index +orderList.size()+deliveryList.size()+17);
					}
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)otherMap.get("supplier_name"));//商家
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue(sdf.format(otherMap.get("booking_date")));//日期
					cc.setCellStyle(styleLeft);

					String _total = df.format(otherMap.get("total"));
					if("".equals(_total)){
						cc = row.createCell(3);
						cc.setCellValue(0);//成本/金额
						cc.setCellStyle(styleLeft);
					}else {
						cc = row.createCell(3);
						cc.setCellValue(_total);//成本/金额
						cc.setCellStyle(styleLeft);
					}

					if(otherMap.get("total_cash") == null){
						cc = row.createCell(4);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}else{
						String t_totalCash = df.format(otherMap.get("total_cash"));
						if("".equals(t_totalCash)){
							cc = row.createCell(4);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(4);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					String b_balance = df.format(otherMap.get("balance"));
					if("".equals(b_balance)){
						cc = row.createCell(5);
						cc.setCellValue(0);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(5);
						cc.setCellValue(b_balance);//未收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumOtherTotal = new BigDecimal(0);
				BigDecimal sumOtherTotalCost = new BigDecimal(0);
				BigDecimal sumOtherBalance = new BigDecimal(0);
				for(int i=0; i<otherIncomeList.size(); i++) {
					Map<String,Object> sumOther = otherIncomeList.get(i);

					if(sumOther.get("total") == null){
						sumOtherTotal = new BigDecimal(0);
					}else{
						String total = df.format(sumOther.get("total"));
						if(!"".equals(total)){
							sumOtherTotal = sumOtherTotal.add((BigDecimal)sumOther.get("total"));
						}else {
							sumOtherTotal = new BigDecimal(0);
						}
					}
					if(sumOther.get("total_cash") == null){
						sumOtherTotalCost = new BigDecimal(0);
					}else{
						String totalCash = df.format(sumOther.get("total_cash"));
						if(!"".equals(totalCash)){
							sumOtherTotalCost = sumOtherTotalCost.add((BigDecimal)sumOther.get("total_cash"));
						}else {
							sumOtherTotalCost = new BigDecimal(0);
						}
					}

					if(sumOther.get("balance") == null){
						sumOtherBalance = new BigDecimal(0);
					}else{
						String balance = df.format(sumOther.get("balance"));
						if(!"".equals(balance)){
							sumOtherBalance = sumOtherBalance.add((BigDecimal)sumOther.get("balance"));
						}else {
							sumOtherBalance = new BigDecimal(0);
						}
					}
				}
				if(deliveryList .size() == 0){
					row = sheet.createRow(index +orderList.size()+14);
				}else {
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+18);
				}
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellValue(df.format(sumOtherTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue(df.format(sumOtherTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumOtherBalance));
				cc.setCellStyle(cellStyle);
			}

			//5、地接社，餐厅，酒店，车队，景区，其他，保险
			index=0;
			if (supplierList != null && supplierList.size() > 0) {
				if(otherIncomeList.size() == 0 && deliveryList.size() >0){
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+16);
				}else if (otherIncomeList .size() > 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+otherIncomeList.size()+16);
				}else if (otherIncomeList.size() == 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+12);
				}else{
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+otherIncomeList.size()+20);
				}

				cc = row.createCell(0);
				cc.setCellValue("序号");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue("类别");//类别
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("商家");//商家
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue("日期");//日期
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("成本");//成本/金额
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue("已收");//已收
				cc.setCellStyle(cellStyle);


				cc = row.createCell(6);
				cc.setCellValue("未收");//未收
				cc.setCellStyle(cellStyle);

				for (Map<String, Object> items : supplierList) {
					if(otherIncomeList.size() == 0 && deliveryList.size() >0){
						row = sheet.createRow(index +orderList.size()+deliveryList.size()+17);
					}else if (otherIncomeList .size() > 0 && deliveryList.size() ==0) {
						row = sheet.createRow(index +orderList.size()+otherIncomeList.size()+17);
					}else if (otherIncomeList.size() == 0 && deliveryList.size() ==0) {
						row = sheet.createRow(index +orderList.size()+12);
					}else{
						row = sheet.createRow(index +orderList.size()+deliveryList.size()+otherIncomeList.size()+21);
					}

					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					Integer type = (Integer)items.get("supplier_type");
					if(type == Constants.TRAVELAGENCY){// 组团社
						cc = row.createCell(1);
						cc.setCellValue("组团社");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.RESTAURANT){// 餐厅
						cc = row.createCell(1);
						cc.setCellValue("餐厅");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.HOTEL){ // 酒店
						cc = row.createCell(1);
						cc.setCellValue("酒店");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.FLEET){// 车队
						cc = row.createCell(1);
						cc.setCellValue("车队");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.SCENICSPOT){// 景区
						cc = row.createCell(1);
						cc.setCellValue("景区");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.SHOPPING){// 购物
						cc = row.createCell(1);
						cc.setCellValue("购物");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.ENTERTAINMENT){// 娱乐
						cc = row.createCell(1);
						cc.setCellValue("娱乐");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.GUIDE){// 导游
						cc = row.createCell(1);
						cc.setCellValue("导游");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.AIRTICKETAGENT){// 机票代理
						cc = row.createCell(1);
						cc.setCellValue("机票代理");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.TRAINTICKETAGENT){// 火车票代理
						cc = row.createCell(1);
						cc.setCellValue("火车票代理");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.GOLF){// 高尔夫
						cc = row.createCell(1);
						cc.setCellValue("高尔夫");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.OTHER){// 其他
						cc = row.createCell(1);
						cc.setCellValue("其他");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.CONTRACTAGREEMENT){// 合同协议
						cc = row.createCell(1);
						cc.setCellValue("合同协议");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.SUPPLIERCOMMENT){// 商家评论
						cc = row.createCell(1);
						cc.setCellValue("商家评论");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.INSURANCE){// 保险
						cc = row.createCell(1);
						cc.setCellValue("保险");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.LOCALTRAVEL){// 地接社
						cc = row.createCell(1);
						cc.setCellValue("地接社");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.OTHERINCOME){// 其他收入
						cc = row.createCell(1);
						cc.setCellValue("其他收入");
						cc.setCellStyle(styleLeft);
					}else {// 其他支出
						cc = row.createCell(1);
						cc.setCellValue("其他支出");
						cc.setCellStyle(styleLeft);
					}

					cc = row.createCell(2);
					cc.setCellValue((String)items.get("supplier_name"));//商家
					cc.setCellStyle(styleLeft);

					cc = row.createCell(3);
					cc.setCellValue(sdf.format(items.get("booking_date")));//日期
					cc.setCellStyle(styleLeft);

					String _total = df.format(items.get("total"));
					if("".equals(_total)){
						cc = row.createCell(4);
						cc.setCellValue(0);//成本/金额
						cc.setCellStyle(styleLeft);
					}else {
						cc = row.createCell(4);
						cc.setCellValue(_total);//成本/金额
						cc.setCellStyle(styleLeft);
					}

					if(items.get("total_cash") == null){
						cc = row.createCell(5);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}else{
						String t_totalCash = df.format(items.get("total_cash"));
						if("".equals(t_totalCash)){
							cc = row.createCell(5);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(5);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					String b_balance = df.format(items.get("balance"));
					if("".equals(b_balance)){
						cc = row.createCell(6);
						cc.setCellValue(0);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(6);
						cc.setCellValue(b_balance);//未收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumSupplierTotal = new BigDecimal(0);
				BigDecimal sumSupplierTotalCost = new BigDecimal(0);
				BigDecimal sumSupplierBalance = new BigDecimal(0);
				for(int i=0; i<supplierList.size(); i++) {
					Map<String,Object> sumSupplier = supplierList.get(i);

					if(sumSupplier.get("total") == null){
						sumSupplierTotal = new BigDecimal(0);
					}else{
						String total = df.format(sumSupplier.get("total"));
						if(!"".equals(total)){
							sumSupplierTotal = sumSupplierTotal.add((BigDecimal)sumSupplier.get("total"));
						}else {
							sumSupplierTotal = new BigDecimal(0);
						}
					}
					if(sumSupplier.get("total_cash") == null){
						sumSupplierTotalCost = new BigDecimal(0);
					}else{
						String totalCash = df.format(sumSupplier.get("total_cash"));
						if(!"".equals(totalCash)){
							sumSupplierTotalCost = sumSupplierTotalCost.add((BigDecimal)sumSupplier.get("total_cash"));
						}else {
							sumSupplierTotalCost = new BigDecimal(0);
						}
					}

					if(sumSupplier.get("balance") == null){
						sumSupplierBalance = new BigDecimal(0);
					}else{
						String balance = df.format(sumSupplier.get("balance"));
						if(!"".equals(balance)){
							sumSupplierBalance = sumSupplierBalance.add((BigDecimal)sumSupplier.get("balance"));
						}else {
							sumSupplierBalance = new BigDecimal(0);
						}
					}
				}
				if(otherIncomeList.size() == 0 && deliveryList.size() >0){
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+supplierList.size()+17);
				}else if (otherIncomeList .size() > 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+otherIncomeList.size()+supplierList.size()+17);
				}else if (otherIncomeList.size() == 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+supplierList.size()+12);
				}else{
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+otherIncomeList.size()+supplierList.size()+21);
				}
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(4);
				cc.setCellValue(df.format(sumSupplierTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumSupplierTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue(df.format(sumSupplierBalance));
				cc.setCellStyle(cellStyle);
			}

			/*CellRangeAddress region = new CellRangeAddress(supplierList.size() + 5,
					supplierList.size() + 5, 0, 10);
			sheet.addMergedRegion(region);

			row = sheet.createRow(supplierList.size() + 5);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));*/
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("结算单详情.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path,fileName,request,response);

	}

	private void download(String path, String fileName, HttpServletRequest request, HttpServletResponse response) {
		try {
			// path是指欲下载的文件的路径。
			File file = new File(path);
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

			// 设置response的Header

			response.addHeader("Content-Length", "" + file.length());
			response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
			OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
			response.setContentType("application/vnd.ms-excel;charset=gb2312");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
			file.delete();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}


	/**
	 * 数字旅游平台数据导出
	 * @author daixiaoman
	 * @date 2016年12月5日 上午11:39:16
	 */
	@RequestMapping("/exportTravelList.htm")
	public String testFtl(HttpServletRequest request,ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		model.addAttribute("bizId",bizId); // 过滤B商家
		//获取所有已导出过数据的团 id 集合
		model.addAttribute("groupIds",tourGroupFacade.getGroupIdsByTravelExportStatus(1,bizId));
		return "finance/exportTravelList";
	}

	/**
	 * 数字旅游平台查看列表页面
	 * @author daixiaoman
	 * @date 2016年12月5日 上午11:45:34
	 */
	@RequestMapping("/exportTravelList_table.htm")
	public String exportTravelListTable(HttpServletRequest request,
										HttpServletResponse reponse, ModelMap model, String sl, String ssl,
										String rp, Integer page, Integer pageSize, String svc,TourGroupVO group) {
		ExportTravelListTableDTO exportTravelListTableDTO = new ExportTravelListTableDTO();
		exportTravelListTableDTO.setSl(sl);
		exportTravelListTableDTO.setSsl(ssl);
		exportTravelListTableDTO.setRp(rp);
		exportTravelListTableDTO.setPage(page);
		exportTravelListTableDTO.setPageSize(pageSize);
		exportTravelListTableDTO.setSvc(svc);
		exportTravelListTableDTO.setGroup(group);
		exportTravelListTableDTO.setBizId(WebUtils.getCurBizId(request));
		exportTravelListTableDTO.setParameters(WebUtils.getQueryParamters(request));
		exportTravelListTableDTO.setUserIdSet(WebUtils.getDataUserIdSet(request));
		ExportTravelListTableResult exportTravelListTableResult = financeFacade.exportTravelListTable(exportTravelListTableDTO);
		model.addAttribute("pageBean", exportTravelListTableResult.getPageBean());
		model.addAttribute("guideMap", exportTravelListTableResult.getGuideMap());
		model.addAttribute("sum", exportTravelListTableResult.getSum());
		return "finance/exportTravelList_table";
	}


	/**
	 * 导出数字旅游平台格式数据
	 * @author daixiaoman
	 * @date 2016年12月5日 上午10:45:16
	 */
	@RequestMapping("/exportSaleDataTravel.ftl")
	public void saleDataTravelExport(HttpServletRequest request,HttpServletResponse response){

		response.addHeader("Content-Disposition", "attachment;filename="+DateUtils.format(new Date(),"yyyyMMddHHmmss")+".xml");
		response.setContentType("application/xml;charset=utf-8");
		Map<String,Object> requestParams = WebUtils.getQueryParamters(request);
		List<Integer> groupIds = new ArrayList<Integer>();
		String[] paramsGroupids = ObjectUtils.toString(requestParams.get("groupIds")).split(",");
		for(String groupid:paramsGroupids){
			groupIds.add(ObjectUtils.parseInteger(groupid));
		}
		ExportTravelListTableDTO exportTravelListTableDTO = new ExportTravelListTableDTO();
		exportTravelListTableDTO.setParameters(requestParams);
		exportTravelListTableDTO.setParamsGroupids(paramsGroupids);
		exportTravelListTableDTO.setGroupIds(groupIds);
		ExportTravelListTableResult exportTravelListTableResult = financeFacade.saleDataTravelExport(exportTravelListTableDTO);

		String content = yihgTemplateFreemarkerService.getContent("saleDataTravelExport.ftl", exportTravelListTableResult.getModel());
			if(null != content){
				try {
					OutputStream os = response.getOutputStream();
					IOUtils.write(content, os);
					os.flush();
					IOUtils.closeQuietly(os);
					//更新导出状态
				//	tourGroupService.updateTourGroupTravelExportStatus(groupIds,1);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	/**
	 * 结算单审核导出Excel功能
	 * @return
	 *//*
	@RequestMapping(value = "queryAuditGroupExcelList.htm")
	public void queryAuditGroupExcelList(HttpServletRequest request,HttpServletResponse response,
										 HttpServletResponse reponse, ModelMap model, Integer groupId) {

		Integer bizId = WebUtils.getCurBizId(request);
		//获取到团信息
		Map map= financeService.queryAuditViewInfo(groupId, bizId);

		Map groupMap = (Map) map.get("group");//获取到团信息
		//获取销售单
		Map<String, Object> pm = WebUtils.getQueryParamters(request);
		List<Map<String, Object>> orderList = getCommonService(null).queryList("fin.selectOrderList", pm);

		//获取地接社
		//List<InfoBean>	del_list = (List) map.get("del");
		List<Map<String, Object>> deliveryList = getCommonService(null).queryList("fin.selectDeliveryList", pm);

		//获取地接社，餐厅，酒店，车队，景区，其他，保险
		List<InfoBean>	list = (List) map.get("sup");

//		Map<String, Object> order_pm = WebUtils.getQueryParamters(request);
		List<Map<String, Object>> supplierList = getCommonService(null).queryList("fin.selectSupplierList", pm);

		//其他收入
		List<Map<String, Object>> otherIncomeList = getCommonService(null).queryList("fin.selectOtherIncomeList", pm);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("supplierList="+supplierList);
		String path = "";
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/financeAuditGroupList.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			XSSFFont createFont = wb.createFont();
			createFont.setFontName("微软雅黑");
			createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
			createFont.setFontHeightInPoints((short) 12);

			XSSFFont tableIndex = wb.createFont();
			tableIndex.setFontName("宋体");
			tableIndex.setFontHeightInPoints((short) 11);

			CellStyle cellStyleFont = wb.createCellStyle();
			cellStyleFont.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyleFont.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyleFont.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyleFont.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyleFont.setAlignment(CellStyle.ALIGN_LEFT); // 居中
			XSSFFont font = wb.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
			cellStyleFont.setFont(font);

			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleFontCenter = wb.createCellStyle();
			styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontCenter.setFont(createFont);

			CellStyle styleFontTable = wb.createCellStyle();
			styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			int index = 0;

			//1、团信息
			if(groupMap.size()>0){
				row = sheet.createRow(index + 3);
				cc = row.createCell(0);
				cc.setCellValue("团号");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue((String)groupMap.get("group_code"));//团号
				cc.setCellStyle(styleLeft);

				cc = row.createCell(2);
				cc.setCellValue("计调");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue((String)groupMap.get("operator_name"));//计调
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("人数");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(groupMap.get("total_adult")+"+"+groupMap.get("total_child")+"+"+groupMap.get("total_guide"));//人数
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue("状态");//
				cc.setCellStyle(cellStyle);

				Integer num = (Integer)groupMap.get("group_state");
				if(num==0){
					cc = row.createCell(7);
					cc.setCellValue("未确认");//未确认
					cc.setCellStyle(cellStyle);
				}else if(num==1){
					cc = row.createCell(7);
					cc.setCellValue("已确认");//已确认
					cc.setCellStyle(cellStyle);
				}else if(num==2){
					cc = row.createCell(7);
					cc.setCellValue("作废");//作废
					cc.setCellStyle(cellStyle);
				}else if(num==3){
					cc = row.createCell(7);
					cc.setCellValue("已审核");//已审核
					cc.setCellStyle(cellStyle);
				}else {
					cc = row.createCell(7);
					cc.setCellValue("已封存");//已封存
					cc.setCellStyle(cellStyle);
				}

				cc = row.createCell(8);
				cc.setCellValue("产品名称");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(9);
				cc.setCellValue("【"+groupMap.get("product_brand_name")+"】"+groupMap.get("product_name"));//产品名称
				cc.setCellStyle(styleLeft);

				row = sheet.createRow(index + 4);
				cc = row.createCell(0);
				cc.setCellValue("收入");//
				cc.setCellStyle(cellStyle);

				BigDecimal total_income = (BigDecimal) groupMap.get("total_income");
				BigDecimal total_income_shop = (BigDecimal) groupMap.get("total_income_shop");
				cc = row.createCell(1);
				cc.setCellValue(df.format(total_income.add(total_income_shop)));//收入
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("支出");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue(df.format(groupMap.get("total_cost")));//支出
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("单团利润");//
				cc.setCellStyle(cellStyle);

				BigDecimal total_profit = (BigDecimal) groupMap.get("total_profit");
				cc = row.createCell(5);
				cc.setCellValue(df.format(total_profit.add(total_income_shop)));//单团利润
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue("人均利润");//
				cc.setCellStyle(cellStyle);

				Integer person_num = (Integer) groupMap.get("person_num");
				BigDecimal sum = total_profit.add(total_income_shop);
				if(person_num.intValue()==0){
					cc = row.createCell(7);
					cc.setCellValue(df.format(sum));//人均利润 = 单团利润
					cc.setCellStyle(cellStyle);
				}else {
					cc = row.createCell(7);
					cc.setCellValue(df.format(sum.divide(new BigDecimal(person_num),2, RoundingMode.HALF_UP)));//人均利润
					cc.setCellStyle(cellStyle);
				}

				cc = row.createCell(8);
				cc.setCellValue("起始日期");//
				cc.setCellStyle(cellStyle);

				cc = row.createCell(9);
				cc.setCellValue(groupMap.get("date_start")+"~"+groupMap.get("date_end"));//起始日期
				cc.setCellStyle(styleLeft);
			}
			//2、销售单
			index=0;
			if(orderList != null && orderList.size() > 0 ){
				for(Map<String, Object> item : orderList){
					row = sheet.createRow(index +9);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)item.get("supplier_name"));//组团社
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue((String)item.get("sale_operator_name"));//销售
					cc.setCellStyle(cellStyle);

					cc = row.createCell(3);
					cc.setCellValue((String)item.get("receive_mode"));//接站牌
					cc.setCellStyle(styleLeft);

					cc = row.createCell(4);
					cc.setCellValue(item.get("num_adult")+"+"+item.get("num_child")+"+"+item.get("num_guide"));//人数
					cc.setCellStyle(cellStyle);

					String total = df.format(item.get("total"));
					if(!"".equals(total)){
						cc = row.createCell(5);
						cc.setCellValue(total);//金额
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(5);
						cc.setCellValue(0);//金额
						cc.setCellStyle(cellStyle);
					}

					String total_cash = df.format(item.get("total_cash"));
					if(!"".equals(total_cash)){
						cc = row.createCell(6);
						cc.setCellValue(total_cash);//已收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(6);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}

					String balance = df.format(item.get("balance"));
					if(!"".equals(total_cash)){
						cc = row.createCell(7);
						cc.setCellValue(balance);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(7);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumTotal = new BigDecimal(0);
				BigDecimal sumTotalCost = new BigDecimal(0);
				BigDecimal sumBalance = new BigDecimal(0);
				for(int i=0; i<orderList.size(); i++) {
					Map<String,Object> sumMap = orderList.get(i);
					String total = df.format(sumMap.get("total"));
					if(!"".equals(total)){
						sumTotal = sumTotal.add((BigDecimal)sumMap.get("total"));
					}else {
						sumTotal = new BigDecimal(0);
					}

					String totalCash = df.format(sumMap.get("total_cash"));
					if(!"".equals(totalCash)){
						sumTotalCost = sumTotalCost.add((BigDecimal)sumMap.get("total_cash"));
					}else {
						sumTotalCost = new BigDecimal(0);
					}

					String balance = df.format(sumMap.get("balance"));
					if(!"".equals(balance)){
						sumBalance = sumBalance.add((BigDecimal)sumMap.get("balance"));
					}else {
						sumBalance = new BigDecimal(0);
					}
				}
				row = sheet.createRow(index + orderList.size()+9); // 加合计行
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellStyle(styleRight);

				cc = row.createCell(4);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue(df.format(sumTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(7);
				cc.setCellValue(df.format(sumBalance));
				cc.setCellStyle(cellStyle);

			}

			//3、地接社
			index=0;
			if(deliveryList != null && deliveryList.size()>0){

				CellRangeAddress region = new CellRangeAddress(index +orderList.size()+11,
						index +orderList.size()+11, 0, 5);
				sheet.addMergedRegion(region);
				row = sheet.createRow(index +orderList.size()+11);
				cc = row.createCell(0);
				cc.setCellValue("地接社");
				cc.setCellStyle(cellStyleFont);

				row = sheet.createRow(index +orderList.size()+12);
				cc = row.createCell(0);
				cc.setCellValue("序号");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue("商家");//商家
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("日期");//日期
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue("金额");//成本/金额
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("已收");//已收
				cc.setCellStyle(cellStyle);


				cc = row.createCell(5);
				cc.setCellValue("未收");//未收
				cc.setCellStyle(cellStyle);

				for(Map<String, Object> delItem : deliveryList){
					row = sheet.createRow(index +orderList.size()+13);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)delItem.get("supplier_name"));//商家
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue((String)delItem.get("create_date"));//日期
					cc.setCellStyle(styleLeft);

					if(delItem.get("total") == null){
						cc = row.createCell(3);
						cc.setCellValue(0);//成本/金额
						cc.setCellStyle(styleLeft);
					}else{
						String t_totalCash = df.format(delItem.get("total"));
						if("".equals(t_totalCash)){
							cc = row.createCell(3);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(3);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					if(delItem.get("total_cash") == null){
						cc = row.createCell(4);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}else{
						String t_totalCash = df.format(delItem.get("total_cash"));
						if("".equals(t_totalCash)){
							cc = row.createCell(4);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(4);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					String b_balance = df.format(delItem.get("balance"));
					if("".equals(b_balance)){
						cc = row.createCell(5);
						cc.setCellValue(0);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(5);
						cc.setCellValue(b_balance);//未收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumDelTotal = new BigDecimal(0);
				BigDecimal sumDelTotalCost = new BigDecimal(0);
				BigDecimal sumDelBalance = new BigDecimal(0);
				for(int i=0; i<deliveryList.size(); i++) {
					Map<String,Object> sumDel = deliveryList.get(i);

					if(sumDel.get("total") == null){
						sumDelTotal = new BigDecimal(0);
					}else{
						String total = df.format(sumDel.get("total"));
						if(!"".equals(total)){
							sumDelTotal = sumDelTotal.add((BigDecimal)sumDel.get("total"));
						}else {
							sumDelTotal = new BigDecimal(0);
						}
					}
					if(sumDel.get("total_cash") == null){
						sumDelTotalCost = new BigDecimal(0);
					}else{
						String totalCash = df.format(sumDel.get("total_cash"));
						if(!"".equals(totalCash)){
							sumDelTotalCost = sumDelTotalCost.add((BigDecimal)sumDel.get("total_cash"));
						}else {
							sumDelTotalCost = new BigDecimal(0);
						}
					}

					if(sumDel.get("balance") == null){
						sumDelBalance = new BigDecimal(0);
					}else{
						String balance = df.format(sumDel.get("balance"));
						if(!"".equals(balance)){
							sumDelBalance = sumDelBalance.add((BigDecimal)sumDel.get("balance"));
						}else {
							sumDelBalance = new BigDecimal(0);
						}
					}
				}

				if(orderList.size()==1){
					row = sheet.createRow(index +orderList.size()+14);
				}
				if(orderList.size()>1){
					row = sheet.createRow(index +orderList.size()+15);
				}
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellValue(df.format(sumDelTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue(df.format(sumDelTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumDelBalance));
				cc.setCellStyle(cellStyle);
			}

			//4、其他收入
			index=0;
			if(otherIncomeList.size() > 0 && otherIncomeList.size()>0){
				if(deliveryList.size() == 0){
					CellRangeAddress region = new CellRangeAddress(index +orderList.size()+11,
							index +orderList.size()+11, 0, 5);
					sheet.addMergedRegion(region);
					row = sheet.createRow(index +orderList.size()+11);
				}else {
					CellRangeAddress region = new CellRangeAddress(index +orderList.size()+deliveryList.size()+15,
							index +orderList.size()+deliveryList.size()+15, 0, 5);
					sheet.addMergedRegion(region);
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+15);
				}

				cc = row.createCell(0);
				cc.setCellValue("其他收入");
				cc.setCellStyle(cellStyleFont);

				if(deliveryList .size() == 0){
					row = sheet.createRow(index +orderList.size()+12);
				}else {
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+16);
				}
				cc = row.createCell(0);
				cc.setCellValue("序号");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue("商家");//商家
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("日期");//日期
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue("金额");//成本/金额
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("已收");//已收
				cc.setCellStyle(cellStyle);


				cc = row.createCell(5);
				cc.setCellValue("未收");//未收
				cc.setCellStyle(cellStyle);

				for(Map<String, Object> otherMap : otherIncomeList){
					if(deliveryList .size() == 0){
						row = sheet.createRow(index +orderList.size()+13);
					}else {
						row = sheet.createRow(index +orderList.size()+deliveryList.size()+17);
					}
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)otherMap.get("supplier_name"));//商家
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue(sdf.format(otherMap.get("booking_date")));//日期
					cc.setCellStyle(styleLeft);

					String _total = df.format(otherMap.get("total"));
					if("".equals(_total)){
						cc = row.createCell(3);
						cc.setCellValue(0);//成本/金额
						cc.setCellStyle(styleLeft);
					}else {
						cc = row.createCell(3);
						cc.setCellValue(_total);//成本/金额
						cc.setCellStyle(styleLeft);
					}

					if(otherMap.get("total_cash") == null){
						cc = row.createCell(4);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}else{
						String t_totalCash = df.format(otherMap.get("total_cash"));
						if("".equals(t_totalCash)){
							cc = row.createCell(4);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(4);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					String b_balance = df.format(otherMap.get("balance"));
					if("".equals(b_balance)){
						cc = row.createCell(5);
						cc.setCellValue(0);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(5);
						cc.setCellValue(b_balance);//未收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumOtherTotal = new BigDecimal(0);
				BigDecimal sumOtherTotalCost = new BigDecimal(0);
				BigDecimal sumOtherBalance = new BigDecimal(0);
				for(int i=0; i<otherIncomeList.size(); i++) {
					Map<String,Object> sumOther = otherIncomeList.get(i);

					if(sumOther.get("total") == null){
						sumOtherTotal = new BigDecimal(0);
					}else{
						String total = df.format(sumOther.get("total"));
						if(!"".equals(total)){
							sumOtherTotal = sumOtherTotal.add((BigDecimal)sumOther.get("total"));
						}else {
							sumOtherTotal = new BigDecimal(0);
						}
					}
					if(sumOther.get("total_cash") == null){
						sumOtherTotalCost = new BigDecimal(0);
					}else{
						String totalCash = df.format(sumOther.get("total_cash"));
						if(!"".equals(totalCash)){
							sumOtherTotalCost = sumOtherTotalCost.add((BigDecimal)sumOther.get("total_cash"));
						}else {
							sumOtherTotalCost = new BigDecimal(0);
						}
					}

					if(sumOther.get("balance") == null){
						sumOtherBalance = new BigDecimal(0);
					}else{
						String balance = df.format(sumOther.get("balance"));
						if(!"".equals(balance)){
							sumOtherBalance = sumOtherBalance.add((BigDecimal)sumOther.get("balance"));
						}else {
							sumOtherBalance = new BigDecimal(0);
						}
					}
				}
				if(deliveryList .size() == 0){
					row = sheet.createRow(index +orderList.size()+14);
				}else {
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+18);
				}
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellValue(df.format(sumOtherTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue(df.format(sumOtherTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumOtherBalance));
				cc.setCellStyle(cellStyle);
			}

			//5、地接社，餐厅，酒店，车队，景区，其他，保险
			index=0;
			if (supplierList != null && supplierList.size() > 0) {
				if(otherIncomeList.size() == 0 && deliveryList.size() >0){
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+16);
				}else if (otherIncomeList .size() > 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+otherIncomeList.size()+16);
				}else if (otherIncomeList.size() == 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+12);
				}else{
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+otherIncomeList.size()+20);
				}

				cc = row.createCell(0);
				cc.setCellValue("序号");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue("类别");//类别
				cc.setCellStyle(cellStyle);

				cc = row.createCell(2);
				cc.setCellValue("商家");//商家
				cc.setCellStyle(cellStyle);

				cc = row.createCell(3);
				cc.setCellValue("日期");//日期
				cc.setCellStyle(cellStyle);

				cc = row.createCell(4);
				cc.setCellValue("成本");//成本/金额
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue("已收");//已收
				cc.setCellStyle(cellStyle);


				cc = row.createCell(6);
				cc.setCellValue("未收");//未收
				cc.setCellStyle(cellStyle);

				for (Map<String, Object> items : supplierList) {
					if(otherIncomeList.size() == 0 && deliveryList.size() >0){
						row = sheet.createRow(index +orderList.size()+deliveryList.size()+17);
					}else if (otherIncomeList .size() > 0 && deliveryList.size() ==0) {
						row = sheet.createRow(index +orderList.size()+otherIncomeList.size()+17);
					}else if (otherIncomeList.size() == 0 && deliveryList.size() ==0) {
						row = sheet.createRow(index +orderList.size()+12);
					}else{
						row = sheet.createRow(index +orderList.size()+deliveryList.size()+otherIncomeList.size()+21);
					}

					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					Integer type = (Integer)items.get("supplier_type");
					if(type == Constants.TRAVELAGENCY){// 组团社
						cc = row.createCell(1);
						cc.setCellValue("组团社");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.RESTAURANT){// 餐厅
						cc = row.createCell(1);
						cc.setCellValue("餐厅");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.HOTEL){ // 酒店
						cc = row.createCell(1);
						cc.setCellValue("酒店");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.FLEET){// 车队
						cc = row.createCell(1);
						cc.setCellValue("车队");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.SCENICSPOT){// 景区
						cc = row.createCell(1);
						cc.setCellValue("景区");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.SHOPPING){// 购物
						cc = row.createCell(1);
						cc.setCellValue("购物");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.ENTERTAINMENT){// 娱乐
						cc = row.createCell(1);
						cc.setCellValue("娱乐");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.GUIDE){// 导游
						cc = row.createCell(1);
						cc.setCellValue("导游");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.AIRTICKETAGENT){// 机票代理
						cc = row.createCell(1);
						cc.setCellValue("机票代理");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.TRAINTICKETAGENT){// 火车票代理
						cc = row.createCell(1);
						cc.setCellValue("火车票代理");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.GOLF){// 高尔夫
						cc = row.createCell(1);
						cc.setCellValue("高尔夫");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.OTHER){// 其他
						cc = row.createCell(1);
						cc.setCellValue("其他");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.CONTRACTAGREEMENT){// 合同协议
						cc = row.createCell(1);
						cc.setCellValue("合同协议");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.SUPPLIERCOMMENT){// 商家评论
						cc = row.createCell(1);
						cc.setCellValue("商家评论");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.INSURANCE){// 保险
						cc = row.createCell(1);
						cc.setCellValue("保险");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.LOCALTRAVEL){// 地接社
						cc = row.createCell(1);
						cc.setCellValue("地接社");
						cc.setCellStyle(styleLeft);
					}else if(type == Constants.OTHERINCOME){// 其他收入
						cc = row.createCell(1);
						cc.setCellValue("其他收入");
						cc.setCellStyle(styleLeft);
					}else {// 其他支出
						cc = row.createCell(1);
						cc.setCellValue("其他支出");
						cc.setCellStyle(styleLeft);
					}

					cc = row.createCell(2);
					cc.setCellValue((String)items.get("supplier_name"));//商家
					cc.setCellStyle(styleLeft);

					cc = row.createCell(3);
					cc.setCellValue(sdf.format(items.get("booking_date")));//日期
					cc.setCellStyle(styleLeft);

					String _total = df.format(items.get("total"));
					if("".equals(_total)){
						cc = row.createCell(4);
						cc.setCellValue(0);//成本/金额
						cc.setCellStyle(styleLeft);
					}else {
						cc = row.createCell(4);
						cc.setCellValue(_total);//成本/金额
						cc.setCellStyle(styleLeft);
					}

					if(items.get("total_cash") == null){
						cc = row.createCell(5);
						cc.setCellValue(0);//已收
						cc.setCellStyle(cellStyle);
					}else{
						String t_totalCash = df.format(items.get("total_cash"));
						if("".equals(t_totalCash)){
							cc = row.createCell(5);
							cc.setCellValue(0);//已收
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(5);
							cc.setCellValue(t_totalCash);//已收
							cc.setCellStyle(cellStyle);
						}
					}

					String b_balance = df.format(items.get("balance"));
					if("".equals(b_balance)){
						cc = row.createCell(6);
						cc.setCellValue(0);//未收
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(6);
						cc.setCellValue(b_balance);//未收
						cc.setCellStyle(cellStyle);
					}
					index ++;
				}
				//加合计行
				index=0;
				BigDecimal sumSupplierTotal = new BigDecimal(0);
				BigDecimal sumSupplierTotalCost = new BigDecimal(0);
				BigDecimal sumSupplierBalance = new BigDecimal(0);
				for(int i=0; i<supplierList.size(); i++) {
					Map<String,Object> sumSupplier = supplierList.get(i);

					if(sumSupplier.get("total") == null){
						sumSupplierTotal = new BigDecimal(0);
					}else{
						String total = df.format(sumSupplier.get("total"));
						if(!"".equals(total)){
							sumSupplierTotal = sumSupplierTotal.add((BigDecimal)sumSupplier.get("total"));
						}else {
							sumSupplierTotal = new BigDecimal(0);
						}
					}
					if(sumSupplier.get("total_cash") == null){
						sumSupplierTotalCost = new BigDecimal(0);
					}else{
						String totalCash = df.format(sumSupplier.get("total_cash"));
						if(!"".equals(totalCash)){
							sumSupplierTotalCost = sumSupplierTotalCost.add((BigDecimal)sumSupplier.get("total_cash"));
						}else {
							sumSupplierTotalCost = new BigDecimal(0);
						}
					}

					if(sumSupplier.get("balance") == null){
						sumSupplierBalance = new BigDecimal(0);
					}else{
						String balance = df.format(sumSupplier.get("balance"));
						if(!"".equals(balance)){
							sumSupplierBalance = sumSupplierBalance.add((BigDecimal)sumSupplier.get("balance"));
						}else {
							sumSupplierBalance = new BigDecimal(0);
						}
					}
				}
				if(otherIncomeList.size() == 0 && deliveryList.size() >0){
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+supplierList.size()+17);
				}else if (otherIncomeList .size() > 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+otherIncomeList.size()+supplierList.size()+17);
				}else if (otherIncomeList.size() == 0 && deliveryList.size() ==0) {
					row = sheet.createRow(index +orderList.size()+supplierList.size()+12);
				}else{
					row = sheet.createRow(index +orderList.size()+deliveryList.size()+otherIncomeList.size()+supplierList.size()+21);
				}
				cc = row.createCell(0);
				cc.setCellStyle(styleRight);

				cc = row.createCell(1);
				cc.setCellStyle(styleRight);

				cc = row.createCell(2);
				cc.setCellStyle(styleRight);

				cc = row.createCell(3);
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(4);
				cc.setCellValue(df.format(sumSupplierTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(5);
				cc.setCellValue(df.format(sumSupplierTotalCost));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(6);
				cc.setCellValue(df.format(sumSupplierBalance));
				cc.setCellStyle(cellStyle);
			}

			*//*CellRangeAddress region = new CellRangeAddress(supplierList.size() + 5,
					supplierList.size() + 5, 0, 10);
			sheet.addMergedRegion(region);

			row = sheet.createRow(supplierList.size() + 5);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));*//*
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("结算单详情.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path,fileName,request,response);

	}*/



}


