package com.yihg.erp.controller.product;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.product.api.ProductRemarkService;
import com.yihg.product.api.ProductRouteService;
import com.yihg.product.api.ProductRouteSupplierService;
import com.yihg.product.api.ProductRouteTrafficService;
import com.yihg.product.po.ProductRemark;
import com.yihg.product.po.ProductRoute;
import com.yihg.product.po.ProductRouteSupplier;
import com.yihg.product.po.ProductRouteTraffic;
import com.yihg.product.vo.ProductRouteDayVo;
import com.yihg.product.vo.ProductRouteVo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ZhengZiyu on 2015/7/7.
 */
@Controller
@RequestMapping("/productInfo/route")
public class ProductRouteController extends BaseController{

    @Autowired
    private ProductRouteService productRouteService;
    @Autowired
    private ProductRemarkService remarkService;
    @Autowired
    private SysConfig config;


    @RequestMapping(value = "/view.htm", method = RequestMethod.GET)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    public String viewRoute(Model model, @RequestParam("productId") String productId) {
        List<ProductRoute> list = productRouteService.findProductRouteByProductId(Integer.valueOf(productId));
        if(list.size() > 0){
            model.addAttribute("config", config);
            model.addAttribute("productId", productId);
            ProductRemark productRemark = remarkService.findProductRemarkByProductId(Integer.valueOf(productId));
            model.addAttribute("productRemark", productRemark);
            return "product/route/product_route_edit";
        }else{
            model.addAttribute("productId", productId);
            return "product/route/product_route_add";
        }

    }

//    @RequestMapping(value = "/edit.htm", method = RequestMethod.GET)
//    public String editRoutePage(Model model, @RequestParam("productId") String productId) {
//        model.addAttribute("config", config);
//        model.addAttribute("productId", productId);
//        return "product/route/product_route_edit";
//    }

    @RequestMapping(value = "/data.do", method = RequestMethod.POST)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    @ResponseBody
    public String editRoute(Model model, @RequestParam("productId") String productId) {

        ProductRouteVo productRouteVo = productRouteService.findByProductId(Integer.valueOf(productId));
        return JSON.toJSONString(productRouteVo);

    }


    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveRoute(Model model, ProductRouteVo productRouteVo) {
        boolean success = productRouteService.saveProductRoute(productRouteVo);
        return success ? successJson() : errorJson("操作失败");
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String editRoute(Model model, ProductRouteVo productRouteVo) {
        boolean success = productRouteService.editProductRoute(productRouteVo);
        return success ? successJson() : errorJson("操作失败");
    }
}
