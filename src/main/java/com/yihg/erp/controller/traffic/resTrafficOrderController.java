package com.yihg.erp.controller.traffic;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.LogOperatorService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.contants.BasicConstants.LOG_ACTION;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.LogOperator;
import com.yihg.basic.util.LogFieldUtil;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.TrafficResProductService;
import com.yihg.product.api.TrafficResService;
import com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION;
import com.yihg.product.po.TrafficResStocklog;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.SpecialGroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.MergeGroupOrderVO;
import com.yihg.supplier.constants.Constants;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.UserSession;

@Controller
@RequestMapping("/resOrder")
public class resTrafficOrderController extends BaseController{
	
	@Autowired
	private GroupOrderService groupOrderService;
	
	@Autowired
	private TourGroupService tourGroupService;
	
	@Autowired
	private TrafficResService trafficResService;
	
	@Autowired
	private LogOperatorService logService;
	
	@Autowired
	private DicService dicService;
	
	@Autowired
	private BizSettingCommon settingCommon;
	
	@Autowired
	private SpecialGroupOrderService specialGroupOrderService ;
	
	@RequestMapping("resGroupOrderList.htm")
	public String loadGroupOrderInfo(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandProductList = dicService.getListByTypeCode(BasicConstants.CPXL_PP, bizId);
		model.addAttribute("brandProductList", brandProductList);
		return "resTraffic/resGroupOrderList";
	}
	
	/**
	 * 订单数据展示Table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "loadResGroupOrderInfo.do")
	public String lockListTable(HttpServletRequest request, ModelMap model,Integer pageSize, Integer page){
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		Map<String,Object> pmBean  = WebUtils.getQueryParamters(request);
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
		pageBean.setParameter(pmBean);
		model.addAttribute("sum",
				groupOrderService.sumGroupOrder(pageBean));
		pageBean=groupOrderService.selectResGroupOrderList(pageBean,
				WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageBean", pageBean);
		return "resTraffic/resGroupOrderTable";
	}
	
	/**
	 * 取消订单信息
	 * @param request
	 * @param id 订单Id
	 * @param model
	 */
	@RequestMapping("toCancelOrder.do")
	public String cancelGroupOrderInfo(HttpServletRequest request,Integer id, ModelMap model){
		model.addAttribute("id", id);
		return "resTraffic/resCancelOrder";
	}
	
	@RequestMapping("toUpdateProductPrice.do")
	@ResponseBody
	public String toUpdateProductPrice(HttpServletRequest request,String id,String causeRemark, ModelMap model) throws ParseException{
		//int nums = groupOrderService.findUpdateGroupOrderState(id,causeRemark);
		
		//此方法为：分销商取消订单
		groupOrderService.findUpdateAdminOrderState(id, causeRemark);
		String ret = Update_OrderState(request, id, "2");
		return ret;
	}
	
	/**
	 * 管理员端订单列表页面跳转
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("resAdminOrderList.htm")
	public String loadAdminOrderInfo(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandProductList = dicService.getListByTypeCode(BasicConstants.CPXL_PP, bizId);
		model.addAttribute("brandProductList", brandProductList);
		return "resTraffic/resAdminOrderList";
	}
	
	/**
	 * 订单数据展示Table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "loadResAdmOrderInfo.do")
	public String adminOrderListTable(HttpServletRequest request, ModelMap model,Integer pageSize, Integer page){
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		Map<String,Object> pmBean  = WebUtils.getQueryParamters(request);
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
		pageBean.setParameter(pmBean);
		model.addAttribute("sum",
				groupOrderService.sumResAdminOrder(pageBean));
		pageBean=groupOrderService.selectResAdminOrderList(pageBean,
				WebUtils.getCurBizId(request),WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageBean", pageBean);
		//权限分配
		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String,Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.TRAFFICRES;
		model.addAttribute("optMap_EDIT", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.TRAFFICRES_EDIT)));
		model.addAttribute("optMap_PAY", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.TRAFFICRES_PAY)));
		return "resTraffic/resAdminOrderTable";
	}
	
	/**
	 * 管理员取消订单信息
	 * @param request
	 * @param id 订单Id
	 * @param model
	 */
	@RequestMapping("toAdminCancelOrder.do")
	public String cancelAdminOrderInfo(HttpServletRequest request,Integer id, ModelMap model){
		model.addAttribute("orderId", id);
		return "resTraffic/resAdminCancelOrder";
	}
	
	/**
	 * 取消订单，更新操作
	 * @param request
	 * @param id
	 * @param causeRemark
	 * @param model
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping("toUpdateAdminExtResState.do")
	@ResponseBody
	public String toUpdateAdminExtResState(HttpServletRequest request,String id,String causeRemark, ModelMap model) throws ParseException{

		groupOrderService.findUpdateAdminOrderState(id,causeRemark);
		String ret = Update_OrderState(request, id, "2");
		return ret;
		
	}
	
	
	/**
	 * 跳转至状态修改页面
	 * @param request
	 * @param model
	 * @param id
	 * @param resId
	 * @return
	 */
	@RequestMapping(value = "/toUpdateOrderState.htm")
	public String toUpdateOrderState(HttpServletRequest request ,ModelMap model ,String id, Integer resId){
		//将选中的id传入页面
		GroupOrder orderBean = groupOrderService.selectByPrimaryKey(Integer.valueOf(id));
		model.addAttribute("totalCash", orderBean.getTotalCash());
		model.addAttribute("extResPrepay", orderBean.getExtResPrepay());
		model.addAttribute("id", id);
		
		model.addAttribute("extResState", orderBean.getExtResState());
		return "resTraffic/resUpdateOrderState";
	}
	
