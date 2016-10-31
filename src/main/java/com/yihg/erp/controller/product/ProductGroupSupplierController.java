package com.yihg.erp.controller.product;

import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.controller.BaseController;
import com.yihg.product.api.ProductGroupSupplierService;
import com.yihg.product.po.ProductGroupSupplier;
import com.yimayhd.erpcenter.facade.service.ProductPricePlusFacade;
/**
 * @author : xuzejun
 * @date : 2015年7月1日 下午3:06:44
 * @Description: 价格设置
 */
@Controller
@RequestMapping(value = "/productInfo/price")
public class ProductGroupSupplierController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(ProductGroupSupplierController.class);

	@Autowired
	private ProductPricePlusFacade productPricePlusFacade;
	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至价格设置页面
	 */
	@RequestMapping(value = "/supplier_list.htm")
	public String toList(ModelMap model,Integer groupId,Integer productId) {
		
		model.addAttribute("productId", productId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupSuppliers", groupSupplierService.selectProductGroupSuppliers(groupId));
		return "product/supplier/supplier_list";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月2日 下午3:24:28
	 * @Description: 保存
	 */
	@RequestMapping(value = "/supplier_save.do",method = RequestMethod.POST)
	@ResponseBody
	public String save(String data) {
		List<ProductGroupSupplier> saveP = JSONArray.parseArray(data, ProductGroupSupplier.class);
		//查询
		
		List<ProductGroupSupplier> selectP = groupSupplierService.selectProductGroupSuppliers(saveP.get(0).getGroupId());
		for (int i = 0; i < selectP.size(); i++) {
			for (int j = 0; j < saveP.size(); j++) {
				if(saveP.get(j).getSupplierId().equals(selectP.get(i).getSupplierId())){
					saveP.remove(j);
				}
			}
		}
		if(saveP.size()==0){
			return successJson();
		}
		return groupSupplierService.save(saveP) ==1?successJson():errorJson("操作失败！");
		
	}
	
	@RequestMapping(value = "/delSupplier.do",method = RequestMethod.POST)
	@ResponseBody
	public String delSupplier(ProductGroupSupplier groupSupplier) {
		return groupSupplierService.update(groupSupplier)==1?successJson():errorJson("操作失败！");

	}
	
	
	
}
