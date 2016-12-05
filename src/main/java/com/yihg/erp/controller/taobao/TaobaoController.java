package com.yihg.erp.controller.taobao;

import java.io.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yihg.erp.utils.*;
import com.yimayhd.erpcenter.dal.basic.po.LogOperator;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingDelivery;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.*;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupOrderPriceVO;
import com.yimayhd.erpcenter.dal.sys.po.MsgInfo;
import com.yimayhd.erpcenter.facade.result.WebResult;
import com.yimayhd.erpcenter.facade.sys.service.SysMsgInfoFacade;
import com.yimayhd.erpcenter.facade.tj.client.query.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.SheetUtil;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SpecialGroupOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.taobao.po.PlatTaobaoTrade;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.basic.service.DicFacade;
import com.yimayhd.erpcenter.facade.sales.query.ReportStatisticsQueryDTO;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;
import com.yimayhd.erpcenter.facade.tj.client.result.AddNewTaobaoOrderResult;
import com.yimayhd.erpcenter.facade.tj.client.result.ImportTaobaoOrderTableResult;
import com.yimayhd.erpcenter.facade.tj.client.result.SaveSpecialGroupResult;
import com.yimayhd.erpcenter.facade.tj.client.result.TaobaoOrderListResult;
import com.yimayhd.erpcenter.facade.tj.client.result.TaobaoOrderListTableResult;
import com.yimayhd.erpcenter.facade.tj.client.result.ToEditTaobaoOrderResult;
import com.yimayhd.erpcenter.facade.tj.client.service.TaobaoFacade;

/**
 * Created by zhoum on 2016/8/10.
 */
@Controller
@RequestMapping(value = "/taobao")
public class TaobaoController extends BaseController {
	@Autowired
	private TaobaoFacade taobaoFacade;
	@Autowired
	private SysConfig config;
	@Autowired
	private BizSettingCommon settingCommon;
	@Autowired
	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
	@Autowired
	private SysPlatformOrgFacade sysPlatformOrgFacade;
	@Autowired
	private DicFacade dicFacade;
	@Autowired
	private GroupOrderFacade groupOrderFacade;
	@Autowired
	private SysMsgInfoFacade sysMsgInfoFacade;
	
