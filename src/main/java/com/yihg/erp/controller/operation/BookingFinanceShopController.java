package com.yihg.erp.controller.operation;


import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;













import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.yihg.airticket.po.AirTicketLeg;
import com.yihg.airticket.po.AirTicketResource;
import com.yihg.basic.api.DicService;
import com.yihg.basic.exception.ClientException;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.ExcelOptConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.ExcelReporter;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.finance.api.FinanceService;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingShopDetailDeployService;
import com.yihg.operation.api.BookingShopDetailService;
import com.yihg.operation.api.BookingShopService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingShop;
import com.yihg.operation.po.BookingShopDetail;
import com.yihg.operation.po.BookingShopDetailDeploy;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.operation.vo.BookingGroup;
import com.yihg.operation.vo.BookingGuidesVO;
import com.yihg.operation.vo.BookingShopDetailDeployVO;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.po.TourGroupPriceAndPersons;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.ContractService;
import com.yihg.supplier.api.SupplierItemService;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierContractPriceDateInfo;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.supplier.po.SupplierItem;
import com.yihg.supplier.vo.SupplierContractVo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yimayhd.erpcenter.facade.sales.result.BookingShopResult;
import com.yimayhd.erpcenter.facade.sales.result.FinanceShopResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.operation.BookingFinanceShopFacade;
/**
 * @author : xuzejun
 * @date : 2015年7月25日 下午2:31:01
 * @Description: 财务-购物
 */
