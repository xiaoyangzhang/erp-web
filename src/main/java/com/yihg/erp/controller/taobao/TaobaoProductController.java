package com.yihg.erp.controller.taobao;

import java.text.ParseException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Date;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestMethod;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.images.util.DateUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.ProductStockService;
import com.yihg.product.api.TaoBaoStockService;
import com.yihg.product.constants.Constants;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.TaobaoProduct;
import com.yihg.product.po.TaobaoStock;
import com.yihg.product.po.TaobaoStockProduct;
import com.yihg.product.vo.TaoBaoProducts;
import com.yihg.product.po.TaobaoStockDate;
import com.yihg.product.po.TaobaoStockLog;

@Controller
@RequestMapping("/taobaoProect")
public class TaobaoProductController extends BaseController {
	
	@Autowired
	private TaoBaoStockService taoBaoStockService;

	@Autowired
	private ProductStockService stockService;

	@RequestMapping(value = "/stockLogDetails.do")
	public String stockLogDetails(HttpServletRequest request, Integer stockDateId,String stockDate,
			ModelMap model) {
	        String startMin=(stockDate+ " 00:00:00") ;
	        String startMax=(stockDate+ " 23:59:59") ;
		List<TaobaoStockLog> list=stockService.selectByStockDateIdAndCreateTime(stockDateId, startMax, startMin);
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
		String beginDateStr = year+"-"+(month<10 ? ("0"+month):(""+month))+"-01";
    	String endDateStr = month==12 ? ((year+1)+"-01-01"):(year+"-"+(month<9 ? ("0"+(month+1)):(""+(month+1)))+"-01");    	
    	Date startDate = DateUtils.parse(beginDateStr, "yyyy-MM-dd");
    	Date endDate = DateUtils.parse(endDateStr,"yyyy-MM-dd");
    	 List<TaobaoStockDate> list=stockService.selectTaobaoStocksByProductIdAndDate(stockId, startDate, endDate);
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
		String beginDateStr = year+"-"+(month<10 ? ("0"+month):(""+month))+"-01";
    	String endDateStr = month==12 ? ((year+1)+"-01-01"):(year+"-"+(month<9 ? ("0"+(month+1)):(""+(month+1)))+"-01");    	
    	Date startDate = DateUtils.parse(beginDateStr, "yyyy-MM-dd");
    	Date endDate = DateUtils.parse(endDateStr,"yyyy-MM-dd");
		// List<ProductStock> stockList = JSON.parseArray(stockStr, ProductStock.class);
		// stockService.saveStock(stockId,stockList,startDate,endDate);
		List<TaobaoStockDate> stockDateList= JSON.parseArray(stockStr, TaobaoStockDate.class);
		if(stockDateList!=null&&stockDateList.size()>0){
		for(TaobaoStockDate item:stockDateList){
			TaobaoStockLog taobaoStockLog=new TaobaoStockLog();
			taobaoStockLog.setCreateUser(WebUtils.getCurUser(request).getName());
			taobaoStockLog.setNum(item.getStockCount());
			taobaoStockLog.setStockId(item.getStockId());
			taobaoStockLog.setTaobaoOrderId(0);
				if(item.getId()==null){
					Integer dateId=stockService.insertTaobaoStockDateSelective(item);
					taobaoStockLog.setStockDateId(dateId);
				}else{
					taobaoStockLog.setStockDateId(item.getId());
				}
		   Integer logId=stockService.insertTaobaoStockLogSelective(taobaoStockLog);
		   stockService.updateByLog(item.getId());   // 计算库存
		}
		}
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
	@RequestMapping("findTaoBaoStockList.do")
	public String findTaoBaoStockList(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) throws ParseException {
		PageBean<TaobaoStock> pageBean = new PageBean<TaobaoStock>();
		Map<String,Object> psBean  = WebUtils.getQueryParamters(request);
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setPage(page);
		pageBean.setParameter(psBean);
		
		pageBean=taoBaoStockService.selectByStockListPage(pageBean);
		model.addAttribute("pageBean", pageBean);	
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
		TaobaoStock taobaoStockBean = taoBaoStockService.selectByPrimaryKey(id);
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
		TaobaoStock tbs = new TaobaoStock();
		tbs.setId(id);
		tbs.setStockName(stockName);
		tbs.setClearDayReset(clearDayReset);
		tbs.setBrief(brief);
		int num = taoBaoStockService.updateByPrimaryKeySelective(tbs);
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
		List<TaobaoStockProduct> stockProList = 
				taoBaoStockService.findStockProductStockId(stockId);
		Set<Integer> proIdSets = new HashSet<Integer>();
		for(TaobaoStockProduct spBean: stockProList){
			proIdSets.add(spBean.getProductId());
		}
		//根据taobao_stock_product中的product_id获取产品名称
		List<TaobaoProduct> proInfoList = null;
		if(proIdSets.size()>0){
			proInfoList = taoBaoStockService.findTaobaoProductById(proIdSets);
		}
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
	
	
	@RequestMapping("findTaoBaoProduct.do")
	public String findTaoBaoProduct(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) throws ParseException {
		PageBean<TaobaoProduct> pageBean = new PageBean<TaobaoProduct>();
		Map<String,Object> psBean  = WebUtils.getQueryParamters(request);
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setPage(page);
		pageBean.setParameter(psBean);
		
		pageBean=taoBaoStockService.findTaoBaoProductListPage(pageBean);
		model.addAttribute("pageBean", pageBean);	
		return "taoBao/taoBaoProductTable";
		
	}
	
	@RequestMapping(value = "TaoBaoProductStockDlg.htm")
	public String TaoBaoProductStockDlg(HttpServletRequest request,String stockDate,
			ModelMap model){
		model.addAttribute("stockDate", stockDate);
		return "taoBao/taoBaoProductStockDlg";
	}
	@RequestMapping("TaoBaoProductStock_Table.do")
	public String TaoBaoProductStock_Table(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) throws ParseException {
		PageBean<TaobaoProduct> pageBean = new PageBean<TaobaoProduct>();
		Map<String,Object> psBean  = WebUtils.getQueryParamters(request);
		if(page==null){
			pageBean.setPage(1);
		}else{
			pageBean.setPage(page);
		}
		if(pageSize==null){
			pageBean.setPageSize(Constants.PAGESIZE);
		}else{
			pageBean.setPageSize(pageSize);
		}
		pageBean.setPage(page);
		pageBean.setParameter(psBean);
		
		pageBean=taoBaoStockService.findTaoBaoProductStockListPage(pageBean);
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
		Map<String,Object> map = new HashMap<String,Object>();
		String[] arrProId= productId.split(",");
		for(int i=0;i<arrProId.length;i++){
			//proIdSets.add(Integer.valueOf(arrProId[i]));
			
			TaobaoStockProduct tbspBean = new TaobaoStockProduct();
			tbspBean.setProductId(Integer.valueOf(arrProId[i]));
			tbspBean.setStockId(stockId);
			//插入淘宝库存产品关联信息
			TaobaoStockProduct taobaoStockProduct = taoBaoStockService.findStockProductInfo(tbspBean);
			if(taobaoStockProduct != null){
				//model.addAttribute("spError", "选择的产品名称已经存在！");
				map.put("error", "spError");
			}else{
				taoBaoStockService.insertTbStockProduct(tbspBean);
				map.put("success", 1);
			}
			
		}
		return JSON.toJSONString(map);
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
		String[] arrProId= productId.split(",");
		for(int i=0;i<arrProId.length;i++){
			TaobaoStockProduct tbspBean = new TaobaoStockProduct();
			tbspBean.setProductId(Integer.valueOf(arrProId[i]));
			tbspBean.setStockId(stockId);
			//删除淘宝库存产品关联信息
			taoBaoStockService.deleteTaoBaoStockProduct(tbspBean);
		}
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
		TaobaoStock tbs = new TaobaoStock();
		tbs.setStockName(stockName);
		tbs.setClearDayReset(clearDayReset);
		tbs.setBrief(brief);
		int num = taoBaoStockService.insertSelective(tbs);
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
		Map<String,Object> map = new HashMap<String,Object>();
		//判断是否存在订单信息
		TaobaoStockLog count = taoBaoStockService.selectLogNumByOrderId(id);
		if(count.getId()!=0){
			map.put("error", "logError");
		}else{
			//删除库存信息
			int num = taoBaoStockService.deleteByPrimaryKey(id);
			
			List<TaobaoStockProduct> tbSPList = taoBaoStockService.findStockProductStockId(id);
			for(TaobaoStockProduct spBean : tbSPList){
				TaobaoStockProduct tbspBean = new TaobaoStockProduct();
				tbspBean.setProductId(spBean.getProductId());
				tbspBean.setStockId(id);
				//删除库存关联信息
				taoBaoStockService.deleteTaoBaoStockProduct(tbspBean);
			}
			map.put("success", num);
		}
		return JSON.toJSONString(map);
	}

}
