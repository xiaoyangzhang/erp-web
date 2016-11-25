package com.yihg.erp.controller.traffic;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.sales.RouteController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.po.TrafficRes;
import com.yimayhd.erpcenter.dal.product.po.TrafficResProduct;
import com.yimayhd.erpcenter.dal.product.vo.TrafficResVo;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinancePay;
import com.yimayhd.erpcenter.dal.sales.client.finance.po.FinancePayDetail;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingGuide;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplierDetail;
import com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingGroup;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SpecialGroupOrderVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.tj.client.query.DetailsStocklogDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.MakeCollectionsDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.ToSearchListDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.ToUpdateProductPriceDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficChangeDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficProBindingDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficResDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficResProductDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficSaveResOrderDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TraficchangeResStateDTO;
import com.yimayhd.erpcenter.facade.tj.client.result.GetProductInfoResult;
import com.yimayhd.erpcenter.facade.tj.client.result.ToSearchListResult;
import com.yimayhd.erpcenter.facade.tj.client.result.ToTraficEditResult;
import com.yimayhd.erpcenter.facade.tj.client.result.TrafficAddResOrderResult;
import com.yimayhd.erpcenter.facade.tj.client.result.WebResult;
import com.yimayhd.erpcenter.facade.tj.client.service.ResTrafficFacade;
import com.yimayhd.erpresource.dal.po.SupplierItem;

@Controller
@RequestMapping("/resTraffic")

public class ResTrafficController extends BaseController{
	private static final Logger log = LoggerFactory
			.getLogger(RouteController.class);
	
	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	
	@Autowired
	private ResTrafficFacade resTrafficFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	
	/**
	 * 交通资源
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("resourceList.htm")
	public String resourceList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {

		return "resTraffic/resourceList";
	}
	
	/**
	 * 交通资源table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("resourceList_table.do")
	public String resourceList_table(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page) {
		TrafficDTO trafficDTO = new TrafficDTO();
		trafficDTO.setPage(page);
		trafficDTO.setPageSize(pageSize);
		trafficDTO.setPm(WebUtils.getQueryParamters(request));
		PageBean result = resTrafficFacade.resourceList_table(trafficDTO);
		model.addAttribute("pageBean", result);

		return "resTraffic/resourceList_table";
	}
	
	/**
	 * 新增资源
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("addResource.htm")
	public String addResource(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String authClient) {

		return "resTraffic/addResource";
	}
	
	/**
	 * @author : zhoumi
	 * @date : 2016年9月12日 
	 * @Description: 保存
	 */
	@RequestMapping(value = "/save.do")
	@ResponseBody
	public String save(HttpServletRequest request, TrafficResVo vo) {
		TrafficResDTO trafficResDTO = new TrafficResDTO();
		trafficResDTO.setBizId(WebUtils.getCurBizId(request));
		trafficResDTO.setUserId(WebUtils.getCurUserId(request));
		trafficResDTO.setCurUser(WebUtils.getCurUser(request));
		trafficResDTO.setTrafficResVo(vo);
		int id = resTrafficFacade.save(trafficResDTO);
		return id > 0 ? successJson("id", id + "") : errorJson("操作失败！");
	}
	
	/**
	 * @author : zhoumi
	 * @date : 2016年9月12日 
	 * @Description: 编辑
	 */
	@RequestMapping(value = "/edit.do")
	public String toEdit(HttpServletRequest request, Integer id,
			ModelMap model) {
		ToTraficEditResult result = resTrafficFacade.toEdit(id);
		model.addAttribute("trafficRes", result.getTrafficRes());
		model.addAttribute("trafficResLine", result.getTrafficResLines());
		return "resTraffic/addResource";
	}
	
	/**
	 * @author : zhoumi
	 * @date : 2016年9月22日 
	 * @Description: 上架/下架
	 */
	@RequestMapping(value = "/changeResState.do")
	@ResponseBody
	public String changeResState(HttpServletRequest request, Integer id,Integer state){
		TraficchangeResStateDTO dto = new TraficchangeResStateDTO();
		dto.setId(id);
		dto.setState(state);
		dto.setCurUser(WebUtils.getCurUser(request));
		int result = resTrafficFacade.changeResState(dto);
		return successJson();
	}
	
