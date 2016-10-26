package com.yihg.erp.controller.sales;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.facade.sales.query.ToSearchListDTO;
import com.yimayhd.erpcenter.facade.sales.result.ToSearchListResult;
import com.yimayhd.erpcenter.facade.sales.service.TeamGroupFacade;
import org.erpcenterFacade.common.client.query.BrandQueryDTO;
import org.erpcenterFacade.common.client.result.BrandQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductRouteService;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.vo.ProductRouteVo;
import com.yihg.sales.po.AutocompleteInfo;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierInfo;
/**
 * @author : qindazhong
 * @date : 2015年7月1日 下午3:06:44
 * @Description: 旅行团管理页面中的导入行程页面控制层
 */
@Controller
@RequestMapping(value = "/route")
public class RouteController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(RouteController.class);

	@Autowired
	private ProductInfoService productInfoService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SysConfig config;
	@Autowired
	private ProductRouteService productRouteService;
	@Autowired
	private ProductCommonFacade productCommonFacade;

	@Autowired
	private TeamGroupFacade teamGroupFacade;

	
	/**
	 * 获取用餐列表
	 * @param request
	 * @param reponse
	 * @param name
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "getNameList.do" ,method = RequestMethod.GET)
	@ResponseBody
	public String getUserNameList(HttpServletRequest request, HttpServletResponse reponse, String name) throws UnsupportedEncodingException{
		List<Map<String, String>> list  = new ArrayList<Map<String,String>>() ;
		Map<String, String> map1 = new HashMap<String, String>() ;
		Map<String, String> map2 = new HashMap<String, String>() ;
		map1.put("name", "√") ;
		map2.put("name", "×") ;
		list.add(map1) ;
		list.add(map2) ;
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}
	/**
	 * @author : qindazhong
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至产品管理页面
	 */
	@RequestMapping(value = "/list.htm")
	//public String toList( ModelMap model,ProductInfo productInfo,String name,Integer page) {
	public String toList(HttpServletRequest request,ModelMap model,ProductInfo productInfo,String productName, String name,Integer page) {
		//省市
		//List<RegionInfo> allProvince = regionService.getAllProvince();
		//产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		//List<DicInfo> brandList = dicService
		//		.getListByTypeCode(BasicConstants.CPXL_PP,bizId);
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(bizId);
		BrandQueryResult brandQueryResult = productCommonFacade.brandQuery(brandQueryDTO);
		if(page==null){
			page=1;
		}
		productInfo.setTravelDays(1);
		/*PageBean<ProductInfo> pageBean = new PageBean<ProductInfo>();
		pageBean.setPageSize(Constants.PAGESIZE);
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);*/
		/*Map parameters=new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		//parameters.put("set", WebUtils.getDataUserIdSet(request));
		pageBean = productInfoService.findProductInfos(pageBean, parameters);*/

		//pageBean = productInfoService.findProductInfos(pageBean, bizId,name, productName,WebUtils.getCurUser(request).getOrgId());
		//model.addAttribute("allProvince",allProvince);
		model.addAttribute("brandList", brandQueryResult.getBrandList());
		model.addAttribute("state", productInfo.getState());
		//model.addAttribute("page", pageBean);
		log.info("跳转到产品查询列表页面");
		return "sales/tourGroup/routeList/product_list";
	}
	
	
	@RequestMapping(value = "/productList.do")
	public String toSearchList(HttpServletRequest request, ModelMap model,ProductInfo productInfo,String productName, String name,Integer page,Integer pageSize) {
		//省市
		//List<RegionInfo> allProvince = regionService.getAllProvince();
		//产品名称
		Integer bizId = WebUtils.getCurBizId(request);
		/*List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,bizId);
		if(page==null){
			page=1;
		}
		PageBean<ProductInfo> pageBean = new PageBean<ProductInfo>();
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		productInfo.setTravelDays(1);
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters=new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);*/
		//parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		//parameters.put("set", WebUtils.getDataUserIdSet(request));
	
	//	pageBean = productInfoService.findProductRoutes(pageBean, parameters);
		ToSearchListDTO toSearchListDTO = new ToSearchListDTO();
		com.yimayhd.erpcenter.dal.product.po.ProductInfo info = new com.yimayhd.erpcenter.dal.product.po.ProductInfo();
		BeanUtils.copyProperties(productInfo, info);
		toSearchListDTO.setProductInfo(info);
		toSearchListDTO.setBizId(bizId);
		toSearchListDTO.setProductName(productName);
		toSearchListDTO.setName(name);
		toSearchListDTO.setPage(page);
		toSearchListDTO.setPageSize(pageSize);
		ToSearchListResult toSearchListResult = teamGroupFacade.toSearchList(toSearchListDTO);

		//pageBean = productInfoService.findProductInfos(pageBean, bizId,name, productName,WebUtils.getCurUser(request).getOrgId());
		//model.addAttribute("allProvince",allProvince);
		model.addAttribute("brandList", toSearchListResult.getBrandList());
		model.addAttribute("page", toSearchListResult.getPageBean());
		model.addAttribute("pageNum", page);
		log.info("跳转到产品列表");
		return "sales/tourGroup/routeList/product_list_table";
	}
	
	/**
	 * @author : zhoum
	 * @date : 2016年9月1日 
	 * @Description: 跳转至产品管理页面
	 */
	@RequestMapping(value = "/StockProduct_list.htm")
	public String StockProduct_list(HttpServletRequest request,ModelMap model,ProductInfo productInfo,String productName, String name,Integer page) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,bizId);
		if(page==null){
			page=1;
		}
		productInfo.setTravelDays(1);
		model.addAttribute("brandList", brandList);
		model.addAttribute("state", productInfo.getState());
		model.addAttribute("itemDate",productInfo.getItemDate());
		log.info("跳转到产品查询列表页面");
		return "sales/tourGroup/routeList/StockProduct_list";
	}
	
	@RequestMapping(value = "/StockProduct_list_table.do")
	public String StockProduct_list_table(HttpServletRequest request, ModelMap model,ProductInfo productInfo,String productName, String name,Integer page,Integer pageSize) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,bizId);
		if(page==null){
			page=1;
		}
		PageBean<ProductInfo> pageBean = new PageBean<ProductInfo>();
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		productInfo.setTravelDays(1);
		pageBean.setParameter(productInfo);
		pageBean.setPage(page);
		Map parameters=new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("name", name);
		parameters.put("productName", productName);
		// pageBean = productInfoService.findProductRoutes(pageBean, parameters);
		pageBean = productInfoService.selectStockProductListPage(pageBean, parameters);
		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		log.info("跳转到产品列表");
		return "sales/tourGroup/routeList/StockProduct_list_table";
	}
	
	
	@RequestMapping(value = "/toImportRoute.htm")
	@ResponseBody
	public String getRouteVo(Model model,Integer productId){
		ProductRouteVo productRouteVo = productRouteService.findByProductId(productId) ;
		
		Gson gson = new Gson();
		String json = gson.toJson(productRouteVo);
		return json;
	}
}
