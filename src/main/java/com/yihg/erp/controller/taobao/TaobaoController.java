package com.yihg.erp.controller.taobao;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.SpecialGroupOrderVO;
import com.yimayhd.erpcenter.dal.sales.client.taobao.po.PlatTaobaoTrade;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.tj.client.query.ImportTaobaoOrderTableDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.SaveSpecialGroupDTO;
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
}
