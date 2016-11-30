package com.yihg.erp.controller.taobao;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.product.po.TaobaoProduct;
import com.yimayhd.erpcenter.dal.product.po.TaobaoStock;
import com.yimayhd.erpcenter.dal.product.po.TaobaoStockDate;
import com.yimayhd.erpcenter.dal.product.po.TaobaoStockLog;
import com.yimayhd.erpcenter.facade.tj.client.service.TaobaoProductFacade;

@Controller
@RequestMapping("/taobaoProect")
public class TaobaoProductController extends BaseController {
	
	@Autowired
	private TaobaoProductFacade taoBaoProductFacade;
	
	@RequestMapping(value = "/stockLogDetails.do")
	public String stockLogDetails(HttpServletRequest request, Integer stockDateId,String stockDate,
			ModelMap model) {
		List<TaobaoStockLog> list = taoBaoProductFacade.stockLogDetails( stockDateId, stockDate, model );
		model.addAttribute("list", list);
		return "sales/taobaoOrder/stockLogDetails";
	}
	@RequestMapping("kalendarStock.htm")
	public String kalendarStock(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer stockId){
		model.addAttribute("stockId", stockId); 
		return "sales/taobaoOrder/kalendarStock";
	}
	
	@RequestMapping(value="stockMonth.do",method=RequestMethod.POST)
	@ResponseBody
	public String stockMonth(ModelMap model,Integer stockId,Integer year,Integer month){
		
		List<TaobaoStockDate> list = taoBaoProductFacade.stockMonth(stockId, year, month);
		
		return successJson("data",JSON.toJSONString(list));
	}

