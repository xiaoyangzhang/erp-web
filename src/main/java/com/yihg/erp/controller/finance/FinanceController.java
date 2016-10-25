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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.basic.api.CommonService;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.util.NumberUtil;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.finance.api.FinanceBillService;
import com.yihg.finance.api.FinanceGuideService;
import com.yihg.finance.api.FinanceService;
import com.yihg.finance.po.FinanceGuide;
import com.yihg.finance.po.FinancePay;
import com.yihg.finance.po.FinancePayDetail;
import com.yihg.finance.po.InfoBean;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingDeliveryPriceService;
import com.yihg.operation.api.BookingDeliveryService;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingShopDetailService;
import com.yihg.operation.api.BookingShopService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.operation.po.BookingDelivery;
import com.yihg.operation.po.BookingDeliveryPrice;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingShop;
import com.yihg.operation.po.BookingShopDetail;
import com.yihg.operation.po.BookingSupplier;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.sales.api.GroupOrderPriceService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.FinanceBillDetail;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.SupplierGuideService;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.constants.SupplierConstant;
import com.yihg.supplier.po.SupplierGuide;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.api.SysBizBankAccountService;
import com.yihg.sys.po.SysBizBankAccount;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;

/**
 * 财务管理
 * 
 * @author Jing.Zhuo
 * @create 2015年7月28日 上午10:55:42
 */
@Controller
@RequestMapping(value = "/finance")
public class FinanceController extends BaseController {

	@Autowired
	private FinanceService financeService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private SysBizBankAccountService sysBizBankAccountService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private GroupOrderService groupOrderService;
	@Autowired
	private BookingShopService bookingShopService;
	@Autowired
	private BookingSupplierService bookingSupplierService;
	@Autowired
	private BookingSupplierDetailService bookingSupplierDetailService;
	@Autowired
	private BookingDeliveryService bookingDeliveryService;
	@Autowired
	private GroupOrderPriceService groupOrderPriceService;
	@Autowired
	private FinanceBillService financeBillService;
	@Autowired
	private ApplicationContext appContext;
	@Autowired
	private BookingGuideService bookingGuideService;
	@Autowired
	private SupplierGuideService supplierGuideService;
	@Autowired
	private FinanceGuideService financeGuideService;

	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private PlatformOrgService orgService;

