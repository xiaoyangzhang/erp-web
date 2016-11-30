<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <col width="8%"/>
    <col width="16%"/>
    <col width="3%"/>
    <col width="7%"/>
    <col width="15%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="6%"/>
    <col width="6%"/>
    <col width="6%"/>
    <col width="9%"/>
    <col />
    <col width="4%"/>
    <thead>
    <tr>
    	<th>序号<i class="w_table_split"></i></th>
        <th>资源名称<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>下载<i class="w_table_split"></i></th>
        <th>出团日期<i class="w_table_split"></i></th>
        <th>交通信息<i class="w_table_split"></i></th>
        <th>待确认<i class="w_table_split"></i></th>
        <th>已确认<i class="w_table_split"></i></th>
        <th>余位<i class="w_table_split"></i></th>
        <th>零售价<i class="w_table_split"></i></th>
         <th>同行价<i class="w_table_split"></i></th>
         <th>代理价<i class="w_table_split"></i></th>
         <th>截止报名时间<i class="w_table_split"></i></th>
        <th>备注<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="trp" varStatus="status">
        <tr id="${trp.id }">
        	<td>${status.count }  </td>
            <td>${trp.resName }  </td>
 			<td style="text-align:left"><a href="javascript:void(0)"onclick="productInfo(${trp.productCode})"class="def">${trp.productName}</a>
 			</td>
 			<td>
	 			<c:if test="${trp.productAttach != '' }">
	 				<a href="javascript:void(0)"  onclick="downloadFile('${config.imgServerUrl}${trp.productAttach }','${trp.productName}');"><span class="ico_down"></span></a>
	 			</c:if>
 			</td>
            <td>${trp.dateStart }</td>
            <td style="text-align:left">${trp.lineInfo}</td>
            <td>${trp.unconfirm }</td>
            <td>${trp.confirm }</td>
       
            <td><fmt:formatNumber value="${trp.numStock }" pattern="#.##"/></td>            
             <td >成人：<fmt:formatNumber value="${trp.adultSuggestPrice }" pattern="#.##"/></br>儿童：<fmt:formatNumber value="${trp.childSuggestPrice }" pattern="#.##"/></br>婴儿：<fmt:formatNumber value="${trp.babySuggestPrice }" pattern="#.##"/></td>
             <td><fmt:formatNumber value="${trp.adultSame}" pattern="#.##"/></br><fmt:formatNumber value="${trp.childSame}" pattern="#.##"/></br><fmt:formatNumber value="${trp.babySame}" pattern="#.##"/></td>    
             <td><fmt:formatNumber value="${trp.adultProxy}" pattern="#.##"/></br><fmt:formatNumber value="${trp.childProxy}" pattern="#.##"/></br><fmt:formatNumber value="${trp.babyProxy}" pattern="#.##"/></td>            
                <td><fmt:parseDate value="${trp.dateLatest}" pattern="yyyy-MM-dd HH:mm:ss" var="date1"></fmt:parseDate>  
            	<fmt:formatDate pattern="yyyy-MM-dd" value="${date1}" /><br/>
            	<fmt:formatDate pattern="HH:mm:ss" value="${date1}" /> </td>
             <td style="text-align:left">${trp.remark} </td>
            <td>
             <c:if test="${trp.operatorId != null}"><a href="javascript:void(0)"onclick="addResOrder(${trp.id})"class="def">下单</a></c:if>
             <c:if test="${trp.operatorId == null}">无操作员</c:if>
            </td>
        </tr>
        <c:set var="numStock" value="${numStock+trp.numStock}" />
    </c:forEach>
    </tbody>
    <tr class="footer1">
        	<td>  </td>
            <td><strong>合计</strong>  </td>
 			<td>  </td>
            <td>  </td>
            <td>  </td>
       		<td>  </td>
       		<td>  </td>
       		<td>  </td>
            <td><strong><fmt:formatNumber value="${numStock}" pattern="#.##"/></strong></td>            
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    <tfoot>
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
		$("#resId").val(resId);
		layerInd = layer.open({
			type : 2,
			title : '资源销售明细',
			shadeClose : true,
			shade : 0.5,
			area: ['500px', '400px'],
			content: 'resDetails.do?resId='+resId
		});
	}
	
	function addResOrder(resId){
		newWindow('新增订单','resTraffic/addResOrder.htm?id='+resId);
	}
	function productInfo(productCode){
		newWindow('产品信息','productSales/info.htm?id='+productCode);
	}
</script>