	@RequestMapping(value="saveStock.do",method=RequestMethod.POST)
	@ResponseBody
	public String saveStock(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer stockId,String stockStr,Integer year,Integer month){
		if(stockId==null){
			return errorJson("产品为空");
		}
		if(StringUtils.isBlank(stockStr)){
			return errorJson("数据为空");
		}
		
		taoBaoProductFacade.saveStock( WebUtils.getCurUser(request).getName(), stockId, stockStr, year, month );
		return successJson();
	}
	
	
	/**
	 * 跳转至淘宝库存列表页面
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toGroupList.htm")
	public String toGroupList(HttpServletRequest request, Model model) {
		return "taoBao/taoBaoStockList";
	}
	
	/**
	 * 显示淘宝库存信息Table
	 * @param request
	 * @param TaobaoStock
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("findTaoBaoStockList.do")
	public String findTaoBaoStockList(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) throws ParseException {
		Map<String,Object> psBean = WebUtils.getQueryParamters(request);
		model.addAttribute("pageBean", 
				taoBaoProductFacade.findTaoBaoStockList(psBean, pageSize, page));	
		return "taoBao/taoBaoStockTable";
		
	}
	
	/**
	 * 修改淘宝库存
	 * @param request
	 * @param TaobaoStock
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("toUpdatetbStockChange.htm")
	public String toUpdatetbStockChange(HttpServletRequest request,
			Integer id,ModelMap model) throws ParseException {
		
		TaobaoStock taobaoStockBean = taoBaoProductFacade.toUpdatetbStockChange( id );
		model.addAttribute("taobaoStockBean", taobaoStockBean);
		return "taoBao/taoBaoModifyStock";
	}
	/**
	 * 保存修改库存信息
	 * @param request
	 * @param id
	 * @param stockName
	 * @param clearDayReset
	 * @param brief
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("toSaveTbStock.do")
	@ResponseBody
	public String toSaveTbStock(HttpServletRequest request, Integer id,String stockName,
			Integer clearDayReset,String brief,ModelMap model) throws ParseException {
		int num = taoBaoProductFacade.toSaveTbStock(id, stockName, clearDayReset, brief, model);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", num);
		return JSON.toJSONString(map);
	}
	
	/**
	 * 关联产品信息
	 * @param request
	 * @param stockId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toStockProductBindingList.do")
	public String toStockProductBindingList(HttpServletRequest request,Integer stockId,ModelMap model){
		List<TaobaoProduct> proInfoList = taoBaoProductFacade.toStockProductBindingList(stockId, model);
		model.addAttribute("proInfoList", proInfoList);
		model.addAttribute("stockId", stockId);
		return "taoBao/taobaoProductBindingList";
	}
	
	/**
	 * 跳转至添加产品页面
	 * @param request
	 * @param stockId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "addTaobaoProduct.htm")
	public String addTaobaoProduct(HttpServletRequest request,Integer stockId,
			ModelMap model){
		//model.addAttribute("stockId", stockId);
		return "taoBao/taoBaoProductList";
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("findTaoBaoProduct.do")
	public String findTaoBaoProduct(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) throws ParseException {
		Map<String,Object> psBean  = WebUtils.getQueryParamters(request);
		model.addAttribute("pageBean", taoBaoProductFacade.findTaoBaoProduct(psBean, pageSize, page));	
		return "taoBao/taoBaoProductTable";
		
	}
	
	@RequestMapping(value = "TaoBaoProductStockDlg.htm")
	public String TaoBaoProductStockDlg(HttpServletRequest request,String stockDate,
			ModelMap model){
		model.addAttribute("stockDate", stockDate);
		return "taoBao/taoBaoProductStockDlg";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("TaoBaoProductStock_Table.do")
	public String TaoBaoProductStock_Table(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) throws ParseException {
		Map<String,Object> psBean  = WebUtils.getQueryParamters(request);
		
		PageBean<TaobaoProduct> pageBean = taoBaoProductFacade.TaoBaoProductStock_Table( psBean, pageSize, page );
		
		model.addAttribute("pageBean", pageBean);	
		return "taoBao/taoBaoProductStockDlgTable";
		
	}
	
	/**
	 * 保存添加的产品信息
	 * @param request
	 * @param stockId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveStockProBinding.do")
	@ResponseBody
	public String saveStockProBinding(HttpServletRequest request,String productId,
			Integer stockId,ModelMap model){
		return JSON.toJSONString(taoBaoProductFacade.saveStockProBinding( productId, stockId, model));
	}
	
	/**
	 * 删除淘宝库存产品关联信息
	 * @param request
	 * @param productId
	 * @param stockId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "deleteTaoBaoStockProduct.do")
	@ResponseBody
	public String deleteTaoBaoStockProduct(HttpServletRequest request,String productId,
			Integer stockId,ModelMap model){
		taoBaoProductFacade.deleteTaoBaoStockProduct(productId, stockId, model);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", 1);
		return JSON.toJSONString(map);
		
	}
	
	/**
	 * 新增淘宝库存信息
	 * @param request
	 * @param TaobaoStock
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("toAddtBStockInfo.htm")
	public String toAddtBStockInfo(HttpServletRequest request,  Model model) throws ParseException {
		return "taoBao/taoBaoAddStock";
	}
	
	/**
	 * 保存
	 * @param request
	 * @param stockName
	 * @param clearDayReset
	 * @param brief
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("saveTaobbaoStock.do")
	@ResponseBody
	public String saveTaobbaoStock(HttpServletRequest request, String stockName, 
			Integer clearDayReset,String brief, Model model) throws ParseException {
		int num = taoBaoProductFacade.saveTaobbaoStock(stockName, clearDayReset, brief, model);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("success", num);
		return JSON.toJSONString(map);
	}
	
	/**
	 * 删除淘宝库存信息
	 * @param request
	 * @param stockId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "deleteTaoBaoStock.do")
	@ResponseBody
	public String deleteTaoBaoStockProduct(HttpServletRequest request,
			Integer id,ModelMap model){
		return JSON.toJSONString(taoBaoProductFacade.deleteTaoBaoStockProduct( id, model));
	}

}
