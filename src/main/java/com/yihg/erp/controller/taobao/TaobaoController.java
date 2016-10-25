package com.yihg.erp.controller.taobao;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.ProductStockService;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.SpecialGroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.MergeGroupOrderVO;
import com.yihg.sales.vo.SpecialGroupOrderVO;
import com.yihg.supplier.constants.Constants;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.taobao.api.TaobaoOrderService;
import com.yihg.taobao.po.PlatTaobaoTrade;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;

/**
 * Created by zhoum on 2016/8/10.
 */
@Controller
@RequestMapping(value = "/taobao")
public class TaobaoController extends BaseController {
	@Autowired
	private GroupOrderService groupOrderService ;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private  PlatformEmployeeService platformEmployeeService;
	@Autowired
	private TaobaoOrderService taobaoOrderService;
	@Autowired
	private DicService dicService ;
	@Autowired
	private RegionService regionService;
	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private SpecialGroupOrderService specialGroupOrderService ;
	@Autowired
	private GroupOrderGuestService groupOrderGuestService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private ProductStockService productStockService;
	
	/**
	 * 操作单
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("taobaoOrderList.htm")
	public String taobaoOrderList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model) {
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicService
				.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		
		model.addAttribute("orgJsonStr",
				orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr",
				platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "sales/taobaoOrder/taobaoOrderList";
	}
	

	/**
	 * 操作单table
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 */
	@RequestMapping("taobaoOrderList_table.htm")
	public String taobaoOrderList_table(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,GroupOrder groupOrder) throws ParseException{
		if(groupOrder.getDateType()!=null && groupOrder.getDateType()==2){
			SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
			if(!"".equals(groupOrder.getStartTime())){
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime()).getTime()+"");
			}
			if(!"".equals(groupOrder.getEndTime())){
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
			
		}
		
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
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
				groupOrder.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		PageBean<GroupOrder> page = new PageBean<GroupOrder>();
		page.setParameter(groupOrder);
		page.setPage(groupOrder.getPage()==null?1:groupOrder.getPage());
		page.setPageSize(groupOrder.getPageSize() == null ? Constants.PAGESIZE
				: groupOrder.getPageSize());
		page =groupOrderService.selectSpecialOrderListPage(page, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		
		List<GroupOrder> list = page.getResult();
		Integer pageTotalAudit=0;
		Integer pageTotalChild=0;
		Integer pageTotalGuide=0;
		BigDecimal pageTotal=new BigDecimal(0);
		if(page.getResult()!=null && page.getResult().size()>0){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (GroupOrder groupOrder2 : list) {
				pageTotalAudit+=groupOrder2.getNumAdult()==null?0:groupOrder2.getNumAdult();
				pageTotalChild+=groupOrder2.getNumChild()==null?0:groupOrder2.getNumChild();
				pageTotalGuide+=groupOrder2.getNumGuide()==null?0:groupOrder2.getNumGuide();
				pageTotal =pageTotal.add(groupOrder2.getTotal()==null?new BigDecimal(0):groupOrder2.getTotal());
				Long createTime = groupOrder2.getCreateTime();
				String dateStr = sdf.format(createTime);
				groupOrder2.setCreateTimeStr(dateStr);
			}
		}
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,WebUtils.getCurBizId(request));
		model.addAttribute("typeList", typeList);
		model.addAttribute("pageTotalAudit", pageTotalAudit);
		model.addAttribute("pageTotalChild",pageTotalChild);
		model.addAttribute("pageTotalGuide",pageTotalGuide);
		model.addAttribute("pageTotal", pageTotal);
		model.addAttribute("page", page);
		GroupOrder go = groupOrderService.selectTotalSpecialOrder(groupOrder, WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("totalAudit", go.getNumAdult());
		model.addAttribute("totalChild", go.getNumChild());
		model.addAttribute("totalGuide", go.getNumGuide());
		model.addAttribute("total", go.getTotal());
		return "sales/taobaoOrder/taobaoOrderList_table";
	}	
	
