package com.yihg.erp.controller.tj;

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
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.util.NumberUtil;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceGuideService;
import com.yihg.images.util.DateUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.ContractService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierContractPriceDateInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.tj.api.TJService;
import com.yihg.tj.po.TJGroupQueryId;
import com.yihg.tj.po.TJGroupShop;
import com.yihg.tj.po.TJRecord;
import com.yihg.tj.po.TJShopProject;
/**
 * 财务统计
 * @author wj
 *
 */
@Controller
@RequestMapping(value = "/tj")
public class TJController extends BaseController{
	@Autowired
	private TJService tjService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private TourGroupService tourGroupService;
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private ContractService contractService;
	@Autowired
	private FinanceGuideService financeGuideService;
	
	@Autowired
	private DicService dicService;
	
	DecimalFormat df = new DecimalFormat("0.##");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	/**
	 * 统计购物项目
	 * @throws IOException 
	 */
	@RequestMapping(value = "tjShopProject.do")
	@ResponseBody
	@PostHandler
	public String tjShopProject(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,Integer type) throws IOException {
		reponse.setContentType("text/html;charset=utf-8");
		PrintWriter out = reponse.getWriter();
		out.write("正在归档");
		out.flush();
		
		Long a = System.currentTimeMillis();
		if(type==0){
			tjService.clearTjShopProject();
		}
		PageBean pb = new PageBean();
		pb.setPageSize(10000);
		int currPage = 1;
		do{
			pb.setPage(currPage);
			Date startDate = tjService.selectRecordEndTime(BasicConstants.TJ_SHOP_PROJECT, WebUtils.getCurBizId(request));
			String start=null;
			//此处把起始时间设为null，全量更新
			if(null!=startDate){
				start = sdf.format(com.yihg.erp.utils.DateUtils.getDateAgoByHour(startDate, 1));
			}
			//查询需要统计表的数据
			if(type==0){
				pb = tjService.tjShopProject(pb,null);
			}else{
				pb = tjService.tjShopProject(pb,start);
			}
			List<TJShopProject> list =  pb.getResult();
			if(list == null || list.size() == 0){
				continue;
			}
			
			int i=0;
			for(TJShopProject tjShopProject : list){
				tjShopProject.setOperatorCompanyId(this.getCompanyIdByOperatorId(tjShopProject.getOperatorId()));
				List<TJShopProject> tj=tjService.selectTJShopProjecectByDetailId(tjShopProject.getGroupId(),tjShopProject.getBookingId(),tjShopProject.getDetailId());
				if(tj.size()<=0){
					tjService.insertTjShopProject(tjShopProject);
				}else{
					tjShopProject.setId(tj.get(0).getId());
					tjService.updateTjShopProject(tjShopProject);
				}
				if (i%100==0){
					out.write(".");
					out.flush();
				}
				i++;
			}
			currPage++;
		}while(currPage <= pb.getTotalPage());
		
		//添加归档记录
		insertArchiveRecord(request, a, BasicConstants.TJ_SHOP_PROJECT);
		
		out.write("<br/>归档完成，请刷新页面重新查询！");
		out.flush();
		out.close();
		
		return null;
	}
	
