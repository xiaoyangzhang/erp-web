package com.yihg.erp.controller.operation;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.basic.api.DicService;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceService;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingShopDetailDeployService;
import com.yihg.operation.api.BookingShopDetailService;
import com.yihg.operation.api.BookingShopService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingShop;
import com.yihg.operation.po.BookingShopDetail;
import com.yihg.operation.po.BookingShopDetailDeploy;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.operation.vo.BookingGroup;
import com.yihg.operation.vo.BookingShopDetailDeployVO;
import com.yihg.operation.vo.BookingShopDetailVO;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.TourGroupPriceAndPersons;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroup;
import com.yimayhd.erpcenter.facade.sales.query.BookingShopDTO;
import com.yimayhd.erpcenter.facade.sales.query.BookingShopDetailDeployDTO;
import com.yimayhd.erpcenter.facade.sales.query.BookingShopListDTO;
import com.yimayhd.erpcenter.facade.sales.result.ToFactShopResult;
import com.yimayhd.erpcenter.facade.sales.service.BookingShopFacade;
/**
 * @author : xuzejun
 * @date : 2015年7月25日 下午2:31:01
 * @Description: 客人-购物
 */
@Controller
@RequestMapping("/bookingGuestShop")
public class BookingGuestShopController extends BaseController {

	
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private SupplierService supplierSerivce;
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
	private BookingSupplierDetailService detailService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private BookingShopFacade bookingShopFacade;
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物页面
	 */
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String toList(ModelMap model,HttpServletRequest request) {
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult departmentTuneQueryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", departmentTuneQueryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", departmentTuneQueryResult.getOrgUserJsonStr());
		
