package com.yihg.erp.controller.product;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.query.BrandQueryDTO;
import org.erpcenterFacade.common.client.result.BrandQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupSupplier;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.vo.ProductSupplierCondition;
import com.yimayhd.erpcenter.dal.product.vo.StockStaticCondition;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.facade.query.ProductGroupSupplierDTO;
import com.yimayhd.erpcenter.facade.query.ProductStockStaticDto;
import com.yimayhd.erpcenter.facade.query.ProductSupplierConditionDTO;
import com.yimayhd.erpcenter.facade.result.ResultSupport;
import com.yimayhd.erpcenter.facade.result.ToAddPriceGroupResult;
import com.yimayhd.erpcenter.facade.result.ToSupplierListResult;
import com.yimayhd.erpcenter.facade.service.ProductFacade;
import com.yimayhd.erpcenter.facade.service.ProductPricePlusFacade;
import com.yimayhd.erpcenter.facade.service.ProductStockFacade;

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
	private ProductStockFacade productStockFacade;
	@Autowired
	private ProductPricePlusFacade productPricePlusFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private ProductFacade productFacade;
	
	@RequestMapping("list.htm")
	public String toList(HttpServletRequest request,ModelMap model,ProductInfo productInfo){
		
		//省市
        List<RegionInfo> allProvince = regionService.getAllProvince();
        //产品名称
        Integer bizId = WebUtils.getCurBizId(request);
        
        BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
        brandQueryDTO.setBizId(bizId);
        BrandQueryResult result = productCommonFacade.brandQuery(brandQueryDTO);
        
        model.addAttribute("allProvince",allProvince);
        model.addAttribute("brandList", result.getBrandList());
        model.addAttribute("state", productInfo.getState());
        return "product/priceplus/product_list_price";
	}
	
	@RequestMapping(value = "/priceList.do",method=RequestMethod.POST)	
	public String toSearchlist(HttpServletRequest request, ModelMap model,ProductInfo productInfo,String productName, String name,Integer page,Integer pageSize){
		//省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		//产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
        brandQueryDTO.setBizId(bizId);
        BrandQueryResult brandQueryResult = productCommonFacade.brandQuery(brandQueryDTO);
        
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
		model.addAttribute("brandList", brandQueryResult.getBrandList());
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
		
		ProductSupplierConditionDTO conditionDTO = new ProductSupplierConditionDTO();
		conditionDTO.setCondition(condition);
		ToSupplierListResult result = productPricePlusFacade.toSupplierList(conditionDTO);
		
		model.addAttribute("productId", condition.getProductId());
		model.addAttribute("productName", result.getProductName());		
		//model.addAttribute("groupId", groupId);
		model.addAttribute("groupSuppliers", result.getGroupSuppliers());
		model.addAttribute("supplierName", condition.getSupplierName());
		model.addAttribute("city", condition.getSupplierName());
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
		
		ResultSupport result = productPricePlusFacade.supplierSave(data);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("操作失败！");
	}
	/**
	 * 删除组团社
	 * @param groupSupplier
	 * @return
	 */
	
	@RequestMapping(value = "/delSupplier",method = RequestMethod.POST)
	@ResponseBody
	public String delSupplier(ProductGroupSupplier groupSupplier) {
		
		ProductGroupSupplierDTO productGroupSupplierDTO = new ProductGroupSupplierDTO();
		productGroupSupplierDTO.setGroupSupplier(groupSupplier);
		ResultSupport result = productPricePlusFacade.delSupplier(productGroupSupplierDTO);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("操作失败！");
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
		
		ToAddPriceGroupResult addPriceGroupResult = productPricePlusFacade.addPriceGroup(id);
		
		model.addAttribute("productGroups", addPriceGroupResult.getProductGroups());
		model.addAttribute("supplierName", addPriceGroupResult.getSupplierName());
		model.addAttribute("supplierId", addPriceGroupResult.getSupplierId());
		model.addAttribute("groupSupplierId", id);
		model.addAttribute("productId",addPriceGroupResult.getProductId());
		model.addAttribute("brandName", addPriceGroupResult.getBrandName());
		model.addAttribute("productName", addPriceGroupResult.getProductName());
		return  "product/priceplus/newPrice";
		
	}
	@RequestMapping("savePriceGroup.do")
	@ResponseBody
	public String savePriceGroup(HttpServletRequest request,HttpServletResponse response,ModelMap model,String productGroups,Integer groupSupplierId){
		
		
		ResultSupport result = productPricePlusFacade.savePriceGroup(productGroups, groupSupplierId);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("保存失败");
	}
	
	@RequestMapping(value="copyGroups.do",method=RequestMethod.POST)
	@ResponseBody
	public String copyGroup(ModelMap model,String groupIds,String destGroupSupplierIds){
		ResultSupport result = productPricePlusFacade.copyGroup(groupIds, destGroupSupplierIds);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("操作失败");
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
	@Deprecated
	public String copyProduct(HttpServletRequest request,HttpServletResponse response,ModelMap model,String data,Integer productId){
		
		ResultSupport result = productPricePlusFacade.copyProduct(data, productId);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("操作失败");
	}
	
	@RequestMapping("copyProductSuppliers.do")
	@ResponseBody
	public String copyProductSuppliers(HttpServletRequest request,HttpServletResponse response,ModelMap model,String data,Integer productId){
		
		ResultSupport result = productPricePlusFacade.copyProductSuppliers(data, productId);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("操作失败");
	}
	
	@RequestMapping("editStock.htm")
	public String editStock(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer productId){
		model.addAttribute("productId", productId);
		return "product/stock/product-stock-plus";
	}
	
	@RequestMapping(value="stockMonth.do",method=RequestMethod.POST)
	@ResponseBody
	public String stockMonth(ModelMap model,Integer productId,Integer year,Integer month){
		
		String result = productPricePlusFacade.stockMonth(productId, year, month);
		return successJson("data", result);
	}
	
	@RequestMapping(value="saveStock.do",method=RequestMethod.POST)
	@ResponseBody
	public String saveStock(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer productId,String stockStr,Integer year,Integer month){
		
		ResultSupport result = productPricePlusFacade.saveStock(productId, stockStr, year, month);
		if(result.isSuccess()){
			return successJson();
		}
		return errorJson("操作失败");
	}
	/**
	 * 
	 * 描述：产品库存跳转页面
	 * @author liyong
	 * 2016年10月19日 
	 * @param request
	 * @param model
	 * @param condition查询的封装对象
	 * @return
	 * @throws ParseException
	 */
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
		BrandQueryDTO dto  = new BrandQueryDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult brandResult = productCommonFacade.brandQuery(dto);
//		List<DicInfo> brandList = dicService.getListByTypeCode(
//				BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		List<DicInfo> brandList = brandResult.getBrandList();
		model.addAttribute("brandList", brandList);
		return "product/stock/stock-statics-plus";
		
	}
	/**
	 * 
	 * 描述：产品库存查询 调用facade
	 * @author liyong
	 * 2016年10月19日 
	 * @param request
	 * @param model
	 * @param condition 
	 * @return 产品库存页面
	 * @throws ParseException
	 */
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
		ProductStockStaticDto dto = new ProductStockStaticDto();
				dto.setCondition(condition);
		PageBean page=productStockFacade.getStockStaticsListNew(dto);
		model.addAttribute("page", page);
		return "product/stock/stock-statics-table-plus";
	}
}
