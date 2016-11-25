package com.yihg.erp.controller.airticket;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpcenterFacade.common.client.query.DepartmentTuneQueryDTO;
import org.erpcenterFacade.common.client.result.DepartmentTuneQueryResult;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.common.exception.ClientException;
import com.yimayhd.erpcenter.dal.sales.client.airticket.bo.AirTicketResourceBO;
import com.yimayhd.erpcenter.dal.sales.client.operation.po.BookingSupplier;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.ticket.query.ArrangeDTO;
import com.yimayhd.erpcenter.facade.ticket.query.ConfirmDTO;
import com.yimayhd.erpcenter.facade.ticket.query.DeleteDTO;
import com.yimayhd.erpcenter.facade.ticket.query.GetResourceBoDTO;
import com.yimayhd.erpcenter.facade.ticket.query.IssueDTO;
import com.yimayhd.erpcenter.facade.ticket.query.RejectDTO;
import com.yimayhd.erpcenter.facade.ticket.query.SaveBookingSupplierDTO;
import com.yimayhd.erpcenter.facade.ticket.query.SaveDTO;
import com.yimayhd.erpcenter.facade.ticket.query.SavePickUpDTO;
import com.yimayhd.erpcenter.facade.ticket.query.ShowApplyListDTO;
import com.yimayhd.erpcenter.facade.ticket.query.ShowGroupOrderDTO;
import com.yimayhd.erpcenter.facade.ticket.query.ShowListDTO;
import com.yimayhd.erpcenter.facade.ticket.query.ShowResourceDTO;
import com.yimayhd.erpcenter.facade.ticket.result.EditRequestResult;
import com.yimayhd.erpcenter.facade.ticket.result.GetResourceBoResult;
import com.yimayhd.erpcenter.facade.ticket.result.PickUpGuestResult;
import com.yimayhd.erpcenter.facade.ticket.result.ResultSupport;
import com.yimayhd.erpcenter.facade.ticket.result.ShowApplyEditResult;
import com.yimayhd.erpcenter.facade.ticket.result.ShowApplyListResult;
import com.yimayhd.erpcenter.facade.ticket.result.ShowGroupOrderResult;
import com.yimayhd.erpcenter.facade.ticket.result.ShowListResult;
import com.yimayhd.erpcenter.facade.ticket.result.ShowResourceResult;
import com.yimayhd.erpcenter.facade.ticket.result.TicketListResult;
import com.yimayhd.erpcenter.facade.ticket.service.RequestFacade;

@Controller
@RequestMapping("/airticket/request")
public class RequestController extends BaseController {
	private static final Logger log = LoggerFactory.getLogger(ResourceController.class);
	
	@Autowired
	private RequestFacade requestFacade;
	
	@Autowired
	private ProductCommonFacade productCommonFacade;
	
