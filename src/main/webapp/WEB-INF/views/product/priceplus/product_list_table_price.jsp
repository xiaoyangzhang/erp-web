<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table LgTable">
    <col width="10%"/>
    <col width="40%"/>
    <col width="10%"/>
    <col width="10%"/>
    <col width="10%"/>
    <col width="10%"/>
    <col width="10%"/>
    <thead>
    <tr>
        <th style="width:8%">产品编号<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th style="width:8%">目的地<i class="w_table_split"></i></th>
        <th style="width:6%">价格状态<i class="w_table_split"></i></th>
        <th style="width:8%">线路类型<i class="w_table_split"></i></th>
        <th style="width:8%">操作员<i class="w_table_split"></i></th>
        <th style="width:12%">操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.result}" var="productInfo" varStatus="status">
        <tr id="${productInfo.id }">
            <td>${productInfo.code }</td>
            <td style="text-align:left">
                【${productInfo.brandName }】${productInfo.nameCity }</td>
            <td>${productInfo.destProvinceName }/${productInfo.destCityName }</td>
            <td>${priceStateMap[productInfo.id]}</td>
            <td><c:choose><c:when test="${productInfo.type eq 1}">国内长线</c:when><c:when
                    test="${productInfo.type eq 2}">周边短线</c:when><c:when
                    test="${productInfo.type eq 3}">出境线路</c:when></c:choose></td>
            <td>${productInfo.creatorName }</td>
            <td>
                <a href="javascript:void(0)"
                   onclick="newWindow('产品详情', '<%=path%>/productSales/detail.htm?id=${productInfo.id }')"
                   class="def">预览</a>
                <a href="javascript:void(0)"
                   onclick="newWindow('产品价格组', '<%=path%>/productInfo/price/list.htm?productId=${productInfo.id }')"
                   class="def">价格</a>
                <a href="download.htm?productId=${productInfo.id }" class="def">打印</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
    <jsp:param value="${page.page }" name="p"/>
    <jsp:param value="${page.totalPage }" name="tp"/>
    <jsp:param value="${page.pageSize }" name="ps"/>
    <jsp:param value="${page.totalCount }" name="tn"/>
</jsp:include>  
<script type="text/javascript">
$(function(){
	lgTable(1680);
})
</script>