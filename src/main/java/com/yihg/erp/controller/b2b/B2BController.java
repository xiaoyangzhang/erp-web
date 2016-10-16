package com.yihg.erp.controller.b2b;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.po.SupplierContactMan;
import com.yihg.supplier.po.SupplierInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.b2b.api.B2BGroupOrderService;
import com.yihg.erp.controller.BaseController;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductRemarkService;
import com.yihg.product.api.ProductRouteService;
import com.yihg.product.constants.Constants;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.ProductRemark;
import com.yihg.product.po.ProductRoute;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.po.GroupRoute;

/**
 * Created by zm on 2016/6/17.
 */
@Controller
@RequestMapping(value = "/b2b")
public class B2BController extends BaseController {

	private static final Logger logger = LoggerFactory.getLogger(B2BController.class);

	@Autowired
	private B2BGroupOrderService b2BGroupOrderService;

	@Autowired
	private ProductInfoService productInfoService;

	@Autowired
	private ProductRouteService productRouteService;

	@Autowired
	private ProductRemarkService productRemarkService;

	@Autowired
	private SupplierService supplierService;

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

		List<GroupOrder> list = b2BGroupOrderService.findGroupOrder(bizId, dateStart, dateEnd, clientName, exports);
		return JSON.toJSONString(list);
	}

	@RequestMapping(value = "/updateExportState")
	@ResponseBody
	public String updateExportState(@RequestParam(value = "ids") String ids) {
		// 更新多个导出状态
		boolean bl = b2BGroupOrderService.updateB2bExportState(ids);
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

		List<GroupOrder> groupOrderList = b2BGroupOrderService.findGroupOrderDetailByIds(ids);

		JSONArray jsonarray = new JSONArray();

		for (GroupOrder groupOrders : groupOrderList) {
			GroupOrder groupOrder;
			groupOrder = groupOrders;

			List<GroupOrderGuest> groupOrderGuests = b2BGroupOrderService.findGroupOrderGuestByOrderId(groupOrders.getId());
			groupOrder.setGroupOrderGuestList(groupOrderGuests);

			List<GroupOrderPrice> groupOrderPrices =
					b2BGroupOrderService.findGroupOrderPriceByOrderId(groupOrders.getId());
			groupOrder.setOrderPrices(groupOrderPrices);

			List<GroupRoute> groupRoutes = b2BGroupOrderService.findGroupRouteByOrderId(groupOrders.getId());
			groupOrder.setGroupRouteList(groupRoutes);
			jsonarray.add(groupOrder);
		}

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

		pageBean = productInfoService.findProductInfos2(pageBean, parameters);

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

		String[] proIds = productIds.split(",");

		List<ProductInfo> list = new ArrayList<ProductInfo>();
		for (String productId : proIds) {
			ProductInfo productInfo;
			productInfo = productInfoService.findProductInfoById(Integer.parseInt(productId));

			List<ProductRoute> productRouteList =
					productRouteService.findProductRouteByProductId(Integer.parseInt(productId));
			productInfo.setProductRouteList(productRouteList);

			ProductRemark productRemark =
					productRemarkService.findProductRemarkByProductId(Integer.parseInt(productId));
			productInfo.setProductRemark(productRemark);
			list.add(productInfo);
		}

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

		if (supplierType == null) {
			supplierType = 1;
		}

		List<SupplierInfo> supplierInfoList = supplierService.findSupplierInfoListToB2B(bizId, supplierType, supplierName);
		JSONArray jsonarray = new JSONArray();
		for (SupplierInfo supplierInfos : supplierInfoList) {

			List<SupplierContactMan> supplierContactManList = supplierService.findSupplierContactManListBySupplierId(supplierInfos.getId());
			supplierInfos.setSupplierContactManList(supplierContactManList);

			jsonarray.add(supplierInfos);
		}

		return JSON.toJSONString(jsonarray);
	}
}
