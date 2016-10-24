package com.yihg.erp.controller.traffic;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.LogOperatorService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.contants.BasicConstants.LOG_ACTION;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.LogOperator;
import com.yihg.basic.po.RegionInfo;
import com.yihg.basic.util.LogFieldUtil;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.sales.RouteController;
import com.yihg.erp.utils.LogUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceService;
import com.yihg.finance.po.FinancePay;
import com.yihg.finance.po.FinancePayDetail;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.TrafficResProductService;
import com.yihg.product.api.TrafficResService;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.TrafficRes;
import com.yihg.product.po.TrafficResLine;
import com.yihg.product.po.TrafficResProduct;
import com.yihg.product.po.TrafficResStocklog;
import com.yihg.product.vo.TrafficResVo;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderPriceService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.GroupOrderTransportService;
import com.yihg.sales.api.GroupRouteService;
import com.yihg.sales.api.SpecialGroupOrderService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.po.GroupOrderTransport;
import com.yihg.sales.vo.SpecialGroupOrderVO;
import com.yihg.supplier.constants.Constants;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;

@Controller
@RequestMapping("/resTraffic")

public class ResTrafficController extends BaseController{
	private static final Logger log = LoggerFactory
			.getLogger(RouteController.class);
	@Autowired
	private TrafficResService trafficResService;
	
	@Autowired 
	private TrafficResProductService trafficResProductService;
	
	@Autowired
	private DicService dicService ;
	
	@Autowired
	private RegionService regionService;
	
	@Autowired
	private SysConfig config;
	
	@Autowired
	private BizSettingCommon settingCommon;

	@Autowired
	private GroupOrderService groupOrderService ;
	
	@Autowired
	private GroupOrderPriceService groupOrderPriceService;
	@Autowired
	private SpecialGroupOrderService specialGroupOrderService ;
	
	@Autowired
	private ProductInfoService productInfoService ;
	
	@Autowired
	private GroupOrderGuestService groupOrderGuestService;
	@Autowired
	private GroupOrderTransportService groupOrderTransportService;
	@Autowired
	private GroupRouteService groupRouteService;
	
	@Autowired
	private LogOperatorService logService;
	
	@Autowired
	private FinanceService financeService;
	
