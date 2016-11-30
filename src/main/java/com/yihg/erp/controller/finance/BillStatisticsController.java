
package com.yihg.erp.controller.finance;

import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.yimayhd.erpcenter.facade.finance.query.InRecordDTO;
import org.yimayhd.erpcenter.facade.finance.result.InRecordResult;
import org.yimayhd.erpcenter.facade.finance.service.BillStatisticsFacade;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;

@Controller
@RequestMapping(value = "/finance")
public class BillStatisticsController extends BaseController {

	@Autowired
	private BillStatisticsFacade billStatisticsFacade;
	
	/**
	 * 跳转到收款明细页面
	 * @throws ParseException 
	 */
	@RequestMapping(value = "billStatistics.htm")
	public String inrecord(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) throws ParseException {
		
		Integer bizId = WebUtils.getCurBizId(request);
		
		InRecordDTO dto = new InRecordDTO();
		dto.setBillState(request.getParameter("billState"));
		dto.setBillSupplier(request.getParameter("billSupplier"));
		dto.setBillType(request.getParameter("billType"));
		dto.setBizId(bizId);
		dto.setDepDateFrom(request.getParameter("depDateFrom"));
		dto.setDepDateTo(request.getParameter("depDateTo"));
		dto.setGroupCode(request.getParameter("groupCode"));
		dto.setGuideName(request.getParameter("guideName"));
		if(request.getParameter("p") != null){
			dto.setPage(Integer.parseInt(request.getParameter("p")));
		}
		if(request.getParameter("ps") != null){
			dto.setPageSize(Integer.parseInt(request.getParameter("ps")));
		}
		dto.setProductName(request.getParameter("productName"));
		dto.setSet(WebUtils.getDataUserIdSet(request));
		InRecordResult result = billStatisticsFacade.inrecord(dto);
		model.addAttribute("pageBean", result.getPageBean());
		model.addAttribute("billTypeList", result.getBillTypeList());
		model.addAttribute("pageTotal", result.getPageTotal());
		model.addAttribute("total", result.getTotal());
		model.addAttribute("pageBean",result.getPageBean());
		return "finance/bill/billStatistics";
	}
	
}
