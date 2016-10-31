package com.yihg.erp.controller.operation;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetail;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShopDetailDeploy;
import com.yimayhd.erpcenter.dal.sales.client.operation.vo.BookingShopDetailDeployVO;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroupPriceAndPersons;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.TourGroupVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformOrgPo;
import com.yimayhd.erpcenter.facade.sales.query.BookingShopDTO;
import com.yimayhd.erpcenter.facade.sales.result.BookingShopResult;
import com.yimayhd.erpcenter.facade.sales.result.LoadBookingShopInfoResult;
import com.yimayhd.erpcenter.facade.sales.result.LoadShopInfoResult;
import com.yimayhd.erpcenter.facade.sales.result.ResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.WebResult;
import com.yimayhd.erpcenter.facade.sales.service.BookingShopFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
/**
 * @author : xuzejun
 * @date : 2015年7月25日 下午2:31:01
 * @Description: 计调-购物
 */
@Controller
@RequestMapping("/bookingShop")
public class BookingShopController extends BaseController {

	
	@Autowired
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private BookingShopFacade bookingShopFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private SaleCommonFacade saleCommonFacade;
	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model, HttpServletRequest request) {
//		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
//		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
		DepartmentTuneQueryDTO	departmentTuneQueryDTO = new  DepartmentTuneQueryDTO();
	    departmentTuneQueryDTO.setBizId(WebUtils.getCurBizId(request));
		DepartmentTuneQueryResult queryResult = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", queryResult.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", queryResult.getOrgUserJsonStr());
	}
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物页面
	 */
	@RequestMapping(value = "/list.htm")
	@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String toList(HttpServletRequest request,ModelMap model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		return "operation/shop/shop-list";
	}

	
	@RequestMapping(value = "/bookingShopList.do")
	@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String productSalesList(HttpServletRequest request, ModelMap model,TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if(group.getPage()==null){
			group.setPage(1);
		}
		if(group.getPageSize()==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(group.getPageSize());
		}
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(), group.getOrgIds(), WebUtils.getCurBizId(request)));
		group.setSupplierType(Constants.SHOPPING);
		group.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(group);
		pageBean.setPage(group.getPage());
		
		pageBean = bookingShopFacade.getShopGroupList(pageBean, group, WebUtils.getDataUserIdSet(request));
		/*fillData(pageBean.getResult());
		if (pageBean.getResult()!=null&&pageBean.getResult().size()>0) {
			for (BookingGroup bGroup : (List<BookingGroup>) pageBean.getResult()) {
				
				List<GroupOrder> gOrders = groupOrderService
						.selectOrderByGroupId(bGroup.getGroupId());
				bGroup.setGroupOrderList(gOrders);
			}
		}*/
		model.addAttribute("page", pageBean);
		return "operation/shop/shop-listView";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物列表下拉详情
	 */
	@RequestMapping(value = "/shopDetailList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String shopDetailList( ModelMap model,Integer groupId) {
//		List<BookingShop> bookingShops=bookingShopService.getShopListByGroupId(groupId);
		List<BookingShop> bookingShops = bookingShopFacade.shopDetailList(groupId);
		BigDecimal count=new BigDecimal(0);
		for (BookingShop bookingShop : bookingShops) {
			if(bookingShop.getTotalFace()!=null){
				count=count.add(bookingShop.getTotalFace());
			}
			
		}
		model.addAttribute("groupId", groupId);
		model.addAttribute("shopList", bookingShops);
		model.addAttribute("count", count);
		
		return "operation/shop/shop-listViewDetail";
	}
	
	/**
	 * 计调管理-预定安排
	 * @param model
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "/groupShopBookingList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupShopBookingList( ModelMap model,Integer groupId) {
//		List<BookingShop> bookingShops=bookingShopService.getShopListByGroupId(groupId);
		BookingShopResult result = bookingShopFacade.groupShopBookingList(groupId);
		BigDecimal count=new BigDecimal(0);
		List<BookingShop> bookingShops = result.getBookingShops();
		for (BookingShop bookingShop : bookingShops) {
			if(bookingShop.getTotalFace()!=null){
				count=count.add(bookingShop.getTotalFace());
			}
		}
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupCanEdit",result.isGroupAbleEdit() );
		model.addAttribute("shopList", bookingShops);
		model.addAttribute("count", count);
		
		return "operation/shop/group-shop-booking-list";
	}
	
	
	/**s
	 * @author : xuzejun
	 * @date : 2015年7月29日 下午3:32:39
	 * @Description: 分配购物 type 1:购物店 0：指标
	 */
	@RequestMapping(value = "/toBookingShopView.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String toEditBookingShop( ModelMap model,Integer groupId,Integer type) {
		model.addAttribute("groupCanEdit", bookingShopFacade.checkGroupCanEdit(groupId));
		return loadBookingShopInfo(model,groupId,type);
	}
	
	/**
	 * 购物管理：分配购物店不受团状态控制
	 * @param model
	 * @param groupId
	 * @param type
	 * @return
	 */
	@RequestMapping("toFinanceBookingShopView.htm")
	public String toFinanceBookingShop(ModelMap model,Integer groupId,Integer type){
		model.addAttribute("groupCanEdit", true);
		model.addAttribute("source", "Finance");		
		return loadBookingShopInfo(model,groupId,type);
	}
	
	private String loadBookingShopInfo(ModelMap model,Integer groupId,Integer type){
		LoadBookingShopInfoResult result = bookingShopFacade.loadBookingShopInfo(groupId);
		List<com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingShop> shoplist = result.getBookingShops();
		model.addAttribute("shoplist", shoplist);
		model.addAttribute("groupId", groupId);
		if(type==1){
			return "operation/shop/alltoShop-list";
		}else{
			model.addAttribute("view", 1);
			com.yimayhd.erpcenter.dal.sales.client.sales.po.TourGroupPriceAndPersons tourGroupInfo = result.getTourGroupPriceAndPersons();
			tourGroupInfo.setProfit(tourGroupInfo.getIncomeIncome()-tourGroupInfo.getCostTotalPrice());
			tourGroupInfo.setTotalProfit(tourGroupInfo.getProfit()/tourGroupInfo.getTotalAdult());
			model.addAttribute("tourGroupInfo", tourGroupInfo);
			return "operation/shop/alltoIndex-list";
		}
	}
	
	@RequestMapping(value = "/bookingShopView.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String bookingShopView( ModelMap model,Integer groupId,Integer type) {
//		List<BookingShop> shoplist = bookingShopService.getShopListByGroupId(groupId);
		LoadBookingShopInfoResult result = bookingShopFacade.loadBookingShopInfo(groupId);
		model.addAttribute("shoplist", result.getBookingShops());
		model.addAttribute("groupId", groupId);
//			TourGroupPriceAndPersons tourGroupInfo = tourGroupService.selectTourGroupInfo(groupId);
	    TourGroupPriceAndPersons tourGroupInfo = result.getTourGroupPriceAndPersons();
		tourGroupInfo.setProfit(tourGroupInfo.getIncomeIncome()-tourGroupInfo.getCostTotalPrice());
		tourGroupInfo.setTotalProfit(tourGroupInfo.getProfit()/tourGroupInfo.getTotalAdult());
		model.addAttribute("tourGroupInfo", tourGroupInfo);
		model.addAttribute("view", 0);
		model.addAttribute("groupId", groupId);
		return "operation/shop/alltoIndex-list";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月29日 下午3:32:39
	 * @Description: 添加购物店
	 */
	@RequestMapping(value = "/editShop.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String editShop( ModelMap model,Integer groupId,Integer id) {
		model.addAttribute("groupCanEdit", bookingShopFacade.checkGroupCanEdit(groupId));
		return loadShopInfo(model,groupId,id);		
	}
	
	/**
	 * 购物录入-编辑购物店
	 * @param model
	 * @param groupId
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/editFinanceShop.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String editFinanceShop( ModelMap model,Integer groupId,Integer id) {
		model.addAttribute("groupCanEdit", true);
		model.addAttribute("source", "Finance");
		return loadShopInfo(model,groupId,id);		
	}
	
	private String loadShopInfo(ModelMap model,Integer groupId,Integer id){
		model.addAttribute("groupId", groupId);
		BookingShopDTO bookingShopDTO = new BookingShopDTO();
		bookingShopDTO.setGroupId(groupId);
		bookingShopDTO.setShopId(id);
		LoadShopInfoResult result = bookingShopFacade.loadShopInfo(bookingShopDTO);
		
		model.addAttribute("shop", result.getBookingShop());
		model.addAttribute("isEdit", result.getIsEdit());
		model.addAttribute("guides", result.getBookingGuides());
		return "operation/shop/edit-shop";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增shop
	 */
	@RequestMapping(value = "/saveShop.do")
	@ResponseBody
	public String saveShop(HttpServletRequest request, ModelMap model,BookingShop shop) {
		if(!bookingShopFacade.checkGroupCanEdit(shop.getGroupId())){
			return errorJson("该团已审核或封存，不允许修改该信息");
		}
		return saveShopInfo(request,model,shop);
	}

	/**
	 * 购物管理-分配购物店-保存
	 * @param request
	 * @param model
	 * @param shop
	 * @return
	 */
	@RequestMapping(value = "/saveShopFinance.do")
	@ResponseBody
	public String saveShopFinance(HttpServletRequest request, ModelMap model,BookingShop shop) {		
		return saveShopInfo(request,model,shop);
	}
	
	private String saveShopInfo(HttpServletRequest request, ModelMap model,BookingShop shop){
//		if(null==shop.getId()){
//			int No = bookingShopService.getBookingCountByTime();
//			shop.setBookingNo(bizSettingCommon.getMyBizCode(request)+Constants.SHOPPING+new SimpleDateFormat("yyMMdd").format(new Date())+(No+100));
			shop.setUserId(WebUtils.getCurUserId(request));
			shop.setUserName(WebUtils.getCurUser(request).getName());
//		}
//		String suc = bookingShopService.save(shop)>0?successJson():errorJson("操作失败！");
//		if(shop.getId()!=null){
//			financeService.calcTourGroupAmount(shop.getGroupId());
//		}
		ResultSupport resultSupport = bookingShopFacade.saveShopInfo(shop, bizSettingCommon.getMyBizCode(request));
		return resultSupport.isSuccess() ? successJson() : errorJson("操作失败！");
	}
	

	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 删除导游信息
	 */
	@RequestMapping(value = "/deleteShop.do",method = RequestMethod.POST)
	@ResponseBody
	public String deldetailGuide(Integer id) {
//		int count = shopDetailDeployService.getCountByShopId(id);
//		BigDecimal total = shopDetailDeployService.getSumBuyTotalByBookingId(id);
//		List<BookingShopDetail> lists = shopDetailService.getShopDetailListByBookingId(id);
//		if((count>0 && (total.compareTo(BigDecimal.ZERO))!=0) || lists.size()>0){
		WebResult<Map<String,Boolean>> webResult = bookingShopFacade.deldetailGuide(id);
		if (!webResult.isSuccess()  ) {
			if (webResult.getValue() != null) {
				
				JSONObject json = new JSONObject();
				json.put("fail", true);
				return json.toString();
			}
			return errorJson("操作失败！");
		}else {
			return successJson();
		}
//		}else{
//			return bookingShopService.deleteByPrimaryKey(id)==1?successJson():errorJson("操作失败！");
//		}
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月31日 下午3:56:31
	 * @Description: to实际消费添加页面
	 */
	@RequestMapping(value = "/toFactShop.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String toFactShop(Integer id,Integer groupId,ModelMap model) {
	
//		BookingShop shop =bookingShopService.selectByPrimaryKey(id);
		//查询实际消费返款列表
//		List<BookingShopDetail> shopDetails =shopDetailService.getShopDetailListByBookingId(id);
		BookingShopResult result = bookingShopFacade.toFactShop(id);
		model.addAttribute("id", id);
		model.addAttribute("shopDetails", result.getShopDetails());
		model.addAttribute("shop", result.getBookingShop());
		return "operation/shop/factShopView";
	}
	
	
	@RequestMapping(value = "/factShop.htm")
	//@RequiresPermissions(PermissionConstants.JDGL_SHOPPING)
	public String factShop(Integer id,Integer groupId,ModelMap model) {
	
//		BookingShop shop =bookingShopService.selectByPrimaryKey(id);
		//查询实际消费返款列表
//		List<BookingShopDetail> shopDetails =shopDetailService.getShopDetailListByBookingId(id);
		BookingShopResult result = bookingShopFacade.toFactShop(id);
		model.addAttribute("id", id);
		model.addAttribute("shopDetails", result.getShopDetails());
		model.addAttribute("shop", result.getBookingShop());
		model.addAttribute("view", 1);
		return "operation/shop/factShopView";
	}
	
	
	//分摊
	@RequestMapping(value = "/editDetailDeploy.htm")
	@ResponseBody
	public String editFactShop(BookingShopDetailDeploy b ,ModelMap model) {
			//查询分摊
//			List<BookingShopDetailDeploy> deploys = shopDetailDeployService.selectByDetailId(b.getBookingDetailId());
//			List<GroupOrder> groupOrders = tourGroupService.selectOrderAndGuestInfoByGroupId(b.getOrderId());
		BookingShopResult result = bookingShopFacade.editFactShop(b.getOrderId(), b.getBookingDetailId());	
		List<BookingShopDetailDeploy> detailDeploys = new ArrayList<BookingShopDetailDeploy>();
			List<GroupOrder> groupOrders = result.getGroupOrders();
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
				List<BookingShopDetailDeploy> deploys = result.getShopDetailDeploys();
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
		List<DicInfo> dic = saleCommonFacade.getShopListByTypeCode();
//		List<DicInfo> dic = dicService.getListByTypeCode(Constants.SHOPPING_TYPE_CODE);
		if(shopDetail.getId()!=null){
//			shopDetail = shopDetailService.getShopDetailById(shopDetail.getId());
			shopDetail = bookingShopFacade.getShopDetailById(shopDetail.getId());
		}
		model.addAttribute("shopDate", shopDate.substring(0, 10));
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("shopDetail", shopDetail);
		model.addAttribute("dic", dic);
		return "operation/shop/edit-shopDetail";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 新增shop
	 */
	@RequestMapping(value = "/saveShopDetail.do")
	@ResponseBody
	public String saveShopDetail(BookingShopDetail shopDetail) {
		
//		String suc = shopDetailService.save(shopDetail)>0?successJson():errorJson("操作失败！");
//		
//		if(shopDetail.getId()!=null){
//			financeService.calcTourGroupAmount(shopDetail.getBookingId());
//		}
		ResultSupport resultSupport = bookingShopFacade.saveShopDetail(shopDetail);
		return resultSupport.isSuccess() ? successJson() : errorJson(resultSupport.getResultMsg());
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月28日 下午6:12:33
	 * @Description: 删除shopDetail信息
	 */
	@RequestMapping(value = "/delShopDetail.do",method = RequestMethod.POST)
	@ResponseBody
	public String delShopDetail(Integer id,Integer groupId) {
//		String suc = shopDetailService.deleteByPrimaryKey(id)==1?successJson():errorJson("操作失败！");
//		financeService.calcTourGroupAmount(groupId);
		ResultSupport resultSupport = bookingShopFacade.delShopDetail(id, groupId);
		return resultSupport.isSuccess() ? successJson() : errorJson(resultSupport.getResultMsg());

	}
	/**
	 * @author : xuzejun
	 * @date : 2015年8月4日 下午8:31:12
	 * @Description: TODO保存分摊
	 */
	@RequestMapping(value = "/saveDeploy.do")
	@ResponseBody
	public String saveShopDetail(BookingShopDetailDeployVO deployVO) {
//		return shopDetailDeployService.insertSelective(deployVO)>0?successJson():errorJson("操作失败！");
		ResultSupport resultSupport = bookingShopFacade.saveShopDetail(deployVO);
		return resultSupport.isSuccess() ? successJson() : errorJson(resultSupport.getResultMsg());
	}
	
	/**
	 * 进店统计表
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "shopTJList.htm")
	public String shopTJList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
//		Integer bizId = WebUtils.getCurBizId(request);
//		getOrgAndUserTreeJsonStr(model, bizId);
		//model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "operation/shopTj/tjShopList";
	}
	
	/**
	 * 进店统计表
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @param group
	 * @return
	 */
	@RequestMapping(value = "/shopTJList.do")
	public String shopTJList(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if (page == null) {
			pageBean.setPage(1);
		} else {
			pageBean.setPage(page);
		}
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(), group.getOrgIds(),WebUtils.getCurBizId(request)));
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
//		pageBean = bookingShopService.selectShopTJListPage(pageBean);
//		List<Map<String,Object>> lists = pageBean.getResult();
//		for (Map<String, Object> map : lists) {
//			PlatformOrgPo platformOrgPo = orgService.getCompanyByEmployeeId(WebUtils.getCurBizId(request), (Integer)map.get("operator_id"));
//			if(null!=platformOrgPo){
//				map.put("company", platformOrgPo.getName());
//			}
//		}
		pageBean = bookingShopFacade.shopTJList(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);

		return "operation/shopTj/tjShopList-table";
	}
	/**
	 * 进店统计表打印预览
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @param group
	 * @return
	 */
	@RequestMapping(value = "/shopTJPrint.do")
	public String shopTJPrint(HttpServletRequest request,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if (page == null) {
			pageBean.setPage(1);
		} else {
			pageBean.setPage(page);
		}
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(), group.getOrgIds(),WebUtils.getCurBizId(request)));
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
//		pageBean = bookingShopService.selectShopTJListPage(pageBean);
//		List<Map<String,Object>> lists = pageBean.getResult();
//		for (Map<String, Object> map : lists) {
//			PlatformOrgPo platformOrgPo = orgService.getCompanyByEmployeeId(WebUtils.getCurBizId(request), (Integer)map.get("operator_id"));
//			if(null!=platformOrgPo){
//				map.put("company", platformOrgPo.getName());
//			}
//		}
		pageBean = bookingShopFacade.shopTJList(pageBean, WebUtils.getCurBizId(request));

		model.addAttribute("pageBean", pageBean);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("printMsg", "打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "operation/shopTj/tjShopList-print";
	}
	
	
	@RequestMapping(value = "/shopTJExcl.do")
	@ResponseBody
	public void shopTJExcl(HttpServletRequest request,HttpServletResponse response,
			ModelMap model, Integer pageSize, Integer page,TourGroupVO group){
		PageBean pageBean = new PageBean();
		if (page == null) {
			pageBean.setPage(1);
		} else {
			pageBean.setPage(page);
		}
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		//如果人员为空并且部门不为空，则取部门下的人id
//		if(StringUtils.isBlank(group.getSaleOperatorIds()) && StringUtils.isNotBlank(group.getOrgIds())){
//			Set<Integer> set = new HashSet<Integer>();
//			String[] orgIdArr = group.getOrgIds().split(",");
//			for(String orgIdStr : orgIdArr){
//				set.add(Integer.valueOf(orgIdStr));
//			}
//			set = platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
//			String salesOperatorIds="";
//			for(Integer usrId : set){
//				salesOperatorIds+=usrId+",";
//			}
//			if(!salesOperatorIds.equals("")){
//				group.setSaleOperatorIds(salesOperatorIds.substring(0, salesOperatorIds.length()-1));
//			}
//		}
		group.setSaleOperatorIds(productCommonFacade.setSaleOperatorIds(group.getSaleOperatorIds(), group.getOrgIds(),WebUtils.getCurBizId(request)));

		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		if(null!=group.getSaleOperatorIds() && !"".equals(group.getSaleOperatorIds())){
			pm.put("operator_id", group.getSaleOperatorIds());
		}
		pm.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(pm);
//		pageBean = bookingShopService.selectShopTJListPage(pageBean);
//		List<Map<String,Object>> lists = pageBean.getResult();
//		for (Map<String, Object> map : lists) {
//			PlatformOrgPo platformOrgPo = orgService.getCompanyByEmployeeId(WebUtils.getCurBizId(request), (Integer)map.get("operator_id"));
//			if(null!=platformOrgPo){
//				map.put("company", platformOrgPo.getName());
//			}
//		}
		pageBean = bookingShopFacade.shopTJList(pageBean, WebUtils.getCurBizId(request));

		model.addAttribute("pageBean", pageBean);
		List list = pageBean.getResult();
		String path ="";
		
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/tjShop.xlsx");
			FileInputStream input = new FileInputStream(new File(url));  //读取的文件路径 
	        XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input)); 
	        CellStyle cellStyle = wb.createCellStyle();
	        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        cellStyle.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        cellStyle.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        cellStyle.setAlignment(CellStyle.ALIGN_CENTER_SELECTION); // 居中
	        
	        CellStyle styleLeft = wb.createCellStyle();
	        styleLeft.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleLeft.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleLeft.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleLeft.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
	        
	        CellStyle styleRight = wb.createCellStyle();
	        styleRight.setBorderBottom(CellStyle.BORDER_THIN); //下边框    
	        styleRight.setBorderLeft(CellStyle.BORDER_THIN);//左边框    
	        styleRight.setBorderTop(CellStyle.BORDER_THIN);//上边框    
	        styleRight.setBorderRight(CellStyle.BORDER_THIN);//右边框
	        styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0) ; //获取到第一个sheet
			Row row = null;
			Cell cc = null ;
			// 遍历集合数据，产生数据行  
			
	        Iterator<Map<String,Object>> it = list.iterator();  
		    int index = 0;  
		    while (it.hasNext()){ 
		    	//团信息
		    	Map<String,Object> tourGroup = it.next() ;
		       //获取团下的导游列表
		       List<Map<String,Object>> guides = (List<Map<String, Object>>) tourGroup.get("guideTj");
		       if(null==guides || guides.size()<1){
		    	   //从第三行开始，前两行分别为标题和列明
	    		   row = sheet.createRow(index+2);
	    		   
	    		   //第一列：序号
	    		   cc = row.createCell(0);
	    		   cc.setCellValue(index+1);
	    		   cc.setCellStyle(cellStyle);
	    		   //第二列：公司
	    		   cc = row.createCell(1);
	    		   cc.setCellValue(tourGroup.get("company")==null?"":tourGroup.get("company").toString());
	    		   cc.setCellStyle(cellStyle);
	    		   
	    		   //第三列：团号
	    		   cc = row.createCell(2);
	    		   cc.setCellValue(tourGroup.get("group_code")==null?"":tourGroup.get("group_code").toString());
	    		   cc.setCellStyle(styleLeft);
	    		   
	    		   //第四列：产品名称
	    		   cc = row.createCell(3);
	    		   cc.setCellValue("【"+tourGroup.get("product_brand_name")+"】"+tourGroup.get("product_name"));
	    		   cc.setCellStyle(styleLeft);
	    		   
	    		   //第五列：计调	       
	    		   cc = row.createCell(4);
	    		   cc.setCellValue(tourGroup.get("operator_name")==null?"":tourGroup.get("operator_name").toString());
	    		   cc.setCellStyle(styleLeft);
	    		   //第六列：人数
	    		   cc = row.createCell(5);
	    		   cc.setCellValue(tourGroup.get("total_adult")+"大"+tourGroup.get("total_child")+"小"+tourGroup.get("total_guide")+"陪");
	    		   cc.setCellStyle(styleLeft);
	    		   //第七列：订单
	    		   cc = row.createCell(6);
	    		   cc.setCellValue(tourGroup.get("orders")==null?"":tourGroup.get("orders").toString().replaceAll("<br/>", "\r\n"));
	    		   cc.setCellStyle(cellStyle);
		    	   index++; 
		    	   
		       }else if(null!=guides && guides.size()>0){
		    	   Iterator<Map<String,Object>> it2 = guides.iterator();
		    	   
		    	   //合并列（公司）
		    	   CellRangeAddress company=new CellRangeAddress(index+2, index+1+guides.size(), 1, 1);
		    	   sheet.addMergedRegion(company); 
		    	   //合并列（团号）
		    	   CellRangeAddress region_phone=new CellRangeAddress(index+2, index+1+guides.size(), 2, 2);
		    	   sheet.addMergedRegion(region_phone); 
		    	   //合并列（产品名称）
		    	   CellRangeAddress region_siji=new CellRangeAddress(index+2, index+1+guides.size(), 3, 3);
		    	   sheet.addMergedRegion(region_siji); 
		    	   //合并列（计调）
		    	   CellRangeAddress region_daoguan=new CellRangeAddress(index+2, index+1+guides.size(), 4, 4);
		    	   sheet.addMergedRegion(region_daoguan); 
		    	   //合并列（人数）
		    	   CellRangeAddress renshu=new CellRangeAddress(index+2, index+1+guides.size(), 4, 4);
		    	   sheet.addMergedRegion(renshu); 
		    	   //合并列（订单）
		    	   CellRangeAddress dingdan=new CellRangeAddress(index+2, index+1+guides.size(), 4, 4);
		    	   sheet.addMergedRegion(dingdan); 
		    	   while (it2.hasNext()){ 
		    		   Map<String,Object> guide = it2.next();
		    		   
		    		   List<BookingShop> shop = (List<BookingShop>)guide.get("shop");
		    		   
		    		   if(null==shop || shop.size()<1){
		    			   
//		    			   //合并列（公司）
//				    	   CellRangeAddress company=new CellRangeAddress(index+2, index+1+guides.size(), 1, 1);
//				    	   sheet.addMergedRegion(company); 
//				    	   //合并列（团号）
//				    	   CellRangeAddress region_phone=new CellRangeAddress(index+2, index+1+guides.size(), 2, 2);
//				    	   sheet.addMergedRegion(region_phone); 
//				    	   //合并列（产品名称）
//				    	   CellRangeAddress region_siji=new CellRangeAddress(index+2, index+1+guides.size(), 3, 3);
//				    	   sheet.addMergedRegion(region_siji); 
//				    	   //合并列（计调）
//				    	   CellRangeAddress region_daoguan=new CellRangeAddress(index+2, index+1+guides.size(), 4, 4);
//				    	   sheet.addMergedRegion(region_daoguan); 
//				    	   //合并列（人数）
//				    	   CellRangeAddress renshu=new CellRangeAddress(index+2, index+1+guides.size(), 5, 5);
//				    	   sheet.addMergedRegion(renshu); 
//				    	   //合并列（订单）
//				    	   CellRangeAddress dingdan=new CellRangeAddress(index+2, index+1+guides.size(), 6, 6);
//				    	   sheet.addMergedRegion(dingdan); 
		    			   
		    			   //从第三行开始，前两行分别为标题和列明
		    			   row = sheet.createRow(index+2);
		    			   //第一列：序号
		    			   cc = row.createCell(0);
		    			   cc.setCellValue(index+1);
		    			   cc.setCellStyle(cellStyle);
		    			   
		    			   //第二列：公司
		    			   cc = row.createCell(1);
		    			   cc.setCellValue(tourGroup.get("company")==null?"":tourGroup.get("company").toString());
		    			   cc.setCellStyle(cellStyle);
		    			   
		    			   //第三列：团号
		    			   cc = row.createCell(2);
		    			   cc.setCellValue(tourGroup.get("group_code")==null?"":tourGroup.get("group_code").toString());
		    			   cc.setCellStyle(styleLeft);
		    			   
		    			   //第四列：产品名称
		    			   cc = row.createCell(3);
		    			   cc.setCellValue("【"+tourGroup.get("product_brand_name")+"】"+tourGroup.get("product_name"));
		    			   cc.setCellStyle(styleLeft);
		    			   
		    			   //第五列：计调	       
		    			   cc = row.createCell(4);
		    			   cc.setCellValue(tourGroup.get("operator_name")==null?"":tourGroup.get("operator_name").toString());
		    			   cc.setCellStyle(styleLeft);
		    			   //第六列：人数
		    			   cc = row.createCell(5);
		    			   cc.setCellValue(tourGroup.get("total_adult")+"大"+tourGroup.get("total_child")+"小"+tourGroup.get("total_guide")+"陪");
		    			   cc.setCellStyle(styleLeft);
		    			   //第七列：订单
		    			   cc = row.createCell(6);
		    			   cc.setCellValue(tourGroup.get("orders")==null?"":tourGroup.get("orders").toString().replaceAll("<br/>", "\r\n"));
		    			   cc.setCellStyle(cellStyle);
		    			   //第八列：导游
		    			   cc = row.createCell(7);
		    			   cc.setCellValue(guide.get("guide_name")==null?"":guide.get("guide_name").toString());
		    			   cc.setCellStyle(cellStyle);
		    			   //第九列：导游电话
		    			   cc = row.createCell(8);
		    			   cc.setCellValue(guide.get("guide_mobile")==null?"":guide.get("guide_mobile").toString());
		    			   cc.setCellStyle(cellStyle);
		    			   //第十列：司机
		    			   cc = row.createCell(9);
		    			   StringBuffer s =new StringBuffer();
		    			   s.append(guide.get("driver_name")==null?"":guide.get("driver_name").toString());
		    			   s.append(guide.get("driver_tel")==null?"":"("+guide.get("driver_tel").toString()+")");
		    			   s.append(guide.get("car_lisence")==null?"":guide.get("car_lisence").toString());
		    			   cc.setCellValue(s.toString());
		    			   cc.setCellStyle(cellStyle);
		    			   //第十一列：导游电话
		    			   cc = row.createCell(10);
		    			   cc.setCellValue(guide.get("user_name")==null?"":guide.get("user_name").toString());
		    			   cc.setCellStyle(cellStyle);
		    			   index++; 
		    		   }else if(null!=shop && shop.size()>0){
		    			   
				    	   //合并列（订单）
				    	   CellRangeAddress daoyou=new CellRangeAddress(index+2, index+1+shop.size(), 7, 7);
				    	   sheet.addMergedRegion(daoyou); 
				    	   //合并列（订单）
				    	   CellRangeAddress dianhua=new CellRangeAddress(index+2, index+1+shop.size(), 8, 8);
				    	   sheet.addMergedRegion(dianhua); 
				    	   //合并列（订单）
				    	   CellRangeAddress siji=new CellRangeAddress(index+2, index+1+shop.size(), 9, 9);
				    	   sheet.addMergedRegion(siji); 
				    	   //合并列（订单）
				    	   CellRangeAddress daoguan=new CellRangeAddress(index+2, index+1+shop.size(), 10, 10);
				    	   sheet.addMergedRegion(daoguan); 
				    	   
		    			   for(int k=0;k<shop.size();k++){
		    				   BookingShop sp = shop.get(k);
		    				   //从第三行开始，前两行分别为标题和列明
		    				   row = sheet.createRow(index+2);
		    				   //第一列：序号
		    				   cc = row.createCell(0);
		    				   cc.setCellValue(index+1);
		    				   cc.setCellStyle(cellStyle);
		    				   
		    				   //第二列：公司
		    				   cc = row.createCell(1);
		    				   cc.setCellValue(tourGroup.get("company")==null?"":tourGroup.get("company").toString());
		    				   cc.setCellStyle(cellStyle);
		    				   
		    				   //第三列：团号
		    				   cc = row.createCell(2);
		    				   cc.setCellValue(tourGroup.get("group_code")==null?"":tourGroup.get("group_code").toString());
		    				   cc.setCellStyle(styleLeft);
		    				   
		    				   //第四列：产品名称
		    				   cc = row.createCell(3);
		    				   cc.setCellValue("【"+tourGroup.get("product_brand_name")+"】"+tourGroup.get("product_name"));
		    				   cc.setCellStyle(styleLeft);
		    				   
		    				   //第五列：计调	       
		    				   cc = row.createCell(4);
		    				   cc.setCellValue(tourGroup.get("operator_name")==null?"":tourGroup.get("operator_name").toString());
		    				   cc.setCellStyle(styleLeft);
		    				   //第六列：人数
		    				   cc = row.createCell(5);
		    				   cc.setCellValue(tourGroup.get("total_adult")+"大"+tourGroup.get("total_child")+"小"+tourGroup.get("total_guide")+"陪");
		    				   cc.setCellStyle(styleLeft);
		    				   //第七列：订单
		    				   cc = row.createCell(6);
		    				   cc.setCellValue(tourGroup.get("orders")==null?"":tourGroup.get("orders").toString().replaceAll("<br/>", "\r\n"));
		    				   cc.setCellStyle(cellStyle);
		    				   //第八列：导游
		    				   cc = row.createCell(7);
		    				   cc.setCellValue(guide.get("guide_name")==null?"":guide.get("guide_name").toString());
		    				   cc.setCellStyle(cellStyle);
		    				   //第九列：导游电话
		    				   cc = row.createCell(8);
		    				   cc.setCellValue(guide.get("guide_mobile")==null?"":guide.get("guide_mobile").toString());
		    				   cc.setCellStyle(cellStyle);
		    				   //第十列：司机
		    				   cc = row.createCell(9);
		    				   StringBuffer s =new StringBuffer();
		    				   s.append(guide.get("driver_name")==null?"":guide.get("driver_name").toString());
		    				   s.append(guide.get("driver_tel")==null?"":"("+guide.get("driver_tel").toString()+")");
		    				   s.append(guide.get("car_lisence")==null?"":guide.get("car_lisence").toString());
		    				   cc.setCellValue(s.toString());
		    				   cc.setCellStyle(cellStyle);
		    				   //第十一列：导游电话
		    				   cc = row.createCell(10);
		    				   cc.setCellValue(guide.get("user_name")==null?"":guide.get("user_name").toString());
		    				   cc.setCellStyle(cellStyle);
		    				   if(null!=sp){
		    					   //第十二列：店名
		    					   cc = row.createCell(11);
		    					   cc.setCellValue(sp.getSupplierName());
		    					   cc.setCellStyle(cellStyle);
		    					   //第十三列：进店日期
		    					   cc = row.createCell(12);
		    					   cc.setCellValue(sp.getShopDate());
		    					   cc.setCellStyle(cellStyle);
		    					   //第十四列：进店人数
		    					   cc = row.createCell(13);
		    					   String num = sp.getPersonNum()==null?"":sp.getPersonNum().toString();
		    					   cc.setCellValue(num);
		    					   cc.setCellStyle(cellStyle);
		    				   }
		    				   index++; 
		    			   }
		    		   }
		    		   
		    	   }
		       }
		       
		    }
		    
		    CellRangeAddress region = new CellRangeAddress(index+3, index+4, 0, 13) ;
		    sheet.addMergedRegion(region) ;
		    row = sheet.createRow(index+3); //打印信息
		    cc = row.createCell(0);
		    cc.setCellValue("打印人："+WebUtils.getCurUser(request).getName()+" 打印时间："+DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path=request.getSession().getServletContext().getRealPath("/")+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
	    	wb.write(out);
	    	out.close();
	    	wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download(path, response,"tjShop.xlsx");
	}
	
	private void download(String path, HttpServletResponse response,String name) {  
        try {  
            // path是指欲下载的文件的路径。  
        	File file = new File(path);  
            // 取得文件名。  
        	String fileName = "";
    		try {
    			fileName = new String(name.getBytes("UTF-8"),
    					"iso-8859-1");
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
                    + new String(fileName.getBytes()));  
            response.addHeader("Content-Length", "" + file.length());  
            OutputStream toClient = new BufferedOutputStream(  
                    response.getOutputStream());  
            response.setContentType("application/vnd.ms-excel;charset=utf-8");  
            toClient.write(buffer);  
            toClient.flush();  
            toClient.close();
            file.delete() ;
        } catch (IOException ex) {
        	ex.printStackTrace();  
        }  
    }  
	
	
}
