package com.yihg.erp.controller.airticket;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.airticket.api.AirTicketOrderService;
import com.yihg.airticket.api.AirTicketRequestService;
import com.yihg.airticket.api.AirTicketResourceService;
import com.yihg.airticket.po.AirTicketLeg;
import com.yihg.airticket.po.AirTicketOrder;
import com.yihg.airticket.po.AirTicketRequest;
import com.yihg.airticket.po.AirTicketResource;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.exception.ClientException;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.bo.airticket.AirTicketRequestBO;
import com.yihg.erp.bo.airticket.AirTicketResourceBO;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.operation.po.BookingSupplier;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.supplier.constants.Constants;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.GroupOrderTransportService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderTransport;
import com.yihg.sales.po.TourGroup;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.po.PlatformEmployeePo;

@Controller
@RequestMapping("/airticket/request")
public class RequestController extends BaseController {
	private static final Logger log = LoggerFactory.getLogger(ResourceController.class);
	@Autowired
	private GroupOrderService groupOrderService; 
	@Autowired
	private GroupOrderGuestService groupOrderGuestService;
	@Autowired
	private AirTicketRequestService airTicketRequestService;
	@Autowired
	private AirTicketResourceService airTicketResourceService;
	@Autowired
	private SupplierService supplierService;
	private Map<Integer, String> ticketSuppliers;
	@Autowired
	private AirTicketOrderService airTicketOrderService;
	@Autowired
	private BookingSupplierService bookingSupplierService;
	@Autowired
	private BookingSupplierDetailService bookingSupplierDetailService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private SupplierService supllierService;
	@Autowired
	private DicService dicService;	
	@Autowired
	private GroupOrderTransportService groupOrderTransportService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	
	
	public GroupOrderService getGroupOrderService(){
		return groupOrderService;
	}
	public AirTicketResourceService getAirTicketResourceService(){
		return airTicketResourceService;
	}
	
	@RequestMapping("alist.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String arrangeList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		return this.showList(request, reponse, model, true);
	}
	
