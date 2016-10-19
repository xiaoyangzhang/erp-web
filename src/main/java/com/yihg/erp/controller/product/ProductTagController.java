package com.yihg.erp.controller.product;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yihg.basic.api.DicService;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.product.api.ProductTagService;
import com.yihg.product.constants.Constants;
import com.yihg.product.po.ProductTag;
import com.yihg.product.vo.DictWithSelectInfoVo;
import com.yimayhd.erpcenter.dal.product.vo.ProductTagVo;
import com.yimayhd.erpcenter.facade.query.ProductTagDTO;
import com.yimayhd.erpcenter.facade.result.ToProductTagResult;
import com.yimayhd.erpcenter.facade.service.ProductFacade;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import static com.yihg.product.constants.Constants.PRODUCT_TAG_ATTEND_METHOD;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_DAYS_PERIOD;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_HOTEL_LEVEL;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_LINE_LEVEL;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_LINE_THEME;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_PRICE_RANGE;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_EXIT_DESTINATION;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_DOMESTIC_DESTINATION;
import static com.yihg.product.constants.Constants.PRODUCT_TAG_TYPE;

/**
 * Created by ZhengZiyu on 2015/7/2.
 */

@Controller
@RequestMapping("/productInfo/tag")
public class ProductTagController extends BaseController{

    @Autowired
    private DicService dicService;