	/**
	 * 购物项目统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toShopProjectList.htm")
	public String toShopProjectList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		
		//产品品牌下拉选择数据
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		
		this.setArchiveTime(request, model, BasicConstants.TJ_SHOP_PROJECT);
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "tj/tjShopProjectList";
	}
	
	@RequestMapping(value = "/selectShopProjectList.do")
	public String selectShopProjectList(HttpServletRequest request,
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
		pageBean = tjService.selectShopProjectListPage(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		Map<String,Object> map = tjService.selectCount(pageBean,WebUtils.getCurBizId(request));
		Map<String,Object> mapDetail = tjService.selectDetailCount(pageBean,WebUtils.getCurBizId(request));
		Integer bizId = WebUtils.getCurBizId(request);		
		List<SupplierContractPriceDateInfo> priceList = contractService.getMultiOperatePriceByParams(bizId, BasicConstants.TJ_PROJECT_SHOP_BOOKING_SUPPLIER_TYPE,null, null,null, null,null, null);
		model.addAttribute("priceList", priceList);
		if(null!=map){
			model.addAttribute("all_total_person", map.get("all_total_person"));
			model.addAttribute("all_total_face", map.get("all_total_face"));
		}
		if(null!=mapDetail){
			model.addAttribute("all_buy_total", mapDetail.get("all_buy_total"));
			model.addAttribute("all_repay_total", mapDetail.get("all_repay_total"));
		}
		

		return "tj/tjShopProjectList-table";
	}
	
	@RequestMapping("archiveAllGroupShop.do")
	public void archiveAllGroupProfit(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException, InterruptedException{
		model.addAttribute("archiveType", "All");
		this.initGroupShopTable(request, response, model);
	}
	@RequestMapping("archiveIncrementalGroupShop.do")
	public void archiveIncrementalGroupProfit(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException, InterruptedException{
		model.addAttribute("archiveType", "Incremental");
		this.initGroupShopTable(request, response, model);
	}
	
	/**
	 * 统计单团购物数据
	 * @throws IOException 
	 */
	@RequestMapping(value = "initGroupShopTable.do")
	@PostHandler
	public void initGroupShopTable(HttpServletRequest request,HttpServletResponse response, ModelMap model) throws IOException {
		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.write("正在归档");
		out.flush();
		
		Long startTime = System.currentTimeMillis();
		
		List<TJGroupQueryId> groupIdList = new ArrayList<TJGroupQueryId>();
		if (model.get("archiveType").equals("Incremental")){
			groupIdList = tjService.findUpdatedGroupIdList("tj_group_shop");
		}else if (model.get("archiveType").equals("All")){
			groupIdList = tjService.findAllGroupIdList();
		}
		
		if (groupIdList.size() > 0){
			tjService.clearUpdatedGroupShop(groupIdList);
		}
		
		for(int i=0; i<groupIdList.size(); i++){
			Integer groupId = groupIdList.get(i).getGroupId();
			List<TJGroupShop> groupShopList = tjService.selectTJGroupShop(groupId);
			if(groupShopList == null || groupShopList.size() == 0){
				continue;
			}
			for(TJGroupShop groupShop : groupShopList){
				
				if (groupShop==null){
					continue;
				}
				if (groupShop.getGroupState()!=null && groupShop.getGroupState()!=1 && groupShop.getGroupState()!=3 && groupShop.getGroupState()!=4){
					continue;
				}
				
				BigDecimal sumCommTotal = financeGuideService.selectCommTotalByGroupId(groupShop.getGroupId());
				groupShop.setTotalComm(sumCommTotal);
				
				//取得组团社信息
				Set<String> orderSupplierNameList = new HashSet<String>();
				List<GroupOrder> orderList = tourGroupService.selectOrderAndGuestInfoByGroupId(groupShop.getGroupId());
				if(orderList != null && orderList.size() > 0){
					for(GroupOrder order: orderList){
						orderSupplierNameList.add(order.getSupplierName());
					}
				}
				
				groupShop.setOrderSupplierNames(StringUtils.join(orderSupplierNameList, ","));
				
				//取得公司ID
				groupShop.setOperatorCompanyId(this.getCompanyIdByOperatorId(groupShop.getOperatorId()));
				
				tjService.insertTJGroupShop(groupShop);
			}
			
			if (i%10==0){
				out.write(".");
				out.flush();
			}
		}
		
		//添加归档记录
		insertArchiveRecord(request, startTime, BasicConstants.TJ_GROUP_SHOP);
		
		out.write("<br/>归档完成!");
		out.flush();
		out.close();
	}
	