	@RequestMapping(value = "/resDetails.do")
	public String resDetails(HttpServletRequest request, Integer resId,
			ModelMap model) {
		List<TrafficRes> list = resTrafficFacade.resDetails(resId);
		String name=list.get(0).getResName();
		String dateStart=list.get(0).getDateStart();
		model.addAttribute("name",name);
		model.addAttribute("dateStart", dateStart);
		model.addAttribute("list", list);
		return "resTraffic/resDetails";
	}
	
		@RequestMapping(value = "/detailsStocklog.do")
		public String detailsStocklog(HttpServletRequest request, Integer resId,String adjustTime,
				ModelMap model) {
			DetailsStocklogDTO detailsStocklogDTO = new DetailsStocklogDTO();
			detailsStocklogDTO.setResId(resId);
			detailsStocklogDTO.setAdjustTime(adjustTime);
			List<TrafficRes> list = resTrafficFacade.detailsStocklog(detailsStocklogDTO);
			model.addAttribute("list", list);
			return "resTraffic/detailsStocklog";
		}
		
	 @RequestMapping(value="/copyRes.do")
	    public String copyRes(ModelMap model,Integer resId){
	    	model.addAttribute("resId",resId);
	    	return "resTraffic/copyRes";
	    }

	@RequestMapping(value="/sureCopy.do")
	@ResponseBody
    public String sureCopy(HttpServletRequest request, ModelMap model,Integer resId,String dateAry){
		DetailsStocklogDTO detailsStocklogDTO = new DetailsStocklogDTO();
		detailsStocklogDTO.setResId(resId);
		detailsStocklogDTO.setAdjustTime(dateAry);
		detailsStocklogDTO.setCurUser(WebUtils.getCurUser(request));
		resTrafficFacade.sureCopy(detailsStocklogDTO);
    	return successJson();
    }
	
	@RequestMapping(value="/change.do")
	@ResponseBody
    public String change(HttpServletRequest request,ModelMap model,Integer resId,String type,String numType,Integer  num){
		TrafficChangeDTO trafficChangeDTO = new TrafficChangeDTO();
		trafficChangeDTO.setResId(resId);
		trafficChangeDTO.setType(type);
		trafficChangeDTO.setNumType(numType);
		trafficChangeDTO.setNum(num);
		trafficChangeDTO.setUserId(WebUtils.getCurUserId(request));
		trafficChangeDTO.setCurUser(WebUtils.getCurUser(request));
		resTrafficFacade.change(trafficChangeDTO);
    	return successJson();
    }
	