	@RequestMapping("list.htm")
	public String requestList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		return this.showList(request, reponse, model, false);
	}
	
	private String showList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, boolean isArrange){
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
//long startMili=System.currentTimeMillis();
		String dateFrom="",  dateTo="", dateType="";
		if (request.getParameter("dateFrom")==null && request.getParameter("dateTo")==null){
			Calendar cal = Calendar.getInstance(); 
			SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
			cal.set( Calendar.DATE, 1 );
			cal.roll(Calendar.DATE, - 1 );
			dateTo=sdf.format(cal.getTime());
			cal.set(GregorianCalendar.DAY_OF_MONTH, 1);
			dateFrom=sdf.format(cal.getTime());
			dateType = "start";
		}else {
			dateFrom = request.getParameter("dateFrom");
			dateTo = request.getParameter("dateTo");
			dateType = request.getParameter("dateType");
		}
		String productName="", lineName="", contactName="", orderNo="", endIssueDateFrom="", endIssueDateTo="", type;
		try {
			productName = request.getParameter("productName");
			lineName = request.getParameter("lineName");
			contactName = request.getParameter("contactName");
			endIssueDateFrom = request.getParameter("endIssueDateFrom");
			endIssueDateTo = request.getParameter("endIssueDateTo");
			orderNo = request.getParameter("orderNo");
			dateFrom = dateFrom==null?"":dateFrom;
			dateTo = dateTo==null?"":dateTo;
			productName = productName==null?"":productName;
			lineName = lineName==null?"":lineName;
			contactName = contactName==null?"":contactName;
			orderNo = orderNo==null?"":orderNo;
		}catch(Exception e){
			e.printStackTrace();
		}

		Integer bizId = WebUtils.getCurBizId(request);
		PageBean<AirTicketRequest> pageBean = new PageBean<AirTicketRequest>();
		try {
			if (pageSize != null){
				pageBean.setPageSize(new Integer(pageSize));
			}else {
				pageBean.setPageSize(15);
			}
			if (page != null){
				pageBean.setPage(new Integer(page));
			}
		}catch(Exception e){
			log.error("Wrong format of page size:" + pageSize + " or page:"+page);
		}
		HashMap<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bizId", WebUtils.getCurBizId(request));
		parameter.put("dateFrom", dateFrom);
		parameter.put("dateTo", dateTo);
		parameter.put("dateType", dateType);
		parameter.put("productName", productName);
		parameter.put("lineName", lineName);
		parameter.put("contactName", contactName);
		parameter.put("orderNo", orderNo);
		parameter.put("receiveMode", request.getParameter("receiveMode"));
		parameter.put("issueStatus", request.getParameter("issueStatus"));
		parameter.put("depCity", request.getParameter("depCity"));
		parameter.put("type", request.getParameter("type"));
		if (!isArrange){
			parameter.put("dataUser", WebUtils.getDataUserIdString(request));
		}
		if (endIssueDateFrom!=null){
			parameter.put("endIssueDateFrom", endIssueDateFrom);
			parameter.put("endIssueTimeFrom", endIssueDateFrom+" 00:00");
		}
		if (endIssueDateTo!=null){
			parameter.put("endIssueDateTo", endIssueDateTo);
			parameter.put("endIssueTimeTo", endIssueDateTo +" 24:00");
		}
		pageBean.setParameter(parameter);
		HashMap<String, Integer> count = airTicketRequestService.countRequestList(pageBean);
		model.addAttribute("count", count);
		pageBean = airTicketRequestService.selectRequestListPage(pageBean);
		ArrayList<AirTicketRequestBO> resultBo = new ArrayList<AirTicketRequestBO>();
		
		HashSet<Integer> resourceIdSet = new HashSet<Integer>();
		HashSet<Integer> groupOrderIdSet = new HashSet<Integer>();
		for(AirTicketRequest q : pageBean.getResult()){
			resourceIdSet.add(q.getResourceId());
			groupOrderIdSet.add(q.getGroupOrderId());
		}
		Map<Integer,GroupOrder> orderMap = groupOrderService.findOrderByIdList(bizId, new ArrayList<Integer>(groupOrderIdSet));
		Map<Integer,AirTicketResource> resourceMap = airTicketResourceService.findResourceByIdList(bizId, new ArrayList<Integer>(resourceIdSet));
		Map<Integer, List<AirTicketLeg>> legsMap = airTicketResourceService.findLegsByResourceIdList(new ArrayList<Integer>(resourceIdSet));
		
		for(int i=0; i<pageBean.getResult().size(); i++){
			AirTicketRequest po = pageBean.getResult().get(i);
			AirTicketRequestBO bo = new AirTicketRequestBO(po);
			bo.setArrange(isArrange);
			AirTicketResource resourcePo = resourceMap.get(po.getResourceId());
			AirTicketResourceBO resourceBo = new AirTicketResourceBO(resourcePo);
			resourceBo.setLegList(legsMap.get(resourcePo.getId()));
			bo.setResource(resourcePo);
			bo.setGroupOrder(orderMap.get(po.getGroupOrderId()));
			//AirTicketResourceBO resoruceBo = getResoruceBo(request, model, po.getResourceId());
			bo.setResourceBo(resourceBo);
			resultBo.add(bo);
		}
		
		model.addAttribute("page", pageBean);
		model.addAttribute("resultBo", resultBo);
		model.addAttribute("isArrange", isArrange);
		if (isArrange){model.addAttribute("arrange", "a");}
		return "airticket/request_list";
	}
	
	@RequestMapping("view.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String viewRequest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		return showView(request, reponse, model, id);
	}
	
	@RequestMapping("aview.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String aviewRequest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		model.addAttribute("arrange", "a");
		model.addAttribute("isArrange", true);
		return showView(request, reponse, model, id);
	}
	
	private String showView(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		getResoruceBo(request, model, id); 
		return "airticket/request_view";
	}
	private AirTicketResourceBO getResoruceBo(HttpServletRequest request, ModelMap model,
			Integer id) {
		String confirm = (String)request.getParameter("confirm"); // used for show confirmation page of request.
		AirTicketRequest po = airTicketRequestService.findRequest(id, WebUtils.getCurBizId(request));
		AirTicketRequestBO bo = new AirTicketRequestBO(po);
		bo.setResource(airTicketResourceService.findResource(po.getResourceId(), 
				WebUtils.getCurBizId(request)));
		bo.setGroupOrder(groupOrderService.findById(po.getGroupOrderId()));

		model.addAttribute("bo", bo);
		AirTicketResourceBO resourceBo = new AirTicketResourceBO(po.getResource());
		resourceBo.setLegList(airTicketResourceService.findLegsByResourceId(resourceBo.getPo().getId()));
		model.addAttribute("resourceBo", resourceBo);
		List<GroupOrderGuest> groupGuestList = groupOrderGuestService.selectByOrderId(po.getGroupOrderId());
		model.addAttribute("guests", groupGuestList);

		model.addAttribute("confirm", confirm);
		return resourceBo;
	}
	
	@RequestMapping("ticketList.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String ticketList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		Integer bizId = WebUtils.getCurBizId(request);
		AirTicketResource resourcePo = airTicketResourceService.findResource(id, bizId);
		AirTicketResourceBO resourceBo = new AirTicketResourceBO(resourcePo);
		resourceBo.setLegList(airTicketResourceService.findLegsByResourceId(resourceBo.getPo().getId()));
		model.addAttribute("resource", resourceBo);
		List<AirTicketRequest> requestList = airTicketRequestService.findRequestsByResource(id, bizId);
		List<AirTicketRequestBO> boList = new ArrayList<AirTicketRequestBO>();
		for (int i=0; i<requestList.size(); i++){
			AirTicketRequest po = requestList.get(i);
			po.setResource(resourcePo);
			AirTicketRequestBO bo = new AirTicketRequestBO(po);
			bo.setGroupOrder(groupOrderService.findById(po.getGroupOrderId()));
			bo.go.setGroupOrderGuestList(groupOrderGuestService.selectByOrderId(po.getGroupOrderId())); 
			boList.add(bo);
		}
		
		model.addAttribute("boList", boList);
		return "airticket/ticket_list";
	}
	
	@RequestMapping("add.htm")
	public String addRequest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		return "airticket/request_edit";
	}

	@RequestMapping("edit.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String editRequest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		AirTicketRequest po = airTicketRequestService.findRequest(id, WebUtils.getCurBizId(request));
		AirTicketRequestBO bo = new AirTicketRequestBO(po);
		bo.setResource(airTicketResourceService.findResource(po.getResourceId(), 
				WebUtils.getCurBizId(request)));
		bo.setGroupOrder(groupOrderService.findById(po.getGroupOrderId()));

		model.addAttribute("bo", bo);
		AirTicketResourceBO resourceBo = new AirTicketResourceBO(po.getResource());
		resourceBo.setLegList(airTicketResourceService.findLegsByResourceId(resourceBo.getPo().getId()));
		model.addAttribute("resourceBo", resourceBo);
		List<GroupOrderGuest> groupGuestList = groupOrderGuestService.selectByOrderId(po.getGroupOrderId());
		model.addAttribute("guests", groupGuestList);
		ArrayList<Boolean> inTicketList= new ArrayList<Boolean>(); // 用于记录客户是否在订单里
		for(int i=0; i<groupGuestList.size(); i++){
			if (bo.isGuestInRequest(groupGuestList.get(i).getId())){
				inTicketList.add(true);
			}else {
				inTicketList.add(false);
			}
		}
		model.addAttribute("inTicketList", inTicketList);
		return "airticket/request_edit";
	}
	
	/* 添加接送机信息  */
	@RequestMapping(value = "pickUpGuest.htm")
	public String pickUpGuest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		AirTicketRequest po = airTicketRequestService.findRequest(id, WebUtils.getCurBizId(request));
		AirTicketRequestBO bo = new AirTicketRequestBO(po);
		bo.setResource(airTicketResourceService.findResource(po.getResourceId(), WebUtils.getCurBizId(request)));
		bo.setGroupOrder(groupOrderService.findById(po.getGroupOrderId()));
		model.addAttribute("bo", bo);
		AirTicketResourceBO resourceBo = new AirTicketResourceBO(po.getResource());
		resourceBo.setLegList(airTicketResourceService.findLegsByResourceId(resourceBo.getPo().getId()));
		model.addAttribute("resourceBo", resourceBo);
		List<GroupOrderTransport> existingTransport = groupOrderTransportService.selectByOrderId(po.getGroupOrderId());
		List<GroupOrderTransport> existingAir = new ArrayList<GroupOrderTransport>();
		Integer methodAir = this.getPickUpMethodAir(request);
		for(GroupOrderTransport t: existingTransport){
			if (t.getMethod()==null){continue;}
			if (t.getMethod().equals(methodAir)){
				existingAir.add(t);
			}
		}
		model.addAttribute("existingTransport", JSONArray.toJSONString(existingAir));
		return "airticket/pick_up_guest";
	}

	@RequestMapping("checkBookingSupplier.do")
	@ResponseBody
	public String checkBookingSupplier(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer bookingId){
		BookingSupplier supplier = bookingSupplierService.selectByPrimaryKey(bookingId);
		Map<String,Object> map = new HashMap<String,Object>();
		if (supplier!=null){
			map.put("exists", true);
			map.put("supplierType", supplier.getSupplierType());
		}else {
			map.put("exists", false);
		}
		return JSON.toJSONString(map);
	}
	
	
	@RequestMapping("resourceInfo.htm")
	@ResponseBody
	public String showResourceInfo(HttpServletRequest request, HttpServletResponse reponse) throws ParseException{
		Integer resourceId = Integer.parseInt((String)request.getParameter("id"));
		if (resourceId==null){return "";}
		AirTicketResource resourcePo = airTicketResourceService.findResource(resourceId, WebUtils.getCurBizId(request));
		AirTicketResourceBO resourceBo = new AirTicketResourceBO(resourcePo);
		resourceBo.setLegList(airTicketResourceService.findLegsByResourceId(resourceBo.getPo().getId()));
		StringBuffer sb = new StringBuffer();
		sb.append("<tr style=\"height:80px;\">");
		sb.append("<td>").append(resourceBo.getPo().getLineName()).append("</td>");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sb.append("<td>").append(sdf.format(resourceBo.getPo().getStartDate())).append("</td>");
		sb.append("<td>").append(resourceBo.getLegHtml()).append("</td>");
		sb.append("<td>").append(resourceBo.getTicketSupplier()).append("</td>");
		sb.append("<td>").append(resourceBo.getPrice()).append("</td>");
		sb.append("<td>").append(resourceBo.getPo().getAvailableNumber().toString()).append("</td>");
		sb.append("<td>").append(resourceBo.getEndIssueTime()).append("</td>");
		sb.append("<script>ticketPrice=\"").append(resourceBo.getPrice()).append("\";</script></tr>");
		return sb.toString();
	}
	
	@RequestMapping("groupOrderInfo.htm")
	@ResponseBody
	public String showGroupOrderInfo(HttpServletRequest request, HttpServletResponse reponse){
		Integer groupOrderId = Integer.parseInt((String)request.getParameter("id"));
		if (groupOrderId==null){return "";}
		
		AirTicketRequest po = new AirTicketRequest();
		AirTicketRequestBO bo = new AirTicketRequestBO(po);
		GroupOrder go = groupOrderService.findOrderById(WebUtils.getCurBizId(request), groupOrderId);
		go.setSupplierName(supplierService.selectBySupplierId(go.getSupplierId()).getNameShort());
		bo.setGroupOrder(go);
		
		StringBuffer sb = new StringBuffer();
		sb.append("<tr style=\"height:80px;\">");
		sb.append("<td>").append(go.getOrderNo()).append("</td>");
		sb.append("<td>").append(go.getDepartureDate()).append("</td>");
		sb.append("<td>").append("【"+go.getProductBrandName()+"】"+go.getProductName()).append("</td>");
		sb.append("<td>").append(go.getSupplierName()).append("</td>");
		sb.append("<td>").append(go.getReceiveMode()).append("</td>");
		sb.append("<td>").append(bo.getGroupGuestNumber()).append("</td></tr>");
		return sb.toString();
	}
	
	@RequestMapping("groupOrderGuest.htm")
	@ResponseBody
	public String showGroupOrderGuest(HttpServletRequest request, HttpServletResponse reponse){
		Integer groupOrderId = Integer.parseInt((String)request.getParameter("id"));
		if (groupOrderId==null){return "";}
		List<GroupOrderGuest> groupGuestList = groupOrderGuestService.selectByOrderId(groupOrderId);
		StringBuffer sb = new StringBuffer();
		for (int i=0; i<groupGuestList.size(); i++){
			GroupOrderGuest guest = groupGuestList.get(i);
			sb.append("<tr style=\"height:30px;\" id=\"trGuest").append(guest.getId()).append("\">");
			sb.append("<td><input type=\"checkbox\" name=\"chkGuest\" value=\"").append(guest.getId()).append("\"></input></td>");
			sb.append("<td>").append(guest.getName()).append("</td>");
			sb.append("<td>").append(guest.getCertificateNum()).append("</td>");
			sb.append("<td>").append(guest.getMobile()).append("</td>");
			sb.append("<td>").append(guest.getRemark()==null?"":guest.getRemark()).append("</td>");
			sb.append("<td><span id='price'></span></td>").append("<td><span id='comment'></span></td></tr>");
		}
		return sb.toString();
	}
	
	@RequestMapping("showResource.htm")
	public String showResource(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Map<String, String> param){
		PageBean<AirTicketResource> pageBean = new PageBean<AirTicketResource>();
		HashMap<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bizId", WebUtils.getCurBizId(request));
		pageBean.setParameter(parameter);
		pageBean = airTicketResourceService.selectResourceListPage(pageBean);

		ArrayList<AirTicketResourceBO> boList = new ArrayList<AirTicketResourceBO>();
		for(int i=0; i<pageBean.getResult().size(); i++){
			boList.add(new AirTicketResourceBO(pageBean.getResult().get(i)));			
		}
		model.addAttribute("page", pageBean);
		model.addAttribute("result", boList);

		return "airticket/request_select_resource";
	}
	
		
	@RequestMapping("showGroupOrder.htm")
	public String showGroupOrder(HttpServletRequest request, ModelMap model){
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>(); 
		Integer bizId = WebUtils.getCurBizId(request);
		//Set<Integer> userSet = WebUtils.getDataUserIdSet(request);
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
		if (page != null){pageBean.setPage(Integer.parseInt(page));}
		if (pageSize != null){pageBean.setPageSize(Integer.parseInt(pageSize));}else {
			pageBean.setPageSize(10);
		}

		HashMap<String, String> param = new HashMap<String, String>();
		param.put("departureDateFrom", (String)request.getParameter("dateFrom"));
		param.put("departureDateTo", (String)request.getParameter("dateTo"));
		param.put("orderNo", (String)request.getParameter("orderNo"));
		param.put("productName", (String)request.getParameter("productName"));
		param.put("receiveMode", (String)request.getParameter("receiveMode"));
		param.put("dataUser", WebUtils.getDataUserIdString(request)); //只取有权限看的订单
		String airApplyState = (String)request.getParameter("airApplyState");
		if (airApplyState!=null && (airApplyState.equals("Y") || airApplyState.equals("N"))){
			param.put("airApplyState", airApplyState);
		}
		pageBean.setParameter(param);
		pageBean = groupOrderService.selectAllOrderByConListPage(pageBean, bizId);
		
		List<GroupOrder> orderList = pageBean.getResult();
		HashMap<Integer, String> groupModes = new HashMap<Integer, String>();
		HashMap<Integer, String> orderSuppliers = new HashMap<Integer, String>();
		HashMap<Integer, String> orderRequestStatus = new HashMap<Integer, String>();
		for (GroupOrder o : orderList) {
			if (o.getSupplierId() != null) {
				if (orderSuppliers.containsKey(o.getSupplierId())){
					o.setSupplierName(orderSuppliers.get(o.getSupplierId()));
				}else {
					SupplierInfo si = supplierService.selectBySupplierId(o.getSupplierId());
					o.setSupplierName(si.getNameShort());
				}
			}
			if (o.getGroupId()==null){
				groupModes.put(o.getId(), "散客订单");
			}else {
				TourGroup tg = tourGroupService.selectByPrimaryKey(o.getGroupId());
				if (tg.getGroupMode()==0){
					groupModes.put(o.getId(), "散客团");
				}else {
					groupModes.put(o.getId(), "团队");
				}
			}
			if (airTicketRequestService.doesOrderhaveRequested(bizId, o.getId())){
				orderRequestStatus.put(o.getId(), "已申请");
			}else{
				orderRequestStatus.put(o.getId(), "未申请");
			}
		}
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("groupModes", groupModes);
		model.addAttribute("orderRequestStatus", orderRequestStatus);

		return "airticket/request_select_group_order";
	}
	
	@RequestMapping(value = "/save.do",method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String save(HttpServletRequest request) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer resourceId = Integer.parseInt((String)request.getParameter("resourceId"));
		String resourceNumber = (String)request.getParameter("resourceNumber");
		Integer groupOrderId = Integer.parseInt((String)request.getParameter("groupOrderId"));
		List<AirTicketOrder> orderList = JSON.parseArray((String)request.getParameter("jsonOrders"), AirTicketOrder.class);
		
		Integer bizId = WebUtils.getCurBizId(request);
		Integer curUserId = WebUtils.getCurUserId(request);
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		String curUserName = curUser.getName();
		
		AirTicketRequest po = new AirTicketRequest();
		if (id!=null){po.setId(id);}
		po.setBizId(bizId);
		po.setGroupOrderId(groupOrderId);
		po.setResourceId(resourceId);
		po.setResourceNumber(resourceNumber);
		po.setGuestNumber(orderList.size());
		if (id==null){
			po.setCreaterId(curUserId);
			po.setCreaterName(curUserName);
		}else {
			po.setOperatorId(curUserId);
			po.setOperatorName(curUserName);
		}
		GroupOrder groupOrder = groupOrderService.findOrderById(bizId, groupOrderId);
		if (groupOrder==null || groupOrder.getState()==-1){
			throw new ClientException("订单已被删除。");
		}
		if (!airTicketRequestService.checkAvailable(bizId, resourceId, id, orderList.size())){
			throw new ClientException("申请票数不能超过可用票数");
		}
		Integer resourceIdBefore = null; // 为了refresh变更前的resource的applied_number;
		if (id==null){
			po.setStatus("ARRANGING");
			Integer newId = airTicketRequestService.saveRequest(po);
			po.setId(newId);
		}else {
			resourceIdBefore = airTicketRequestService.findRequest(id, bizId).getResourceId();
			po.setStatus("ARRANGING");
			airTicketRequestService.updateRequest(po);
		}
		
		for(int i=0; i<orderList.size(); i++){
			orderList.get(i).setBizId(bizId);
			orderList.get(i).setRequestId(po.getId());
			orderList.get(i).setResourceId(resourceId);
		}
		airTicketOrderService.deleteRequestOrder(po.getId(), bizId);
		airTicketOrderService.saveOrderList(orderList);
		if (resourceIdBefore!=null && resourceIdBefore!=po.getResourceId()){
			airTicketResourceService.refreshAppliedNumber(resourceIdBefore);
		}
		airTicketResourceService.refreshAppliedNumber(po.getResourceId());
		return null;
	}
	
	private void refreshAppliedNumber(Integer requestId, Integer bizId){
		Integer resourceId = airTicketRequestService.findRequest(requestId, bizId).getResourceId();
		airTicketResourceService.refreshAppliedNumber(resourceId);
	}
	@RequestMapping(value = "/arrange.do")
	@ResponseBody
	@PostHandler
	public String arrange(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer opId = WebUtils.getCurUserId(request);
		String opName = WebUtils.getCurUser(request).getName();
		Integer bizId = WebUtils.getCurBizId(request);
		airTicketRequestService.setStatus(id, bizId, "CONFIRMING", opId, opName, comment);
		this.refreshAppliedNumber(id, bizId);
		return null;
	}

	@RequestMapping(value = "/reject.do")
	@ResponseBody
	@PostHandler
	public String reject(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer opId = WebUtils.getCurUserId(request);
		String opName = WebUtils.getCurUser(request).getName();
		Integer bizId = WebUtils.getCurBizId(request);
		AirTicketRequest po = airTicketRequestService.findRequest(id, bizId);
		BookingSupplier booking = bookingSupplierService.selectByPrimaryKey(po.getBookingSupplierId());
		if (booking!=null && booking.getStateFinance()>=1){ // 如果订单已审核，则禁止撤回。
			throw new ClientException("订单已被财务审核，退回需要先取消审核。");
		}
		if (po.getBookingSupplierId()!=null ){
			BookingSupplier bs = bookingSupplierService.selectByPrimaryKey(po.getBookingSupplierId());
			if (bs!=null){
				bookingSupplierService.deleteSupplierWithFinanceByPrimaryKey(po.getBookingSupplierId(), false);
			}
			airTicketRequestService.updateBookingSupplierId(id, bizId, null);
		}
		airTicketRequestService.setStatus(id, bizId, "REJECTED", opId, opName, comment);
		
		List<GroupOrderTransport> existingTransport = groupOrderTransportService.selectByOrderId(po.getGroupOrderId());
		for (GroupOrderTransport e : existingTransport){
			if (e.getMethod()!=null && e.getMethod().equals(this.getPickUpMethodAir(request))){
				groupOrderTransportService.deleteByPrimaryKey(e.getId());
			}
		}
		this.refreshAppliedNumber(id, bizId);
		return null;
	}

	@RequestMapping(value = "/confirm.do")
	@ResponseBody
	@PostHandler
	public String confirm(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer opId = WebUtils.getCurUserId(request);
		String opName = WebUtils.getCurUser(request).getName();
		Integer bizId = WebUtils.getCurBizId(request);
		airTicketRequestService.setStatus(id, bizId, "ISSUING", opId, opName, comment);
		this.refreshAppliedNumber(id, bizId);
		return null;
	}
	
	@RequestMapping(value = "/issue.do")
	@ResponseBody
	@PostHandler
	public String issue(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer opId = WebUtils.getCurUserId(request);
		String opName = WebUtils.getCurUser(request).getName();
		Integer bizId = WebUtils.getCurBizId(request);
		airTicketRequestService.setStatus(id, bizId, "ISSUED", opId, opName, comment);
		this.saveBookingSupplier(id, request);
		this.refreshAppliedNumber(id, bizId);
		return null;
	}
	
	@RequestMapping(value = "/delete.do")
	@ResponseBody
	@PostHandler
	public String delete(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer bizId = WebUtils.getCurBizId(request);
		Integer resourceId = airTicketRequestService.findRequest(id, bizId).getResourceId();
		airTicketRequestService.deleteRequest(id, bizId,
				WebUtils.getCurUserId(request),WebUtils.getCurUser(request).getName(), comment);
		airTicketOrderService.deleteRequestOrder(id, bizId);
		airTicketResourceService.refreshAppliedNumber(resourceId);
		return null;
	}

	@RequestMapping(value = "/changePrice.do")
	@ResponseBody
	@PostHandler
	public void changePrice(HttpServletRequest request, Integer orderId, BigDecimal price){
		AirTicketOrder o = new AirTicketOrder();
		o.setId(orderId);
		o.setPrice(price);
		airTicketOrderService.updateOrder(o);
	}
	
	@RequestMapping(value = "/changePrices.do")
	@ResponseBody
	@PostHandler
	public void changePrices(HttpServletRequest request, String orderIds, BigDecimal price){
		orderIds = StringUtils.trim(orderIds);
		String[] ids = StringUtils.split(orderIds, ',');
		for (String id: ids){
			try {
				AirTicketOrder o = new AirTicketOrder();
				o.setId(Integer.parseInt(id));
				o.setPrice(price);
				airTicketOrderService.updateOrder(o);
			}catch(NumberFormatException e){
				log.error("wrong orderIds: " + orderIds);
			}
		}
	}
	
	@RequestMapping(value = "/savePickUp.do")
	@ResponseBody
	@PostHandler
	public void savePickUp(HttpServletRequest request){
		Integer orderId = Integer.parseInt(request.getParameter("orderId"));
		Integer resourceId = Integer.parseInt(request.getParameter("resourceId"));
		String jsonString = request.getParameter("data");
		List<GroupOrderTransport> list = JSON.parseArray(jsonString, GroupOrderTransport.class);
		Integer methodAir = this.getPickUpMethodAir(request); // 交通方式：飞机 
		// 先删除已存的接送飞机信息
		//TODO 一个订单可能会有多次资源申请
		List<GroupOrderTransport> existingTransport = groupOrderTransportService.selectByOrderId(orderId);
		List<AirTicketLeg> legList = airTicketResourceService.findLegsByResourceId(resourceId);
		for (GroupOrderTransport e : existingTransport){
			if (e.getMethod()!=null && e.getMethod().equals(methodAir) && isTransportInLeg(e, legList)){
				groupOrderTransportService.deleteByPrimaryKey(e.getId());
			}
		}
		// 添加新的接送飞机信息
		for (GroupOrderTransport t: list){
			t.setOrderId(orderId);
			t.setMethod(methodAir);
			groupOrderTransportService.insertSelective(t);
		}
		return ;
	}
	public boolean isTransportInLeg(GroupOrderTransport e, List<AirTicketLeg> legList){ // 判断接送机信息是否在机票资源的航班中，在的话先删除再添加
		for (AirTicketLeg leg: legList){
			if (e.getDepartureDate()!=null && e.getClassNo()!=null && 
					e.getDepartureDate().equals(leg.getDepDate()) && e.getClassNo().trim().equals(leg.getAirCode())){
				return true;
			}
		}
		return false;
	}
	
	private int getPickUpMethodAir(HttpServletRequest request){
		int bizId = WebUtils.getCurBizId(request);
		Integer methodAir = 154; // 交通方式：飞机 
		List<DicInfo> transportTypeList = dicService.getListByTypeCode(BasicConstants.GYXX_JTFS,bizId);
		for (DicInfo d: transportTypeList){
			if (d.getValue().toString().equals("飞机")){methodAir=d.getId(); break;}
		}
		return methodAir;
	}
	
	@RequestMapping(value = "/changeGuestComment.do")
	@ResponseBody
	@PostHandler
	public void changeGuestComment(HttpServletRequest request, Integer orderId, String comment){
		AirTicketOrder o = new AirTicketOrder();
		o.setId(orderId);
		o.setComment(comment);
		airTicketOrderService.updateOrder(o);
	}
	
	public Map<Integer, String> getTicketSuppliers(Integer bizId){
		if (this.ticketSuppliers != null){
			return this.ticketSuppliers;
		}
		this.ticketSuppliers=new HashMap<Integer, String>();
		SupplierInfo supplierInfo = new SupplierInfo();
		supplierInfo.setSupplierType(Constants.AIRTICKETAGENT);
		PageBean<SupplierInfo> pageBean = new PageBean<SupplierInfo>();
		pageBean.setPageSize(1000);
		pageBean.setParameter(supplierInfo);
		pageBean.setPage(1);
		pageBean = supplierService.selectAllSupplierListPage(pageBean, bizId);
		for (int i=0; i<pageBean.getResult().size(); i++){
			SupplierInfo s = pageBean.getResult().get(i);
			this.ticketSuppliers.put(s.getId(), s.getNameFull());
		}
		return this.ticketSuppliers;
	}

	private void updateBookingSupplier(Integer requestId, HttpServletRequest request){
		
	}
	
	private String saveBookingSupplier(Integer requestId, HttpServletRequest request){
		Integer bizId = WebUtils.getCurBizId(request);
		Integer operatorId = WebUtils.getCurUserId(request);
		String operatorName = WebUtils.getCurUser(request).getName();
		AirTicketRequest po = airTicketRequestService.findRequest(requestId, bizId);
		AirTicketResource resource = airTicketResourceService.findResource(po.getResourceId(), bizId);
		List<AirTicketLeg> legList = airTicketResourceService.findLegsByResourceId(po.getResourceId());
		GroupOrder go = groupOrderService.findById(po.getGroupOrderId());

		BookingSupplier bs = new BookingSupplier();
		bs.setStateBooking(0);
		bs.setStateFinance(0);
		if (resource.getType().equals("TRAIN")){
			bs.setSupplierType(Constants.TRAINTICKETAGENT);
		}else {
			bs.setSupplierType(Constants.AIRTICKETAGENT);
		}
		if(go.getGroupId()!=null){
			bs.setGroupId(go.getTourGroup().getId());
		}
		bs.setOrderId(go.getId());
		bs.setUserId(operatorId);
		bs.setUserName(operatorName);
		bs.setSupplierId(resource.getTicketSupplierId());
		bs.setSupplierName(resource.getTicketSupplier());
		bs.setContact(resource.getContact());
		bs.setContactTel(resource.getContactTel());
		bs.setContactMobile(resource.getContactMobile());
		bs.setContactFax(resource.getContactFax());
		//bs.setCashType(po.getPaymentType());
		bs.setCashType("公司现付"); //2016-5-25 欧宗莹更改，由于　po里该字段永远是null,根据业务要求出票１００%是公司现付
		//bs.setRemark(go.getTourGroup().getRemark());
		
		int count = bookingSupplierService.getBookingCountByTypeAndTime(bs.getSupplierType());
		bs.setBookingNo("YM"+Constants.SUPPLIERSHORTCODEMAP.get(bs.getSupplierType())
				+new SimpleDateFormat("yyMMdd").format(new Date())+(count+100));
		bs.setBookingDate(new Date());
		bs.setCreateTime(new Date().getTime());
		
		ArrayList<BookingSupplierDetail> bsdList = new ArrayList<BookingSupplierDetail>();
		HashMap<BigDecimal, Double> priceMap = new HashMap<BigDecimal, Double>();
		for (AirTicketOrder order : po.getOrderList()){
			BigDecimal price = order.getPrice();
			if (priceMap.containsKey(price)){
				priceMap.put(price, priceMap.get(price)+1.0);
			}else {
				priceMap.put(price, 1.0);
			}
		}
		for (BigDecimal price : priceMap.keySet()){
			BookingSupplierDetail bsd = new BookingSupplierDetail();
			bsd.setType1Name(resource.getSeatType());
			bsd.setTicketDeparture(resource.getDepCity());
			bsd.setTicketArrival(legList.get(legList.size()-1).getArrCity());
			bsd.setItemDate(resource.getDepDate());
			bsd.setTicketFlight(resource.getLineName());
			bsd.setItemPrice(price.doubleValue());
			bsd.setItemNum(priceMap.get(price));
			bsd.setItemNumMinus(0.0);
			bsd.setItemTotal(price.doubleValue() * priceMap.get(price));
			bsdList.add(bsd);
		}
		bs.setDetailList(bsdList);
		
		double priceSum=0.0;
		for (BookingSupplierDetail detail : bsdList) {
			priceSum=priceSum+detail.getItemTotal();
		}
		bs.setTotal(new BigDecimal(priceSum));

		
		int bsId=bookingSupplierService.insert(bs);
		for (BookingSupplierDetail detail : bsdList) {
			detail.setBookingId(bsId);
			bookingSupplierDetailService.insert(detail);
		}
		airTicketRequestService.updateBookingSupplierId(po.getId(), bizId, bsId);
		return null;
	}
	
	
	
	/**
	 * new page for apply
	 */
	@RequestMapping("apply.htm")
	public String showApply(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		return "airticket/request_apply";
	}
	
	@RequestMapping("applyList.do")
	public String showApplyList(HttpServletRequest request, ModelMap model){
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>(); 
		Integer bizId = WebUtils.getCurBizId(request);
		//Set<Integer> userSet = WebUtils.getDataUserIdSet(request);
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
		if (page != null){pageBean.setPage(Integer.parseInt(page));}
		if (pageSize != null){pageBean.setPageSize(Integer.parseInt(pageSize));}else {
			pageBean.setPageSize(15);
		}
		Map param = WebUtils.getQueryParamters(request);
		param.put("dataUser", WebUtils.getDataUserIdString(request)); //只取有权限看的订单
		
		Set<Integer> operatorIdSet = new HashSet<Integer>();
		if (param.get("saleOperatorIds")!=null){
			for (String oId: StringUtils.split((String)param.get("saleOperatorIds"), ',')){
				operatorIdSet.add(Integer.parseInt(oId));
			}
		}
		if (param.get("saleOperatorIds")==null && param.get("orgIds")!=null){
			Set<Integer> orgIdSet = new HashSet<Integer>();
			for (String oId : StringUtils.split((String)param.get("orgIds"), ',')){
				orgIdSet.add(Integer.parseInt(oId));
			}
			operatorIdSet.addAll(platformEmployeeService.getUserIdListByOrgIdList(WebUtils.getCurBizId(request), orgIdSet));
		}
		if (operatorIdSet.size()!=0){
			param.put("saleOperatorIds", StringUtils.join(operatorIdSet, ','));
		}
		
		pageBean.setParameter(param);
		pageBean = groupOrderService.selectAllOrderByConListPage(pageBean, bizId);
		//查询总人数
		Map<String, Object> sumPerson = groupOrderService.selectAllOrderByConTotal(pageBean, bizId);
		List<Integer> orderIdList = new ArrayList<Integer>();
		for (GroupOrder o : pageBean.getResult()){
			orderIdList.add(o.getId());
		}
		Map<Integer, List<AirTicketRequest>> requestMap = airTicketRequestService.findRequestListForGroupOrder(bizId, orderIdList);
		
		HashMap<Integer, String> orderRequestStatus = new HashMap<Integer, String>();
		List<Integer> resourceIdList = new ArrayList<Integer>();
		for (GroupOrder o : pageBean.getResult()){
			if (requestMap.containsKey(o.getId())){
				orderRequestStatus.put(o.getId(), "已申请");
				for(AirTicketRequest q : requestMap.get(o.getId())){
					resourceIdList.add(q.getResourceId());
				}
			}else {
				orderRequestStatus.put(o.getId(), "未申请");
			}
		}
		// get legs by resource IDs
		Map<Integer, List<AirTicketLeg>> legMap = airTicketResourceService.findLegsByResourceIdList(resourceIdList);
		HashMap<Integer, List<AirTicketRequestBO>> boMap = new HashMap<Integer, List<AirTicketRequestBO>>();
		for (Integer orderId: requestMap.keySet()){
			ArrayList<AirTicketRequestBO> l = new ArrayList<AirTicketRequestBO>();
			for (AirTicketRequest q : requestMap.get(orderId)){
				AirTicketRequestBO qBo = new AirTicketRequestBO(q);
				qBo.setArrange(false);
				qBo.getResourceBo().setLegList(legMap.get(qBo.getResourceId()));
				l.add(qBo);
			}
			boMap.put(orderId, l);
		}
		
		/*TourGroup tg = tourGroupService.selectByPrimaryKey(o.getGroupId());
		if (tg.getGroupMode()==0){
			groupModes.put(o.getId(), "散客团");
		}else {
			groupModes.put(o.getId(), "团队");
		}*/

		model.addAttribute("pageBean", pageBean);
		model.addAttribute("sumPerson", sumPerson);
		model.addAttribute("orderRequestStatus", orderRequestStatus);
		model.addAttribute("boMap", boMap);
		return "airticket/request_apply_list";
	}
	
	@RequestMapping("applyEdit.htm")
	public String showApplyEdit(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer orderId) throws IOException{
		Integer bizId = WebUtils.getCurBizId(request);
		GroupOrder order = groupOrderService.findById(orderId);
		model.addAttribute("order", order);
		List<GroupOrderGuest> guestList = groupOrderGuestService.selectByOrderId(order.getId());
		model.addAttribute("guestList", guestList);
		/*List<Integer> orderIdList = new ArrayList<Integer>();
		orderIdList.add(orderId);
		Map<Integer, AirTicketRequest> requestMap = airTicketRequestService.findRequestListForGroupOrder(bizId, orderIdList);
		if (requestMap.size()>0){
			response.sendRedirect(request.getContextPath()+"/airticket/request/view.htm?id="+requestMap.get(orderId).getId().toString());
		}*/
		return "airticket/request_apply_edit";
	}
	
}