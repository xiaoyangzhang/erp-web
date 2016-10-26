package com.yihg.erp.controller.operation;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.management.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.GroupOrderTransportService;
import com.yihg.sales.api.GroupRequirementService;
import com.yihg.sales.api.GroupRouteService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderTransport;
import com.yihg.sales.po.GroupRequirement;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.GroupRouteDayVO;
import com.yihg.sales.vo.GroupRouteVO;
import com.yihg.supplier.api.BizSupplierRelationService;
import com.yihg.supplier.api.ContractService;
import com.yihg.supplier.api.SupplierCarService;
import com.yihg.supplier.api.SupplierImgService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.BizSupplierRelation;
import com.yihg.supplier.po.SupplierCar;
import com.yihg.supplier.po.SupplierContract;
import com.yihg.supplier.po.SupplierContractPrice;
import com.yihg.supplier.po.SupplierContractPriceDateInfo;
import com.yihg.supplier.vo.SupplierCarVO;
import com.yimayhd.erpcenter.facade.sales.query.ContractQueryDTO;
import com.yimayhd.erpcenter.facade.sales.result.operation.TourGroupInfoResult;
import com.yimayhd.erpcenter.facade.sales.service.BookingComponentFacade;

@Controller
@RequestMapping("/booking")
public class BookingComponentController extends BaseController {
	
	@Autowired
	private GroupOrderTransportService groupOrderTransportService;
	@Autowired
	private GroupOrderGuestService groupOrderGuestService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private GroupRequirementService groupRequirementService;
	@Autowired
	private GroupRouteService groupRouteService;
	@Autowired
	private GroupOrderService groupOrderService;
	@Autowired
	private ContractService contractService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SupplierCarService supplierCarService;
	@Autowired
	private SupplierImgService supplierImgService;
	@Autowired
	private BookingSupplierDetailService detailService;
	@Autowired
    private BizSupplierRelationService bizSupplierRelationService;
	@Autowired
	private BookingComponentFacade bookingComponentFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@Autowired
	private SysConfig config;
	@RequestMapping("guestList.htm")
	public String guestList(HttpServletRequest request,HttpServletResponse response,ModelMap model, Integer orderId){
		if(orderId==null){
			orderId = 0;
		}
		// 客人列表
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest> groupOrderGuests = bookingComponentFacade.selectGuestByOrderId(orderId);
		model.addAttribute("guestList", groupOrderGuests);
		return "/operation/component/guest-list";
	}
	
	@RequestMapping("transportList.htm")
	public String transportList(HttpServletRequest request,HttpServletResponse response,ModelMap model, Integer orderId){
		if(orderId==null){
			orderId = 0;
		}
		List<com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport> groupOrderTransports = bookingComponentFacade.selectTransportByOrderId(orderId);
		model.addAttribute("transportList", groupOrderTransports);
		int bizId = WebUtils.getCurBizId(request);
//		List<DicInfo> jtfsList = dicService
//				.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		List<com.yimayhd.erpcenter.dal.basic.po.DicInfo> transportList = saleCommonFacade.getTransportListByTypeCode(bizId);
		model.addAttribute("transportTypeList", transportList);
		return "/operation/component/transport-list";
	}
	