	private Map<Integer, String> ticketSuppliers;
	
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
		String productName="", lineName="", contactName="", orderNo="", endIssueDateFrom="", endIssueDateTo="", saleName = "", type;
		try {
			productName = request.getParameter("productName");
			saleName = request.getParameter("saleName");
			lineName = request.getParameter("lineName");
			contactName = request.getParameter("contactName");
			endIssueDateFrom = request.getParameter("endIssueDateFrom");
			endIssueDateTo = request.getParameter("endIssueDateTo");
			orderNo = request.getParameter("orderNo");
			dateFrom = dateFrom==null?"":dateFrom;
			dateTo = dateTo==null?"":dateTo;
			productName = productName==null?"":productName;
			lineName = lineName==null?"":lineName;
			saleName = saleName==null?"":saleName;
			contactName = contactName==null?"":contactName;
			orderNo = orderNo==null?"":orderNo;
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ShowListDTO dto = new ShowListDTO();
		if(page != null){
			dto.setPage(Integer.parseInt(page));
		}
		if(pageSize != null){
			dto.setPageSize(Integer.parseInt(pageSize));
		}
		
		dto.setArrange(isArrange);
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setContactName(request.getParameter("contactName"));
		if (!isArrange){
			dto.setDataUser(WebUtils.getDataUserIdString(request));
		}
		dto.setDateFrom(dateFrom);
		dto.setDateTo(dateTo);
		dto.setDateType(dateType);
		dto.setDepCity(request.getParameter("depCity"));
		dto.setEndIssueDateFrom(endIssueDateFrom);
		dto.setEndIssueDateTo(endIssueDateTo);
		dto.setIssueStatus(request.getParameter("issueStatus"));
		dto.setLineName(lineName);
		dto.setSaleName(saleName);
		dto.setOrderNo(orderNo);
		
		dto.setProductName(productName);
		dto.setReceiveMode(request.getParameter("receiveMode"));
		dto.setType(request.getParameter("type"));
		
		ShowListResult result = requestFacade.showList(dto);
		
		model.addAttribute("count", result.getCount());
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("resultBo", result.getResultBo());
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
	private AirTicketResourceBO getResoruceBo(HttpServletRequest request, ModelMap model, Integer id) {
		
		GetResourceBoDTO dto = new GetResourceBoDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setId(id);
		GetResourceBoResult result = requestFacade.getResoruceBo(dto);

		model.addAttribute("bo", result.getBo());
		AirTicketResourceBO resourceBo = result.getResourceBo();
		model.addAttribute("resourceBo", resourceBo);
		model.addAttribute("guests", result.getGroupGuestList());

		String confirm = (String)request.getParameter("confirm"); // used for show confirmation page of request.
		model.addAttribute("confirm", confirm);
		return resourceBo;
	}
	
	@RequestMapping("ticketList.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String ticketList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		Integer bizId = WebUtils.getCurBizId(request);
		TicketListResult result = requestFacade.ticketList(bizId, id);
		model.addAttribute("resource", result.getResourceBo());
		model.addAttribute("boList", result.getBoList());
		return "airticket/ticket_list";
	}
	
	@RequestMapping("add.htm")
	public String addRequest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		return "airticket/request_edit";
	}

	@RequestMapping("edit.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String editRequest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		
		EditRequestResult result = requestFacade.editRequest(WebUtils.getCurBizId(request), id);
		model.addAttribute("bo", result.getBo());
		model.addAttribute("resourceBo", result.getResourceBo());
		model.addAttribute("guests", result.getGroupGuestList());
		model.addAttribute("inTicketList", result.getInTicketList());
		return "airticket/request_edit";
	}
	
	/* 添加接送机信息  */
	@RequestMapping(value = "pickUpGuest.htm")
	public String pickUpGuest(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id){
		
		PickUpGuestResult result = requestFacade.pickUpGuest(WebUtils.getCurBizId(request), id);
		model.addAttribute("bo", result.getBo());
		model.addAttribute("resourceBo", result.getResourceBo());
		model.addAttribute("existingTransport", result.getExistingTransport());
		return "airticket/pick_up_guest";
	}

	@RequestMapping("checkBookingSupplier.do")
	@ResponseBody
	public String checkBookingSupplier(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer bookingId){
		BookingSupplier supplier = requestFacade.selectByPrimaryKey(bookingId);
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
		String ret = requestFacade.showResourceInfo(resourceId, WebUtils.getCurBizId(request));
		return ret;
	}
	
	@RequestMapping("groupOrderInfo.htm")
	@ResponseBody
	public String showGroupOrderInfo(HttpServletRequest request, HttpServletResponse reponse){
		
		Integer groupOrderId = Integer.parseInt((String)request.getParameter("id"));
		String ret = requestFacade.showGroupOrderInfo(groupOrderId, WebUtils.getCurBizId(request));
		return ret;
	}
	
	@RequestMapping("groupOrderGuest.htm")
	@ResponseBody
	public String showGroupOrderGuest(HttpServletRequest request, HttpServletResponse reponse){
		Integer groupOrderId = Integer.parseInt((String)request.getParameter("id"));
		String ret = requestFacade.showGroupOrderGuest(groupOrderId);
		return ret;
	}
	
