package com.yihg.erp.controller.product;

import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.product.api.ProductRemarkService;
import com.yihg.product.po.ProductRemark;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by ZhengZiyu on 2015/7/2.
 */
@Controller
@RequestMapping("/productInfo/remark")
public class ProductRemarkController {

    @Autowired
    private ProductRemarkService productRemarkService;

    @RequestMapping(value = "/view.htm", method = RequestMethod.GET)
   // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
   public String viewRemark(Model model, @RequestParam("productId") String productId) {
        model.addAttribute("productId", productId);
        ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(Integer.valueOf(productId));
        model.addAttribute("productRemark", productRemark);
        return "product/remark/product_remark";
    }

    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    public String saveRemark(Model model, ProductRemark productRemark) {
        productRemarkService.saveProductRemark(productRemark);
        return "redirect:view.htm?productId=" + productRemark.getProductId();
    }
}
