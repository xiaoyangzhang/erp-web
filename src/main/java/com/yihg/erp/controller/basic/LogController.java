package com.yihg.erp.controller.basic;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.yihg.basic.api.LogOperatorService;
import com.yihg.basic.po.LogOperator;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;

@Controller
@RequestMapping("/basic")
public class LogController extends BaseController{
	@Autowired
	private LogOperatorService logService;

	
	@RequestMapping(value="/singleList.htm")
	public String dicEdit(HttpServletRequest request,HttpServletResponse response,ModelMap model,LogOperator log){
		Integer bizId = WebUtils.getCurBizId(request);
		if (null == log.getTableName())
			log.setTableName("无");
		log.setBizId(bizId);
		
		
		List<LogOperator> list = logService.getWhere_NotLogText(log);
		List<Map<String, Object>> logDetail = logService.getWhere_LogDetail(log);
		
		if (logDetail != null && logDetail.size() > 0) {
			for(LogOperator item : list){
				List<String> itemDetail = new ArrayList<String>();
				item.setListDetail(itemDetail);
				
				for (Map<String, Object> det : logDetail) {
					if (item.getBatchId().toString().equals(det.get("batch_id").toString())){
						LogOperator logDet = new LogOperator();
						logDet.setAction(det.get("action").toString());
						logDet.setTableName(det.get("table_name").toString());
						logDet.setTableTitle(det.get("table_title").toString());
						logDet.setLogBrief(det.get("log_brief").toString());
						logDet.setLogText(det.get("log_text").toString());
						itemDetail.add(JSON.toJSONString(logDet));
					}
				}
				
			}
		}
		
		
		model.addAttribute("list", list);
		model.addAttribute("log", log);
		return "/basic/log/singleList";
	}
	

}
