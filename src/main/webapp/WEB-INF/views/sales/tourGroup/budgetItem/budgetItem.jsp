<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
	<body>
		<p class="p_paragraph_title">
			<b>收入列表</b>
		</p>
			<dl class="p_paragraph_content">
			<c:if test="${stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button type="button" class="button button-primary button-small"
							onclick="addPrice(0,'newPrice');">添加新价格</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
				<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
			
   					<table cellspacing="0" cellpadding="0" class="w_table" id="incomeTable"> 
		        	<thead>
		            	<tr>
		             		<th>序号<i class="w_table_split"></i></th>
		             		<th>项目<i class="w_table_split"></i></th>
		             		<th>备注<i class="w_table_split"></i></th>
		             		<th>单价<i class="w_table_split"></i></th>
		             		<th>次数<i class="w_table_split"></i></th>
		             		<th>人数<i class="w_table_split"></i></th>
		             		<th>金额<i class="w_table_split"></i></th>
		             		<th>操作</th>
		             	</tr>
		             </thead>
		           
		             	<c:forEach items="${incomeList}" var="il" varStatus="v">
		             		<tr>
		             		<td>${v.count }</td>
		             		<td>${il.itemName }</td>
		             		<td>${il.remark }</td>
		             		<td>${il.unitPrice}</td>
							<td>${il.numTimes}</td>
							<td>${il.numPerson}</td>
							<td>${il.totalPrice }</td>
		             		<td  style="width:8%">
				                <c:if test="${stateFinance!=1}">
				                  <a href="javascript:void(0);" onclick="toEdit(${il.id})"  class="def">修改</a>
				                  <a href="javascript:void(0)" onclick="deleteBudgetItemById(this,${il.id})" class="def">删除</a>
				                </c:if>
			                 </td>
		               		</tr>
		               		<c:set var="sum_price" value="${sum_price+il.totalPrice }" />
		             	</c:forEach>
		             	   <tbody id="newPriceData">
						</tbody>
						<tr>
							<td colspan="6"  style="text-align: right">合计： </td>
							<td align="left"><fmt:formatNumber value="${sum_price }" pattern="#.##" type="number"/></td>
							<c:if test="${stateFinance!=1}">
								<td></td>
							</c:if>
						</tr>
          		 </table>
   				
				</div>
				<div class="clear"></div>
			</dd>
			</dl>
	</body>

					
</html>