	/**
	 * 操作单
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("taobaoOrderList.htm")
	public String taobaoOrderList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model) {
		TaobaoOrderListResult result = taobaoFacade.taobaoOrderList(WebUtils.getCurBizId(request));
		model.addAttribute("pp", result.getPp());
		model.addAttribute("allProvince", result.getAllProvince());
		
		model.addAttribute("typeList", result.getTypeList());
		model.addAttribute("sourceTypeList", result.getSourceTypeList());
		
		model.addAttribute("orgJsonStr",result.getOrgTreeJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserTreeJsonStr());
		model.addAttribute("curUser", WebUtils.getCurUser(request).getName());
		model.addAttribute("curUserId", WebUtils.getCurUserId(request));
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
		TaobaoOrderListTableDTO dto = new TaobaoOrderListTableDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		dto.setGroupOrder(groupOrder);
		TaobaoOrderListTableResult result = taobaoFacade.taobaoOrderList_table(dto);
		
		PageBean<GroupOrder> page = new PageBean<GroupOrder>();
		page = result.getPage();
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
		List<DicInfo> typeList = result.getTypeList();
		model.addAttribute("typeList", typeList);
		model.addAttribute("pageTotalAudit", pageTotalAudit);
		model.addAttribute("pageTotalChild",pageTotalChild);
		model.addAttribute("pageTotalGuide",pageTotalGuide);
		model.addAttribute("pageTotal", pageTotal);
		model.addAttribute("page", page);
		GroupOrder go = result.getGroupOrder();
		model.addAttribute("totalAudit", go.getNumAdult());
		model.addAttribute("totalChild", go.getNumChild());
		model.addAttribute("totalGuide", go.getNumGuide());
		model.addAttribute("total", go.getTotal());
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String today = formatter.format(new Date());
		model.addAttribute("today", today);
		return "sales/taobaoOrder/taobaoOrderList_table";
	}	
	
	/*操作单-编辑*/
	@RequestMapping(value = "toEditTaobaoOrder.htm")
	public String toEditTaobaoOrder(HttpServletRequest request,
			HttpServletResponse reponse,Integer see, ModelMap model,Integer id,Integer operType) throws ParseException{
		if(id <=0){
			return "sales/taobaoOrder/addNewTaobaoOrder";
		}
	 	// see=0
		// 查看
		// see=1操作单编辑
		// see=2计调操作单
		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String, Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.JDGL_JDCZD;
		model.addAttribute("SH",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.JDCZD_SH)));

		ToEditTaobaoOrderDTO dto = new ToEditTaobaoOrderDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrderId(id);
		dto.setOperType(operType);
		int bizId = WebUtils.getCurBizId(request);
		ToEditTaobaoOrderResult result = taobaoFacade.toEditTaobaoOrder(dto);
		model.addAttribute("operType", operType);
		model.addAttribute("vo", result.getSpecialGroupOrderVO());
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("typeList", result.getTypeList());
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("config", config);
		model.addAttribute("allowNum", result.getCount()); // 库存
		model.addAttribute("allCity", result.getCityList());
		model.addAttribute("allCity1", result.getDepartCityList());
		model.addAttribute("guideStr", result.getGuideStr());
		model.addAttribute("orders", result.getOrders());
		model.addAttribute("tbIds", result.getTbOrderIds());
		model.addAttribute("see", see);

		// 获取消息
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bizId", bizId);
		map.put("userId", WebUtils.getCurUserId(request));
		map.put("orderId", id);

		model.addAttribute("msgInfoList", getMsgInfo(map));

		if (result.getGroupOrder().getGroupId() != null) {
			model.addAttribute("groupCanEdit", result.getGroupCanEdit());
			model.addAttribute("groupId", result.getGroupOrder().getGroupId());
			model.addAttribute("bookingInfo", result.getBookingInfo());

			model.addAttribute("bdList", result.getBdList());
			model.addAttribute("tg", result.getTg());
		}

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
			HttpServletResponse reponse,String retVal, ModelMap model) {
		model.addAttribute("operType", 1);
		AddNewTaobaoOrderResult result = taobaoFacade.addNewTaobaoOrder(WebUtils.getCurBizId(request));
		GroupOrder groupOrder  = new GroupOrder();
		groupOrder.setSaleOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setSaleOperatorName(WebUtils.getCurUser(request).getName());
		groupOrder.setOperatorId(WebUtils.getCurUserId(request));
		groupOrder.setOperatorName(WebUtils.getCurUser(request).getName());
		SpecialGroupOrderVO vo = new SpecialGroupOrderVO();
		vo.setGroupOrder(groupOrder);
		model.addAttribute("vo", vo);
		model.addAttribute("jdxjList", result.getJdxjList());
		model.addAttribute("jtfsList", result.getJtfsList());
		model.addAttribute("zjlxList", result.getZjlxList());
		model.addAttribute("typeList", result.getTypeList());
		model.addAttribute("allProvince", result.getAllProvince());
		model.addAttribute("lysfxmList", result.getLysfxmList());
		model.addAttribute("config", config);
		model.addAttribute("retVal", retVal);

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
		SaveSpecialGroupDTO dto = new SaveSpecialGroupDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setUserId(WebUtils.getCurUserId(request));
		dto.setUserName(WebUtils.getCurUser(request).getName());
		dto.setOrderNo(settingCommon.getMyBizCode(request));
		dto.setTaobaoOrderId(id);
		dto.setTaobaoOrderIds(ids);
		dto.setMyBizCode(settingCommon.getMyBizCode(request));
		dto.setGroupMode(GroupMode);
		Integer orderId = 0;
		GroupOrder go = null;
		List<GroupOrderPrice> incomeList = null;
		List<GroupOrderGuest> guestList = null;
		List<GroupOrderTransport> transList = null;
		// 日志保存
		List<LogOperator> logList = new ArrayList<LogOperator>();
		logList.addAll(LogUtils.LogRow_GroupOrder(request, vo.getGroupOrder(), go)); // GroupOrder
		logList.addAll(LogUtils.LogRow_GroupOrderPrice(request, orderId, vo.getGroupOrderPriceList(), incomeList)); // groupOrderPrice
		logList.addAll(LogUtils.LogRow_GroupOrderGuest(request, orderId, vo.getGroupOrderGuestList(), guestList)); // groupOrderGuest
		logList.addAll(
				LogUtils.LogRow_GroupOrderTransport(request, orderId, vo.getGroupOrderTransportList(), transList)); // groupOrderTransport

		dto.setLogList(logList);


		SaveSpecialGroupResult result = taobaoFacade.saveSpecialGroup(dto);
		if(!result.isSuccess()){
			return result.getResultMsg();
		}
		return result.getResultJson();
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
		ImportTaobaoOrderTableDTO dto = new ImportTaobaoOrderTableDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
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
		if (pm.get("startMin") != null){
			pm.put("startMin",pm.get("startMin")+" 00:00:00");
		}
		if (pm.get("startMax") != null){
			pm.put("startMax",pm.get("startMax")+" 23:59:59");
		}
		pageBean.setParameter(pm);
		dto.setPageBean(pageBean);
		ImportTaobaoOrderTableResult result = taobaoFacade.import_taobaoOrder_table(dto);
		model.addAttribute("pageBean", result.getPageBean());
		
		return "sales/taobaoOrder/import_taobaoOrder_table";
	}
	
	/**
	 * 确定
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
		return taobaoFacade.taobaoOrder_GetByIds(ids);
	}
	
	/**
	 * 淘宝原始单（爱游）
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("taobaoOriginalOrder.htm")
	public String taobaoOriginalOrder(HttpServletRequest request, HttpServletResponse reponse, String startMin,
									  String startMax, String isBrushSingle, String myStoreId, String title, ModelMap model, String authClient,String outerIid ) {

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

		model.addAttribute("startMin", startMin);
		model.addAttribute("startMax", startMax);
		model.addAttribute("isBrushSingle", isBrushSingle);
		model.addAttribute("myStoreId", myStoreId);
		model.addAttribute("title", title);
		model.addAttribute("outerIid", outerIid);
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
	@RequestMapping("taobaoOriginalOrder_table.htm")
	public String taobaoOriginalOrder_table(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page,String authClient) {
		TaobaoOriginalOrderTableDTO dto = new TaobaoOriginalOrderTableDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
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
		dto.setPageBean(pageBean);
		PageBean result = taobaoFacade.taobaoOriginalOrder_table(dto);
		model.addAttribute("pageBean", result);
		return "sales/taobaoOrder/taobaoOriginalOrder_table";
	}


	/**
	 * 预售淘宝原始单.
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping("presellTaobaoOriginalOrder.htm")
	public String presellTaobaoOriginalOrder(HttpServletRequest request, HttpServletResponse reponse, String startMin,
											 String startMax, String isBrushSingle, String myStoreId, String title, ModelMap model, String authClient,String outerIid) {

		model.addAttribute("authClient", authClient);

		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String, Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.XSGL_TAOBAO_TRADELIST;
		model.addAttribute("optMap_AY",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_AY)));
		model.addAttribute("optMap_YM",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_YM)));
		model.addAttribute("optMap_TX",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_TX)));
		model.addAttribute("optMap_JY",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_JY)));
		model.addAttribute("optMap_OUTSIDE",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.XSGL_TAOBAO_OUTSIDE)));

		model.addAttribute("startMin", startMin);
		model.addAttribute("startMax", startMax);
		model.addAttribute("isBrushSingle", isBrushSingle);
		model.addAttribute("myStoreId", myStoreId);
		model.addAttribute("title", title);
		model.addAttribute("outerIid", outerIid);
		return "sales/taobaoOrder/presellTaobaoOriginalOrder";
	}

	/**
	 * 预售淘宝原始单table.
	 *
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping("presellTaobaoOriginalOrder_table.htm")
	public String presellTaobaoOriginalOrder_table(HttpServletRequest request, ModelMap model, Integer pageSize,
												   Integer page, String authClient) {

		Map<String, Object> pm = WebUtils.getQueryParamters(request);
		pm.put("myStoreId", authClient);
		pm.put("curUserName", WebUtils.getCurrentUserSession(request).getName());
		PresellTaobaoOriginalOrderDTO dto = new PresellTaobaoOriginalOrderDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setPm(pm);
		PresellTaobaoOriginalOrderDTO result = taobaoFacade.presellTaobaoOriginalOrder_table(dto);
		PageBean pageBean = result.getPageBean();
		model.addAttribute("pageBean", pageBean);
		return "sales/taobaoOrder/presellTaobaoOriginalOrder_table";
	}

	/**
     * 废弃
     */
	@RequestMapping("updateCancel.do")
	public String updateCancel(String idss){
		taobaoFacade.updateCancel(idss);
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	/**
     * 还原
     */
	@RequestMapping("updateNew.do")
	public String updateNew(String idss){
		taobaoFacade.updateNew(idss);
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	/**
     * 同步 by time
     */
	@RequestMapping("synchroByTime.do")
	public String synchroByTime(HttpServletRequest request,Integer pageSize, Integer page,ModelMap model,String authClient,String startTime,String endTime){
		TaobaoOriginalOrderTableDTO dto = new TaobaoOriginalOrderTableDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
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
//		pm.put("startMin",startTime+" 00:00:00");
//		pm.put("startMax",endTime+" 23:59:59");
		pm.put("startTime", startTime);
		
		pageBean.setParameter(pm);
		dto.setPageBean(pageBean);
		PageBean result = taobaoFacade.synchroByTime(dto);
		model.addAttribute("pageBean", result);
		
		return "sales/taobaoOrder/taobaoOriginalOrder" ; 
	}
	/**
     * 同步 by tid
     */
	@RequestMapping("synchroByTid.do")
	public String synchroByTid(HttpServletRequest request,ModelMap model, Integer pageSize, Integer page,String authClient,String tid){
		TaobaoOriginalOrderTableDTO dto = new TaobaoOriginalOrderTableDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
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
		dto.setPageBean(pageBean);
		PageBean result = taobaoFacade.synchroByTid(dto);
		model.addAttribute("pageBean", result);
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
    
    /**
     * 淘宝单统计
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("taobaoStatistics.htm")
    public String taobaoStatistics(HttpServletRequest request, Model model) {
        return "sales/taobaoOrder/taobaoStatistics";
    }
    
    /**
     * 店铺销售统计
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("shopSalesStatistics.htm")
    public String shopSalesStatistics(HttpServletRequest request, HttpServletResponse response, ModelMap model,
            PlatTaobaoTrade platTaobaoTrade, String startMin, String startMax, String myStoreId,Integer dateType) {
        model.addAttribute("start_max", startMax);
        model.addAttribute("start_min", startMin);
        model.addAttribute("myStoreId", myStoreId);
        model.addAttribute("dateType", dateType);
        UserSession user = WebUtils.getCurrentUserSession(request);
        Map<String, Boolean> optMap = user.getOptMap();
        String menuCode = PermissionConstants.SALES_QUERIES_TAOBAO;
        model.addAttribute("optMap_AY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_AY)));
        model.addAttribute("optMap_YM",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_YM)));
        model.addAttribute("optMap_TX",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_TX)));
        model.addAttribute("optMap_JY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_JY)));
        model.addAttribute("optMap_OUTSIDE",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_OUTSIDE)));
        if (myStoreId != null) {
            platTaobaoTrade.setEndTime(DateUtils.fmt(startMax, "yyyy-MM-dd hh:mm"));
            platTaobaoTrade.setStartTime(DateUtils.fmt(startMin, "yyyy-MM-dd hh:mm"));
            platTaobaoTrade.setMyStoreId(myStoreId);
            platTaobaoTrade.setDateType(dateType);
            
            ShopSalesStatisticsQueryDTO queryDTO = new ShopSalesStatisticsQueryDTO();
            queryDTO.setBizId( WebUtils.getCurBizId(request));
            queryDTO.setPlatTaobaoTrade(platTaobaoTrade);
            
            PlatTaobaoTrade trade = taobaoFacade.selectTaobaoshopSalesStatistics(queryDTO).getTrade();
            model.addAttribute("trade", trade);

            platTaobaoTrade.setIsBrushSingle(99);
            queryDTO.setBizId( WebUtils.getCurBizId(request));
            queryDTO.setPlatTaobaoTrade(platTaobaoTrade);
            
            PlatTaobaoTrade tradeNoBrush = taobaoFacade.selectTaobaoshopSalesStatistics(queryDTO).getTrade();
            model.addAttribute("tradeNoBrush", tradeNoBrush);
            
            platTaobaoTrade.setIsBrushSingle(1);
            queryDTO.setBizId( WebUtils.getCurBizId(request));
            queryDTO.setPlatTaobaoTrade(platTaobaoTrade);
            PlatTaobaoTrade tradeBrush = taobaoFacade.selectTaobaoshopSalesStatistics(queryDTO).getTrade();
            
            model.addAttribute("tradeBrush", tradeBrush);
        }
        return "sales/taobaoOrder/shopSalesStatistics";
    }

    /**
     * 预售产品统计
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("presellProductStatistics.htm")
    public String presellProductStatistics(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
        UserSession user = WebUtils.getCurrentUserSession(request);
        Map<String, Boolean> optMap = user.getOptMap();
        String menuCode = PermissionConstants.SALES_QUERIES_TAOBAO;
        model.addAttribute("optMap_AY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_AY)));
        model.addAttribute("optMap_YM",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_YM)));
        model.addAttribute("optMap_TX",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_TX)));
        model.addAttribute("optMap_JY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_JY)));
        model.addAttribute("optMap_OUTSIDE",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_OUTSIDE)));
        return "sales/taobaoOrder/presellProductStatistics";
    }

    @RequestMapping("presellProductStatistics_table.do")
    public String presellProductStatistics_table(HttpServletRequest request, ModelMap model, Integer pageSize,
            Integer page, String authClient) {
        PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
        Map<String, Object> pm = WebUtils.getQueryParamters(request);
        pageBean.setParameter(pm);
        
        PresellProductStatistics queryDTO = new PresellProductStatistics();
        queryDTO.setPageBean(pageBean);
        queryDTO.setBizId(WebUtils.getCurBizId(request));
        pageBean = taobaoFacade.selectPresellProductStatisticsListPage(queryDTO).getPageBean();
        model.addAttribute("pageBean", pageBean);
        return "sales/taobaoOrder/presellProductStatistics_table";
    }

    /**
     * 非预售产品统计
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("notPresellProductStatistics.htm")
    public String notPresellProductStatistics(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
        UserSession user = WebUtils.getCurrentUserSession(request);
        Map<String, Boolean> optMap = user.getOptMap();
        String menuCode = PermissionConstants.SALES_QUERIES_TAOBAO;
        model.addAttribute("optMap_AY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_AY)));
        model.addAttribute("optMap_YM",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_YM)));
        model.addAttribute("optMap_TX",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_TX)));
        model.addAttribute("optMap_JY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_JY)));
        model.addAttribute("optMap_OUTSIDE",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_OUTSIDE)));
        return "sales/taobaoOrder/notPresellProductStatistics";
    }

    @RequestMapping("notPresellProductStatistics_table.do")
    public String notPresellProductStatistics_table(HttpServletRequest request, ModelMap model, Integer pageSize,
            Integer page, String authClient) {
        PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
        Map<String, Object> pm = WebUtils.getQueryParamters(request);
        pageBean.setParameter(pm);
        
        PresellProductStatistics queryDTO = new PresellProductStatistics();
        queryDTO.setPageBean(pageBean);
        queryDTO.setBizId(WebUtils.getCurBizId(request));
        
        pageBean = taobaoFacade.selectNotPresellProductStatisticsListPage(queryDTO).getPageBean();
        model.addAttribute("pageBean", pageBean);
        return "sales/taobaoOrder/notPresellProductStatistics_table";
    }

    /**
     * 客服销售统计
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("saleOperatorSalesStatistics.htm")
    public String saleOperatorSalesStatistics(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
        model.addAttribute("orgJsonStr", sysPlatformOrgFacade.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
        model.addAttribute("orgUserJsonStr",
        		sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
        UserSession user = WebUtils.getCurrentUserSession(request);
        Map<String, Boolean> optMap = user.getOptMap();
        String menuCode = PermissionConstants.SALES_QUERIES_TAOBAO;
        model.addAttribute("optMap_AY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_AY)));
        model.addAttribute("optMap_YM",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_YM)));
        model.addAttribute("optMap_TX",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_TX)));
        model.addAttribute("optMap_JY",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_JY)));
        model.addAttribute("optMap_OUTSIDE",
                optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.SALES_TAOBAO_OUTSIDE)));
        return "sales/taobaoOrder/saleOperatorSalesStatistics";
    }

    @RequestMapping("saleOperatorSalesStatistics_table.do")
    public String saleOperatorSalesStatistics_table(HttpServletRequest request, ModelMap model, Integer pageSize,
            Integer page, String authClient) {
        PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
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
        Map<String, Object> pm = WebUtils.getQueryParamters(request);
        pm.put("set", WebUtils.getDataUserIdSet(request));
        Object orgIds = pm.get("orgIds");
        if (orgIds != null && StringUtils.isNotBlank(orgIds.toString())) {
            Set<Integer> set = new HashSet<Integer>();
            String[] orgIdArr = orgIds.toString().split(",");
            for (String orgIdStr : orgIdArr) {
                set.add(Integer.valueOf(orgIdStr));
            }
            set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
            String salesOperatorIds = "";
            for (Integer usrId : set) {
                salesOperatorIds += usrId + ",";
            }
            if (!salesOperatorIds.equals("")) {
                pm.put("saleOperatorIds", salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
            }
        }
        pageBean.setParameter(pm);
        
        PresellProductStatistics queryDTO = new PresellProductStatistics();
        queryDTO.setBizId(WebUtils.getCurBizId(request));
        queryDTO.setPageBean(pageBean);
        pageBean = taobaoFacade.selectSaleOperatorSalesStatisticsListPage(queryDTO ).getPageBean();
        model.addAttribute("pageBean", pageBean);
        
        return "sales/taobaoOrder/saleOperatorSalesStatistics_table";
    }

    /**
     * 月报表统计
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("monthlyReportStatistics.htm")
    public String monthlyReportStatistics(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
        model.addAttribute("orgJsonStr", sysPlatformOrgFacade.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
        model.addAttribute("orgUserJsonStr",
        		sysPlatformEmployeeFacade.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
        // List<DicInfo> typeList =
        // dicService.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,
        // WebUtils.getCurBizId(request));
        // model.addAttribute("typeList", typeList);
        return "sales/taobaoOrder/monthlyReportStatistics";
    }

    @RequestMapping("monthlyReportStatistics_table.do")
    public String monthlyReportStatistics_table(HttpServletRequest request, ModelMap model, Integer pageSize,
            Integer page, String authClient) {
        PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
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
        Map<String, Object> pm = WebUtils.getQueryParamters(request);
        pm.put("set", WebUtils.getDataUserIdSet(request));
        Object orgIds = pm.get("orgIds");
        if (orgIds != null && StringUtils.isNotBlank(orgIds.toString())) {
            Set<Integer> set = new HashSet<Integer>();
            String[] orgIdArr = orgIds.toString().split(",");
            for (String orgIdStr : orgIdArr) {
                set.add(Integer.valueOf(orgIdStr));
            }
            set = sysPlatformEmployeeFacade.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), set);
            String salesOperatorIds = "";
            for (Integer usrId : set) {
                salesOperatorIds += usrId + ",";
            }
            if (!salesOperatorIds.equals("")) {
                pm.put("saleOperatorIds", salesOperatorIds.substring(0, salesOperatorIds.length() - 1));
            }
        }
        pageBean.setParameter(pm);
        /*
         * pageBean =
         * taobaoOrderService.selectNotPresellProductStatisticsListPage(
         * pageBean, WebUtils.getCurBizId(request));
         */
        model.addAttribute("parameter", pm);
        
        ReportStatisticsQueryDTO queryDTO = new ReportStatisticsQueryDTO();
        queryDTO.setPageBean(pageBean);
        queryDTO.setBizId(WebUtils.getCurBizId(request));
        pageBean = groupOrderFacade.selectMonthlyReportStatisticsListPage(queryDTO).getPageBean();
        model.addAttribute("pageBean", pageBean);
        List<DicInfo> typeList = dicFacade.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,
                WebUtils.getCurBizId(request));
        model.addAttribute("typeList", typeList);
        return "sales/taobaoOrder/monthlyReportStatistics_table";
    }

    /**
     * 月报表统计excel导出部分
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/getOrders.do")
    @ResponseBody
    public void getOrders(HttpServletRequest request, HttpServletResponse response, GroupOrder vo) {
        List<DicInfo> typeList = dicFacade.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE,
                WebUtils.getCurBizId(request));
        PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
        pageBean.setParameter(vo);
        
        
        ReportStatisticsQueryDTO queryDTO = new ReportStatisticsQueryDTO();
        queryDTO.setPageBean(pageBean);
        queryDTO.setBizId(WebUtils.getCurBizId(request));
        List<GroupOrder> orders = groupOrderFacade.selectMonthlyReportStatistics(queryDTO).getOrderList();

        String path = "";

        try {
            String url = request.getSession().getServletContext()
                    .getRealPath("/template/excel/monthlyReportStatistics.xlsx");
            FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
            XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
            XSSFFont createFont = wb.createFont();
            createFont.setFontName("微软雅黑");
            createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
            createFont.setFontHeightInPoints((short) 12);

            XSSFFont tableIndex = wb.createFont();
            tableIndex.setFontName("宋体");
            tableIndex.setFontHeightInPoints((short) 11);

            CellStyle cellStyle = wb.createCellStyle();
            cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

            CellStyle styleFontCenter = wb.createCellStyle();
            styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
            styleFontCenter.setFont(createFont);

            CellStyle styleFontTable = wb.createCellStyle();
            styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
            styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

            CellStyle styleLeft = wb.createCellStyle();
            styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

            CellStyle styleRight = wb.createCellStyle();
            styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
            Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
            Row row = null;
            Cell cc = null;
            // 遍历集合数据，产生数据行
            Iterator<GroupOrder> it = orders.iterator();
            int index = 0;
            while (it.hasNext()) {
                GroupOrder order = it.next();
                String orderMode = "";
                for (DicInfo item : typeList) {
                    if (item.getId().equals( order.getOrderMode())) {
                        orderMode = item.getValue();
                    }
                }
                row = sheet.createRow(index + 2);
                cc = row.createCell(0);
                cc.setCellValue(index + 1);
                cc.setCellStyle(cellStyle);
                cc = row.createCell(1);
                cc.setCellValue(order.getGroupCode());
                cc.setCellStyle(styleLeft);
                cc = row.createCell(2);
                cc.setCellValue(order.getDateStart());
                cc.setCellStyle(styleLeft);
                cc = row.createCell(3);
                cc.setCellValue(order.getProductName());
                cc.setCellStyle(styleLeft);
                cc = row.createCell(4);
                cc.setCellValue(order.getBusinessName());
                cc.setCellStyle(styleLeft);
                cc = row.createCell(5);
                cc.setCellValue(order.getSupplierName());
                cc.setCellStyle(styleLeft);
                cc = row.createCell(6);
                cc.setCellValue(orderMode);
                cc.setCellStyle(styleLeft);
                cc = row.createCell(7);
                cc.setCellValue(order.getReceiveMode());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(8);
                cc.setCellValue(order.getNumAdult() == null ? 0 : order.getNumAdult());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(9);
                cc.setCellValue(order.getNumChild() == null ? 0 : order.getNumChild());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(10);
                cc.setCellValue(order.getSaleOperatorName());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(11);
                cc.setCellValue(order.getOperatorName());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(12);
                cc.setCellValue(order.getTotal() == null ? 0 : order.getTotal().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(13);
                cc.setCellValue(order.getTotalCash() == null ? 0 : order.getTotalCash().doubleValue());
                cc.setCellStyle(styleLeft);
                cc = row.createCell(14);
                cc.setCellValue(order.getTotalBalance() == null ? 0 : order.getTotalBalance().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(15);
                cc.setCellValue(order.getOtherTotal() == null ? 0 : order.getOtherTotal().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(16);
                cc.setCellValue(order.getOtherTotalCash() == null ? 0 : order.getOtherTotalCash().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(17);
                cc.setCellValue(order.getOtherTotalBalance() == null ? 0 : order.getOtherTotalBalance().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(18);
                cc.setCellValue(order.getCost() == null ? 0 : order.getCost().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(19);
                cc.setCellValue(order.getCostCash() == null ? 0 : order.getCostCash().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(20);
                cc.setCellValue(order.getCostBalance() == null ? 0 : order.getCostBalance().doubleValue());
                cc.setCellStyle(cellStyle);
                cc = row.createCell(21);
                cc.setCellValue(order.getGroupCost() == null ? 0 : order.getGroupCost().doubleValue());
                cc.setCellStyle(cellStyle);
                index++;

            }
            List<String> list = getTotal(orders);
            row = sheet.createRow(orders.size() + 2); // 加合计行
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
            cc.setCellStyle(styleRight);
            cc = row.createCell(6);
            cc.setCellStyle(styleRight);
            cc = row.createCell(7);
            cc.setCellValue("合计：");
            cc.setCellStyle(styleRight);
            cc = row.createCell(8);
            cc.setCellValue(list.get(0));
            cc.setCellStyle(styleRight);
            cc = row.createCell(9);
            cc.setCellValue(list.get(1));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(10);
            cc.setCellStyle(styleRight);
            cc = row.createCell(11);
            cc.setCellStyle(styleRight);
            cc = row.createCell(12);
            cc.setCellValue(list.get(3));
            cc.setCellStyle(styleRight);
            cc = row.createCell(13);
            cc.setCellValue(list.get(4));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(14);
            cc.setCellValue(list.get(5));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(15);
            cc.setCellValue(list.get(10));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(16);
            cc.setCellValue(list.get(11));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(17);
            cc.setCellValue(list.get(12));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(18);
            cc.setCellValue(list.get(6));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(19);
            cc.setCellValue(list.get(7));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(20);
            cc.setCellValue(list.get(8));
            cc.setCellStyle(cellStyle);
            cc = row.createCell(21);
            cc.setCellValue(list.get(9));
            cc.setCellStyle(cellStyle);
            CellRangeAddress region = new CellRangeAddress(orders.size() + 3, orders.size() + 4, 0, 21);
            sheet.addMergedRegion(region);
            row = sheet.createRow(orders.size() + 3);
            cc = row.createCell(0);
            cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName() + " 打印时间："
                    + DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
            path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
                    + ".xlsx";
            FileOutputStream out = new FileOutputStream(path);
            wb.write(out);
            out.close();
            wb.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        String fileName = "";
        try {
            fileName = new String("月报表统计.xlsx".getBytes("UTF-8"), "iso-8859-1");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        download(path, fileName, request, response);
    }

    private List<String> getTotal(List<GroupOrder> orders) {
        DecimalFormat format = new DecimalFormat("#.##");
        List<String> list = new ArrayList<String>();
        double numAdult = 0;
        double numChild = 0;
        double numGuide = 0;
        double total = 0;
        double totalCash = 0;
        double totalBalance = 0;
        double cost = 0;
        double costCash = 0;
        double costBalance = 0;
        double groupCost = 0;
        double otherTotal = 0;
        double otherTotalCash = 0;
        double otherTotalBalance = 0;
        for (GroupOrder order : orders) {
            numAdult += order.getNumAdult() == null ? 0 : order.getNumAdult();
            numChild += order.getNumChild() == null ? 0 : order.getNumChild();
            numGuide += order.getNumGuide() == null ? 0 : order.getNumGuide();
            total += (order.getTotal() == null ? 0 : order.getTotal().doubleValue());
            totalCash += (order.getTotalCash() == null ? 0 : order.getTotalCash().doubleValue());
            totalBalance += (order.getTotalBalance() == null ? 0 : order.getTotalBalance().doubleValue());
            cost += (order.getCost() == null ? 0 : order.getCost().doubleValue());
            costCash += (order.getCostCash() == null ? 0 : order.getCostCash().doubleValue());
            costBalance += (order.getCostBalance() == null ? 0 : order.getCostBalance().doubleValue());
            groupCost += (order.getGroupCost() == null ? 0 : order.getGroupCost().doubleValue());
            otherTotal += (order.getOtherTotal() == null ? 0 : order.getOtherTotal().doubleValue());
            otherTotalCash += (order.getOtherTotalCash() == null ? 0 : order.getOtherTotalCash().doubleValue());
            otherTotalBalance += (order.getOtherTotalBalance() == null ? 0 : order.getOtherTotalBalance().doubleValue());
        }
        list.add(format.format(numAdult));
        list.add(format.format(numChild));
        list.add(format.format(numGuide));
        list.add(format.format(total));
        list.add(format.format(totalCash));
        list.add(format.format(totalBalance));
        list.add(format.format(cost));
        list.add(format.format(costCash));
        list.add(format.format(costBalance));
        list.add(format.format(groupCost));
        list.add(format.format(otherTotal));
        list.add(format.format(otherTotalCash));
        list.add(format.format(otherTotalBalance));
        return list;
    }

	/**
	 * 操作单导出Excel
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toOrderPreview.htm")
	public void toOrderPreview(HttpServletRequest request, HttpServletResponse response, String dateType,
							   String startTime, String endTime, String groupCode, String supplierName, String receiveMode,
							   String orderMode, String stateFinance,String buyerNick,String guestName, String orderLockState, String orgIds, String operType,
							   String saleOperatorIds, String productBrandId, String productName, Model model) throws ParseException {

		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setDateType(dateType == "" ? null : Integer.valueOf(dateType));
		groupOrder.setStartTime(startTime);
		groupOrder.setEndTime(endTime);
		groupOrder.setGroupCode(groupCode);
		groupOrder.setSupplierName(supplierName);
		groupOrder.setReceiveMode(receiveMode);
		groupOrder.setBuyerNick(buyerNick);
		groupOrder.setGuestName(guestName);
		groupOrder.setOrderMode(orderMode == "" ? null : Integer.valueOf(orderMode));
		groupOrder.setStateFinance(stateFinance == "" ? null : Integer.valueOf(stateFinance));
		groupOrder.setOrderLockState(orderLockState == "" ? null : Integer.valueOf(orderLockState));
		groupOrder.setOrgIds(orgIds);
		groupOrder.setOperType(operType == "" ? null : Integer.valueOf(operType));
		groupOrder.setSaleOperatorIds(saleOperatorIds);
		groupOrder.setProductBrandId(productBrandId == "" ? null : Integer.valueOf(productBrandId));
		groupOrder.setProductName(productName);

		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (!"".equals(groupOrder.getStartTime())) {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime()).getTime() + "");
			}
			if (!"".equals(groupOrder.getEndTime())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
		}
		TaobaoOrderListTableDTO taobaoOrderListTableDTO = new TaobaoOrderListTableDTO();
		taobaoOrderListTableDTO.setBizId(WebUtils.getCurBizId(request));
		taobaoOrderListTableDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		taobaoOrderListTableDTO.setGroupOrder(groupOrder);
		com.yimayhd.erpcenter.facade.tj.client.result.WebResult<PageBean> webResult = taobaoFacade.toOrderPreview(taobaoOrderListTableDTO);
		PageBean<GroupOrder> page = new PageBean<GroupOrder>();
		page = webResult.getValue();
		List<GroupOrder> orders = page.getResult();
		for (int i = 0; i < orders.size(); i++) {
			GroupOrder vo = orders.get(i);
			List<GroupOrderGuest> guests = new ArrayList<GroupOrderGuest>();
			if (vo.getGuestNames() != null) {
				GroupOrderGuest guest = null;
				List<String> guestsString = vo.getGuestNames();
				for (String s : guestsString) {
					if (s.length() > 0) {
						String[] ss = s.split("@");
						if (ss.length == 2) {
							guest = new GroupOrderGuest();
							guest.setName(ss[0]);
							guest.setCertificateNum(ss[1]);
						} else if (ss.length == 3) {
							guest = new GroupOrderGuest();
							guest.setName(ss[0]);
							guest.setCertificateNum(ss[1]);
							guest.setMobile(ss[2]);
						}
						guests.add(guest);
					}
				}
			}
			vo.setGuests(guests);
		}

		String path = "";
		try {
			String url = request.getSession().getServletContext().getRealPath("/template/excel/operatorOrders.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			cellStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			cellStyle.setWrapText(true);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
			styleLeft.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleLeft.setWrapText(true);

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			styleRight.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleRight.setWrapText(true);

			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<GroupOrder> it = page.getResult().iterator();
			int num = 1;
			int index = 0;
			// 合并行填充数据列
			int createRow = 2;
			while (it.hasNext()) {
				GroupOrder sov = it.next();
				List<GroupOrderGuest> guestList = new ArrayList<GroupOrderGuest>();
				GroupOrderGuest orderGuest = null;
				List<String> guests = sov.getGuestNames();
				if (null != sov.getGuestNames()) {
					for (String str : guests) {

						// String[] guestInfo = guests.get(i).split("@");
						orderGuest = new GroupOrderGuest();
						orderGuest.setName(str);
                        /*
                         * orderGuest.setCertificateNum(guestInfo[1].trim()); if
                         * (guestInfo.length == 3) {
                         * orderGuest.setMobile(guestInfo[2].trim()); }
                         */

						guestList.add(orderGuest);
					}

				}

				if (guestList.size() == 0) {
					row = sheet.createRow(index + 2);

					cc = row.createCell(0);
					cc.setCellValue(num);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue(sov.getGroupCode());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue(sov.getDepartureDate());
					cc.setCellStyle(cellStyle);

					cc = row.createCell(3);
					cc.setCellValue("【" + sov.getProductBrandName() + "】" + sov.getProductName());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(4);
					cc.setCellValue(sov.getSupplierName());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(5);
					cc.setCellValue(sov.getBuyerNick());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(6);
					cc.setCellValue(sov.getReceiveMode());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(7);
					cc.setCellValue((sov.getNumAdult() == null ? 0 : sov.getNumAdult()) + "+"
							+ (sov.getNumChild() == null ? 0 : sov.getNumChild()) + "+"
							+ (sov.getNumGuide() == null ? 0 : sov.getNumGuide()));
					cc.setCellStyle(cellStyle);

					cc = row.createCell(8);
					cc.setCellValue(sov.getSaleOperatorName());
					cc.setCellStyle(cellStyle);

					cc = row.createCell(9);
					cc.setCellValue("");
					cc.setCellStyle(styleLeft);

                    /*
                     * cc = row.createCell(9); cc.setCellValue("");
                     * cc.setCellStyle(cellStyle);
                     *
                     * cc = row.createCell(10); cc.setCellValue("");
                     * cc.setCellStyle(cellStyle);
                     */

					index++;
				} else {
					for (String guest : guests) {
						row = sheet.createRow(index + 2);
						cc = row.createCell(0);
						cc.setCellValue(num);
						cc.setCellStyle(cellStyle);

						cc = row.createCell(1);
						cc.setCellValue(sov.getGroupCode());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(2);
						cc.setCellValue(sov.getDepartureDate());
						cc.setCellStyle(cellStyle);

						cc = row.createCell(3);
						cc.setCellValue("【" + sov.getProductBrandName() + "】" + sov.getProductName());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(4);
						cc.setCellValue(sov.getSupplierName());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(5);
						cc.setCellValue(sov.getBuyerNick());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(6);
						cc.setCellValue(sov.getReceiveMode());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(7);
						cc.setCellValue((sov.getNumAdult() == null ? 0 : sov.getNumAdult()) + "+"
								+ (sov.getNumChild() == null ? 0 : sov.getNumChild()) + "+"
								+ (sov.getNumGuide() == null ? 0 : sov.getNumGuide()));
						cc.setCellStyle(cellStyle);

						cc = row.createCell(8);
						cc.setCellValue(sov.getSaleOperatorName());
						cc.setCellStyle(cellStyle);

						String str = guest.replace("@", "，");
						cc = row.createCell(9);
						cc.setCellValue(str.substring(0,str.length()-1));
						cc.setCellStyle(styleLeft);

                        /*
                         * cc = row.createCell(9);
                         * cc.setCellValue(guest.getCertificateNum());
                         * cc.setCellStyle(cellStyle);
                         *
                         * cc = row.createCell(10);
                         * cc.setCellValue(guest.getMobile());
                         * cc.setCellStyle(cellStyle);
                         */

						index++;
					}
					for (int i = 0; i < 10; i++) {
						if (i != 9) {
							CellRangeAddress region = new CellRangeAddress(createRow, createRow + guestList.size() - 1,
									i, i);
							sheet.addMergedRegion(region);
							cc = SheetUtil.getCellWithMerges(sheet, createRow, i);
							if (1 == i) {
								cc.setCellStyle(styleLeft);
							} else if (3 == i) {
								cc.setCellStyle(styleLeft);
							} else if (4 == i) {
								cc.setCellStyle(styleLeft);
							} else if (5 == i) {
								cc.setCellStyle(styleLeft);
							} else if (6 == i) {
								cc.setCellStyle(styleLeft);
							} else if (8 == i) {
								cc.setCellStyle(styleLeft);
							}else {
								cc.setCellStyle(cellStyle);
							}

						}
					}
				}
				if( guestList.size() == 0){
					createRow = createRow + 1;
				}else{
					createRow = createRow + guestList.size();

				}
				num++;
			}
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("操作单.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);

		// return "sales/taobaoOrder/taobaoOrderPreview";

	}


	/**
	 * 导出简表Excel
	 * @throws ParseException
	 */
	@RequestMapping(value = "toOperatorSummaryTable.do")
	public void operatorSummaryTable(HttpServletRequest request, HttpServletResponse response,
									 String dateType,String startTime, String endTime, String groupCode,
									 String supplierName, String receiveMode,String orderMode, String stateFinance,
									 String buyerNick,String guestName, String orderLockState, String orgIds,
									 String operType,String saleOperatorIds, String productBrandId, String productName,
									 Model model) throws ParseException {
		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setDateType(dateType == "" ? null : Integer.valueOf(dateType));
		groupOrder.setStartTime(startTime);
		groupOrder.setEndTime(endTime);
		groupOrder.setGroupCode(groupCode);
		groupOrder.setSupplierName(supplierName);
		groupOrder.setReceiveMode(receiveMode);
		groupOrder.setBuyerNick(buyerNick);
		groupOrder.setGuestName(guestName);
		groupOrder.setOrderMode(orderMode == "" ? null : Integer.valueOf(orderMode));
		groupOrder.setStateFinance(stateFinance == "" ? null : Integer.valueOf(stateFinance));
		groupOrder.setOrderLockState(orderLockState == "" ? null : Integer.valueOf(orderLockState));
		groupOrder.setOrgIds(orgIds);
		groupOrder.setOperType(operType == "" ? null : Integer.valueOf(operType));
		groupOrder.setSaleOperatorIds(saleOperatorIds);
		groupOrder.setProductBrandId(productBrandId == "" ? null : Integer.valueOf(productBrandId));
		groupOrder.setProductName(productName);

		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (!"".equals(groupOrder.getStartTime())) {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime()).getTime() + "");
			}
			if (!"".equals(groupOrder.getEndTime())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}

		}
		TaobaoOrderListTableDTO taobaoOrderListTableDTO = new TaobaoOrderListTableDTO();
		taobaoOrderListTableDTO.setBizId(WebUtils.getCurBizId(request));
		taobaoOrderListTableDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		taobaoOrderListTableDTO.setGroupOrder(groupOrder);
		com.yimayhd.erpcenter.facade.tj.client.result.WebResult<PageBean> webResult = taobaoFacade.toOrderPreview(taobaoOrderListTableDTO);
		PageBean<GroupOrder> page = new PageBean<GroupOrder>();
		page = webResult.getValue();

		String path = "";
		try {
			String url = request.getSession().getServletContext().getRealPath("/template/excel/operatorSummaryTable.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			cellStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			cellStyle.setWrapText(true);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
			styleLeft.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleLeft.setWrapText(true);

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			styleRight.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleRight.setWrapText(true);

			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<GroupOrder> it = page.getResult().iterator();

			int index = 0;
			while (it.hasNext()) {
				GroupOrder sov = it.next();
				List<GroupOrderGuest> guestList = new ArrayList<GroupOrderGuest>();
				GroupOrderGuest orderGuest = null;
				List<String> guests = sov.getGuestNames();
				if (null != sov.getGuestNames()) {
					for (String str : guests) {
						String[] guestInfo = str.split("@");
						orderGuest = new GroupOrderGuest();
						if(guestInfo.length==3){
							orderGuest.setName(guestInfo[0].trim());
							orderGuest.setMobile(guestInfo[2].trim());
						}
						if(guestInfo.length<3){
							orderGuest.setName(guestInfo[0].trim());
							orderGuest.setMobile("");
						}
						guestList.add(orderGuest);
					}
				}

				List<String> nameList = new ArrayList<String>();
				for(GroupOrderGuest ggBean : guestList){
					if("".equals(ggBean.getMobile())){
						nameList.add(ggBean.getName());
					}else{
						nameList.add(ggBean.getName()+"("+ggBean.getMobile()+")");
					}
				}
				StringBuilder sb = new StringBuilder();
                /*for (int i = 0; i < nameList.size(); i++) {
                    sb.append(String.valueOf(nameList.get(i))+"，");
                }*/
				if (nameList != null && nameList.size() > 0) {
					for (String s : nameList) {
						sb.append(s + ",");  //循环遍历数组中元素，添加到 StringBuilder 对象中
					}
				}
				if (sb.length() > 0)
					sb.deleteCharAt(sb.length() - 1); //调用 字符串的deleteCharAt() 方法,删除最后一个多余的逗号

				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue(sov.getReceiveMode());//团号
				cc.setCellStyle(styleLeft);

				cc = row.createCell(2);//自编码
				cc.setCellValue(sov.getProductName());//
				cc.setCellStyle(styleLeft);

				cc = row.createCell(3);//买家昵称
				cc.setCellValue(sov.getBuyerNick());
				cc.setCellStyle(styleLeft);

				//客人手机号
				cc = row.createCell(4);
				cc.setCellValue(sb.toString());
				cc.setCellStyle(styleLeft);

				cc = row.createCell(5);//客户
				cc.setCellValue(sov.getSaleOperatorName());
				cc.setCellStyle(styleLeft);

				index++;
			}

			CellRangeAddress region = new CellRangeAddress(page.getResult().size() + 3,
					page.getResult().size() + 3, 0, 8);
			sheet.addMergedRegion(region);
			row = sheet.createRow(page.getResult().size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("简表.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);

	}

	/**
	 * 计调操作单导出Excel
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toOperatorOrderPreview.htm")
	public void toSaleOperatorPreview(HttpServletRequest request, HttpServletResponse response, String dateType,
									  String startTime, String endTime, String groupCode, String supplierName, String receiveMode,
									  String orderMode, String stateFinance,String buyerNick,String guestName, String orderLockState, String orgIds, String operType,
									  String saleOperatorIds, String productBrandId, String productName, Model model) throws ParseException {

		GroupOrder groupOrder = new GroupOrder();
		groupOrder.setDateType(dateType == "" ? null : Integer.valueOf(dateType));
		groupOrder.setStartTime(startTime);
		groupOrder.setEndTime(endTime);
		groupOrder.setGroupCode(groupCode);
		groupOrder.setSupplierName(supplierName);
		groupOrder.setReceiveMode(receiveMode);
		groupOrder.setBuyerNick(buyerNick);
		groupOrder.setGuestName(guestName);
		groupOrder.setOrderMode(orderMode == "" ? null : Integer.valueOf(orderMode));
		groupOrder.setStateFinance(stateFinance == "" ? null : Integer.valueOf(stateFinance));
		groupOrder.setOrderLockState(orderLockState == "" ? null : Integer.valueOf(orderLockState));
		groupOrder.setOrgIds(orgIds);
		groupOrder.setOperType(operType == "" ? null : Integer.valueOf(operType));
		groupOrder.setSaleOperatorIds(saleOperatorIds);
		groupOrder.setProductBrandId(productBrandId == "" ? null : Integer.valueOf(productBrandId));
		groupOrder.setProductName(productName);

		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (!"".equals(groupOrder.getStartTime())) {
				groupOrder.setStartTime(sdf.parse(groupOrder.getStartTime()).getTime() + "");
			}
			if (!"".equals(groupOrder.getEndTime())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(sdf.parse(groupOrder.getEndTime()));
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}
		}

		TaobaoOrderListTableDTO taobaoOrderListTableDTO = new TaobaoOrderListTableDTO();
		taobaoOrderListTableDTO.setBizId(WebUtils.getCurBizId(request));
		taobaoOrderListTableDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		taobaoOrderListTableDTO.setGroupOrder(groupOrder);
		com.yimayhd.erpcenter.facade.tj.client.result.WebResult<PageBean> webResult = taobaoFacade.toOrderPreview(taobaoOrderListTableDTO);
		PageBean<GroupOrder> page = new PageBean<GroupOrder>();
		page = webResult.getValue();

		List<GroupOrder> orders = page.getResult();
		for (int i = 0; i < orders.size(); i++) {
			GroupOrder vo = orders.get(i);
			List<GroupOrderGuest> guests = new ArrayList<GroupOrderGuest>();
			if (vo.getGuestNames() != null) {
				GroupOrderGuest guest = null;
				List<String> guestsString = vo.getGuestNames();
				for (String s : guestsString) {
					if (s.length() > 0) {
						String[] ss = s.split("@");
						if (ss.length == 2) {
							guest = new GroupOrderGuest();
							guest.setName(ss[0]);
							guest.setCertificateNum(ss[1]);
						} else if (ss.length == 3) {
							guest = new GroupOrderGuest();
							guest.setName(ss[0]);
							guest.setCertificateNum(ss[1]);
							guest.setMobile(ss[2]);
						}
						guests.add(guest);
					}
				}
			}
			vo.setGuests(guests);
		}

		String path = "";
		try {
			String url = request.getSession().getServletContext().getRealPath("/template/excel/operatorOrders.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			cellStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			cellStyle.setWrapText(true);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
			styleLeft.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleLeft.setWrapText(true);

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			styleRight.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleRight.setWrapText(true);

			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<GroupOrder> it = page.getResult().iterator();
			int num = 1;
			int index = 0;
			// 合并行填充数据列
			int createRow = 2;
			while (it.hasNext()) {
				GroupOrder sov = it.next();
				List<GroupOrderGuest> guestList = new ArrayList<GroupOrderGuest>();
				GroupOrderGuest orderGuest = null;
				List<String> guests = sov.getGuestNames();
				if (null != sov.getGuestNames()) {
					for (String str : guests) {

						// String[] guestInfo = guests.get(i).split("@");
						orderGuest = new GroupOrderGuest();
						orderGuest.setName(str);
                        /*
                         * orderGuest.setCertificateNum(guestInfo[1].trim()); if
                         * (guestInfo.length == 3) {
                         * orderGuest.setMobile(guestInfo[2].trim()); }
                         */

						guestList.add(orderGuest);
					}

				}

				if (guestList.size() == 0) {
					row = sheet.createRow(index + 2);

					cc = row.createCell(0);
					cc.setCellValue(num);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue(sov.getGroupCode());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue(sov.getDepartureDate());
					cc.setCellStyle(cellStyle);

					cc = row.createCell(3);
					cc.setCellValue("【" + sov.getProductBrandName() + "】" + sov.getProductName());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(4);
					cc.setCellValue(sov.getSupplierName());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(5);
					cc.setCellValue(sov.getBuyerNick());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(6);
					cc.setCellValue(sov.getReceiveMode());
					cc.setCellStyle(styleLeft);

					cc = row.createCell(7);
					cc.setCellValue((sov.getNumAdult() == null ? 0 : sov.getNumAdult()) + "+"
							+ (sov.getNumChild() == null ? 0 : sov.getNumChild()) + "+"
							+ (sov.getNumGuide() == null ? 0 : sov.getNumGuide()));
					cc.setCellStyle(cellStyle);

					cc = row.createCell(8);
					cc.setCellValue(sov.getSaleOperatorName());
					cc.setCellStyle(cellStyle);

					cc = row.createCell(9);
					cc.setCellValue("");
					cc.setCellStyle(styleLeft);

                    /*
                     * cc = row.createCell(9); cc.setCellValue("");
                     * cc.setCellStyle(cellStyle);
                     *
                     * cc = row.createCell(10); cc.setCellValue("");
                     * cc.setCellStyle(cellStyle);
                     */

					index++;
				} else {
					for (String guest : guests) {
						row = sheet.createRow(index + 2);
						cc = row.createCell(0);
						cc.setCellValue(num);
						cc.setCellStyle(cellStyle);

						cc = row.createCell(1);
						cc.setCellValue(sov.getGroupCode());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(2);
						cc.setCellValue(sov.getDepartureDate());
						cc.setCellStyle(cellStyle);

						cc = row.createCell(3);
						cc.setCellValue("【" + sov.getProductBrandName() + "】" + sov.getProductName());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(4);
						cc.setCellValue(sov.getSupplierName());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(5);
						cc.setCellValue(sov.getBuyerNick());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(6);
						cc.setCellValue(sov.getReceiveMode());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(7);
						cc.setCellValue((sov.getNumAdult() == null ? 0 : sov.getNumAdult()) + "+"
								+ (sov.getNumChild() == null ? 0 : sov.getNumChild()) + "+"
								+ (sov.getNumGuide() == null ? 0 : sov.getNumGuide()));
						cc.setCellStyle(cellStyle);

						cc = row.createCell(8);
						cc.setCellValue(sov.getSaleOperatorName());
						cc.setCellStyle(cellStyle);

						String str = guest.replace("@", "，");
						cc = row.createCell(9);
						cc.setCellValue(str.substring(0,str.length()));
						cc.setCellStyle(styleLeft);

                        /*
                         * cc = row.createCell(9);
                         * cc.setCellValue(guest.getCertificateNum());
                         * cc.setCellStyle(cellStyle);
                         *
                         * cc = row.createCell(10);
                         * cc.setCellValue(guest.getMobile());
                         * cc.setCellStyle(cellStyle);
                         */

						index++;
					}
					for (int i = 0; i < 10; i++) {
						if (i != 9) {
							CellRangeAddress region = new CellRangeAddress(createRow, createRow + guestList.size() - 1,
									i, i);
							sheet.addMergedRegion(region);
							cc = SheetUtil.getCellWithMerges(sheet, createRow, i);
							if (1 == i) {
								cc.setCellStyle(styleLeft);
							} else if (3 == i) {
								cc.setCellStyle(styleLeft);
							} else if (4 == i) {
								cc.setCellStyle(styleLeft);
							} else if (5 == i) {
								cc.setCellStyle(styleLeft);
							} else if (6 == i) {
								cc.setCellStyle(styleLeft);
							} else if (8 == i) {
								cc.setCellStyle(styleLeft);
							}else {
								cc.setCellStyle(cellStyle);
							}

						}
					}
				}
				if( guestList.size() == 0){
					createRow = createRow + 1;
				}else{
					createRow = createRow + guestList.size();

				}
				num++;
			}
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("操作单.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);

		// return "sales/taobaoOrder/taobaoOrderPreview";

	}


	/**
	 * 计调操作单
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("taobaoOrderListByOp.htm")
	public String taobaoOrderListByOp(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		TaobaoOrderListByOpDTO taobaoOrderListByOpDTO = new TaobaoOrderListByOpDTO();
		taobaoOrderListByOpDTO.setBizId(WebUtils.getCurBizId(request));
		TaobaoOrderListByOpDTO result = taobaoFacade.taobaoOrderListByOp(taobaoOrderListByOpDTO);
		model.addAttribute("pp", result.getPp());
		model.addAttribute("allProvince", result.getAllProvince());

		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("typeList", result.getTypeList());
		model.addAttribute("sourceTypeList", result.getSourceTypeList());

		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", result.getOrgUserJsonStr());
		return "sales/taobaoOrder/taobaoOrderListByOp";
	}


	/**
	 * 计调操作单table
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param groupOrder
	 * @return
	 */
	@RequestMapping("taobaoOrderListByOp_table.htm")
	public String taobaoOrderListByOp_table(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
											GroupOrder groupOrder) throws ParseException {

		TaobaoOrderListByOpDTO taobaoOrderListByOpDTO = new TaobaoOrderListByOpDTO();
		taobaoOrderListByOpDTO.setGroupOrder(groupOrder);
		taobaoOrderListByOpDTO.setBizId(WebUtils.getCurBizId(request));
		taobaoOrderListByOpDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));

		TaobaoOrderListByOpDTO taobaoResult = taobaoFacade.taobaoOrderListByOp_table(taobaoOrderListByOpDTO);


		model.addAttribute("typeList", taobaoResult.getTypeList());
		model.addAttribute("pageTotalAudit", taobaoResult.getPageTotalAudit());
		model.addAttribute("pageTotalChild", taobaoResult.getPageTotalChild());
		model.addAttribute("pageTotalGuide", taobaoResult.getPageTotalGuide());
		model.addAttribute("pageTotal", taobaoResult.getPageTotal());
		model.addAttribute("page", taobaoResult.getPage());
		GroupOrder go = taobaoResult.getGroupOrder();

		model.addAttribute("totalAudit", go.getNumAdult());
		model.addAttribute("totalChild", go.getNumChild());
		model.addAttribute("totalGuide", go.getNumGuide());
		model.addAttribute("total", go.getTotal());

		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String, Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.JDGL_JDCZD;
		model.addAttribute("CHANGE_PRICE",
				optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.CHANGE_PRICE)));
		return "sales/taobaoOrder/taobaoOrderListByOp_table";
	}


	@RequestMapping("changeOrderLockState.do")
	@ResponseBody()
	public String changeOrderLockState(Integer orderId) {
		taobaoFacade.changeOrderLockState(orderId);
		return successJson();
	}

	@RequestMapping("changeorderLockStateByOp.do")
	@ResponseBody()
	public String changeorderLockStateByOp(Integer orderId) {
		taobaoFacade.changeorderLockStateByOp(orderId);
		return successJson();
	}

	@RequestMapping("goBackOrderLockStateByOp.do")
	@ResponseBody()
	public String goBackOrderLockStateByOp(Integer orderId) {
		taobaoFacade.goBackOrderLockStateByOp(orderId);
		return successJson();
	}

	@RequestMapping("updateLockStateToFinance.do")
	@ResponseBody()
	public String updateLockStateToFinance(Integer orderId) {
		taobaoFacade.updateLockStateToFinance(orderId);
		return successJson();
	}

	@RequestMapping("goBackToOP.do")
	@ResponseBody()
	public String goBackToOP(Integer orderId) {
		taobaoFacade.goBackToOP(orderId);
		return successJson();
	}


	/**
	 * 选中签证填写信息
	 *
	 * @param request
	 * @param model
	 * @param orderMode
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "visa.htm")
	public String addSivaInfo(HttpServletRequest request, Integer orderId, String bookingDate, ModelMap model,
							  Integer orderMode) throws ParseException {
		AddSivaInfoDTO addSivaInfoDTO = new AddSivaInfoDTO();
		int bizId = WebUtils.getCurBizId(request);
		addSivaInfoDTO.setBizId(bizId);
		addSivaInfoDTO.setOrderId(orderId);
		AddSivaInfoDTO result = taobaoFacade.addSivaInfo(addSivaInfoDTO);

		GroupOrder orderBean = result.getOrderBean();

		model.addAttribute("orderBean", orderBean);
		model.addAttribute("orderMode", orderMode);
		model.addAttribute("orderId", orderId);
		model.addAttribute("bizId", bizId);
		return "sales/taobaoOrder/addVisaInfo";
	}

	/**
	 * 保存签证信息
	 *
	 * @param orderMode
	 * @param countStr
	 * @return
	 */
	@RequestMapping("saveVisaInfo.do")
	@ResponseBody()
	public String saveVisaInfo(HttpServletRequest request, String orderId, String orderMode, String countStr,
							   ModelMap model) {
		GroupOrder goBean = new GroupOrder();
		goBean.setId(Integer.valueOf(orderId));
		goBean.setExtVisaInfo(countStr);
		goBean.setOrderMode(orderMode == "" ? null : Integer.valueOf(orderMode));
		AddSivaInfoDTO addSivaInfoDTO = new AddSivaInfoDTO();
		addSivaInfoDTO.setOrderBean(goBean);
		taobaoFacade.saveVisaInfo(addSivaInfoDTO);
		return successJson();
	}

	/**
	 * 查询签证客户信息
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param mobile
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("visaDetail.do")
	public String loadGroupOrderVisaInfo(HttpServletRequest request, HttpServletResponse reponse, ModelMap model,
										 String mobile) throws ParseException {
		List<GroupOrder> groupOrderList = taobaoFacade.loadGroupOrderVisaInfo(mobile);
		model.addAttribute("groupOrderList", groupOrderList);
		return "sales/taobaoOrder/visaInfoGuestTable";
	}

	private Integer getCountByGroupId(List<Map<String, Object>> list, Integer groupId) {
		if (list == null || list.size() == 0 || groupId == null) {
			return 0;
		}

		Map<String, Object> map = null;
		for (int i = 0; i < list.size(); i++) {
			map = list.get(i);
			Integer mapGroupId = (Integer) map.get("group_id");
			if (mapGroupId == null) {
				continue;
			}
			if (groupId.intValue() == mapGroupId.intValue()) {
				return Integer.parseInt(map.get("count").toString());
			}
		}
		return 0;
	}

	private String getNamesByGroupId(List<Map<String, Object>> list, Integer groupId) {
		if (list == null || list.size() == 0 || groupId == null) {
			return null;
		}

		Map<String, Object> map = null;
		for (int i = 0; i < list.size(); i++) {
			map = list.get(i);
			Integer mapGroupId = (Integer) map.get("group_id");
			if (mapGroupId == null) {
				continue;
			}
			if (groupId.intValue() == mapGroupId.intValue()) {
				return map.get("bookSupplierName").toString();
			}
		}
		return null;
	}

	private List<MsgInfo> getMsgInfo(Map<String, Object> map) {
		return sysMsgInfoFacade.findMsgInfo(map);
	}


	/**
	 * 跳转至客人名单信息列表页面
	 *
	 * @param request
	 * @param model
	 * @param userRightType   0为销售，1为计调
	 * @return
	 */
	@RequestMapping(value = "findGroupOrderGuestPage.htm")
	public String findGroupOrderGuestPage(HttpServletRequest request, Model model,Integer userRightType) {
		Integer bizId = WebUtils.getCurBizId(request);
		TaobaoOrderListByOpDTO taobaoOrderListByOpDTO = new TaobaoOrderListByOpDTO();
		taobaoOrderListByOpDTO.setBizId(bizId);
		TaobaoOrderListByOpDTO result = taobaoFacade.findGroupOrderGuestPage(taobaoOrderListByOpDTO);
		model.addAttribute("typeList", result.getTypeList());
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr", result.getOrgUserJsonStr());
		model.addAttribute("userRightType", userRightType);
		return "sales/teamGroup/groupOrderGuestList";
	}

	@RequestMapping("toGroupOrderGuestListPage.do")
	public String loadGroupOrderGuestList(HttpServletRequest request, ModelMap model, GroupOrder groupOrder,
										  Integer pageSize, Integer page,Integer userRightType) throws ParseException {

		TaobaoOrderListByOpDTO taobaoOrderListByOpDTO = new TaobaoOrderListByOpDTO();
		taobaoOrderListByOpDTO.setBizId(WebUtils.getCurBizId(request));
		taobaoOrderListByOpDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		taobaoOrderListByOpDTO.setGroupOrder(groupOrder);
		TaobaoOrderListByOpDTO result = taobaoFacade.loadGroupOrderGuestList(taobaoOrderListByOpDTO);


		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("typeList", result.getTypeList());
		return "sales/teamGroup/groupOrderGuestTable";
	}


	@RequestMapping(value = "/toSaleGuestListExcel.do")
	public void toSaleGuestListExcel(HttpServletRequest request, HttpServletResponse response,
									 String startTime,String endTime,String receiveMode,String groupCode,String supplierName,
									 String orgIds,String orgNames,String operType,String saleOperatorIds,String saleOperatorName,
									 String orderMode,String remark,Integer page,Integer pageSize,Integer userRightType,
									 String guestName,Integer gender,Integer ageFirst,Integer ageSecond,String nativePlace) {
		GroupOrder vo = new GroupOrder();
		vo.setPage(page);
		vo.setPageSize(pageSize);
		vo.setStartTime(startTime);
		vo.setEndTime(endTime);
		vo.setRemark(remark);
		vo.setGuestName(guestName);
		vo.setOrderNo(orderMode);
		vo.setGroupCode(groupCode);
		vo.setSaleOperatorIds(saleOperatorIds);
		vo.setOrgIds(orgIds);
		vo.setOperType(Integer.valueOf(operType));
		vo.setReceiveMode(receiveMode);
		vo.setOrgNames(orgNames);
		vo.setSaleOperatorName(saleOperatorName);
		vo.setSupplierName(supplierName);
		vo.setGender(gender);
		vo.setAgeFirst(ageFirst);
		vo.setAgeSecond(ageSecond);
		vo.setNativePlace(nativePlace);

		PageBean pageBean = new PageBean();
		if (page == null) {
			pageBean.setPage(1);
		} else {
			pageBean.setPage(page);
		}
		if (pageSize == null) {
			pageBean.setPageSize(10000);
		} else {
			pageBean.setPageSize(10000);
		}
		pageBean.setParameter(vo);
		pageBean.setPage(page);

		ToSaleGuestListExcelDTO toSaleGuestListExcelDTO = new ToSaleGuestListExcelDTO();
		toSaleGuestListExcelDTO.setPage(page);
		toSaleGuestListExcelDTO.setPageSize(pageSize);
		toSaleGuestListExcelDTO.setStartTime(startTime);
		toSaleGuestListExcelDTO.setEndTime(endTime);
		toSaleGuestListExcelDTO.setRemark(remark);
		toSaleGuestListExcelDTO.setGuestName(guestName);
		toSaleGuestListExcelDTO.setOrderMode(orderMode);
		toSaleGuestListExcelDTO.setGroupCode(groupCode);
		toSaleGuestListExcelDTO.setSaleOperatorIds(saleOperatorIds);
		toSaleGuestListExcelDTO.setOrgIds(orgIds);
		toSaleGuestListExcelDTO.setOperType(operType);
		toSaleGuestListExcelDTO.setReceiveMode(receiveMode);
		toSaleGuestListExcelDTO.setOrgNames(orgNames);
		toSaleGuestListExcelDTO.setSaleOperatorName(saleOperatorName);
		toSaleGuestListExcelDTO.setSupplierName(supplierName);
		toSaleGuestListExcelDTO.setGender(gender);
		toSaleGuestListExcelDTO.setAgeFirst(ageFirst);
		toSaleGuestListExcelDTO.setAgeSecond(ageSecond);
		toSaleGuestListExcelDTO.setNativePlace(nativePlace);
		toSaleGuestListExcelDTO.setPage(page);

		toSaleGuestListExcelDTO.setBizId(WebUtils.getCurBizId(request));
		toSaleGuestListExcelDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		toSaleGuestListExcelDTO.setUserRightType(userRightType);
		ToSaleGuestListExcelDTO webResult = taobaoFacade.toSaleGuestListExcel(toSaleGuestListExcelDTO);
		pageBean = webResult.getPageBean();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String path = "";
		try {
			String url = request.getSession().getServletContext().getRealPath("/template/excel/groupGuestList.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			cellStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			cellStyle.setWrapText(true);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
			styleLeft.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleLeft.setWrapText(true);

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			styleRight.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleRight.setWrapText(true);

			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			//Iterator<GroupOrder> it = pageBean.getResult().iterator();
			Map map = null;
			int index = 0;
			DecimalFormat df = new DecimalFormat("0.##");
			if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
				for (int i = 0; i < pageBean.getResult().size(); i++) {
					map = (HashMap) pageBean.getResult().get(i);
					//GroupOrder go = it.next();

					row = sheet.createRow(index + 2);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue((String)map.get("group_code"));//团号
					cc.setCellStyle(styleLeft);

					cc = row.createCell(2);
					cc.setCellValue(sdf.format(map.get("departure_date")));//发团日期
					cc.setCellStyle(cellStyle);

					cc = row.createCell(3);
					cc.setCellValue((String)map.get("supplier_name"));//平台来源
					cc.setCellStyle(styleLeft);

					cc = row.createCell(4);
					cc.setCellValue((String)map.get("receive_mode"));//客人信息
					cc.setCellStyle(styleLeft);

					cc = row.createCell(5);
					cc.setCellValue((String)map.get("name"));//姓名
					cc.setCellStyle(styleLeft);

					cc = row.createCell(6);
					cc.setCellValue((Integer)map.get("gender")==0?"女":"男");//性别
					cc.setCellStyle(cellStyle);

					cc = row.createCell(7);
					cc.setCellValue(String.valueOf(map.get("age")));//年龄
					cc.setCellStyle(cellStyle);

					cc = row.createCell(8);
					cc.setCellValue((String)(map.get("certificate_num")));//证件号
					cc.setCellStyle(cellStyle);

					cc = row.createCell(9);
					cc.setCellValue((String)map.get("mobile"));//电话
					cc.setCellStyle(cellStyle);

					cc = row.createCell(10);
					cc.setCellValue((String)map.get("native_place"));//籍贯
					cc.setCellStyle(styleLeft);

					cc = row.createCell(11);
					cc.setCellValue((String)map.get("remark"));//产品套餐
					cc.setCellStyle(styleLeft);

					if((Integer)map.get("order_mode")==1374){
						cc = row.createCell(12);
						cc.setCellValue("长线");//业务
						cc.setCellStyle(cellStyle);
					} else if((Integer)map.get("order_mode")==1475){
						cc = row.createCell(12);
						cc.setCellValue("短线");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1476){
						cc = row.createCell(12);
						cc.setCellValue("签证");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1486){
						cc = row.createCell(12);
						cc.setCellValue("门票");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1487){
						cc = row.createCell(12);
						cc.setCellValue("酒店");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1488){
						cc = row.createCell(12);
						cc.setCellValue("专线");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1489){
						cc = row.createCell(12);
						cc.setCellValue("包车");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1490){
						cc = row.createCell(12);
						cc.setCellValue("组团");//业务
						cc.setCellStyle(cellStyle);
					}else if((Integer)map.get("order_mode")==1493){
						cc = row.createCell(12);
						cc.setCellValue("推广");//业务
						cc.setCellStyle(cellStyle);
					}else {
						cc = row.createCell(12);
						cc.setCellValue("石林九乡");//业务
						cc.setCellStyle(cellStyle);
					}

					cc = row.createCell(13);
					cc.setCellValue((String)map.get("sale_operator_name"));//销售
					cc.setCellStyle(cellStyle);

					cc = row.createCell(14);
					cc.setCellValue((String)map.get("operator_name"));//计调
					cc.setCellStyle(cellStyle);

					Integer sumAC = (Integer) map.get("num_adult")+(Integer) map.get("num_child");
					BigDecimal total = (BigDecimal) map.get("total");

					cc = row.createCell(15);
					cc.setCellValue(df.format(total.divide(new BigDecimal(sumAC),2, RoundingMode.HALF_UP)));//金额
					cc.setCellStyle(cellStyle);

					index++;
				}
			}
			CellRangeAddress region = new CellRangeAddress(pageBean.getResult().size() + 5,
					pageBean.getResult().size() + 5, 0, 10);
			sheet.addMergedRegion(region);

			row = sheet.createRow(pageBean.getResult().size() + 5);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("客人名单导出.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);
	}

	// 导出Export
	@RequestMapping(value = "/toGroupOrderGuesExport.do")
	@ResponseBody
	public void toGroupOrderGuesExport(HttpServletRequest request, HttpServletResponse response,
									   String startTime,String endTime,String receiveMode,String groupCode,String supplierName,
									   String orgIds,String orgNames,String operType,String saleOperatorIds,String saleOperatorName,
									   String orderMode,String remark,Integer page,Integer pageSize,Integer userRightType,
									   String guestName,Integer gender,Integer ageFirst,Integer ageSecond,String nativePlace){


		PageBean pageBean = new PageBean();
		ToSaleGuestListExcelDTO toSaleGuestListExcelDTO = new ToSaleGuestListExcelDTO();
		toSaleGuestListExcelDTO.setPage(page);
		toSaleGuestListExcelDTO.setPageSize(pageSize);
		toSaleGuestListExcelDTO.setStartTime(startTime);
		toSaleGuestListExcelDTO.setEndTime(endTime);
		toSaleGuestListExcelDTO.setRemark(remark);
		toSaleGuestListExcelDTO.setGuestName(guestName);
		toSaleGuestListExcelDTO.setOrderMode(orderMode);
		toSaleGuestListExcelDTO.setGroupCode(groupCode);
		toSaleGuestListExcelDTO.setSaleOperatorIds(saleOperatorIds);
		toSaleGuestListExcelDTO.setOrgIds(orgIds);
		toSaleGuestListExcelDTO.setOperType(operType);
		toSaleGuestListExcelDTO.setReceiveMode(receiveMode);
		toSaleGuestListExcelDTO.setOrgNames(orgNames);
		toSaleGuestListExcelDTO.setSaleOperatorName(saleOperatorName);
		toSaleGuestListExcelDTO.setSupplierName(supplierName);
		toSaleGuestListExcelDTO.setGender(gender);
		toSaleGuestListExcelDTO.setAgeFirst(ageFirst);
		toSaleGuestListExcelDTO.setAgeSecond(ageSecond);
		toSaleGuestListExcelDTO.setNativePlace(nativePlace);
		toSaleGuestListExcelDTO.setPage(page);

		toSaleGuestListExcelDTO.setBizId(WebUtils.getCurBizId(request));
		toSaleGuestListExcelDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		toSaleGuestListExcelDTO.setUserRightType(userRightType);

		toSaleGuestListExcelDTO.setDoType(1);

		ToSaleGuestListExcelDTO webResult = taobaoFacade.toSaleGuestListExcel(toSaleGuestListExcelDTO);
		pageBean = webResult.getPageBean();
		String path = "";
		try {
			String url = request.getSession().getServletContext().getRealPath("/template/excel/groupGuestContact.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			XSSFFont createFont = wb.createFont();
			createFont.setFontName("微软雅黑");
			createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
			createFont.setFontHeightInPoints((short) 12);

			XSSFFont tableIndex = wb.createFont();
			tableIndex.setFontName("宋体");
			tableIndex.setFontHeightInPoints((short) 11);

			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleFontCenter = wb.createCellStyle();
			styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontCenter.setFont(createFont);

			CellStyle styleFontTable = wb.createCellStyle();
			styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行

			int index = 0;
			Map map = null;

			if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
				for (int i = 0; i < pageBean.getResult().size(); i++) {
					map = (HashMap) pageBean.getResult().get(i);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

					row = sheet.createRow(index + 7);
					addRow(row, cc, index, cellStyle, map, styleLeft, sdf);
					index++;

				}
			}

			if (pageBean.getTotalPage() > 1) {
				for (int m = 2; m <= pageBean.getTotalPage(); m++) {
					pageBean.setPage(m);
					toSaleGuestListExcelDTO.setDoType(2);
					toSaleGuestListExcelDTO.setPageBean(pageBean);
//					pageBean = groupOrderService.selectGroupOrderGuestListPage(pageBean, WebUtils.getCurBizId(request),
//							WebUtils.getDataUserIdSet(request),userRightType);

					ToSaleGuestListExcelDTO webResult2 = taobaoFacade.toSaleGuestListExcel(toSaleGuestListExcelDTO);
					pageBean = webResult2.getPageBean();
					List list = pageBean.getResult();
					if (list != null && list.size() > 0) {
						for (int j = 0; j < list.size(); j++) {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
							map = (HashMap) pageBean.getResult().get(j);
							row = sheet.createRow(index + 7);
							addRow(row, cc, index, cellStyle, map, styleLeft, sdf);
							index++;
						}
					}
				}
			}
            /*
             * Row to_v_row = sheet.createRow(2); Cell to_v_cc =
             * to_v_row.createCell(1); to_v_cc.setCellValue("11");
             * to_v_cc.setCellStyle(styleLeft);
             */

			row = sheet.createRow(5);
			cc = row.createCell(2);
			cc.setCellValue("团成员信息：" + "" + "共：" + (int) pageBean.getTotalCount() + "人");

			CellRangeAddress groupInfo = new CellRangeAddress((int) pageBean.getTotalCount() + 11,
					(int) pageBean.getTotalCount() + 12, 0, 4);
			sheet.addMergedRegion(groupInfo);
			row = sheet.createRow((int) pageBean.getTotalCount() + 11);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName() + " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("地接联系单.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);

	}

	private void addRow(Row row, Cell cc, int index, CellStyle cellStyle, Map map, CellStyle styleLeft,
						SimpleDateFormat sdf) {

		cc = row.createCell(0);
		cc.setCellValue((String) map.get("receive_mode"));
		cc.setCellStyle(styleLeft);

		cc = row.createCell(1);
		cc.setCellValue((String) map.get("name"));
		cc.setCellStyle(styleLeft);

		cc = row.createCell(2);
		cc.setCellValue((String) map.get("certificate_num"));
		cc.setCellStyle(styleLeft);

		cc = row.createCell(3);
		cc.setCellValue(String.valueOf(map.get("mobile")));
		cc.setCellStyle(styleLeft);

		cc = row.createCell(4);
		cc.setCellValue((String) map.get("remark"));
		cc.setCellStyle(styleLeft);
	}

	private void download(String path, String fileName, HttpServletRequest request, HttpServletResponse response) {
		try {
			// path是指欲下载的文件的路径。
			File file = new File(path);
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

            /*
             * //解决IE浏览器下下载文件名乱码问题 if
             * (request.getHeader("USER-AGENT").indexOf("msie") > -1){ fileName
             * = new URLEncoder().encode(fileName) ; }
             */
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
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
	 * 订单保险投保单
	 *
	 * @param request
	 * @param response
	 */
	@RequestMapping("downloadInsure.htm")
	public void downloadInsureFile(HttpServletRequest request, HttpServletResponse response,
								   String startTime,String endTime,String receiveMode,String groupCode,String supplierName,
								   String orgIds,String orgNames,String operType,String saleOperatorIds,String saleOperatorName,
								   String orderMode,String remark,Integer page,Integer pageSize,Integer userRightType,
								   String guestName,Integer gender,Integer ageFirst,Integer ageSecond,String nativePlace){
		try {
			// 处理中文文件名下载乱码
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		String path = "";
		String fileName = "";

		// 旅游综合保障计划投保书
		try {
			fileName = new String("旅游综合保障计划投保书.doc".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		path = saleInsurance( request,  response,   startTime, endTime, receiveMode, groupCode, supplierName,
				orgIds, orgNames, operType, saleOperatorIds, saleOperatorName,
				orderMode, remark, page, pageSize, userRightType,
				guestName, gender, ageFirst, ageSecond, nativePlace);

		response.setCharacterEncoding("utf-8");
		response.setContentType("application/msword"); // word格式
		try {
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			File file = new File(path);
			InputStream inputStream = new FileInputStream(file);
			OutputStream os = response.getOutputStream();
			byte[] b = new byte[10240];
			int length;
			while ((length = inputStream.read(b)) > 0) {
				os.write(b, 0, length);
			}
			inputStream.close();
			os.flush();
			os.close();
			file.delete();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 旅游综合保障计划投保书
	 *
	 * @param request
	 * @return
	 */
	public String saleInsurance(HttpServletRequest request, HttpServletResponse response,
								String startTime,String endTime,String receiveMode,String groupCode,String supplierName,
								String orgIds,String orgNames,String operType,String saleOperatorIds,String saleOperatorName,
								String orderMode,String remark,Integer page,Integer pageSize,Integer userRightType,
								String guestName,Integer gender,Integer ageFirst,Integer ageSecond,String nativePlace){
		// TourGroup tg = tourGroupService.findByGroupCode(groupCode);
		String url = request.getSession().getServletContext().getRealPath("/") + "/download/"
				+ System.currentTimeMillis() + ".doc";
		// List<GroupOrderGuest> guests =
		// groupOrderGuestService.getGuestByGroupIdAndIsLeader(tg.getId(),
		// null);
		// GroupOrder groupOrder = groupOrderService.selectByPrimaryKey(null,
		// groupId);
		// GroupRoute groupRoute = groupRouteService.selectDayNumAndMaxday(null,
		// tg.getId());
		String realPath = request.getSession().getServletContext().getRealPath("/template/guestInsurances.docx");
		WordReporter export = new WordReporter(realPath);
		try {
			export.init();
		} catch (IOException e) {
			e.printStackTrace();
		}

		GroupOrder vo = new GroupOrder();
		vo.setPage(page);
		vo.setPageSize(pageSize);
		vo.setStartTime(startTime);
		vo.setEndTime(endTime);
		vo.setRemark(remark);
		vo.setGuestName(guestName);
		vo.setOrderNo(orderMode);
		vo.setGroupCode(groupCode);
		vo.setSaleOperatorIds(saleOperatorIds);
		vo.setOrgIds(orgIds);
		vo.setOperType(Integer.valueOf(operType));
		vo.setReceiveMode(receiveMode);
		vo.setOrgNames(orgNames);
		vo.setSaleOperatorName(saleOperatorName);
		vo.setSupplierName(supplierName);
		vo.setGender(gender);
		vo.setAgeFirst(ageFirst);
		vo.setAgeSecond(ageSecond);
		vo.setNativePlace(nativePlace);

		TaobaoOrderListTableDTO taobaoOrderListTableDTO = new TaobaoOrderListTableDTO();
		taobaoOrderListTableDTO.setDataUserIdSets(WebUtils.getDataUserIdSet(request));
		taobaoOrderListTableDTO.setBizId(WebUtils.getCurBizId(request));
		taobaoOrderListTableDTO.setGroupOrder(vo);

		com.yimayhd.erpcenter.facade.tj.client.result.WebResult<PageBean> webResult = taobaoFacade.saleInsurance(taobaoOrderListTableDTO, page, pageSize, userRightType);

		PageBean pageBean = new PageBean();
		pageBean = webResult.getValue();
		List<Map<String, String>> guestList = new ArrayList<Map<String, String>>();
		Map<String, String> map = null, mapTemp = null;
		int index = 0;
		if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
			int firstSum = pageBean.getResult().size() / 2;
			for (int i = 0; i < firstSum; i++) {
				map = (HashMap) pageBean.getResult().get(i);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				mapTemp = new HashMap<String, String>();
				mapTemp.put("number", index + 1 + "");
				mapTemp.put("code", (String) map.get("receive_mode"));
				mapTemp.put("guestName", (String) map.get("name"));
				mapTemp.put("cerNum", (String) map.get("certificate_num"));
				mapTemp.put("snumber", "");
				mapTemp.put("scode", "");
				mapTemp.put("sguestName", "");
				mapTemp.put("scerNum", "");
				guestList.add(mapTemp);
				index++;
			}

			for (int i = firstSum; i < pageBean.getResult().size(); i++) {
				map = (HashMap) pageBean.getResult().get(i);
				mapTemp = isAddNewRow(guestList);
				if (mapTemp == null) {
					mapTemp = new HashMap<String, String>();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					mapTemp.put("number", index + 1 + "");
					mapTemp.put("code", (String) map.get("receive_mode"));
					mapTemp.put("guestName", (String) map.get("name"));
					mapTemp.put("cerNum", (String) map.get("certificate_num"));
					guestList.add(mapTemp);
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					mapTemp.put("snumber", index + 1 + "");
					mapTemp.put("scode", (String) map.get("receive_mode"));
					mapTemp.put("sguestName", (String) map.get("name"));
					mapTemp.put("scerNum", (String) map.get("certificate_num"));
				}
				index++;
			}

		}

		Map<String, Object> mapHeader = new HashMap<String, Object>();
		mapHeader.put("company", WebUtils.getCurBizInfo(request).getName()); // 当前单位
		mapHeader.put("operator", WebUtils.getCurUser(request).getName());
		mapHeader.put("printTime", DateUtils.format(new Date()));
		mapHeader.put("opTel", WebUtils.getCurUser(request).getMobile());
		mapHeader.put("groupCode", "");
		mapHeader.put("person", String.valueOf(pageBean.getTotalCount()));
		mapHeader.put("guide", "");
		mapHeader.put("departureDate", "");
		mapHeader.put("maxDay", "");
		mapHeader.put("numDay", "");

		try {
			export.export(mapHeader, 0);
			export.export(guestList, 1);
			export.generate(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}

	private Map<String, String> isAddNewRow(List<Map<String, String>> guestList) {
		Map<String, String> ret = null;
		for (Map<String, String> item : guestList) {
			if ("".equals(item.get("snumber"))) {
				ret = item;
				break;
			}
		}
		return ret;

	}

	/**
	 * 改价格
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "changePrice.do")
	public String changePrice(HttpServletRequest request, Model model, Integer orderId) {

		ChangePriceDTO changePriceDTO = new ChangePriceDTO();
		changePriceDTO.setBizId(WebUtils.getCurBizId(request));
		changePriceDTO.setOrderId(orderId);
		ChangePriceDTO webResult = taobaoFacade.changePrice(changePriceDTO);
		model.addAttribute("gop", webResult.getGop());
		model.addAttribute("lysfxmList", webResult.getLysfxmList());
		model.addAttribute("orderId", orderId);
		return "sales/taobaoOrder/changePrice";
	}

	@RequestMapping(value = "savePrice.do")
	@ResponseBody()
	public String savePrice(HttpServletRequest request, Model model, Integer orderId, GroupOrderPriceVO vo) {
		List<GroupOrderPrice> groupOrderPrices = vo.getGroupOrderPriceList();
		ChangePriceDTO changePriceDTO = new ChangePriceDTO();
		changePriceDTO.setBizId(WebUtils.getCurBizId(request));
		changePriceDTO.setOrderId(orderId);
		changePriceDTO.setGroupOrderPrices(groupOrderPrices);
		changePriceDTO.setUserName(WebUtils.getCurrentUserSession(request).getName());
		changePriceDTO.setUserId(WebUtils.getCurUserId(request));
		taobaoFacade.savePrice(changePriceDTO);

		return successJson();
	}



}