	/**
	 * 单团购物统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toGroupShopList.htm")
	public String toGroupShopList(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		this.setArchiveTime(request, model, BasicConstants.TJ_GROUP_SHOP);
		return "tj/tjGroupShopList";
	}
	
	@RequestMapping(value = "/selectTJGroupShopList.do")
	public String selectTJGroupShopList(HttpServletRequest request, ModelMap model, Integer pageSize, Integer page,TourGroupVO groupVO) {
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
		if(StringUtils.isBlank(groupVO.getSaleOperatorIds()) && StringUtils.isNotBlank(groupVO.getOrgIds())){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupVO.getOrgIds().split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				groupVO.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=groupVO.getSaleOperatorIds() && !"".equals(groupVO.getSaleOperatorIds())){
			pm.put("operator_id", groupVO.getSaleOperatorIds());
		}
		Set set = WebUtils.getDataUserIdSet(request);
		pm.put("set", WebUtils.getDataUserIdSet(request));
		
		
		pageBean.setParameter(pm);
		pageBean = tjService.selectTJGroupListPage(pageBean);
		List<Map<String, Object>> groups = pageBean.getResult();
		if(groups != null){
			Map<String, Object> group = null;
			for(int i = 0; i < groups.size(); i++){
				group = groups.get(i);
				Integer groupId = group.get("group_id") != null ? Integer.parseInt(group.get("group_id").toString()) : 0;
				pm.put("groupId", groupId);
				List<Map<String, Object>> shops = tjService.selectTJShopOfGroup(pm);
				group.put("shops", shops);
			}
		}
		
		model.addAttribute("pageBean", pageBean);
		
		Map<String, Object> totalMap = tjService.selectTJGroupShopTotal(pageBean);
		model.addAttribute("totalMap", totalMap);
		
		Map<String, Object> totalCommMap = tjService.selectTJGroupShopCommTotal(pageBean);
		model.addAttribute("totalCommMap", totalCommMap);

		return "tj/tjGroupShopList-table";
	}
	
	/**
	 * 跳转到单团购物统计打印页面
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toGroupShopListPrint.htm")
	public String toGroupShopListPrint(HttpServletRequest request, ModelMap model,TourGroupVO groupVO) {
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
		//如果人员为空并且部门不为空，则取部门下的人id
		if(StringUtils.isBlank(groupVO.getSaleOperatorIds()) && StringUtils.isNotBlank(groupVO.getOrgIds())){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupVO.getOrgIds().split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				groupVO.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=groupVO.getSaleOperatorIds() && !"".equals(groupVO.getSaleOperatorIds())){
			pm.put("operator_id", groupVO.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		pageBean = tjService.selectTJGroupListPage(pageBean);
		List<Map<String, Object>> groups = pageBean.getResult();
		if(groups != null){
			Map<String, Object> group = null;
			for(int i = 0; i < groups.size(); i++){
				group = groups.get(i);
				Integer groupId = group.get("group_id") != null ? Integer.parseInt(group.get("group_id").toString()) : 0;
				pm.put("groupId", groupId);
				List<Map<String, Object>> shops = tjService.selectTJShopOfGroup(pm);
				group.put("shops", shops);
			}
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" <br/>打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "tj/tjGroupShopList-print";
	}
	
	/**
	 * 导出单团购物统计Excel表
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("exportGroupShopListExcel.do")
	public void exportGroupShopListExcel(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		try {
			
			PageBean pageBean = new PageBean();
			pageBean.setPage(1);
			pageBean.setPageSize(1000000);
			Map<String,Object> pm  = WebUtils.getQueryParamters(request);
			pageBean.setParameter(pm);
			pageBean = tjService.selectTJGroupListPage(pageBean);
			List<Map<String, Object>> groups = pageBean.getResult();
			
			String url = request.getSession().getServletContext().getRealPath("/template/excel/group_shop.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
//	        CellStyle cellStyle = wb.createCellStyle();
//	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
//	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
//	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
//	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
//	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
			Sheet sheet = wb.getSheetAt(0) ; //获取到第一个sheet
			
			BigDecimal allTotalPerson = new BigDecimal(0);
			BigDecimal allTotalFact = new BigDecimal(0);
			BigDecimal allTotalRepay = new BigDecimal(0);
			BigDecimal allTotalComm = new BigDecimal(0);
			
			DecimalFormat df = new DecimalFormat("0.##");
			if(groups != null && groups.size() > 0){
				
				Row row = null;
				Cell cell = null ;
				Map<String,Object> group = null;
				int currRowIndex = 1;
				for(int i = 0; i < groups.size(); i++){
					
					group = groups.get(i);
					
					currRowIndex = currRowIndex + 1;
					
					List<Map<String, Object>> shops = null;
					if(group != null){
						Integer groupId = group.get("group_id") != null ? Integer.parseInt(group.get("group_id").toString()) : 0;
						pm.put("groupId", groupId);
						shops = tjService.selectTJShopOfGroup(pm);
					}
					
					int mergeRowCount = shops != null && shops.size() > 0 ? shops.size() - 1 : 0;
					
					//从第三行开始，前两行分别为标题和列名
					row = sheet.createRow(currRowIndex);
					//第1列：序号
					CellRangeAddress mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 0, 0);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(0);
					cell.setCellValue(i + 1);
//					cell.setCellStyle(cellStyle);
					
					//第2列：团号
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 1, 1);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(1);
					cell.setCellValue(group.get("group_code") != null ? group.get("group_code").toString() : "");
//					cell.setCellStyle(cellStyle);
					
					//第3列：产品
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 2, 2);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(2);
					String product_brand_name = group.get("product_brand_name") != null ? group.get("product_brand_name").toString() : "";
					String product_name = group.get("product_name") != null ? group.get("product_name").toString() : "";
					cell.setCellValue("【"+product_brand_name + "】" + product_name);
//					cell.setCellStyle(cellStyle);
					
					//第4列：客源地
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 3, 3);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(3);
					cell.setCellValue(group.get("province_name") != null ? group.get("province_name").toString() : "");
//					cell.setCellStyle(cellStyle);
					
					//第5列：客源等级
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 4, 4);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(4);
					cell.setCellValue(group.get("source_type_name") != null ? group.get("source_type_name").toString() : "");
//					cell.setCellStyle(cellStyle);
					
					//第6列：团期
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 5, 5);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(5);
					String dateStart = group.get("date_start") != null ? group.get("date_start").toString() : "";
					cell.setCellValue(dateStart );
//					cell.setCellStyle(cellStyle);
					
					//第7列：计调
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 6, 6);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(6);
					cell.setCellValue(group.get("operator_name") != null ? group.get("operator_name").toString() : "");
//					cell.setCellStyle(cellStyle);
					
					//第8列：人数
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 7, 7);
				    sheet.addMergedRegion(mergedRegion); 
					cell = row.createCell(7);
					String total_adult = group.get("total_adult") != null ? group.get("total_adult").toString() : "";
					String total_child = group.get("total_child") != null ? group.get("total_child").toString() : "";
					cell.setCellValue(total_adult + "大" + total_child+"小");
//					cell.setCellStyle(cellStyle);
					
					//第17列：其他佣金
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 16, 16);
				    sheet.addMergedRegion(mergedRegion); 
					BigDecimal totalComm = group.get("total_comm") != null ? new BigDecimal(group.get("total_comm").toString()) : new BigDecimal(0);
					cell = row.createCell(16);
					cell.setCellValue(df.format(totalComm));
//					cell.setCellStyle(cellStyle);
					allTotalComm = allTotalComm.add(totalComm);
					
					//第18列：购物利润
					mergedRegion=new CellRangeAddress(currRowIndex, currRowIndex+mergeRowCount, 17, 17);
				    sheet.addMergedRegion(mergedRegion); 
					BigDecimal shopProfit = group.get("shop_profit") != null ? new BigDecimal(group.get("shop_profit").toString()) : new BigDecimal(0);
					cell = row.createCell(17);
					cell.setCellValue(df.format(shopProfit));
//					cell.setCellStyle(cellStyle);
					
					if(shops != null && shops.size() > 0){
						Row detailRow = row;
						Map<String,Object> shop = null;
						for(int j = 0; j < shops.size(); j++){
							
							if(j > 0){
								currRowIndex = currRowIndex + 1;
								detailRow = sheet.createRow(currRowIndex);
							}
							
							shop = shops.get(j);
							
							//第9列：购物店 
							cell = detailRow.createCell(8);
							cell.setCellValue(shop.get("shop_supplier_name") != null ? shop.get("shop_supplier_name").toString() : "");
//							cell.setCellStyle(cellStyle);
							
							//第10列：进店人数 
							BigDecimal personNum = shop.get("person_num") != null ? new BigDecimal(shop.get("person_num").toString()) : new BigDecimal(0);
							cell = detailRow.createCell(9);
							cell.setCellValue(shop.get("person_num") != null ? shop.get("person_num").toString() : "");
//							cell.setCellStyle(cellStyle);
							
							//第11列：进店日期
							cell = detailRow.createCell(10);
							cell.setCellValue(shop.get("shop_date") != null ? shop.get("shop_date").toString() : "");
//							cell.setCellStyle(cellStyle);
							
							//第12列：导游
							cell = detailRow.createCell(11);
							cell.setCellValue(shop.get("guide_name") != null ? shop.get("guide_name").toString() : "");
//							cell.setCellStyle(cellStyle);
							
							//第13列：导管
							cell = detailRow.createCell(12);
							cell.setCellValue(shop.get("guide_manage_name") != null ? shop.get("guide_manage_name").toString() : "");
//							cell.setCellStyle(cellStyle);
							
							//第14列：购物金额
							BigDecimal totalFact = shop.get("total_fact") != null ? new BigDecimal(shop.get("total_fact").toString()) : new BigDecimal(0);
							cell = detailRow.createCell(13);
							cell.setCellValue(df.format(totalFact));
//							cell.setCellStyle(cellStyle);
							
							//第15列：人均购物
							BigDecimal personBuyAvg = shop.get("person_buy_avg") != null ? new BigDecimal(shop.get("person_buy_avg").toString()) : new BigDecimal(0);
							cell = detailRow.createCell(14);
							cell.setCellValue(df.format(personBuyAvg));
//							cell.setCellStyle(cellStyle);
							
							//第16列：购物返款
							BigDecimal totalRepay = shop.get("total_repay") != null ? new BigDecimal(shop.get("total_repay").toString()) : new BigDecimal(0);
							cell = detailRow.createCell(15);
							cell.setCellValue(df.format(totalRepay));
//							cell.setCellStyle(cellStyle);
							
							allTotalPerson = allTotalPerson.add(personNum);
							allTotalFact = allTotalFact.add(totalFact);
							allTotalRepay = allTotalRepay.add(totalRepay);
						}
					}
				}
				
				CellRangeAddress mergedRegion=new CellRangeAddress(currRowIndex+1, currRowIndex+1, 0, 8);
			    sheet.addMergedRegion(mergedRegion); 
				
				//合计
			    CellStyle cellStyle = wb.createCellStyle();
			    cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
			    
			    row = sheet.createRow(currRowIndex+1);
				cell = row.createCell(0);
				cell.setCellValue("合计：");
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(9);
				cell.setCellValue(df.format(allTotalFact));
				
				cell = row.createCell(10);
				/*if(allTotalPerson.compareTo(BigDecimal.ZERO)==0){
					cell.setCellValue(0);
				}else{
					cell.setCellValue(df.format(allTotalFact.divide(allTotalPerson, 2, BigDecimal.ROUND_HALF_UP)));
				}*/
				cell.setCellValue("");
				