	@RequestMapping("showResource.htm")
	public String showResource(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Map<String, String> param){
		
		ShowResourceDTO dto = new ShowResourceDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setParam(param);
		ShowResourceResult result = requestFacade.showResource(dto);
		model.addAttribute("page", result.getPageBean());
		model.addAttribute("result", result.getBoList());

		return "airticket/request_select_resource";
	}
	
		
	@RequestMapping("showGroupOrder.htm")
	public String showGroupOrder(HttpServletRequest request, ModelMap model){
		
		ShowGroupOrderDTO dto = new ShowGroupOrderDTO();
		dto.setAirApplyState((String)request.getParameter("airApplyState"));
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setDataUser(WebUtils.getDataUserIdString(request));
		dto.setDepartureDateFrom((String)request.getParameter("dateFrom"));
		dto.setDepartureDateTo((String)request.getParameter("dateTo"));
		dto.setOrderNo((String)request.getParameter("orderNo"));
		dto.setProductName((String)request.getParameter("productName"));
		dto.setReceiveMode((String)request.getParameter("receiveMode"));
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
		if (page != null){
			dto.setPage(Integer.parseInt(page));
		}
		if (pageSize != null){
			dto.setPageSize(Integer.parseInt(pageSize));
		}
		
		ShowGroupOrderResult result = requestFacade.showGroupOrder(dto);
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("groupModes", result.getGroupModes());
		model.addAttribute("orderRequestStatus", result.getOrderRequestStatus());

		return "airticket/request_select_group_order";
	}
	
