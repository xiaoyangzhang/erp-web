<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String path = request.getContextPath();
%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date now_date = new Date();
	String times = sdf.format(now_date);
	pageContext.setAttribute("times", times);
	
%>
<style type="text/css">
#style_method{
	text-align: left;
}
#pro_brand_name_id{
	color: #0088cc;
}
</style>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%"/>
	<col width="6%"/>
    <col width="16%"/>
    <col width="6%"/>
    <col width="5%"/>
    <col width="5%"/>
    
    <col width="7%"/>
    
    <col width="5%"/>
    <col width="5%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    
    <col width="4%"/>
    <col width="4%"/>
    <col width="8%"/>
    <col width="10%"/>
    <col width="5%"/>

	<thead>
		<tr>
			<th>序号</th>
			<th>订单号</th>
			<th>产品名称</th>
			<th>出团日期</th>
			<th>预留</th>
			<th>下单员</th>
			
			<th>接站牌</th>
			
			<th>人数</th>
			<th>金额</th>
			<th>定金</th>
			<th>已付</th>
			<th>尾款</th>
			
			<th>订单</th>
			<th>占位</th>
			<th>预留时长</th>
			<th>订单备注</th>
			<th>操作</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="resOrder" varStatus="status">
        <tr id="${res.id }">
            <td>${status.index+1 }</td>
            <td>${resOrder.orderNo }</td> 
            <td style="text-align:left;">
            	<span>【${resOrder.productBrandName }】</span><br/>
            	${resOrder.productName }
            </td>
            <td>${resOrder.departureDate }</td>
            <td>
            <c:choose>
            	<c:when test="${resOrder.extResState  =='1'}"></c:when>
            	<c:otherwise>
            		${resOrder.type == '1'?"":"<span class='log_action delete'>是</span>" }
            	</c:otherwise>
            </c:choose>
            </td>
            <td>${resOrder.creatorName }</td>
            <td  style="text-align:left;">${resOrder.receiveMode }</td>
            <td>${resOrder.numAdult }+${resOrder.numChild }+${resOrder.numChildBaby }</td>
            <td><fmt:formatNumber value="${resOrder.total }" pattern="#.##"/></td>
            <td> <fmt:formatNumber value="${resOrder.extResPrepay }" pattern="#.##"/></td>
            <td> <fmt:formatNumber value="${resOrder.totalCash }" pattern="#.##"/></td>
            <td><fmt:formatNumber value="${resOrder.total-resOrder.totalCash }" pattern="#.##"/></td>
            <td>
            <c:choose>
            	<c:when test="${resOrder.extResState =='0'}">
            		 <span class='log_action update'>待确认</span>
            	</c:when>
            	<c:when test="${resOrder.extResState  =='1'}">
            		<span class='log_action insert'>已确认</span>
            	</c:when>
            	<c:when test="${resOrder.extResState  =='2'}">
            		<span class='log_action delete'>已取消</span>
            	</c:when>
            	<c:otherwise>
            		<span class='log_action delete'>已清位</span>
            	</c:otherwise>
            </c:choose>
            </td>
            <td>
            <c:choose>
            	<c:when test="${resOrder.extResState =='0'}">
            		 <span class='log_action normal'>占位</span>
            	</c:when>
            	<c:when test="${resOrder.extResState  =='1'}">
            		<span class='log_action normal'>占位</span>
            	</c:when>
            	<c:when test="${resOrder.extResState  =='2'}">
            		<span class='log_action update'>退还</span>
            	</c:when>
            	<c:otherwise>
            		<span class='log_action delete'>清位</span>
            	</c:otherwise>
            </c:choose>
            </td>
            <td>
            	<c:if test="${resOrder.extResCleanTime != 0  && resOrder.extResState =='0'}">
            		<fmt:parseDate value="${resOrder.limitTime}" pattern="yyyy-MM-dd HH:mm:ss" var="date1"></fmt:parseDate>  
	            	<fmt:formatDate pattern="yyyy-MM-dd" value="${date1}" /><br/>
	            	<fmt:formatDate pattern="HH:mm:ss" value="${date1}" />
            		<c:if test="${times>resOrder.limitTime }">
		            	<span style='color:red'>超时</span>
		        	</c:if>
		        </c:if>
            </td>
            <td style="text-align:left;">${resOrder.remark }<span style="color:red;">${resOrder.remarkInternal }</span></td>            
            <td>
            	<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
						<a href="javascript:queryOrder(${resOrder.id });" class="def">查看订单</a>
						<c:choose>
			            	<%-- <c:when test="${resOrder.extResState  =='2'}">
			            		 <a href="javascript:void(0)"onclick="toDeleteOrderDatil(${resOrder.id})"class="def">删除订单</a>
			            	</c:when> --%>
			            	<c:when test="${resOrder.extResState  =='0'}">
			            		<a href="javascript:void(0)"onclick="toProductOrderDatil(${resOrder.id})"class="def">修改订单</a>
				                
				                <c:if test="${resOrder.totalCash <=0}">
				                	<a href="javascript:goOrder(${resOrder.id });" class="def">取消订单</a>
				                </c:if>
				                <%-- <a href="javascript:void(0)"onclick="toDeleteOrderDatil(${resOrder.id})"class="def">删除订单</a> --%>
			            	</c:when>
			            </c:choose>
			            <a href="javascript:void(0)" class="def" onclick="paymentLog(${resOrder.id})" >收款日志</a>
				        <a href="javascript:void(0)" class="def" onclick="goLogStock(${resOrder.id})" >操作日志</a>
					</div>
				</div>
            </td>
        </tr>  
        	<c:set var="numAdult" value="${numAdult+resOrder.numAdult}" />
        	<c:set var="numChild" value="${numChild+resOrder.numChild}" />
        	<c:set var="numChildBaby" value="${numChildBaby+resOrder.numChildBaby}" />
        	<c:set var="rtotal" value="${rtotal+resOrder.total}" />
        	<c:set var="rextResPrepay" value="${rextResPrepay+resOrder.extResPrepay}" />
			<c:set var="rtotalCash" value="${rtotalCash+resOrder.totalCash}" />
			<c:set var="rbalance" value="${rbalance+(resOrder.total-resOrder.totalCash)}" />
    </c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
 			<td colspan="7" style="text-align: right;">页合计</td>
            <td>${numAdult}+${numChild}+${numChildBaby}</td>
            <td><fmt:formatNumber value="${rtotal}" pattern="#.##" type="currency"/></td>
            <td><fmt:formatNumber value="${rextResPrepay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${rtotalCash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${rbalance}" pattern="#.##" type="currency"/></td>  
            <td></td>   
            <td></td>   
            <td></td>
            <td></td>
            <td></td>			
		</tr>
		<tr class="footer2">
 			<td colspan="7" style="text-align: right">总合计</td>
            <td>${sum.numAdult}+${sum.numChild}+${sum.numChildBaby}</td>
            <td><fmt:formatNumber value="${sum.total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum.extResPrepay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum.totalCash}" pattern="#.##" type="currency"/></td>  
            <td><fmt:formatNumber value="${sum.total-sum.totalCash}" pattern="#.##" type="currency"/></td>   
            <td></td>   
            <td></td>
            <td></td>
            <td></td>
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
	/* 订单详情 */
	function toProductOrderDatil(obj){
		newWindow('订单详情','<%=path%>/resTraffic/editResOrder.htm?id='+obj)
	}
	
	/* 取消订单 */
	function goOrder(obj){
		layer.open({
			type : 2,
			title : '取消订单',
			shadeClose : true,
			shade : 0.5,
			area: ['460px', '350px'],
			content: '<%=path%>/resOrder/toCancelOrder.do?id='+obj
		
		});
	}
	
	function queryOrder(obj){
		newWindow('订单详情','<%=path%>/resTraffic/editResOrder.htm?id='+obj+'&see='+1)
	}
	
<%-- 	function toDeleteOrderDatil(obj){
		$.ajax({
			type : "post",
			url : "<%=path%>/resOrder/toDeleteOrderInfo.do",
			data:{id:obj},
			dataType : "json",
			success : function(data) {
				if (data && data.success == '1') {
					//刷新页面
					location.reload();
				}
			},
			error : function() {
				alert('系统异常，请与管理员联系');
			}
		});
	} --%>
	
	function paymentLog(obj){
		layer.open({
			type : 2,
			title : '收款日志',
			shadeClose : true,
			shade : 0.5,
			area: ['480px', '380px'],
			content: '<%=path%>/resTraffic/receivablesRecord.htm?id='+obj
		});
	}
</script>