    @Autowired
    private ProductTagService productTagService;
    @Autowired
    private ProductFacade productFacade;
    @RequestMapping(value = "/view.htm", method = RequestMethod.GET)
    // @RequiresPermissions(PermissionConstants.PRODUCT_LIST)
    public String viewTag(HttpServletRequest request,Model model, @RequestParam("productId") String productId) {
    	
    	Integer bizId = WebUtils.getCurBizId(request);
    	int id = 0;
    	if (StringUtils.isNotBlank(productId)) {
			id = Integer.parseInt(productId);
		}
        ToProductTagResult result = productFacade.toProductTags(id, bizId);
    	/*List<DicInfo> lineThemeList = dicService.getListByTypeCode(PRODUCT_TAG_LINE_THEME,bizId);
        List<DicInfo> lineLevelList = dicService.getListByTypeCode(PRODUCT_TAG_LINE_LEVEL,bizId);
        List<DicInfo> attendMethodList = dicService.getListByTypeCode(PRODUCT_TAG_ATTEND_METHOD,bizId);
        List<DicInfo> hotelLevelList = dicService.getListByTypeCode(PRODUCT_TAG_HOTEL_LEVEL,bizId);
        List<DicInfo> daysPeriodList = dicService.getListByTypeCode(PRODUCT_TAG_DAYS_PERIOD,bizId);
        
        List<DicInfo> priceRangeList = dicService.getListByTypeCode(PRODUCT_TAG_PRICE_RANGE,bizId);
        List<DicInfo> exitDestinationList = dicService.getListByTypeCode(PRODUCT_TAG_EXIT_DESTINATION,bizId);
        List<DicInfo> domesticDestinationList = dicService.getListByTypeCode(PRODUCT_TAG_DOMESTIC_DESTINATION,bizId);
        List<DicInfo> typeList = dicService.getListByTypeCode(PRODUCT_TAG_TYPE,bizId);
        ProductTagVo productTagVo = productTagService.findProductTagsByProductId(Integer.valueOf(productId));


        Map<String, List<Integer>> selectedMap = new HashMap<String, List<Integer>>();
        for(ProductTag productTag : productTagVo.getProductTags()){
            if(selectedMap.get(productTag.getTagType()) == null){
                List<Integer> tagList = new ArrayList<Integer>();
                tagList.add(productTag.getTagId());
                selectedMap.put(productTag.getTagType(), tagList);
            }else{
                selectedMap.get(productTag.getTagType()).add(productTag.getTagId());
            }
        }*/


//        if(selectedMap.get(PRODUCT_TAG_LINE_THEME) != null){
//            List<DictWithSelectInfoVo> lineThemeListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : lineThemeList){
//                lineThemeListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_LINE_THEME).contains(dicInfo.getId())));
//            }
            model.addAttribute("lineThemeList", result.getLineThemeListPlus());
//        }else{
//            List<DictWithSelectInfoVo> lineThemeListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : lineThemeList){
//                lineThemeListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
          //  model.addAttribute("lineThemeList", lineThemeListPlus);
//        }
//
//        if(selectedMap.get(PRODUCT_TAG_LINE_LEVEL) != null){
//            List<DictWithSelectInfoVo> lineLevelListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : lineLevelList){
//                lineLevelListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_LINE_LEVEL).contains(dicInfo.getId())));
//            }
          //  model.addAttribute("lineLevelList", lineLevelListPlus);
//        }else{
//            List<DictWithSelectInfoVo> lineLevelListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : lineLevelList){
//                lineLevelListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
            model.addAttribute("lineLevelList", result.getLineLevelListPlus());
//        }
//
//        if(selectedMap.get(PRODUCT_TAG_ATTEND_METHOD) != null){
//            List<DictWithSelectInfoVo> attendMethodListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : attendMethodList){
//                attendMethodListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_ATTEND_METHOD).contains(dicInfo.getId())));
//            }
            model.addAttribute("attendMethodList", result.getAttendMethodListPlus());
//        }else{
//            List<DictWithSelectInfoVo> attendMethodListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : attendMethodList){
//                attendMethodListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("attendMethodList", attendMethodListPlus);
//        }
//
//        if(selectedMap.get(PRODUCT_TAG_HOTEL_LEVEL) != null){
//            List<DictWithSelectInfoVo> hotelLevelListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : hotelLevelList){
//                hotelLevelListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_HOTEL_LEVEL).contains(dicInfo.getId())));
//            }
            model.addAttribute("hotelLevelList", result.getHotelLevelListPlus());
//        }else{
//            List<DictWithSelectInfoVo> hotelLevelListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : hotelLevelList){
//                hotelLevelListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("hotelLevelList", hotelLevelListPlus);
//        }
//
//        if(selectedMap.get(PRODUCT_TAG_DAYS_PERIOD) != null){
//            List<DictWithSelectInfoVo> daysPeriodListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : daysPeriodList){
//                daysPeriodListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_DAYS_PERIOD).contains(dicInfo.getId())));
//            }
            model.addAttribute("daysPeriodList", result.getDaysPeriodListPlus());
//        }else{
//            List<DictWithSelectInfoVo> daysPeriodListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : daysPeriodList){
//                daysPeriodListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("daysPeriodList", daysPeriodListPlus);
//        }
//        
//        if(selectedMap.get(PRODUCT_TAG_PRICE_RANGE) != null){
//            List<DictWithSelectInfoVo> priceRangeListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : priceRangeList){
//            	priceRangeListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_PRICE_RANGE).contains(dicInfo.getId())));
//            }
            model.addAttribute("priceRangeList", result.getPriceRangeListPlus());
//        }else{
//            List<DictWithSelectInfoVo> priceRangeListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : priceRangeList){
//            	priceRangeListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("priceRangeList", priceRangeListPlus);
//        }
//       
//        if(selectedMap.get(PRODUCT_TAG_EXIT_DESTINATION) != null){
//            List<DictWithSelectInfoVo> exitDestinationListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : exitDestinationList){
//            	exitDestinationListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_EXIT_DESTINATION).contains(dicInfo.getId())));
//            }
            model.addAttribute("exitDestinationList", result.getExitDestinationListPlus());
//        }else{
//            List<DictWithSelectInfoVo> exitDestinationListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : exitDestinationList){
//            	exitDestinationListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("exitDestinationList", exitDestinationListPlus);
       // }
       
//        if(selectedMap.get(PRODUCT_TAG_DOMESTIC_DESTINATION) != null){
//            List<DictWithSelectInfoVo> domesticDestinationListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : domesticDestinationList){
//            	domesticDestinationListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_DOMESTIC_DESTINATION).contains(dicInfo.getId())));
//            }
            model.addAttribute("domesticDestinationList", result.getDomesticDestinationListPlus());
//        }else{
//            List<DictWithSelectInfoVo> domesticDestinationListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : domesticDestinationList){
//            	domesticDestinationListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("domesticDestinationList", domesticDestinationListPlus);
//        }
//        
//        if(selectedMap.get(PRODUCT_TAG_TYPE) != null){
//            List<DictWithSelectInfoVo> typeListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : typeList){
//            	typeListPlus.add(new DictWithSelectInfoVo(dicInfo, selectedMap.get(PRODUCT_TAG_TYPE).contains(dicInfo.getId())));
//            }
            model.addAttribute("typeList", result.getTypeListPlus());
//        }else{
//            List<DictWithSelectInfoVo> typeListPlus = new ArrayList<DictWithSelectInfoVo>();
//            for(DicInfo dicInfo : typeList){
//            	typeListPlus.add(new DictWithSelectInfoVo(dicInfo, false));
//            }
//            model.addAttribute("typeList", typeListPlus);
//        }
        

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
