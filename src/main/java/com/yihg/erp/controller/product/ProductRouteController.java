package com.yihg.erp.controller.product;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yimayhd.erpcenter.dal.product.po.ProductRemark;
import com.yimayhd.erpcenter.dal.product.po.ProductRoute;
import com.yimayhd.erpcenter.dal.product.vo.ProductRouteVo;
import com.yimayhd.erpcenter.facade.result.GetProductRouteResult;
import com.yimayhd.erpcenter.facade.result.ProductInfoResult;
import com.yimayhd.erpcenter.facade.service.ProductFacade;

/**
 * Created by ZhengZiyu on 2015/7/7.
 */
@Controller
@RequestMapping("/productInfo/route")
public class ProductRouteController extends BaseController{

    @Autowired
    private SysConfig config;
    @Autowired
    private ProductFacade productFacade;
    

    @RequestMapping(value = "/view.htm", method = RequestMethod.GET)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    public String viewRoute(Model model, @RequestParam("productId") String productId) {
//        List<ProductRoute> list = productRouteService.findProductRouteByProductId(Integer.valueOf(productId));
    	ProductInfoResult result = productFacade.viewRoute(Integer.parseInt(productId));
    	List<ProductRoute> list = result.getProductRoutes();
        if(!CollectionUtils.isEmpty(list)){
            model.addAttribute("config", config);
            model.addAttribute("productId", productId);
//            ProductRemark productRemark = remarkService.findProductRemarkByProductId(Integer.valueOf(productId));
            ProductRemark productRemark = result.getProductRemark();
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
    	GetProductRouteResult result = productFacade.findProductRouteById(Integer.valueOf(productId));
        return JSON.toJSONString(result.getProductRouteVo());

    }


    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveRoute(Model model, ProductRouteVo productRouteVo) {
//        boolean success = productRouteService.saveProductRoute(productRouteVo);
        boolean success = productFacade.saveProductRoute(productRouteVo);
        return success ? successJson() : errorJson("操作失败");
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String editRoute(Model model, ProductRouteVo productRouteVo) {
//        boolean success = productRouteService.editProductRoute(productRouteVo);
        boolean success = productFacade.editProductRoute(productRouteVo);
        return success ? successJson() : errorJson("操作失败");
    }
}
