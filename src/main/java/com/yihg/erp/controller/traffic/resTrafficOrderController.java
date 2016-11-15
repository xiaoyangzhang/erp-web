package com.yihg.erp.controller.traffic;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.tj.client.query.LockListTableDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficOrderDTO;
import com.yimayhd.erpcenter.facade.tj.client.result.AdminOrderListTableResult;
import com.yimayhd.erpcenter.facade.tj.client.result.LockListTableResult;
import com.yimayhd.erpcenter.facade.tj.client.service.ResTrafficOrderFacade;

@Controller
@RequestMapping("/resOrder")
public class resTrafficOrderController extends BaseController{
	
	@Autowired
	private BizSettingCommon settingCommon;
	
	@Autowired
	private ResTrafficOrderFacade resTrafficOrderFacade;
	
	@RequestMapping("resGroupOrderList.htm")
	public String loadGroupOrderInfo(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandProductList = resTrafficOrderFacade.loadGroupOrderInfo(bizId);
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
		LockListTableDTO lockListTableDTO = new LockListTableDTO();
		lockListTableDTO.setBizId(WebUtils.getCurBizId(request));
		lockListTableDTO.setPage(page);
		lockListTableDTO.setPageSize(pageSize);
		lockListTableDTO.setPmBean(WebUtils.getQueryParamters(request));
		lockListTableDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		LockListTableResult result = resTrafficOrderFacade.lockListTable(lockListTableDTO);
		model.addAttribute("sum",result.getSumGroupOrder());
		model.addAttribute("pageBean", result.getPageBean());
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
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO(); 
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setCauseRemark(causeRemark);
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficOrderDTO.setMyBizCode(settingCommon.getMyBizCode(request));
		String result = resTrafficOrderFacade.toUpdateProductPrice(trafficOrderDTO);
		return result;
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
		List<DicInfo> brandProductList = resTrafficOrderFacade.loadAdminOrderInfo(bizId);
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
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO();
		trafficOrderDTO.setPage(page);
		trafficOrderDTO.setPageSize(pageSize);
		trafficOrderDTO.setPm(WebUtils.getQueryParamters(request));
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		AdminOrderListTableResult result = resTrafficOrderFacade.adminOrderListTable(trafficOrderDTO);
		model.addAttribute("sum",result.getSumResAdminOrder());
		model.addAttribute("pageBean", result.getPageBean());
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
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO(); 
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setCauseRemark(causeRemark);
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficOrderDTO.setMyBizCode(settingCommon.getMyBizCode(request));
		String result = resTrafficOrderFacade.toUpdateAdminExtResState(trafficOrderDTO);
		return result;
		
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
		GroupOrder orderBean = resTrafficOrderFacade.toUpdateOrderState(id);
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
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO(); 
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setExtResState(extResState);
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficOrderDTO.setMyBizCode(settingCommon.getMyBizCode(request));
		String result = resTrafficOrderFacade.toUpdateExtResState(trafficOrderDTO);
		return result;
	}
	
	@RequestMapping("toDeleteOrderInfo.do")
	@ResponseBody
	public String toDeleteOrderInfo(HttpServletRequest request ,ModelMap model,String id){
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO();
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		String result = resTrafficOrderFacade.toDeleteOrderInfo(trafficOrderDTO);
		return result;
	}
}
