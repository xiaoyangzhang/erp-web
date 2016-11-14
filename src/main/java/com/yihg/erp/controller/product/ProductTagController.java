package com.yihg.erp.controller.product;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.product.vo.ProductTagVo;
import com.yimayhd.erpcenter.facade.query.ProductTagDTO;
import com.yimayhd.erpcenter.facade.result.ToProductTagResult;
import com.yimayhd.erpcenter.facade.service.ProductFacade;

/**
 * Created by ZhengZiyu on 2015/7/2.
 */

@Controller
@RequestMapping("/productInfo/tag")
public class ProductTagController extends BaseController{

    @Autowired
    private ProductFacade productFacade;
    @RequestMapping(value = "/view.htm", method = RequestMethod.GET)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    public String viewTag(HttpServletRequest request,Model model, @RequestParam("productId") String productId) {
    	
    	int bizId = WebUtils.getCurBizId(request);
    	int id = 0;
    	if (StringUtils.isNotBlank(productId)) {
			id = Integer.parseInt(productId);
		}
		ToProductTagResult result = productFacade.toProductTags(id, bizId);
    	
        model.addAttribute("lineThemeList", result.getLineThemeListPlus());
        model.addAttribute("lineLevelList", result.getLineLevelListPlus());
        model.addAttribute("attendMethodList", result.getAttendMethodListPlus());
        model.addAttribute("hotelLevelList", result.getHotelLevelListPlus());
        model.addAttribute("daysPeriodList", result.getDaysPeriodListPlus());
        model.addAttribute("priceRangeList", result.getPriceRangeListPlus());
        model.addAttribute("exitDestinationList", result.getExitDestinationListPlus());
        model.addAttribute("domesticDestinationList", result.getDomesticDestinationListPlus());
        model.addAttribute("typeList", result.getTypeListPlus());

        model.addAttribute("productId", productId);
        return "product/tag/product_tag";
    }

    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveTag(@RequestParam("productTagVo")String productTagJson){
    	ProductTagVo productTagVo = JSONObject.parseObject(productTagJson, ProductTagVo.class);
    	ProductTagDTO productTagDTO = new ProductTagDTO();
    	productTagDTO.setProductTagVo(productTagVo);
    	boolean result = productFacade.saveProductTags(productTagDTO);
        return successJson();
    }

}
