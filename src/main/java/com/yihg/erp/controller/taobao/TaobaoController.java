package com.yihg.erp.controller.taobao;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.facade.result.WebResult;
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
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SpecialGroupOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.taobao.po.PlatTaobaoTrade;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.basic.service.DicFacade;
import com.yimayhd.erpcenter.facade.sales.query.ReportStatisticsQueryDTO;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;
import com.yimayhd.erpcenter.facade.tj.client.query.ImportTaobaoOrderTableDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.PresellProductStatistics;
import com.yimayhd.erpcenter.facade.tj.client.query.SaveSpecialGroupDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.ShopSalesStatisticsQueryDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TaobaoOrderListTableDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TaobaoOriginalOrderTableDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.ToEditTaobaoOrderDTO;
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
	
	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
	
	private SysPlatformOrgFacade sysPlatformOrgFacade;
	
	private DicFacade dicFacade;
	
	private GroupOrderFacade groupOrderFacade;
	
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
			HttpServletResponse reponse, ModelMap model,Integer id,Integer operType) throws ParseException{
		ToEditTaobaoOrderDTO dto = new ToEditTaobaoOrderDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setOrderId(id);
		dto.setOperType(operType);
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
		model.addAttribute("guideStr", result.getGuideStr());
		model.addAttribute("orders", result.getOrders());
		model.addAttribute("tbIds", result.getTbOrderIds());
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
		pm.put("startMin",pm.get("startMin")+" 00:00:00");
		pm.put("startMax",pm.get("startMax")+" 23:59:59");
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
		pm.put("startMin",startTime+" 00:00:00");
		pm.put("startMax",endTime+" 23:59:59");
		
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
	 * @param orderVO
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
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP, WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> typeList = dicService.getListByTypeCode(BasicConstants.SALES_TEAM_TYPE, bizId);
		model.addAttribute("typeList", typeList);
		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);

		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "sales/taobaoOrder/taobaoOrderListByOp";
	}



}