	/**
	 * 产品列表
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("resProductList.htm")
	public String resProductList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {

		return "resTraffic/resProductList";
	}
	
	/**
	 * 产品列表table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("resProductList_table.do")
	public String resProductList_table(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page) {
		TrafficDTO trafficDTO = new TrafficDTO();
		trafficDTO.setPage(page);
		trafficDTO.setPageSize(pageSize);
		String[] deftMappingSupplier = settingCommon.getOrgMappingSupplierId(WebUtils.getCurUser(request).getOrgId()); //获取当前登录用户默认对应的组团社ID
		Map pm = WebUtils.getQueryParamters(request);
		pm.put("currentOrgIdMappingSupplierId", deftMappingSupplier[0]);
		trafficDTO.setPm(WebUtils.getQueryParamters(request));
		PageBean result = resTrafficFacade.resProductList_table(trafficDTO);
	    model.addAttribute("pageBean", result);
	    model.addAttribute("config", config);
		return "resTraffic/resProductList_table";
	}
	
	/**
	 * 跳转到预定信息页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("addResOrder.htm")
	public String addResOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id) {
		TrafficResDTO trafficResDTO = new TrafficResDTO();
		trafficResDTO.setTrafficProductInfoId(id);
		trafficResDTO.setBizId(WebUtils.getCurBizId(request));
		String orgSupplierMapping = WebUtils.getBizConfigValue(request,BizConfigConstant.ORG_SUPPLIER_MAPPING);
		trafficResDTO.setOrgSupplierMapping(orgSupplierMapping);
		String[] defaultMappingSupplier = settingCommon.getOrgMappingSupplierId(WebUtils.getCurUser(request).getOrgId()); //获取当前登录用户默认对应的组团社ID
		trafficResDTO.setSupplierId(Integer.parseInt(defaultMappingSupplier[0]));
		trafficResDTO.setSupplierName(defaultMappingSupplier[1]);
		trafficResDTO.setCurUser(WebUtils.getCurUser(request));
		TrafficAddResOrderResult result = resTrafficFacade.addResOrder(trafficResDTO);
		model.addAttribute("operType", 1);
		model.addAttribute("vo", result.getVo());
		int bizId = WebUtils.getCurBizId(request);
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("config", config);
		model.addAttribute("trp", result.getTrafficResProduct());
		model.addAttribute("pi", result.getProductInfo());
		model.addAttribute("trl", JSON.toJSONString(result.getTrafficResLine()));
		
		return "resTraffic/addResOrder";
	}
	
	@RequestMapping(value = "editResOrder.htm")
	public String EditResOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id,Integer operType,Integer see){
		TrafficResDTO trafficResDTO = new TrafficResDTO();
		trafficResDTO.setOrderId(id);
		trafficResDTO.setOperType(operType);
		trafficResDTO.setBizId(WebUtils.getCurBizId(request));
		TrafficAddResOrderResult result = resTrafficFacade.EditResOrder(trafficResDTO);
		//id=80801;
		if(operType==null){
			operType=1;
		}
		SpecialGroupOrderVO vo = result.getVo();
		model.addAttribute("operType", operType);
		model.addAttribute("vo", vo);
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("config", config);
		model.addAttribute("allCity", result.getCityList());
		model.addAttribute("trp", result.getTrafficResProduct());
		model.addAttribute("trl", "1");   // 判断是否导入行程，接送信息
		model.addAttribute("see", see);
		return "resTraffic/addResOrder";
	}
	
	/**
	 * 保存订单
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveResOrder.do")
	@ResponseBody
	public String saveResOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,SpecialGroupOrderVO vo,String ids,String id
				,Integer GroupMode,Integer trpId,Integer see) throws ParseException{
		TrafficSaveResOrderDTO trafficSaveResOrderDTO = new TrafficSaveResOrderDTO();
		trafficSaveResOrderDTO.setVo(vo);
		trafficSaveResOrderDTO.setId(id);
		trafficSaveResOrderDTO.setIds(ids);
		trafficSaveResOrderDTO.setGroupMode(GroupMode);
		trafficSaveResOrderDTO.setTrpId(trpId);
		trafficSaveResOrderDTO.setSee(see);
		trafficSaveResOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficSaveResOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficSaveResOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficSaveResOrderDTO.setOrderNo(settingCommon.getMyBizCode(request));
		WebResult result = resTrafficFacade.saveResOrder(trafficSaveResOrderDTO);
		if(!result.isSuccess()){
			return successJson("see","1");
		}
		return successJson("groupId",result.getValue()+"");
	}
	
	@RequestMapping("receivables.htm")   // 收款
	public String receivables(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id) {
		GroupOrder go = resTrafficFacade.receivables(id);
		//id=80826;
		model.addAttribute("go", go); 
		return "resTraffic/receivables";
	}

	@RequestMapping(value = "makeCollections.do")  // 收款确定
	@ResponseBody
	@PostHandler
	public String makeCollections(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, FinancePay pay,Integer orderId) {
		MakeCollectionsDTO makeCollectionsDTO = new MakeCollectionsDTO();
		makeCollectionsDTO.setOrderId(orderId);
		makeCollectionsDTO.setPay(pay);
		makeCollectionsDTO.setEmp(WebUtils.getCurUser(request));
		makeCollectionsDTO.setBizId(WebUtils.getCurBizId(request));
		resTrafficFacade.makeCollections(makeCollectionsDTO);
		return successJson();
	}
	
	@RequestMapping("receivablesRecord.htm")  // 收款记录
	public String receivablesRecord(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id) {
		List<FinancePayDetail> financePayDetail = resTrafficFacade.receivablesRecord(id);
		model.addAttribute("fpd", financePayDetail); 
		return "resTraffic/receivablesRecord";
	}
	
	/**
	 * 查询已绑定的产品信息
	 * @param request
	 * @param resId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toProductBindingList.do")
	public String toProductBindingList(HttpServletRequest request,Integer resId,ModelMap model){
		List<TrafficResProduct> resProList = resTrafficFacade.toProductBindingList(resId);
		model.addAttribute("resProList",resProList);
		model.addAttribute("resId", resId);
		return "resTraffic/resProBindingList";
	}
	
	/**
	 * 查询产品信息
	 * @param request
	 * @param resId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toProductBindingTable.do")
	public String toProductBindingTable(HttpServletRequest request,Integer resId,ModelMap model){
		//resId = 17;
		List<TrafficResProduct> resProList = resTrafficFacade.toProductBindingTable(resId);
		model.addAttribute("resProList",resProList);
		return "resTraffic/resProBindingTable";
	}
	
	/**
	 * 插入绑定产品信息
	 * @param request
	 * @param resId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/insertTrafficProBinding.do")
	@ResponseBody
	public String insertTrafficProBinding(HttpServletRequest request,Integer resId,Integer productId,ModelMap model){
		TrafficProBindingDTO trafficProBindingDTO = new TrafficProBindingDTO();
		trafficProBindingDTO.setResId(resId);
		trafficProBindingDTO.setProductId(productId);
		trafficProBindingDTO.setCurUser(WebUtils.getCurUser(request));
		trafficProBindingDTO.setUserId(WebUtils.getCurUserId(request));
		String result = resTrafficFacade.insertTrafficProBinding(trafficProBindingDTO);
		return result;
	}
	
	/**
	 * 修改资源产品信息
	 * @param request
	 * @param resId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toUpdateResProduct.do")
	public String toUpdateResProduct(HttpServletRequest request,Integer resId,ModelMap model){
		TrafficResProduct resProductBean = resTrafficFacade.toUpdateResProduct(resId);
		model.addAttribute("resProductBean",resProductBean);
		return "resTraffic/resProductUpdate";
	}
	
	/**
	 * 保存修改产品信息
	 * @param request
	 * @param resProBean
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toSaveResProduct.do")
	@ResponseBody
	public String toSaveResProduct(HttpServletRequest request,TrafficResProduct productBean){
		TrafficResProductDTO trafficResProductDTO = new TrafficResProductDTO();
		trafficResProductDTO.setProductBean(productBean);
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		trafficResProductDTO.setCurUser(curUser);
		String result = resTrafficFacade.toSaveResProduct(trafficResProductDTO);

		return result;
	}
	
	/**
	 * 根据ID删除产品信息
	 * @param request
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/deleteResProduct.do")
	@ResponseBody
	public String deleteResProduct(HttpServletRequest request,Integer id){
		TrafficResProductDTO trafficResProductDTO = new TrafficResProductDTO();
		trafficResProductDTO.setTrafficResProductId(id);
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		trafficResProductDTO.setCurUser(curUser);
		String result = resTrafficFacade.deleteResProduct(trafficResProductDTO);
		return result;
	}
	
	/**
	 * 跳转至价格调整页面
	 * @param request
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toAdjustProPrice.do")
	public String toAdjustProPrice(HttpServletRequest request ,ModelMap model ,String id, Integer resId){
		//将选中的id传入页面
		model.addAttribute("setId", id);
		model.addAttribute("resId", resId);
		return "resTraffic/resProAdjustPrice";
	}
	

	/**
	 * 调整价格方法
	 * @param request
	 * @param id
	 * @param suggest_price_id
	 * @param adjust_uprodown_num
	 * @param price
	 * @return
	 */
	@RequestMapping(value = "/toUpdateProductPrice.do")
	@ResponseBody
	public String toUpdateProductPrice(HttpServletRequest request,String id,String suggest_price_id
			,String adjust_uprodown_num,String price, Integer resId){
		ToUpdateProductPriceDTO toUpdateProductPriceDTO = new ToUpdateProductPriceDTO();
		toUpdateProductPriceDTO.setId(id);
		toUpdateProductPriceDTO.setSuggestPriceId(suggest_price_id);
		toUpdateProductPriceDTO.setAdjustUprodownNum(adjust_uprodown_num);
		toUpdateProductPriceDTO.setPrice(price);
		toUpdateProductPriceDTO.setResId(resId);
		toUpdateProductPriceDTO.setCurUser(WebUtils.getCurUser(request));
		String result = resTrafficFacade.toUpdateProductPrice(toUpdateProductPriceDTO);
		return result;
	}
	/**
	 * 
	 * @param request
	 * @param model
	 * @param productInfo
	 * @param productName
	 * @param name
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/list.htm")
	public String toList(HttpServletRequest request,ModelMap model,ProductInfo productInfo,
			String productName, String name,Integer page) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = resTrafficFacade.getListByTypeCode(bizId);
		if(page==null){
			page=1;
		}
		productInfo.setTravelDays(1);
		model.addAttribute("brandList", brandList);
		model.addAttribute("state", productInfo.getState());
		log.info("跳转到产品查询列表页面");
		return "resTraffic/resProNameList";
	}
	
	@RequestMapping(value = "/getProductInfo.do")
	@ResponseBody
	public String getProductInfo(Integer resId,Integer productId,ModelMap model) {
		TrafficResProductDTO trafficResProductDTO = new TrafficResProductDTO();
		trafficResProductDTO.setResId(resId);
		trafficResProductDTO.setProductId(productId);
		GetProductInfoResult result = resTrafficFacade.getProductInfo(trafficResProductDTO);
		model.addAttribute("productIdCount", result.getProductIdCount());
		return JSON.toJSONString(result.getMap());
	}
	
	@RequestMapping(value = "/productList.do")
	public String toSearchList(HttpServletRequest request, ModelMap model,ProductInfo productInfo,String productName, String name,Integer page,Integer pageSize) {
		ToSearchListDTO toSearchListDTO = new ToSearchListDTO();
		toSearchListDTO.setProductInfo(productInfo);
		toSearchListDTO.setProductName(productName);
		toSearchListDTO.setName(name);
		toSearchListDTO.setPage(page);
		toSearchListDTO.setPageSize(pageSize);
		Integer bizId = WebUtils.getCurBizId(request);
		toSearchListDTO.setBizId(bizId);
		ToSearchListResult result = resTrafficFacade.toSearchList(toSearchListDTO);

		model.addAttribute("brandList", result.getBrandList());
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("pageNum", result.getPage());
		log.info("跳转到产品列表");
		return "resTraffic/resProNameTable";
	}
	
	@RequestMapping(value = "/ticketInfo.do")
	public String ticketInfo(HttpServletRequest request, Integer resId,
			ModelMap model) {
		model.addAttribute("list",resTrafficFacade.ticketInfo(resId));
		model.addAttribute("resId",resId);
		return "resTraffic/ticketInfo";
	}
	
	@RequestMapping("addTicket.do")
	public String addTicket(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer groupId, Integer bookingId, Integer resId,String guestIds,Integer num,
			Integer adultNum,Integer childNum,Integer babyNum) {
		if(guestIds!=null&&guestIds!=""){
			guestIds=guestIds.substring(0,guestIds.length()-1);
		}
		Integer bizId = WebUtils.getCurBizId(request);
		toAddSupplier(model, groupId, bookingId, bizId);
		model.addAttribute("supplierType", Constants.AIRTICKETAGENT);
		//机票
		List<DicInfo> airTypes =saleCommonFacade.getAirTicketTypesByTypeCode();
		model.addAttribute("airTypes", airTypes);
		TrafficRes trafficRes=resTrafficFacade.addTicket(resId);
		model.addAttribute("trafficRes", trafficRes);
		model.addAttribute("guestIds", guestIds);
		model.addAttribute("num", num);
		model.addAttribute("adultNum", adultNum);
		model.addAttribute("childNum", childNum);
		model.addAttribute("babyNum", babyNum);
		model.addAttribute("groupId", groupId);
		return "resTraffic/addTicket";
	}
	
	/**
	 * 跳转到供应商编辑或新增页面
	 *
	 * @param model
	 * @param groupId
	 * @param bookingId
	 */
	private void toAddSupplier(ModelMap model, Integer groupId, Integer bookingId, Integer bizId) {
		BookingSupplierDTO bookingSupplierDTO = new BookingSupplierDTO();
		bookingSupplierDTO.setBookingId(bookingId);
		bookingSupplierDTO.setGroupId(groupId);
		bookingSupplierDTO.setBizId(bizId);
		ToAddSupplierResult result =resTrafficFacade.toAddSupplier(bookingSupplierDTO);
		
		if (bookingId != null) {
			model.addAttribute("supplier", result.getSupplier());
			model.addAttribute("bookingDetailList", result.getDetailList);
			
			model.addAttribute("bookingId", bookingId);
			if (null!=result.getSupplier() && result.getSupplier().getSupplierType().equals(Constants.SCENICSPOT)) {
				model.addAttribute("supplierItems", result.getSupplierItems());
			}
		}
		
		model.addAttribute("groupId", groupId);
		if (groupId != null) {
			model.put("bookingGuides", result.getBookingGuides());
		}
		
		//从字典中查询结算方式
		model.addAttribute("cashTypes", result.getCashTypes());
	}
	