	/*操作单-编辑*/
	@RequestMapping(value = "toEditTaobaoOrder.htm")
	public String toEditTaobaoOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,Integer id,Integer operType) throws ParseException{
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
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		model.addAttribute("typeList", typeList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("config", config);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		GroupOrder groupOrder = groupOrderService.findById(id);
		int count=0;
		if("stock".equals(vo.getGroupOrder().getOrderBusiness())){
		 count = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),sdf.parse(groupOrder.getDepartureDate()));
		}
		model.addAttribute("allowNum", count); // 库存
		List<RegionInfo> cityList = null;
		if(vo.getGroupOrder().getProvinceId()!=null && vo.getGroupOrder().getProvinceId()!=-1){
			cityList=regionService.getRegionById(vo.getGroupOrder().getProvinceId()+""); 
		}
		model.addAttribute("allCity", cityList);
		String guideStr="";
		List<GroupOrderGuest> guestList = groupOrderGuestService.selectByOrderId(id);
		if(guestList!=null){
			for (GroupOrderGuest groupOrderGuest : guestList) {
				if(groupOrderGuest.getType()==3){
					guideStr=("".equals(guideStr)?"":(guideStr+" | "))+groupOrderGuest.getName()+" "+groupOrderGuest.getMobile();
				}
			}
		}
		model.addAttribute("guideStr", guideStr);
		List<PlatTaobaoTrade> orders = null; 
		orders=taobaoOrderService.selectTaobaoOrderByOrderId(id);
		model.addAttribute("orders", orders);
		String tbOrderIds = "";
		if ( orders != null){
			for (PlatTaobaoTrade item : orders) {
				tbOrderIds += item.getId() +",";
			}
		}
		if (!"".equals(tbOrderIds))
			tbOrderIds = tbOrderIds.substring(0, tbOrderIds.length()-1);
		model.addAttribute("tbIds", tbOrderIds);

		
		return "sales/taobaoOrder/addNewTaobaoOrder";
	}

	/**
	 * 跳转到新增订单页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("addNewTaobaoOrder.htm")
	public String addNewTaobaoOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		model.addAttribute("operType", 1);
		GroupOrder groupOrder  = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		SpecialGroupOrderVO  vo = new SpecialGroupOrderVO();
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
		List<DicInfo> typeList = dicService
				.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,bizId);
		model.addAttribute("typeList", typeList);
/*		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);*/
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, bizId);
		model.addAttribute("lysfxmList", lysfxmList);
		model.addAttribute("config", config);
		

		return "sales/taobaoOrder/addNewTaobaoOrder";
	}
	
	/**
	 * 保存订单
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveSpecialGroup.do")
	@ResponseBody
	public String saveSpecialGroup(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,SpecialGroupOrderVO vo,String ids,String id,Integer GroupMode) throws ParseException{
		if(vo.getGroupOrder().getId()==null){
			vo.getGroupOrder().setOrderNo(settingCommon.getMyBizCode(request));
		}
		Integer orderId;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Integer newNum = vo.getGroupOrder().getNumAdult()
				+ vo.getGroupOrder().getNumChild();
		Integer oldNum = 0;
		try {
			if("stock".equals(vo.getGroupOrder().getOrderBusiness())){
			if (vo.getGroupOrder().getId() != null) {
				GroupOrder groupOrder =groupOrderService.findById(vo.getGroupOrder().getId());
				oldNum = groupOrder.getNumAdult()
						+groupOrder.getNumChild();
			}
			//查出库存(剩余人数)
			int freeCount = productStockService.getRestCountByProductIdAndDate(vo.getGroupOrder().getProductId(),sdf.parse(vo.getGroupOrder().getDepartureDate()));
			//实际库存应该是修改前人数+库存
			freeCount = oldNum + freeCount;
			if(newNum > freeCount){
				//如果新增人数大于库存,则不能保存
				return errorJson("由于库存剩余数有变化，目前剩余库存不足【" + newNum + "】！实际库存还有【" + freeCount + "】");
			}
			
			if (vo.getGroupOrder().getId() == null) {
			productStockService.updateStockCount(vo.getGroupOrder()
					.getProductId(), sdf.parse(vo.getGroupOrder()
					.getDepartureDate()), newNum );
			}
			}
			 orderId = specialGroupOrderService.saveOrUpdateSpecialOrderInfo(vo,WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(),WebUtils.getCurBizId(request));
			//todo取出原来ids，并对比现在在的ids，得到要删除的ids ,　　比如原来：１,２,３,４　删除了2,3－> 14, 
			if(id !="" && id.length()>0){
			id=id.substring(0,id.length()-1);
			taobaoOrderService.updateTaobaoOrderIdToZero(id);
			}
			if(ids.length()>0 && ids !=""){
				taobaoOrderService.updateTaobaoOrderId(orderId, ids);
			}
			List<GroupOrder> orderList = groupOrderService.selectGroupOrderById(orderId);
			List<MergeGroupOrderVO> result = new ArrayList<MergeGroupOrderVO>();
			for (int i = 0; i < orderList.size();) {
				GroupOrder order = orderList.get(i);
				GroupOrder groupOrder = groupOrderService.findById(order.getId());
				groupOrder.setGroupCode(order.getGroupCode());
				orderList.remove(order);
				MergeGroupOrderVO mov = new MergeGroupOrderVO();
				mov.getOrderList().add(groupOrder);
				result.add(mov);
			}
			specialGroupOrderService.mergetGroupTaobao(result, WebUtils.getCurBizId(request),
					WebUtils.getCurUserId(request), WebUtils.getCurUser(request)
							.getName(), settingCommon.getMyBizCode(request));
			GroupOrder groupOrder=groupOrderService.findById(orderId);
			TourGroup tourGroup=tourGroupService.selectByPrimaryKey(groupOrder.getGroupId());
			tourGroup.setGroupMode(GroupMode);
			tourGroupService.updateByPrimaryKey(tourGroup);
		} catch (ParseException e) {
			return errorJson("操作失败,请检查后重试！");
		}	
		if("stock".equals(vo.getGroupOrder().getOrderBusiness())&&vo.getGroupOrder().getId() != null){
		try {productStockService.updateStockCount(vo.getGroupOrder()
					.getProductId(), sdf.parse(vo.getGroupOrder()
					.getDepartureDate()), newNum - oldNum);
			 }
		catch (Exception e) {
			return errorJson("更新库存失败！");
		                              }
	 } 
		return successJson("groupId",orderId+"");
	}

	
	/**
	 * 淘宝订单导入页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("import_taobaoOrder.htm")
	/*@RequiresPermissions(PermissionConstants.XSGL_TAOBAO_AY)*/

	public String import_taobaoOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {

		UserSession user = WebUtils.getCurrentUserSession(request);
		//Map<String,Map<String,Boolean>> menuOptMap = user.getMenuOptMap();
		//request.setAttribute("optMap", optMap);
		Map<String,Boolean> optMap = user.getOptMap();
		model.addAttribute("optMap_AY", optMap.containsKey(PermissionConstants.XSGL_TAOBAO_ORDERLIST.concat("_").concat(PermissionConstants.XSGL_TAOBAO_AY)));
		model.addAttribute("optMap_YM", optMap.containsKey(PermissionConstants.XSGL_TAOBAO_ORDERLIST.concat("_").concat(PermissionConstants.XSGL_TAOBAO_YM)));
		model.addAttribute("optMap_TX", optMap.containsKey(PermissionConstants.XSGL_TAOBAO_ORDERLIST.concat("_").concat(PermissionConstants.XSGL_TAOBAO_TX)));
		model.addAttribute("optMap_JY", optMap.containsKey(PermissionConstants.XSGL_TAOBAO_ORDERLIST.concat("_").concat(PermissionConstants.XSGL_TAOBAO_JY)));
		model.addAttribute("optMap_OUTSIDE", optMap.containsKey(PermissionConstants.XSGL_TAOBAO_ORDERLIST.concat("_").concat(PermissionConstants.XSGL_TAOBAO_OUTSIDE)));
    	
		return "sales/taobaoOrder/import_taobaoOrder";
	}
	
	/**
	 * 淘宝订单导入页面table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("import_taobaoOrder_table.htm")
	public String import_taobaoOrder_table(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page) {
		PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
		pm.put("startMin",pm.get("startMin")+" 00:00:00");
		pm.put("startMax",pm.get("startMax")+" 23:59:59");
		pageBean.setParameter(pm);
		pageBean=taobaoOrderService.selectTaobaoOrderImport(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);
		
		return "sales/taobaoOrder/import_taobaoOrder_table";
	}
	
	/**
	 * 确定
	 * @param request
	 * @param model
	 * @return
	 */
