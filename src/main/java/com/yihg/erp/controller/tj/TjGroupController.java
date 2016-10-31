package com.yihg.erp.controller.tj;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.controller.airticket.ResourceController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sales.client.tj.po.TJGroupProfit;
import com.yimayhd.erpcenter.facade.tj.client.query.TjSearchDTO;
import com.yimayhd.erpcenter.facade.tj.client.result.SelectLineProfitListResult;
import com.yimayhd.erpcenter.facade.tj.client.result.SelectShopProjectListResult;
import com.yimayhd.erpcenter.facade.tj.client.result.TJGroupProfitResult;
import com.yimayhd.erpcenter.facade.tj.client.result.TjSearchResult;
import com.yimayhd.erpcenter.facade.tj.client.result.ToGroupListResult;
import com.yimayhd.erpcenter.facade.tj.client.service.TJFacade;
import com.yimayhd.erpcenter.facade.tj.client.service.TjGroupFacade;
/**
 * 财务统计
 * @author wj
 *
 */
@Controller
@RequestMapping(value = "/tjGroup")
public class TjGroupController {
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private TjGroupFacade tjGroupFacade;
	@Autowired
	private TJFacade tjFacade;
	
	private static final Logger log = LoggerFactory.getLogger(ResourceController.class);
	
	private DecimalFormat df = new DecimalFormat("0.##");
	SimpleDateFormat dt = new SimpleDateFormat("MM-dd");
	
	@RequestMapping("list.htm")
	public String list(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,TourGroupVO group){
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		Integer bizId = WebUtils.getCurBizId(request);
		tjSearchDTO.setBizId(bizId);
		tjSearchDTO.setGroup(group);
		
		String page = request.getParameter("p");
		String pageSize = request.getParameter("ps");
		tjSearchDTO.setPage(page==null?0:Integer.parseInt(page));
		tjSearchDTO.setPageSize(pageSize==null?0:Integer.parseInt(pageSize));
		tjSearchDTO.setPm( WebUtils.getQueryParamters(request));
		tjSearchDTO.setDataUserIdString(WebUtils.getDataUserIdString(request));
		tjSearchDTO.setDateFrom(request.getParameter("dateFrom"));
		tjSearchDTO.setDateTo(request.getParameter("dateTo"));
		ToGroupListResult result = tjGroupFacade.list(tjSearchDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", result.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		
//		setArchiveTime(request, model, BasicConstants.TJ_GROUP_PROFIT);
		
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("pageTotalTj", this.getPageTotal(result.getPageBean().getResult()));
		model.addAttribute("totalTj", result.getTotalTj());
		return "tj/tjGroupProfitList";
	}
	
	@RequestMapping("GroupProfitList.htm")
	public String GroupProfitList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		TjSearchResult result = tjGroupFacade.GroupProfitList(bizId);
		
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", result.getOrgUserJsonStr());
		model.addAttribute("bizId", bizId); // 过滤B商家
		return "tj/GroupProfitList";
	}
	

	@RequestMapping(value = "/GroupProfitList_Post.do")
	public String GroupProfitList_get(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, TourGroupVO group){
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		tjSearchDTO.setBizId(WebUtils.getCurBizId(request));
		tjSearchDTO.setGroup(group);
		tjSearchDTO.setDataUserIdString(WebUtils.getDataUserIdString(request));
		ToGroupListResult result = tjGroupFacade.GroupProfitList_get(tjSearchDTO);
		
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("pageTotalTj", this.getPageTotal(result.getPageBean().getResult()));
		model.addAttribute("totalTj", result.getTotalTj());
		return "tj/GroupProfitList_table";
	}
	
