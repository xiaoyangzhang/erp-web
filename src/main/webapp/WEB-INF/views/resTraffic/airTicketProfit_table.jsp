<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String staticPath = request.getContextPath();
%>
<!-- 	<SCRIPT type="text/javascript">
	$(function(){	
		alert($("#orderId").val())
	})
	</SCRIPT> -->

	<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="3%"/>
    <col width="10%"/>
    <col width="7%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    
    <col width="8%"/>
    <col width="8%"/>
    <col width="8%"/>
    <col width="8%"/>
    <col width="8%"/>
    <col width="8%"/>
    <col width="8%"/>
    <col width="8%"/>
    <thead>
    <tr>
    	<th>序号<i class="w_table_split"></i></th>
        <th>资源名称<i class="w_table_split"></i></th>
        <th>日期<i class="w_table_split"></i></th>
        <th>总数量<i class="w_table_split"></i></th>
        <th>机动位<i class="w_table_split"></i></th>
        <th>已售<i class="w_table_split"></i></th>
        <th>剩余<i class="w_table_split"></i></th>
        
        <th>预算收入<i class="w_table_split"></i></th>
        <th>预算成本<i class="w_table_split"></i></th>
        <th>预算利润<i class="w_table_split"></i></th>
        <th>预算明细</th>
        
        <th>实时收入<i class="w_table_split"></i></th>
        <th>实时成本<i class="w_table_split"></i></th>
        <th>实时利润<i class="w_table_split"></i></th>
        <th>实时明细</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="res" varStatus="status">
        <tr id="${res.id }">
        	<td>${status.count }</td>
 			<td>${res.resName }</td>
            <td>${res.dateStart }</td>
            <td>${res.numStock }</td>            
            <td>${res.numDisable } </td>
            <td>${res.numSold } </td>   
            <td>${res.numStock - res.numSold }</td>  
             <td><fmt:formatNumber value="${res.planIncome}" type="currency" pattern="#.##" /></td>
             <td><fmt:formatNumber value="${res.planCost}" type="currency" pattern="#.##" /></td>
              <td><fmt:formatNumber value="${res.planIncome - res.planCost}" type="currency" pattern="#.##" /></td>  
             <td><a href="javascript:void(0)"   onclick="budgetDetail(this,'${res.id }','${res.dateStart}')" class="def">查看</a></td>
             <td><fmt:formatNumber value="${res.sumTotal}" type="currency" pattern="#.##" /></td>
             <td><fmt:formatNumber value="${res.sumCost}" type="currency" pattern="#.##" /></td>
             <td><fmt:formatNumber value="${res.sumTotal - res.sumCost}" type="currency" pattern="#.##" /></td>
             <td><a href="javascript:void(0)"   onclick="constantlyDetail(this,'${res.id }','${res.dateStart}')" class="def">查看</a></td>
        </tr>
			<c:set var="numStock" value="${numStock+res.numStock}" />
			<c:set var="numDisable" value="${numDisable+res.numDisable}" />
			<c:set var="numSold" value="${numSold+res.numSold}" />
			<c:set var="numCancel" value="${numCancel+res.numCancel+res.numClean}" />
			<c:set var="planIncome" value="${planIncome+res.planIncome}" />
			<c:set var="planCost" value="${planCost+res.planCost}" />
			
			<c:set var="sumTotal" value="${sumTotal+res.sumTotal}" />
			<c:set var="sumCost" value="${sumCost+res.sumCost}" />
    </c:forEach>
    </tbody>
    <tfoot>
		<tr class="footer1">
			<td></td>
            <td></td>
 			<td >合计</td>
            <td>${numStock}</td>
            <td>${numDisable}</td>
            <td>${numSold}</td>            
           	<td>${numStock-numSold}</td>
            <td><fmt:formatNumber value="${planIncome}" type="currency" pattern="#.##" /></td>
 			<td><fmt:formatNumber value="${planCost}" type="currency" pattern="#.##" /></td>
            <td><fmt:formatNumber value="${planIncome-planCost}" type="currency" pattern="#.##" /></td>
            <td></td>
            <td><fmt:formatNumber value="${sumTotal}" type="currency" pattern="#.##" /></td> 
            <td><fmt:formatNumber value="${sumCost}" type="currency" pattern="#.##" /></td>
            <td><fmt:formatNumber value="${sumTotal-sumCost}" type="currency" pattern="#.##" /></td>	
            <td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>

<script type="text/javascript">
	function stocklog(obj,resId){
		newWindow("资源销售明细","resTraffic/resDetails.do?resId="+resId);
	}
	
	function budgetDetail(obj,resId,dateStart){
	  	layerInd = layer.open({
			type : 2,
			title : '机票成本明细',
			shadeClose : true,
			shade : 0.5,
			area: ['800px', '500px'],
			content: 'budgetDetail.htm?resId='+resId+ "&dateStart=" + dateStart
		}); 
	}
	
	function constantlyDetail(obj,resId,dateStart){
	  	layerInd = layer.open({
			type : 2,
			title : '机票实时明细',
			shadeClose : true,
			shade : 0.5,
			area: ['800px', '500px'],
			content: 'constantlyDetail.htm?resId='+resId+ "&dateStart=" + dateStart
		}); 
	}
</script>