	@Autowired
	private BookingDeliveryPriceService bookingDeliveryPriceService;
	@Autowired
	private BookingShopDetailService bookingShopDetailService;
	@Resource
	private BizSettingCommon bizSettingCommon;
	
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
	public String calcTourGroupAmount(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId){
		if(groupId != null){
			financeService.calcTourGroupAmount(groupId);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("msg", "calculate over!");
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
		PageBean pb = new PageBean();
		Map pm = WebUtils.getRequestParamters(request);
		if(bizId != null){
			pm.put("bizId", bizId);
		}
		pb.setParameter(pm);
		List<TourGroup> results = tourGroupService.selectIdList(pb);
		
		if(results != null && results.size() > 0){
			TourGroup group = null;
			for(int i = 0; i < results.size(); i++){
				group = results.get(i);
				financeService.calcTourGroupAmount(group.getId());
			}
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("msg", "calculate over! fixed "+ results.size() +" tour groups");
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
		financeService.calcBookingSupplierTotalCash(bookingSupplierId);
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		
		map.put("success", "true");
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("msg", "calculate over!");
		
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
		List<BookingSupplier> results = bookingSupplierService.selectIdList();
		
		if(results != null && results.size() > 0){
			BookingSupplier bookingSupplier = null;
			for(int i = 0; i < results.size(); i++){
				bookingSupplier = results.get(i);
				financeService.calcBookingSupplierTotalCash(bookingSupplier.getId());
				
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
		financeService.calcGroupOrderTotalCash(groupOrderId);
		String endDate = DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		
		map.put("success", "true");
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("msg", "calculate over!");
		
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
		List<GroupOrder> results = groupOrderService.selectIdList(supplierId);
		
		if(results != null && results.size() > 0){
			GroupOrder order = null;
			for(int i = 0; i < results.size(); i++){
				order = results.get(i);
				financeService.calcGroupOrderTotalCash(order.getId());
				
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
		if(groupId != null){
			financeService.calcTotalCash_collection(groupId);
		}
        time = System.currentTimeMillis() - time;  
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", "true");
		map.put("msg", "completed!");
		map.put("result", "groupId="+groupId.toString()+", process times="+Long.toString(time)+" ms");
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
		List<TourGroup> results = tourGroupService.selectGroupByDateZone(startTime, endTime, bizId);
		
		if(results != null && results.size() > 0){
			TourGroup tg = null;
			for(int i = 0; i < results.size(); i++){
				tg = results.get(i);
				financeService.calcTotalCash_collection(tg.getId());
				
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
	public String inrecord(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("sup_type_map_in",
				SupplierConstant.supplierTypeMapIn);
		model.addAttribute("sup_type_map_pay",
				SupplierConstant.supplierTypeMapPay);
		return "finance/record/income-list";
	}

	/**
	 * 跳转到付款明细页面
	 */
	@RequestMapping(value = "payrecord.htm")
	public String payrecord(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("sup_type_map_pay",
				SupplierConstant.supplierTypeMapPay);
		return "finance/record/pay-list";
	}

	/**
	 * 跳转到结算单页面
	 */
	@RequestMapping(value = "settleList.htm")
	public String settleList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = tourGroupService.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "finance/settle-list";
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
	public String statementCheckPreview(HttpServletRequest request,HttpServletResponse response,ModelMap model,TourGroupVO group,String sl,String svc){
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		PageBean pb = new PageBean();
		pb.setPage(1);
		pb.setPageSize(100000);
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
		
		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
				item.put("userName", bookingGuides.get(j).getUserName());
			}
			guideMap.put(groupId, s.toString());
			
			BigDecimal totalIncome = NumberUtil.parseObj2Num(item.get("total_income"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item.get("total_cost"));
			
			//团收入 = 团收入 - 购物汇总
			InfoBean shop = financeService.statsShopWithCommInfoBean(groupId);
			totalIncome = totalIncome.subtract(shop.getNum());
			
			item.put("total_income", totalIncome);
			item.put("total_cost", totalCost);
			item.put("total_profit", totalIncome.subtract(totalCost));

		}
		model.addAttribute("guideMap", guideMap);
		return "finance/statementCheckPreview";
		
	}
	@RequestMapping("statementCheckExportExcel.htm")
	public void statementCheckExportExcel(HttpServletRequest request,HttpServletResponse response,TourGroupVO group,String sl,String svc){
		PageBean pb = new PageBean();
		pb.setPage(1);
		pb.setPageSize(100000);
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
		
		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
				//item.put("userName", bookingGuides.get(j).getUserName());
				s.append("（"+bookingGuides.get(j).getUserName()+"）");
			}
			guideMap.put(groupId, s.toString());
			
			BigDecimal totalIncome = NumberUtil.parseObj2Num(item.get("total_income"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item.get("total_cost"));
			
			//团收入 = 团收入 - 购物汇总
			InfoBean shop = financeService.statsShopWithCommInfoBean(groupId);
			totalIncome = totalIncome.subtract(shop.getNum());
			
			item.put("total_income", totalIncome);
			item.put("total_cost", totalCost);
			item.put("total_profit", totalIncome.subtract(totalCost));

		}
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
		List<TourGroup> auditorList = tourGroupService.getAuditorList();
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("auditorList", auditorList);
		return "finance/seal/settle-list";
	}
	
	@RequestMapping(value = "settleSealList.do")
	public String settleSealList(HttpServletRequest request,
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
		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			
			List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
			}
			guideMap.put(groupId, s.toString());
			
			BigDecimal totalIncome = NumberUtil.parseObj2Num(item.get("total_income"));
			BigDecimal totalIncomeShop = NumberUtil.parseObj2Num(item.get("total_income_shop"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item.get("total_cost"));
			
			//团收入 = 团收入 - 购物收入
			totalIncome = totalIncome.subtract(totalIncomeShop);
			
			item.put("total_income", totalIncome);
			item.put("total_profit", totalIncome.subtract(totalCost));

		}
		model.addAttribute("guideMap", guideMap);
		model.addAttribute("pageBean", pb);
		return rp;
	}


	/**
	 * 跳转到收款记录详情页面
	 */
	@RequestMapping(value = "incomeView.htm")
	public String incomeView(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		handResponse(request, model);
		model.addAttribute("pay", financeService.queryPayById(payId));
		return "finance/cash/income-view";
	}

	/**
	 * 跳转到付款记录详情页面
	 */
	@RequestMapping(value = "payView.htm")
	public String payView(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		model.addAttribute("pay", financeService.queryPayById(payId));
		return "finance/cash/pay-view";
	}

	/**
	 * 跳转到收款订单关联页面
	 */
	@RequestMapping(value = "incomeJoinList.htm")
	public String incomeJoinList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("saleOperatorIds", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.selectIncomeJoinTableListPage(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		
		return "finance/cash/income-join-list-table";
	}

	/**
	 * 跳转到付款订单关联页面
	 */
	@RequestMapping(value = "payJoinList.htm")
	public String payJoinList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("start_min", DateUtils.getMonthFirstDay());
		model.addAttribute("start_max", DateUtils.getMonthLastDay());
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		
		return "finance/cash/pay-join-list";
	}

	/**
	 * 跳转到收款新增页面
	 */
	@RequestMapping(value = "incomeAdd.htm")
	public String incomeAdd(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		handResponse(request, model);
		if (payId != null) {
			model.addAttribute("pay", financeService.queryPayById(payId));
		}else{
			model.addAttribute("currDate", new Date());
		}
		return "finance/cash/income-add";
	}

	/**
	 * 跳转到付款新增页面
	 */
	@RequestMapping(value = "payAdd.htm")
	public String payAdd(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer payId) {
		handResponse(request, model);
		if (payId != null) {
			model.addAttribute("pay", financeService.queryPayById(payId));
		}else{
			model.addAttribute("currDate", new Date());
		}
		return "finance/cash/pay-add";
	}

	/**
	 * 跳转收款记录页面
	 */
	@RequestMapping(value = "incomeRecordList.htm")
	public String incomeRecordList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		handResponse(request, model);
		return "finance/cash/income-list";
	}

	/**
	 * 跳转付款记录页面
	 */
	@RequestMapping(value = "payRecordList.htm")
	public String cashRecordList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		handResponse(request, model);
		return "finance/cash/pay-list";
	}

	/**
	 * 跳转到收款审核
	 */
	@RequestMapping(value = "auditList.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String auditList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		model.addAttribute("group",
				tourGroupService.selectByPrimaryKey(groupId));
		return "finance/audit-list";
	}

	/**
	 * 跳转到审核汇总页面
	 */
	@RequestMapping(value = "auditGroup.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String auditGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAllAttributes(financeService.queryAuditViewInfo(groupId, bizId));
		return "finance/audit-group";
	}
	
	/**
	 * 跳转到审核汇总页面
	 */
	@RequestMapping(value = "auditGroupList.htm")
	@RequiresPermissions(PermissionConstants.CWGL_JSDSH)
	public String auditGroupList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAllAttributes(financeService.queryAuditViewInfo(groupId, bizId));
		return "finance/audit-group-list";
	}
	
	/**
	 * 跳转到审核汇总打印页面
	 */
	@RequestMapping(value = "auditGroupListPrint.htm")
	public String auditGroupListPrint(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAllAttributes(financeService.queryAuditViewInfo(groupId, bizId));
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/audit-group-list-print";
	}

	/**
	 * 跳转到审核查询页面
	 */
	@RequestMapping(value = "aduditStatisticsList.htm")
	public String aduditStatisticsList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = tourGroupService.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "finance/aduditStatisticsList-list";
	}
	
	@RequestMapping(value = "aduditStatisticsList.do")
	public String aduditStatisticsList(HttpServletRequest request,
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
	public String getAuditUserList(HttpServletRequest request,
			HttpServletResponse reponse, String name)
			throws UnsupportedEncodingException {
		List<Map<String, String>> list = tourGroupService.getAuditUserList(
				WebUtils.getCurBizId(request),
				java.net.URLDecoder.decode(name, "UTF-8"));
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
		List<TourGroup> operateLogs = financeService.getOperateLogs(groupId);
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
		//处理审核
		financeService.audit(groupId, feeType, checkedIds, unCheckedIds,comCheckedIds, 
				comUnCheckedIds, emp.getEmployeeId(),emp.getName());
		
		if(StringUtils.isNotEmpty(financeGuides)){
			//处理导游报账
			List<FinanceGuide> list = JSONArray.parseArray(financeGuides, FinanceGuide.class);
			financeGuideService.financeBatchSave(list);
			
			//修改订单结算方式
			FinanceGuide fg = null;
			for(int i = 0; i < list.size(); i++){
				fg = list.get(i);
				BookingSupplier supplier = new BookingSupplier();
				supplier.setId(fg.getBookingIdLink());
				supplier.setCashType(fg.getCashType());
				bookingSupplierService.updateByPrimaryKeySelective(supplier);
			}
		}
		
		//审核订单价格
		groupOrderPriceService.auditPriceByIds(priceCheckedIds, priceUnCheckedIds);
		
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
		//处理审核
		financeService.audit(data, emp.getEmployeeId(), emp.getName());
		
		if(StringUtils.isNotEmpty(financeGuides)){
			
			//处理导游报账
			List<FinanceGuide> list = JSONArray.parseArray(financeGuides, FinanceGuide.class);
			financeGuideService.financeBatchSave(list);
			
			//修改订单结算方式
			FinanceGuide fg = null;
			for(int i = 0; i < list.size(); i++){
				fg = list.get(i);
				BookingSupplier supplier = new BookingSupplier();
				supplier.setId(fg.getBookingIdLink());
				supplier.setCashType(fg.getCashType());
				bookingSupplierService.updateByPrimaryKeySelective(supplier);
			}
		}
		return null;
	}

	/**
	 * 结算单审核
	 */
	@RequestMapping(value = "finAudit.do")
	@ResponseBody
	@PostHandler
	public String finAudit(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer groupId) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		financeService.audit(groupId, emp.getEmployeeId(), emp.getName());
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
		financeService.unAudit(groupId, emp.getName());
		return null;
	}

	/**
	 * 批量封存
	 */
	@RequestMapping(value = "batchSeal.do")
	@ResponseBody
	@PostHandler
	public String batchSeal(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String groupIds) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		financeService.batchSeal(groupIds, emp.getEmployeeId(), emp.getName());
		return null;
	}