		return "operation/guestShop/shop-list";
	}
	
	@RequestMapping(value = "/bookingShopList.do")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String bookingShopList(HttpServletRequest request, ModelMap model,TourGroup group,TourGroupVO groupVo) {
		BookingShopListDTO bookingShopListDTO = new BookingShopListDTO();
		bookingShopListDTO.setGroup(group);
		bookingShopListDTO.setBizId(WebUtils.getCurBizId(request));
		bookingShopListDTO.setOrgIds(groupVo.getOrgIds());
		bookingShopListDTO.setSaleOperatorIds(groupVo.getSaleOperatorIds());
		bookingShopListDTO.setDataUserIds(WebUtils.getDataUserIdSet(request));
		PageBean pageBean = bookingShopFacade.bookingShopList(bookingShopListDTO);
		model.addAttribute("page", pageBean);
		return "operation/guestShop/shop-listView";
	}
	
	
	private void fillData(List<BookingGroup> bookingGroupList){
		if(bookingGroupList!=null&&bookingGroupList.size()>0){
			for(BookingGroup group : bookingGroupList){
				if(group.getProductBrandName()!=null){
					group.setProductName("【"+group.getProductBrandName()+"】"+group.getProductName());
				}
				//填充定制团的组团社名称
				if(group.getSupplierId()!=null){
					SupplierInfo supplierInfo = supplierSerivce.selectBySupplierId(group.getSupplierId());
					if(supplierInfo!=null){
						group.setSupplierName(supplierInfo.getNameFull());
					}
				}

				//group.setCount(bookingShopService.getSelectCountByGruopId(group.getGroupId()));
				
			}
		}
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物列表下拉详情
	 */
	@RequestMapping(value = "/shopDetailList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String shopDetailList( ModelMap model,Integer groupId) {
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop> bookingShops = bookingShopFacade.shopDetailList(groupId);
		BigDecimal count=new BigDecimal(0);
		for (com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop bookingShop : bookingShops) {
			if(bookingShop.getTotalMoney()!=null){
				count=count.add(bookingShop.getTotalMoney());
			}
			
		}
		model.addAttribute("groupId", groupId);
		model.addAttribute("shopList", bookingShops);
		model.addAttribute("count", count);
		
		return "operation/guestShop/shop-listViewDetail";
	}
	
	
	/**s
	 * @author : xuzejun
	 * @date : 2015年7月29日 下午3:32:39
	 * @Description: 分配购物 type 1:购物店 0：指标
	 */
	@RequestMapping(value = "/toBookingShopView.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String toEditBookingShop( ModelMap model,Integer groupId,Integer type) {
		List<BookingShop> shoplist = bookingShopService.getShopListByGroupId(groupId);
		model.addAttribute("shoplist", shoplist);
		model.addAttribute("groupId", groupId);
		
		if(type==1){
			return "operation/guestShop/alltoShop-list";
		}else{
			model.addAttribute("view", 1);
			TourGroupPriceAndPersons tourGroupInfo = tourGroupService.selectTourGroupInfo(groupId);
			tourGroupInfo.setProfit(tourGroupInfo.getIncomeIncome()-tourGroupInfo.getCostTotalPrice());
			tourGroupInfo.setTotalProfit(tourGroupInfo.getProfit()/tourGroupInfo.getTotalAdult());
			model.addAttribute("tourGroupInfo", tourGroupInfo);
			return "operation/guestShop/alltoIndex-list";
		}
	
		
	}
	
	@RequestMapping(value = "/bookingShopView.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String bookingShopView( ModelMap model,Integer groupId,Integer type) {
		List<BookingShop> shoplist = bookingShopService.getShopListByGroupId(groupId);
		model.addAttribute("shoplist", shoplist);
		model.addAttribute("groupId", groupId);
			TourGroupPriceAndPersons tourGroupInfo = tourGroupService.selectTourGroupInfo(groupId);
			tourGroupInfo.setProfit(tourGroupInfo.getIncomeIncome()-tourGroupInfo.getCostTotalPrice());
			tourGroupInfo.setTotalProfit(tourGroupInfo.getProfit()/tourGroupInfo.getTotalAdult());
			model.addAttribute("tourGroupInfo", tourGroupInfo);
			model.addAttribute("view", 0);
			return "operation/guestShop/alltoIndex-list";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月29日 下午3:32:39
	 * @Description: 添加购物店
	 */
	@RequestMapping(value = "/editShop.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String editShop( ModelMap model,Integer groupId,Integer id) {
		model.addAttribute("groupId", groupId);
		if(id!=null){
			BookingShop shop = bookingShopService.selectByPrimaryKey(id);
			model.addAttribute("shop", shop);
		}
		//查询导游列表
		List<BookingGuide> guides = bookingGuideService.selectGuidesByGroupId(groupId);
		model.addAttribute("guides", guides);
		return "operation/guestShop/edit-shop";
		
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增shop
	 */
	@RequestMapping(value = "/saveShop.do")
	@ResponseBody
	public String saveShop(HttpServletRequest request, ModelMap model,BookingShop shop) {
		if(null==shop.getId()){
			int No = bookingShopService.getBookingCountByTime();
			shop.setBookingNo(bizSettingCommon.getMyBizCode(request)+Constants.SHOPPING+new SimpleDateFormat("yyMMdd").format(new Date())+(No+100));
			shop.setUserId(WebUtils.getCurUserId(request));
			shop.setUserName(WebUtils.getCurUser(request).getName());
		}
		String suc = bookingShopService.save(shop)>0?successJson():errorJson("操作失败！");
		if(shop.getId()!=null){
			financeService.calcTourGroupAmount(shop.getGroupId());
		}
	
		return suc;
	}


	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 删除导游信息
	 */
	@RequestMapping(value = "/deleteShop.do",method = RequestMethod.POST)
	@ResponseBody
	public String deldetailGuide(Integer id) {
		return bookingShopService.deleteByPrimaryKey(id)==1?successJson():errorJson("操作失败！");

	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月31日 下午3:56:31
	 * @Description: to实际消费添加页面
	 */
	@RequestMapping(value = "/toFactShop.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String toFactShop(Integer id,Integer groupId,ModelMap model) {
		BookingShopDTO bookingShopDTO = new BookingShopDTO();
		bookingShopDTO.setShopId(id);
		bookingShopDTO.setGroupId(groupId);
		ToFactShopResult result = bookingShopFacade.toFactShop(bookingShopDTO);
		model.addAttribute("id", id);
		model.addAttribute("detailDeploys", result.getDetailDeploys());
		model.addAttribute("shop", result.getShop());
		return "operation/guestShop/factShopView";
	}

	private List<BookingShopDetailDeploy> selectShopDetail(Integer id,
			Integer groupId) {
		List<BookingShopDetailDeploy> deploys = shopDetailDeployService.selectByBookingId(id);
		List<GroupOrder> groupOrders = tourGroupService.selectOrderAndGuestInfoByGroupId(groupId);
		List<BookingShopDetailDeploy> detailDeploys = new ArrayList<BookingShopDetailDeploy>();
		
		for (GroupOrder g : groupOrders) {
			boolean exist = false;
			BookingShopDetailDeploy deploy = new BookingShopDetailDeploy();
			deploy.setOrderId(g.getId());//订单id
			deploy.setOrderNo(g.getOrderNo());//订单号
			deploy.setSupplierName(g.getSupplierName());//组团社
			//deploy.setGuestSize(g.getGroupOrderGuestList().size());//人数
			deploy.setAdultNum(g.getNumAdult());
			deploy.setChildNum(g.getNumChild());
			/*StringBuffer sb = new StringBuffer();
			if(null!=g.getGroupOrderGuestList()){
				List<GroupOrderGuest> groupOrderGuestList = g.getGroupOrderGuestList();
				for (int i = 0; i < groupOrderGuestList.size(); i++) {
						if(i!=groupOrderGuestList.size()-1){
							sb.append(groupOrderGuestList.get(i).getName()+",");
						}else{
							sb.append(groupOrderGuestList.get(i).getName());
						}
						
				}
			}*/
			deploy.setGuestNames(g.getReceiveMode());
			for (int i = 0; i < deploys.size()&& !exist; i++) {
				if(deploys.get(i).getOrderId().equals(g.getId())){
					deploy.setBookingId(id);
					deploy.setBuyTotal(deploys.get(i).getBuyTotal());
					deploy.setRemark(deploys.get(i).getRemark());
					detailDeploys.add(deploy);
					exist = true;
					break;
				}
			}
			if(!exist){
				
				deploy.setBookingId(id);
				deploy.setRemark(null);
				deploy.setBuyTotal(null);
				
				detailDeploys.add(deploy);
			}
			
		}
		return detailDeploys;
	}
	
	
	@RequestMapping(value = "/factShop.htm")
	@RequiresPermissions(PermissionConstants.JDGL_GUESTSHOPPING)
	public String factShop(Integer id,Integer groupId,ModelMap model) {
	
	BookingShop shop =bookingShopService.selectByPrimaryKey(id);
	/*		List<BookingShopDetail> shopDetails =shopDetailService.getShopDetailListByBookingId(id);*/
		List<BookingShopDetailDeploy> detailDeploys = selectShopDetail(id,
				groupId);
		model.addAttribute("detailDeploys", detailDeploys);
		model.addAttribute("id", id);
		/*model.addAttribute("shopDetails", shopDetails);*/
		model.addAttribute("shop", shop);
		model.addAttribute("view", 1);
		return "operation/guestShop/factShopView";
	}
	
	
	//分摊
	@RequestMapping(value = "/editDetailDeploy.htm")
	@ResponseBody
	public String editFactShop(BookingShopDetailDeploy b ,ModelMap model) {
			//查询分摊
			List<BookingShopDetailDeploy> deploys = shopDetailDeployService.selectByDetailId(b.getBookingDetailId());
			List<GroupOrder> groupOrders = tourGroupService.selectOrderAndGuestInfoByGroupId(b.getOrderId());
			List<BookingShopDetailDeploy> detailDeploys = new ArrayList<BookingShopDetailDeploy>();
			
			for (GroupOrder g : groupOrders) {
				boolean exist = false;
				BookingShopDetailDeploy deploy = new BookingShopDetailDeploy();
				deploy.setOrderId(g.getId());//订单id
				deploy.setOrderNo(g.getOrderNo());//订单号
				deploy.setSupplierName(g.getSupplierName());//组团社
				deploy.setGuestSize(g.getGroupOrderGuestList().size());//人数
				StringBuffer sb = new StringBuffer();
				if(null!=g.getGroupOrderGuestList()){
					List<GroupOrderGuest> groupOrderGuestList = g.getGroupOrderGuestList();
					for (int i = 0; i < groupOrderGuestList.size(); i++) {
							if(i!=groupOrderGuestList.size()-1){
								sb.append(groupOrderGuestList.get(i).getName()+",");
							}else{
								sb.append(groupOrderGuestList.get(i).getName());
							}
							
					}
				}
				deploy.setGuestNames(sb.toString());
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
		
		List<DicInfo> dic = dicService.getListByTypeCode(Constants.SHOPPING_TYPE_CODE);
		if(shopDetail.getId()!=null){
			shopDetail = shopDetailService.getShopDetailById(shopDetail.getId());
		}
		model.addAttribute("shopDate", shopDate.substring(0, 10));
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("shopDetail", shopDetail);
		model.addAttribute("dic", dic);
		return "operation/guestShop/edit-shopDetail";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增shop
	 */
	@RequestMapping(value = "/saveShopDetail.do")
	@ResponseBody
	public String saveShopDetail(BookingShopDetail shopDetail) {
		shopDetail.setType((byte)0);//客人购物录入
		String suc = shopDetailService.save(shopDetail)>0?successJson():errorJson("操作失败！");
		
		/*if(shopDetail.getId()!=null){
			financeService.calcTourGroupAmount(shopDetail.getBookingId());
		}*/
		return suc;
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 删除shopDetail信息
	 */
	@RequestMapping(value = "/delShopDetail.do",method = RequestMethod.POST)
	@ResponseBody
	public String delShopDetail(Integer id,Integer groupId) {
		String suc = shopDetailService.deleteByPrimaryKey(id)==1?successJson():errorJson("操作失败！");
		//financeService.calcTourGroupAmount(groupId);
		return suc;

	}
	/**
	 * @author : xuzejun
	 * @date : 2015年8月4日 下午8:31:12
	 * @Description: TODO保存分摊
	 */
	@RequestMapping(value = "/saveDeploy.do")
	@ResponseBody
	public String saveShopDetail(com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingShopDetailDeployVO deployVO) {
		BookingShopDetailDeployDTO bookingShopDetailDeployDTO = new BookingShopDetailDeployDTO();
		bookingShopDetailDeployDTO.setBookingShopDetailDeployVO(deployVO);
		int result = bookingShopFacade.saveDeploy(bookingShopDetailDeployDTO);
		return result>0?successJson():errorJson("操作失败！");
	}
	
	@RequestMapping("delBookingShop.do")
	@ResponseBody
	public String delBookingShop(Integer bookingId){
		if(bookingId==null){
			return errorJson("请选择要删除的购物数据");
		}
		int result = bookingShopFacade.delBookingShop(bookingId);
		if(result>0){
			return successJson();			
		}
		return errorJson("删除失败");		
	}
	@RequestMapping("toEditShop.htm")
	public String toAddShop(Integer groupId,HttpServletRequest request,HttpServletResponse response,ModelMap model){
		model.addAttribute("groupId", groupId);
		BookingShopDTO bookingShopDTO = new BookingShopDTO();
		bookingShopDTO.setGroupId(groupId);
		bookingShopDTO.setBizId(WebUtils.getCurBizId(request));
		List<Map<String, Object>> result = bookingShopFacade.toEditShop(bookingShopDTO);
		
		model.addAttribute("bookingGroups", result);		
		return "operation/guestShop/editShop";
		
	}
	
	@RequestMapping(value = "/saveDeploys.do")
	@ResponseBody
	public String saveShopDetails(String shopDetails) {
		bookingShopFacade.saveShopDetails(shopDetails);
		return successJson();
	}
	/*
	@RequestMapping("getMatchedDriver.htm")
	@ResponseBody
	public String getMatchedDriver(Integer guideId,Integer groupId){
		BookingGuide driverGuide = bookingGuideService.selectByGuideIdAndGroupId(guideId, groupId);
		BookingSupplierDetail driver = detailService.selectByPrimaryKey(driverGuide.getBookingDetailId());
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("driverId", driver.getDriverId());
		map.put("driverName", driver.getDriverName());
		return successJson(map);
		
	}
	*/
}