	/***
	 * 加载团组信息
	 * @param request
	 * @param response
	 * @param model
	 * @param gid 团id
	 * @param stype 供应商类型
	 * @param showr 是否显示需求信息
	 * @return
	 */
	@RequestMapping("groupDetail.htm")
	public String groupDetail(HttpServletRequest request,HttpServletResponse response,ModelMap model, Integer gid,Integer stype,Integer flag){
		TourGroupInfoResult result = bookingComponentFacade.getTourGroupInfo(gid, stype);
//		TourGroup groupInfo = tourGroupService.selectByPrimaryKey(gid);	
//		if (groupInfo!=null) {
//			if (groupInfo.getServiceStandard() != null) {
//				groupInfo.setServiceStandard(groupInfo.getServiceStandard().replaceAll("[\\n]", "<br/>"));
//			}
//			if (groupInfo.getRemarkInternal() != null) {
//				groupInfo.setRemarkInternal(groupInfo.getRemarkInternal().replaceAll("[\\n]", "<br/>"));
//			}
//			if (groupInfo.getRemark() != null) {
//				groupInfo.setRemark(groupInfo.getRemark().replaceAll("[\\n]", "<br/>"));
//			}
//		}
		//List<BookingSupplierDetail> driverList = detailService.getDriversByGroupIdAndType(gid, null);
		model.addAttribute("group", result.getTourGroup());
		model.addAttribute("groupId", gid);
		String supplierName = "";
		//团队才有组团社
		//if(groupInfo!=null && groupInfo.getGroupMode()>0){
			//List<GroupOrder> list = groupOrderService.selectOrderByGroupId(gid);
		if(CollectionUtils.isEmpty(result.getOrders())){
				supplierName=result.getOrders().get(0).getSupplierName();
			}
		//}
		model.addAttribute("supplierName",supplierName);
//		if(stype!=null && stype==1){
//			List<GroupRequirement> requirementList = groupRequirementService.selectByGroupIdAndType(gid, stype);
			model.addAttribute("requireList", result.getGroupRequirements());
		//}
		model.addAttribute("stype", stype);
		//GroupRouteVO routeVo = groupRouteService.findGroupRouteByGroupId(gid);	
		List<com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupRouteDayVO> routeList = result.getGroupRoute().getGroupRouteDayVOList();
		model.addAttribute("routeList",routeList);
		if (null==flag) {
			return "/operation/component/group-detail";
		}
		else {
			return "/operation/financeShop/group-detail";
			
		}
		
		
	}
	