	/**
	 * 解封
	 */
	@RequestMapping(value = "unseal.do")
	@ResponseBody
	@PostHandler
	public String unseal(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String groupId) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		financeService.unseal(groupId, emp.getEmployeeId(), emp.getName());
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
	public String pay(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, FinancePay pay) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		pay.setUserId(emp.getEmployeeId());
		pay.setUserName(emp.getName());
		pay.setBizId(WebUtils.getCurBizId(request));
		
//		以下几句获得收付款当前商家的类别，因为其它收入，其它支出是共用一个商家类别，代码里面求各是需要判断用到 ou
		SupplierInfo sInfo = supplierService.selectBySupplierId(pay.getSupplierId());
		int SupplierType = pay.getSupplierType();
		if (sInfo != null)
			SupplierType = sInfo.getSupplierType();
		
		FinancePay rt = financeService.pay(pay,	JSON.parseArray(pay.getDetails(), FinancePayDetail.class), SupplierType);
		return String.valueOf(rt.getId());
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
		map.put("accountList", supplierService.selectBankBySupplierId(sid));
		return JSON.toJSONString(map);
	}

	private void handResponse(HttpServletRequest request, ModelMap model) {
		List<DicInfo> payTypeList = dicService
				.getListByTypeCode(BasicConstants.CW_ZFFS);
		model.addAttribute("payTypeList", payTypeList);
		Integer biz_id = WebUtils.getCurBizId(request);
		List<SysBizBankAccount> bizAccountList = sysBizBankAccountService
				.getListByBizId(biz_id);
		model.addAttribute("bizAccountList", bizAccountList);
		model.addAttribute("supplierTypeMapIn",
				SupplierConstant.supplierTypeMapIn);
		model.addAttribute("supplierTypeMapPay",
				SupplierConstant.supplierTypeMapPay);
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

		// 旅行团信息
		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);

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
		List<GroupOrder> orderList = groupOrderService
				.selectOrderByGroupId(groupId);
		// 购物店收入
		List<BookingShop> shoppingList = bookingShopService
				.getShopListByGroupId(groupId);
		// 其他收入
		List<BookingSupplier> otherList = bookingSupplierService
				.getBookingSupplierByGroupIdAndSupplierType(groupId,
						com.yihg.supplier.constants.Constants.OTHERINCOME);
		// 地接社支出
		List<BookingDelivery> deliveryList = bookingDeliveryService
				.getDeliveryListByGroupId(groupId);
		// 供应商支出
		List<BookingSupplier> paymentList = bookingSupplierService
				.selectByPrimaryGroupId(groupId);

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
			List<GroupOrderPrice> priceList = groupOrderPriceService
					.selectByOrder(order.getId());
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

			List<BookingSupplierDetail> detailList = bookingSupplierDetailService
					.selectByPrimaryBookId(bookingSupplier.getId());
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
			map.put(type, SupplierConstant.supplierTypeMap.get(supplierService
					.selectBySupplierId(delivery.getSupplierId())
					.getSupplierType()));
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
					com.yihg.sales.constants.Constants.OTHER)) {
				continue;
			}
			Map<String, String> map = new HashMap<String, String>();
			map.put(type, SupplierConstant.supplierTypeMap.get(supplierService
					.selectBySupplierId(bookingSupplier.getSupplierId())
					.getSupplierType()));
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
			List<BookingSupplierDetail> detailList = bookingSupplierDetailService
					.selectByPrimaryBookId(bookingSupplier.getId());
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
	public String receiveOrderList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, TourGroup group,
			Integer page) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
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
	public String receiveOrderListSelect(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("saleOperatorIds", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeBillService.selectreceiveOrderListSelectPage(
				pageBean, WebUtils.getCurBizId(request), "finance", WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageBean", pageBean);

		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = dicService.getListByTypeCode(
				BasicConstants.LD_DJLX, bizId);
		model.addAttribute("billTypeList", billTypeList);
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
	public String fuzzyApplicantList(HttpServletRequest request,
			HttpServletResponse reponse, String name)
			throws UnsupportedEncodingException {
		List<Map<String, String>> list = financeBillService
				.getFuzzyApplicantList(WebUtils.getCurBizId(request),
						java.net.URLDecoder.decode(name, "UTF-8"));
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
	public String diatributeBill(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String id,
			String guideId, String groupCode) {
		List<FinanceBillDetail> financeBillDetailList = financeBillService
				.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), id,
						guideId);
		if (null != financeBillDetailList && financeBillDetailList.size() > 0) {
			Map financeBillDetail = (Map) financeBillDetailList.get(0);
			model.put("guideName", financeBillDetail.get("guide_name"));
			model.put("applicant", financeBillDetail.get("applicant"));
			model.put("appliTime", financeBillDetail.get("appli_time"));
			model.put("financeBillDetailList", financeBillDetailList);
		}
		model.put("nowDate", new Date());

		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = dicService.getListByTypeCode(
				BasicConstants.LD_DJLX, bizId);
		model.addAttribute("billTypeList", billTypeList);

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
			HttpServletResponse response, ModelMap model, String id,
			String guideId, String groupCode) {
		List<FinanceBillDetail> financeBillDetailList = financeBillService
				.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), id,
						guideId);
		if (null != financeBillDetailList && financeBillDetailList.size() > 0) {
			Map financeBillDetail = (Map) financeBillDetailList.get(0);
			model.put("guideName", financeBillDetail.get("guide_name"));
			model.put("applicant", financeBillDetail.get("applicant"));
			model.put("appliTime", financeBillDetail.get("appli_time"));
			model.put("apprTime", financeBillDetail.get("appr_time"));
			model.put("financeBillDetailList", financeBillDetailList);
		}
		model.put("nowDate", new Date());

		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = dicService.getListByTypeCode(
				BasicConstants.LD_DJLX, bizId);
		model.addAttribute("billTypeList", billTypeList);
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
		List<FinanceBillDetail> financeBillDetailList = financeBillService
				.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), id,
						guideId);
		if (null != financeBillDetailList && financeBillDetailList.size() > 0) {
			Map financeBillDetail = (Map) financeBillDetailList.get(0);
			model.put("guideName", financeBillDetail.get("guide_name"));
			model.put("applicant", financeBillDetail.get("applicant"));
			model.put("appliTime", financeBillDetail.get("appli_time"));
			model.put("apprTime", financeBillDetail.get("appr_time"));
			model.put("veriTime", financeBillDetail.get("veri_time"));
			model.put("appliState", appliState);
			model.put("financeBillDetailList", financeBillDetailList);
		}
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = dicService.getListByTypeCode(
				BasicConstants.LD_DJLX, bizId);
		model.addAttribute("billTypeList", billTypeList);
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
		List<FinanceBillDetail> financeBillDetailList = financeBillService
				.getbillListByIdAndGuideId(WebUtils.getCurBizId(request), id,
						guideId);
		if (null != financeBillDetailList && financeBillDetailList.size() > 0) {
			Map financeBillDetail = (Map) financeBillDetailList.get(0);
			model.put("guideName", financeBillDetail.get("guide_name"));
			model.put("applicant", financeBillDetail.get("applicant"));
			model.put("appliTime", financeBillDetail.get("appli_time"));
			model.put("apprTime", financeBillDetail.get("appr_time"));
			model.put("veriTime", financeBillDetail.get("veri_time"));
			model.put("appliState", appliState);
			model.put("financeBillDetailList", financeBillDetailList);
		}
		TourGroup tour = tourGroupService.selectByPrimaryKey(Integer.parseInt(id));
		model.addAttribute("tour", tour);
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = dicService.getListByTypeCode(
				BasicConstants.LD_DJLX, bizId);
		model.addAttribute("billTypeList", billTypeList);
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
		financeBillService.saveDistributeBill(billList);
		financeBillService.updateFinanceOrder(WebUtils.getCurUser(request)
				.getLoginName(), new Integer(groupId), new Integer(guideId),
				new Date(), type);
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
		financeBillService.saveVerifyBill(billList);
		financeBillService.updateFinanceOrder(WebUtils.getCurUser(request)
				.getLoginName(), new Integer(groupId), new Integer(guideId),
				new Date(), type);
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
		financeBillService.delVerify(order_id,type);
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
		financeBillService.delReceived(group_id,guide_id);
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
	public String getUserNameList(HttpServletRequest request,
			HttpServletResponse reponse, String name)
			throws UnsupportedEncodingException {
		List<Map<String, String>> list = financeBillService.getUserNameList(
				WebUtils.getCurBizId(request),
				java.net.URLDecoder.decode(name, "UTF-8"));
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
		
		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
				item.put("userName", bookingGuides.get(j).getUserName());
			}
			guideMap.put(groupId, s.toString());
			
			BigDecimal totalIncome = NumberUtil.parseObj2Num(item.get("total_income"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item.get("total_cost"));
			
			//团收入 = 团收入 - 购物汇总
			InfoBean shop = financeService.statsShopWithCommInfoBean(groupId);
			totalIncome = totalIncome.subtract(shop.getNum());
			
			item.put("total_income", totalIncome);
			item.put("total_profit", totalIncome.subtract(totalCost));

		}
		model.addAttribute("guideMap", guideMap);

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map pm = (Map) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}
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
		
		String feeType = request.getParameter("feeType");
		Map<String, Object> pm = WebUtils.getQueryParamters(request);
		List<Map<String, Object>> list = getCommonService(svc).queryList(sl, pm);
		Integer bizId = WebUtils.getCurBizId(request);
		if(list != null && list.size() > 0 ){
			
			for(Map<String, Object> item : list){
				Integer bookingId = Integer.parseInt(item.get("id").toString());
				String details = "";
				if("order".equals(feeType)){
					boolean isShow = pm.get("isShow") != null ? Boolean.parseBoolean(pm.get("isShow").toString()) : false;
					List<GroupOrderPrice> priceList = groupOrderPriceService.selectByOrderAndType(bookingId, 0);
					details = groupOrderPriceService.concatDetailTable(priceList, isShow,edit);
				}else if("shop".equals(feeType)){
					List<BookingShopDetail> detailList = bookingShopDetailService.getShopDetailListByBookingId(bookingId);
					details = bookingShopDetailService.concatDetailTable(detailList);
				}else if("del".equals(feeType)){
					List<BookingDeliveryPrice> priceList = bookingDeliveryPriceService.getPriceListByBookingId(bookingId);
					details = bookingDeliveryPriceService.concatDetailTable(priceList);
				}else if("sup".equals(feeType) || "otherin".equals(feeType)){
					Integer supType = Integer.parseInt(request.getParameter("supType"));
					String remark = item.get("remark") != null ? item.get("remark").toString() : "";
					List<BookingSupplierDetail> detailList = bookingSupplierDetailService.selectByPrimaryBookId(bookingId);
					details = bookingSupplierDetailService.concatDetailTable(supType, remark, detailList);
				}
				item.put("details", details);
			}
		}
		
		model.addAttribute("list", list);
		if("sup".equals(feeType) || "otherin".equals(feeType)){
			String groupId = request.getParameter("groupId");
			if(StringUtils.isNotEmpty(groupId)){
				List<BookingGuide> bookingGuides = bookingGuideService.selectGuidesByGroupId(Integer.parseInt(groupId));
				model.put("bookingGuides", bookingGuides);
			}
			
			//从字典中查询结算方式
			List<DicInfo> cashTypes = null;
			if("otherin".equals(feeType)){
				cashTypes = dicService.getListByTypeCode(BasicConstants.QTSR_JSFS,bizId);
			}else{
				cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS,bizId);
			}
			model.addAttribute("cashTypes", cashTypes);
		}
		
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
	 * 删除财务-收款付款
	 */
	@RequestMapping(value = "deleteFinancePay.do")
	@ResponseBody
	@PostHandler
	public String deleteFinancePay(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		try {
			financeService.deletePayById(id);
			return successJson("msg", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
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
		try {
			financeService.deletePayDetail(supplierType, locOrderId, payId);
			return successJson("msg", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
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
		
		try {
			String[] idArr = locOrderIds.split(",");
			for(int i = 0; i < idArr.length; i++){
				String locOrderId = idArr[i];
				if(StringUtils.isEmpty(locOrderId)){
					continue;
				}
				financeService.deletePayDetail(supplierType, Integer.parseInt(locOrderId), payId);
			}
			
			return successJson("msg", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
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
	public String shopVerifyList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
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
		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = bookingShopService.selectShopVerifyListPage(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		
		//合计
		Map<String,Object> map = bookingShopService.selectShopVerifySum(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("map", map);
		List<SupplierGuide> supplierGuides = supplierGuideService.getAllGuide();
		model.addAttribute("supplierGuides", supplierGuides);

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
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(10000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = bookingShopService.selectShopVerifyListPage(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		
		//合计
		Map<String,Object> map = bookingShopService.selectShopVerifySum(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("map", map);
		List<SupplierGuide> supplierGuides = supplierGuideService.getAllGuide();
		model.addAttribute("supplierGuides", supplierGuides);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));

		return "finance/shopVerify/shopVerifyList-print";
	}

	/**
	 * 批量审核购物店
	 */
	@RequestMapping(value = "auditShop.do")
	@ResponseBody
	public String auditShop(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String checkedIds,
			String unCheckedIds) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		financeService.auditShop(checkedIds, unCheckedIds, emp.getEmployeeId(),
				emp.getName());
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
	public String shopStatisticsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("projectTypeJsonStr", 
				dicService.getCommProjectTypeTreeJsonStr(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request)));
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
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
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("projectTypeJsonStr", 
				dicService.getCommProjectTypeTreeJsonStr(BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request)));
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "finance/commission/shopCommissionDeductionStats-list";
	}

	@RequestMapping("viewShopCommissionStatsList.htm")
	public String viewhopStatisticsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		
		//产品品牌下拉列表数据
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("projectTypeJsonStr", 
				dicService.getCommProjectTypeTreeJsonStr(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request)));
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "finance/commission/viewShopCommissionStats-list";
	}
	
	@RequestMapping("viewShopCommissionDeductionStatsList.htm")
	public String viewShopCommissionDeductionStatsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		//产品品牌下拉列表数据
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("projectTypeJsonStr", 
				dicService.getCommProjectTypeTreeJsonStr(BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request)));
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
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
		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeGuideService.getCommisionStatsListPage(pageBean);
		List<Map<String, Object>> data = pageBean.getResult();
		List<BookingGuide> guides = new ArrayList<BookingGuide>();
		if(data != null && data.size() > 0){
			for(int i = 0 ; i < data.size(); i++){
				BookingGuide guide = financeGuideService.parseDataToGuide(data.get(i), pageBean, false);
				guides.add(guide);
				
				SupplierGuide sg = supplierGuideService.getGuideInfoById(guide.getGuideId());
				if(sg != null){
					guide.setBankAccount(sg.getBankAccount());
				}
			}
		}
		pageBean.setResult(guides);
		model.addAttribute("pageBean", pageBean);

		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);
		
		//总合计
		Map<String, Object> sums = financeGuideService.getCommisionsSum(pageBean);
		model.addAttribute("sums", sums);

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
		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeGuideService.getCommisionDeductionStatsListPage(pageBean);
		List<Map<String, Object>> data = pageBean.getResult();
		List<BookingGuide> guides = new ArrayList<BookingGuide>();
		if(data != null && data.size() > 0){
			for(int i = 0 ; i < data.size(); i++){
				BookingGuide guide = financeGuideService.parseDataToGuide(data.get(i), pageBean, true);
				guides.add(guide);
				
				SupplierGuide sg = supplierGuideService.getGuideInfoById(guide.getGuideId());
				if(sg != null){
					guide.setBankAccount(sg.getBankAccount());
				}
			}
		}
		pageBean.setResult(guides);
		model.addAttribute("pageBean", pageBean);

		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);
		
		//总合计
		Map<String, Object> sums = financeGuideService.getCommisionsDeductionSum(pageBean);
		model.addAttribute("sums", sums);

		return "finance/commission/shopCommissionDeductionStats-table";
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/queryShopCommissionStats2.do")
	public String toShopStatisticsList2(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		PageBean pageBean = new PageBean();
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
		Map paramters = WebUtils.getQueryParamters(request);
		String carInfo = (String)WebUtils.getQueryParamters(request).get("carInfo");
		if (StringUtils.isNotBlank(carInfo)) {
			List<Integer> groupIds = bookingSupplierService.getGroupIdByCarInfo(carInfo);
			if (groupIds!=null && groupIds.size()>0) {
				String groupIdStr = groupIds.toString().substring(1,groupIds.toString().length()-1);
				paramters.put("groupIds", groupIdStr);
				//bookingDeliveryPrice.setGroupIds(groupIdStr);
			}else{
				paramters.put("groupIds", "9999999999");
			}
		}
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
		
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			paramters.put("operator_id", group.getSaleOperatorIds());
		}
		paramters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(paramters);
		pageBean = financeGuideService.getCommisionStatsListPage(pageBean);
		List<Map<String, Object>> data = pageBean.getResult();
		List<BookingGuide> guides = new ArrayList<BookingGuide>();
		if(data != null && data.size() > 0){
			for(int i = 0 ; i < data.size(); i++){
				BookingGuide guide = financeGuideService.parseDataToGuide(data.get(i), pageBean, false);
				guides.add(guide);
				
				SupplierGuide sg = supplierGuideService.getGuideInfoById(guide.getGuideId());
				if(sg != null){
					guide.setBankAccount(sg.getBankAccount());
				}
			}
		}
		
		pageBean.setResult(guides);
		model.addAttribute("pageBean", pageBean);
		
		//总合计
		Map<String, Object> sums = financeGuideService.getCommisionsSum(pageBean);
		model.addAttribute("sums", sums);
		
		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);

		return "finance/commission/viewShopCommissionStats-table";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/queryShopCommissionDeductionStats2.do")
	public String queryShopCommissionDeductionStats2(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		PageBean pageBean = new PageBean();
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
		Map paramters = WebUtils.getQueryParamters(request);
		String carInfo = (String)WebUtils.getQueryParamters(request).get("carInfo");
		if (StringUtils.isNotBlank(carInfo)) {
			List<Integer> groupIds = bookingSupplierService.getGroupIdByCarInfo(carInfo);
			if (groupIds!=null && groupIds.size()>0) {
				String groupIdStr = groupIds.toString().substring(1,groupIds.toString().length()-1);
				paramters.put("groupIds", groupIdStr);
				//bookingDeliveryPrice.setGroupIds(groupIdStr);
			}else{
				paramters.put("groupIds", "9999999999");
			}
		}
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
		
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			paramters.put("operator_id", group.getSaleOperatorIds());
		}
		paramters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(paramters);
		pageBean = financeGuideService.getCommisionDeductionStatsListPage(pageBean);
		List<Map<String, Object>> data = pageBean.getResult();
		List<BookingGuide> guides = new ArrayList<BookingGuide>();
		if(data != null && data.size() > 0){
			for(int i = 0 ; i < data.size(); i++){
				BookingGuide guide = financeGuideService.parseDataToGuide(data.get(i), pageBean, true);
				guides.add(guide);
				
				SupplierGuide sg = supplierGuideService.getGuideInfoById(guide.getGuideId());
				if(sg != null){
					guide.setBankAccount(sg.getBankAccount());
				}
			}
		}
		pageBean.setResult(guides);
		model.addAttribute("pageBean", pageBean);
		
		//总合计
		Map<String, Object> sums = financeGuideService.getCommisionsDeductionSum(pageBean);
		model.addAttribute("sums", sums);
		
		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);

		return "finance/commission/viewShopCommissionDeductionStats-table";
	}

	/**
	 * 批量审核购物发放佣金
	 */
	@RequestMapping(value = "auditComm.do")
	@ResponseBody
	public String auditComm(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String checkedIds,
			String unCheckedIds) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		financeService.auditComm(checkedIds, unCheckedIds, emp.getEmployeeId(),
				emp.getName());
		return null;
	}
	
	/**
	 * 批量审核购物扣除佣金
	 */
	@RequestMapping(value = "auditCommDeduction.do")
	@ResponseBody
	public String auditCommDeduction(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String checkedIds,
			String unCheckedIds) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		financeService.auditCommDeduction(checkedIds, unCheckedIds, emp.getEmployeeId(),
				emp.getName());
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

		List<DicInfo> payTypeList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JSFS);
		model.addAttribute("payTypeList", payTypeList);

		Integer biz_id = WebUtils.getCurBizId(request);
		List<SysBizBankAccount> bizAccountList = sysBizBankAccountService
				.getListByBizId(biz_id);
		model.addAttribute("bizAccountList", bizAccountList);

		List<DicInfo> bankList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_BANK);
		model.addAttribute("bankList", bankList);

		List<BookingGuide> guideList = bookingGuideService
				.selectDistinctListByGroupId(groupId);
		model.addAttribute("guideList", guideList);

		model.addAttribute("projectTypeJsonStr", 
				dicService.getCommProjectTypeTreeJsonStr(BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request)));
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
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

		List<DicInfo> payTypeList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JSFS);
		model.addAttribute("payTypeList", payTypeList);

		Integer biz_id = WebUtils.getCurBizId(request);
		List<SysBizBankAccount> bizAccountList = sysBizBankAccountService
				.getListByBizId(biz_id);
		model.addAttribute("bizAccountList", bizAccountList);

		List<DicInfo> bankList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_BANK);
		model.addAttribute("bankList", bankList);

		List<BookingGuide> guideList = bookingGuideService
				.selectDistinctListByGroupId(groupId);
		model.addAttribute("guideList", guideList);

		model.addAttribute("projectTypeJsonStr", 
				dicService.getCommProjectTypeTreeJsonStr(BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request)));
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
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
		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeGuideService.getCommisionStatsListPage(pageBean);
		List<Map<String, Object>> data = pageBean.getResult();
		List<BookingGuide> guides = new ArrayList<BookingGuide>();
		if(data != null && data.size() > 0){
			for(int i = 0 ; i < data.size(); i++){
				BookingGuide guide = financeGuideService.parseDataToGuide(data.get(i), pageBean, false);
				guides.add(guide);
				
				SupplierGuide sg = supplierGuideService.getGuideInfoById(guide.getGuideId());
				if(sg != null){
					guide.setBankAccount(sg.getBankAccount());
				}
			}
		}
		pageBean.setResult(guides);
		model.addAttribute("pageBean", pageBean);

		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);

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
		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeGuideService.getCommisionDeductionStatsListPage(pageBean);
		List<Map<String, Object>> data = pageBean.getResult();
		List<BookingGuide> guides = new ArrayList<BookingGuide>();
		if(data != null && data.size() > 0){
			for(int i = 0 ; i < data.size(); i++){
				BookingGuide guide = financeGuideService.parseDataToGuide(data.get(i), pageBean, true);
				guides.add(guide);
				
				SupplierGuide sg = supplierGuideService.getGuideInfoById(guide.getGuideId());
				if(sg != null){
					guide.setBankAccount(sg.getBankAccount());
				}
			}
		}
		pageBean.setResult(guides);
		model.addAttribute("pageBean", pageBean);

		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_KKXM, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);

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
	public String subjectSummary(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
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

		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.getsubjectSummaryListPage(pageBean);
		List<Map<String,Object>> lists = (List<Map<String,Object>>)pageBean.getResult();
		for (Map<String, Object> map : lists) {
			Map<String,Object> qdyj=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_QDYJ);
			map.put("qd_total_cash", qdyj==null?0:qdyj.get("total_cash"));
			map.put("qd_total", qdyj==null?0:qdyj.get("total"));
			
			Map<String,Object> dyxf=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_DYXF);
			map.put("dy_total_cash", dyxf==null?0:dyxf.get("total_cash"));
			map.put("dy_total", dyxf==null?0:dyxf.get("total"));
			
			Map<String,Object> gsxf=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXF);
			map.put("gs_total_cash", gsxf==null?0:gsxf.get("total_cash"));
			map.put("gs_total", gsxf==null?0:gsxf.get("total"));
			
			Map<String,Object> qt=financeService.getsubjectSummaryQT(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXF,Constants.SUMJECT_SUMMARY_QDYJ,Constants.SUMJECT_SUMMARY_DYXF);
			map.put("qt_total_cash", qt==null?0:qt.get("total_cash"));
			map.put("qt_total", qt==null?0:qt.get("total"));
			
			//Map<String,Object> dybz=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),null);

			
			BigDecimal dy_total=new BigDecimal(map.get("dy_total").toString());
			/**
			 * 导游报账只针对导游现付才有效
			 * 比如：订单金额车费8300，结算方式是：导游现付，导游报账5000，那么：结果就是：导游现付=5000，签单月结=3300
			 */
			BigDecimal qd_total=new BigDecimal(map.get("qd_total").toString());
			if(null != dyxf){
				BigDecimal dybz_total=new BigDecimal(dyxf.get("dybz_total").toString());
				qd_total = dy_total.subtract(dybz_total).add(qd_total);
				map.put("dy_total",dybz_total);
			}
			map.put("qd_total",qd_total);
		}
		model.addAttribute("pageBean", pageBean);

		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);

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
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		
		pageBean = financeService.getsubjectSummaryListPage(pageBean);
		List<Map<String,Object>> lists = (List<Map<String,Object>>)pageBean.getResult();
		for (Map<String, Object> map : lists) {
			Map<String,Object> qdyj=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_QDYJ);
			map.put("qd_total_cash", qdyj==null?0:qdyj.get("total_cash"));
			map.put("qd_total", qdyj==null?0:qdyj.get("total"));
			
			Map<String,Object> dyxf=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_DYXF);
			map.put("dy_total_cash", dyxf==null?0:dyxf.get("total_cash"));
			map.put("dy_total", dyxf==null?0:dyxf.get("total"));
			
			Map<String,Object> gsxf=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXF);
			map.put("gs_total_cash", gsxf==null?0:gsxf.get("total_cash"));
			map.put("gs_total", gsxf==null?0:gsxf.get("total"));
			
			Map<String,Object> qt=financeService.getsubjectSummaryQT(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXF,Constants.SUMJECT_SUMMARY_QDYJ,Constants.SUMJECT_SUMMARY_DYXF);
			map.put("qt_total_cash", qt==null?0:qt.get("total_cash"));
			map.put("qt_total", qt==null?0:qt.get("total"));
			
			//Map<String,Object> dybz=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),null);

			
			BigDecimal dy_total=new BigDecimal(map.get("dy_total").toString());
			/**
			 * 导游报账只针对导游现付才有效
			 * 比如：订单金额车费8300，结算方式是：导游现付，导游报账5000，那么：结果就是：导游现付=5000，签单月结=3300
			 */
			BigDecimal qd_total=new BigDecimal(map.get("qd_total").toString());
			if(null != dyxf){
				BigDecimal dybz_total=new BigDecimal(dyxf.get("dybz_total").toString());
				qd_total = dy_total.subtract(dybz_total).add(qd_total);
				map.put("dy_total",dybz_total);
			}
			map.put("qd_total",qd_total);
		}
		model.addAttribute("pageBean", pageBean);

		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/subjectSummary/subjectSummary-print";
	}
	
	
	@RequestMapping(value = "/sumjectSummaryExcl.do")
	@ResponseBody
	public void sumjectSummaryExcl(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.getsubjectSummaryListPage(pageBean);
		List<Map<String,Object>> lists = (List<Map<String,Object>>)pageBean.getResult();
		for (Map<String, Object> map : lists) {
			Map<String,Object> qdyj=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_QDYJ);
			map.put("qd_total_cash", qdyj==null?0:qdyj.get("total_cash"));
			map.put("qd_total", qdyj==null?0:qdyj.get("total"));
			
			Map<String,Object> dyxf=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_DYXF);
			map.put("dy_total_cash", dyxf==null?0:dyxf.get("total_cash"));
			map.put("dy_total", dyxf==null?0:dyxf.get("total"));
			
			Map<String,Object> gsxf=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXF);
			map.put("gs_total_cash", gsxf==null?0:gsxf.get("total_cash"));
			map.put("gs_total", gsxf==null?0:gsxf.get("total"));
			
			Map<String,Object> qt=financeService.getsubjectSummaryQT(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXF,Constants.SUMJECT_SUMMARY_QDYJ,Constants.SUMJECT_SUMMARY_DYXF);
			map.put("qt_total_cash", qt==null?0:qt.get("total_cash"));
			map.put("qt_total", qt==null?0:qt.get("total"));
			
			//Map<String,Object> dybz=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),null);

			
			BigDecimal dy_total=new BigDecimal(map.get("dy_total").toString());
			/**
			 * 导游报账只针对导游现付才有效
			 * 比如：订单金额车费8300，结算方式是：导游现付，导游报账5000，那么：结果就是：导游现付=5000，签单月结=3300
			 */
			BigDecimal qd_total=new BigDecimal(map.get("qd_total").toString());
			if(null != dyxf){
				BigDecimal dybz_total=new BigDecimal(dyxf.get("dybz_total").toString());
				qd_total = dy_total.subtract(dybz_total).add(qd_total);
				map.put("dy_total",dybz_total);
			}
			map.put("qd_total",qd_total);
		}
		
		List list = pageBean.getResult();
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
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
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

		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.getsubjectSummary2ListPage(pageBean,"");
		
		model.addAttribute("pageBean", pageBean);

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
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		
		pageBean = financeService.getsubjectSummary2ListPage(pageBean,"");
		model.addAttribute("pageBean", pageBean);

		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/subjectSummary/subjectSummary2-print";
	}
	
	@RequestMapping(value = "/sumjectSummary2Excl.do")
	@ResponseBody
	public void sumjectSummary2Excl(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.getsubjectSummary2ListPage(pageBean,"");
		//合计
		PageBean pageBean2 = new PageBean();
		List list = pageBean.getResult();
		
		pageBean2 = financeService.getsubjectSummary2ListPage(pageBean,"sum");
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
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
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

		PageBean pageBean = new PageBean();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.getsubjectSummaryListPage(pageBean);
		List<Map<String,Object>> lists = (List<Map<String,Object>>)pageBean.getResult();
		for (Map<String, Object> map : lists) {
			Map<String,Object> dyxs=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_DYXS);
			map.put("dy_total_cash", dyxs==null?0:dyxs.get("total_cash"));
			map.put("dy_total", dyxs==null?0:dyxs.get("total"));
			
			Map<String,Object> gsxs=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXS);
			map.put("gs_total_cash", gsxs==null?0:gsxs.get("total_cash"));
			map.put("gs_total", gsxs==null?0:gsxs.get("total"));
			
			Map<String,Object> qt=financeService.getsubjectSummaryQT(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXS,Constants.SUMJECT_SUMMARY_DYXS,null);
			map.put("qt_total_cash", qt==null?0:qt.get("total_cash"));
			map.put("qt_total", qt==null?0:qt.get("total"));
			
		}
		model.addAttribute("pageBean", pageBean);

		List<DicInfo> dicInfoList = dicService.getListByTypeCode(
				BasicConstants.YJ_XMLX, WebUtils.getCurBizId(request));
		model.addAttribute("dicInfoList", dicInfoList);

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
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		
		pageBean = financeService.getsubjectSummaryListPage(pageBean);
		List<Map<String,Object>> lists = (List<Map<String,Object>>)pageBean.getResult();
		for (Map<String, Object> map : lists) {
			Map<String,Object> dyxs=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_DYXS);
			map.put("dy_total_cash", dyxs==null?0:dyxs.get("total_cash"));
			map.put("dy_total", dyxs==null?0:dyxs.get("total"));
			
			Map<String,Object> gsxs=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXS);
			map.put("gs_total_cash", gsxs==null?0:gsxs.get("total_cash"));
			map.put("gs_total", gsxs==null?0:gsxs.get("total"));
			
			Map<String,Object> qt=financeService.getsubjectSummaryQT(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXS,Constants.SUMJECT_SUMMARY_DYXS,null);
			map.put("qt_total_cash", qt==null?0:qt.get("total_cash"));
			map.put("qt_total", qt==null?0:qt.get("total"));
			
		}
		model.addAttribute("pageBean", pageBean);

		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "finance/subjectSummary/subjectSummary3-print";
	}
	
	
	@RequestMapping(value = "/sumjectSummaryExcl3.do")
	@ResponseBody
	public void sumjectSummaryExcl3(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = financeService.getsubjectSummaryListPage(pageBean);
		List<Map<String,Object>> lists = (List<Map<String,Object>>)pageBean.getResult();
		for (Map<String, Object> map : lists) {
			Map<String,Object> dyxs=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_DYXS);
			map.put("dy_total_cash", dyxs==null?0:dyxs.get("total_cash"));
			map.put("dy_total", dyxs==null?0:dyxs.get("total"));
			
			Map<String,Object> gsxs=financeService.getsubjectSummaryQDYJ(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXS);
			map.put("gs_total_cash", gsxs==null?0:gsxs.get("total_cash"));
			map.put("gs_total", gsxs==null?0:gsxs.get("total"));
			
			Map<String,Object> qt=financeService.getsubjectSummaryQT(pageBean,Integer.parseInt(map.get("supplier_id").toString()),Constants.SUMJECT_SUMMARY_GSXS,Constants.SUMJECT_SUMMARY_DYXS,null);
			map.put("qt_total_cash", qt==null?0:qt.get("total_cash"));
			map.put("qt_total", qt==null?0:qt.get("total"));
			
		}
		
		List list = pageBean.getResult();
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
}
