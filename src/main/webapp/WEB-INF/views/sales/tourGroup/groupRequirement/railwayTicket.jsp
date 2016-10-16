<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
	<body>
		<p class="p_paragraph_title">
			<b>火车票</b>
		</p>
   			<div class="dd_top"  style="margin-left: 5%;margin-bottom: 5px">
   				<c:if test="${stateFinance!=1}">
   					<button href="#" class="button button-primary button-small" onclick="newRailwayTicket();">新增</button>
   				</c:if>
   				<%-- <c:if test="${stateFinance==1}">
   					<button disabled="disabled" href="#" class="button button-primary button-small" onclick="newRailwayTicket();">新增</button>
   				</c:if> --%>
   			</div>
   			<div class="dd_right" style="width:60%;margin-left: 5%">
               	<table cellspacing="0" cellpadding="0" class="w_table" > 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>日期<i class="w_table_split"></i></th>
		             		<th>车次<i class="w_table_split"></i></th>
		             		<th>出发地<i class="w_table_split"></i></th>
		             		<th>目的地<i class="w_table_split"></i></th>
		             		<th>数量<i class="w_table_split"></i></th>
		             		<th>摘要<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             	<c:forEach items="${railwayTicketList}" var="rtl" varStatus="v">
		             		<tr>
			                  <td width="5%">${v.index+1}</td>
			                  <td width="10%">${rtl.requireDate}</td> 
			                  <td width="10%">${rtl.classNo}</td>
			                  <td width="10%">${rtl.cityDeparture}</td>
			                  <td width="10%">${rtl.cityArrival}</td>
			                   <td width="10%">${rtl.countRequire}</td>
			                  <td width="20%" style="text-align: left;line-height: 15px;">${rtl.remark}</td>
			                  <td width="25%">
			                  	<c:if test="${stateFinance!=1}">
			                  		<a href="javascript:void(0);" onclick="toEditRailwayTicket(${rtl.id})" class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" onclick="deleteRailwayTicketById(this,${rtl.id})" class="def">删除</a>
			                 	</c:if>
			                 	<c:if test="${stateFinance==1}">
			                  		<a href="javascript:void(0);" class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" class="def">删除</a>
			                 	</c:if>
			                  </td>
		               		</tr>
		             	</c:forEach>
		             </tbody>
          		 </table>
   			</div>
   			<div class="clear"></div>
		<div id="addOrEditRailwayTicket" style="display: none;">
	 		<form id="addOrEditRailwayTicketForm" method="post" action="">
				<div class="p_container" >
			        <div class="p_container_sub" >
			    		<input type="hidden" name="id" id="railwayTicketId"/>
		                <input type="hidden" name="supplierType" value="10"/>
		                <input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
		                <input type="hidden" name="groupId" value="${groupId}"/>
		                <dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>日期:</div>
			    				<input type="text" id="railwayTicketRequireDate" name="requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd '})" />
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>班次:</div>
			    				<input type="text" name="classNo" id="railwayTicketClassNo" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>出发城市:</div>
			    				<input type="text" name="cityDeparture" id="railwayTicketCityDeparture" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>到达城市:</div>
			    				<input type="text" name="cityArrival" id="railwayTicketCityArrival" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left"><i class="red">*</i>数量:</div>
			    				<input type="text" name="countRequire" id="railwayTicketCountRequire" value="" class="IptText301"/>
			    			</dd>
   						</dl>
   						<dl class="p_aragraph_content" style="margin-top: 10px">
			    			<dd>
			    				<div class="dd_left">备注:</div>
			    				<textarea id="railwayTicketRemark" class="l_textarea" name="remark" style="width:270px;"></textarea>
			    			</dd>
	    				</dl>
			        </div>
			    </div>
				<div class="modal-footer" style="margin-left: 43%;">
					<button type="submit" class="button button-primary button-small">保存</button>
				</div>
		    </form>
		</div>
	</body>
</html>