@Controller
@RequestMapping("/bookingFinanceShop")
public class BookingFinanceShopController extends BaseController {

	
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private SupplierService supplierSerivce;
	@Autowired
	private SupplierItemService itemService;
	@Autowired
	private BookingShopService bookingShopService;
	@Autowired
	private BookingGuideService bookingGuideService;
	@Autowired
	private DicService dicService;
	@Autowired
	private BookingShopDetailService shopDetailService;
	@Autowired
	private BookingShopDetailDeployService shopDetailDeployService;
	@Autowired
	private FinanceService financeService;
	@Autowired
	private GroupOrderService groupOrderService;
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private BookingSupplierDetailService detailsService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
    private ContractService contractService;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@Autowired
	private BookingFinanceShopFacade bookingFinanceShopFacade;
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物页面
	 */
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String toList(HttpServletRequest request,ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr",
				result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",
				result.getOrgUserJsonStr());
		return "operation/financeShop/shop-list";
	}
	
	@RequestMapping(value = "/importData.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String importData(HttpServletRequest request,ModelMap model) {
		return "operation/financeShop/shop-list-import";
	}
	
	@RequestMapping(value = "/importExcel.do")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	@ResponseBody
	public String importExcel(@RequestParam(value = "file", required = false) MultipartFile file,
			HttpServletRequest request, ModelMap model,Integer supplierId,String supplierName) throws IOException {  
		String path = request.getSession().getServletContext().getRealPath("upload");  
        if(null==file){
        	 return errorJson("请上传文件！") ; 
        }
        String fileName = file.getOriginalFilename();  
        if(!fileName.endsWith(".xlsx")){
        	return errorJson("文件格式不支持，请上传 xlsx格式excel文件!") ; 
        }
        String tempFileName = System.currentTimeMillis()+".xlsx" ;
        File targetFile = new File(path, tempFileName);  
        if(!targetFile.exists()){  
            targetFile.mkdirs();  
        }  
        //保存  
        try {  
            file.transferTo(targetFile);  
            String str = toSaveExcelData(targetFile,supplierId,supplierName,WebUtils.getCurBizId(request),request);
            targetFile.delete();
            return successJson("guestString",JSONArray.toJSONString(str)) ;
        } catch (Exception e) {
            e.printStackTrace();
            return errorJson(JSONArray.toJSONString("服务器忙！请稍后再试。。。。。。")) ; 
        }  
    }
	
	public String toSaveExcelData(File file,Integer supplierId,String supplierName,Integer bizId,HttpServletRequest request) throws InvalidFormatException, IOException{
		StringBuffer str =new StringBuffer();
		//根据购物店id获取购物项目
		List<SupplierItem> supplierItems = itemService.findSupplierItemBySupplierId(supplierId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		Workbook wb = new XSSFWorkbook(file) ;
		Sheet sheet = wb.getSheetAt(0) ;
		//前四列固定为团号、导游、进店人数和进店日期，从第五列开始记录购物项目，key为第几列，value为项目名称
		Row row0 = sheet.getRow(0);
		Cell cl = null ;
		for(int i=4;i<20;i++){
			cl=row0.getCell(i);
			if(null!=cl){
				map.put(cl.getStringCellValue().trim(),i);
			}
		}
		//比较表中购物项目，去掉不存在的购物项目
		String imp = null;
		//筛选后，保留下来的购物项目集合
		List<SupplierItem> supplierItemList = new ArrayList<SupplierItem>();
		Iterator<Map.Entry<String,Object>> it = map.entrySet().iterator();  
        while(it.hasNext()){  
            Map.Entry<String,Object> entry=it.next();  
            for (SupplierItem supplierItem : supplierItems) {
				if(supplierItem.getItemName().trim().equals(entry.getKey())){
					imp = "HAVE";
					supplierItem.setExclId((Integer)entry.getValue());
					supplierItemList.add(supplierItem);
				}
			}
            if(null==imp){
            	str.append(supplierName+"没有"+entry.getKey()+"\r\n");
            	it.remove();  
			}
			imp =null;
        }  
		
		Row row = null ;
		Cell cell = null ;
		TourGroup tour = null;
		 for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
			row = sheet.getRow(rowIndex) ;
			//团号
			String groupCode="";
			cell = row.getCell(0) ;
			if(null!=cell){
				cell.setCellType(1) ;
				str.append(cell.getStringCellValue()+",");
				groupCode = cell.getStringCellValue().trim();
			}
			//导游姓名
			String guideName="";
			Integer guideId = null;
			cell = row.getCell(1) ;
			if(null!=cell){
				cell.setCellType(1) ;
				str.append(cell.getStringCellValue()+":");
				tour = tourGroupService.selectByGroupCode(groupCode);
				if(null==tour){
					str.append("找不到该团！\r\n");
					continue;
				}
				List<BookingGuidesVO> guide = bookingGuideService.selectBookingGuideVoByGroupId(tour.getId());
				for (BookingGuidesVO bookingGuidesVO : guide) {
					if(bookingGuidesVO.getGuide().getGuideName().equals(cell.getStringCellValue().trim())){
						guideName = cell.getStringCellValue().trim();
						guideId = bookingGuidesVO.getGuide().getGuideId();
					}
				}
				if(StringUtils.isBlank(guideName)){
					str.append("该团找不到此导游！\r\n");
					continue;
				}
			}
			
			//进店人数
			String personNum = null;
			cell = row.getCell(2) ;
			if(null!=cell){
				cell.setCellType(1) ;
				personNum = cell.getStringCellValue().trim();
				if(!WordReporter.isNumeric(personNum)){
					str.append("该团进店人数不是数字！\r\n");
					continue;
				}
			}
			
			//进店日期
			Date date = null;
			cell = row.getCell(3) ;
			if(null!=cell){
				cell.setCellType(Cell.CELL_TYPE_NUMERIC) ;
				date = cell.getDateCellValue();
			}
			
			//购物店信息
			BookingShop shop =new BookingShop();
			shop.setGroupId(tour.getId());
			shop.setGuideId(guideId);
			shop.setGuideName(guideName);
			shop.setPersonNum(personNum==null?0:Integer.parseInt(personNum));
			shop.setShopDate(date == null ? "" : DateUtils.format(date));
			shop.setSupplierId(supplierId);
			shop.setSupplierName(supplierName);
			
			
			List<BookingShopDetail> bShopDetails= new ArrayList<BookingShopDetail>();
			BookingShopDetail bookingShopDetail = null;
			
			for (SupplierItem supplierItem : supplierItemList) {
				bookingShopDetail = new BookingShopDetail();
				bookingShopDetail.setGoodsId(supplierItem.getId());
				bookingShopDetail.setGoodsName(supplierItem.getItemName());
				cell = row.getCell(supplierItem.getExclId()) ;
				if(null!=cell){
					bookingShopDetail.setBuyTotal(new BigDecimal(cell.getNumericCellValue()));
				}
				//返款协议
				List<Date> dateList = new ArrayList<Date>();
				dateList.add(tour.getDateStart());
				List<SupplierContractPriceDateInfo> priceList = contractService.getContractPriceByPramas(bizId, supplierId,supplierItem.getId(), dateList);
				if(null!=priceList && priceList.size()>0){
					bookingShopDetail.setRepayVal(new BigDecimal(priceList.get(priceList.size()-1).getRebateAmount()));
				}else{
					str.append(supplierItem.getItemName()+"没有返款比例！");
					continue;
				}
				bookingShopDetail.setRepayTotal(bookingShopDetail.getBuyTotal().multiply(bookingShopDetail.getRepayVal().divide(new BigDecimal("100"))));
				bShopDetails.add(bookingShopDetail);
			}
			//保存
			bookingShopService.saveShopAndDetail(bizSettingCommon.getMyBizCode(request),WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(),bShopDetails,shop);
			str.append("导入成功！\r\n");
			
		 }
		 wb.close();
		 System.out.println(str.toString());
		 return str.toString() ;
	}
	
	@RequestMapping(value = "/bookingShopList.do")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String financeShopList(HttpServletRequest request, ModelMap model,TourGroupVO group,TourGroupVO groupVo) {
		
		PageBean pageBean = new PageBean();
		if(group.getPage()==null){
			group.setPage(1);
		}
		if(group.getPageSize()==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(group.getPageSize());
		}
		//Map paramters = WebUtils.getQueryParamters(request);
//		if(StringUtils.isBlank(groupVo.getSaleOperatorIds()) && StringUtils.isNotBlank(groupVo.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = groupVo.getOrgIds().split(",");
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
//				//paramters.put("saleOperatorIds", salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(groupVo.getSaleOperatorIds(), 
				groupVo.getOrgIds(), WebUtils.getCurBizId(request)));
		pageBean.setParameter(group);
		pageBean.setPage(group.getPage());
		//如果查询条件有进店日期或导游
		/*if(group.getSelectDate()==1 || StringUtils.isNotBlank(group.getGuideName())){
			
			pageBean = tourGroupService.selectGroup5ListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		}else {
			
			pageBean = tourGroupService.selectGroupListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		}*/