	@RequestMapping(value = "/GroupProfitList_GetData.do")
	@ResponseBody
	public String GroupProfitList_GetData(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, TourGroupVO group){
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		tjSearchDTO.setBizId(WebUtils.getCurBizId(request));
		tjSearchDTO.setGroup(group);
		tjSearchDTO.setDataUserIdString(WebUtils.getDataUserIdString(request));
		PageBean result = tjGroupFacade.GroupProfitList_GetData(tjSearchDTO);
		
		model.addAttribute("page", result);
		//model.addAttribute("pageTotalTj", this.getPageTotal(pageBean.getResult()));
		//model.addAttribute("totalTj", totalTj);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value = "/GroupProfitList_PostFooter.do")
	@ResponseBody
	public String GroupProfitList_PostFooter(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, TourGroupVO group){
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		tjSearchDTO.setBizId(WebUtils.getCurBizId(request));
		tjSearchDTO.setGroup(group);
		tjSearchDTO.setDataUserIdString(WebUtils.getDataUserIdString(request));
		TJGroupProfitResult result = tjGroupFacade.GroupProfitList_PostFooter(tjSearchDTO);

		return JSON.toJSONString(result.getTjGroupProfit());
	}
	
	@RequestMapping("toGroupProfitPrint.htm")
	public String toGroupProfitPrint(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,TourGroupVO group){
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		tjSearchDTO.setBizId(WebUtils.getCurBizId(request));
		tjSearchDTO.setGroup(group);
		tjSearchDTO.setPm(WebUtils.getQueryParamters(request));
		tjSearchDTO.setDataUserIdString(WebUtils.getDataUserIdString(request));
		SelectShopProjectListResult result = tjGroupFacade.toGroupProfitPrint(tjSearchDTO);
		
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("pageTotalTj", this.getPageTotal(result.getPageBean().getResult()));
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" <br/>打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "tj/tjGroupProfitList-print";
	}
	/**
	 * 单团利润统计导出excl
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 */
	@RequestMapping(value = "/getGroupProfitExcl.do")
	@ResponseBody
	public void getGroupProfitExcl(HttpServletRequest request,HttpServletResponse response, ModelMap model,TourGroupVO group){
		if (StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = tjFacade.getUserIdListByOrgIdList(set, WebUtils.getCurBizId(request));
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operatorId", group.getSaleOperatorIds());
		}
		Integer bizId = WebUtils.getCurBizId(request);
		String dataUser = WebUtils.getDataUserIdString(request); //数据权限
		pm.put("dataUser", dataUser);
		
		PageBean<TJGroupProfit> pageBean = new PageBean<TJGroupProfit>();
		pageBean.setPageSize(100000);
		pageBean.setPage(1);		
		pageBean.setParameter(pm);
		
		pageBean = tjGroupFacade.selectGroupProfitListPageOu(pageBean, bizId, dataUser);
		//pageBean = tjService.selectGroupProfitListPage(pageBean);
		this.addOrderDetailExcl(pageBean);
		
		TJGroupProfit all = this.getPageTotal(pageBean.getResult());
		
		List list = pageBean.getResult();
		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/groupProfit.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
	        CellStyle cellStyle = wb.createCellStyle();
	        cellStyle.setWrapText(true);
	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
	        CellStyle styleLeft = wb.createCellStyle();
	        styleLeft.setWrapText(true);
	        styleLeft.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleLeft.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleLeft.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleLeft.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
	        
	        CellStyle styleRight = wb.createCellStyle();
	        styleRight.setWrapText(true);
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
		    	TJGroupProfit tJGroupProfit = (TJGroupProfit)it.next() ;
		       
		       //从第四行开始，前三行分别为标题和列明
		       row = sheet.createRow(index+3);
		       //第一列：序号
		       cc = row.createCell(0);
		       cc.setCellValue(index+1);
		       cc.setCellStyle(cellStyle);
		       
		       //第二列：团号
		       cc = row.createCell(1);
		       cc.setCellValue(tJGroupProfit.getGroupCode()==null?"":tJGroupProfit.getGroupCode());
		       cc.setCellStyle(cellStyle);
		       
		       //第三列：团期
		       cc = row.createCell(2);
		       String start = tJGroupProfit.getDateStart()==null?"":dt.format(tJGroupProfit.getDateStart());
		       String end = tJGroupProfit.getDateEnd()==null?"":dt.format(tJGroupProfit.getDateEnd());
		       cc.setCellValue(start+"/"+end);
		       cc.setCellStyle(styleLeft);
		       
		       //第四列：人数
		       cc = row.createCell(3);
		       cc.setCellValue(tJGroupProfit.getTotalAdult()+"大"+tJGroupProfit.getTotalChild()+"小"+tJGroupProfit.getTotalGuide()+"陪");
		       cc.setCellStyle(styleLeft);
		       
		       //第五列：产品线路	       
		       cc = row.createCell(4);
		       cc.setCellValue("【"+tJGroupProfit.getProductBrandName()+"】"+tJGroupProfit.getProductName());
		       cc.setCellStyle(styleLeft);
		       //第六列：组团社 
		       cc = row.createCell(5);
	    	   cc.setCellValue(tJGroupProfit.getOrderDetails());
		       cc.setCellStyle(cellStyle);
		       //第七列：地接社
		       cc = row.createCell(6);
		       cc.setCellValue(StringUtils.isBlank(tJGroupProfit.getDeliveryNames()) || StringUtils.isEmpty(tJGroupProfit.getDeliveryNames())?"":tJGroupProfit.getDeliveryNames().replaceAll("<br/>", "\r\n"));
		       cc.setCellStyle(cellStyle);
		       //第八列：计调
		       cc = row.createCell(7);
		       cc.setCellValue(tJGroupProfit.getOperatorName());
		       cc.setCellStyle(cellStyle);
		       //第九列：团费
		       cc = row.createCell(8);
			   BigDecimal incomeOrder = tJGroupProfit.getIncomeOrder() != null ? new BigDecimal(tJGroupProfit.getIncomeOrder().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(incomeOrder));
		       cc.setCellStyle(cellStyle);
		       //第十列：其他收入
		       cc = row.createCell(9);
			   BigDecimal incomeOther = tJGroupProfit.getIncomeOther() != null ? new BigDecimal(tJGroupProfit.getIncomeOther().toString()) : new BigDecimal(0);
			   cc.setCellValue(df.format(incomeOther));
			   cc.setCellStyle(cellStyle);
		       //第十一列：购物收入
		       cc = row.createCell(10);
			   BigDecimal incomeShop = tJGroupProfit.getIncomeShop() != null ? new BigDecimal(tJGroupProfit.getIncomeShop().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(incomeShop));
		       cc.setCellStyle(cellStyle);
		       //第十二列：地接
		       cc = row.createCell(11);
			   BigDecimal expenseTravelagency = tJGroupProfit.getExpenseTravelagency() != null ? new BigDecimal(tJGroupProfit.getExpenseTravelagency().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseTravelagency));
		       cc.setCellStyle(cellStyle);
		       //第十三列：房费
		       cc = row.createCell(12);
		       BigDecimal expenseHotel = tJGroupProfit.getExpenseHotel() != null ? new BigDecimal(tJGroupProfit.getExpenseHotel().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseHotel));
		       cc.setCellStyle(cellStyle);
		       //第十四列：餐费
		       cc = row.createCell(13);
			   BigDecimal expenseRestaurant = tJGroupProfit.getExpenseRestaurant() != null ? new BigDecimal(tJGroupProfit.getExpenseRestaurant().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseRestaurant));
		       cc.setCellStyle(cellStyle);
		       //第十五列：车费
		       cc = row.createCell(14);
		       BigDecimal expenseFleet = tJGroupProfit.getExpenseFleet() != null ? new BigDecimal(tJGroupProfit.getExpenseFleet().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseFleet));
		       cc.setCellStyle(cellStyle);
		       //第十六列：门票
		       cc = row.createCell(15);
		       BigDecimal expenseScenicspot = tJGroupProfit.getExpenseScenicspot() != null ? new BigDecimal(tJGroupProfit.getExpenseScenicspot().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseScenicspot));
		       cc.setCellStyle(cellStyle);
		       //第十七列：机票
		       cc = row.createCell(16);
		       BigDecimal expenseAirticket = tJGroupProfit.getExpenseAirticket() != null ? new BigDecimal(tJGroupProfit.getExpenseAirticket().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseAirticket));
		       cc.setCellStyle(cellStyle);
		       //第十八列：火车票
		       cc = row.createCell(17);
		       BigDecimal expenseTrainticket = tJGroupProfit.getExpenseTrainticket() != null ? new BigDecimal(tJGroupProfit.getExpenseTrainticket().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseTrainticket));
		       cc.setCellStyle(cellStyle);
		       //第十九列：保险
		       cc = row.createCell(18);
		       BigDecimal expenseInsurance = tJGroupProfit.getExpenseInsurance() != null ? new BigDecimal(tJGroupProfit.getExpenseInsurance().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseInsurance));
		       cc.setCellStyle(cellStyle);
		       //第二十列：其他支出
		       cc = row.createCell(19);
		       BigDecimal expenseOther = tJGroupProfit.getExpenseOther() != null ? new BigDecimal(tJGroupProfit.getExpenseOther().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(expenseOther));
		       cc.setCellStyle(cellStyle);
		       //第二十一列：总收入
		       cc = row.createCell(20);
		       BigDecimal totalIncome = tJGroupProfit.getTotalIncome() != null ? new BigDecimal(tJGroupProfit.getTotalIncome().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(totalIncome));
		       cc.setCellStyle(cellStyle);
		       //第二十二列：总成本
		       cc = row.createCell(21);
		       BigDecimal totalExpense = tJGroupProfit.getTotalExpense() != null ? new BigDecimal(tJGroupProfit.getTotalExpense().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(totalExpense));
		       cc.setCellStyle(cellStyle);
		       //第二十三列：毛利
		       cc = row.createCell(22);
		       BigDecimal totalProfit = tJGroupProfit.getTotalProfit() != null ? new BigDecimal(tJGroupProfit.getTotalProfit().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(totalProfit));
		       cc.setCellStyle(cellStyle);
		       //第24列：人均毛利
		       cc = row.createCell(23);
		       BigDecimal profitPerGuest = tJGroupProfit.getProfitPerGuest() != null ? new BigDecimal(tJGroupProfit.getProfitPerGuest().toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(profitPerGuest));
		       cc.setCellStyle(cellStyle);
		       
		       index++; 
		       
		    }
		    BigDecimal totalAdult=new BigDecimal(0);
		    BigDecimal totalChild=new BigDecimal(0);
		    BigDecimal totalGuide=new BigDecimal(0);
		    BigDecimal iIncomeOrder=new BigDecimal(0);
		    BigDecimal incomeOther=new BigDecimal(0);
		    BigDecimal incomeShop=new BigDecimal(0);
		    BigDecimal expenseTravelagency=new BigDecimal(0);
		    BigDecimal expenseHotel=new BigDecimal(0);
		    BigDecimal expenseRestaurant=new BigDecimal(0);
		    BigDecimal expenseFleet=new BigDecimal(0);
		    BigDecimal expenseScenicspot=new BigDecimal(0);
		    
		    BigDecimal expenseAirticket=new BigDecimal(0);
		    BigDecimal expenseTrainticket=new BigDecimal(0);
		    BigDecimal expenseInsurance=new BigDecimal(0);
		    BigDecimal expenseOther=new BigDecimal(0);
		    BigDecimal totalIncome=new BigDecimal(0);
		    BigDecimal totalExpense=new BigDecimal(0);
		    BigDecimal totalProfit=new BigDecimal(0);
		    BigDecimal profitPerGuest=new BigDecimal(0);
		   
		    if(null!=all){
		    	if(null!=all.getTotalAdult()){
					totalAdult = new BigDecimal(all.getTotalAdult());
				}
				if(null!=all.getTotalChild()){
					totalChild = new BigDecimal(all.getTotalChild());
				}
				if(null!=all.getTotalGuide()){
					totalGuide = new BigDecimal(all.getTotalGuide());
				}
		    	if(null!=all.getIncomeOrder()){
		    		iIncomeOrder = new BigDecimal(all.getIncomeOrder().toString());
				}
				if(null!=all.getIncomeOther()){
					incomeOther = new BigDecimal(all.getIncomeOther().toString());
				}
				if(null!=all.getIncomeShop()){
					incomeShop = new BigDecimal(all.getIncomeShop().toString());
				}
				if(null!=all.getExpenseTravelagency()){
					expenseTravelagency = new BigDecimal(all.getExpenseTravelagency().toString());
				}
				if(null!=all.getExpenseHotel()){
					expenseHotel = new BigDecimal(all.getExpenseHotel().toString());
				}
				if(null!=all.getExpenseRestaurant()){
					expenseRestaurant = new BigDecimal(all.getExpenseRestaurant().toString());
				}
				if(null!=all.getExpenseFleet()){
					expenseFleet = new BigDecimal(all.getExpenseFleet().toString());
				}
				if(null!=all.getExpenseScenicspot()){
					expenseScenicspot = new BigDecimal(all.getExpenseScenicspot().toString());
				}
				if(null!=all.getExpenseAirticket()){
					expenseAirticket = new BigDecimal(all.getExpenseAirticket().toString());
				}
				if(null!=all.getExpenseTrainticket()){
					expenseTrainticket = new BigDecimal(all.getExpenseTrainticket().toString());
				}
				if(null!=all.getExpenseInsurance()){
					expenseInsurance = new BigDecimal(all.getExpenseInsurance().toString());
				}
				if(null!=all.getExpenseOther()){
					expenseOther = new BigDecimal(all.getExpenseOther().toString());
				}
				if(null!=all.getTotalIncome()){
					totalIncome = new BigDecimal(all.getTotalIncome().toString());
				}
				if(null!=all.getTotalExpense()){
					totalExpense = new BigDecimal(all.getTotalExpense().toString());
				}
				if(null!=all.getTotalProfit()){
					totalProfit = new BigDecimal(all.getTotalProfit().toString());
				}
				if(null!=all.getProfitPerGuest()){
					profitPerGuest = new BigDecimal(all.getProfitPerGuest().toString());
				}
				
			}
		    row = sheet.createRow(index+3); //加合计行
		    cc = row.createCell(0);
		    cc = row.createCell(1);
		    cc = row.createCell(2);
		    cc.setCellValue("合计："); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(3);
		    cc.setCellValue(totalAdult.toString()+"大"+totalChild.toString()+"小"+totalGuide.toString()+"陪"); 
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
		    cc.setCellValue(df.format(iIncomeOrder)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(9);
		    cc.setCellValue(df.format(incomeOther)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(10);
		    cc.setCellValue(df.format(incomeShop)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(11);
		    cc.setCellValue(df.format(expenseTravelagency)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(12);
		    cc.setCellValue(df.format(expenseHotel)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(13);
		    cc.setCellValue(df.format(expenseRestaurant)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(14);
		    cc.setCellValue(df.format(expenseFleet)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(15);
		    cc.setCellValue(df.format(expenseScenicspot)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(16);
		    cc.setCellValue(df.format(expenseAirticket)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(17);
		    cc.setCellValue(df.format(expenseTrainticket)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(18);
		    cc.setCellValue(df.format(expenseInsurance)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(19);
		    cc.setCellValue(df.format(expenseOther)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(20);
		    cc.setCellValue(df.format(totalIncome)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(21);
		    cc.setCellValue(df.format(totalExpense)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(22);
		    cc.setCellValue(df.format(totalProfit)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(23);
		    cc.setCellValue(df.format(profitPerGuest)); 
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
		download(path, response,"tjGroupProfit.xlsx");
	}
	
//	
//	private void addOrderDetail(PageBean pageBean){
//		List<TJGroupProfit> list = pageBean.getResult();
//		if(list != null && list.size() > 0){
//			StringBuilder detailStr = null;
//			TJGroupProfit groupProfit = null;
//			for(int i = 0; i < list.size(); i++){
//				groupProfit = list.get(i);
//				List<GroupOrder> orderList = tourGroupService.selectOrderAndGuestInfoByGroupId(groupProfit.getGroupId());
//				if(orderList == null || orderList.size() == 0){
//					continue;
//				}
//				
//				detailStr = new StringBuilder();
//				for(int j = 0; j < orderList.size(); j++){
//					if(j > 0){
//						detailStr.append("<br/>");
//					}
//					GroupOrder order = orderList.get(j);
//					String total = order.getTotal()!=null?df.format(order.getTotal()):df.format(new BigDecimal(0));
//					detailStr.append("<label class='order-lb1'>"+ order.getSupplierName()+"</label>");
//					detailStr.append("<label class='order-lb2'>"+ order.getNumAdult() +"+"+ order.getNumChild() +"</label>");
//					detailStr.append("<label class='order-lb3'>"+ total +"</label>");
//					detailStr.append("<label class='order-lb4'>"+ order.getSaleOperatorName()+"</label>");
//					detailStr.append("<label class='order-lb5'>"+ order.getSourceTypeName()+"</label>");
//				}
//				groupProfit.setOrderDetails(detailStr.toString());
//			}
//		}
//	}
	
//	/**
//	 * 处理销售订单的明细显示
//	 * @param pageBean
//	 */
//	private void addOrderDetail2(PageBean pageBean) {
//		List<TJGroupProfit> list = pageBean.getResult();
//		if (list != null && list.size() > 0) {
//			StringBuilder detailStr = new StringBuilder();
//			TJGroupProfit groupProfit = null;
//			for (int i = 0; i < list.size(); i++) {
//				groupProfit = list.get(i);
//				if (!StringUtils.isBlank(groupProfit.getOrderSupplierNames())){
//					for (String row : groupProfit.getOrderSupplierNames().split(",")) {
//						if (!StringUtils.isBlank(row)){
//							String[] rowAry = row.split("@");
//							if (rowAry.length > 1) {
//								detailStr.append("<p>");
//								detailStr.append("<label class='order-lb1'>" + rowAry[0] + "</label>");
//								detailStr.append("<label class='order-lb2'>" + rowAry[1] + "+" + rowAry[2] + "</label>");
//								detailStr.append("<label class='order-lb3'>" + df.format(new BigDecimal(rowAry[4])) + "</label>");
//								detailStr.append("<label class='order-lb4'>" + rowAry[5] + "</label>");
//								if (rowAry.length == 7)
//									detailStr.append("<label class='order-lb5'>" + rowAry[6] + "</label>");
//								detailStr.append("</p>");
//							}
//						}
//					}
//				}
//
//				groupProfit.setOrderDetails(detailStr.toString());
//				detailStr.setLength(0);
//			}
//		}
//	}	
	private void addOrderDetailExcl(PageBean pageBean){
		List<TJGroupProfit> list = pageBean.getResult();
		if (list != null && list.size() > 0) {
			StringBuilder detailStr = new StringBuilder();
			TJGroupProfit groupProfit = null;
			for (int i = 0; i < list.size(); i++) {
				groupProfit = list.get(i);
				if (!StringUtils.isBlank(groupProfit.getOrderSupplierNames())){
					for (String row : groupProfit.getOrderSupplierNames().split(",")) {
						if (!StringUtils.isBlank(row)){
							String[] rowAry = row.split("@");
							if (rowAry.length > 1) {
								detailStr.append("" + rowAry[0] + " ");
								detailStr.append("" + rowAry[1] + "+" + rowAry[2] + " ");
								detailStr.append("" + df.format(new BigDecimal(rowAry[4])) + " ");
								detailStr.append("" + rowAry[5] + " ");
								if (rowAry.length == 7)
									detailStr.append("" + rowAry[6] + "");
								detailStr.append("\r\n");
							}
						}
					}
				}

				groupProfit.setOrderDetails(detailStr.toString());
				detailStr.setLength(0);
			}
		}
		
		
	}
	
	private TJGroupProfit getPageTotal(List<TJGroupProfit> tjList){
		TJGroupProfit pageTotal = new TJGroupProfit();
		for (TJGroupProfit tj: tjList){
			pageTotal.setTotalAdult(pageTotal.getTotalAdult() + tj.getTotalAdult());
			pageTotal.setTotalChild(pageTotal.getTotalChild() + tj.getTotalChild());
			pageTotal.setTotalGuide(pageTotal.getTotalGuide() + tj.getTotalGuide());
			pageTotal.setIncomeOrder(pageTotal.getIncomeOrder().add(tj.getIncomeOrder()));
			pageTotal.setIncomeOther(pageTotal.getIncomeOther().add(tj.getIncomeOther()));
			pageTotal.setIncomeShop(pageTotal.getIncomeShop().add(tj.getIncomeShop()));
			pageTotal.setExpenseTravelagency(pageTotal.getExpenseTravelagency().add(tj.getExpenseTravelagency()));
			pageTotal.setExpenseHotel(pageTotal.getExpenseHotel().add(tj.getExpenseHotel()));
			pageTotal.setExpenseRestaurant(pageTotal.getExpenseRestaurant().add(tj.getExpenseRestaurant()));
			pageTotal.setExpenseFleet(pageTotal.getExpenseFleet().add(tj.getExpenseFleet()));
			pageTotal.setExpenseScenicspot(pageTotal.getExpenseScenicspot().add(tj.getExpenseScenicspot()));
			pageTotal.setExpenseAirticket(pageTotal.getExpenseAirticket().add(tj.getExpenseAirticket()));
			pageTotal.setExpenseTrainticket(pageTotal.getExpenseTrainticket().add(tj.getExpenseTrainticket()));
			pageTotal.setExpenseInsurance(pageTotal.getExpenseInsurance().add(tj.getExpenseInsurance()));
			pageTotal.setExpenseOther(pageTotal.getExpenseOther().add(tj.getExpenseOther()));
			pageTotal.setTotalIncome(pageTotal.getTotalIncome().add(tj.getTotalIncome()));
			pageTotal.setTotalExpense(pageTotal.getTotalExpense().add(tj.getTotalExpense()));
			pageTotal.setTotalProfit(pageTotal.getTotalProfit().add(tj.getTotalProfit()));
			pageTotal.setProfitPerGuest(pageTotal.getProfitPerGuest().add(tj.getProfitPerGuest()));
		}
		if (tjList.size()!=0){
			pageTotal.setProfitPerGuest(pageTotal.getProfitPerGuest().divide(new BigDecimal(tjList.size()), 2, BigDecimal.ROUND_HALF_UP));
		}
		return pageTotal;
	}
	
//	@RequestMapping("archiveAllGroupProfit.do")
//	public void archiveAllGroupProfit(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException, InterruptedException{
//		model.addAttribute("archiveType", "All");
//		this.initGroupProfitTable(request, response, model);
//	}
//	@RequestMapping("archiveIncrementalGroupProfit.do")
//	public void archiveIncrementalGroupProfit(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException, InterruptedException{
//		model.addAttribute("archiveType", "Incremental");
//		this.initGroupProfitTable(request, response, model);
//	}
	
//	private void initGroupProfitTable(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException, InterruptedException{
//		response.setContentType("text/html;charset=utf-8");
//		response.getWriter().write("开始归档");
//		response.flushBuffer();
//		
//		List<TJGroupQueryId> groupIdList = new ArrayList<TJGroupQueryId>();
//		if (model.get("archiveType").equals("Incremental")){
//			groupIdList = tjService.findUpdatedGroupIdList("tj_group_profit");
//		}else if (model.get("archiveType").equals("All")){
//			groupIdList = tjService.findAllGroupIdList();
//		}else {
//
//		}
//
//		Long startTime = System.currentTimeMillis();
//		if (model.get("archiveType").equals("All")){
//			tjService.clearAllGroup();
//		}else if (groupIdList.size()>0){
//			tjService.clearUpdatedGroup(groupIdList);
//		}
//		for(int i=0; i<groupIdList.size(); i++){
//			Integer groupId = groupIdList.get(i).getGroupId();
//			Integer bizId = groupIdList.get(i).getBizId();
//			TJGroupProfit tj = new TJGroupProfit();
//			TourGroup g = tourGroupService.selectByPrimaryKey(groupId);
//			if (g==null){
//				continue;
//			}
//			if (g.getGroupState()!=null && g.getGroupState()!=1 && g.getGroupState()!=3 && g.getGroupState()!=4){
//				continue;
//			}
//			tj.setBizId(bizId);
//			tj.setGroupId(groupId);
//			tj.setGroupCode(g.getGroupCode());
//			tj.setGroupMode(g.getGroupMode());
//			tj.setGroupState(g.getGroupState());
//			tj.setDateStart(g.getDateStart());
//			tj.setDateEnd(g.getDateEnd());
//			tj.setProductBrandName(g.getProductBrandName());
//			tj.setProductName(g.getProductName());
//			tj.setTotalAdult(g.getTotalAdult()==null?0:g.getTotalAdult());
//			tj.setTotalChild(g.getTotalChild()==null?0:g.getTotalChild());
//			tj.setTotalGuide(g.getTotalGuide()==null?0:g.getTotalGuide());
//			tj.setOperatorId(g.getOperatorId());
//			tj.setOperatorName(g.getOperatorName());
//			tj.setOperatorCompanyId(this.getCompanyIdByOperatorId(g.getOperatorId()));
//			// 取得组团社信息
//			Set<String> orderSupplierNameList = new HashSet<String>();
//			Set<String> orderSupplierIdList = new HashSet<String>();
//			Set<String> orderIdList = new HashSet<String>();
//			//销售ID
//			Integer saleId = null;
//			for(GroupOrder order: tourGroupService.selectOrderAndGuestInfoByGroupId(groupId)){
//				orderSupplierNameList.add(order.getSupplierName());
//				orderSupplierIdList.add(order.getSupplierId().toString());
//				orderIdList.add(order.getId().toString());
//				if(null == saleId){
//					saleId = order.getSaleOperatorId();
//				}
//			}
//			tj.setSaleOperatorId(saleId);
//			tj.setOrderSupplierIds(StringUtils.join(orderSupplierIdList, ","));
//			tj.setOrderSupplierNames(StringUtils.join(orderSupplierNameList, ","));
//			tj.setOrderIds(StringUtils.join(orderIdList, ","));
//			// 取得地接社信息
//			ArrayList<String> deliveryNameList = new ArrayList<String>();
//			ArrayList<String> deliveryIdList = new ArrayList<String>();
//			for (BookingDelivery delivery : bookingDeliveryService.getDeliveryListByGroupId(groupId)){
//				if (delivery.getSupplierId()==null){
//					log.error("wrong delivery at " + groupId);
//				}
//				deliveryNameList.add(delivery.getSupplierName());
//				deliveryIdList.add(delivery.getSupplierId().toString());
//			}
//			tj.setDeliveryNames(StringUtils.join(deliveryNameList, "<br/>"));
//			tj.setDeliveryIds(StringUtils.join(deliveryIdList, ","));
//			
//			Map fMap = financeService.queryAuditViewInfo(groupId, bizId);
//			// 组团社收入
//			InfoBean incomeOrder = (InfoBean)fMap.get("order");
//			tj.setIncomeOrder(incomeOrder.getNum());
//			tj.setIncomeOrderState(incomeOrder.getIsAudited()?1:0);
//			// 其他收入
//			InfoBean incomeOther = (InfoBean)fMap.get("otherin");
//			tj.setIncomeOther(incomeOther.getNum());
//			tj.setIncomeOtherState(incomeOther.getIsAudited()?1:0);
//			// 购物收入
//			//InfoBean incomeShop = (InfoBean)fMap.get("shop");
//			tj.setIncomeShop(g.getTotalIncomeShop()==null?new BigDecimal(0):g.getTotalIncomeShop());
//			tj.setIncomeShopState(0); // TODO 此处没有取是否审核过
//			// 地接社费用
//			InfoBean expenseDel = (InfoBean)fMap.get("del");
//			tj.setExpenseTravelagency(expenseDel.getNum());
//			tj.setExpenseTravelagencyState(expenseDel.getIsAudited()?1:0);
//			// 其他供应商支出
//			Collection<InfoBean> sups = (Collection<InfoBean>)fMap.get("sup");
//			for(InfoBean info: sups){
//				if (Constants.RESTAURANT.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseRestaurant(info.getNum());
//					tj.setExpenseRestaurantState(info.getIsAudited()?1:0);
//				}else if (Constants.HOTEL.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseHotel(info.getNum());
//					tj.setExpenseHotelState(info.getIsAudited()?1:0);
//				}else if (Constants.FLEET.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseFleet(info.getNum());
//					tj.setExpenseFleetState(info.getIsAudited()?1:0);
//				}else if (Constants.SCENICSPOT.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseScenicspot(info.getNum());
//					tj.setExpenseScenicspotState(info.getIsAudited()?1:0);
//				}else if (Constants.AIRTICKETAGENT.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseAirticket(info.getNum());
//					tj.setExpenseAirticketState(info.getIsAudited()?1:0);
//				}else if (Constants.TRAINTICKETAGENT.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseTrainticket(info.getNum());
//					tj.setExpenseTrainticketState(info.getIsAudited()?1:0);
//				}else if (Constants.INSURANCE.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseInsurance(info.getNum());
//					tj.setExpenseInsuranceState(info.getIsAudited()?1:0);
//				}else if (Constants.OTHEROUTCOME.equals(Integer.parseInt(info.getId()))){
//					tj.setExpenseOther(info.getNum());
//					tj.setExpenseOtherState(info.getIsAudited()?1:0);
//				}else {
//					log.error("Wrong supplier type, groupId:" + groupId + " and supplierType:"+info.getId());
//				}
//			}
//			// 计算总收入、支出、毛利润
//			tj.setTotalIncome(tj.getIncomeOrder().add(tj.getIncomeOther()).add(tj.getIncomeShop()));
//			tj.setTotalExpense(tj.getExpenseTravelagency().add(tj.getExpenseRestaurant()).add(tj.getExpenseFleet())
//					.add(tj.getExpenseHotel()).add(tj.getExpenseScenicspot()).add(tj.getExpenseAirticket())
//					.add(tj.getExpenseTrainticket()).add(tj.getExpenseInsurance()).add(tj.getExpenseOther()));
//			tj.setTotalProfit(tj.getTotalIncome().subtract(tj.getTotalExpense()));
//			if (tj.getTotalAdult()+tj.getTotalChild()!=0){
//				tj.setProfitPerGuest(tj.getTotalProfit().divide(new BigDecimal(tj.getTotalAdult()+tj.getTotalChild()), 2, BigDecimal.ROUND_HALF_DOWN));
//			}
//
//			BookingShopSelect groupShop = bookingShopService.getShopSelect(groupId);
//			if (groupShop!=null){
//				tj.setShopSales(groupShop.getFactSales());
//				tj.setShopSalesState(groupShop.isAudited()?1:0);
//				tj.setShopRepay(groupShop.getTotalRepay());
//				tj.setShopRepayState(groupShop.isAudited()?1:0);
//			}
//			List<FinanceCommission> commissions = financeGuideService.selectCommissionByGroupId(groupId);
//			BigDecimal tmpComm=new BigDecimal(0);
//			Integer tmpCommState=(commissions.size()>0)?1:0;
//			for (FinanceCommission comm: commissions){
//				tmpComm=tmpComm.add(comm.getTotal());
//				if (comm.getStateFinance()==0){
//					tmpCommState=0;
//				}
//			}
//			tj.setShopCommission(tmpComm);
//			tj.setShopCommissionState(tmpCommState);
//			tjService.insertGroupProfit(tj);
//			if (i%10==0){
//				response.getWriter().write(".");
//				response.flushBuffer();
//			}
//		}
//		insertArchiveRecord(request, startTime, BasicConstants.TJ_GROUP_PROFIT);
//		response.getWriter().write("归档完成。");
//		response.flushBuffer();
//	}
	
//	@RequestMapping("test")
//	@ResponseBody
//	public String test(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException, InterruptedException{
//		HashMap<String, String> json = new HashMap<String, String>();
//		response.setContentType("text/html;charset=utf-8");
//		response.getWriter().write("开始归档");
//		response.flushBuffer();
//		
//		for (int i=0; i<100; i++){
//			
//			
//		}
//		
//		return JSON.toJSONString(json);
//	}
	
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
			String qy = tjFacade.findByOrgPath("1-3-");
			String zy = tjFacade.findByOrgPath("1-4-") ;
			String yy = tjFacade.findByOrgPath("1-5-") ;
			String sx = tjFacade.findByOrgPath("1-6-") ;
			
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
	 * 线路利润统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toLineProfitList.htm")
	public String toLineProfitList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
//		setArchiveTime(request, model, BasicConstants.TJ_GROUP_PROFIT);
		Integer bizId = WebUtils.getCurBizId(request);
		TjSearchResult result = tjGroupFacade.toLineProfitList(bizId);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", result.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "tj/tjLineProfitList";
	}
	
	/**
	 * 线路利润统计2
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */             
	@RequestMapping("toLineProfits.htm")
	public String toLineProfits(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
//		setArchiveTime(request, model, BasicConstants.TJ_GROUP_PROFIT);
		Integer bizId = WebUtils.getCurBizId(request);
		TjSearchResult result = tjGroupFacade.toLineProfits(bizId);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", result.getOrgUserJsonStr());
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
		
		return "tj/tjLineProfits";
	}
	
	/**
	 * 查询线路利润
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/selectLineProfitList.do")
	public String selectLineProfitList(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,String saleOperatorIds,String orgIds,String sourceTypeId) {
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		tjSearchDTO.setBizId(WebUtils.getCurBizId(request));
		tjSearchDTO.setPage(page);
		tjSearchDTO.setPageSize(pageSize);
		tjSearchDTO.setOrgIds(orgIds);
		tjSearchDTO.setSaleOperatorIds(saleOperatorIds);
		tjSearchDTO.setPm(WebUtils.getQueryParamters(request));
		tjSearchDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		SelectLineProfitListResult result = tjGroupFacade.selectLineProfitList(tjSearchDTO);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("all_income_order", result.getAllIncomeOrder());
		model.addAttribute("all_income_other", result.getAllIncomeOther());
		model.addAttribute("all_shop_repay", result.getAllShopRepay());
		model.addAttribute("all_total_cost", result.getAllTotalCost());
		model.addAttribute("all_shop_commission", result.getAllShopCommission());
		model.addAttribute("all_total_profit", result.getAllTotalProfit());
		model.addAttribute("all_shop_sales", result.getAllShopSales());
		model.addAttribute("all_sum_person", result.getAllSumPerson());
		model.addAttribute("all_total_adult", result.getAllTotalAdult());
		model.addAttribute("all_total_child", result.getAllTotalChild());
		model.addAttribute("all_total_guide", result.getAllTotalGuide());
		return "tj/tjLineProfitList-table";
	}
	

	
	/**
	 * 查询线路利润2
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/selectLineProfits.do")
	public String selectLineProfits(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,String saleOperatorIds,String orgIds,String sourceTypeId) {
		TjSearchDTO tjSearchDTO = new TjSearchDTO();
		tjSearchDTO.setBizId(WebUtils.getCurBizId(request));
		tjSearchDTO.setPage(page);
		tjSearchDTO.setPageSize(pageSize);
		tjSearchDTO.setOrgIds(orgIds);
		tjSearchDTO.setSaleOperatorIds(saleOperatorIds);
		tjSearchDTO.setPm(WebUtils.getQueryParamters(request));
		tjSearchDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		SelectLineProfitListResult result = tjGroupFacade.selectLineProfits(tjSearchDTO);
		
		model.addAttribute("all_income_order", result.getAllIncomeOrder());
		model.addAttribute("all_income_other", result.getAllIncomeOther());
		model.addAttribute("all_shop_repay", result.getAllShopRepay());
		model.addAttribute("all_total_cost", result.getAllTotalCost());
		model.addAttribute("all_shop_commission", result.getAllShopCommission());
		model.addAttribute("all_total_profit", result.getAllTotalProfit());
		model.addAttribute("all_shop_sales", result.getAllShopSales());
		model.addAttribute("all_sum_person", result.getAllSumPerson());
		model.addAttribute("all_total_adult", result.getAllTotalAdult());
		model.addAttribute("all_total_child", result.getAllTotalChild());
		model.addAttribute("all_total_guide", result.getAllTotalGuide());
		return "tj/tjLineProfitListsTable";
	}
	
	

	
//	/**
//	 * 取得最新归档时间，放到Model里
//	 * @param request
//	 * @param model
//	 */
//	private void setArchiveTime(HttpServletRequest request, ModelMap model, String type){
//		Date recordEndTime = tjService.selectRecordEndTime(type, WebUtils.getCurBizId(request));
//		model.addAttribute("recordEndTime", DateUtils.format(recordEndTime, DateUtils.FORMAT_LONG));
//	}
	
//	/**
//	 * 添加归档记录
//	 * @param request
//	 * @param startTime
//	 */
//	private void insertArchiveRecord(HttpServletRequest request, Long startTime, String type){
//		Long endTime = System.currentTimeMillis();
//		//根据类型查询此表上一次统计的结束时间作为本次统计的开始时间
//		Date startDate = tjService.selectRecordEndTime(type, WebUtils.getCurBizId(request));
//		TJRecord tjRecord = new TJRecord();
//		tjRecord.setBizId(WebUtils.getCurBizId(request));
//		tjRecord.setType(type);
//		tjRecord.setStartTime(startDate);
//		tjRecord.setEndTime(new Date());
//		//耗时  秒
//		Long taketime = (endTime-startTime)/1000;
//		tjRecord.setTakeTime(taketime.intValue());
//		//插入记录
//		tjService.insetTJRecord(tjRecord);
//	}
	
	/**
	 * 线路利润统计打印页面
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("lineProfitPrint.htm")
	public String lineProfitPrint(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,String startTime,String endTime,String productBrandName,String companyId,String type,String saleOperatorIds,String orgIds) {
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
		
		//如果人员为空并且部门不为空，则取部门下的人id
		if(StringUtils.isBlank(saleOperatorIds) && StringUtils.isNotBlank(orgIds)){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = orgIds.split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = tjFacade.getUserIdListByOrgIdList(set, WebUtils.getCurBizId(request));
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				saleOperatorIds=salesOperatorIds.substring(0, salesOperatorIds.length()-1);
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=saleOperatorIds && !"".equals(saleOperatorIds)){
			pm.put("operator_id", saleOperatorIds);
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		
		pageBean = tjGroupFacade.selectLineProfitListPage(pageBean);
		Map<String,Object> map = tjGroupFacade.selectLineProfitCount(pageBean);
		if(null!=map){
			model.addAttribute("all_sum_person", map.get("all_sum_person"));
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "tj/tjLineProfitList-print";
	}
	/**
	 * 线路利润统计打印excl
	 * @param request
	 * @param response
	 * @param dateType
	 * @param startMin
	 * @param startMax
	 * @param shopStore
	 * @param shopItem
	 */
	@RequestMapping(value = "/getLineProfitExcl.do")
	@ResponseBody
	public void getLineProfitExcl(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,String startTime,String endTime,String productBrandName,String companyId,String type,String saleOperatorIds,String orgIds){
		PageBean pageBean = new PageBean();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);
		
		//如果人员为空并且部门不为空，则取部门下的人id
		if(StringUtils.isBlank(saleOperatorIds) && StringUtils.isNotBlank(orgIds)){
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = orgIds.split(",");
			for(String orgIdStr : orgIdArr){
				set.add(Integer.valueOf(orgIdStr));
			}
			set = tjFacade.getUserIdListByOrgIdList(set, WebUtils.getCurBizId(request));
			String salesOperatorIds="";
			for(Integer usrId : set){
				salesOperatorIds+=usrId+",";
			}
			if(!salesOperatorIds.equals("")){
				saleOperatorIds=salesOperatorIds.substring(0, salesOperatorIds.length()-1);
			}
		}
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=saleOperatorIds && !"".equals(saleOperatorIds)){
			pm.put("operator_id", saleOperatorIds);
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
		
		pageBean = tjGroupFacade.selectLineProfitListPage(pageBean);
		List list = pageBean.getResult();
		Map<String,Object> map = tjGroupFacade.selectLineProfitCount(pageBean);
		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/lineProfit.xlsx");
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
		       //线路
		       Map<String,Object> order = it.next() ;
		       
		       //从第四行开始，前三行分别为标题和列明
		       row = sheet.createRow(index+3);
		       //第一列：序号
		       cc = row.createCell(0);
		       cc.setCellValue(index+1);
		       cc.setCellStyle(cellStyle);
		       
		       //第二列：品牌名称
		       cc = row.createCell(1);
		       cc.setCellValue(order.get("product_brand_name")!=null?order.get("product_brand_name").toString():"");
		       cc.setCellStyle(cellStyle);
		       
		       //第三列：收客人数
		       cc = row.createCell(2);
		       cc.setCellValue(order.get("total_adult").toString()+"大"+order.get("total_child").toString()+"小"+order.get("total_guide").toString()+"陪");
		       cc.setCellStyle(styleLeft);
		       
		       //第四列：收客占比
		       cc = row.createCell(3);
		       if(null==order.get("sum_person")||null==map.get("all_sum_person")){
		    	   cc.setCellValue("0");
		       }else if(new BigDecimal(map.get("all_sum_person").toString()).compareTo(new BigDecimal(0))==0){
		    	   cc.setCellValue("0");
		       }else{
		    	   BigDecimal a =new BigDecimal(order.get("sum_person").toString());
		    	   BigDecimal b =new BigDecimal(map.get("all_sum_person").toString());
		    	   BigDecimal a1 =a.multiply(new BigDecimal(100));
		    	   double d = a1.divide(b,4).setScale(4,BigDecimal.ROUND_HALF_UP).doubleValue();
		    	   cc.setCellValue(df.format(d)+"%");
		       }
		       cc.setCellStyle(styleLeft);
		       
		       //第五列：团款收入	       
		       cc = row.createCell(4);
			   BigDecimal income_order = order.get("income_order") != null ? new BigDecimal(order.get("income_order").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(income_order));
		       cc.setCellStyle(styleLeft);
		       //第六列：人均团款 
		       cc = row.createCell(5);
		       if(null==order.get("income_order")||null==order.get("total_adult")){
		    	   cc.setCellValue("0");
		       }else if(new BigDecimal(order.get("total_adult").toString()).compareTo(new BigDecimal(0))==0){
		    	   cc.setCellValue("0");
		       }else{
		    	   BigDecimal a =new BigDecimal(order.get("income_order").toString());
		    	   BigDecimal b =new BigDecimal(order.get("total_adult").toString());
		    	   double d = a.divide(b,2).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
		    	   cc.setCellValue(df.format(d));
		       }
		       cc.setCellStyle(cellStyle);
		       //第七列：其他收入
		       cc = row.createCell(6);
			   BigDecimal income_other = order.get("income_other") != null ? new BigDecimal(order.get("income_other").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(income_other));
		       cc.setCellStyle(cellStyle);
		       //第八列：购物收入
		       cc = row.createCell(7);
			   BigDecimal shop_repay = order.get("shop_repay") != null ? new BigDecimal(order.get("shop_repay").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(shop_repay));
		       cc.setCellStyle(cellStyle);
		       //第九列：单团成本
		       cc = row.createCell(8);
			   BigDecimal total_cost = order.get("total_cost") != null ? new BigDecimal(order.get("total_cost").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(total_cost));
		       cc.setCellStyle(cellStyle);
		       //第十列：人均成本
		       cc = row.createCell(9);
		       if(null==order.get("total_cost")||null==order.get("total_adult")){
		    	   cc.setCellValue("0");
		       }else if(new BigDecimal(order.get("total_adult").toString()).compareTo(new BigDecimal(0))==0){
		    	   cc.setCellValue("0");
		       }else{
		    	   BigDecimal a =new BigDecimal(order.get("total_cost").toString());
		    	   BigDecimal b =new BigDecimal(order.get("total_adult").toString());
		    	   double d = a.divide(b,2).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
		    	   cc.setCellValue(df.format(d));
		       }
		       cc.setCellStyle(cellStyle);
		       //第十一列：购物成本
		       cc = row.createCell(10);
			   BigDecimal shop_commission = order.get("shop_commission") != null ? new BigDecimal(order.get("shop_commission").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(shop_commission));
		       cc.setCellStyle(cellStyle);
		       //第十二列：毛利
		       cc = row.createCell(11);
			   BigDecimal total_profit = order.get("total_profit") != null ? new BigDecimal(order.get("total_profit").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(total_profit));
		       cc.setCellStyle(cellStyle);
		       //第十三列：人均毛利
		       cc = row.createCell(12);
		       if(null==order.get("total_profit")||null==order.get("total_adult")){
		    	   cc.setCellValue("0");
		       }else if(new BigDecimal(order.get("total_adult").toString()).compareTo(new BigDecimal(0))==0){
		    	   cc.setCellValue("0");
		       }else{
		    	   BigDecimal a =new BigDecimal(order.get("total_profit").toString());
		    	   BigDecimal b =new BigDecimal(order.get("total_adult").toString());
		    	   double d = a.divide(b,2).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
		    	   cc.setCellValue(df.format(d));
		       }
		       cc.setCellStyle(cellStyle);
		       //第十四列：总购物
		       cc = row.createCell(13);
			   BigDecimal shop_sales = order.get("shop_sales") != null ? new BigDecimal(order.get("shop_sales").toString()) : new BigDecimal(0);
		       cc.setCellValue(df.format(shop_sales));
		       cc.setCellStyle(cellStyle);
		       //第十五列：人均购物
		       cc = row.createCell(14);
		       if(null==order.get("shop_sales")||null==order.get("total_adult")){
		    	   cc.setCellValue("0");
		       }else if(new BigDecimal(order.get("total_adult").toString()).compareTo(new BigDecimal(0))==0){
		    	   cc.setCellValue("0");
		       }else{
		    	   BigDecimal a =new BigDecimal(order.get("shop_sales").toString());
		    	   BigDecimal b =new BigDecimal(order.get("total_adult").toString());
		    	   double d = a.divide(b,2).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
		    	   cc.setCellValue(df.format(d));
		       }
		       cc.setCellStyle(cellStyle);
		       
		       index++; 
		       
		    }
		    BigDecimal all_income_order=new BigDecimal(0);
		    BigDecimal all_income_other=new BigDecimal(0);
		    BigDecimal all_shop_repay=new BigDecimal(0);
		    BigDecimal all_total_cost=new BigDecimal(0);
		    BigDecimal all_shop_commission=new BigDecimal(0);
		    BigDecimal all_total_profit=new BigDecimal(0);
		    BigDecimal all_shop_sales=new BigDecimal(0);
		    BigDecimal all_sum_person=new BigDecimal(0);
		    BigDecimal total_adult=new BigDecimal(0);
		    BigDecimal total_child=new BigDecimal(0);
		    BigDecimal total_guide=new BigDecimal(0);
		    if(null!=map){
		    	if(null!=map.get("all_income_order")){
		    		all_income_order = new BigDecimal(map.get("all_income_order").toString());
				}
				if(null!=map.get("all_income_other")){
					all_income_other = new BigDecimal(map.get("all_income_other").toString());
				}
				if(null!=map.get("all_shop_repay")){
					all_shop_repay = new BigDecimal(map.get("all_shop_repay").toString());
				}
				if(null!=map.get("all_total_cost")){
					all_total_cost = new BigDecimal(map.get("all_total_cost").toString());
				}
				if(null!=map.get("all_shop_commission")){
					all_shop_commission = new BigDecimal(map.get("all_shop_commission").toString());
				}
				if(null!=map.get("all_total_profit")){
					all_total_profit = new BigDecimal(map.get("all_total_profit").toString());
				}
				if(null!=map.get("all_shop_sales")){
					all_shop_sales = new BigDecimal(map.get("all_shop_sales").toString());
				}
				if(null!=map.get("all_sum_person")){
					all_sum_person = new BigDecimal(map.get("all_sum_person").toString());
				}
				if(null!=map.get("total_adult")){
					total_adult = new BigDecimal(map.get("total_adult").toString());
				}
				if(null!=map.get("total_child")){
					total_child = new BigDecimal(map.get("total_child").toString());
				}
				if(null!=map.get("total_guide")){
					total_guide = new BigDecimal(map.get("total_guide").toString());
				}
			}
		    row = sheet.createRow(index+3); //加合计行
		    cc = row.createCell(0);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(1);
		    cc.setCellValue("合计："); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(2);
		    cc.setCellValue(total_adult.toString()+"大"+total_child.toString()+"小"+total_guide.toString()+"陪"); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(3);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(4);
		    cc.setCellValue(df.format(all_income_order)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(5);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(6);
		    cc.setCellValue(df.format(all_income_other)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(7);
		    cc.setCellValue(df.format(all_shop_repay)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(8);
		    cc.setCellValue(df.format(all_total_cost)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(9);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(10);
		    cc.setCellValue(df.format(all_shop_commission)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(11);
		    cc.setCellValue(df.format(all_total_profit)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(12);
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(13);
		    cc.setCellValue(df.format(all_shop_sales)); 
		    cc.setCellStyle(styleRight);
		    cc = row.createCell(14);
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
		download(path, response,"tjLineProfit.xlsx");
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
            response.setContentType("application/vnd.ms-excel;charset=gb2312");  
            toClient.write(buffer);  
            toClient.flush();  
            toClient.close();
            file.delete() ;
        } catch (IOException ex) {
        	ex.printStackTrace();  
        }  
    }  

}
