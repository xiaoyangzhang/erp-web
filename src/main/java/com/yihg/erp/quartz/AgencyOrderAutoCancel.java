package com.yihg.erp.quartz;

import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductStockService;
import com.yihg.product.api.TrafficResService;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.TrafficResStocklog;
import com.yihg.sales.api.FitOrderService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.po.GroupOrder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

public class AgencyOrderAutoCancel {
	private static final Logger log = LoggerFactory.getLogger(AgencyOrderAutoCancel.class);
	@Autowired
	private FitOrderService fitOrderService;
	@Autowired
	private GroupOrderService groupOrderService;

	@Autowired
	private ProductStockService productStockService;

	@Autowired
	private ProductInfoService productInfoService;

	@Autowired
	private TrafficResService trafficResService;

	public void execute() throws ParseException {
		long startTime = System.currentTimeMillis();
		List<GroupOrder> orderList = fitOrderService.selectReserveOrderList();

		if (orderList != null && orderList.size() != 0) {

			for (GroupOrder groupOrder : orderList) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				ProductInfo productInfo = productInfoService.findProductInfoById(groupOrder.getProductId());

				if (productInfo.getObligateHour() != null) {
					long ObligatMin = productInfo.getObligateHour() * 60 * 60 * 1000;
					if (groupOrder.getCreateTime() + ObligatMin < System.currentTimeMillis()) {
						log.info("发现可删除的订单,开始执行....");
						productStockService.updateReserveCount(groupOrder.getProductId(),
								sdf.parse(groupOrder.getDepartureDate()),
								-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
						groupOrderService.delGroupOrder(groupOrder.getId());
						continue;
					}

				}
				if (productInfo.getObligateCount() != null) {
					int stock = productStockService.getRestCountByProductIdAndDate(groupOrder.getProductId(),
							sdf.parse(groupOrder.getDepartureDate()));
					if (stock < productInfo.getObligateCount()) {
						log.info("发现可删除的订单,开始执行....");
						productStockService.updateReserveCount(groupOrder.getProductId(),
								sdf.parse(groupOrder.getDepartureDate()),
								-(groupOrder.getNumAdult() + groupOrder.getNumChild()));
						groupOrderService.delGroupOrder(groupOrder.getId());

					}
				}

			}
		}
	}

	/**
	 * 管理员端订单-已超时的订单信息自动清位
	 * 
	 * @throws ParseException
	 */
	public void executeUpdateResOrderState() throws ParseException {
		//PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		Integer orderState = 0;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 查询已超时的记录
		List<GroupOrder> orderList = groupOrderService.selectOrderOverTime();
		if (null != orderList && orderList.size() > 0) {
			for (GroupOrder groupOrder : orderList) {
				groupOrder.setExtResState(2);
				groupOrder.setState(orderState);
				// groupOrder.setExtResConfirmId(null);
				// groupOrder.setExtResConfirmName("");
				groupOrderService.loadUpdateExtResState(groupOrder);
				
				//修改 traffic_res_stocklog 预留订单状态为已确认
				TrafficResStocklog updateStockLog=new TrafficResStocklog();
				updateStockLog.setAdjustState(2);
				updateStockLog.setResId(groupOrder.getExtResId());
				updateStockLog.setOrderId(groupOrder.getId());
				trafficResService.updateStockLog_AdjustState(updateStockLog);
				//更新库存
				trafficResService.updateStockOrStockDisable(groupOrder.getExtResId());
			}
		}
	}
	
	
}