				cell = row.createCell(11);
				cell.setCellValue(df.format(allTotalRepay));
				
				cell = row.createCell(12);
				cell.setCellValue(df.format(allTotalComm));
				
				cell = row.createCell(13);
				cell.setCellValue(df.format(allTotalRepay.subtract(allTotalComm)));
			}
		
			String path=request.getSession().getServletContext().getRealPath("/")+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
	    	out.close();
	    	wb.close();
	    	download(path, response, "group_shop.xlsx");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 按购物店统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toShopList.htm")
	public String toShopList(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		
		//产品品牌下拉选择数据
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		this.setArchiveTime(request, model, BasicConstants.TJ_GROUP_SHOP);
		return "tj/tjShopList";
	}
	
	@RequestMapping(value = "/selectShopList.do")
	public String selectShopList(HttpServletRequest request, ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
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
		pageBean = tjService.selectTJShopListPage(pageBean);
		model.addAttribute("pageBean", pageBean);
		
		Map<String, Object> totalMap = tjService.selectTJShopTotal(pageBean);
		model.addAttribute("totalMap", totalMap);
		return "tj/tjShopList-table";
	}
	
	/**
	 * 跳转到购物店统计打印页面
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toShopListPrint.htm")
	public String toShopListPrint(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
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
		pageBean = tjService.selectTJShopListPage(pageBean);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("pageBean", pageBean);
		
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" <br/>打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "tj/tjShopList-print";
	}
	
	/**
	 * 导出购物店Excel表
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("exportShopListExcel.do")
	public void exportShopListExcel(HttpServletRequest request, HttpServletResponse response, ModelMap model, TourGroupVO group) {
		try {
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
			pageBean = tjService.selectTJShopListPage(pageBean);
			List<Map<String, Object>> results = pageBean.getResult();
		
			String url = request.getSession().getServletContext().getRealPath("/template/excel/shop.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
	        CellStyle cellStyle = wb.createCellStyle();
	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
			Sheet sheet = wb.getSheetAt(0) ; //获取到第一个sheet
			
			if(results != null && results.size() > 0){
				BigDecimal allPersonNum = new BigDecimal(0);
				BigDecimal allTotalFact = new BigDecimal(0);
				BigDecimal allTotalRepay = new BigDecimal(0);
				BigDecimal allTotalCash = new BigDecimal(0);
				
				Row row = null;
				Cell cell = null ;
				Map<String,Object> shop = null;
				for(int i = 0; i < results.size(); i++){
					
					shop = results.get(i);
					//从第三行开始，前两行分别为标题和列明
					row = sheet.createRow(i+2);
					//第一列：序号
					cell = row.createCell(0);
					cell.setCellValue(i+1);
					cell.setCellStyle(cellStyle);
					
					//第二列：购物店
					cell = row.createCell(1);
					cell.setCellValue(shop.get("shop_supplier_name") != null ? shop.get("shop_supplier_name").toString() : "");
					cell.setCellStyle(cellStyle);
					
					//第三列：人数
					BigDecimal personNum = shop.get("person_num") != null ? new BigDecimal(shop.get("person_num").toString()) : new BigDecimal(0);
					cell = row.createCell(2);
					cell.setCellValue(personNum.intValue());
					cell.setCellStyle(cellStyle);
					
					//第四列：购物金额
					BigDecimal totalFact = shop.get("total_fact") != null ? new BigDecimal(shop.get("total_fact").toString()) : new BigDecimal(0);
					cell = row.createCell(3);
					cell.setCellValue(df.format(totalFact));
					cell.setCellStyle(cellStyle);
					
					//第五列：人均购物
					BigDecimal personBuyAvg = shop.get("person_buy_avg") != null ? new BigDecimal(shop.get("person_buy_avg").toString()) : new BigDecimal(0);
					cell = row.createCell(4);
					cell.setCellValue(df.format(personBuyAvg));
					cell.setCellStyle(cellStyle);
					
					//第六列：购物返款
					BigDecimal totalRepay = shop.get("total_repay") != null ? new BigDecimal(shop.get("total_repay").toString()) : new BigDecimal(0);
					cell = row.createCell(5);
					cell.setCellValue(df.format(totalRepay));
					cell.setCellStyle(cellStyle);
					
					//第七列：应收合计
					cell = row.createCell(6);
					cell.setCellValue(df.format(totalRepay));
					cell.setCellStyle(cellStyle);
					
					//第八列：已收
					BigDecimal totalCash = shop.get("total_cash") != null ? new BigDecimal(shop.get("total_cash").toString()) : new BigDecimal(0);
					cell = row.createCell(7);
					cell.setCellValue(df.format(totalCash));
					cell.setCellStyle(cellStyle);
					
					//第九列：欠收
					cell = row.createCell(8);
					cell.setCellValue(df.format(totalRepay.subtract(totalCash)));
					cell.setCellStyle(cellStyle);
					
					allPersonNum = allPersonNum.add(personNum);
					allTotalFact = allTotalFact.add(totalFact);
					allTotalRepay = allTotalRepay.add(totalRepay);
					allTotalCash = allTotalCash.add(totalCash);
				}
				
				CellRangeAddress region_supplier_name=new CellRangeAddress(results.size()+2, results.size()+2, 0, 1);
			    sheet.addMergedRegion(region_supplier_name); 
				
				//合计
				row = sheet.createRow(results.size()+2);
				cell = row.createCell(0);
				cell.setCellValue("合计：");
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(1);
				cell.setCellValue("");
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(2);
				cell.setCellValue(allPersonNum.intValue());
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(3);
				cell.setCellValue(df.format(allTotalFact));
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(4);
				if(allPersonNum.compareTo(BigDecimal.ZERO)==0){
					cell.setCellValue(0);
				}else{
					cell.setCellValue(df.format(allTotalFact.divide(allPersonNum, 2, BigDecimal.ROUND_HALF_UP)));
				}
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(5);
				cell.setCellValue(df.format(allTotalRepay));
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(6);
				cell.setCellValue(df.format(allTotalRepay));
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(7);
				cell.setCellValue(df.format(allTotalCash));
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(8);
				cell.setCellValue(df.format(allTotalRepay.subtract(allTotalCash)));
				cell.setCellStyle(cellStyle);
			}
		
			String path=request.getSession().getServletContext().getRealPath("/")+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
	    	out.close();
	    	wb.close();
	    	download(path, response, "shop.xlsx");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	/**
	 * 购物项目统计打印页面
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("shopProjectPrint.htm")
	public String shopProjectPrint(HttpServletRequest request,
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
		
		pageBean = tjService.selectShopProjectListPage(pageBean,WebUtils.getCurBizId(request));
		
		Map<String,Object> map = tjService.selectCount(pageBean,WebUtils.getCurBizId(request));
		Map<String,Object> mapDetail = tjService.selectDetailCount(pageBean,WebUtils.getCurBizId(request));
		if(null!=map){
			model.addAttribute("all_total_person", map.get("all_total_person"));
			model.addAttribute("all_total_face", map.get("all_total_face"));
		}
		if(null!=mapDetail){
			model.addAttribute("all_buy_total", mapDetail.get("all_buy_total"));
			model.addAttribute("all_repay_total", mapDetail.get("all_repay_total"));
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "tj/tjShopProjectList-print";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private ArrayList<Integer> qyList;
	private ArrayList<Integer> zyList;
	private ArrayList<Integer> yyList;
	private ArrayList<Integer> sxList;
	private Integer getCompanyIdByOperatorId(Integer operatorId){
		if(this.qyList==null){
			/**
			 * 昆明群游旅行社有限公司   1-3- id=3
			 * 昆明众益旅行社有限公司   1-4- id=4
			 * 昆明逸游旅行社有限公司   1-5- id=5
			 * 昆明顺行旅行社有限公司   1-6- id=6
			 */
			String qy = platformEmployeeService.findByOrgPath("1-3-") ;
			String zy = platformEmployeeService.findByOrgPath("1-4-") ;
			String yy = platformEmployeeService.findByOrgPath("1-5-") ;
			String sx = platformEmployeeService.findByOrgPath("1-6-") ;
			
			this.qyList = new ArrayList<Integer>();
			this.zyList = new ArrayList<Integer>();
			this.yyList = new ArrayList<Integer>();
			this.sxList = new ArrayList<Integer>();
			for(String tmpId : qy.split(",")){
				if (!tmpId.equals("")){this.qyList.add(Integer.parseInt(tmpId));}
			}
			for(String tmpId : zy.split(",")){
				if (!tmpId.equals("")){this.zyList.add(Integer.parseInt(tmpId));}
			}
			for(String tmpId : yy.split(",")){
				if (!tmpId.equals("")){this.yyList.add(Integer.parseInt(tmpId));}
			}
			for(String tmpId : sx.split(",")){
				if (!tmpId.equals("")){this.sxList.add(Integer.parseInt(tmpId));}
			}
		}
		if (this.qyList.contains(operatorId)){
			return 3;
		}else if (this.zyList.contains(operatorId)){
			return 4;
		}else if (this.yyList.contains(operatorId)){
			return 5;
		}else if (this.sxList.contains(operatorId)){
			return 6;
		}else {
			return 0;
		}
	}
	
	/**
	 * 取得最新归档时间，放到Model里
	 * @param request
	 * @param model
	 */
	private void setArchiveTime(HttpServletRequest request, ModelMap model, String type){
		Date recordEndTime = tjService.selectRecordEndTime(type, WebUtils.getCurBizId(request));
		model.addAttribute("recordEndTime", DateUtils.format(recordEndTime, DateUtils.FORMAT_LONG));
	}
	
	/**
	 * 添加归档记录
	 * @param request
	 * @param startTime
	 */
	private void insertArchiveRecord(HttpServletRequest request, Long startTime, String type){
		Long endTime = System.currentTimeMillis();
		//根据类型查询此表上一次统计的结束时间作为本次统计的开始时间
		Date startDate = tjService.selectRecordEndTime(type, WebUtils.getCurBizId(request));
		TJRecord tjRecord = new TJRecord();
		tjRecord.setBizId(WebUtils.getCurBizId(request));
		tjRecord.setType(type);
		tjRecord.setStartTime(startDate);
		tjRecord.setEndTime(new Date());
		//耗时  秒
		Long taketime = (endTime-startTime)/1000;
		tjRecord.setTakeTime(taketime.intValue());
		//插入记录
		tjService.insetTJRecord(tjRecord);
	}
	
	
	
	@RequestMapping(value = "/getProjects.do")
	@ResponseBody
	public void getProjects(HttpServletRequest request,HttpServletResponse response,TourGroupVO group){
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
		pageBean = tjService.selectShopProjectListPage(pageBean,WebUtils.getCurBizId(request));
		List list = pageBean.getResult();
		Map<String,Object> map = tjService.selectCount(pageBean,WebUtils.getCurBizId(request));
		Map<String,Object> mapDetail = tjService.selectDetailCount(pageBean,WebUtils.getCurBizId(request));
		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/shopProject.xlsx");
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
		    	//购物店
		    	Map<String,Object> order = it.next() ;
		       //获取购物店下的购物项目列表
		       List<Map<String,Object>> projects = (List<Map<String, Object>>) order.get("bookingShopDetailList");
		       Iterator<Map<String,Object>> it2 = projects.iterator();
		       
		       //合并列（购物店）
		       CellRangeAddress region_supplier_name=new CellRangeAddress(index+2, index+1+projects.size(), 1, 1);
		       sheet.addMergedRegion(region_supplier_name); 
		       //合并列（进店总人数）
		       CellRangeAddress region_total_person=new CellRangeAddress(index+2, index+1+projects.size(), 2, 2);
		       sheet.addMergedRegion(region_total_person); 
		       //合并列（总额）
		       CellRangeAddress region_total_money=new CellRangeAddress(index+2, index+1+projects.size(), 3, 3);
		       sheet.addMergedRegion(region_total_money); 
		       while (it2.hasNext()){ 
		    	   Map<String,Object> project = it2.next();
			       //从第三行开始，前两行分别为标题和列明
			       row = sheet.createRow(index+2);
			       //第一列：序号
			       cc = row.createCell(0);
			       cc.setCellValue(index+1);
			       cc.setCellStyle(cellStyle);
			       
			       //第二列：购物店
			       cc = row.createCell(1);
			       cc.setCellValue(order.get("supplier_name")==null?"":order.get("supplier_name").toString());
			       cc.setCellStyle(cellStyle);
			       
			       //第三列：进店总人数
			       cc = row.createCell(2);
			       BigDecimal total_person = order.get("total_person")!=null?new BigDecimal(order.get("total_person").toString()):new BigDecimal(0);
			       cc.setCellValue(total_person.intValue());
			       cc.setCellStyle(styleLeft);
			       
			       //第四列：总额
			       cc = row.createCell(3);
			       BigDecimal total_face = order.get("total_face") != null ? new BigDecimal(order.get("total_face").toString()) : new BigDecimal(0);
			       cc.setCellValue(df.format(total_face));
			       cc.setCellStyle(styleLeft);
			       
			       //第五列：购物项目	       
			       cc = row.createCell(4);
			       cc.setCellValue(project.get("goods_name")!=null?project.get("goods_name").toString():"");
			       cc.setCellStyle(styleLeft);
			       //第六列：返款比例 
			       cc = row.createCell(5);
			       String[] array;
			       StringBuffer str =new StringBuffer();
			       String repay_val = project.get("repay_val")!=null?project.get("repay_val").toString():"";
			       if(!"".equals(repay_val)){
			    	   array = repay_val.split(",");
			    	   for (int i=0;i<array.length;i++) {
			    		   str.append(NumberUtil.formatDouble(new BigDecimal(array[i]))+"% ");
			    		   if(i<array.length-1){
			    			   str.append("\r\n");
			    		   }
			    	   }
			       }
			       
//			       if(null==project.get("buy_total")||null==project.get("repay_total")){
//			    	   cc.setCellValue("0");
//			       }else if(new BigDecimal(project.get("buy_total").toString()).compareTo(new BigDecimal(0))==0){
//			    	   cc.setCellValue("0");
//			       }else{
//			    	   BigDecimal a =new BigDecimal(project.get("repay_total").toString());
//			    	   BigDecimal b =new BigDecimal(project.get("buy_total").toString());
//			    	   BigDecimal a1 =a.multiply(new BigDecimal(100));
//			    	   double d = a1.divide(b,4).setScale(4,BigDecimal.ROUND_HALF_UP).doubleValue();
//			    	   cc.setCellValue(df.format(d)+"%");
//			       }
			       cc.setCellValue(str.toString());
			       cc.setCellStyle(cellStyle);
			       //第七列：购物金额
			       cc = row.createCell(6);
			       BigDecimal buy_total = project.get("buy_total") != null ? new BigDecimal(project.get("buy_total").toString()) : new BigDecimal(0);
			       cc.setCellValue(df.format(buy_total));
			       cc.setCellStyle(cellStyle);
			       //第八列：返款
			       cc = row.createCell(7);
			       BigDecimal repay_total = project.get("repay_total") != null ? new BigDecimal(project.get("repay_total").toString()) : new BigDecimal(0);
			       cc.setCellValue(df.format(repay_total));
			       cc.setCellStyle(cellStyle);
			       
			       index++; 
		       }
		       
		    }
		    BigDecimal all_total_person=new BigDecimal(0);
		    BigDecimal all_total_face=new BigDecimal(0);
		    BigDecimal all_buy_total=new BigDecimal(0);
		    BigDecimal all_repay_total=new BigDecimal(0);
			if(null!=map){
				if(null!=map.get("all_total_person")){
					all_total_person = new BigDecimal(map.get("all_total_person").toString());
				}
				if(null!=map.get("all_total_face")){
					all_total_face = new BigDecimal(map.get("all_total_face").toString());
				}
			}
			if(null!=mapDetail){
				if(null!=mapDetail.get("all_buy_total")){
					all_buy_total = new BigDecimal(mapDetail.get("all_buy_total").toString());
				}
				if(null!=mapDetail.get("all_repay_total")){
					all_repay_total = new BigDecimal(mapDetail.get("all_repay_total").toString());
				}
			}
		    row = sheet.createRow(index+2); //加合计行
		    cc = row.createCell(0);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(1);
		    cc.setCellValue("合计："); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(2);
		    cc.setCellValue(all_total_person.toString()); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(3);
		    cc.setCellValue(df.format(all_total_face)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(4);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(5);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(6);
		    cc.setCellValue(df.format(all_buy_total)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(7);
		    cc.setCellValue(df.format(all_repay_total)); 
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
		download(path, response,"tjShopProject.xlsx");
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
	
}
