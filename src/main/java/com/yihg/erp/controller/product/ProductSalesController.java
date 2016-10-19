package com.yihg.erp.controller.product;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.images.utils.DateUtil;
import com.yihg.erp.utils.SysConfig;
import com.yihg.product.api.ProductGroupPriceService;
import com.yihg.product.api.ProductGroupService;
import com.yihg.product.api.ProductGroupSupplierService;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductRemarkService;
import com.yihg.product.api.ProductRouteService;
import com.yihg.product.api.ProductStockService;
import com.yihg.product.po.PriceView;
import com.yihg.product.po.ProductGroup;
import com.yihg.product.po.ProductGroupSupplier;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.ProductRemark;
import com.yihg.product.po.ProductStock;
import com.yihg.product.vo.ProductInfoVo;
import com.yihg.product.vo.ProductRouteVo;

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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.utils.WebUtils;
import com.yihg.images.util.DateUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.po.ProductSales;
import com.yihg.supplier.constants.Constants;
import com.yimayhd.erpcenter.facade.service.ProductFacade;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
	private ProductInfoService productInfoService;

	@Autowired
	private ProductRouteService productRouteService;

	@Autowired
	private ProductRemarkService productRemarkService;

	@Autowired
	private ProductGroupService productGroupService;
	
	@Autowired
	private ProductGroupPriceService priceService;

	@Autowired
	private DicService dicService;
	
	@Resource
	private ProductStockService stockService;

	@Autowired
	private SysConfig config;
	
	@Autowired
	private ProductFacade productFacade;
	/****************************************组团版********************************/
	
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.SALE_SK_ADD)
	public String toList(ModelMap model,HttpServletRequest request) {
		//产品名称
		List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,WebUtils.getCurBizId(request));
		model.addAttribute("brandList", brandList);
		return "product/sales/list";
	}

	@RequestMapping(value = "/productSalesList.do")
	public String productSalesList(HttpServletRequest request, ModelMap model,ProductSales productSales,Integer page,Integer pageSize) {
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
		pageBean = productInfoService.findProductSales(pageBean, bizId,WebUtils.getCurUser(request).getOrgId());
		
		
		
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("config", config);
		return "product/sales/list_view";
	}
	
	@RequestMapping(value = "/minPrice.do")
	@ResponseBody
	public String loadMinPrice(HttpServletRequest request,String list){
		List<Integer> productIds = JSON.parseArray(list, Integer.class);
		Date date = com.yihg.images.util.DateUtils.formatDate(new Date(), com.yihg.images.util.DateUtils.FORMAT_SHORT);
		List<Map> mapList = priceService.getMinPriceByProductIdSetAndDate(productIds, date);
		return JSON.toJSONString(mapList);
	}
	
	@RequestMapping(value = "/detail.htm")
	public String detail(HttpServletRequest request,Model model, @RequestParam Integer id) {
        ProductInfoVo productInfoVo = productInfoService.findProductInfoVoById(id);
        ProductRouteVo productRouteVo = productRouteService.findByProductId(id);
		ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(id);
        //List<ProductGroup> productGroups = productGroupService.selectProductGroups(id);
		List<ProductGroup> productGroups = productGroupService.selectProductGroupsBySellerId(id,WebUtils.getCurUserId(request));

		model.addAttribute("productInfoVo", productInfoVo);
        model.addAttribute("productRouteVo", productRouteVo);
        model.addAttribute("productRemark", productRemark);
        model.addAttribute("productGroupSuppliers", productGroups);
        model.addAttribute("config", config);
        
        ProductInfo info = productInfoVo.getProductInfo();
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
        List<PriceView> priceViews = productInfoService.getPriceViewsByDate(groupId, startDate, endDate);        
        List<ProductStock> stockList = stockService.getStocksByProductIdAndDateSpan(productId, startDate, endDate);
        
        List<PriceView> newPriceList = new ArrayList<PriceView>();
        
        Map<String,PriceView> map = new HashMap<String,PriceView>();
        if(stockList!=null && stockList.size()>0){
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
        
        if(priceViews!=null && priceViews.size()>0){
        	for(PriceView price : priceViews){
        		if(price.getGroupDateTo()==null){ //旧的数据过滤掉
	        		/*if(map.containsKey(DateUtils.format(price.getGroupDate(), "yyyy-MM-dd"))){
	        			ProductStock stock = map.get(DateUtils.format(price.getGroupDate(), "yyyy-MM-dd"));
	        			price.setItemDate(price.getGroupDate());
	        			price.setStockCount(stock.getStockCount());
	        			price.setReceiveCount(stock.getReceiveCount());
	        			price.setReserveCount(stock.getReserveCount());
	        			newPriceList.add(price);
	        		}*/
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
        					}/*else{//没有库存，设置价格
        						//new 一个新对象，否则数据有问题
        						newPrice = new PriceView();
        						newPrice.setGroupId(price.getGroupId());
        						newPrice.setProductId(price.getProductId());
        						newPrice.setPriceId(price.getPriceId());
        						newPrice.setGroupDate(groupDate);
        					}
        					newPrice.setPriceSettlementAdult(price.getPriceSettlementAdult());
    						newPrice.setPriceSettlementChild(price.getPriceSettlementChild());
    						newPrice.setPriceSuggestAdult(price.getPriceSuggestAdult());
    						newPrice.setPriceSuggestChild(price.getPriceSuggestChild());
    						newPrice.setPriceCostAdult(price.getPriceCostAdult());
    						newPrice.setPriceCostChild(price.getPriceCostChild());
        					map.put(DateUtils.format(groupDate, "yyyy-MM-dd"), newPrice);*/
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
        /*Map<String,Object> map = new HashMap<String,Object>();
        map.put("price", priceViews);
        map.put("stock", stockList);
        return JSONArray.toJSONString(map);*/
    }
    
    @RequestMapping(value="/priceDate.htm")
    public String productGroupPriceDate(HttpServletRequest request,ModelMap model,Integer productId){
    	//List<ProductGroup> productGroups = productGroupService.selectProductGroups(productId);
    	List<ProductGroup> productGroups = productGroupService.selectProductGroupsBySellerId(productId,WebUtils.getCurUserId(request));
    	model.addAttribute("productGroupSuppliers", productGroups);
    	model.addAttribute("productId",productId);
    	ProductInfo info = productInfoService.findProductInfoById(productId);
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
    	//产品名称
		List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,WebUtils.getCurBizId(request));
		model.addAttribute("brandList", brandList);
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
		pageBean.setParameter(productSales);
		pageBean.setPage(page);
		pageBean = productInfoService.findProductSalesPlus(pageBean, bizId,WebUtils.getCurUser(request).getOrgId());

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
    	ProductInfoVo productInfoVo = productInfoService.findProductInfoVoById(id);
        ProductRouteVo productRouteVo = productRouteService.findByProductId(id);
		ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(id);
		model.addAttribute("productInfoVo", productInfoVo);
        model.addAttribute("productRouteVo", productRouteVo);
        model.addAttribute("productRemark", productRemark);
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
    	List<ProductStock> stockList = stockService.getStocksByProductIdAndDateSpan(productId, startDate, endDate);
        return JSONArray.toJSONString(stockList);
    }
    
    @RequestMapping(value="/groupDate.htm")
    public String productGroupDate(ModelMap model,Integer productId){
    	model.addAttribute("productId",productId);
    	return "product/priceplus/product-group-date";
    }
    
}
