package com.yihg.erp.controller.sales;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderTransport;
import com.yimayhd.erpcenter.facade.sales.result.SaveSeatInCoachResult;
import com.yimayhd.erpcenter.facade.sales.service.SeatInCoachFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.yihg.erp.controller.BaseController;


@Controller
@RequestMapping(value = "/seatInCoach")
public class SeatInCoachController extends BaseController {
	
	private static final Logger logger = LoggerFactory.getLogger(SeatInCoachController.class);

	@Autowired
	private SeatInCoachFacade seatInCoachFacade ;
	
	@RequestMapping(value = "/saveAndEditSeatInCoach.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveAndEditSeatInCoach(HttpServletRequest request,HttpServletResponse response,ModelMap model,String transport){
		/*Transport trans = JSON.parseObject(transport, Transport.class);
		int i = groupOrderTransportService.saveAndEditSeatInCoach(trans) ;
		if(i==1){
			logger.info("保存或修改接送信息成功成功");
			return successJson() ;
		}else{
			logger.info("保存或修改接送信息成功失败");
			return errorJson("保存失败") ;
		}*/

		 SaveSeatInCoachResult saveSeatInCoachResult = seatInCoachFacade.saveAndEditSeatInCoach(transport);
		if(saveSeatInCoachResult.getC()==1){
			logger.info("保存或修改接送信息成功成功");
			return successJson() ;
		}else{
			logger.info("保存或修改接送信息成功失败");
			return errorJson("保存失败") ;
		}
	}
	
	@RequestMapping(value = "/saveSeatInCoach", method = RequestMethod.POST)
	@ResponseBody
	public String saveSeatInCoach(GroupOrderTransport groupOrderTransport,Model model){
		//groupOrderTransport.setOrderId(24);
		/*groupOrderTransportService.insertSelective(groupOrderTransport) ;
		logger.info("添加接送信息成功成功");
		return successJson() ;*/
		SaveSeatInCoachResult saveSeatInCoachResult = seatInCoachFacade.saveSeatInCoach(groupOrderTransport);
		logger.info("添加接送信息成功成功");
		return successJson() ;
		
	}
	
	/**
	 * 修改接送信息回显数据
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "editSeatInCoach.do", method = RequestMethod.GET)
	@ResponseBody
	public String editSeatInCoach(Integer id,Model model){
		/*GroupOrderTransport groupOrderTransport = groupOrderTransportService.selectByPrimaryKey(id) ;
		Gson gson = new Gson();
		String string = gson.toJson(groupOrderTransport);
		logger.info("跳转修改接送信息页面");
		return string ;*/
		SaveSeatInCoachResult saveSeatInCoachResult = seatInCoachFacade.editSeatInCoach(id);
		Gson gson = new Gson();
		String string = gson.toJson(saveSeatInCoachResult.getGroupOrderTransport());
		logger.info("跳转修改接送信息页面");
		return string ;
	}
	
	/**
	 * 
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/updateSeatInCoach", method = RequestMethod.POST)
	@ResponseBody
	public String updateSeatInCoach(GroupOrderTransport groupOrderTransport,Model model){
		/*groupOrderTransportService.updateByPrimaryKeySelective(groupOrderTransport) ;
		logger.info("修改接送信息成功");
		return successJson();*/
		SaveSeatInCoachResult saveSeatInCoachResult = seatInCoachFacade.updateSeatInCoach(groupOrderTransport);
		logger.info("修改接送信息成功");
		return successJson();
	}
	
	/**
	 * 删除接送信息
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/deleteSeatInCoachById", method = RequestMethod.GET)
	@ResponseBody
	public String deleteSeatInCoachById(Integer id,Model model){
		/*groupOrderTransportService.deleteByPrimaryKey(id) ;
		logger.info("删除接送信息成功");
		return successJson() ;*/
		SaveSeatInCoachResult saveSeatInCoachResult = seatInCoachFacade.deleteSeatInCoachById(id);
		logger.info("删除接送信息成功");
		return successJson() ;
	}
	
	@RequestMapping(value="/batchInput.htm", method = RequestMethod.POST)
	@ResponseBody
	public String batchInput(@RequestParam("userArray[]")List<String> userArray){
		/*GroupOrderTransport got = null ;
		for (int i = 0; i < userArray.size(); i++) {
			String dataString = userArray.get(i) ;
			String[] ss = dataString.replace("\\n","").replace(";","").replace("，",",").replace("：",":").split(",") ;
			got = new GroupOrderTransport() ;
			if(ss.length==6){
				got.setDepartureTime(ss[0]);
				got.setArrivalTime(ss[1]);
				got.setClassNo(ss[2]);
				got.setDepartureCity(ss[3]);
				got.setArrivalCity(ss[4]);
				got.setOrderId(Integer.parseInt(ss[5]));
			}
			if(ss.length==4){
				got.setDepartureTime(ss[0]);
				got.setArrivalTime(ss[1]);
				got.setClassNo(ss[2]);
				got.setOrderId(Integer.parseInt(ss[3]));
			}
			groupOrderTransportService.insertSelective(got) ;
		}
		return successJson() */;
		SaveSeatInCoachResult saveSeatInCoachResult = seatInCoachFacade.batchInput(userArray);
		return successJson();
	}
}
