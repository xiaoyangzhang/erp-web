package com.yihg.erp.controller.b2b;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.controller.BaseController;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductRemark;
import com.yimayhd.erpcenter.dal.product.po.ProductRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.facade.result.WebResult;
import com.yimayhd.erpcenter.facade.sales.service.B2BFacade;
import com.yimayhd.erpcenter.facade.service.ProductFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.SupplierContactMan;
import com.yimayhd.erpresource.dal.po.SupplierInfo;

/**
 * Created by zm on 2016/6/17.
 */
@Controller
@RequestMapping(value = "/b2b")
public class B2BController extends BaseController {

	private static final Logger logger = LoggerFactory.getLogger(B2BController.class);
	
	@Autowired
	private B2BFacade b2BFacade;
	
	@Autowired
	private ProductFacade productFacade;

	@RequestMapping(value = "/groupOrderList")
	@ResponseBody
	public String findGroupOrderListToB2B(
			@RequestParam(value = "appKey") String appKey,
			@RequestParam(value = "bizId") Integer bizId,
			@RequestParam(value = "dateStart") String dateStart,
			@RequestParam(value = "dateEnd") String dateEnd,
			@RequestParam(value = "clientName") String clientName,
			@RequestParam(value = "exports") Integer exports,
			@RequestParam(value = "sign") String sign) {

		// 验证授权码
		// 验证签名

		List<GroupOrder> list = b2BFacade.findGroupOrder(bizId, dateStart, dateEnd, clientName, exports);
		return JSON.toJSONString(list);
	}

	@RequestMapping(value = "/updateExportState")
	@ResponseBody
	public String updateExportState(@RequestParam(value = "ids") String ids) {
		// 更新多个导出状态
		boolean bl = b2BFacade.updateB2bExportState(ids);
		if (bl) {
			return successJson();
		}
		return errorJson("更新导出状态失败");
	}

	@RequestMapping(value = "/groupOrderDetailByIds")
	@ResponseBody
	public String findGroupOrderDetailByIdsToB2B(
			@RequestParam(value = "appKey") String appKey,
			@RequestParam(value = "ids") String ids,
			@RequestParam(value = "sign") String sign) {

		JSONArray jsonarray = b2BFacade.findGroupOrderDetailByIdsToB2B(ids);
		return JSON.toJSONString(jsonarray);
	}

	@RequestMapping(value = "/productInfoList")
	@ResponseBody
	public String findProductInfoListToB2B(
			@RequestParam(value = "appKey") String appKey,
			@RequestParam(value = "sign") String sign,
			@RequestParam(value = "bizId") Integer bizId,
			ProductInfo productInfo,
			@RequestParam(value = "brandId") Integer brandId,
			@RequestParam(value = "nameCity") String nameCity,
			Integer page,
			Integer pageSize) {
		// 验证授权码
		// 验证签名

		PageBean<ProductInfo> pageBean = new PageBean<ProductInfo>();

		if (page == null) {
			page = 1;
		}

		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}

		pageBean.setParameter(productInfo);

		pageBean.setPage(page);
		Map parameters = new HashMap();
		parameters.put("bizId", bizId);
		parameters.put("brandId", brandId);
		parameters.put("productName", nameCity);  // 产品名称

		WebResult<PageBean<ProductInfo>> webResult = productFacade.selectProductList(pageBean, parameters);
		pageBean = webResult.getValue();

		return JSON.toJSONString(pageBean);
	}

	@RequestMapping(value = "/productInfoDetailByProductId")
	@ResponseBody
	public String findProductInfoDetailByProductIdToB2B(
			@RequestParam(value = "appKey") String appKey,
			@RequestParam(value = "productIds") String productIds,
			@RequestParam(value = "sign") String sign) {
		// 验证授权码
		// 验证签名
		List<ProductInfo> list = b2BFacade.findProductInfoDetailByProductIdToB2B(productIds);
		return JSON.toJSONString(list);
	}

	@RequestMapping(value = "/supplierInfoList")
	@ResponseBody
	public String findSupplierInfoListToB2B(
			@RequestParam(value = "appKey") String appKey,
			@RequestParam(value = "sign") String sign,
			@RequestParam(value = "bizId") Integer bizId,
			Integer supplierType,
			String supplierName) {
		// 验证授权码
		// 验证签名

		JSONArray jsonarray = b2BFacade.findSupplierInfoListToB2B(bizId, supplierType, supplierName);
		return JSON.toJSONString(jsonarray);
	}
}
