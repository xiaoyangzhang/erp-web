package com.yihg.erp.controller.product;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.OpenPlatformConstannt;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.erp.utils.WordReporter;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.po.BookingSupplier;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.product.api.ProductGroupSellerService;
import com.yihg.product.api.ProductGroupService;
import com.yihg.product.api.ProductGroupSupplierService;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductRemarkService;
import com.yihg.product.api.ProductRouteService;
import com.yihg.product.po.ProductGroup;
import com.yihg.product.po.ProductGroupPrice;
import com.yihg.product.po.ProductGroupSeller;
import com.yihg.product.po.ProductGroupSupplier;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.ProductRemark;
import com.yihg.product.po.ProductRight;
import com.yihg.product.po.ProductRoute;
import com.yihg.product.vo.ProductGroupSupplierVo;
import com.yihg.product.vo.ProductInfoVo;
import com.yihg.product.vo.ProductRouteVo;
import com.yihg.product.vo.StockStaticCondition;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.po.GroupRoute;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.PlatformOrgPo;
import com.yihg.sys.po.SysBizBankAccount;

import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author : xuzejun
 * @date : 2015年7月1日 下午3:06:44
 * @Description: 产品管理基本信息
 */
@Controller
@RequestMapping(value = "/productInfo")
public class ProductInfoController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(ProductInfoController.class);

	@Autowired
	private ProductInfoService productInfoService;
	@Autowired
	private ProductRouteService productRouteService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SysConfig config;
	@Resource
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private ProductRemarkService productRemarkService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private ProductGroupService productGroupService;
	@Autowired
	private ProductGroupSupplierService groupSupplierService;
	@Autowired
	private ProductGroupSellerService sellerService;

	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至产品管理页面
	 */
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.PRODUCT_LIST)
	// public String toList( ModelMap model,ProductInfo productInfo,String
	// name,Integer page) {
	public String toList(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo) {
		// 省市
		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		/*
		 * if(page==null){ page=1; } PageBean pageBean = new PageBean();
		 * pageBean.setPageSize(Constants.PAGESIZE);
		 * pageBean.setParameter(productInfo); pageBean.setPage(page); pageBean
		 * = productInfoService.findProductInfos(pageBean, bizId,name,
		 * productName);
		 */
		
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));

		// model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("state", productInfo.getState());
		/* model.addAttribute("page", pageBean); */
		return "product/product_list";
	}

	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至产品管理页面
	 */
	@RequestMapping(value = "/listPrice.htm")
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	// public String toList( ModelMap model,ProductInfo productInfo,String
	// name,Integer page) {
	public String toListPrice(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo) {
		// 省市
		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		/*
		 * if(page==null){ page=1; } PageBean pageBean = new PageBean();
		 * pageBean.setPageSize(Constants.PAGESIZE);
		 * pageBean.setParameter(productInfo); pageBean.setPage(page); pageBean
		 * = productInfoService.findProductInfos(pageBean, bizId,name,
		 * productName);
		 */
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));

		// model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("state", productInfo.getState());
		/* model.addAttribute("page", pageBean); */

		return "product/product_list_price";
	}

	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至产品管理页面
	 */
	@RequestMapping(value = "/listState.htm")
	@RequiresPermissions(PermissionConstants.PRODUCT_SHELF)
	// public String toList( ModelMap model,ProductInfo productInfo,String
	// name,Integer page) {
	public String toListState(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo) {
		// 省市
		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		/*
		 * if(page==null){ page=1; } PageBean pageBean = new PageBean();
		 * pageBean.setPageSize(Constants.PAGESIZE);
		 * pageBean.setParameter(productInfo); pageBean.setPage(page); pageBean
		 * = productInfoService.findProductInfos(pageBean, bizId,name,
		 * productName);
		 */
		// model.addAttribute("allProvince", allProvince);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));

		model.addAttribute("brandList", brandList);
		model.addAttribute("state", productInfo.getState());
		/* model.addAttribute("page", pageBean); */
		return "product/product_list_state";
	}

	/**
	 * @author : ouzy
	 * @date : 2016年9月12日 
	 * @Description: 组团中心-产品列表
	 */
	@RequestMapping(value = "/productZTlist.htm")
	@RequiresPermissions(PermissionConstants.PRODUCT_LIST_ZT)
	public String productZTlist(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(BasicConstants.CPXL_PP, bizId);
		model.addAttribute("orgJsonStr",orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("brandList", brandList);

		return "product/productZT_list";
	}
	
	@RequestMapping(value = "/productZTList.do")
	public String productZTList(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo, String productName, String name,
			Integer page, Integer pageSize) {
		// 省市
		//List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(BasicConstants.CPXL_PP, bizId);
		if (page == null) {
			page = 1;
		}
		PageBean pageBean = new PageBean();
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		if (StringUtils.isBlank(productInfo.getOperatorIds())
				&& StringUtils.isNotBlank(productInfo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = productInfo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				productInfo.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters = new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		parameters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean = productInfoService.findProductInfos2(pageBean, parameters);

		//model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("priceMode", getPriceMode(request));
		model.addAttribute("userId", WebUtils.getCurUser(request).getEmployeeId());
		
		return "product/productZT_list_table";
	}
	
	/**
	 * @author : zhoumi
	 * @date : 2016年9月7日 
	 * @Description: 跳转至爱游产品管理页面
	 */
	@RequestMapping(value = "/productAYlist.htm")
	@RequiresPermissions(PermissionConstants.PRODUCT_LIST_AIYOU)
	public String productAYlist(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		model.addAttribute("brandList", brandList);
		model.addAttribute("state", productInfo.getState());
		return "product/productAY_list";
	}
	
	@RequestMapping(value = "/productAYList.do")
	public String productAYList(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo, String productName, String name,
			Integer page, Integer pageSize) {
		// 省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		if (page == null) {
			page = 1;
		}
		PageBean pageBean = new PageBean();
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		if (StringUtils.isBlank(productInfo.getOperatorIds())
				&& StringUtils.isNotBlank(productInfo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = productInfo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				productInfo.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters = new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		parameters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean = productInfoService.findProductInfos2(pageBean, parameters);
		Map<Integer, String> priceStateMap = new HashMap<Integer, String>();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("priceStateMap", priceStateMap);
		model.addAttribute("priceMode", getPriceMode(request));
		model.addAttribute("apiPath", OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("Url"));
		model.addAttribute("userId", WebUtils.getCurUser(request).getEmployeeId());
		
		//从爱游接口读取产品消息
		Set<Integer> pidSet = new HashSet<Integer>();
		for(ProductInfo item : (List<ProductInfo>) pageBean.getResult()){
			pidSet.add(item.getProductSysId());
		}
		String ids = "";
		if (!pidSet.isEmpty())
		{
			ids = StringUtils.join(pidSet.toArray(), ",");
			// ids = ids.substring(0, ids.length()-1);
		}
		if ("".equals(ids))
			ids = "0";

		//若接口连接不上，会造成无限等待  建义放到前台jsonp 请求数据；
		//http://localhost:48898/PubFunction/aiyouAPI.ashx?appKey=LVDAOERP&method=getProductMsgCount&param=13&uid=1 Url apiPath appKey
		//String MsgStr = httpAiyouProduct_Access("getProductMsgCount", ids, WebUtils.getCurUser(request).getEmployeeId());
		String MsgStr = OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("Url") + OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("apiPath")+"?appKey="+OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("appKey")
				+"&method=getProductMsgCount&param="+ids+"&uid="+WebUtils.getCurUser(request).getEmployeeId();
		model.addAttribute("aiyouProduct_Msg", MsgStr);
		
		return "product/productAY_list_table";
	}
	
	@RequestMapping(value = "/updateAYSysId.do")
	@ResponseBody
	public String updateAYSysId(HttpServletRequest request,Integer productId ,Integer productSysId) {
		productInfoService.updateProductSysId(productId, productSysId);
		return "product/productAY_list_table";
	}
	
	@RequestMapping(value = "/import_productAY.htm")
	public String productAYlist(HttpServletRequest request, ModelMap model) { 
		model.addAttribute("apiPath", OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("Url")+ OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("apiPath"));
		model.addAttribute("appKey", OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("appKey"));
		
		return "product/import_productAY";
	}
	
	/**
	 * 访问爱游产品系统
	 * @param method：getProductList、getProductDetail、getProductMsgCount
	 * @param param：当method=getProductList时，param表示产品名称或产品编码
            当method=getProductDetil时，param表示ids，如：12,456,12
            当method=getProductMsgCount时，param表示ids，如1,2,3
     * @param uid ：表示erp系统当前登录人id，只有method=getProductMsgCount时有用
	 * @return
	 */
	private String httpAiyouProduct_Access(String method, String param, Integer uid){
		String apiUrl = OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("Url")+ OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("apiPath");
		String appKey = OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("appKey");
		String resultString = "";
		 
		//从接口调用爱游产品系统数据
        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(apiUrl);
       
        List<NameValuePair> nameValuePairList = new ArrayList<NameValuePair>();
        nameValuePairList.add(new BasicNameValuePair("appKey", appKey));
        nameValuePairList.add(new BasicNameValuePair("method", method));
        nameValuePairList.add(new BasicNameValuePair("param", param));
        nameValuePairList.add(new BasicNameValuePair("uid", uid.toString()));
        
       	try {
       			httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList, "utf-8"));
       			CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);
    	        
    	        try {
    	            HttpEntity httpEntity = closeableHttpResponse.getEntity();
    	            resultString = EntityUtils.toString(httpEntity);
    	        } finally {
    	            closeableHttpResponse.close();
    	        }
	        
		} catch (Exception e) {
			log.error("读取爱游产品系统接口失败：" + e.getMessage());
			return errorJson("读取爱游产品系统接口失败："+e.getMessage());
		}
       	return resultString;
	}
	
	@RequestMapping(value = "/import_productAY_getProductList.do")
	@ResponseBody
	public String productAY_GetProductList(HttpServletRequest request, ModelMap model, String txtcode){
		txtcode = txtcode.trim();
		 String resultString = httpAiyouProduct_Access("getProductList", txtcode, WebUtils.getCurUser(request).getEmployeeId());
		/* 
		String apiUrl = OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("Url")+ OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("apiPath");
		String appKey = OpenPlatformConstannt.AIYOU_PRODUCT_APIMap.get("appKey");
		String urlParam = "?appKey="+appKey+"&method=getProductList&param="+txtcode;
		 // 访问接口
        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet(apiUrl+urlParam);
        // 访问参数
        String resultString = "";
        try
        {
	        CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpGet);
	        try {
	            HttpEntity httpEntity = closeableHttpResponse.getEntity();
	            resultString = EntityUtils.toString(httpEntity);
	            
	        } finally {
	            closeableHttpResponse.close();
	        }
		} catch (Exception e) {
			log.error("调用爱游产品系统接口错误:" + e.getMessage());
			return errorJson("调用爱游产品系统接口错误");
		}
		*/
        return resultString;
	}

	@RequestMapping(value = "/import_productAY_getProductImport.do")
	@ResponseBody
	public String productAY_GetProductImport(HttpServletRequest request, ModelMap model, String productIds){
		if ("".equals(productIds.trim())) 
			productIds = "0";
		else
			productIds = productIds.trim().substring(0, productIds.length()-1);
		//将返回的数据 插入或更新到 product_info表中
		 String resultString = httpAiyouProduct_Access("getProductDetail", productIds, WebUtils.getCurUser(request).getEmployeeId());
       	if (!"".equals(resultString)){
       		JSONArray jsonAry = JSON.parseArray(resultString);
       		//TODO 
       		ProductInfo info =null;
       		ProductRemark remark=null;
       		ProductRoute route=null;
       		for(int i = 0;i < jsonAry.size();i++){
       		JSONObject lineObj = jsonAry.getJSONObject(i);
       		ProductInfo product=productInfoService.selectProductInfoByPsId(lineObj.getInteger("pid"));
       		if(product!=null&&product.getId()>0){	
       			product.setCode(lineObj.getString("pcode"));
       			product.setNameCity(lineObj.getString("pname"));
       			product.setTravelDays(lineObj.getInteger("pday"));
       			product.setState((byte) 2);
       			product.setProductSysId(lineObj.getInteger("pid"));
       			product.setBizId(WebUtils.getCurBizId(request));
       			product.setCreatorName(WebUtils.getCurUser(request).getName());
       			product.setCreatorId(WebUtils.getCurUserId(request));
       			product.setCreateTime(new Date().getTime());
           		productInfoService.updateProductInfo(product);
           		// product_remark表
           		ProductRemark proRe= productRemarkService.findProductRemarkByProductId(product.getId());
           		if(proRe!=null&&proRe.getId()>0){
           			proRe.setGuestNote(lineObj.getString("r_detail"));
           			proRe.setProductFeature(lineObj.getString("pkind"));
           			proRe.setItemInclude(lineObj.getString("r_include"));
           			proRe.setChildPlan(lineObj.getString("r_child"));
           			proRe.setShoppingPlan(lineObj.getString("r_shopping"));
           			proRe.setItemCharge(lineObj.getString("r_selfpay"));
           			proRe.setItemFree(lineObj.getString("r_donate"));
           			proRe.setAttention(lineObj.getString("r_rule"));
               		proRe.setItemOther(lineObj.getString("r_hotel"));
               		proRe.setItemExclude(lineObj.getString("r_include_not"));
               		proRe.setEatNote(lineObj.getString("r_food"));
               		proRe.setCarNote(lineObj.getString("r_car"));
               		proRe.setGuideNote(lineObj.getString("r_guide"));
               		proRe.setInsuranceNote(lineObj.getString("r_insure"));
               		proRe.setAppointRule(lineObj.getString("r_booking_rule"));
               		proRe.setRemarkInfo(lineObj.getString("r_other"));
               		productRemarkService.saveProductRemark(proRe);
           		}else{
           			remark=new ProductRemark();
               		remark.setGuestNote(lineObj.getString("r_detail"));
               		remark.setProductFeature(lineObj.getString("pkind"));
               		remark.setItemInclude(lineObj.getString("r_include"));
               		remark.setChildPlan(lineObj.getString("r_child"));
               		remark.setShoppingPlan(lineObj.getString("r_shopping"));
               		remark.setItemCharge(lineObj.getString("r_selfpay"));
               		remark.setItemFree(lineObj.getString("r_donate"));
               		remark.setAttention(lineObj.getString("r_rule"));
               		remark.setItemOther(lineObj.getString("r_hotel"));
               		remark.setItemExclude(lineObj.getString("r_include_not"));
               		remark.setEatNote(lineObj.getString("r_food"));
               		remark.setCarNote(lineObj.getString("r_car"));
               		remark.setGuideNote(lineObj.getString("r_guide"));
               		remark.setInsuranceNote(lineObj.getString("r_insure"));
               		remark.setAppointRule(lineObj.getString("r_booking_rule"));
               		remark.setRemarkInfo(lineObj.getString("r_other"));
             		remark.setProductId(product.getId());
               		productRemarkService.saveProductRemark(remark);
           		}
       		}else{
       		info=new ProductInfo();
       		info.setCode(lineObj.getString("pcode"));
       		info.setNameCity(lineObj.getString("pname"));
       		info.setTravelDays(lineObj.getInteger("pday"));
       		info.setState((byte) 2);
       		info.setProductSysId(lineObj.getInteger("pid"));
       		info.setBizId(WebUtils.getCurBizId(request));
       		info.setCreatorName(WebUtils.getCurUser(request).getName());
       		info.setCreatorId(WebUtils.getCurUserId(request));
       		info.setCreateTime(new Date().getTime());
     		remark=new ProductRemark();
       		remark.setGuestNote(lineObj.getString("r_detail"));
       		remark.setProductFeature(lineObj.getString("pkind"));
       		remark.setItemInclude(lineObj.getString("r_include"));
       		remark.setChildPlan(lineObj.getString("r_child"));
       		remark.setShoppingPlan(lineObj.getString("r_shopping"));
       		remark.setItemCharge(lineObj.getString("r_selfpay"));
       		remark.setItemFree(lineObj.getString("r_donate"));
       		remark.setAttention(lineObj.getString("r_rule"));
       		remark.setItemOther(lineObj.getString("r_hotel"));
       		remark.setItemExclude(lineObj.getString("r_include_not"));
       		remark.setEatNote(lineObj.getString("r_food"));
       		remark.setCarNote(lineObj.getString("r_car"));
       		remark.setGuideNote(lineObj.getString("r_guide"));
       		remark.setInsuranceNote(lineObj.getString("r_insure"));
       		remark.setAppointRule(lineObj.getString("r_booking_rule"));
       		remark.setRemarkInfo(lineObj.getString("r_other"));
       		int id=productInfoService.insertSelective(info);
       		// product_remark表
       		remark.setProductId(id);
       		productRemarkService.saveProductRemark(remark);
       		for(int a=0;a<info.getTravelDays();a++){
           		route =new ProductRoute();
           		route.setProductId(id);
           		route.setDayNum(a+1);
           		route.setBreakfast("");
           		route.setLunch("");
           		route.setSupper("");
           		route.setHotelId(0);
           		route.setHotelName("");
           		route.setRouteDesp("");
           		route.setRouteTip("");
           		route.setRouteShort("");
       			productRouteService.saveProductRoute1(route);
       		}   	
   			}
       		}
       	}
       	
		return resultString;
		
	}
	
	
	@RequestMapping(value = "/productList.do")
	@RequiresPermissions(PermissionConstants.PRODUCT_LIST)
	public String toSearchList(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo, String productName, String name,
			Integer page, Integer pageSize) {
		// 省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		if (page == null) {
			page = 1;
		}
		PageBean pageBean = new PageBean();
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		if (StringUtils.isBlank(productInfo.getOperatorIds())
				&& StringUtils.isNotBlank(productInfo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = productInfo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				productInfo.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters = new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		parameters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean = productInfoService.findProductInfos2(pageBean, parameters);

		Map<Integer, String> priceStateMap = new HashMap<Integer, String>();
		/*
		 * for (Object product : pageBean.getResult()) { ProductInfo info =
		 * (ProductInfo) product; Integer productId = info.getId(); String state
		 * = productInfoService.getProductPriceState(productId);
		 * priceStateMap.put(info.getId(), state); }
		 */
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("priceStateMap", priceStateMap);
		model.addAttribute("priceMode", getPriceMode(request));
		return "product/product_list_table";
	}

	@RequestMapping(value = "/productStateList.do")
	@RequiresPermissions(PermissionConstants.PRODUCT_SHELF)
	public String toSearchListState(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo, String productName, String name,
			Integer page, Integer pageSize) {
		// 省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		if (page == null) {
			page = 1;
		}
		PageBean pageBean = new PageBean();
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		if (StringUtils.isBlank(productInfo.getOperatorIds())
				&& StringUtils.isNotBlank(productInfo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = productInfo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				productInfo.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters = new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		// parameters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean = productInfoService.findProductInfos(pageBean, parameters);

		Map<Integer, String> priceStateMap = new HashMap<Integer, String>();
		/*
		 * for (Object product : pageBean.getResult()) { ProductInfo info =
		 * (ProductInfo) product; Integer productId = info.getId(); String state
		 * = productInfoService.getProductPriceState(productId);
		 * priceStateMap.put(info.getId(), state); }
		 */
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("priceStateMap", priceStateMap);
		model.addAttribute("priceMode", getPriceMode(request));
		return "product/product_list_table_state";
	}

	@RequestMapping(value = "/productPriceList.do")
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	public String toSearchListPrice(HttpServletRequest request, ModelMap model,
			ProductInfo productInfo, String productName, String name,
			Integer page, Integer pageSize) {
		// 省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		if (page == null) {
			page = 1;
		}
		PageBean pageBean = new PageBean();
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		if (StringUtils.isBlank(productInfo.getOperatorIds())
				&& StringUtils.isNotBlank(productInfo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = productInfo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				productInfo.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		// productInfo.set
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters = new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		// parameters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean = productInfoService.findProductInfos(pageBean, parameters);

		Map<Integer, String> priceStateMap = new HashMap<Integer, String>();
		/*
		 * for (Object product : pageBean.getResult()) { ProductInfo info =
		 * (ProductInfo) product; Integer productId = info.getId(); String state
		 * = productInfoService.getProductPriceState(productId);
		 * priceStateMap.put(info.getId(), state); }
		 */
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		model.addAttribute("priceStateMap", priceStateMap);

		model.addAttribute("priceMode", getPriceMode(request));
		return "product/product_list_table_price";
	}

	private String getPriceMode(HttpServletRequest request) {
		String priceMode = WebUtils.getBizConfigValue(request,
				BizConfigConstant.BIZ_PRODUCT_PRICE_MODE);
		if (StringUtils.isEmpty(priceMode)) {
			priceMode = BizConfigConstant.PRODUCT_PRICE_MODE_LOCAL_ANGENCY;
		}
		return priceMode;
	}

	/**
	 * @author : xuzejun
	 * @date : 2015年7月2日 上午9:23:34
	 * @Description: 跳转产品添加页面
	 */
	@RequestMapping(value = "/add.htm")
	// @RequiresPermissions(PermissionConstants.PRODUCT_ADD)
	public String toAdd(HttpServletRequest request, ModelMap model) {
		// 省市
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// 产品名称
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("brandList", brandList);
		model.addAttribute("config", config);
		// 获取当前登录人的信息
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		model.addAttribute("operatorId", curUser.getEmployeeId());
		model.addAttribute("operatorName", curUser.getName());
		return "product/info/product_add";
	}

	/**
	 * @author : xuzejun
	 * @date : 2015年7月2日 上午9:23:34
	 * @Description: 跳转产品修改页面 <a
	 *               href="<%=path%>/contract/${supplierId}/${contract.id}/edit.htm"
	 *               target="mainFrame">修改</a>&nbsp;
	 */
	@RequestMapping(value = "/edit.htm", method = RequestMethod.GET)
	// @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
	public String toEdit(HttpServletRequest request, Integer productId,
			ModelMap model) {
		ProductInfoVo productInfoVo = productInfoService.findProductInfoVoById(productId);
		ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(productId);
		model.addAttribute("vo", productInfoVo);
		model.addAttribute("productRemark", productRemark);
		
		// 省
		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// 市
		/*
		 * if (productInfoVo.getProductInfo().getDestProvinceId() != null) {
		 * List<RegionInfo> allCity = regionService
		 * .getRegionById(productInfoVo.getProductInfo()
		 * .getDestProvinceId().toString()); model.addAttribute("allCity",
		 * allCity); }
		 * model.addAttribute("allProvince", allProvince);
		 */

		// 产品名称
		List<DicInfo> brandList = dicService.getListByTypeCode(BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("brandList", brandList);

		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		model.addAttribute("operatorId", curUser.getEmployeeId());
		model.addAttribute("operatorName", curUser.getName());
		
		model.addAttribute("config", config);
		model.addAttribute("productId", productId);
		return "product/info/product_edit";
	}

	/**
	 * @author : xuzejun
	 * @date : 2015年7月2日 下午3:24:28
	 * @Description: 保存
	 */
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	@ResponseBody
	public String save(HttpServletRequest request, ProductInfoVo info, ProductRouteVo productRouteVo) {
		if (info.getProductInfo().getId() == null) {
			info.getProductInfo().setCreatorId(WebUtils.getCurUserId(request));
			info.getProductInfo().setCreatorName(WebUtils.getCurUser(request).getName());
			info.getProductInfo().setBizId(WebUtils.getCurBizId(request));
			// 默认把自己单位加上
			Set<Integer> orgIdSet = new HashSet<Integer>();
			orgIdSet.add(WebUtils.getCurUser(request).getOrgId());
			info.setOrgIdSet(orgIdSet);
		}
		int id = productInfoService.saveProductInfo(info,bizSettingCommon.getMyBizCode(request),dicService.getById(info.getProductInfo().getBrandId().toString()).getCode());
		
		if (info.getProductInfo().getId() == null) {
			productRouteVo.setProductId(id);
			productRouteService.saveProductRoute(productRouteVo);
		}else{
			productRouteService.editProductRoute(productRouteVo);
		}
		
		return id > 0 ? successJson("id", id + "") : errorJson("操作失败！");
	}

	@RequestMapping(value = "/upState.do", method = RequestMethod.POST)
	@ResponseBody
	public String upState(ProductInfo info) {
		List<ProductRoute> productRoutes = productRouteService
				.findProductRouteByProductId(info.getId());
		if (info.getState() != (byte) -1 && productRoutes.size() == 0) {
			return errorJson("产品内无行程内容");
		} else {
			return productInfoService.updateProductInfo(info) == 1 ? successJson()
					: errorJson("操作失败！");
		}
	}

	/**
	 * 订单打印
	 * 
	 * @param productId
	 * @param request
	 * @param response
	 */
	@RequestMapping("download.htm")
	public void downloadFile(Integer preivew, Integer productId,
			HttpServletRequest request, HttpServletResponse response) {
		String path = "";
		String fileName = "";
		String productCode = "";
		Map<String, Object> map = productInfoService
				.findProductInfos(productId);
		path = createProductInfo(preivew, request, productId, map);
		ProductInfo productInfo = (ProductInfo) map.get("productInfo");
		if (productInfo != null) {
			productCode = productInfo.getCode();
		}
		try {
			String agent = request.getHeader("User-Agent");
			boolean isMSIE = (agent != null && agent.indexOf("MSIE") != -1);
			if (isMSIE) {
				fileName = java.net.URLEncoder.encode("行程单" + productCode
						+ ".doc", "UTF8");
			} else {
				fileName = new String(
						("行程单" + productCode + ".doc").getBytes("UTF-8"),
						"iso-8859-1");
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}// 为了解决中文名称乱码问题
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/msword"); // word格式
		try {
			response.setHeader("Content-Disposition", "attachment; filename="
					+ fileName);
			File file = new File(path);
			System.out.println(file.getAbsolutePath());
			InputStream inputStream = new FileInputStream(file);
			OutputStream os = response.getOutputStream();
			byte[] b = new byte[10240];
			int length;
			while ((length = inputStream.read(b)) > 0) {
				os.write(b, 0, length);
			}
			inputStream.close();
			file.delete();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public String createProductInfo(Integer preview,
			HttpServletRequest request, Integer productId,
			Map<String, Object> map) {
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		Map<String, Object> params1 = new HashMap<String, Object>();

		if (imgPath != null) {
			Map<String, String> picMap = new HashMap<String, String>();
			picMap.put("width", BizConfigConstant.BIZ_LOGO_WIDTH);
			picMap.put("height", BizConfigConstant.BIZ_LOGO_HEIGHT);
			picMap.put("type", "jpg");
			picMap.put("path", imgPath);
			params1.put("logo", picMap);
		} else {
			params1.put("logo", "");
		}
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		/**
		 * 第二个表格
		 */
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		/**
		 * 第三个表格
		 */
		Map<String, Object> map2 = new HashMap<String, Object>();

		Map<Integer, List<Integer>> delRowMap = new HashMap<Integer, List<Integer>>();

		// 打印的数据
		getProductInfo(preview, request, map, params1, map0, routeList, map2,
				delRowMap, "word");

		String url = request.getSession().getServletContext().getRealPath("/")
				+ "/download/product-" + System.currentTimeMillis() + ".doc";
		// String imgPath = WebUtils.getCurBizLogo(config.getImgServerUrl(),
		String realPath = request.getSession().getServletContext()
				.getRealPath("/template/product_info.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
		try {
			export.export(params1);
			export.export(map0, 0);
			export.export(routeList, 1);
			export.export(map2, 2);
			export.deleteRow(delRowMap);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	/**
	 * 
	 * @param preview
	 * @param request
	 * @param map
	 * @param params1
	 * @param map0
	 * @param routeList
	 * @param map2
	 * @param type
	 *            html(导出html) word（导出word）
	 */
	private void getProductInfo(Integer preview, HttpServletRequest request,
			Map<String, Object> map, Map<String, Object> params1,
			Map<String, Object> map0, List<Map<String, String>> routeList,
			Map<String, Object> map2, Map<Integer, List<Integer>> delRowMap,
			String type) {
		PlatformEmployeePo employeePo = WebUtils.getCurUser(request);

		ProductInfo productInfo = (ProductInfo) map.get("productInfo");
		ProductRemark productRemark = (ProductRemark) map.get("productRemark");
		if (productRemark == null) {
			productRemark = new ProductRemark();
		}
		@SuppressWarnings("unchecked")
		List<ProductRoute> productRouteList = (List<ProductRoute>) map
				.get("productRoutes");

		// request);
		map0.put("product_brand", productInfo.getBrandName());
		map0.put("product_name", productInfo.getNameCity());
		// params1.put("userName", employeePo.getName());
		// params1.put("userTel", employeePo.getMobile());
		// params1.put("userFax", employeePo.getFax());
		params1.put("printTime", DateUtils.format(new Date()));
		map0.put("product_code", productInfo.getCode());
		if (productInfo.getTravelDays() == null
				|| productInfo.getTravelDays().equals("")) {
			productInfo.setTravelDays(0);
		}
		map0.put("day_num", productInfo.getTravelDays() + "天");
		// map0.put(
		// "destination",
		// (productInfo.getDestProvinceName()==null?"":productInfo.getDestProvinceName())
		// +
		// (productInfo.getDestCityName()==null?"":productInfo.getDestCityName()));
		map0.put(
				"product_feature",
				productRemark.getProductFeature() == null ? "" : productRemark
						.getProductFeature());

		int j = 1;
		for (int i = 0; i < productRouteList.size(); i++) {
			Map<String, String> mapp = new HashMap<String, String>();
			mapp.put("date", "第" + j++ + "天");

			if (type.equals("html")) {
				mapp.put("route_short", productRouteList.get(i).getRouteShort());
				mapp.put("route_desp", productRouteList.get(i).getRouteDesp());
				mapp.put("meal", "早餐：" + productRouteList.get(i).getBreakfast()
						+ " <br/>午餐：" + productRouteList.get(i).getLunch()
						+ " <br/>晚餐：" + productRouteList.get(i).getSupper());
			} else if (type.equals("word")) {
				mapp.put("route_short", productRouteList.get(i).getRouteShort());
				if (StringUtils
						.isEmpty(productRouteList.get(i).getRouteShort())) {
					mapp.put("route_desp", productRouteList.get(i)
							.getRouteDesp());
				} else {
					mapp.put(
							"route_desp",
							productRouteList.get(i).getRouteShort()
									+ "\b________________________________________________________________________\n"
									+ productRouteList.get(i).getRouteDesp());
				}
				mapp.put("meal", "早餐：" + productRouteList.get(i).getBreakfast()
						+ " \n午餐：" + productRouteList.get(i).getLunch()
						+ " \n晚餐：" + productRouteList.get(i).getSupper());
			}
			mapp.put("hotel", productRouteList.get(i).getHotelName());
			routeList.add(mapp);
		}
		// 打印页面
		if (preview == null) {

			List<Integer> rowIdxList = new ArrayList<Integer>();
			map2.put("item_include", productRemark.getItemInclude());
			if (StringUtils.isEmpty(productRemark.getItemInclude())) {
				rowIdxList.add(0);
			}
			map2.put("item_exclude", productRemark.getItemExclude());
			if (StringUtils.isEmpty(productRemark.getItemExclude())) {
				rowIdxList.add(1);
			}
			map2.put("child_plan", productRemark.getChildPlan());
			if (StringUtils.isEmpty(productRemark.getChildPlan())) {
				rowIdxList.add(2);
			}
			map2.put("shopping_plan", productRemark.getShoppingPlan());
			if (StringUtils.isEmpty(productRemark.getShoppingPlan())) {
				rowIdxList.add(3);
			}
			map2.put("item_charge", productRemark.getItemCharge());
			if (StringUtils.isEmpty(productRemark.getItemCharge())) {
				rowIdxList.add(4);
			}
			map2.put("item_free", productRemark.getItemFree());
			if (StringUtils.isEmpty(productRemark.getItemFree())) {
				rowIdxList.add(5);
			}
			map2.put("attention", productRemark.getAttention());
			if (StringUtils.isEmpty(productRemark.getAttention())) {
				rowIdxList.add(14);
			}
			map0.put("item_other", productRemark.getItemOther());
			map2.put("warm_tip", productRemark.getWarmTip());
			if (StringUtils.isEmpty(productRemark.getWarmTip())) {
				rowIdxList.add(15);
			}
			map2.put("passort", productRemark.getPassort());
			if (StringUtils.isEmpty(productRemark.getPassort())) {
				rowIdxList.add(13);
			}
			map2.put("eat_note", productRemark.getEatNote());
			if (StringUtils.isEmpty(productRemark.getEatNote())) {
				rowIdxList.add(6);
			}
			map2.put("car_note", productRemark.getCarNote());
			if (StringUtils.isEmpty(productRemark.getCarNote())) {
				rowIdxList.add(7);
			}
			map2.put("guide_note", productRemark.getGuideNote());
			if (StringUtils.isEmpty(productRemark.getGuideNote())) {
				rowIdxList.add(8);
			}
			map2.put("insurance_note", productRemark.getInsuranceNote());
			if (StringUtils.isEmpty(productRemark.getInsuranceNote())) {
				rowIdxList.add(9);
			}
			map2.put("sight_note", productRemark.getSightNote());
			if (StringUtils.isEmpty(productRemark.getSightNote())) {
				rowIdxList.add(10);
			}
			map2.put("refund_rule", productRemark.getRefundRule());
			if (StringUtils.isEmpty(productRemark.getRefundRule())) {
				rowIdxList.add(11);
			}
			map2.put("appoint_rule", productRemark.getAppointRule());
			if (StringUtils.isEmpty(productRemark.getAppointRule())) {
				rowIdxList.add(12);
			}

			// 删除行
			if (delRowMap != null) {
				delRowMap.put(2, rowIdxList);
			}
		} else {

			map2.put("item_include",
					productRemark.getItemInclude() == null ? "" : productRemark
							.getItemInclude().replace("\n", "<br/>"));
			map2.put("item_exclude",
					productRemark.getItemExclude() == null ? "" : productRemark
							.getItemExclude().replace("\n", "<br/>"));
			map2.put("child_plan", productRemark.getChildPlan() == null ? ""
					: productRemark.getChildPlan().replace("\n", "<br/>"));
			map2.put(
					"shopping_plan",
					productRemark.getShoppingPlan() == null ? ""
							: productRemark.getShoppingPlan().replace("\n",
									"<br/>"));
			map2.put("item_charge", productRemark.getItemCharge() == null ? ""
					: productRemark.getItemCharge().replace("\n", "<br/>"));
			map2.put("item_free", productRemark.getItemFree() == null ? ""
					: productRemark.getItemFree().replace("\n", "<br/>"));
			map2.put("attention", productRemark.getAttention() == null ? ""
					: productRemark.getAttention().replace("\n", "<br/>"));
			map0.put("item_other", productRemark.getItemOther() == null ? ""
					: productRemark.getItemOther().replace("\n", "<br/>"));
			map2.put("warm_tip", productRemark.getWarmTip() == null ? ""
					: productRemark.getWarmTip().replace("\n", "<br/>"));
			map2.put("passort", productRemark.getPassort() == null ? ""
					: productRemark.getPassort().replace("\n", "<br/>"));
			map2.put("eat_note", productRemark.getEatNote() == null ? ""
					: productRemark.getEatNote().replace("\n", "<br/>"));
			map2.put("car_note", productRemark.getCarNote() == null ? ""
					: productRemark.getCarNote().replace("\n", "<br/>"));
			map2.put("guide_note", productRemark.getGuideNote() == null ? ""
					: productRemark.getGuideNote().replace("\n", "<br/>"));
			map2.put(
					"insurance_note",
					productRemark.getInsuranceNote() == null ? ""
							: productRemark.getInsuranceNote().replace("\n",
									"<br/>"));
			map2.put("sight_note", productRemark.getSightNote() == null ? ""
					: productRemark.getSightNote().replace("\n", "<br/>"));
			map2.put("refund_rule", productRemark.getRefundRule() == null ? ""
					: productRemark.getRefundRule().replace("\n", "<br/>"));
			map2.put("appoint_rule",
					productRemark.getAppointRule() == null ? "" : productRemark
							.getAppointRule().replace("\n", "<br/>"));
		}

	}

	@RequestMapping("/stockStatics.htm")
	//@RequiresPermissions(PermissionConstants.PRODUCT_STOCK)
	public String stockStatics(HttpServletRequest request, ModelMap model,
			StockStaticCondition condition) throws ParseException {
		// loadStockStatics(request,model,condition);

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
		return "product/stock/stock-statics";
	}

	@RequestMapping("/stockStatics.do")
	//@RequiresPermissions(PermissionConstants.PRODUCT_STOCK)
	public String queryStockStatics(HttpServletRequest request, ModelMap model,
			StockStaticCondition condition) throws ParseException {
		loadStockStatics(request, model, condition);
		return "product/stock/stock-statics-table";
	}

	private void loadStockStatics(HttpServletRequest request, ModelMap model,
			StockStaticCondition condition) throws ParseException {
		if (condition.getPageSize() == null) {
			condition.setPageSize(Constants.PAGESIZE);
		}
		if (condition.getPage() == null) {
			condition.setPage(1);
		}
		condition.setOrgId(WebUtils.getCurUser(request).getOrgId());
		condition.setBizId(WebUtils.getCurBizId(request));
		PageBean page = productInfoService.getStockStaticsList(condition);
		model.addAttribute("page", page);
	}

	/**
	 * 产品权限树
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/rightTree.htm")
	public String rightTree(HttpServletRequest request, ModelMap model,
			Integer productId) {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		List<PlatformOrgPo> orgList = orgService.getOrgTree(
				WebUtils.getCurBizId(request), null);
		List<ProductRight> rightList = productInfoService
				.getRightListByProductId(productId);
		Map<Integer, Boolean> rightMap = new HashMap<Integer, Boolean>();
		if (rightList != null && rightList.size() > 0) {
			for (ProductRight right : rightList) {
				rightMap.put(right.getOrgId(), true);
			}
		}
		// 父节点集合
		// Map<Integer,Boolean> parentMap = new HashMap<Integer,Boolean>();
		if (orgList != null && orgList.size() > 0) {
			/*
			 * for(PlatformOrgPo org : orgList){
			 * parentMap.put(org.getParentId(), true); }
			 */
			for (PlatformOrgPo org : orgList) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("id", org.getOrgId() + "");
				map.put("pId", org.getParentId() + "");
				map.put("name", org.getName());
				map.put("open", "true");
				// 如果当前节点是父节点，则不允许选择
				/*
				 * if(parentMap.containsKey(org.getOrgId())){ map.put("nocheck",
				 * "true"); }
				 */
				if (rightMap.containsKey(org.getOrgId())) {
					map.put("checked", "true");
				}
				list.add(map);
			}
		}

		model.addAttribute("orgJsonStr", JSON.toJSONString(list));
		return "/product/right/org-tree";
	}

	@RequestMapping(value = "/saveRight.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveProductRight(HttpServletRequest request, ModelMap model,
			Integer productId, String orgIdArr) {
		List<Integer> orgIdList = JSON.parseArray(orgIdArr, Integer.class);
		Set<Integer> orgIdSet = new HashSet<Integer>(orgIdList);
		// 默认添加上自己的单位
		orgIdSet.add(WebUtils.getCurUser(request).getOrgId());
		productInfoService.saveProductRight(productId, orgIdSet);
		return successJson();
	}

	@RequestMapping(value = "/getProductInfo.do")
	@ResponseBody
	public String getProductInfo(Integer productId) {
		ProductInfo info = productInfoService.findProductInfoById(productId);
		Gson gson = new Gson();
		return gson.toJson(info);
	}
	
	@RequestMapping(value = "/getStockCount.do")
	@ResponseBody
	public String getStockCount(Integer productId,String itemDate) {
		ProductInfo info = productInfoService.selectStockCount(productId, itemDate);
		int a=info.getStockCount()-info.getReceiveCount();
		info.setStockCount(a);
		Gson gson = new Gson();
		return gson.toJson(info);
	}

	@RequestMapping(value = "/getProductMarks.do")
	@ResponseBody
	public String getProductMarks(Integer productId) {
		ProductRemark productRemark = productRemarkService
				.findProductRemarkByProductId(Integer.valueOf(productId));
		Gson gson = new Gson();
		return gson.toJson(productRemark);
	}

	@RequestMapping("productInfoPreview.htm")
	public String productInfoPreview(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, Integer productId,
			Integer preview) {
		Map<String, Object> map = productInfoService
				.findProductInfos(productId);
		Map<String, Object> params1 = new HashMap<String, Object>();
		/**
		 * 第一个表格
		 */
		Map<String, Object> map0 = new HashMap<String, Object>();
		/**
		 * 第二个表格
		 */
		List<Map<String, String>> routeList = new ArrayList<Map<String, String>>();
		/**
		 * 第三个表格
		 */
		Map<String, Object> map2 = new HashMap<String, Object>();

		getProductInfo(preview, request, map, params1, map0, routeList, map2,
				null, "html");
		model.addAttribute("productId", productId);
		model.addAttribute("params1", params1);
		model.addAttribute("map0", map0);
		model.addAttribute("routeList", routeList);
		model.addAttribute("map2", map2);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		return "product/productInfoPreview";

	}

	@RequestMapping(value = "codeValidate.do", method = RequestMethod.POST)
	@ResponseBody
	public String productNameValidate(HttpServletRequest request,
			ModelMap model, Integer productId, String code) {
		Integer bizId = WebUtils.getCurBizId(request);
		boolean result = productInfoService.checkProductCodeExist(productId,
				bizId, code);
		if (!result) {
			return successJson();

		} else {
			return errorJson("该编码已存在");
		}
	}

	@RequestMapping("productPricePreview.htm")
	public String productPricePreview(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String productIds) {
		// List<ProductInfo> productInfoList = JSONArray.parseArray(productIds,
		// ProductInfo.class);
		String[] productIdArr = productIds.split(",");
		// List<Map<ProductInfo, List<ProductGroupSupplier>>>
		// productPriceList=new
		// ArrayList<Map<ProductInfo,List<ProductGroupSupplier>>>();
		List<ProductGroupSupplierVo> productPriceList = new ArrayList<ProductGroupSupplierVo>();
		for (String id : productIdArr) {
			// Map<ProductInfo, List<ProductGroupSupplier>> productPriceMap=new
			// HashMap<ProductInfo, List<ProductGroupSupplier>>();
			ProductGroupSupplierVo supplierVo = new ProductGroupSupplierVo();
			ProductInfo product = productInfoService.findProductByIdAndBizId(
					Integer.parseInt(id), WebUtils.getCurBizId(request));
			List<ProductGroupSupplier> productPriceInfoList = groupSupplierService
					.getProductPriceInfoList(Integer.parseInt(id));
			if (productPriceInfoList != null && productPriceInfoList.size() > 0) {
				int rowSpan = 0;
				for (ProductGroupSupplier supplier : productPriceInfoList) {
					// rowSpan += (supplier.getRowSpan()==null?0:
					// supplier.getRowSpan());
					List<ProductGroup> productGroupList = supplier
							.getProductGroupList();
					if (productGroupList != null && productGroupList.size() > 0) {
						int rowSpan2 = 0;
						// supplier.setRowSpan(productGroupList.size());
						for (ProductGroup productGroup : productGroupList) {
							productGroup.setRowSpan(productGroup
									.getGroupPrices() == null ? 0
									: productGroup.getGroupPrices().size());
							// productGroup.getGroupPrices();
							rowSpan2 += (productGroup.getGroupPrices() == null ? 0
									: productGroup.getGroupPrices().size());
							rowSpan += (productGroup.getGroupPrices() == null ? 0
									: productGroup.getGroupPrices().size());

						}
						supplier.setRowSpan(rowSpan2);
					}
				}

				product.setRowSpan(rowSpan);
			}
			supplierVo.setProductInfo(product);
			supplierVo.setProductGroupSupplierList(productPriceInfoList);
			// List<ProductGroupSupplier> productPriceInfoList =
			// groupSupplierService.getProductPriceInfoList(Integer.parseInt(id));
			// productPriceMap.put(product, null);
			// productPriceList.add(productPriceMap);
			productPriceList.add(supplierVo);
		}
		model.addAttribute("productPriceList", productPriceList);
		// String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", bizSettingCommon.getMyBizLogo(request));
		model.addAttribute("productIds", productIds);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "/product/product-price-preview";

	}

	@RequestMapping("exportExcel.do")
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response, String productIds) {
		String[] productIdArr = productIds.split(",");
		List<ProductGroupSupplierVo> productPriceList = new ArrayList<ProductGroupSupplierVo>();
		for (String id : productIdArr) {
			// Map<ProductInfo, List<ProductGroupSupplier>> productPriceMap=new
			// HashMap<ProductInfo, List<ProductGroupSupplier>>();
			ProductGroupSupplierVo supplierVo = new ProductGroupSupplierVo();
			ProductInfo product = productInfoService.findProductByIdAndBizId(
					Integer.parseInt(id), WebUtils.getCurBizId(request));
			List<ProductGroupSupplier> productPriceInfoList = groupSupplierService
					.getProductPriceInfoList(Integer.parseInt(id));
			if (productPriceInfoList != null && productPriceInfoList.size() > 0) {
				int rowSpan = 0;
				for (ProductGroupSupplier supplier : productPriceInfoList) {
					// rowSpan += (supplier.getRowSpan()==null?0:
					// supplier.getRowSpan());
					List<ProductGroup> productGroupList = supplier
							.getProductGroupList();
					if (productGroupList != null && productGroupList.size() > 0) {
						int rowSpan2 = 0;
						// supplier.setRowSpan(productGroupList.size());
						for (ProductGroup productGroup : productGroupList) {
							productGroup.setRowSpan(productGroup
									.getGroupPrices() == null ? 0
									: productGroup.getGroupPrices().size());
							// productGroup.getGroupPrices();
							rowSpan2 += (productGroup.getGroupPrices() == null ? 0
									: productGroup.getGroupPrices().size());
							rowSpan += (productGroup.getGroupPrices() == null ? 0
									: productGroup.getGroupPrices().size());

						}
						supplier.setRowSpan(rowSpan2);
					}
				}

				product.setRowSpan(rowSpan);
			}
			supplierVo.setProductInfo(product);
			supplierVo.setProductGroupSupplierList(productPriceInfoList);
			// List<ProductGroupSupplier> productPriceInfoList =
			// groupSupplierService.getProductPriceInfoList(Integer.parseInt(id));
			// productPriceMap.put(product, null);
			// productPriceList.add(productPriceMap);
			productPriceList.add(supplierVo);
		}
		String path = "";
		// BigDecimal total = new BigDecimal(0);
		// BigDecimal totalNum = new BigDecimal(0);
		// BigDecimal totalNumMinus = new BigDecimal(0);
		// double total=0;
		// double totalNum=0;
		// double totalNumMinus=0;
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/product-price.xlsx");
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
			cellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

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
			int createRowSupplier = 3;
			int createRowGroup = 3;
			int createRowProduct = 3;
			int priceSizeGroup = 0;
			Float sumCostAdult = 0.0f;
			Float sumCostChild = 0.0f;
			Float sumSettlementAdult = 0.0f;
			Float sumSettlementChild = 0.0f;
			for (ProductGroupSupplierVo supplier : productPriceList) {
				int priceSizeTotal = 0;
				if (supplier.getProductGroupSupplierList() == null
						|| supplier.getProductGroupSupplierList().size() == 0) {
					row = sheet.createRow(index + 3);
					cc = row.createCell(0);
					cc.setCellValue(supplier.getProductInfo().getCode());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(1);
					cc.setCellValue("【"
							+ supplier.getProductInfo().getBrandName() + "】"
							+ supplier.getProductInfo().getNameCity());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(2);
					cc.setCellValue("");
					cc.setCellStyle(styleLeft);
					cc = row.createCell(3);
					cc.setCellValue("");
					cc.setCellStyle(styleLeft);
					cc = row.createCell(4);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(5);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(6);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(7);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(8);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(9);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(10);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					index++;
					priceSizeTotal += 1;
				} else {
					for (ProductGroupSupplier gSupplier : supplier
							.getProductGroupSupplierList()) {

						int priceSizeSupplier = 0;
						if (gSupplier.getProductGroupList() == null
								|| gSupplier.getProductGroupList().size() == 0) {

							row = sheet.createRow(index + 4);
							cc = row.createCell(0);
							cc.setCellValue(supplier.getProductInfo().getCode());
							cc.setCellStyle(styleLeft);
							cc = row.createCell(1);
							cc.setCellValue("【"
									+ supplier.getProductInfo().getBrandName()
									+ "】"
									+ supplier.getProductInfo().getNameCity());
							cc.setCellStyle(styleLeft);
							cc = row.createCell(2);
							cc.setCellValue(gSupplier.getProvince()
									+ gSupplier.getCity() + gSupplier.getArea()
									+ gSupplier.getTown());
							cc.setCellStyle(styleLeft);
							cc = row.createCell(3);
							cc.setCellValue(gSupplier.getSupplierName());
							cc.setCellStyle(styleLeft);
							cc = row.createCell(4);
							cc.setCellValue(gSupplier.getUpdateTime() == null ? ""
									: new SimpleDateFormat("yyyy-MM-dd")
											.format(gSupplier.getUpdateTime()));
							cc.setCellStyle(styleLeft);
							cc = row.createCell(5);
							cc.setCellValue("");
							cc.setCellStyle(cellStyle);
							cc = row.createCell(6);
							cc.setCellValue("");
							cc.setCellStyle(cellStyle);
							cc = row.createCell(7);
							cc.setCellValue("");
							cc.setCellStyle(cellStyle);
							cc = row.createCell(8);
							cc.setCellValue("");
							cc.setCellStyle(cellStyle);
							cc = row.createCell(9);
							cc.setCellValue("");
							cc.setCellStyle(cellStyle);
							cc = row.createCell(10);
							cc.setCellValue("");
							cc.setCellStyle(cellStyle);
							index++;
							priceSizeTotal += supplier
									.getProductGroupSupplierList().size();
							priceSizeSupplier += 1;
							// total+=detail.getItemTotal();
							// totalNum+=detail.getItemNum();
							// totalNumMinus += detail.getItemNumMinus();
						} else {
							for (ProductGroup group : gSupplier
									.getProductGroupList()) {

								if (group.getGroupPrices() == null
										|| group.getGroupPrices().size() == 0) {
									row = sheet.createRow(index + 3);
									cc = row.createCell(0);
									cc.setCellValue(supplier.getProductInfo()
											.getCode());
									cc.setCellStyle(styleLeft);
									cc = row.createCell(1);
									cc.setCellValue("【"
											+ supplier.getProductInfo()
													.getBrandName()
											+ "】"
											+ supplier.getProductInfo()
													.getNameCity());
									cc.setCellStyle(styleLeft);
									cc = row.createCell(2);
									cc.setCellValue(gSupplier.getProvince()
											+ gSupplier.getCity()
											+ gSupplier.getArea()
											+ gSupplier.getTown());
									cc.setCellStyle(styleLeft);
									cc = row.createCell(3);
									cc.setCellValue(gSupplier.getSupplierName());
									cc.setCellStyle(styleLeft);
									cc = row.createCell(4);
									cc.setCellValue(gSupplier.getUpdateTime() == null ? ""
											: new SimpleDateFormat("yyyy-MM-dd")
													.format(gSupplier
															.getUpdateTime()));
									cc.setCellStyle(styleLeft);
									cc = row.createCell(5);
									cc.setCellValue(group.getName());
									cc.setCellStyle(cellStyle);
									cc = row.createCell(6);
									cc.setCellValue("");
									cc.setCellStyle(cellStyle);
									cc = row.createCell(7);
									cc.setCellValue("");
									cc.setCellStyle(cellStyle);
									cc = row.createCell(8);
									cc.setCellValue("");
									cc.setCellStyle(cellStyle);
									cc = row.createCell(9);
									cc.setCellValue("");
									cc.setCellStyle(cellStyle);
									cc = row.createCell(10);
									cc.setCellValue("");
									cc.setCellStyle(cellStyle);
									index++;
									priceSizeTotal += gSupplier
											.getProductGroupList().size();
									priceSizeSupplier += gSupplier
											.getProductGroupList().size();
									priceSizeGroup += 1;
								} else {
									for (ProductGroupPrice price : group
											.getGroupPrices()) {

										row = sheet.createRow(index + 3);
										cc = row.createCell(0);
										cc.setCellValue(supplier
												.getProductInfo().getCode());
										cc.setCellStyle(styleLeft);
										cc = row.createCell(1);
										cc.setCellValue("【"
												+ supplier.getProductInfo()
														.getBrandName()
												+ "】"
												+ supplier.getProductInfo()
														.getNameCity());
										cc.setCellStyle(styleLeft);
										cc = row.createCell(2);
										cc.setCellValue(gSupplier.getProvince()
												+ gSupplier.getCity()
												+ gSupplier.getArea()
												+ gSupplier.getTown());
										cc.setCellStyle(styleLeft);
										cc = row.createCell(3);
										cc.setCellValue(gSupplier
												.getSupplierName());
										cc.setCellStyle(styleLeft);
										cc = row.createCell(4);
										cc.setCellValue(gSupplier
												.getUpdateTime() == null ? ""
												: new SimpleDateFormat(
														"yyyy-MM-dd").format(gSupplier
														.getUpdateTime()));
										cc.setCellStyle(styleLeft);
										cc = row.createCell(5);
										cc.setCellValue(group.getName());
										cc.setCellStyle(styleLeft);
										cc = row.createCell(6);
										cc.setCellValue(new SimpleDateFormat(
												"yyyy-MM-dd").format(price
												.getGroupDate())
												+ "~"
												+ new SimpleDateFormat(
														"yyyy-MM-dd").format(price
														.getGroupDateTo()));
										cc.setCellStyle(cellStyle);
										cc = row.createCell(7);
										cc.setCellValue(price
												.getPriceSettlementAdult()
												.floatValue());
										cc.setCellStyle(cellStyle);
										cc = row.createCell(8);
										cc.setCellValue(price
												.getPriceSettlementChild()
												.floatValue());
										cc.setCellStyle(cellStyle);
										cc = row.createCell(9);
										cc.setCellValue(price
												.getPriceCostAdult()
												.floatValue());
										cc.setCellStyle(cellStyle);
										cc = row.createCell(10);
										cc.setCellValue(price
												.getPriceCostChild()
												.floatValue());
										cc.setCellStyle(cellStyle);
										index++;
										sumCostAdult += price
												.getPriceCostAdult();
										sumCostChild += price
												.getPriceCostChild();
										sumSettlementAdult += price
												.getPriceSettlementAdult();
										sumSettlementChild += price
												.getPriceSettlementChild();
									}
									for (int i = 0; i < 11; i++) {
										if (i == 5) {
											sheet.addMergedRegion(new CellRangeAddress(
													createRowGroup,
													createRowGroup
															+ group.getGroupPrices()
																	.size() - 1,
													i, i));
										}
									}
								}
								priceSizeTotal += group.getGroupPrices().size();
								priceSizeSupplier += group.getGroupPrices()
										.size();
								priceSizeGroup += group.getGroupPrices().size();
								createRowGroup += priceSizeGroup;
							}
							for (int i = 0; i < 11; i++) {
								if (i == 2 || i == 3 || i == 4) {
									sheet.addMergedRegion(new CellRangeAddress(
											createRowSupplier,
											createRowSupplier
													+ priceSizeSupplier - 1, i,
											i));
								}
							}
						}
						createRowSupplier += priceSizeSupplier;

					}
					for (int i = 0; i < 11; i++) {
						if (i == 0 || i == 1) {
							sheet.addMergedRegion(new CellRangeAddress(
									createRowProduct, createRowProduct
											+ priceSizeTotal - 1, i, i));

						}

					}
				}
				createRowProduct += priceSizeTotal;
				// createRow += supplier.getDetailList().size();

			}
			row = sheet.createRow(createRowProduct); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			// cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellValue("合计：");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(7);
			cc.setCellValue(sumSettlementAdult.floatValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(sumSettlementChild.floatValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(9);
			cc.setCellValue(sumCostAdult.floatValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(sumCostChild.floatValue());
			cc.setCellStyle(styleRight);

			CellRangeAddress region = new CellRangeAddress(
					createRowProduct + 1, createRowProduct + 1, 0, 6);
			sheet.addMergedRegion(region);
			row = sheet.createRow(createRowProduct + 1);
			cc = row.createCell(0);
			cc.setCellValue("打印人："
					+ WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ com.yihg.erp.utils.DateUtils.format(new Date(),
							"yyyy-MM-dd HH:mm:ss"));
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
				fileName = new String("产品价格信息表.xlsx".getBytes("UTF-8"),"iso-8859-1");
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
	 * 查询所有产品及其价格组，组团版产品价格批量设置用户功能使用
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param productInfo
	 * @param page
	 * @param pageSize
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="productInfoList.do")
	public String productInfoList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			ProductInfo productInfo, Integer page, Integer pageSize) throws UnsupportedEncodingException {
		// Integer bizId = WebUtils.getCurBizId(request);
		
		/*
		if (productInfo.getOperatorName() != null) {
			productInfo.setOperatorName(new String(productInfo.getOperatorName().getBytes("iso-8859-1"),"utf-8")); 
		}if(productInfo.getNameCity()!=null){
			productInfo.setNameCity(new String(productInfo.getNameCity().getBytes("iso-8859-1"),"utf-8")); 
		}
		*/
		
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("brandList", brandList);
		model.addAttribute("product", productInfo);
		if (page == null) {
			page = 1;
		}
		PageBean pageBean = new PageBean();
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		productInfo.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);

		pageBean = productInfoService.findProductAndPriceGroup(pageBean);
		// 用户
		String operatorIds = productInfo.getOperatorIds();
		if (operatorIds != null && operatorIds.length() > 0) {
			List<ProductGroupSeller> groupSellers = sellerService
					.selectGroupSellers(WebUtils.getCurBizId(request),
							operatorIds);
			List result = pageBean.getResult();
			for (Object obj : result) {
				ProductInfo pInfo = (ProductInfo) obj;
				if (groupSellers != null && groupSellers.size() > 0) {
					// List<ProductGroupSeller> groupSellerList =
					// pInfo.getGroupSellers();
					List<ProductGroup> productGroupList = pInfo
							.getProductGroupList();
					if (productGroupList != null && productGroupList.size() > 0) {
						for (ProductGroup group : productGroupList) {
							for (ProductGroupSeller pSeller : groupSellers) {
								// System.out.println(group.getId()+"================="+pSeller.getGroupId());
								if (group.getId().equals(pSeller.getGroupId())) {
									// System.out.println(group.getId()+"================="+pSeller.getGroupId());
									group.setChecked(true);
								}
								/*
								 * else { //System.out.println(group.getId()+
								 * "-----------------------------------"
								 * +pSeller.getGroupId());
								 * group.setChecked(false);
								 * 
								 * }
								 */
							}
						}
					}
				}
			}
		}
		
		model.addAttribute("page", pageBean);
		return "/product/price/addUser_list";

	}

	// @RequestMapping("selectPriceGroupByOperator.do")
	// @ResponseBody
	// public String selectPriceGroupByOperator(HttpServletRequest
	// request,HttpServletResponse response,ModelMap model,String operatorIds){
	// String[] operatorIdArr = operatorIds.split(",");
	// for (String operateId : operatorIdArr) {
	//
	// ProductGroupSeller selectGroupSeller =
	// sellerService.selectGroupSeller(WebUtils.getCurBizId(request), null,
	// Integer.parseInt(operateId));
	// }
	// Map<String, Object> map=new HashMap<String, Object>();
	// return successJson(map);
	//
	// }
	/**
	 * 保存产品价格组和用户的关联
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param userJson
	 * @return
	 */

	@RequestMapping("saveUser.do")
	@ResponseBody
	public String saveUser(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String insertJson, String deleteJson ) {
		// String[] productGroupUserArr = users.split(",");
		// List<ProductGroupSeller> groupSellers =
		// productInfo.getGroupSellers();
		// List<ProductInfo> groupSellers = JSONArray.parseArray(userJson,
		// ProductInfo.class);
		//@SuppressWarnings("unchecked")
		
		
		
		
/*		JSONObject obj = JSON.parseObject(insertJson);
		
			JSONArray resultArray = obj.getJSONArray("user");
			for(int i = 0, len = resultArray.size();i < len;i++){
				JSONObject lineObj = resultArray.getJSONObject(i);
				//AirLine airLine = new AirLine();
				//airLine.setAirCode(lineObj.getString("FlightNum"));
			}*/
		
		ProductInfo productInfoIns = JSON.parseObject(insertJson, ProductInfo.class);
		ProductInfo productInfoDel = JSON.parseObject(deleteJson, ProductInfo.class);
		try {
			for (ProductGroupSeller pgSeller : productInfoIns.getGroupSellers()) {
				pgSeller.setBizId(WebUtils.getCurBizId(request));
				pgSeller.setCreateTime(new Date().getTime());
				//sellerService.insertSelective(pgSeller);
				sellerService.insertByBatch(pgSeller);
			}
			for (ProductGroupSeller pgSeller : productInfoDel.getGroupSellers()) {
				sellerService.delSellerBatch(pgSeller.getGroupId(), pgSeller.getProductId(), pgSeller.getOperatorId());
			}
			return successJson();
		} catch (Exception e) {

			e.printStackTrace();
			return errorJson("保存失败");
		}
		// return ;

	}
}