/*	@RequestMapping("taobaoOrderInfo.do")
	public String taobaoOrderInfo(Integer orderId){
		taobaoOrderService.selectTaobaoOrderById(orderId);
		return null;
		
	}*/
	
	@RequestMapping("getTaobaoOrders.do")
	@ResponseBody()
	public String taobaoOrder_GetByIds(String ids){
		List<PlatTaobaoTrade> orders = null; 
		orders=taobaoOrderService.selectTaobaoOrderById(ids);
		return JSON.toJSONString(orders);
	}
	
	/**
	 * 淘宝原始单（爱游）
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("taobaoOriginalOrder.htm")
	public String taobaoOriginalOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String authClient) {

		model.addAttribute("authClient",authClient);
		//TODO
		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String,Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.XSGL_TAOBAO_TRADELIST;
		model.addAttribute("optMap_AY", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_AY)));
		model.addAttribute("optMap_YM", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_YM)));
		model.addAttribute("optMap_TX", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_TX)));
		model.addAttribute("optMap_JY", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_JY)));
		model.addAttribute("optMap_OUTSIDE", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_OUTSIDE)));

		
		return "sales/taobaoOrder/taobaoOriginalOrder";
	}
	
	/**
	 * 淘宝原始单table（爱游）
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("taobaoOriginalOrder_table.do")
	public String taobaoOriginalOrder_table(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page,String authClient) {
		PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		pm.put("myStoreId",authClient);
		pm.put("curUserName",WebUtils.getCurrentUserSession(request).getName());
		
		pm.put("startMin",pm.get("startMin")+" 00:00:00");
		pm.put("startMax",pm.get("startMax")+" 23:59:59");
		
		pageBean.setParameter(pm);
		
		pageBean=taobaoOrderService.selectTaobaoOrder(pageBean, WebUtils.getCurBizId(request));
	
		model.addAttribute("pageBean", pageBean);
		
		return "sales/taobaoOrder/taobaoOriginalOrder_table";
	}
	/**
     * 废弃
     */
	@RequestMapping("updateCancel.do")
	public String updateCancel(String idss){
		taobaoOrderService.updateCANCEL(idss);
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	/**
     * 还原
     */
	@RequestMapping("updateNew.do")
	public String updateNew(String idss){
		taobaoOrderService.updateNEW(idss);
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	/**
     * 同步 by time
     */
	@RequestMapping("synchroByTime.do")
	public String synchroByTime(HttpServletRequest request,Integer pageSize, Integer page,ModelMap model,String authClient,String startTime,String endTime){
		PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		pm.put("myStoreId",authClient);
		pm.put("curUserName",WebUtils.getCurrentUserSession(request).getName());
		pm.put("startMin",startTime+" 00:00:00");
		pm.put("startMax",endTime+" 23:59:59");
		
		pageBean.setParameter(pm);
		
		pageBean=taobaoOrderService.selectTaobaoOrder(pageBean, WebUtils.getCurBizId(request));
		
		model.addAttribute("pageBean", pageBean);
		
		
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	/**
     * 同步 by tid
     */
	@RequestMapping("synchroByTid.do")
	public String synchroByTid(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page,String authClient,String tid){
		PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
		Map<String,Object> pm  = WebUtils.getQueryParamters(request);
		pm.put("myStoreId",authClient);
		pm.put("curUserName",WebUtils.getCurrentUserSession(request).getName());
		pm.put("tid",tid);
		
		pageBean.setParameter(pm);
		
		pageBean=taobaoOrderService.selectTaobaoOrderByTid(pageBean, WebUtils.getCurBizId(request));

		model.addAttribute("pageBean", pageBean);
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	
	/**
     * 淘宝授权
     *
     * @param model      model
     * @param authClient 授权客户端编码
     * @return 授权页面
     */
    @RequestMapping("/auth")
    public String auth(ModelMap model, String authClient) {
        
        model.addAttribute("authClient", authClient);
        
        return "taoBao/taoBaoAuth";
    }
}
