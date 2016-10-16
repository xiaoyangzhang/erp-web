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
			<b>机票</b>
		</p>
   			<div class="dd_top"  style="margin-left: 5%;margin-bottom: 5px">
   				<c:if test="${stateFinance!=1}">
   					<button href="#" class="button button-primary button-small" onclick="newAirTicket();">新增</button>
   				</c:if>
   				<%-- <c:if test="${stateFinance==1}">
   					<button disabled="disabled" href="#" class="button button-primary button-small" onclick="newAirTicket();">新增</button>
   				</c:if> --%>
   			</div>
   			<div class="dd_right" style="width:65%;margin-left: 5%">
               	<table cellspacing="0" cellpadding="0" class="w_table" > 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>日期<i class="w_table_split"></i></th>
		             		<th>班次<i class="w_table_split"></i></th>
		             		<th>出发城市<i class="w_table_split"></i></th>
		             		<th>到达城市<i class="w_table_split"></i></th>
		             		<th>数量<i class="w_table_split"></i></th>
		             		<th>备注<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		             <tbody> 
		             	<c:forEach items="${airTicketList}" var="atl" varStatus="v">
		             		<tr>
			                  <td width="10%">${v.index+1}</td>
			                  <td width="15%">${atl.requireDate}</td> 
			                  <td width="10%">${atl.classNo}</td>
			                  <td width="12%">${atl.cityDeparture}</td>
			                  <td width="12%">${atl.cityArrival}</td>
			                  <td width="10%">${atl.countRequire}</td>
			                  <td width="10%" style="text-align: left;line-height: 15px;">${atl.remark}</td>
			                  <td width="21%">
			                  	<c:if test="${stateFinance!=1}">
			                  		<a href="javascript:void(0);" onclick="toEditAirTicket(${atl.id})"  class="def">修改</a>&nbsp;&nbsp;
			                  		<a href="javascript:void(0);" onclick="deleteAirTicketById(this,${atl.id})"  class="def">删除</a>
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
			<div id="addOrEditAirTicket" style="display: none;">
		 		<form id="addOrEditAirTicketForm" method="post" action="">
					<div class="p_container" >
				        <div class="p_container_sub" >
				    		<input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
				    		<input type="hidden" name="groupId" value="${groupId}"/>
				    		<input type="hidden" name="id" id="airTicketId"/>
			                <input type="hidden" name="supplierType" value="9"/>
			                <dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>日期:</div>
				    				<input type="text" id="airTicketRequireDate" name="requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd '})" />
				    			</dd>
		    				</dl>
		    				<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>班次:</div>
				    				<input type="text" name="classNo" id="classNo" value="" class="IptText301">
				    			</dd>
		    				</dl>
		    				<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>出发城市:</div>
				    				<input type="text" name="cityDeparture" id="cityDeparture" value="" class="IptText301">
				    			</dd>
		    				</dl>
		    				<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>到达城市:</div>
				    				<input type="text" name="cityArrival" id="cityArrival" value="" class="IptText301">
				    			</dd>
		    				</dl>
		    				<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left"><i class="red">*</i>数量:</div>
				    				<input type="text" name="countRequire" id="countRequire" value="" class="IptText301">
				    			</dd>
		    				</dl>
		    				<dl class="p_aragraph_content" style="margin-top: 10px">
				    			<dd>
				    				<div class="dd_left">备注:</div>
				    				<textarea id="airTicketRemark" class="l_textarea" name="remark" style="width:270px;"></textarea>
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