	/**
	 * 保存修改的订单状态
	 * @param request
	 * @param model
	 * @param id
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping("toUpdateExtResState.do")
	@ResponseBody
	public String toUpdateExtResState(HttpServletRequest request ,ModelMap model,String id,String extResState) throws ParseException{
		String ret = Update_OrderState(request, id, extResState);
		return ret;
	}
	
	private String Update_OrderState(HttpServletRequest request, String id,String extResState) throws ParseException{
		//  0待确认（占位）、1已确认（占位）、2正常取消（退还），3系统执行自动任务取消（清位）
		// 订单状态 1正常  -1删除  0 待确认
		
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		String actionStr = "", briefStr = "";
		Integer orderState = 0;
		GroupOrder order = groupOrderService.selectByPrimaryKey(Integer.valueOf(id));
		if("0".equals(extResState)){
			briefStr = "更改状态为：待确认";
			if (order.getType().equals(1))
				actionStr = TRAFFICRES_STOCK_ACTION.ORDER_SOLD.toString();
			else
				actionStr = TRAFFICRES_STOCK_ACTION.ORDER_RESERVE.toString();
			order.setExtResConfirmId(curUser.getEmployeeId());
			order.setExtResConfirmName(curUser.getName());
		}
		if("1".equals(extResState)){
			orderState = 1;
			briefStr = "更改状态为：已确认";
			actionStr = "";
			order.setExtResConfirmId(curUser.getEmployeeId());
			order.setExtResConfirmName(curUser.getName());
			toGroup(order.getId(), order.getOrderType(), request);
		}
		if("2".equals(extResState)){
			briefStr = "更改状态为：取消";
			actionStr = TRAFFICRES_STOCK_ACTION.ORDER_CANCEL.toString();
		}
		if("3".equals(extResState)){
			briefStr = "更改状态为：清位取消";
			actionStr = TRAFFICRES_STOCK_ACTION.ORDER_CLEAN.toString();
		}
		
		order.setExtResState(Integer.valueOf(extResState));
		order.setState(orderState);
		int nums = groupOrderService.loadUpdateExtResState(order);
		
		
		//日志
		Integer groupId = order.getGroupId()==null?0:order.getGroupId();
		insertLog(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(), LOG_ACTION.UPDATE, "group_order", order.getId(), groupId ,briefStr, null, null));

		//库存变更
		if (!"".equals(actionStr)){
			TrafficResStocklog trafficResStocklog=new TrafficResStocklog();
			trafficResStocklog.setAdjustAction(actionStr);
			trafficResStocklog.setAdjustNum(order.getNumAdult()+order.getNumChild());
			trafficResStocklog.setResId(order.getExtResId());//参数为resId：资源ID
			trafficResStocklog.setAdjustTime(new Date());
			trafficResStocklog.setUserId(curUser.getEmployeeId());
			trafficResStocklog.setUserName(curUser.getName());
			trafficResService.insertTrafficResStocklog(trafficResStocklog);
			//更新库存
			trafficResService.updateStockOrStockDisable(order.getExtResId());
		}
		 
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", nums);
		return JSON.toJSONString(map);

	}
	
	private void toGroup(Integer orderId,Integer orderType,HttpServletRequest request) throws ParseException{
		GroupOrder order = groupOrderService.selectByPrimaryKey(orderId);
		if(orderType==1){				// 团队
			List<MergeGroupOrderVO> result = new ArrayList<MergeGroupOrderVO>();
				MergeGroupOrderVO mov = new MergeGroupOrderVO();
				mov.getOrderList().add(order);
				result.add(mov);
			specialGroupOrderService.mergetGroupResTeam(result, WebUtils.getCurBizId(request),
					WebUtils.getCurUserId(request), WebUtils.getCurUser(request)
							.getName(), settingCommon.getMyBizCode(request));
		}
		if(orderType==0){          // 散客
			List<TourGroup> groupList  =tourGroupService.selecGroupBefAutoMergerGroup(order.getBizId(), order.getDepartureDate(), order.getProductId());
			if (groupList != null && groupList.size() > 0) {
				TourGroup tourGroup=groupList.get(0);
				order.setGroupId(tourGroup.getId());
				groupOrderService.updateGroupOrder(order);
				tourGroup.setOrderNum(tourGroup.getOrderNum() == null ? 1
						: tourGroup.getOrderNum() + 1);
				tourGroupService.updateByPrimaryKey(tourGroup);
				groupOrderService.updateGroupPersonNum(tourGroup.getId());
				groupOrderService.updateGroupPrice(tourGroup.getId());
			} else { // 如果不存在新建团并加入
				List<MergeGroupOrderVO> result = new ArrayList<MergeGroupOrderVO>();
				MergeGroupOrderVO mov = new MergeGroupOrderVO();
				mov.getOrderList().add(order);
				result.add(mov);
				specialGroupOrderService.mergetGroupResFit(result, WebUtils.getCurBizId(request), WebUtils.getCurUserId(request), WebUtils.getCurUser(request).getName(), settingCommon.getMyBizCode(request));
			}
		}
	}
	
	@RequestMapping("toDeleteOrderInfo.do")
	@ResponseBody
	public String toDeleteOrderInfo(HttpServletRequest request ,ModelMap model,String id){
		int nums = groupOrderService.delGroupOrderId(Integer.valueOf(id));
		
		//插入日志
		GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(Integer.valueOf(id));
		Integer groupId = groupOrder.getGroupId()==null?0:groupOrder.getGroupId();
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		insertLog(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.DELETE, "group_order", groupOrder.getId(), groupId ,"删除订单!", groupOrder, null));

		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", nums);
		return JSON.toJSONString(map);
	}
		
	
	private void insertLog(LogOperator log){
		List<LogOperator> logList = new ArrayList<LogOperator>();
		logList.add(log);
        logService.insert(logList);
	}
	

}
