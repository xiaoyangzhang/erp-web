package com.yihg.erp.controller.product;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yihg.erp.controller.BaseController;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupExtraItem;

/**
 * Created by ZhengZiyu on 2015/7/18.
 */
@Controller
@RequestMapping(value = "/productInfo/price/extra")
public class ProductPriceExtraController extends BaseController{


    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    @ResponseBody
    public String save(HttpServletRequest request, @RequestParam("groupId") Integer groupId, @RequestParam("data")String extraJson) {
        ProductGroupExtraItem productGroupExtraItem = JSONObject.parseObject(extraJson, ProductGroupExtraItem.class);
        productGroupExtraItem.setGroupId(groupId);
        productGroupExtraItem = productGroupExtraItemService.save(productGroupExtraItem);
        return JSONArray.toJSONString(productGroupExtraItem);
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String edit(HttpServletRequest request, @RequestParam("groupId") Integer groupId, @RequestParam("data")String extraJson) {
        ProductGroupExtraItem productGroupExtraItem = JSONObject.parseObject(extraJson, ProductGroupExtraItem.class);
        productGroupExtraItem.setGroupId(groupId);
        productGroupExtraItem = productGroupExtraItemService.edit(productGroupExtraItem);
        return JSONArray.toJSONString(productGroupExtraItem);
    }

    @RequestMapping(value = "/del.do", method = RequestMethod.POST)
    @ResponseBody
    public String del(HttpServletRequest request, @RequestParam("id") Integer id) {
        boolean success = productGroupExtraItemService.deleteById(id);
        return success ? successJson() : errorJson("操作失败");
    }

    @RequestMapping(value = "/view.do", method = RequestMethod.POST)
    @ResponseBody
    public String view(HttpServletRequest request, @RequestParam("id") Integer id) {
        ProductGroupExtraItem productGroupExtraItem = productGroupExtraItemService.findById(id);
        return JSONObject.toJSONString(productGroupExtraItem);
    }
}
