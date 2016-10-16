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
	<div class="p_container_sub" id="tab1">
		<p class="p_paragraph_title">
			<b>成本列表</b>
		</p>
		<dl class="p_paragraph_content">
		<c:if test="${stateFinance!=1}">
			<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
							<button type="button" class="button button-primary button-small"
							onclick="addCost(1,'newCost');">添加新成本</button>
					</div>
					<div class="clear"></div>
			</dd>
		</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
				
   					<table cellspacing="0" cellpadding="0" class="w_table" id="costTable">
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
		           	
		             	<c:forEach items="${costList}" var="cl" varStatus="v">
		             		<tr>
			             		<td>${v.count }</td>
			             		<td>${cl.itemName }</td>
			             		<td>${cl.remark }</td>
			             		<td>${cl.unitPrice}</td>
								<td>${cl.numTimes}</td>
								<td>${cl.numPerson}</td>
								<td>${cl.totalPrice }</td>
			             		<td  style="width:8%">
					                <c:if test="${stateFinance!=1}">
					                  <a href="javascript:void(0);" onclick="toEditCostItem(${cl.id})"  class="def">修改</a>
					                  <a href="javascript:void(0)" onclick="deleteCostItemById(this,${cl.id})" class="def" >删除</a>
					                </c:if>
				                </td>
		               		</tr>
		               		<c:set var="sum_price" value="${sum_price+cl.totalPrice }" />
		             	</c:forEach>
		             	<tbody id="newCostData">
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
				</div>
	</body>
					
</html>