	@RequestMapping(value = "/save.do",method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String save(HttpServletRequest request) {
		
		
		Integer curUserId = WebUtils.getCurUserId(request);
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		String curUserName = curUser.getName();
		Integer bizId = WebUtils.getCurBizId(request);
		
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer resourceId = Integer.parseInt((String)request.getParameter("resourceId"));
		String resourceNumber = (String)request.getParameter("resourceNumber");
		Integer groupOrderId = Integer.parseInt((String)request.getParameter("groupOrderId"));
		
		SaveDTO dto = new SaveDTO();
		dto.setBizId(bizId);
		dto.setCurUserId(curUserId);
		dto.setCurUserName(curUser.getName());
		dto.setGroupOrderId(groupOrderId);
		dto.setId(id);
		dto.setJsonOrders((String)request.getParameter("jsonOrders"));
		dto.setResourceId(resourceId);
		dto.setResourceNumber(resourceNumber);
		ResultSupport result = requestFacade.save(dto);
		if(!result.isSuccess()){
			throw new ClientException(result.getResultMsg());
		}
		return null;
	}
	
	@RequestMapping(value = "/arrange.do")
	@ResponseBody
	@PostHandler
	public String arrange(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer opId = WebUtils.getCurUserId(request);
		String opName = WebUtils.getCurUser(request).getName();
		Integer bizId = WebUtils.getCurBizId(request);
		
		ArrangeDTO dto = new ArrangeDTO();
		dto.setRequestId(id);
		dto.setOpId(opId);
		dto.setOpName(opName);
		dto.setBizId(bizId);
		dto.setComment(comment);
		requestFacade.arrange(dto);
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
		
		RejectDTO dto = new RejectDTO();
		dto.setBizId(bizId);
		dto.setComment(comment);
		dto.setOpId(opId);
		dto.setOpName(opName);
		dto.setRequestId(id);
		requestFacade.reject(dto);
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
		
		ConfirmDTO dto = new ConfirmDTO();
		dto.setBizId(bizId);
		dto.setComment(comment);
		dto.setOpId(opId);
		dto.setOpName(opName);
		dto.setRequestId(id);
		requestFacade.confirm(dto);
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
		
		IssueDTO dto = new IssueDTO();
		dto.setBizId(bizId);
		dto.setOpId(opId);
		dto.setOpName(opName);
		dto.setRequestId(id);
		dto.setComment(comment);
		requestFacade.issue(dto);
		return null;
	}
	
	@RequestMapping(value = "/delete.do")
	@ResponseBody
	@PostHandler
	public String delete(HttpServletRequest request, String comment) {
		Integer id = (String)request.getParameter("id")==null?null:Integer.parseInt((String)request.getParameter("id"));
		Integer bizId = WebUtils.getCurBizId(request);
		
		DeleteDTO dto = new DeleteDTO();
		dto.setBizId(bizId);
		dto.setOpId(WebUtils.getCurUserId(request));
		dto.setOpName(WebUtils.getCurUser(request).getName());
		dto.setRequestId(id);
		dto.setComment(comment);
		requestFacade.delete(dto);
		return null;
	}

	@RequestMapping(value = "/changePrice.do")
	@ResponseBody
	@PostHandler
	public void changePrice(HttpServletRequest request, Integer orderId, BigDecimal price){
		
		requestFacade.changePrice(orderId, price);
	}
	
	@RequestMapping(value = "/changePrices.do")
	@ResponseBody
	@PostHandler
	public void changePrices(HttpServletRequest request, String orderIds, BigDecimal price){
		
		requestFacade.changePrices(orderIds, price);
	}
	
	@RequestMapping(value = "/savePickUp.do")
	@ResponseBody
	@PostHandler
	public void savePickUp(HttpServletRequest request){
		
		SavePickUpDTO dto = new SavePickUpDTO();
		dto.setBizId(WebUtils.getCurBizId(request));
		dto.setJsonString(request.getParameter("data"));
		dto.setOrderId(Integer.parseInt(request.getParameter("orderId")));
		dto.setResourceId(Integer.parseInt(request.getParameter("resourceId")));
		requestFacade.savePickUp(dto);
	}
	
	@RequestMapping(value = "/changeGuestComment.do")
	@ResponseBody
	@PostHandler
	public void changeGuestComment(HttpServletRequest request, Integer orderId, String comment){
		requestFacade.changeGuestComment(orderId, comment);
	}
	
	public Map<Integer, String> getTicketSuppliers(Integer bizId){
		if (this.ticketSuppliers != null){
			return this.ticketSuppliers;
		}
		this.ticketSuppliers = requestFacade.getTicketSuppliers(bizId);
		return this.ticketSuppliers;
	}

	private void updateBookingSupplier(Integer requestId, HttpServletRequest request){
		
	}
	
	private String saveBookingSupplier(Integer requestId, HttpServletRequest request){
		Integer bizId = WebUtils.getCurBizId(request);
		Integer operatorId = WebUtils.getCurUserId(request);
		String operatorName = WebUtils.getCurUser(request).getName();
		
		SaveBookingSupplierDTO dto = new SaveBookingSupplierDTO();
		dto.setBizId(bizId);
		dto.setOperatorId(operatorId);
		dto.setOperatorName(operatorName);
		dto.setRequestId(requestId);
		requestFacade.saveBookingSupplier(dto);
		return null;
	}
	
	
	
	/**
	 * new page for apply
	 */
	@RequestMapping("apply.htm")
	public String showApply(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		DepartmentTuneQueryDTO departmentTuneQueryDTO = new DepartmentTuneQueryDTO();
		departmentTuneQueryDTO.setBizId(bizId);
		DepartmentTuneQueryResult result = productCommonFacade.departmentTuneQuery(departmentTuneQueryDTO);
		model.addAttribute("orgJsonStr", result.getOrgJsonStr());
		model.addAttribute("orgUserJsonStr",result.getOrgUserJsonStr());
		return "airticket/request_apply";
	}
	
	@RequestMapping("applyList.do")
	public String showApplyList(HttpServletRequest request, ModelMap model){
		
		Integer bizId = WebUtils.getCurBizId(request);
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
		
		ShowApplyListDTO dto = new ShowApplyListDTO();
		dto.setBizId(bizId);
		dto.setDataUser(WebUtils.getDataUserIdString(request));
		if (page != null){
			dto.setPage(Integer.parseInt(page));
		}
		if (pageSize != null){
			dto.setPageSize(Integer.parseInt(pageSize));	
		}
		dto.setParam(WebUtils.getQueryParamters(request));
		ShowApplyListResult result = requestFacade.showApplyList(dto);
		
		
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("sumPerson", result.getSumPerson());
		model.addAttribute("orderRequestStatus", result.getOrderRequestStatus());
		model.addAttribute("boMap", result.getBoMap());
		return "airticket/request_apply_list";
	}
	
	@RequestMapping("applyEdit.htm")
	public String showApplyEdit(HttpServletRequest request, HttpServletResponse response, ModelMap model, Integer orderId) throws IOException{
		
		Integer bizId = WebUtils.getCurBizId(request);
		ShowApplyEditResult result = requestFacade.showApplyEdit(bizId, orderId);
		model.addAttribute("order", result.getOrder());
		model.addAttribute("guestList", result.getGuestList());
		return "airticket/request_apply_edit";
	}
	
}