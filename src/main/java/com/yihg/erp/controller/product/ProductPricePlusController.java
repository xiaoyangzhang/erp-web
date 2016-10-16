package com.yihg.erp.controller.product;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.images.util.DateUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.ProductGroupPriceService;
import com.yihg.product.api.ProductGroupService;
import com.yihg.product.api.ProductGroupSupplierService;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductStockService;
import com.yihg.product.po.ProductGroup;
import com.yihg.product.po.ProductGroupPrice;
import com.yihg.product.po.ProductGroupSupplier;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.ProductStock;
import com.yihg.product.vo.PriceCopyVo;
import com.yihg.product.vo.ProductPriceVo;
import com.yihg.product.vo.ProductSupplierCondition;
import com.yihg.product.vo.StockStaticCondition;
import com.yihg.supplier.constants.Constants;
/**
 * @author : 葛进军
 * @date : 2015-12-14
 * @Description: 产品价格方案二
 */
@Controller
@RequestMapping(value = "/product/price")
public class ProductPricePlusController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(ProductPricePlusController.class);

	@Autowired
	private ProductGroupService productGroupService;
	@Autowired
    private ProductGroupPriceService groupService;
	@Autowired
	private DicService dicService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private ProductInfoService productInfoService;
	@Autowired
	private ProductGroupSupplierService groupSupplierService;
	@Autowired
	private ProductStockService stockService;
	
	@RequestMapping("list.htm")
	public String toList(HttpServletRequest request,ModelMap model,ProductInfo productInfo){
		//省市
        List<RegionInfo> allProvince = regionService.getAllProvince();
        //产品名称
        Integer bizId = WebUtils.getCurBizId(request);
        List<DicInfo> brandList = dicService
                .getListByTypeCode(BasicConstants.CPXL_PP,bizId);
        model.addAttribute("allProvince",allProvince);
        model.addAttribute("brandList", brandList);
        model.addAttribute("state", productInfo.getState());
        return "product/priceplus/product_list_price";
	}
	
	@RequestMapping(value = "/priceList.do",method=RequestMethod.POST)	
	public String toSearchlist(HttpServletRequest request, ModelMap model,ProductInfo productInfo,String productName, String name,Integer page,Integer pageSize){
		//省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		//产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,bizId);
		if(page==null){
			page=1;
		}
		PageBean pageBean = new PageBean();
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}

		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters=new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		parameters.put("set", WebUtils.getDataUserIdSet(request));
	
		pageBean = productInfoService.findProductInfos(pageBean, parameters);

		//pageBean = productInfoService.findProductInfos(pageBean, bizId,name, productName,WebUtils.getCurUser(request).getOrgId());

		Map<Integer, String> priceStateMap = new HashMap<Integer, String>();
		for(Object product : pageBean.getResult()){
			ProductInfo info = (ProductInfo) product;
			Integer productId = info.getId();
			String state = productInfoService.getProductPriceState(productId);
			priceStateMap.put(info.getId(), state);
		}
		model.addAttribute("allProvince",allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("priceStateMap", priceStateMap);
		return "product/priceplus/product_list_table_price";
	}
	
	/**
	 * 组团社列表
	 * @param request
	 * @param model
	 * @param groupId
	 * @param productId
	 * @return
	 */
	@RequestMapping("supplierList.htm")
	public String toSupplierList(HttpServletRequest request,ModelMap model,Integer groupId,Integer productId){
		return "product/priceplus/product_supplier_list";
	}
	
	/**
	 * 组团社-分组列表
	 * @param request
	 * @param model
	 * @param productId
	 * @return
	 */
	@RequestMapping("groupList.htm")
	public String toGroupList(HttpServletRequest request,ModelMap model,Integer productId){
		return "product/priceplus/product_group_list";
	}
	/**
	 * @author : zhangxiaoyang
	 * @Description: 跳转至价格设置页面
	 */
	@RequestMapping(value = "/supplier_list.htm")
	// @RequiresPermissions(value=PermissionConstants.PRODUCT_PRICE)
	public String toSupplierList(ModelMap model,ProductSupplierCondition condition) {
		
		model.addAttribute("productId", condition.getProductId());
		ProductInfo productInfo = productInfoService.findProductInfoById(condition.getProductId());
		model.addAttribute("productName", "【" +productInfo.getBrandName()+"】"+productInfo.getNameCity());		
		//model.addAttribute("groupId", groupId);
		model.addAttribute("groupSuppliers", groupSupplierService.selectSupplierList(condition));
		model.addAttribute("supplierName", condition.getSupplierName());
		model.addAttribute("city", condition.getCity());
		return "product/priceplus/newSupplier";
	}
	/**
	 * 保存组团社
	 * @param data
	 * @return
	 */
	@RequestMapping(value = "/supplierSave.do",method = RequestMethod.POST)
	@ResponseBody
	public String save(String data) {
		List<ProductGroupSupplier> saveP = JSONArray.parseArray(data, ProductGroupSupplier.class);
		if(saveP.size()==0){
			return successJson();
		}
		return groupSupplierService.save(saveP) ==1?successJson():errorJson("操作失败！");
		
	}
	/**
	 * 删除组团社
	 * @param groupSupplier
	 * @return
	 */
	
	@RequestMapping(value = "/delSupplier",method = RequestMethod.POST)
	@ResponseBody
	public String delSupplier(ProductGroupSupplier groupSupplier) {
		//return groupSupplierService.update(groupSupplier)==1?successJson():errorJson("操作失败！");
		return groupSupplierService.deleteByProductSupplierId(groupSupplier.getId()) == 1?successJson():errorJson("操作失败！");
	}
	/**
	 * 跳转到添加价格组页面
	 * @param request
	 * @param response
	 * @param model
	 * @param id 产品组团社表id
	 * @param supplierName 组团社名称
	 * @return
	 */
	@RequestMapping("addPriceGroup.htm")
	public String addPriceGroup(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer id){
		List<ProductGroup> productGroups = productGroupService.selectProductGroupList(id);
		ProductInfo productInfo = productInfoService.findProductInfoBySupplierId(id);
		for (ProductGroup pGroup : productGroups) {
			List<ProductGroupPrice> groupPrices = groupService.selectProductGroupPrices(pGroup.getId(), null, null);
			pGroup.setGroupPrices(groupPrices);
			//pGroup.setRowSpan(groupPrices.size());
		}
		model.addAttribute("productGroups", productGroups);
		//try {
			//groupSupplierService.
		ProductGroupSupplier supplierInfo = groupSupplierService.selectgGroupSupplierById(id);
			model.addAttribute("supplierName", supplierInfo.getSupplierName());
			model.addAttribute("supplierId", supplierInfo.getSupplierId());
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
		model.addAttribute("groupSupplierId", id);
		model.addAttribute("productId",supplierInfo.getProductId());
		model.addAttribute("brandName", productInfo.getBrandName());
		model.addAttribute("productName", productInfo.getNameCity());
		return  "product/priceplus/newPrice";
		
	}
	@RequestMapping("savePriceGroup.do")
	@ResponseBody
	public String savePriceGroup(HttpServletRequest request,HttpServletResponse response,ModelMap model,String productGroups,Integer groupSupplierId){
		List<ProductGroup> GroupPrices = JSON.parseArray(productGroups, ProductGroup.class);
		try {
			productGroupService.save2(GroupPrices,groupSupplierId);
		} catch (Exception e) {
			return errorJson("保存失败");
		}
		return successJson();
		
	}
	
	@RequestMapping(value="copyGroups.do",method=RequestMethod.POST)
	@ResponseBody
	public String copyGroup(ModelMap model,String groupIds,String destGroupSupplierIds){
		List<Integer> groupIdList = JSON.parseArray(groupIds, Integer.class);
		List<Integer> groupSupplierIdList = JSON.parseArray(destGroupSupplierIds, Integer.class);
		productGroupService.copyGroups(groupIdList,groupSupplierIdList);
		return successJson();
	}
	
	/**
	 * 将某个产品下的组团社和价格组复制到其他产品
	 * @param request
	 * @param response
	 * @param model
	 * @param data
	 * @param productId
	 * @return
	 */
	@RequestMapping("copyProduct.do")
	@ResponseBody
	public String copyProduct(HttpServletRequest request,HttpServletResponse response,ModelMap model,String data,Integer productId){
		//获取要复制到的产品的id集合
		List<ProductInfo> productInfos = JSON.parseArray(data, ProductInfo.class);
		//获取要复制的产品下的组团社
		try {
			groupSupplierService.save(productInfos, productId);
		} catch (Exception e) {
			return errorJson("操作失败");
		}
		return successJson();
	}
	
	@RequestMapping("copyProductSuppliers.do")
	@ResponseBody
	public String copyProductSuppliers(HttpServletRequest request,HttpServletResponse response,ModelMap model,String data,Integer productId){
		//获取要复制的组团社
		List<Integer> productSupplierIdList = JSON.parseArray(data, Integer.class);		
		//获取要复制的产品下的组团社
		try {
			groupSupplierService.copyProductSuppliersToTarget(productId, productSupplierIdList);
		} catch (Exception e) {
			return errorJson("操作失败");
		}
		return successJson();
	}
	
	@RequestMapping("editStock.htm")
	public String editStock(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer productId){
		model.addAttribute("productId", productId);
		return "product/stock/product-stock-plus";
	}
	
	@RequestMapping(value="stockMonth.do",method=RequestMethod.POST)
	@ResponseBody
	public String stockMonth(ModelMap model,Integer productId,Integer year,Integer month){
		String beginDateStr = year+"-"+(month<10 ? ("0"+month):(""+month))+"-01";
    	String endDateStr = month==12 ? ((year+1)+"-01-01"):(year+"-"+(month<9 ? ("0"+(month+1)):(""+(month+1)))+"-01");    	
    	Date startDate = DateUtils.parse(beginDateStr, "yyyy-MM-dd");
    	Date endDate = DateUtils.parse(endDateStr,"yyyy-MM-dd");
		List<ProductStock> list = stockService.getStocksByProductIdAndDateSpan(productId, startDate, endDate);
		return successJson("data",JSON.toJSONString(list));
	}
	
	@RequestMapping(value="saveStock.do",method=RequestMethod.POST)
	@ResponseBody
	public String saveStock(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer productId,String stockStr,Integer year,Integer month){
		if(productId==null){
			return errorJson("产品为空");
		}
		if(StringUtils.isBlank(stockStr)){
			return errorJson("数据为空");
		}
		String beginDateStr = year+"-"+(month<10 ? ("0"+month):(""+month))+"-01";
    	String endDateStr = month==12 ? ((year+1)+"-01-01"):(year+"-"+(month<9 ? ("0"+(month+1)):(""+(month+1)))+"-01");    	
    	Date startDate = DateUtils.parse(beginDateStr, "yyyy-MM-dd");
    	Date endDate = DateUtils.parse(endDateStr,"yyyy-MM-dd");
		List<ProductStock> stockList = JSON.parseArray(stockStr, ProductStock.class);
		stockService.saveStock(productId,stockList,startDate,endDate);
		return successJson();
	}
	@RequestMapping("/stockStatics.htm")
	public String stockStatics(HttpServletRequest request, ModelMap model,
			StockStaticCondition condition) throws ParseException{
		
		String groupDate = org.apache.commons.lang.time.DateFormatUtils.format(
				new Date(), "yyyy-MM-dd");
		String toGroupDate = org.apache.commons.lang.time.DateFormatUtils
				.format(org.apache.commons.lang.time.DateUtils.addDays(
						new Date(), 6), "yyyy-MM-dd");
		model.addAttribute("groupDate", groupDate);
		model.addAttribute("toGroupDate", toGroupDate);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("brandList", brandList);
		return "product/stock/stock-statics-plus";
		
	}
	@RequestMapping("/stockStatics.do")
	public String queryStockStatics(HttpServletRequest request, ModelMap model,
			StockStaticCondition condition) throws ParseException {
		if (condition.getPageSize() == null) {
			condition.setPageSize(Constants.PAGESIZE);
		}
		if (condition.getPage() == null) {
			condition.setPage(1);
		}
		condition.setOrgId(WebUtils.getCurUser(request).getOrgId());
		condition.setBizId(WebUtils.getCurBizId(request));
		//PageBean page = productInfoService.getStockStaticsList(condition);
		PageBean page=productInfoService.getStockStaticsList2(condition);
		model.addAttribute("page", page);
		return "product/stock/stock-statics-table-plus";
	}
}