	/**
	 * 根据供应商、用户选择的类型和日期获取协议价
	 * @param request
	 * @param response
	 * @param model
	 * @param supplierId
	 * @param type1
	 * @param type2
	 * @param type2Name
	 * @param date
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value="price.do",method=RequestMethod.POST)
	@ResponseBody
	public String price(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer supplierId,Integer type1,Integer type2,String type2Name,Date date) throws ParseException{
		String jsonstr = getPriceJson(request,supplierId,type1,type2,type2Name,date);
		return jsonstr;
	}
	
	private String getPriceJson(HttpServletRequest request,Integer supplierId,Integer type1,Integer type2,String type2Name,Date date){
		Integer bizId = WebUtils.getCurBizId(request);
		ContractQueryDTO queryDTO = new ContractQueryDTO();
		queryDTO.setBizId(bizId);
		queryDTO.setSupplierId(supplierId);
		queryDTO.setDate(date);
		queryDTO.setType1(type1);
		queryDTO.setType2(type2);
		queryDTO.setType2Name(type2Name);
		List<com.yimayhd.erpresource.dal.po.SupplierContractPriceDateInfo> priceList = bookingComponentFacade.getOperateContractPrice(queryDTO);
		com.yimayhd.erpresource.dal.po.SupplierContractPriceDateInfo price = null;
		if(!CollectionUtils.isEmpty(priceList)){
			price = priceList.get(0);			
			return JSON.toJSONString(price);
		}
		return null;
	}
	
	
	@RequestMapping(value="carPrice.htm")
	public String carPrice(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer type1,Integer seatCnt,Date date,Date dateTo) throws ParseException{
		Integer bizId = WebUtils.getCurBizId(request);
		//车协议的shop_supplier_id定为-bizId
		int bizCarContractId=0-bizId;
		ContractQueryDTO queryDTO = new ContractQueryDTO();
		queryDTO.setBizCarContractId(bizCarContractId);
		queryDTO.setDate(date);
		queryDTO.setDateTo(dateTo);
		queryDTO.setType1(type1);
		queryDTO.setSeatCnt(seatCnt);
		List<com.yimayhd.erpresource.dal.po.SupplierContractPriceDateInfo> priceList = bookingComponentFacade.getCarContractPrice(queryDTO);
		model.addAttribute("priceList", priceList);
		return "/operation/component/car-price-list";
	}
	
	@RequestMapping(value="contractPrice.htm")
	@ResponseBody
	public String contractPrice(HttpServletRequest request,HttpServletResponse response,ModelMap model, Integer gid,Integer supplierId) throws ParseException{
		String jsonstr = getContractPriceJson(request,gid,supplierId);
		return jsonstr;
	}
	
	private String getContractPriceJson(HttpServletRequest request,Integer gid,Integer supplierId){
		//TourGroup groupInfo = tourGroupService.selectByPrimaryKey(gid);
		Integer bizId = WebUtils.getCurBizId(request);
		ContractQueryDTO queryDTO = new ContractQueryDTO();
		queryDTO.setBizId(bizId);
		queryDTO.setSupplierId(supplierId);
		String result = bookingComponentFacade.getContractPriceJson(queryDTO);
//		List<Date> dateList = new ArrayList<Date>();
//		if(groupInfo!=null && groupInfo.getDaynum()!=null){
//			for(int i=0;i<groupInfo.getDaynum();i++){
//				dateList.add(DateUtils.addDays(groupInfo.getDateStart(),i));
//			}
//		}
		/*DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		dateList.add(format.parse("2015-8-5"));
		dateList.add(format.parse("2015-8-6"));*/
//		if(dateList.size()==0){
//			return "[]";
//		}
		//List<SupplierContractPriceDateInfo> priceList = contractService.getContractPriceByPramas(bizId, supplierId,null, dateList);
//		if(priceList==null){
//			return "[]";
//		}
		return result;
	}
	
	@RequestMapping(value="contractPriceExt.htm")
	@ResponseBody
	public String contractPrice(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer supplierId,Integer goodsId,String date){
		Date curDate;
		try {
			curDate = DateUtils.parseDate(date, new String[]{"yyyy-MM-dd"});
		} catch (ParseException e) {
			return "[]";
		}
		List<Date> dateList = new ArrayList<Date>();
		dateList.add(curDate);
		Integer bizId = WebUtils.getCurBizId(request);	
		ContractQueryDTO queryDTO = new ContractQueryDTO();
		queryDTO.setBizId(bizId);
		queryDTO.setSupplierId(supplierId);
		queryDTO.setDateList(dateList);
		queryDTO.setGoodsId(goodsId);
		List<com.yimayhd.erpresource.dal.po.SupplierContractPriceDateInfo> priceList = bookingComponentFacade.getContractPriceByPramas(queryDTO);
		if(priceList==null){
			return "[]";
		}
		return JSON.toJSONString(priceList);
	}
	@RequestMapping(value = "toSupplierCarList.htm")
	public String toSupplierCarList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierCar supplierCar) {
		PageBean pageBean = new PageBean();
		pageBean.setParameter(supplierCar);
		pageBean.setPage(supplierCar.getPage());
		pageBean.setPageSize(supplierCar.getPageSize());
		PageBean page = supplierCarService.selectPrivateCarListPage(pageBean,
				WebUtils.getCurBizId(request));
		List<SupplierCarVO> voList = new ArrayList<SupplierCarVO>();
		List<SupplierCar> result = page.getResult();
		if (result != null && result.size() > 0) {
			for (SupplierCar sc : result) {
				SupplierCarVO scv = new SupplierCarVO();
				scv.setSupplierCar(sc);
				scv.setImgList(supplierImgService.selectBySupplierCommentImgId(
						sc.getId(), 5));
				voList.add(scv);
			}
		}
		model.addAttribute("voList", voList);
		model.addAttribute("config", config);
		model.addAttribute("page", page);
		model.addAttribute("supplierCar", supplierCar);
		List<DicInfo> list = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		model.addAttribute("carType", list);
		return "/operation/supplier/car/supplierCarList";
	}
	
	@RequestMapping(value = "deliveryContract.htm")
	public String deliveryContract(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer supplierId){
		SupplierContract supplierContract = new SupplierContract();
		//有效的协议
		supplierContract.setState(1);
		Integer bizId = WebUtils.getCurBizId(request);
		BizSupplierRelation bizSupplierRelation = bizSupplierRelationService.getByBizIdAndSupplierId(bizId, supplierId);
		PageBean<SupplierContract> pageBean = new PageBean<SupplierContract>();
		pageBean.setPageSize(100);
        pageBean.setPage(supplierContract.getPage());
        pageBean.setParameter(supplierContract);
        if(bizSupplierRelation != null){
            pageBean = contractService.findContracts(pageBean, bizSupplierRelation.getId());
        }
        model.addAttribute("page", pageBean);
		return "/operation/component/delivery-contract-list";
	}
	@RequestMapping(value = "deliveryContractPrice.do",method=RequestMethod.POST)
	public String deliveryContractPrice(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer contractId){
		List<SupplierContractPrice> supplierContractPrices = contractService.getContractPriceListByContractId(contractId);
		model.addAttribute("priceList", supplierContractPrices);
		return "/operation/component/delivery-contract-list-table";
	}
}
