package com.yihg.erp.controller.sales;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.facade.sales.result.GuestResult;
import com.yimayhd.erpcenter.facade.sales.service.GuestFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.google.gson.Gson;
import com.yihg.erp.controller.BaseController;


@Controller
@RequestMapping(value = "/guest")
public class GuestController extends BaseController {
	
	private static final Logger logger = LoggerFactory.getLogger(SeatInCoachController.class);
	@Autowired
	private GuestFacade guestFacade ;
	
	/**
	 * 保存客人信息，如果该订单在客人表中的人数大于等于订单中的总人数，不插入
	 * @param groupOrderTransport
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveGuest.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGuest(GroupOrderGuest groupOrderTransport,Model model){
		/*groupOrderGuestService.insertSelective(groupOrderTransport) ;
		logger.info("添加接送信息成功成功");
		return successJson() ;*/
		GuestResult guestResult = guestFacade.saveGuest(groupOrderTransport);
		logger.info("添加接送信息成功成功");
		return successJson() ;
	}
	
	/**
	 * 修改‘客人’信息回显数据
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "editGuest.do", method = RequestMethod.GET)
	@ResponseBody
	public String editGuest(Integer id,Model model){
	/*	GroupOrderGuest groupOrderTransport = groupOrderGuestService.selectByPrimaryKey(id) ;
		Gson gson = new Gson();
		String string = gson.toJson(groupOrderTransport);
		logger.info("跳转修改客人信息页面");
		return string ;*/
		GuestResult  guestResult= guestFacade.editGuest(id) ;
		Gson gson = new Gson();
		String string = gson.toJson(guestResult.getGroupOrderGuest());
		logger.info("跳转修改客人信息页面");
		return string ;
	}
	
	/**
	 * 保存‘客人’修改数据
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/updateGuest", method = RequestMethod.POST)
	@ResponseBody
	public String updateGuest(GroupOrderGuest groupOrderTransport,Model model){
		/*groupOrderGuestService.updateByPrimaryKeySelective(groupOrderTransport) ;
		logger.info("修改客人信息成功");
		return successJson();*/
		GuestResult guestResult= guestFacade.updateGuest(groupOrderTransport);
		logger.info("修改客人信息成功");
		return successJson();
	}
	
	/**
	 * 删除客人信息
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/deleteGuestById", method = RequestMethod.GET)
	@ResponseBody
	public String deleteGuestById(Integer id,Integer orderId,Model model){
		/*groupOrderGuestService.deleteByPrimaryKey(id) ;
		logger.info("删除客人信息成功");
		return successJson() ;*/
		GuestResult guestResult= guestFacade.deleteGuestById(id);
		logger.info("删除客人信息成功");
		return successJson() ;
	}
	
	@RequestMapping(value="/batchInput.htm", method = RequestMethod.POST)
	@ResponseBody
	public String batchInput(@RequestParam("userArray[]")List<String> userArray){
		/*GroupOrderGuest groupOrderGuest = null ;
		//身份证存的是id
		DicInfo dicInfo = dicService.getDicInfoByTypeCodeAndDicCode(BasicConstants.GYXX_ZJLX,BasicConstants.GYXX_ZJLX_SFZ) ;
		for (int i = 0; i < userArray.size(); i++) {
			String dataString = userArray.get(i) ;
			String[] ss = dataString.replace("\\n","").replace(";","").replace("，",",").split(",") ;
			groupOrderGuest = new GroupOrderGuest() ;
			if(ss.length==5){
				groupOrderGuest.setName(ss[0]);
				groupOrderGuest.setCertificateNum(ss[1]);
				groupOrderGuest.setMobile(ss[2]);
				groupOrderGuest.setOrderId(Integer.parseInt(ss[3]));
				groupOrderGuest.setType(Integer.parseInt(ss[4]));
				groupOrderGuest.setIsSingleRoom(0);
				groupOrderGuest.setIsLeader(0);
				groupOrderGuest.setGender(1);
				groupOrderGuest.setCreateTime(new Date().getTime());
			}else if(ss.length==8){
				String s = ss[1] ;
				int gender = 0 ;
				if(s.equals("男")){ 
					gender = 1 ;
				}else{
					gender = 0 ;
				}
				groupOrderGuest.setName(ss[0]);
				groupOrderGuest.setGender(gender);
				groupOrderGuest.setAge(Integer.parseInt(ss[2]));
				groupOrderGuest.setNativePlace(ss[3]);
				groupOrderGuest.setCertificateTypeId(dicInfo.getId());
				groupOrderGuest.setCertificateNum(ss[4]);
				groupOrderGuest.setMobile(ss[5]);
				groupOrderGuest.setOrderId(Integer.parseInt(ss[6]));
				groupOrderGuest.setType(Integer.parseInt(ss[7]));
				groupOrderGuest.setIsSingleRoom(0);
				groupOrderGuest.setIsLeader(0);
				groupOrderGuest.setCreateTime(new Date().getTime());
			}
			groupOrderGuestService.insertSelective(groupOrderGuest) ;
		}
		return successJson();*/
		GuestResult guestResult= guestFacade.batchInput(userArray);
		return successJson();
	}
	/**
	 * 
	 * @param orderId 订单id
	 * @param count 插入客人的数量
	 * @return
	 */
	@RequestMapping(value="/matchNum.htm")
	@ResponseBody
	public String matchNum(Integer orderId,Integer count){
		/*GroupOrder groupOrder = groupOrderService.findById(orderId) ;
		Integer num = groupOrder.getNumAdult()+groupOrder.getNumChild()+groupOrder.getNumGuide() ;
		Integer numAdult = groupOrderGuestService.selectNumAdultByOrderID(orderId) ;
		Integer numChild = groupOrderGuestService.selectNumChildByOrderID(orderId) ;
		Integer numGuide = groupOrderGuestService.selectNumGuideByOrderID(orderId) ;
		Integer it = num-(numAdult+numChild+numGuide) ;
		if(it>=count){
			return successJson();
		}else{
			return errorJson("当前定制团可录入客人人数："+it) ;
		}*/

		GuestResult guestResult= guestFacade.matchNum( orderId,  count);
		if(guestResult.getIt()>=count){
			return successJson();
		}else{
			return errorJson("当前定制团可录入客人人数："+guestResult.getIt()) ;
		}
	}
	/**
	 * 
	 * @param orderId 订单id
	 * @return
	 */
	@RequestMapping(value="/matchGuide.htm")
	@ResponseBody
	public String matchNum(Integer orderId){
		/*GroupOrder groupOrder = groupOrderService.findById(orderId) ;
		Integer num = groupOrder.getNumGuide() ;
		Integer numGuide = groupOrderGuestService.selectNumGuideByOrderID(orderId) ;
		Integer it = num-numGuide;
		if(it>=1){
			return successJson();
		}else{
			return errorJson("当前定制团可录入客人全陪人数："+it) ;
		}*/
		GuestResult guestResult= guestFacade.matchNum(orderId);

		if(guestResult.getIt()>=1){
			return successJson();
		}else{
			return errorJson("当前定制团可录入客人全陪人数："+guestResult.getIt()) ;
		}
	}
	
	/**
	 * 查询当前订单下所有客人的身份证信息（用于判断客人录入的时候数据的重复问题）
	 * @param request
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/getCertificateNums.htm")
	@ResponseBody
	public String getCertificateNums(HttpServletRequest request,Integer orderId){
		// 客人列表
	/*	List<GroupOrderGuest> groupOrderGuests = groupOrderGuestService
				.selectByOrderId(orderId);
		StringBuilder sb = new StringBuilder();
		for (GroupOrderGuest guest : groupOrderGuests) {
			sb.append(guest.getCertificateNum()+",") ;
		}
		Map<String,Object> map = new HashMap<String, Object>() ;
		map.put("certificateNums", sb.toString()) ;
		return successJson(map); */

		GuestResult guestResult= guestFacade.getCertificateNums(orderId);
		Map<String,Object> map = new HashMap<String, Object>() ;
		map.put("certificateNums", guestResult.getCertificateNums()) ;
		return successJson(map);
	}
	
	/**
	 * 验证客人是否有参团历史
	 * @param request
	 * @param model
	 * @param guestCertificateNum
	 * @return
	 */
	@RequestMapping(value="/guestCertificateNumValidate.htm")
	@ResponseBody
	public String guestCertificateNumValidate(String guestCertificateNum,Integer orderId){
		/*List<GroupOrderGuest> guests = groupOrderGuestService.getGuestByGuestCertificateNum(guestCertificateNum,orderId) ;
		if(guests.size()>0){
			return errorJson("") ;
		}else{
			return successJson() ;
		}*/
		GuestResult guestResult= guestFacade.guestCertificateNumValidate( guestCertificateNum,  orderId);
		if(guestResult.getGroupOrderGuestList().size()>0){
			return errorJson("") ;
		}else{
			return successJson() ;
		}
	}
	/**
	 * 获取参团信息
	 * @param request
	 * @param model
	 * @param guestCertificateNum
	 * @return
	 */
	@RequestMapping(value="/getGuestOrderInfo.htm")
	public String getGuestOrderInfo(HttpServletRequest request, Model model, String guestCertificateNum,Integer orderId){
		/*List<GroupOrder> orders = new ArrayList<GroupOrder>() ;
		List<GroupOrderGuest> guests = groupOrderGuestService.getGuestByGuestCertificateNum(guestCertificateNum,orderId) ;
		for (GroupOrderGuest guest : guests) {
			orders.add(groupOrderService.selectByPrimaryKey(guest.getOrderId())) ;
		}
		model.addAttribute("orders", orders) ;
		return "sales/tourGroup/guest/guestOrderInfo" ;*/

		GuestResult guestResult= guestFacade.getGuestOrderInfo(guestCertificateNum,orderId);
		model.addAttribute("orders", guestResult.getGroupOrderList()) ;
		return "sales/tourGroup/guest/guestOrderInfo" ;
	}
}
