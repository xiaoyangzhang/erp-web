package com.yihg.erp.controller.airticket;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.yihg.air.api.AirLineService;
import com.yihg.air.api.AirPortService;
import com.yihg.air.po.AirLine;
import com.yihg.airticket.api.AirTicketResourceService;
import com.yihg.airticket.po.AirTicketLeg;
import com.yihg.airticket.po.AirTicketResource;
import com.yihg.basic.exception.ClientException;
import com.yihg.erp.aop.PostHandler;
import com.yihg.erp.bo.airticket.AirTicketResourceBO;
import com.yihg.erp.contant.ExcelOptConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.ExcelReporter;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.po.PlatformEmployeePo;


@Controller
@RequestMapping("/airticket/resource")
public class ResourceController extends BaseController {
	private static final Logger log = LoggerFactory.getLogger(ResourceController.class);
	
	@Autowired
	private AirTicketResourceService airTicketResourceService;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private AirPortService airPortService;
	@Autowired
	private AirLineService airLineService;
	
	private Map<Integer, String> ticketSuppliers;

	private SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
	private SimpleDateFormat sdfTime =new SimpleDateFormat("yyyy-MM-dd HH:mm");

	@RequestMapping("queryList.htm")
	public String queryList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		model.addAttribute("queryOnly", true);
		return this.showList(request, reponse, model);
	}
	
	@RequestMapping("list.htm")
	/*  @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String list(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		//model.addAttribute("queryOnly", false);
		return this.showList(request, reponse, model);
	}
	
	private String showList(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
		String ajax = (String)request.getParameter("ajax");
		String apply = (String)request.getParameter("apply"); // for new air ticket apply page.
		if (model.containsAttribute("queryOnly")){
			model.addAttribute("thisPage", "queryList.htm");
		}else {
			model.addAttribute("thisPage", "list.htm");
		}
		
		
		if (pageSize==null){
			if (ajax!=null && ajax.equals("1")){
				pageSize="10";
			}else {
				pageSize="15";
			}
		}
		
		String depDateFrom="",  depDateTo="", dateType="";
		if (request.getParameter("date_from")==null && request.getParameter("date_to")==null){
			Calendar cal = Calendar.getInstance();
			cal.set( Calendar.DATE, 1 );
			cal.roll(Calendar.DATE, - 1 );
			depDateTo=sdf.format(cal.getTime());
			cal.set(GregorianCalendar.DAY_OF_MONTH, 1);
			depDateFrom=sdf.format(cal.getTime());
			dateType = "start";
		}else {
			depDateFrom = request.getParameter("date_from");
			depDateTo = request.getParameter("date_to");
			dateType = request.getParameter("date_type");
		}
		String resourceNumber="", lineName="", depCity="", endIssueDateFrom="", endIssueDateTo="", type="";
		try {
			resourceNumber = request.getParameter("resource_number");
			endIssueDateFrom = request.getParameter("endIssueDateFrom");
			endIssueDateTo = request.getParameter("endIssueDateTo");
			depCity = request.getParameter("dep_city");
			lineName = request.getParameter("line_name");
			type = request.getParameter("type");
			resourceNumber = resourceNumber==null?"":resourceNumber;
			depDateFrom = depDateFrom==null?"":depDateFrom;
			depDateTo = depDateTo==null?"":depDateTo;
			depCity = depCity==null?"":depCity;
			lineName = lineName==null?"":lineName;
		}catch(Exception e){
			e.printStackTrace();
		}
		
		PageBean<AirTicketResource> pageBean = new PageBean<AirTicketResource>();
		try {
			if (pageSize != null){
				pageBean.setPageSize(new Integer(pageSize));
			}
			if (page != null){
				pageBean.setPage(new Integer(page));
			}
		}catch(Exception e){
			log.error("Wrong format of page size:" + pageSize + " or page:"+page);
		}
		HashMap<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bizId", WebUtils.getCurBizId(request));
		//parameter.put("set", WebUtils.getDataUserIdSet(request));
		if (resourceNumber != ""){parameter.put("resourceNumber", resourceNumber);}
		if (depDateFrom != ""){parameter.put("dateType", dateType); parameter.put("depDateFrom", depDateFrom);}
		if (depDateTo != ""){parameter.put("dateType", dateType); parameter.put("depDateTo", depDateTo);}
		if (depCity != ""){parameter.put("depCity", depCity);}
		if (lineName != ""){parameter.put("lineName", lineName);}
		if (type !=""){parameter.put("type", type);}
		if (endIssueDateFrom!=null){
			parameter.put("endIssueDateFrom", endIssueDateFrom);
			parameter.put("endIssueTimeFrom", endIssueDateFrom+" 00:00");
		}
		if (endIssueDateTo!=null){
			parameter.put("endIssueDateTo", endIssueDateTo);
			parameter.put("endIssueTimeTo", endIssueDateTo +" 24:00");
		}
		
		pageBean.setParameter(parameter);
		HashMap<String, Integer> count = airTicketResourceService.countResourceList(pageBean);
		pageBean = airTicketResourceService.selectResourceListPage(pageBean);

		ArrayList<AirTicketResourceBO> boList = new ArrayList<AirTicketResourceBO>();
		for(int i=0; i<pageBean.getResult().size(); i++){
			AirTicketResourceBO bo = new AirTicketResourceBO(pageBean.getResult().get(i));
			bo.setLegList(airTicketResourceService.findLegsByResourceId(bo.getPo().getId()));
			boList.add(bo);
		}
		model.addAttribute("page", pageBean);
		model.addAttribute("result", boList);
		model.addAttribute("count", count);
		if (ajax!=null && ajax.equals("1")){
			if (apply!=null && apply.equals("1")){
				return "airticket/request_apply_select_resource";
			}else {
				return "airticket/request_select_resource";
			}
		}
		return "airticket/resource_list";
	}
	
	
	@RequestMapping("batchAdd.htm")
	public String batchAdd(HttpServletRequest request, HttpServletResponse reponse, ModelMap model){
		return "airticket/resourceBatchAdd";
	}
	
	
	@RequestMapping("add.htm")
	/*  @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String newResource(HttpServletRequest request, HttpServletResponse reponse, ModelMap model)  {
		//AirTicketResourceBO resourceBo = new AirTicketResourceBO(new AirTicketResource());
		model.addAttribute("templateNames", airTicketResourceService.getLineTemplateNames(WebUtils.getCurBizId(request), ""));
	//	model.addAttribute("resource", resourceBo);
		//model.addAttribute("suppliers", this.getTicketSuppliers(WebUtils.getCurBizId(request)));
		return "airticket/resource_edit";
	}
	
	@RequestMapping("edit.htm")
	/* @RequiresPermissions(PermissionConstants.AIR_TICKET_RESOURCE) */
	public String editResource(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id)  {
		AirTicketResource po = airTicketResourceService.findResource(id, WebUtils.getCurBizId(request));
		AirTicketResourceBO resourceBo = new AirTicketResourceBO(po);
		model.addAttribute("resource", resourceBo);
		model.addAttribute("legList", airTicketResourceService.findLegsByResourceId(po.getId()));
		model.addAttribute("templateNames", airTicketResourceService.getLineTemplateNames(WebUtils.getCurBizId(request), ""));
		//model.addAttribute("suppliers", this.getTicketSuppliers(WebUtils.getCurBizId(request)));
		return "airticket/resource_edit";
	}
	
	@RequestMapping(value = "/save.do",method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String save(HttpServletRequest request, AirTicketResource po, String legList) throws ParseException{
		Integer bizId = WebUtils.getCurBizId(request);
		String endIssueTime = (String)request.getParameter("endIssueTime");
		po.setEndIssueTime(sdfTime.parse(endIssueTime));
		po.setBizId(bizId);
		String saveTemplate = (String)request.getParameter("saveTemplate");
		if (saveTemplate!=null && saveTemplate.equals("save")){
			airTicketResourceService.saveTemplate(bizId, po.getLineName(), legList);
		}
		po.setDepCity(request.getParameter("depCityFirst"));
		po.setDepDate(sdf.parse(request.getParameter("depDateFirst")));
		PlatformEmployeePo userInfo = WebUtils.getCurUser(request);
		if(po.getId() == null || po.getId() == 0){
			po.setCreaterId(userInfo.getEmployeeId());
			po.setCreaterName(userInfo.getName());
			airTicketResourceService.saveResource(po, legList);
		}else{
			po.setOperatorId(userInfo.getEmployeeId());
			po.setOperatorName(userInfo.getName());
			po.setOperatorId(WebUtils.getCurUserId(request));
			airTicketResourceService.updateResource(po, legList);
		}
		return null;
	} 
	
	@RequestMapping(value = "/delete.do",method = RequestMethod.POST)
	@ResponseBody
	@PostHandler
	public String delete(HttpServletRequest request, Integer id) {
		airTicketResourceService.deleteResource(id, WebUtils.getCurBizId(request));
		return null;
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
		pageBean = supplierService.selectPrivateSupplierList(pageBean, bizId);
		for (int i=0; i<pageBean.getResult().size(); i++){
			SupplierInfo s = pageBean.getResult().get(i);
			this.ticketSuppliers.put(s.getId(), s.getNameFull());
		}
		return this.ticketSuppliers;
	}
	/**
	 * 资源edit 机场名字自动补全
	 * @param request
	 * @param reponse
	 * @param cityName
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "fuzzyAirPortList.do" ,method = RequestMethod.GET)
	@ResponseBody
	public String airPortComplete(HttpServletRequest request, HttpServletResponse reponse, String cityName) throws UnsupportedEncodingException{
		//transcoding(cityName, request.getCharacterEncoding());
 		List<Map<String,String>> list = airPortService.getFuzzySearchList(cityName);
		Map<String,Object> map = new HashMap<String,Object>(3);
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}
	/**
	 * 资源list 出发城市自动补全
	 * @param request
	 * @param reponse
	 * @param cityName
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="fuzzyDepCityList.do",method = RequestMethod.GET)
	@ResponseBody
	public String depCityComplete(HttpServletRequest request, HttpServletResponse reponse, String depCity) throws UnsupportedEncodingException{
		//transcoding(depCity, request.getCharacterEncoding());
		List<String> list = airTicketResourceService.getFuzzyDepCityList(depCity);
		Map<String,Object> map = new HashMap<String,Object>(3);
		map.put("success", "true");
		map.put("result", list);
		return JSON.toJSONString(map);
	}
	/**
	 * 如果是ISO-8859-1时，转为UTF-8
	 * @param arg
	 * @throws UnsupportedEncodingException 
	 */
	/*private void transcoding(String arg, String characterEncoding) throws UnsupportedEncodingException{
		String internationalEncoding = "ISO-8859-1";
		String zh_cn = "UTF-8";
		if(characterEncoding.equals(internationalEncoding)){
			arg = StringUtils.isBlank(arg) ? null : new String(arg.getBytes(internationalEncoding),zh_cn);
		}
	}*/ // deleted by Yun 2015/09/16, 实际环境上有URIEncoding="UTF8"的配置，不需做转换
	
	@RequestMapping(value="getLineTemplatenames.do",method = RequestMethod.GET)
	@ResponseBody
	public String getLineTemplateNames(HttpServletRequest request, HttpServletResponse reponse){
		String keyword = request.getParameter("name");
		if (keyword==null){keyword="";}
		List<String> listNames = airTicketResourceService.getLineTemplateNames(WebUtils.getCurBizId(request), keyword);
		StringBuffer sb = new StringBuffer();
		for(String name : listNames){
			sb.append("<option value='").append(name).append("'>").append(name).append("</option>");
		}
		return sb.toString();
	}
	@RequestMapping(value="getLineTemplates.do",method = RequestMethod.GET)
	@ResponseBody
	public String getLineTemplates(HttpServletRequest request, HttpServletResponse reponse, String templateName){
		List<Map> templates = airTicketResourceService.getLineTemplates(WebUtils.getCurBizId(request), templateName);
		return JSON.toJSONString(templates);
	}

	@RequestMapping(value="getAirLine.do",method = RequestMethod.GET)
	@ResponseBody
	public String getAirLine(HttpServletRequest request, HttpServletResponse reponse, String date, String airCode, String depCity, String arrCity) throws IOException{
		SimpleDateFormat sdfLineTime = new SimpleDateFormat("HH:mm");
		HashMap<String, String> json = new HashMap<String, String>();
		try {
			AirLine airLine = airLineService.findAirLine(date, airCode, depCity, arrCity);
			if (airLine.getDepTerminal()==null){
				airLine.setDepTerminal("");
			}
			if (airLine.getArrTerminal()==null){
				airLine.setArrTerminal("");
			}
			StringBuffer sb = new StringBuffer();
			sb.append(airLine.getDepCity()).append(airLine.getDepTerminal()).append(" ").append(sdfTime.format(airLine.getDepTime()));
			sb.append(" ==> ").append(airLine.getArrCity()).append(airLine.getArrTerminal()).append(" ").append(sdfTime.format(airLine.getArrTime()));
			json.put("result", "200");
			json.put("message", sb.toString());
			json.put("depCity", airLine.getDepCity());
			json.put("arrCity", airLine.getArrCity());
			json.put("depTerminal", airLine.getDepTerminal());
			json.put("arrTerminal", airLine.getArrTerminal());
			json.put("depTime", sdfLineTime.format(airLine.getDepTime()));
			json.put("arrTime", sdfLineTime.format(airLine.getArrTime()));
		}catch(ClientException ce){
			json.put("result", "40001");
			json.put("message", "<span style='color:red;'>"+ce.getMessage() +"</span>");
		}catch(Exception e){
			json.put("result", "40001");
			json.put("message", "<span style='color:red;'>"+e.getMessage() +"</span>");
		}
		return JSON.toJSONString(json);
	}
	
	@RequestMapping(value="getLineTemplateList.do",method = RequestMethod.GET)
	@ResponseBody
	public String getLineTemplateList(HttpServletRequest request, HttpServletResponse reponse, String name) throws UnsupportedEncodingException{
		HashMap<String, Object> json = new HashMap<String, Object>();
		if (name==null){name="";}
		name = URLDecoder.decode(name, "UTF-8");
		json.put("result", airTicketResourceService.getLineTemplateNames(WebUtils.getCurBizId(request), name));
		json.put("success", "true");
		return JSON.toJSONString(json);
	}

	@RequestMapping(value="deleteLine.do",method = RequestMethod.GET)
	@ResponseBody
	public String deleteLine(HttpServletRequest request, HttpServletResponse reponse, String lineName){
		HashMap<String, Object> json = new HashMap<String, Object>();
		airTicketResourceService.deleteLineTemplate(WebUtils.getCurBizId(request), lineName);
		json.put("success", "true");
		return JSON.toJSONString(json);
	}
	
//	@RequestMapping(value = "airLineList.do" ,method = RequestMethod.GET)
//	@ResponseBody
//	public String airLineList(HttpServletRequest request, HttpServletResponse reponse, String name) throws UnsupportedEncodingException{
// 		List<Map<String,String>> list = airTicketResourceService.airLineList(WebUtils.getCurBizId(request),java.net.URLDecoder.decode(name,"UTF-8"));
//		Map<String,Object> map = new HashMap<String,Object>();
//		map.put("success", "true");
//		map.put("result", list);
//		return JSON.toJSONString(map);
//	}
	@RequestMapping("saveAirTicketResourceForm")
	@ResponseBody
	public String importExcel(HttpServletRequest request,AirTicketResource resource, MultipartFile file){
		try {
			String path = request.getSession().getServletContext().getRealPath("/") + "/upload/";
			String filename = file.getOriginalFilename();
			File uploadFile=new File(path+filename);
			FileUtils.copyInputStreamToFile(file.getInputStream(), uploadFile);
			List<Map<String, String>> dataMap = ExcelReporter.exportListFromExcel(uploadFile,ExcelOptConstant.AIRRESOURCE);
			HashMap<Integer, AirTicketResource> resources = new HashMap<Integer, AirTicketResource>();
			HashMap<Integer, ArrayList<AirTicketLeg>> legMap = new HashMap<Integer, ArrayList<AirTicketLeg>>();
			Integer bizId = WebUtils.getCurBizId(request);
			Integer operatorId= WebUtils.getCurUserId(request);
			String operatorName = WebUtils.getCurUser(request).getName();

			for (Map<String, String> map : dataMap) {
				Integer index = 0;
				try {
					index = new Double(map.get("index")).intValue();
				}catch (NumberFormatException e){
					e.printStackTrace();
					continue;
				}
				AirTicketLeg l = new AirTicketLeg();
				l.setDepDate(sdf.parse(map.get("legDepDate")));
				ArrayList<String> cities = this.cityMapping(map.get("legName").split("-"));
				l.setDepCity(cities.get(0));
				l.setArrCity(cities.get(1));
				l.setAirCode(map.get("legAirCode"));
				ArrayList<Date> flightTimes = this.parseFlightTime(l.getDepDate(), map.get("legFlightTime"));
				l.setDepTime(flightTimes.get(0));
				l.setArrTime(flightTimes.get(1));
				
				if (!resources.containsKey(index)){
					AirTicketResource r = new AirTicketResource();
					r.setType(resource.getType());
					r.setBizId(bizId);
					r.setCreaterId(operatorId);
					r.setCreaterName(operatorName);
					r.setOperatorId(operatorId);
					r.setOperatorName(operatorName);
					r.setTicketSupplierId(resource.getTicketSupplierId());
					r.setTicketSupplier(resource.getTicketSupplier());
					r.setLineName(map.get("lineName"));
					r.setStartDate(sdf.parse(map.get("startDate")));
					r.setDepCity(l.getDepCity());
					r.setDepDate(l.getDepDate());
					r.setBuyPrice(new BigDecimal(map.get("buyPrice")));
					r.setPrice(new BigDecimal(map.get("price")));
					r.setTotalNumber(new Double(map.get("totalNumber")).intValue());
					r.setTicketOrderNum(map.get("ticketOrderNum"));
					r.setEndIssueTime(sdfTime.parse(map.get("endIssueTime")));
					r.setAdvancedDeposit(new BigDecimal(map.get("advancedDeposit")));
					r.setComment(map.get("comment"));
					resources.put(index, r);
				}
				if (!legMap.containsKey(index)){
					ArrayList<AirTicketLeg> legs = new ArrayList<AirTicketLeg>();
					legs.add(l);
					legMap.put(index, legs);
				}else {
					legMap.get(index).add(l);
				}
			}
			for (Integer i: resources.keySet()){
				airTicketResourceService.saveTemplate(bizId, resources.get(i).getLineName(), legMap.get(i));
				airTicketResourceService.saveResource(resources.get(i), legMap.get(i));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new ClientException(e.getMessage());
		}
		return successJson();
	}
	
	private ArrayList<String> cityMapping(String[] cities){
		ArrayList<String> newCities = new ArrayList<String>();
		for(String c:cities){
			if (c.startsWith("北京T")){newCities.add("北京");
			}else if (c.equals("版纳")){newCities.add("西双版纳");
			}else {newCities.add(c);}
		}
		return newCities;
	}
	/**
	 * 解析 "23:55-01:00"到两个Date 
	 * @throws ParseException 
	 */
	private ArrayList<Date> parseFlightTime(Date depDate, String flightTime) throws ParseException{
		String[] flightTimes = StringUtils.split(flightTime, "-");
		String sDate = sdf.format(depDate);
		Date depTime = sdfTime.parse(sDate + " " + flightTimes[0].trim());
		Date arrTime = sdfTime.parse(sDate + " " + flightTimes[1].trim());
		if (arrTime.before(depTime)){
			Calendar c = new GregorianCalendar();
			c.setTime(arrTime);
			c.add(Calendar.DATE, 1);
			arrTime = c.getTime();
		}
		ArrayList<Date> times = new ArrayList<Date>();
		times.add(depTime);
		times.add(arrTime);
		return times;
	}
	
}