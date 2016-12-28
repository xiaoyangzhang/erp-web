package com.yihg.erp.controller.product;

import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductGroup;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupExtraItem;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupPriceStockallocate;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupSupplier;
import com.yimayhd.erpcenter.dal.product.vo.ProductPriceVo;
import com.yimayhd.erpcenter.facade.result.ProductGroupResult;
import com.yimayhd.erpcenter.facade.result.ResultSupport;
import com.yimayhd.erpcenter.facade.service.ProductPricePlusFacade;
import com.yimayhd.erpcenter.facade.service.ProductUpAndDownFrameFacade;
import org.erpcenterFacade.common.client.service.SaleCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author : xuzejun
 * @date : 2015年7月1日 下午3:06:44
 * @Description: 价格表
 */
@Controller
@RequestMapping(value = "/productInfo/price")
public class ProductPricesListController extends BaseController {
    private static final Logger log = LoggerFactory
            .getLogger(ProductPricesListController.class);

    @Autowired
    private ProductUpAndDownFrameFacade productUpAndDownFrameFacade;
    @Autowired
    private ProductPricePlusFacade productPricePlusFacade;
    @Autowired
    private SaleCommonFacade saleCommonFacade;
	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至价格设置页面
	 */
	@RequestMapping(value = "/price_list.htm")
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	public String toList(ModelMap model,Integer groupId,Integer productId) {
//		List<ProductGroupExtraItem> productGroupExtraItems = productGroupExtraItemService.findByGroupId(groupId);
		List<ProductGroupExtraItem> productGroupExtraItems = productUpAndDownFrameFacade.findByGroupId(groupId);
		model.addAttribute("productGroupExtraItems", productGroupExtraItems);
		model.addAttribute("groupId", groupId);
		model.addAttribute("productId", productId);
		return "product/price/price_list";
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转到新增团期
	 */
	@RequestMapping(value = "/addprice_list.htm")
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	public String toAdd(ModelMap model,Integer groupId,Integer productId) {
		//查询产品信息
//		ProductInfo info = infoService.findProductInfoById(productId);
		//查询客户列表
//		List<ProductGroupSupplier> suppliers = groupSupplierService.selectProductGroupSuppliers(groupId);
//		ProductGroup groupInfo = productGroupService.getGroupInfoById(groupId);
		ProductGroupResult result = productPricePlusFacade.ToAddPrice(groupId, productId);
		int groupSetting = 0;
		ProductGroup groupInfo = result.getProductGroups().get(0);
		if(groupInfo!=null && groupInfo.getGroupSetting()!=null){
			groupSetting = groupInfo.getGroupSetting().intValue();
		}
		model.addAttribute("groupSetting", groupSetting);
		model.addAttribute("suppliers", result.getGroupSuppliers());
		model.addAttribute("groupId", groupId);
		model.addAttribute("productId", productId);
		model.addAttribute("info", result.getProductInfo());
		return "product/price/addPrice_list";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转到修改团期
	 */
	@RequestMapping(value = "/editprice_list.htm")
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	public String toEdit(ModelMap model,Integer id,Integer groupId,Integer productId) {
		//查询产品信息
//		ProductInfo info = infoService.findProductInfoById(productId);
		//查询客户列表
//		List<ProductGroupSupplier> suppliers = groupSupplierService.selectProductGroupSuppliers(groupId);
//		ProductPriceVo vo = groupService.selectByPrimaryKey(id);
//		ProductGroup groupInfo = productGroupService.getGroupInfoById(groupId);
		ProductGroupResult result = productPricePlusFacade.ToEditPrice(groupId, productId,id);
		ProductGroup groupInfo = result.getProductGroups().get(0);
		int groupSetting = 0;
		if(groupInfo!=null && groupInfo.getGroupSetting()!=null){
			groupSetting = groupInfo.getGroupSetting().intValue();
		}
		model.addAttribute("groupSetting", groupSetting);
		List<ProductGroupSupplier> suppliers = result.getGroupSuppliers();
		ProductPriceVo vo = result.getPriceVo();
		if(groupSetting==0){
			List<ProductGroupPriceStockallocate> priceStockallocateList = vo.getPriceStockallocate();
			for(ProductGroupSupplier s : suppliers){
				boolean exist = false;
				for(int i=0;i<priceStockallocateList.size() && !exist;i++){
					if(s.getSupplierId()==priceStockallocateList.get(i).getSupplierId()){
						priceStockallocateList.get(i).setSupplierName(s.getSupplierName());
						priceStockallocateList.get(i).setSupplierAddr(s.getProvince()+"-"+s.getCity());
						exist=true;
						break;
					}
				}
				if(!exist){
					ProductGroupPriceStockallocate a = new ProductGroupPriceStockallocate();
					a.setSupplierId(s.getSupplierId());
					a.setSupplierName(s.getSupplierName());
					a.setSupplierAddr(s.getProvince()+"-"+s.getCity());
					vo.getPriceStockallocate().add(a);
				}
			}
		}
		//查询价格

		
		model.addAttribute("suppliers", suppliers);
		model.addAttribute("groupId", groupId);
		model.addAttribute("productId", productId);
		model.addAttribute("info", result.getProductInfo());
		model.addAttribute("vo", vo);
		
		return "product/price/editPrice_list";
	}
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月2日 下午3:24:28
	 * @Description: 保存
	 */
	@RequestMapping(value = "/priceListsave.do",method = RequestMethod.POST)
	@ResponseBody
	public String save(ProductPriceVo priceVo) {
		ResultSupport resultSupport = productPricePlusFacade.save(priceVo);
//		return groupService.save(priceVo)==1?successJson():errorJson("操作失败！");
		return resultSupport.isSuccess()  ? successJson():errorJson("操作失败！");
		
	}
   
	 /**
     * 价格数据获取
     * @param request
     * @param groupId
     * @param year
     * @param month
     * @return
     */
    @RequestMapping(value = "/priceList.do", method = RequestMethod.POST)
    @ResponseBody
    public String list(HttpServletRequest request, @RequestParam Integer groupId, @RequestParam String year, @RequestParam String month) {
//        return JSONArray.toJSONString(groupService.selectProductGroupPrices(groupId, year, month));
        return JSONArray.toJSONString(productPricePlusFacade.selectProductGroupPrices(groupId, year, month));
    }

    @RequestMapping(value = "/extraDic.do", method = RequestMethod.POST)
    @ResponseBody
    public String extraDic(HttpServletRequest request) {
    	Integer bizId=WebUtils.getCurBizId(request);
//        List<DicInfo> extraTypeList = dicService.getListByTypeCode(BasicConstants.GGXX_LYSFXM,bizId);
        List<DicInfo> extraTypeList = saleCommonFacade.getFeeItemsByTypeCode(bizId);
        return JSONArray.toJSONString(extraTypeList);
    }
    /**
     * 删除
     * @param id
     * @return
     */
    @RequestMapping(value = "/del.do", method = RequestMethod.POST)
    @ResponseBody
    public String del(@RequestParam Integer id) {
//		boolean success = groupService.delete(id);
//		return success ? successJson() : errorJson("操作失败");
    	ResultSupport resultSupport = productPricePlusFacade.delete(id);
    	return resultSupport.isSuccess() ? successJson() : errorJson("操作失败");
    }
    /**
     * 批量删除
     * @param ids
     * @return
     */
    @RequestMapping(value = "/batchDel.do", method = RequestMethod.POST)
    @ResponseBody
    public String batchDel(@RequestParam("id[]") String[] ids) {
        boolean success = true;
//        for (String id : ids) {
//            try {
//                groupService.delete(Integer.valueOf(id));
//                success &= true;
//            } catch (Exception e) {
//                success &= false;
//            }
//        }
        ResultSupport resultSupport = productPricePlusFacade.batchDel(ids);
        if(resultSupport.isSuccess()){
            return successJson();
        }else{
            return errorJson("删除失败");
        }

    }

   


}
