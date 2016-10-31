package com.yihg.erp.controller.sales;

import java.math.BigDecimal;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrice;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.CostIncome;
import com.yimayhd.erpcenter.facade.sales.query.costitem.SaveCostItemDTO;
import com.yimayhd.erpcenter.facade.sales.query.costitem.ToAddProfitChangeDTO;
import com.yimayhd.erpcenter.facade.sales.query.costitem.ToSaveCostIncomeDTO;
import com.yimayhd.erpcenter.facade.sales.result.costitem.CostItemResult;
import com.yimayhd.erpcenter.facade.sales.service.CostItemFacade;

@Controller
@RequestMapping(value = "/costItem")
public class CostItemController extends BaseController {
	
	//private static final Logger logger = LoggerFactory.getLogger(CostItemController.class);
	
	@Autowired
	private CostItemFacade costItemFacade;
	
	@RequestMapping(value="/toSaveCostIncome",method=RequestMethod.POST)
	@ResponseBody
	public String toSaveCostIncome(HttpServletRequest request,HttpServletResponse response,ModelMap model,String price){
//		CostIncome costIncome = JSON.parseObject(price, CostIncome.class);
//		groupOrderPriceService.saveCostIncomeBatch(costIncome,WebUtils.getCurUser(request).getEmployeeId(),WebUtils.getCurUser(request).getName()) ;
//		return successJson();
		
		CostIncome costIncome = JSON.parseObject(price, CostIncome.class);
		Integer    employeeId = WebUtils.getCurUser(request).getEmployeeId();
		String     curUserName = WebUtils.getCurUser(request).getName();
		
		ToSaveCostIncomeDTO toSaveCostIncomeDTO =new ToSaveCostIncomeDTO();
		toSaveCostIncomeDTO.setCostIncome(costIncome);
		toSaveCostIncomeDTO.setCurUserName(curUserName);
		toSaveCostIncomeDTO.setEmployeeId(employeeId);
		
		costItemFacade.toSaveCostIncome(toSaveCostIncomeDTO);
		
		return successJson();
	}
	/**
	 * 保存预算项目
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCostItem", method = RequestMethod.POST)
	@ResponseBody
	public String saveCostItem(HttpServletRequest request,GroupOrderPrice groupOrderPrice,Model model){
		
//		groupOrderPrice.setMode(1); //0是预算，1是成本
//		groupOrderPrice.setRowState(1);
//		groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
//		groupOrderPrice.setCreatorName(WebUtils.getCurUser(request).getName());
//		groupOrderPrice.setCreateTime(new Date().getTime());
//		groupOrderPriceService.insertSelective(groupOrderPrice) ;
		
		groupOrderPrice.setMode(1); //0是预算，1是成本
		groupOrderPrice.setRowState(1);
		groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
		groupOrderPrice.setCreatorName(WebUtils.getCurUser(request).getName());
		groupOrderPrice.setCreateTime(new Date().getTime());
		
		SaveCostItemDTO  saveCostItemDTO=new SaveCostItemDTO();
		saveCostItemDTO.setGroupOrderPrice(groupOrderPrice);
		
		costItemFacade.saveCostItem(saveCostItemDTO);

		return successJson();
	}
	
	/**
	 * 修改预算项目回显数据
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "editCostItem.do", method = RequestMethod.GET)
	@ResponseBody
	public String editCostItem(Integer id,Model model){
		
//		GroupOrderPrice groupOrderPrice = groupOrderPriceService.selectByPrimaryKey(id) ;
//		Gson gson = new Gson();
//		String string = gson.toJson(groupOrderPrice);
//		logger.info("跳转修改价格成本页面");
//		return string ;
		
		CostItemResult result=costItemFacade.editCostItem(id);
		Gson gson = new Gson();
		String string = gson.toJson(result.getGroupOrderPrice());
		return string ;
	}
	
	/**
	 * 
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/updateCostItem", method = RequestMethod.POST)
	@ResponseBody
	public String updateCostItem(GroupOrderPrice groupOrderPrice,Model model){
		
//		groupOrderPrice.setMode(1); //0是预算，1是成本
//		groupOrderPriceService.updateByPrimaryKeySelective(groupOrderPrice) ;
//		logger.info("修改价格成本成功");
//		return successJson();
	
		SaveCostItemDTO  costItemDTO=new SaveCostItemDTO();
		costItemDTO.setGroupOrderPrice(groupOrderPrice);
		costItemFacade.updateCostItem(costItemDTO);
		
		return successJson();
	}
	
	@RequestMapping(value="/deleteCostItemById", method = RequestMethod.GET)
	@ResponseBody
	public String deleteCostItemById(Integer id,Model model){
//		groupOrderPriceService.deleteByPrimaryKey(id) ;
//		logger.info("删除价格成本成功");
		costItemFacade.deleteCostItemById(id);
		return successJson() ;
	}
	
	/**
	 * 预算利润
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toAddProfitChange.do", method = RequestMethod.POST)
	@ResponseBody
	public String toAddProfitChange(BigDecimal price,Integer id,HttpServletRequest request){
		
//		GroupOrderPrice gop = new GroupOrderPrice() ;
//		gop.setOrderId(id);
//		gop.setMode(1);
//		gop.setRowState(1);
//		gop.setPriceLockState(0);
//		gop.setTotalPrice(price.doubleValue());
//		gop.setItemName("其他");
//		gop.setItemId(153);
//		gop.setCreateTime(new Date().getTime());
//		gop.setCreatorId(WebUtils.getCurUserId(request));
//		gop.setCreatorName(WebUtils.getCurUser(request).getName());
//		gop.setUnitPrice(price.doubleValue());
//		gop.setNumTimes(new Double(1));
//		gop.setNumPerson(new Double(1));
//		groupOrderPriceService.insertSelective(gop) ;
		
		ToAddProfitChangeDTO profitChangeDTO=new ToAddProfitChangeDTO();
		
		profitChangeDTO.setId(id);
		profitChangeDTO.setCreatorId(WebUtils.getCurUserId(request));
		profitChangeDTO.setCreatorName(WebUtils.getCurUser(request).getName());
		profitChangeDTO.setPrice(price);
		
		costItemFacade.toAddProfitChange(profitChangeDTO);
		
		return successJson() ;
	}
}