	/**
	 * 保存新增出票
	 *
	 * @param request
	 * @param reponse
	 * @param booking
	 * @param groupId
	 * @param supplierType
	 * @param supplierId
	 * @return
	 * @throws ParseException s
	 */
	@RequestMapping("saveBooking.do")
	@ResponseBody
	public String saveBooking(HttpServletRequest request, HttpServletResponse reponse, BookingSupplier bookingSupplier, String financeGuideJson,BookingGroup detailVo) {
		SaveBookingDTO saveBookingDTO = new SaveBookingDTO();
		saveBookingDTO.setDetails(detailVo.getBookingSupplierDetails());
		bookingSupplier.setUserId(WebUtils.getCurUserId(request));
		bookingSupplier.setUserName(WebUtils.getCurUser(request).getName());
		bookingSupplier.setCreateTime((new Date()).getTime());
		bookingSupplier.setBookingDate(new Date());
		saveBookingDTO.setBookingSupplier(bookingSupplier);
		saveBookingDTO.setCode(settingCommon.getMyBizCode(request));
		resTrafficFacade.saveBooking(saveBookingDTO);
		return successJson();
	}
	
	/**
	 * 跳转至机位库存状态页面
	 * @param request
	 * @param resId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toUpdateResNumStockChange.htm")
	public String toUpdateResNumStockState(HttpServletRequest request,Integer id,ModelMap model){
		ToUpdateResNumStockStateResult result = resTrafficFacade.toUpdateResNumStockState(id);
		
		model.addAttribute("resBindingProList",result.getResBindingProList());
		model.addAttribute("trafficResBean", result.getTrafficResBean());
		model.addAttribute("id", id);
		model.addAttribute("sumResProBean",result.getSumResProBean());
		return "resTraffic/resResNumStockChange";
	}
	
	/**
	 * 保存机位库存信息
	 * @param request
	 * @param productBean
	 * @return
	 */
	@RequestMapping(value = "/toSaveResNumsSold.do")
	@ResponseBody
	public String toSaveResNumsSold(HttpServletRequest request,String productList,String numStock,String numDisable, String id,
			Integer poorNumStock,Integer poorNumDisable){
		ToSaveResNumsSoldDTO toSaveResNumsSoldDTO = new ToSaveResNumsSoldDTO();
		//TODO jiatiaojian
		
		return resTrafficFacade.toSaveResNumsSold(toSaveResNumsSoldDTO);
	}

}