//		pageBean = tourGroupService.selectBookingFinanceShopGroupListPage(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));		
//		BookingGroup bookingGroup = tourGroupService.selectBookingFinanceShopGroupListPageSum(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		FinanceShopResult result = bookingFinanceShopFacade.financeShopList(pageBean, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", result.getPageBean());
		if(null != result.getBookingGroup()){
			model.addAttribute("bookingGroup", result.getBookingGroup());
		}
		return "operation/financeShop/shop-listView";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物列表下拉详情
	 */
	@RequestMapping(value = "/shopDetailList.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String shopDetailList( ModelMap model,Integer groupId) {
//		List<BookingShop> bookingShops=bookingShopService.getShopListByGroupId(groupId);
//		BigDecimal count=new BigDecimal(0);
//		for (BookingShop bookingShop : bookingShops) {
//			if(bookingShop.getTotalFace()!=null){
//				count=count.add(bookingShop.getTotalFace());
//			}
//			
//		}
		BookingShopResult result = bookingFinanceShopFacade.shopDetailList(groupId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("shopList", result.getBookingShops());
		model.addAttribute("count", result.getCount());
		
		return "operation/financeShop/shop-listViewDetail";
	}
	
	
	/**s
	 * @author : xuzejun
	 * @date : 2015年7月29日 下午3:32:39
	 * @Description: 分配购物 type 1:购物店 0：指标
	 */
	@RequestMapping(value = "/toBookingShopView.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String toEditBookingShop( ModelMap model,Integer groupId,Integer type) {
		BookingShopResult result = bookingFinanceShopFacade.toEditBookingShop(groupId, type);
		//List<BookingShop> shoplist = bookingShopService.getShopListByGroupId(groupId);
		model.addAttribute("shoplist", result.getBookingShops());
		model.addAttribute("groupId", groupId);
		
		if(type==1){
			return "operation/financeShop/alltoShop-list";
		}else{
			model.addAttribute("view", 1);
//			TourGroupPriceAndPersons tourGroupInfo = tourGroupService.selectTourGroupInfo(groupId);
//			tourGroupInfo.setProfit(tourGroupInfo.getIncomeIncome()-tourGroupInfo.getCostTotalPrice());
//			tourGroupInfo.setTotalProfit(tourGroupInfo.getProfit()/tourGroupInfo.getTotalAdult());
			model.addAttribute("tourGroupInfo",result.getTourGroupInfo());
			return "operation/financeShop/alltoIndex-list";
		}
	
		
	}
	
	@RequestMapping(value = "/bookingShopView.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String bookingShopView( ModelMap model,Integer groupId,Integer type) {
		BookingShopResult result = bookingFinanceShopFacade.toEditBookingShop(groupId, type);
		//List<BookingShop> shoplist = bookingShopService.getShopListByGroupId(groupId);
		model.addAttribute("shoplist",  result.getBookingShops());
		model.addAttribute("groupId", groupId);
//			TourGroupPriceAndPersons tourGroupInfo = tourGroupService.selectTourGroupInfo(groupId);
//			tourGroupInfo.setProfit(tourGroupInfo.getIncomeIncome()-tourGroupInfo.getCostTotalPrice());
//			tourGroupInfo.setTotalProfit(tourGroupInfo.getProfit()/tourGroupInfo.getTotalAdult());
		model.addAttribute("tourGroupInfo", result.getTourGroupInfo());
		model.addAttribute("view", 0);
		return "operation/financeShop/alltoIndex-list";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月29日 下午3:32:39
	 * @Description: 添加购物店
	 */
	@RequestMapping(value = "/editShop.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String editShop( ModelMap model,Integer groupId,Integer id) {
		model.addAttribute("groupId", groupId);
//		if(id!=null){
//			BookingShop shop = bookingShopService.selectByPrimaryKey(id);
		BookingShopResult result = bookingFinanceShopFacade.editShop(groupId, id);
			model.addAttribute("shop", result.getBookingShop());
//		}
//		//查询导游列表
//		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
		model.addAttribute("guides", result.getBookingGuides());
		return "operation/financeShop/edit-shop";
		
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增shop
	 */
	@RequestMapping(value = "/saveShop.do")
	@ResponseBody
	public String saveShop(HttpServletRequest request, ModelMap model,com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop shop) {
		if(null==shop.getId()){
			//int No = bookingShopService.getBookingCountByTime();
			//shop.setBookingNo(bizSettingCommon.getMyBizCode(request)+Constants.SHOPPING+new SimpleDateFormat("yyMMdd").format(new Date())+(No+100));
			shop.setUserId(WebUtils.getCurUserId(request));
			shop.setUserName(WebUtils.getCurUser(request).getName());
		}
//		String suc = bookingShopService.save(shop)>0?successJson():errorJson("操作失败！");
//		if(shop.getId()!=null){
//			financeService.calcTourGroupAmount(shop.getGroupId());
//		}
		int result = bookingFinanceShopFacade.saveShopAndUpdateFinance(shop, bizSettingCommon.getMyBizCode(request));
		return result >0 ? successJson():errorJson("操作失败！");
	}


	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 删除导游信息
	 */
	@RequestMapping(value = "/deleteShop.do",method = RequestMethod.POST)
	@ResponseBody
	public String deldetailGuide(Integer bookingId) {
//		BookingShop shop = bookingShopService.selectByPrimaryKey(bookingId);
//		shopDetailService.deleteByBookingId(bookingId);
//		bookingShopService.deleteByPrimaryKey(bookingId);
//		financeService.calcTourGroupAmount(shop.getGroupId());
		bookingFinanceShopFacade.deldetailGuide(bookingId);
		return successJson();
		//return bookingShopService.deleteByPrimaryKey(id)==1?successJson():errorJson("操作失败！");
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月31日 下午3:56:31
	 * @Description: to实际消费添加页面
	 */
	@RequestMapping(value = "/toFactShop.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String toFactShop(Integer id,Integer groupId,ModelMap model) {
	
//		BookingShop shop =bookingShopService.selectByPrimaryKey(id);
//		//查询实际消费返款列表
//		List<BookingShopDetail> shopDetails =shopDetailService.getShopDetailListByBookingId(id);
//		//商品
////		List<DicInfo> dic = dicService.getListByTypeCode(Constants.SHOPPING_TYPE_CODE);
////		model.addAttribute("dic", dic);
//		List<SupplierItem> supplierItems = itemService.findSupplierItemBySupplierId(shop.getSupplierId());
//		//查询导游列表
//		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
		BookingShopResult result = bookingFinanceShopFacade.toFactShop(groupId, id);
		model.addAttribute("guides", result.getBookingGuides());
		//if(!=nullshop.getId())
//		BookingGuide driverGuide = bookingGuideService.selectByGuideIdAndGroupId(shop.getGuideId(), groupId);
		com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplierDetail driver = result.getBookingSupplierDetail();
//		if(driverGuide != null){
//			driver = detailsService.selectByPrimaryKey(driverGuide.getBookingDetailId());
//		}
		model.addAttribute("driverName", null==driver?"":driver.getDriverName());
		model.addAttribute("driverId", null==driver?"":driver.getDriverId());
		//List<BookingSupplierDetail> driverList = detailsService.getDriversByGroupIdAndType(groupId, null);
		model.addAttribute("dic", result.getSupplierItems());
		model.addAttribute("driverList", result.getSupplierDetails());
		model.addAttribute("groupId", groupId);
		model.addAttribute("id", id);
		model.addAttribute("shopDetails",result.getShopDetails());
		model.addAttribute("shop", result.getBookingShop());
		return "operation/financeShop/shopAdd";
	}
	
	
	@RequestMapping(value = "/factShop.htm")
	@RequiresPermissions(PermissionConstants.CWGL_FINANCESHOPPING)
	public String factShop(Integer id,Integer groupId,ModelMap model) {
	
		//BookingShop shop =bookingShopService.selectByPrimaryKey(id);
		//查询实际消费返款列表
		//List<BookingShopDetail> shopDetails =shopDetailService.getShopDetailListByBookingId(id);
		//查询导游列表
		//List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
		BookingShopResult result = bookingFinanceShopFacade.toFactShop(groupId, id);
		model.addAttribute("guides", result.getBookingGuides());
		//商品
//				List<DicInfo> dic = dicService.getListByTypeCode(Constants.SHOPPING_TYPE_CODE);
//				model.addAttribute("dic", dic);
		//List<SupplierItem> supplierItems = itemService.findSupplierItemBySupplierId(shop.getSupplierId());
		model.addAttribute("dic", result.getSupplierItems());
		//List<BookingSupplierDetail> driverList = detailsService.getDriversByGroupIdAndType(groupId, null);
		model.addAttribute("driverList", result.getSupplierDetails());
		//BookingGuide driverGuide = bookingGuideService.selectByGuideIdAndGroupId(shop.getGuideId(), groupId);
//		if(null!=driverGuide){
//			BookingSupplierDetail driver = detailsService.selectByPrimaryKey(driverGuide.getBookingDetailId());
			com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplierDetail driver = result.getBookingSupplierDetail();
			model.addAttribute("driverName", null==driver?"":driver.getDriverName());
			model.addAttribute("driverId", null==driver?"":driver.getDriverId());
//		}
		model.addAttribute("id", id);
		model.addAttribute("groupId", groupId);
		model.addAttribute("shopDetails", result.getShopDetails());
		model.addAttribute("shop", result.getBookingShop());
		model.addAttribute("view", 1);
		return "operation/financeShop/shopAdd";
	}
	
	
	//分摊
	@RequestMapping(value = "/editDetailDeploy.htm")
	@ResponseBody
	public String editFactShop(com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetailDeploy b ,ModelMap model) {
			//查询分摊
//			List<BookingShopDetailDeploy> deploys = shopDetailDeployService.selectByDetailId(b.getBookingDetailId());
//			List<GroupOrder> groupOrders = tourGroupService.selectOrderAndGuestInfoByGroupId(b.getOrderId());
			BookingShopResult result = bookingFinanceShopFacade.editFactShop(b);
			
			List<BookingShopDetailDeploy> detailDeploys = new ArrayList<BookingShopDetailDeploy>();
			
			List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder> groupOrders = result.getGroupOrders();
			for (com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder g : groupOrders) {
				boolean exist = false;
				BookingShopDetailDeploy deploy = new BookingShopDetailDeploy();
				deploy.setOrderId(g.getId());//订单id
				deploy.setOrderNo(g.getOrderNo());//订单号
				deploy.setSupplierName(g.getSupplierName());//组团社
				deploy.setGuestSize(g.getGroupOrderGuestList().size());//人数
				StringBuffer sb = new StringBuffer();
				if(null!=g.getGroupOrderGuestList()){
					List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest> groupOrderGuestList = g.getGroupOrderGuestList();
					for (int i = 0; i < groupOrderGuestList.size(); i++) {
							if(i!=groupOrderGuestList.size()-1){
								sb.append(groupOrderGuestList.get(i).getName()+",");
							}else{
								sb.append(groupOrderGuestList.get(i).getName());
							}
							
					}
				}
				deploy.setGuestNames(sb.toString());
				List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetailDeploy> deploys = result.getShopDetailDeploys();
				for (int i = 0; i < deploys.size()&& !exist; i++) {
					if(deploys.get(i).getOrderId().equals(g.getId())){
						deploy.setBookingDetailId(b.getBookingDetailId());
						deploy.setBuyTotal(deploys.get(i).getBuyTotal());
						deploy.setRemark(deploys.get(i).getRemark());
						detailDeploys.add(deploy);
						exist = true;
						break;
					}
				}
				if(!exist){
					
					deploy.setBookingDetailId(b.getBookingDetailId());
					deploy.setRemark(null);
					deploy.setBuyTotal(null);
					
					detailDeploys.add(deploy);
				}
				
			}

			
			return JSONArray.toJSONString(detailDeploys, SerializerFeature.WriteNullStringAsEmpty);
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月31日 下午3:56:31
	 * @Description: to实际消费添加页面
	 */
	@RequestMapping(value = "/toEditShopDetail.htm")
	public String toEditShopDetail(BookingShopDetail shopDetail,String shopDate,Integer supplierId,Integer groupId,ModelMap model) {
		List<com.yimayhd.erpcenter.dal.basic.po.DicInfo> shopTypeList = saleCommonFacade.getShopListByTypeCode();
		//List<DicInfo> dic = dicService.getListByTypeCode(Constants.SHOPPING_TYPE_CODE);
//		if(shopDetail.getId()!=null){
//			shopDetail = shopDetailService.getShopDetailById(shopDetail.getId());
//		}
		com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetail detail = bookingFinanceShopFacade.getShopDetailById(shopDetail.getId());
		model.addAttribute("shopDate", shopDate.substring(0, 10));
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("groupId", groupId);
		if (detail.getId() == null) {
			model.addAttribute("shopDetail", shopDetail);
		}else {
			
			model.addAttribute("shopDetail", detail);
		}
		model.addAttribute("dic", shopTypeList);
		return "operation/financeShop/edit-shopDetail";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增shop
	 */
	@RequestMapping(value = "/saveShopDetail.do")
	@ResponseBody
	/*public String saveShopDetail(BookingShopDetail shopDetail) {
		shopDetail.setType((byte)1);
		String suc = shopDetailService.save(shopDetail)>0?successJson():errorJson("操作失败！");
		
		if(shopDetail.getId()!=null){
			financeService.calcTourGroupAmount(shopDetail.getBookingId());
		}
		return suc;
	}*/
	public String saveShopDetail(HttpServletRequest request,String shopDetail,com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop shop) {
		//BookingShopDetail bShopDetail = JSON.parseObject(shopDetail,BookingShopDetail.class);
		//保存购物
		if(null==shop.getId()){
//			int No = bookingShopService.getBookingCountByTime();
//			shop.setBookingNo(bizSettingCommon.getMyBizCode(request)+Constants.SHOPPING+new SimpleDateFormat("yyMMdd").format(new Date())+(No+100));
			shop.setUserId(WebUtils.getCurUserId(request));
			shop.setUserName(WebUtils.getCurUser(request).getName());
//			shop.setPersonNumFact(shop.getPersonNum());
		}
//		Integer id = bookingShopService.save(shop);
//		if(shop.getId()!=null){
//			shopDetailService.deleteByBookingId(shop.getId());
//		}
		//保存实际消费
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetail> bShopDetails = JSON.parseArray(shopDetail, com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetail.class);
		Map<String, Object> map = bookingFinanceShopFacade.saveShopDetail(bShopDetails, shop, bizSettingCommon.getMyBizCode(request));
//		if(bShopDetails!=null && bShopDetails.size()>0){
//			for (BookingShopDetail bShopDetail : bShopDetails) {
//				bShopDetail.setType((byte)1);
//				bShopDetail.setBookingId(id);
//				shopDetailService.save(bShopDetail);
//			}
//		}else{//如果detail为空，则shop金额全部为空
//			shop.setTotalFace(new BigDecimal(0));
//			shop.setTotalRepay(new BigDecimal(0));
//			bookingShopService.updateByPrimaryKeySelective(shop);
//		}
//		if(shop!=null && shop.getGroupId()!=null){
//			financeService.calcTourGroupAmount(shop.getGroupId());
//		}
//		Map<String, Object> map=new HashMap<String, Object>();
//		map.put("id", id);
		return successJson(map);
		
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 删除shopDetail信息
	 */
	@RequestMapping(value = "/delShopDetail.do",method = RequestMethod.POST)
	@ResponseBody
	public String delShopDetail(Integer id,Integer groupId) {
//		BookingShopDetail shopDetail = shopDetailService.getShopDetailById(id);
//		String suc = shopDetailService.deleteByPrimaryKey(id)==1?successJson():errorJson("操作失败！");
//		if(shopDetail.getType() != null){
//		  
//			if(shopDetail.getType().equals((byte)1)){
//				bookingShopService.updatetotalFace(shopDetail.getBookingId());
//			}
//		}
//		financeService.calcTourGroupAmount(groupId);
		ResultSupport result = bookingFinanceShopFacade.delShopDetail(id, groupId);
		return result.isSuccess() ? successJson() : errorJson("操作失败！");

	}
	/**
	 * @author : xuzejun
	 * @date : 2015年8月4日 下午8:31:12
	 * @Description: TODO保存分摊
	 */
	@RequestMapping(value = "/saveDeploy.do")
	@ResponseBody
	public String saveShopDetail(com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingShopDetailDeployVO deployVO) {
		//return shopDetailDeployService.insertSelective(deployVO)>0?successJson():errorJson("操作失败！");
		ResultSupport resultSupport = bookingFinanceShopFacade.saveShopDetail(deployVO);
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败！");
	}
	@RequestMapping("toAddShop.htm")
	public String toAddShop(Integer groupId,HttpServletRequest request,HttpServletResponse response,ModelMap model){
		//商品
		//List<DicInfo> dic = dicService.getListByTypeCode(Constants.SHOPPING_TYPE_CODE);
		//model.addAttribute("dic", dic);
		//supplierSerivce.getSupplierItemsBySupplierId(supplierId);
		//查询导游列表
//		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
		BookingShopResult result = bookingFinanceShopFacade.toAddShop(groupId);
		model.addAttribute("guides", result.getBookingGuides());
//		List<BookingSupplierDetail> driverList = detailsService.getDriversByGroupIdAndType(groupId, null);
		//model.addAttribute("dic", supplierItems);
		model.addAttribute("driverList", result.getSupplierDetails());
		model.addAttribute("groupId", groupId);
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
		model.addAttribute("group", result.getTourGroup());
		return "operation/financeShop/shopAdd";
		
	}
	@RequestMapping("getMatchedDriver.htm")
	@ResponseBody
	public String getMatchedDriver(Integer guideId,Integer groupId){
//		BookingGuide driverGuide = bookingGuideService.selectByGuideIdAndGroupId(guideId, groupId);
//		BookingSupplierDetail driver = detailsService.selectByPrimaryKey(driverGuide.getBookingDetailId());
//		Map<String, Object> map=new HashMap<String, Object>();
//		map.put("driverId", null==driver?"":driver.getDriverId());
//		map.put("driverName", null==driver?"":driver.getDriverName());
		Map<String, Object> map = bookingFinanceShopFacade.getMatchedDriver(guideId, groupId);
		return successJson(map);
		
	}
	@RequestMapping("delBookingShop.do")
	@ResponseBody
	public String delBookingShop(Integer bookingId){
//		BookingShop shop = bookingShopService.selectByPrimaryKey(bookingId);
//		shopDetailService.deleteByBookingId(bookingId);
//		bookingShopService.deleteByPrimaryKey(bookingId);
//		financeService.calcTourGroupAmount(shop.getGroupId());
		ResultSupport resultSupport = bookingFinanceShopFacade.delBookingShop(bookingId);
		return successJson();
	}
	
	@RequestMapping("delShopAndDetail.do")
	@ResponseBody
	public String delShopAndDetail(Integer bookingId){
		//int s = shopDetailDeployService.getCountByShopId(bookingId);
		ResultSupport resultSupport = bookingFinanceShopFacade.delShopAndDetail(bookingId);
		if(!resultSupport.isSuccess()){
			JSONObject json = new JSONObject();
			json.put("fail", true);
			return json.toString();
		}else{
//			BookingShop shop = bookingShopService.selectByPrimaryKey(bookingId);
//			shopDetailService.deleteByBookingId(bookingId);
//			bookingShopService.deleteByPrimaryKey(bookingId);
//			financeService.calcTourGroupAmount(shop.getGroupId());
			return successJson();
		}
		
	}
	/**
	 * 跳转到购物数据导入页面
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("batchAdd.htm")
	public String importData(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		return "operation/financeShop/shopDataBatchAdd";
		
	}
	/**
	 * 保存从excel文件读取的数据
	 * @param request
	 * @param resource
	 * @param file
	 * @return
	 */
	@RequestMapping("saveShopData.do")
	@ResponseBody
	public String importExcel(HttpServletRequest request,AirTicketResource resource, MultipartFile file){
		try {
			String path = request.getSession().getServletContext().getRealPath("/") + "/upload/";
			String filename = file.getOriginalFilename();
			File uploadFile=new File(path+filename);
			FileUtils.copyInputStreamToFile(file.getInputStream(), uploadFile);
			List<Map<String, String>> dataMap = ExcelReporter.exportListFromExcel(uploadFile,ExcelOptConstant.AIRRESOURCE);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new ClientException(e.getMessage());
		}
		return successJson();
	}
}
