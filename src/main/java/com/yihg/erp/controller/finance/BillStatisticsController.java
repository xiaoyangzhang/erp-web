
package com.yihg.erp.controller.finance;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceBillService;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.supplier.constants.Constants;

@Controller
@RequestMapping(value = "/finance")
public class BillStatisticsController extends BaseController {

	@Autowired
	private FinanceBillService financeBillService;
	private Map<String, String> billStates;
	@Autowired
	private DicService dicService;
	
	public BillStatisticsController(){
		super();
		this.billStates = new HashMap<String, String>();
		billStates.put("APPLIED", "已申请");
		billStates.put("RECEIVED", "已领单");
		billStates.put("VERIFIED", "已销单");

	}
	
	/**
	 * 跳转到收款明细页面
	 * @throws ParseException 
	 */
	@RequestMapping(value = "billStatistics.htm")
	public String inrecord(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) throws ParseException {
		
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> billTypeList = dicService.getListByTypeCode(BasicConstants.LD_DJLX, bizId);
		model.addAttribute("billTypeList", billTypeList);
		
		String page = (String)request.getParameter("p");
		String pageSize = (String)request.getParameter("ps");
		PageBean<Map> pageBean = new PageBean<Map>();
		
		if (pageSize != null){
			pageBean.setPageSize(new Integer(pageSize));
		}else{
			pageBean.setPageSize(Constants.PAGESIZE);
		}
		if (page != null){
			pageBean.setPage(new Integer(page));
		}
		
		HashMap<String, Object> parameter = new HashMap<String, Object>();
		if(null==request.getParameter("depDateFrom")&& null==request.getParameter("depDateTo")){
			Calendar c=Calendar.getInstance();
			int year=c.get(Calendar.YEAR);
			int month=c.get(Calendar.MONTH);
			SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1);
			parameter.put("depDateFrom", c.getTime());
			//group.setStartTime(c.getTime());
			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			parameter.put("depDateTo", c.getTime());
			//group.setEndTime(c.getTime());
			
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (request.getParameter("depDateFrom")!=null){
			parameter.put("depDateFrom", sdf.parse((String)request.getParameter("depDateFrom")));
		}
		if (request.getParameter("depDateTo")!=null){
			parameter.put("depDateTo", sdf.parse((String)request.getParameter("depDateTo")));
		}
		parameter.put("groupCode", request.getParameter("groupCode"));
		parameter.put("billType", request.getParameter("billType"));
		parameter.put("guideName", request.getParameter("guideName"));
		parameter.put("productName", request.getParameter("productName"));
		parameter.put("billState", request.getParameter("billState"));
		parameter.put("billSupplier", request.getParameter("billSupplier"));
		parameter.put("bizId", WebUtils.getCurBizId(request));
		parameter.put("set", WebUtils.getDataUserIdSet(request));
		pageBean.setParameter(parameter);

		pageBean = financeBillService.statisBillList(pageBean);
		
		this.makeShow(pageBean.getResult(), billTypeList);
		model.addAttribute("pageBean", pageBean);
		
		Map<String, Integer> pageTotal=new HashMap<String, Integer>();
		for(Map map: pageBean.getResult()){
			Integer n1 = (pageTotal.get("num")==null)?0:pageTotal.get("num");
			Integer n2 = (pageTotal.get("received_num")==null)?0:pageTotal.get("received_num");
			Integer n3 = (pageTotal.get("returned_num")==null)?0:pageTotal.get("returned_num");
			Integer m1 = (map.get("num")==null)?0:(Integer)map.get("num");
			Integer m2 = (map.get("received_num")==null)?0:(Integer)map.get("received_num");
			Integer m3 = (map.get("returned_num")==null)?0:(Integer)map.get("returned_num");
			pageTotal.put("num", n1+ m1);
			pageTotal.put("received_num", n2 + m2);
			pageTotal.put("returned_num", n3 + m3);
		}
		Map total = financeBillService.statisBillTotal(parameter);
		
		model.addAttribute("pageTotal", pageTotal);
		model.addAttribute("total", total);
		
		return "finance/bill/billStatistics";
	}
	
	private void makeShow(List<Map> result, List<DicInfo> billTypeList){
		for(int i=0; i<result.size(); i++){
			Map map = result.get(i);
			if (map.get("total_adult")==null){
				map.put("total_adult", 0);
			}
			if (map.get("total_child")==null){
				map.put("total_child", 0);
			}
			if (map.get("total_guide")==null){
				map.put("total_guide", 0);
			}
			
			if(billTypeList != null){
				DicInfo info = null;
				for(int j = 0; j < billTypeList.size(); j++){
					info = billTypeList.get(j);
					if(map.get("bill_type").equals(info.getCode())){
						map.put("bill_type", info.getValue());
						break;
					}
				}
			}else{
				map.put("bill_type", "");
			}
			
			map.put("appli_state", billStates.get(map.get("appli_state")));
		}
	}
}
