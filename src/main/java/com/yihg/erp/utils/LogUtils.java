package com.yihg.erp.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.yihg.basic.contants.BasicConstants.LOG_ACTION;
import com.yihg.basic.po.LogOperator;
import com.yihg.basic.util.LogFieldUtil;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.GroupOrderPrice;
import com.yihg.sales.po.GroupOrderTransport;
import com.yihg.sales.po.GroupRoute;
import com.yihg.sales.vo.GroupRouteDayVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;

/**
 * 保存数据时，产生日志处理
 * @author Ou.ZongYing
 * @create 2016年9月24日 
 */
public class LogUtils {
	
	
	/**
	 * GrupOrder表
	 * 
	 * @param request
	 * @param objEdit 保存订单的实体对象
	 * @param objDb 为从数据库取出来的GroupOrder ，如果订单为新增可以为Null
	 * @return
	 */
	public static List<LogOperator> LogRow_GroupOrder(HttpServletRequest request, GroupOrder objEdit, GroupOrder objDb){
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = new ArrayList<LogOperator>();
		
		boolean isNew = (objEdit.getId()==null);
		Integer orderId = 0, groupId = 0;
		if(!isNew){
			orderId = objEdit.getId();
			groupId = objEdit.getGroupId()==null?0: objEdit.getGroupId();
			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.UPDATE, "group_order", orderId,  groupId,"修改订单", objEdit, objDb));
		}else{                     
			logList.add(LogFieldUtil.getLog_Instant(curUser.getBizId(), curUser.getName(),LOG_ACTION.INSERT, "group_order", 0,  0,"创建订单", objEdit, null));
		}
		return logList;
		
	}
	
	/**
	 * GrupOrderPrice表
	 * 
	 * @param request
	 * @param objEdit 保存订单的实体对象
	 * @param objDb 为从数据库取出来的GroupOrderPrice ，如果订单为新增可以为Null
	 * @return
	 */
	public static List<LogOperator> LogRow_GroupOrderPrice(HttpServletRequest request, Integer orderId, List<GroupOrderPrice> objEdit, List<GroupOrderPrice> objDb){
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "group_order_price", orderId, objEdit, objDb);
		return logList;
	}
	
	/**
	 * GrupOrderGuest表
	 * 
	 * @param request
	 * @param objEdit 保存订单的实体对象
	 * @param objDb 为从数据库取出来的GroupOrderGuest ，如果订单为新增可以为Null
	 * @return
	 */
	public static List<LogOperator> LogRow_GroupOrderGuest(HttpServletRequest request, Integer orderId, List<GroupOrderGuest> objEdit, List<GroupOrderGuest> objDb){
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "group_order_guest", orderId, objEdit, objDb);
		return logList;
	}
	
	/**
	 * GrupOrderTransport表 GroupRoute
	 * 
	 * @param request
	 * @param objEdit 保存订单的实体对象
	 * @param objDb 为从数据库取出来的GroupOrderTransport ，如果订单为新增可以为Null
	 * @return
	 */
	public static List<LogOperator> LogRow_GroupOrderTransport(HttpServletRequest request, Integer orderId, List<GroupOrderTransport> objEdit, List<GroupOrderTransport> objDb){
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "group_order_transport", orderId, objEdit, objDb);
		return logList;
	}
	
	/**
	 * GroupRoute表 
	 * 
	 * @param request
	 * @param objEdit 保存订单的实体对象
	 * @param objDb 为从数据库取出来的GroupRoute ，如果订单为新增可以为Null
	 * @return
	 */
	public static List<LogOperator> LogRow_GroupRoute_OrderId(HttpServletRequest request, Integer orderId, List<GroupRoute> objEdit, List<GroupRoute> objDb){
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "group_route", orderId, objEdit, objDb);
		return logList;
	}
	
	/**
	 * GroupRoute表 
	 * 
	 * @param request
	 * @param objEdit 保存订单的实体对象
	 * @param objDb 为从数据库取出来的GroupRoute ，如果订单为新增可以为Null
	 * @return
	 */
	public static List<LogOperator> LogRow_GroupRoute_GroupId(HttpServletRequest request, Integer groupId, List<GroupRoute> objEdit, List<GroupRoute> objDb){
		PlatformEmployeePo curUser = WebUtils.getCurUser(request);
		List<LogOperator> logList = LogFieldUtil.getLog_InstantList(curUser.getBizId(), curUser.getName(), "group_route", groupId, objEdit, objDb);
		return logList;
	}
	
	/**
	 *  把保存时的 GroupRouteDayVO对象提取出来成 GroupRoute
	 * @param voList
	 * @param departureDate
	 * @return
	 */
	public static List<GroupRoute> groupRouteDatVo_Transfer_Route(List<GroupRouteDayVO> voList, String departureDate){
		List<GroupRoute> routeList = new ArrayList<GroupRoute>();
		
		if (voList != null && voList.size() > 0) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar c = Calendar.getInstance();
			try {
				c.setTime(sdf.parse(departureDate));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			for (GroupRouteDayVO item : voList) {
				GroupRoute groupRoute = item.getGroupRoute();
				
				c.add(Calendar.DAY_OF_MONTH, groupRoute.getDayNum() - 1);
				Date t = c.getTime();
				groupRoute.setGroupDate(t);
				
				if (groupRoute.getId() == null) {
					groupRoute.setCreateTime(System.currentTimeMillis());
				} 
				routeList.add(groupRoute);
			}
		}
		return routeList;
	}
	
	/**
	 * 给日志List赋值
	 * @param logList
	 * @param tableName
	 * @param tableId
	 * @param tableParentId
	 */
	public static void LogRow_SetValue(List<LogOperator> logList, String tableName, Integer tableId, Integer tableParentId){
		for(LogOperator log : logList){
			if (log.getTableName().equals(tableName)){
				if (null != tableId)
					log.setTableId(tableId);
				if (null != tableParentId)
					log.setTableParentId(tableParentId);
			}
			if (log.getTableParentId() == null)
				log.setTableParentId(0);
		}
	}
}
