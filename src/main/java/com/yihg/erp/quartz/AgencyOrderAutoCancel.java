package com.yihg.erp.quartz;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.yihg.erp.utils.WebUtils;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.api.ProductStockService;
import com.yihg.product.api.TrafficResService;
import com.yihg.product.constants.Constants.TRAFFICRES_STOCK_ACTION;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.po.TrafficResStocklog;
import com.yihg.sales.api.FitOrderService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sys.po.PlatformEmployeePo;

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
