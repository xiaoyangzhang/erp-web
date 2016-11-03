package com.yihg.erp.controller.product;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yihg.erp.controller.BaseController;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupExtraItem;
import com.yimayhd.erpcenter.facade.service.ProductPricePlusFacade;

/**
 * Created by ZhengZiyu on 2015/7/18.
 */
@Controller
@RequestMapping(value = "/productInfo/price/extra")
public class ProductPriceExtraController extends BaseController{

	@Autowired
	private ProductPricePlusFacade productPricePlusFacade;

    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    @ResponseBody
    public String save(HttpServletRequest request, @RequestParam("groupId") Integer groupId, @RequestParam("data")String extraJson) {
        ProductGroupExtraItem productGroupExtraItem = JSONObject.parseObject(extraJson, ProductGroupExtraItem.class);
        productGroupExtraItem.setGroupId(groupId);
//        productGroupExtraItem = productGroupExtraItemService.save(productGroupExtraItem);
        productGroupExtraItem = productPricePlusFacade.save(productGroupExtraItem);
        return JSONArray.toJSONString(productGroupExtraItem);
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String edit(HttpServletRequest request, @RequestParam("groupId") Integer groupId, @RequestParam("data")String extraJson) {
        ProductGroupExtraItem productGroupExtraItem = JSONObject.parseObject(extraJson, ProductGroupExtraItem.class);
        productGroupExtraItem.setGroupId(groupId);
//        productGroupExtraItem = productGroupExtraItemService.edit(productGroupExtraItem);
        productGroupExtraItem = productPricePlusFacade.edit(productGroupExtraItem);
        return JSONArray.toJSONString(productGroupExtraItem);
    }

    @RequestMapping(value = "/del.do", method = RequestMethod.POST)
    @ResponseBody
    public String del(HttpServletRequest request, @RequestParam("id") Integer id) {
//        boolean success = productGroupExtraItemService.deleteById(id);
        return productPricePlusFacade.deleteById(id) ? successJson() : errorJson("操作失败");
    }

    @RequestMapping(value = "/view.do", method = RequestMethod.POST)
    @ResponseBody
    public String view(HttpServletRequest request, @RequestParam("id") Integer id) {
//        ProductGroupExtraItem productGroupExtraItem = productGroupExtraItemService.findById(id);
        ProductGroupExtraItem productGroupExtraItem = productPricePlusFacade.findById(id);
        return JSONObject.toJSONString(productGroupExtraItem);
    }
}
