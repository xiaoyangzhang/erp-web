package com.yihg.erp.quartz;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.yimayhd.erpcenter.dal.product.constans.Constants.TRAFFICRES_STOCK_ACTION;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.po.TrafficResStocklog;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;

public class AgencyOrderAutoCancel {
	private static final Logger log = LoggerFactory.getLogger(AgencyOrderAutoCancel.class);

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
				groupOrder.setExtResState(3);
				groupOrder.setState(orderState);
				groupOrder.setExtResConfirmId(null);
				groupOrder.setExtResConfirmName("");
				groupOrderService.loadUpdateExtResState(groupOrder);
				
				//库存变更
				TrafficResStocklog trafficResStocklog=new TrafficResStocklog();
				trafficResStocklog.setAdjustAction(TRAFFICRES_STOCK_ACTION.ORDER_CLEAN.toString());
				trafficResStocklog.setAdjustNum(groupOrder.getNumAdult()+groupOrder.getNumChild());
				trafficResStocklog.setResId(groupOrder.getExtResId());//参数为resId：资源ID
				trafficResStocklog.setAdjustTime(new Date());
				trafficResStocklog.setUserId(null);
				trafficResStocklog.setUserName("");
				
				trafficResService.insertTrafficResStocklog(trafficResStocklog);
				trafficResService.updateStockOrStockDisable(groupOrder.getExtResId());
			}
		}
	}
	
	
}
