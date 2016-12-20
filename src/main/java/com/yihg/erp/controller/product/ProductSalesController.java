package com.yihg.erp.controller.product;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSONObject;
import com.yimayhd.erpcenter.dal.product.po.*;
import com.yimayhd.erpcenter.dal.product.vo.ProductTagVo;
import com.yimayhd.erpcenter.facade.result.ToProductTagResult;
import org.erpcenterFacade.common.client.query.BrandQueryDTO;
import org.erpcenterFacade.common.client.result.BrandQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.images.utils.DateUtil;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.common.util.DateUtils;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.facade.query.DetailDTO;
import com.yimayhd.erpcenter.facade.result.DetailResult;
import com.yimayhd.erpcenter.facade.result.ProductInfoResult;
import com.yimayhd.erpcenter.facade.service.ProductFacade;
import com.yimayhd.erpcenter.facade.service.ProductPricePlusFacade;
import com.yimayhd.erpcenter.facade.service.ProductStockFacade;
import com.yimayhd.erpcenter.facade.service.ProductUpAndDownFrameFacade;

/**
 * @author : xuzejun
 * @date : 2015年7月22日 下午3:06:44
 * @Description: 产品管理基本信息
 */
@Controller
@RequestMapping(value = "/productSales")
public class ProductSalesController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(ProductSalesController.class);


	@Autowired
	private SysConfig config;
	
	@Autowired
	private ProductFacade productFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;

	@Autowired
	private ProductUpAndDownFrameFacade productUpAndDownFrameFacade;
	@Autowired
	private ProductPricePlusFacade productPricePlusFacade;
	@Autowired
	private ProductStockFacade productStockFacade;
	/****************************************组团版********************************/
	
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_ADD)
	public String toList(ModelMap model,HttpServletRequest request) {
		BrandQueryDTO brandQueryDTO  = new BrandQueryDTO();
		brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
		BrandQueryResult brandList = productCommonFacade.brandQuery(brandQueryDTO);
		model.addAttribute("brandList", brandList.getBrandList());
		ToProductTagResult result = productFacade.getProductTags(WebUtils.getCurBizId(request));

		model.addAttribute("lineThemeList", result.getLineThemeListPlus());
		model.addAttribute("lineLevelList", result.getLineLevelListPlus());
		model.addAttribute("attendMethodList", result.getAttendMethodListPlus());
		model.addAttribute("hotelLevelList", result.getHotelLevelListPlus());
		model.addAttribute("daysPeriodList", result.getDaysPeriodListPlus());
		model.addAttribute("priceRangeList", result.getPriceRangeListPlus());
		model.addAttribute("exitDestinationList", result.getExitDestinationListPlus());
		model.addAttribute("domesticDestinationList", result.getDomesticDestinationListPlus());
		model.addAttribute("typeList", result.getTypeListPlus());
		return "product/sales/list";
	}

	@RequestMapping(value = "/productSalesList.do")
	public String productSalesList(HttpServletRequest request, ModelMap model,ProductSales productSales,Integer page,Integer pageSize) {
		ProductTagVo productTagVo = JSONObject.parseObject(productSales.getProductTagVo(), ProductTagVo.class);

		List<ProductTag> tabList = productTagVo.getProductTags();
		Set<String> strSet = new HashSet<String>();
		for(ProductTag tagBean:tabList){
			strSet.add(tagBean.getTagName());
		}
		if(strSet.size()>0 ){
			productSales.setStrSet(strSet);
		}else {
			productSales.setStrSet(null);
		}
		Integer bizId = WebUtils.getCurBizId(request);
		if(page==null){
			page=1;
		}
		PageBean pageBean = new PageBean();
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setParameter(productSales);
		pageBean.setPage(page);
		pageBean = productFacade.findProductSales(pageBean, bizId,WebUtils.getCurUser(request).getOrgId());
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("config", config);
		return "product/sales/list_view";
	}
	
	@RequestMapping(value = "/minPrice.do")
	@ResponseBody
	public String loadMinPrice(HttpServletRequest request,String list){
		List<Integer> productIds = JSON.parseArray(list, Integer.class);
		Date date = DateUtils.formatDate(new Date(), DateUtils.FORMAT_SHORT);
		List<Map> mapList = productPricePlusFacade.loadMinPrice(productIds, date);
		return JSON.toJSONString(mapList);
	}
	
	@RequestMapping(value = "/detail.htm")
	public String detail(HttpServletRequest request,Model model, @RequestParam Integer id) {
		DetailDTO detailDTO = new DetailDTO();
		detailDTO.setId(id);
		DetailResult detailResult = productUpAndDownFrameFacade.detail(detailDTO);

		model.addAttribute("productInfoVo", detailResult.getProductInfoVo());
        model.addAttribute("productRouteVo", detailResult.getProductRouteVo());
        model.addAttribute("productRemark", detailResult.getProductRemark());
        model.addAttribute("productGroupSuppliers", detailResult.getProductGroups());
        model.addAttribute("config", config);

		ProductInfo info = detailResult.getProductInfoVo().getProductInfo();
    	if(info.getObligate()==null){
    		info.setObligate(0);
    	}    	
    	model.addAttribute("isReserve", info.getObligate());
    	model.addAttribute("reserve_hour", info.getObligateHour());
    	model.addAttribute("reserve_count", info.getObligateCount());
    	model.addAttribute("reserve_remark", info.getObligateRemark());
        
        return "product/sales/product_detail";
	}

    @RequestMapping(value = "/priceData.do", method = RequestMethod.POST)
    @ResponseBody
    public String priceData(Model model,Integer productId, @RequestParam Integer groupId, @RequestParam Integer year, @RequestParam Integer month){
    	String beginDateStr = year+"-"+(month<10 ? ("0"+month):(""+month))+"-01";
    	String endDateStr = month==12 ? ((year+1)+"-01-01"):(year+"-"+(month<9 ? ("0"+(month+1)):(""+(month+1)))+"-01");    	
    	Date startDate = DateUtils.parse(beginDateStr, "yyyy-MM-dd");
    	Date endDate = DateUtils.parse(endDateStr,"yyyy-MM-dd");
        ProductInfoResult result = productStockFacade.priceData(productId, groupId, startDate, endDate);
        List<PriceView> newPriceList = new ArrayList<PriceView>();
        List<ProductStock> stockList = result.getProductStocks();
        Map<String,PriceView> map = new HashMap<String,PriceView>();
        if(!CollectionUtils.isEmpty(stockList)){
        	for(ProductStock stock : stockList){
        		PriceView newPrice = new PriceView();
        		newPrice.setProductId(stock.getProductId());
        		newPrice.setGroupDate(stock.getItemDate());
        		newPrice.setStockCount(stock.getStockCount());
				newPrice.setReceiveCount(stock.getReceiveCount());
				newPrice.setReserveCount(stock.getReserveCount());
        		map.put(DateUtils.format(stock.getItemDate(), "yyyy-MM-dd"), newPrice);
        	}
        }
        
        int days = DateUtil.getIntervalDays(endDate, startDate);
        List<PriceView> priceViews = result.getPriceViews();
        if(!CollectionUtils.isEmpty(priceViews)){
        	for(PriceView price : priceViews){
        		if(price.getGroupDateTo()==null){ //旧的数据过滤掉
        			continue;
        		}else{
        			//直接遍历当前月份的天数
        			for(int i=0;i<days;i++){
        				Date groupDate = DateUtils.addDay(startDate, i);
        				if(groupDate.compareTo(price.getGroupDate())>=0 && groupDate.compareTo(price.getGroupDateTo())<=0){
        					PriceView newPrice = null;
        					if(map.containsKey(DateUtils.format(groupDate, "yyyy-MM-dd"))){//有库存，设置价格
        						newPrice = map.get(DateUtils.format(groupDate, "yyyy-MM-dd"));
        						newPrice.setGroupId(price.getGroupId());
        						newPrice.setPriceId(price.getPriceId());   
        						
        						newPrice.setPriceSettlementAdult(price.getPriceSettlementAdult());
        						newPrice.setPriceSettlementChild(price.getPriceSettlementChild());
        						newPrice.setPriceSuggestAdult(price.getPriceSuggestAdult());
        						newPrice.setPriceSuggestChild(price.getPriceSuggestChild());
        						newPrice.setPriceCostAdult(price.getPriceCostAdult());
        						newPrice.setPriceCostChild(price.getPriceCostChild());
            					map.put(DateUtils.format(groupDate, "yyyy-MM-dd"), newPrice);
        					}
        				}
        			}
        		}
        	}
        }
        
        if(!map.isEmpty()){
        	for(Map.Entry<String, PriceView> entry : map.entrySet()){
        		newPriceList.add(entry.getValue());
        	}
        }
        
        return JSONArray.toJSONString(newPriceList);

    }
    
    @RequestMapping(value="/priceDate.htm")
    public String productGroupPriceDate(HttpServletRequest request,ModelMap model,Integer productId){
    	ProductInfoResult result = productStockFacade.productGroupPriceDate(productId, WebUtils.getCurUserId(request));
    	model.addAttribute("productGroupSuppliers", result.getProductGroups());
    	model.addAttribute("productId",productId);
    	ProductInfo info = result.getProductInfo();
    	if(info.getObligate()==null){
    		info.setObligate(0);
    	}    	
    	model.addAttribute("isReserve", info.getObligate());
    	model.addAttribute("reserve_hour", info.getObligateHour());
    	model.addAttribute("reserve_count", info.getObligateCount());
    	model.addAttribute("reserve_remark", info.getObligateRemark());
    	return "product/sales/product-group-date";
    }
    
    /****************************************地接版********************************/
    @RequestMapping(value = "/saleList.htm")
    public String saleList(ModelMap model,HttpServletRequest request){
    	BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
    	brandQueryDTO.setBizId(WebUtils.getCurBizId(request));
    	BrandQueryResult queryResult = productCommonFacade.brandQuery(brandQueryDTO);
		model.addAttribute("brandList",queryResult.getBrandList());
		ToProductTagResult result = productFacade.getProductTags(WebUtils.getCurBizId(request));

		model.addAttribute("lineThemeList", result.getLineThemeListPlus());
		model.addAttribute("lineLevelList", result.getLineLevelListPlus());
		model.addAttribute("attendMethodList", result.getAttendMethodListPlus());
		model.addAttribute("hotelLevelList", result.getHotelLevelListPlus());
		model.addAttribute("daysPeriodList", result.getDaysPeriodListPlus());
		model.addAttribute("priceRangeList", result.getPriceRangeListPlus());
		model.addAttribute("exitDestinationList", result.getExitDestinationListPlus());
		model.addAttribute("domesticDestinationList", result.getDomesticDestinationListPlus());
		model.addAttribute("typeList", result.getTypeListPlus());
		return "product/sales/list_plus";
    }
    
    @RequestMapping(value = "/saleListView.do")
	public String saleListView(HttpServletRequest request, ModelMap model,ProductSales productSales,Integer page,Integer pageSize) {
		Integer bizId = WebUtils.getCurBizId(request);
		if(page==null){
			page=1;
		}
		PageBean pageBean = new PageBean();
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		ProductTagVo productTagVo = JSONObject.parseObject(productSales.getProductTagVo(), ProductTagVo.class);

		List<ProductTag> tabList = productTagVo.getProductTags();
		Set<String> strSet = new HashSet<String>();
		for(ProductTag tagBean:tabList){
			strSet.add(tagBean.getTagName());
		}
		if(strSet.size()>0 ){
			productSales.setStrSet(strSet);
		}else {
			productSales.setStrSet(null);
		}
		pageBean.setParameter(productSales);
		pageBean.setPage(page);
		pageBean = productStockFacade.findProductSalesPlus(pageBean, bizId,WebUtils.getCurUser(request).getOrgId());

		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("config", config);
		return "product/sales/list_plus_view";
	}
    /**
     * 
    * created by zhangxiaoyang
    * @date 2016年10月19日
    * @Description:产品列表/预览
    * @param 
    * @return String
    * @throws
     */
    @RequestMapping("info.htm")
    public String productInfo(ModelMap model, @RequestParam Integer id){
    	ProductInfoResult result = productFacade.toProductPreview(id);

		model.addAttribute("productInfoVo", result.getProductInfoVo());
        model.addAttribute("productRouteVo", result.getProductRouteVo());
        model.addAttribute("productRemark", result.getProductRemark());
        model.addAttribute("config", config);
        return "product/priceplus/product_detail";
    }
    
    @RequestMapping(value = "/stock.do", method = RequestMethod.POST)
    @ResponseBody
    public String stockData(Model model, @RequestParam Integer productId, @RequestParam Integer year, @RequestParam Integer month){
    	String beginDateStr = year+"-"+(month<10 ? ("0"+month):(""+month))+"-01";
    	String endDateStr = month==12 ? ((year+1)+"-01-01"):(year+"-"+(month<9 ? ("0"+(month+1)):(""+(month+1)))+"-01");    	
    	Date startDate = DateUtils.parse(beginDateStr, "yyyy-MM-dd");
    	Date endDate = DateUtils.parse(endDateStr,"yyyy-MM-dd");
    	List<ProductStock> stockList = productStockFacade.getStocksByProductIdAndDateSpan(productId, startDate, endDate);
        return JSONArray.toJSONString(stockList);
    }
    
    @RequestMapping(value="/groupDate.htm")
    public String productGroupDate(ModelMap model,Integer productId){
    	model.addAttribute("productId",productId);
    	return "product/priceplus/product-group-date";
    }
    
}
