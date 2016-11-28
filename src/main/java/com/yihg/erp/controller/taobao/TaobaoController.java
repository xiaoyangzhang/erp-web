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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
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
     * @param modelMap
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
     * @param page
     * @param pageSize
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
}
