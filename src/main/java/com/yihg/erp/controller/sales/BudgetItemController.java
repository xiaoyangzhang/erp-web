package com.yihg.erp.controller.sales;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.sales.api.GroupOrderPriceService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.po.TourGroup;

@Controller
@RequestMapping(value = "/budgetItem")
public class BudgetItemController extends BaseController {

	private static final Logger logger = LoggerFactory
			.getLogger(BudgetItemController.class);

	@Autowired
	private GroupOrderService groupOrderService;

	@Autowired
	private GroupOrderPriceService groupOrderPriceService;
	@Autowired
	private TourGroupService tourGroupService;

	@Autowired
	private DicService dicService;

	/**
	 *收入价格保存
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveBudgetItem", method = RequestMethod.POST)
	@ResponseBody
	public String saveBudgetItem(HttpServletRequest request,
			GroupOrderPrice groupOrderPrice, Model model) {
		groupOrderPrice.setMode(0);
		groupOrderPrice.setRowState(1);
		groupOrderPrice.setCreatorId(WebUtils.getCurUserId(request));
		groupOrderPrice.setCreatorName(WebUtils.getCurUser(request).getName());
		groupOrderPrice.setCreateTime(new Date().getTime());
		groupOrderPriceService.insertSelective(groupOrderPrice);
		logger.info("添加价格预算成功");
		return successJson();
	}

	/**
	 * 跳转到修改收入价格页面
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "editBudgetItem.do")
	@ResponseBody
	public String editBudgetItem(Integer id, Model model) {
		GroupOrderPrice groupOrderPrice = groupOrderPriceService
				.selectByPrimaryKey(id);
		Gson gson = new Gson();
		String string = gson.toJson(groupOrderPrice);
		logger.info("跳转修改价格预算页面");
		return string;
	}

	/**
	 * 修改收入价格
	 * @param groupOrderPrice
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateBudgetItem", method = RequestMethod.POST)
	@ResponseBody
	public String updateBudgetItem(GroupOrderPrice groupOrderPrice, Model model) {
		groupOrderPrice.setMode(0);
		groupOrderPriceService.updateByPrimaryKeySelective(groupOrderPrice);
		logger.info("修改价格预算成功");
		return successJson();
	}

	@RequestMapping(value = "/deleteBudgetItemById", method = RequestMethod.GET)
	@ResponseBody
	public String deleteBudgetItemById(Integer id, Model model) {
		groupOrderPriceService.deleteByPrimaryKey(id);
		logger.info("删除价格预算成功");
		return successJson();
	}
	
	/**
	 * 查询订单下是否有成本价格
	 * @param request
	 * @param reponse
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value="getTotalBudgetByOrderId.do")
	@ResponseBody
	public String getTotalBudgetByOrderId(HttpServletRequest request,
			HttpServletResponse reponse, Integer orderId){
		
		Boolean flag = groupOrderPriceService.selectByOrderAndType(orderId) ;
		if(flag){
			return successJson() ;
		}else{
			return errorJson("该团的成本价格没有维护！") ;
		}
	}
}