	@Autowired
	private  PlatformEmployeeService platformEmployeeService;
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
		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
	PageBean<TrafficRes> pageBean = new PageBean<TrafficRes>();
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setPage(page);
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		pageBean.setParameter(pm);
		pageBean=trafficResService.selectTrafficResListPage(pageBean);
		 model.addAttribute("pageBean", pageBean);

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
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(vo.getTrafficRes().getId()==null){
			vo.getTrafficRes().setUserName(WebUtils.getCurUser(request).getName());
			vo.getTrafficRes().setUserId(WebUtils.getCurUserId(request));
			vo.getTrafficRes().setBizId(WebUtils.getCurBizId(request));
			vo.getTrafficRes().setTimeCreate(sdf.format(new Date()));
			vo.getTrafficRes().setNumReserved(0);
			vo.getTrafficRes().setNumSold(0);
			vo.getTrafficRes().setNumBalance((vo.getTrafficRes().getNumStock()-vo.getTrafficRes().getNumDisable()));
			vo.getTrafficRes().setState((byte) 1);
			vo.getTrafficRes().setTimeUpdate(sdf.format(new Date()));
		}else{
			vo.getTrafficRes().setUserName(WebUtils.getCurUser(request).getName());
			vo.getTrafficRes().setUserId(WebUtils.getCurUserId(request));
			vo.getTrafficRes().setTimeUpdate(sdf.format(new Date()));
		}
		//产生日志（主表）
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
		int id = 0; boolean isNew = false;
		if (vo.getTrafficRes().getId()==null) {
			isNew = true;
			
		}else{
			id = vo.getTrafficRes().getId();
			
			TrafficRes orginReS = trafficResService.findTrafficResById(id);
			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(), LOG_ACTION.UPDATE, "traffic_res", id, 0, "修改资源记录", vo.getTrafficRes(), orginReS));
			
			//产生日志（子表）
			List<TrafficResLine> lineListDB = trafficResService.selectTrafficResLine(id);
			List<TrafficResLine> lineList = vo.getTrafficResLine();
			List<LogOperator> tmpList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "traffic_res_line", id, lineList, lineListDB);
			logList.addAll(tmpList);
		}
		
		
		id = trafficResService.saveTrafficRes(vo); //业务保存代码

		
		if (isNew){
			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res", id, 0, String.format("创建资源记录,名称:%s", vo.getTrafficRes().getResName()), vo.getTrafficRes(), null)); 
		}
		
		
		
		if(vo.getTrafficRes().getId()==null){
			if(vo.getTrafficRes().getNumStock()!=0&&vo.getTrafficRes().getNumStock()!=null){
				TrafficResStocklog trafficResStocklog=new TrafficResStocklog();
				trafficResStocklog.setAdjustAction(com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.STOCK.toString());
				trafficResStocklog.setAdjustNum(vo.getTrafficRes().getNumStock());
				trafficResStocklog.setResId(id);
				trafficResStocklog.setAdjustTime(new Date());
				trafficResStocklog.setUserId(WebUtils.getCurUserId(request));
				trafficResStocklog.setUserName(WebUtils.getCurUser(request).getName());
				trafficResService.insertTrafficResStocklog(trafficResStocklog);
				trafficResService.updateStockOrStockDisable(id);
				
				logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res_stocklog", 0, id ,"库位变动,【入库】", trafficResStocklog, null));
			}
			if(vo.getTrafficRes().getNumDisable()!=0&&vo.getTrafficRes().getNumDisable()!=null){
				TrafficResStocklog trafficResStocklog=new TrafficResStocklog();
				trafficResStocklog.setAdjustAction(com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.STOCK_DISABLE.toString());
				trafficResStocklog.setAdjustNum(vo.getTrafficRes().getNumDisable());
				trafficResStocklog.setResId(id);
				trafficResStocklog.setAdjustTime(new Date());
				trafficResStocklog.setUserId(WebUtils.getCurUserId(request));
				trafficResStocklog.setUserName(WebUtils.getCurUser(request).getName());
				trafficResService.insertTrafficResStocklog(trafficResStocklog);
				trafficResService.updateStockOrStockDisable(id);
				logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res_stocklog", 0, id ,"库位变动,【机动位】", trafficResStocklog, null));
			}
		}
		logService.insert(logList);
		
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
		TrafficRes trafficRes=trafficResService.findTrafficResById(id);
		model.addAttribute("trafficRes", trafficRes);
	List<TrafficResLine> trafficResLine=trafficResService.selectTrafficResLine(id);
	model.addAttribute("trafficResLine", trafficResLine);
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
		//日志 
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
		String stateStr = ("0".equals(String.valueOf(state))?"下架":"上架");
		logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.UPDATE, "traffic_res", id, 0, "更改状态为："+stateStr, null, null));
		logService.insert(logList);
		
		trafficResService.updateTrafficResState(id, state);
	return successJson();
	}
	
	@RequestMapping(value = "/resDetails.do")
	public String resDetails(HttpServletRequest request, Integer resId,
			ModelMap model) {
		List<TrafficRes> list=trafficResService.selectResDetails(resId);
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
			List<TrafficRes> list=trafficResService.selectDetailsStocklog(resId, adjustTime);
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
		String[] arr = dateAry.split(",");
		List<String> list = java.util.Arrays.asList(arr);

		//日志 
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
		
				
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Integer newResId = trafficResService.copyRes(resId, list.get(i));
				logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res", newResId, 0 ,"由复制产生！", null, null));
			}
		}
		
		logService.insert(logList);
    	return successJson();
    }
	
	@RequestMapping(value="/change.do")
	@ResponseBody
    public String change(HttpServletRequest request,ModelMap model,Integer resId,String type,String numType,Integer  num){
		// com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.STOCK.toString()
		TrafficResStocklog trafficResStocklog=new TrafficResStocklog();
		if(type.equals("numStock")){
			trafficResStocklog.setAdjustAction(com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.STOCK.toString());
		}
		if(type.equals("numDisable")){
			trafficResStocklog.setAdjustAction(com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.STOCK_DISABLE.toString());
		}
		if(numType.equals("add")){
			trafficResStocklog.setAdjustNum(num);
		}
		if(numType.equals("minus")){
			trafficResStocklog.setAdjustNum(-num);
		}
		trafficResStocklog.setResId(resId);
		trafficResStocklog.setAdjustTime(new Date());
		trafficResStocklog.setUserId(WebUtils.getCurUserId(request));
		trafficResStocklog.setUserName(WebUtils.getCurUser(request).getName());
		trafficResService.insertTrafficResStocklog(trafficResStocklog);
		trafficResService.updateStockOrStockDisable(resId);
		
		//日志 
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
		logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res_stocklog", 0, resId ,"库位变动", trafficResStocklog, null));
		logService.insert(logList);
		
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
		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
	PageBean<TrafficResProduct> pageBean = new PageBean<TrafficResProduct>();
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setPage(page);
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		pageBean.setParameter(pm);
		 pageBean=trafficResService.selectResProductListPage(pageBean);
		 List<TrafficResProduct> list=pageBean.getResult();
		 if(pageBean.getResult()!=null && pageBean.getResult().size()>0){
			 for(TrafficResProduct trp : list){
				 if(trp.getNumStock()==0){     // 库存
					 trp.setNumStock(trp.getNumBalance());
					}else{
						trp.setNumStock(trp.getNumStock()-trp.getNumSold());
						}
				 trp.setAdultSame(trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay()));
				 trp.setAdultProxy((trp.getAdultSuggestPrice().subtract(trp.getAdultSamePay())).subtract(trp.getAdultProxyPay()));
				 trp.setChildSame(trp.getChildSuggestPrice().subtract(trp.getChildSamePay()));
				 trp.setChildProxy((trp.getChildSuggestPrice().subtract(trp.getChildSamePay())).subtract(trp.getChildProxyPay()));
				 trp.setBabySame(trp.getBabySuggestPrice().subtract(trp.getBabySamePay()));
				 trp.setBabyProxy((trp.getBabySuggestPrice().subtract(trp.getBabySamePay())).subtract(trp.getBadyProxyPay()));
			 }
		 }
		 model.addAttribute("pageBean", pageBean);

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
		model.addAttribute("operType", 1);
		TrafficResProduct trafficResProduct=trafficResService.selectTrafficProductInfo(id);
		GroupOrder groupOrder  = new GroupOrder();
		groupOrder.setSaleOperatorId(trafficResProduct.getOperatorId());
		groupOrder.setSaleOperatorName(trafficResProduct.getOperatorName());
		groupOrder.setOperatorId(trafficResProduct.getOperatorId()); 
		groupOrder.setOperatorName(trafficResProduct.getOperatorName());
		groupOrder.setContactName(WebUtils.getCurUser(request).getName());
		groupOrder.setContactMobile(WebUtils.getCurUser(request).getMobile());
		groupOrder.setContactTel(WebUtils.getCurUser(request).getPhone());
		groupOrder.setContactFax(WebUtils.getCurUser(request).getFax());
		SpecialGroupOrderVO  vo = new SpecialGroupOrderVO();
		//取出当前登录人，所对应的默认组团社id和名称
		String orgSupplierMapping = WebUtils.getBizConfigValue(request,BizConfigConstant.ORG_SUPPLIER_MAPPING);
		String defaultSupplierId = "", defaultSupplierName = "";
		if (!"".equals(orgSupplierMapping)){
			JSONArray jary = JSON.parseArray(orgSupplierMapping);
			for(int i = 0 ; i < jary.size() ; i++){
				JSONObject Obj = jary.getJSONObject(i);
				if ( WebUtils.getCurUser(request).getOrgId().toString().equals(Obj.getString("orgId")) && 
						Constants.TRAVELAGENCY.toString().equals(Obj.getString("supplierType"))){
					defaultSupplierId = Obj.getString("supplierId");
					defaultSupplierName = Obj.getString("supplierName");
				}
			}
		}
		groupOrder.setSupplierId(Integer.parseInt(defaultSupplierId));
		groupOrder.setSupplierName(defaultSupplierName);
		vo.setGroupOrder(groupOrder);
		model.addAttribute("vo", vo);
		int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		model.addAttribute("config", config);
		ProductInfo productInfo=productInfoService.findProductInfoById(trafficResProduct.getProductCode());
		if(trafficResProduct.getNumStock()==0){
			trafficResProduct.setNumStock(trafficResProduct.getNumBalance());
		}else{
			trafficResProduct.setNumStock(trafficResProduct.getNumStock()-trafficResProduct.getNumSold());
		}
		trafficResProduct.setAdultSuggestPrice((trafficResProduct.getAdultSuggestPrice().subtract(trafficResProduct.getAdultSamePay())).subtract(trafficResProduct.getAdultProxyPay()));
		trafficResProduct.setChildSuggestPrice((trafficResProduct.getChildSuggestPrice().subtract(trafficResProduct.getChildSamePay())).subtract(trafficResProduct.getChildProxyPay()));
		trafficResProduct.setBabySuggestPrice((trafficResProduct.getBabySuggestPrice().subtract(trafficResProduct.getBabySamePay())).subtract(trafficResProduct.getBadyProxyPay()));
		List<TrafficResLine> trafficResLine=trafficResService.selectTrafficResLine(trafficResProduct.getResId());
		model.addAttribute("trp", trafficResProduct);
		model.addAttribute("pi", productInfo);
		model.addAttribute("trl", JSON.toJSONString(trafficResLine));
		
		return "resTraffic/addResOrder";
	}
	
	@RequestMapping(value = "editResOrder.htm")
	public String EditResOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id,Integer operType,Integer see){
		//id=80801;
		if(operType==null){
			operType=1;
		}
		model.addAttribute("operType", operType);
		SpecialGroupOrderVO  vo= specialGroupOrderService.selectSpeciaOrderlInfoByOrderId(id);
		model.addAttribute("vo", vo);
		List<DicInfo> jdxjList = dicService.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		List<DicInfo> zjlxList = dicService
				.getListByTypeCode(BasicConstants.GYXX_ZJLX);
		model.addAttribute("zjlxList", zjlxList);
		int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		List<DicInfo> jtfsList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("jtfsList", jtfsList);
		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("config", config);
		List<RegionInfo> cityList = null;
		if(vo.getGroupOrder().getProvinceId()!=null && vo.getGroupOrder().getProvinceId()!=-1){
			cityList=regionService.getRegionById(vo.getGroupOrder().getProvinceId()+"");
		}
		model.addAttribute("allCity", cityList);
		TrafficResProduct trafficResProduct=trafficResService.selectTrafficProductInfoByProductCode(vo.getGroupOrder().getProductId(),vo.getGroupOrder().getExtResId());
		if(trafficResProduct.getNumStock()==0){			//查找库存
			trafficResProduct.setNumStock(trafficResProduct.getNumBalance());
		}else{
			trafficResProduct.setNumStock(trafficResProduct.getNumStock()-trafficResProduct.getNumSold());
		}
		trafficResProduct.setAdultSuggestPrice((trafficResProduct.getAdultSuggestPrice().subtract(trafficResProduct.getAdultSamePay())).subtract(trafficResProduct.getAdultProxyPay()));
		trafficResProduct.setChildSuggestPrice((trafficResProduct.getChildSuggestPrice().subtract(trafficResProduct.getChildSamePay())).subtract(trafficResProduct.getChildProxyPay()));
		trafficResProduct.setBabySuggestPrice((trafficResProduct.getBabySuggestPrice().subtract(trafficResProduct.getBabySamePay())).subtract(trafficResProduct.getBadyProxyPay()));
		model.addAttribute("trp", trafficResProduct);
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
			HttpServletResponse reponse, ModelMap model,SpecialGroupOrderVO vo,String ids,String id,Integer GroupMode,Integer trpId,Integer see) throws ParseException{
		Integer num, orderId = 0;
		GroupOrder go = null;
		if(see != null&&see==1){
			orderId = specialGroupOrderService.saveGuestListInfo(vo, WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(),WebUtils.getCurBizId(request));
			return successJson("see","1");
		}
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		TrafficResProduct trafficResProduct=trafficResService.selectTrafficProductInfo(trpId);
		vo.getGroupOrder().setExtResCleanTime(trafficResProduct.getReserveTime());
		
		if(vo.getGroupOrder().getId()!=null){                    // 计算编辑页面库存
			orderId = vo.getGroupOrder().getId();
			go=groupOrderService.selectByPrimaryKey(orderId);
			num=vo.getGroupOrder().getNumAdult()+vo.getGroupOrder().getNumChild()-(go.getNumAdult()+go.getNumChild());
		}else{                     // 计算新增页面库存
			num=vo.getGroupOrder().getNumAdult()+vo.getGroupOrder().getNumChild();
		}
		if(vo.getGroupOrder().getId()==null){
			vo.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
		}
		vo.getGroupOrder().setExtResPrepay(((new BigDecimal(vo.getGroupOrder().getNumAdult()).multiply(trafficResProduct.getAdultMinDeposit())).
				add(new BigDecimal(vo.getGroupOrder().getNumChild()).multiply(trafficResProduct.getChildMinDeposit()))).
				add(new BigDecimal(vo.getGroupOrder().getNumChildBaby()).multiply(trafficResProduct.getBadyMinDeposit())));
		 
		
		//TODO 处理日志
		List<GroupOrderPrice> incomeList = null;
		List<GroupOrderGuest> guestList = null;
		List<GroupOrderTransport> transList = null;
		//List<GroupRoute> routeList = null;
		if (orderId > 0){
			incomeList = groupOrderPriceService.selectByOrderAndType(orderId, 0);
			guestList = groupOrderGuestService.selectByOrderId(orderId);
			transList = groupOrderTransportService.selectByOrderId(orderId);
			//routeList = groupRouteService.selectByOrderId(orderId);
		}
		List<LogOperator> logList = new ArrayList<LogOperator>();
		logList.addAll(LogUtils.LogRow_GroupOrder(request, vo.getGroupOrder(), go)); //GroupOrder
		logList.addAll(LogUtils.LogRow_GroupOrderPrice(request, orderId, vo.getGroupOrderPriceList(), incomeList)); //groupOrderPrice
		logList.addAll(LogUtils.LogRow_GroupOrderGuest(request, orderId, vo.getGroupOrderGuestList(), guestList)); //groupOrderGuest
		logList.addAll(LogUtils.LogRow_GroupOrderTransport(request, orderId, vo.getGroupOrderTransportList(), transList)); //groupOrderTransport
		
		//List<GroupRoute> routeEditList = LogUtils.groupRouteDatVo_Transfer_Route(vo.getGroupRouteDayVOList(), vo.getGroupOrder().getDepartureDate());
		//logList.addAll(LogUtils.LogRow_GroupRoute_OrderId(request, orderId, routeEditList, routeList)); //groupRoute

		//保存订单
		orderId = specialGroupOrderService.saveOrUpdateSpecialOrderInfo(vo,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(),WebUtils.getCurBizId(request));
		
		//日志OrderId赋值
		LogUtils.LogRow_SetValue(logList, "group_order", orderId, null);
		LogUtils.LogRow_SetValue(logList, "group_order_price", null, orderId);
		LogUtils.LogRow_SetValue(logList, "group_order_guest", null, orderId);
		LogUtils.LogRow_SetValue(logList, "group_order_transport", null, orderId);
		//LogUtils.LogRow_SetValue(logList, "group_route", null, orderId);
		
		
		
		 //减资源库存
		TrafficResStocklog trafficResStocklog=new TrafficResStocklog();
		if(vo.getGroupOrder().getType()==0){
			trafficResStocklog.setAdjustAction(com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.ORDER_RESERVE.toString()); // 预留
		}
		if(vo.getGroupOrder().getType()==1){
			trafficResStocklog.setAdjustAction(com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION.ORDER_SOLD.toString()); // 全款
		}
		trafficResStocklog.setAdjustNum(num);
		trafficResStocklog.setResId(vo.getGroupOrder().getExtResId());
		trafficResStocklog.setAdjustTime(new Date());
		trafficResStocklog.setUserId(WebUtils.getCurUserId(request));
		trafficResStocklog.setUserName(WebUtils.getCurUser(request).getName());
		if (num > 0){
			trafficResService.insertTrafficResStocklog(trafficResStocklog); //Stock表 
			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res_stocklog", 0, trafficResProduct.getResId() ,"库位变动", trafficResStocklog, null));
		}
		
		//更新产品已售数量  
		if (null != trafficResProduct){
			Integer sumPerson = groupOrderService.selectSumPersonByProductId(trafficResProduct.getProductCode(), vo.getGroupOrder().getDepartureDate());
			trafficResProduct.setNumSold(sumPerson);
			trafficResService.updateNumSoldById(trafficResProduct);
		}
		
		//更新资源的库存数量
		trafficResService.updateStockOrStockDisable(vo.getGroupOrder().getExtResId());
		
		//插入到日志
		logService.insert(logList);
		
		return successJson("groupId",orderId+"");
	}
	
	@RequestMapping("receivables.htm")   // 收款
	public String receivables(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id) {
		//id=80826;
		GroupOrder go=groupOrderService.selectByPrimaryKey(id);
		model.addAttribute("go", go); 
		return "resTraffic/receivables";
	}

	@RequestMapping(value = "makeCollections.do")  // 收款确定
	@ResponseBody
	@PostHandler
	public String makeCollections(HttpServletRequest request, HttpServletResponse reponse,
			ModelMap model, FinancePay pay,Integer orderId) {
		PlatformEmployeePo emp = WebUtils.getCurUser(request);
		pay.setUserId(emp.getEmployeeId());
		pay.setUserName(emp.getName());
		pay.setBizId(WebUtils.getCurBizId(request));
		pay.setSupplierType(1);
		pay.setPayDate(new Date());
		pay.setPayDirect(1);
		pay.setCreateTime((new Date()).getTime());
		pay.setGroupId(0);
		financeService.makeCollections(pay, orderId);
		return successJson();
	}
	
	@RequestMapping("receivablesRecord.htm")  // 收款记录
	public String receivablesRecord(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id) {
		List<FinancePayDetail> financePayDetail=financeService.selectFinancePayList(id);
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
		List<TrafficResProduct> resProList = trafficResProductService.loadTrafficResProductInfo(resId);
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
		List<TrafficResProduct> resProList = trafficResProductService.loadTrafficResProductInfo(resId);
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
		TrafficResProduct tProductBean = trafficResProductService.selectByResProductId(productId);
		TrafficRes	 trafficRes =trafficResService.findTrafficResById(resId);
		TrafficResProduct trproBean = new TrafficResProduct();
		trproBean.setResId(resId);
		trproBean.setProductCode(0);
		trproBean.setProductName("");
		trproBean.setNumStock(0);
		trproBean.setNumSold(0);
		trproBean.setAdultCostPrice(new BigDecimal(0.0000));
		trproBean.setAdultSuggestPrice(new BigDecimal(0.0000));
		trproBean.setAdultSamePay(new BigDecimal(0.0000));
		trproBean.setAdultProxyPay(new BigDecimal(0.0000));
		trproBean.setAdultMinDeposit(new BigDecimal(0.0000));
		trproBean.setChildCostPrice(new BigDecimal(0.0000));
		trproBean.setChildSuggestPrice(new BigDecimal(0.0000));
		trproBean.setChildSamePay(new BigDecimal(0.0000));
		trproBean.setChildProxyPay(new BigDecimal(0.0000));
		trproBean.setChildMinDeposit(new BigDecimal(0.0000));
		trproBean.setBabyCostPrice(new BigDecimal(0.0000));
		trproBean.setBabySuggestPrice(new BigDecimal(0.0000));
		trproBean.setBabySamePay(new BigDecimal(0.0000));
		trproBean.setBadyProxyPay(new BigDecimal(0.0000));
		trproBean.setBadyMinDeposit(new BigDecimal(0.0000));
		trproBean.setUserId(WebUtils.getCurUserId(request));
		trproBean.setUserName(WebUtils.getCurUser(request).getName());
		//trproBean.setReserveTime(tProductBean.getReserveTime());
		/*if(null != tProductBean){
			trproBean.setReserveTime(tProductBean.getReserveTime());
		}else {
			if(null !=trafficRes.getDateLatest()){
				trproBean.setReserveTime(Integer.valueOf(trafficRes.getDateLatest()));
			}else{
				trproBean.setReserveTime(Integer.valueOf(trafficRes.getDateStart()+" 23:59"));
			}
		}*/
		if(null != tProductBean){
			trproBean.setReserveTime(tProductBean.getReserveTime());
		}else {
			trproBean.setReserveTime(0);
			
		}
		trproBean.setReserveStockLimit(0);
		trproBean.setTimeCreate(new Date());
		trproBean.setTimeUpdate(new Date());
		Integer id = trafficResProductService.insertTrafficResProduct(trproBean);
				
		//日志 
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
		logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "traffic_res_product", id, resId ,"新增产品", null, null));
		logService.insert(logList);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", id);
		return JSON.toJSONString(map);
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
		TrafficResProduct resProductBean = trafficResProductService.loadTrafficResProduct(resId);
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
		
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);

		//日志 
		List<LogOperator> logList = new ArrayList<LogOperator>();
		TrafficResProduct proBeanDB = trafficResProductService.loadTrafficResProduct(productBean.getId());
		logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.UPDATE, "traffic_res_product", productBean.getId(), productBean.getResId() ,"修改产品价格", productBean, proBeanDB));
		logService.insert(logList);
		
		productBean.setUserId(curUser.getEmployeeId());
		productBean.setUserName(curUser.getName());
		Map<String,Object> map = new HashMap<String,Object>();
		
		int saveNum = trafficResProductService.saveTrafficResProduct(productBean);
		map.put("success", saveNum);
		map.put("resId", productBean.getResId());
		return JSON.toJSONString(map);
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
		//日志 
				PlatformEmployeePo curUser = WebUtils.getCurUser(request);
				List<LogOperator> logList = new ArrayList<LogOperator>();
				TrafficResProduct proBeanDB = trafficResProductService.loadTrafficResProduct(id);
				logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.DELETE, "traffic_res_product", id, proBeanDB.getResId() ,"删除产品", proBeanDB, null));
				logService.insert(logList);
				
		int delNum = trafficResProductService.delTrafficResProduct(id);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", delNum);
		return JSON.toJSONString(map);
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
	public String toUpdateProductPrice(HttpServletRequest request,String id,String suggest_price_id,String adjust_uprodown_num,String price, Integer resId){
		//统一调整价格日志
		String[] sourceStrArray = id.split(",");
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
        for (int i = 0; i < sourceStrArray.length; i++) {
        	Integer pid = Integer.valueOf(sourceStrArray[i]);
    		
    		String brief = String.format("统一[%s]%s：%s", "0".equals(adjust_uprodown_num)?"上调":"下调", toUpdateProductPrice_GetFieldName(Integer.valueOf(suggest_price_id)), price);
    		logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.UPDATE, "traffic_res_product", pid, resId ,brief, null, null));
        }
        logService.insert(logList);
        
        
		int nums= trafficResProductService.loadByResProductId(id,suggest_price_id,adjust_uprodown_num,price);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", nums);
		return JSON.toJSONString(map);
	}
	private String toUpdateProductPrice_GetFieldName(Integer index){
		String ret = "";
		//"0" //更新上调成本价 1//更新上调零售价  2//更新上调同行返款  3//更新代理返款
		switch (index){
			case 0:
				ret = "成本价";
				break;
			case 1:
				ret = "零售价 ";
				break;
			case 2:
				ret = "同行返款";
				break;
			case 3:
				ret = "代理返款";
				break;
			default :
				ret = "<未定义>";
				break;
		}
		return ret;
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
		List<DicInfo> brandList = dicService
				.getListByTypeCode(BasicConstants.CPXL_PP,bizId);
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
		ProductInfo info = productInfoService.findProductInfoById(productId);
		//先判断选择的产品名称是否有重复，若已经存在产品，则不能添加该产品
		int productIdCount = 
				trafficResProductService.selectResProductNameCount(productId, resId);
		if(productIdCount == 0){
			model.addAttribute("productIdCount", productIdCount);
			
		}else {
			model.addAttribute("productIdCount", productIdCount); 
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("productIdCount", productIdCount);
		map.put("info", info);
		return JSON.toJSONString(map);
	}
	
	@RequestMapping(value = "/productList.do")
	public String toSearchList(HttpServletRequest request, ModelMap model,ProductInfo productInfo,String productName, String name,Integer page,Integer pageSize) {
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
	
		pageBean = productInfoService.findProductRoutes(pageBean, parameters);

		model.addAttribute("brandList", brandList);
		model.addAttribute("page", pageBean);
		model.addAttribute("pageNum", page);
		log.info("跳转到产品列表");
		return "resTraffic/resProNameTable";
	}

}
