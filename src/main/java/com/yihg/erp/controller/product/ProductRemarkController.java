package com.yihg.erp.controller.product;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.yimayhd.erpcenter.dal.product.po.ProductRemark;
import com.yimayhd.erpcenter.facade.query.ProductRemarkDTO;
import com.yimayhd.erpcenter.facade.result.ToProductRemarkResult;
import com.yimayhd.erpcenter.facade.service.ProductFacade;

/**
 * Created by ZhengZiyu on 2015/7/2.
 */
@Controller
@RequestMapping("/productInfo/remark")
public class ProductRemarkController {

    @Autowired
    private ProductFacade productFacade;
    @RequestMapping(value = "/view.htm", method = RequestMethod.GET)
   // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
   public String viewRemark(Model model, @RequestParam("productId") String productId) {
        model.addAttribute("productId", productId);
      //  ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(Integer.valueOf(productId));
       int id = 0;
        if (StringUtils.isNotBlank(productId)) {
			id = Integer.parseInt(productId); 
		}
        ToProductRemarkResult result = productFacade.toProductRemark(id);
        model.addAttribute("productRemark", result.getProductRemark());
        return "product/remark/product_remark";
    }

    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    public String saveRemark(Model model, ProductRemark productRemark) {
    	ProductRemarkDTO productRemarkDTO = new ProductRemarkDTO();
    	productRemarkDTO.setProductRemark(productRemark);
    	boolean result = productFacade.saveProductRemark(productRemarkDTO);
        return "redirect:view.htm?productId=" + productRemark.getProductId();
    }
}
