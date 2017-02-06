<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
String staticPath = request.getContextPath();
%>

<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="3%"/>
    <col width="20%"/>
    <col width="27%"/>
    <col width="20%"/>
    <col width="13%"/>
    <col width="10%"/>
    <col width="7%"/>
    <thead>
    <tr>
        <th>序号<i class="w_table_split"></i></th>
        <th>自编码<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>套餐名称<i class="w_table_split"></i></th>
        <th>库存名称<i class="w_table_split"></i></th>
        <th>店铺<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody class="wtbodys">
    <c:forEach items="${page.result}" var="list" varStatus="status">
        <tr id="${list.proId }">
            <td>${status.count}</td>
            <td>${list.outerId }</td>
            <td style="text-align:left">
                    ${list.title }</td>
            <td style="text-align:left">
                    ${list.pidName }</td>
            <td style="text-align:left">
                    ${list.stockName }</td>
            <td><c:if test="${list.myStoreId=='AY'}">爱游</c:if>
                <c:if test="${list.myStoreId=='YM'}">怡美</c:if>
                <c:if test="${list.myStoreId=='JY'}">景怡</c:if>
                <c:if test="${list.myStoreId=='TX'}">天翔</c:if>
                <c:if test="${list.myStoreId=='OUTSIDE'}">出境店</c:if></td>
            <td><c:if test="${list.myStoreId !='' && list.numIid > 0 }"><a href="javascript:void(0);" onclick="syncSKU(this,${list.numIid},${list.proId },'${list.myStoreId}')" class="def">同步套餐</a></c:if>
                <c:if test="${list.numIid == 0 }"><a href="javascript:void(0);" onclick="AddBtn(${list.tpsId})" class="def">编辑</a></c:if>
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
    function syncSKU(input,numIid,proId,myStoreId){
        $.getJSON("../taobaoProect/syncProductSku.do?numIid=" + numIid+"&productId="+proId+"&myStoreId="+myStoreId, function(data) {
            if (data.success) {
                $.success('操作成功',function(){
                    searchBtn();
                });
            }else{
                $.info('操作取消！');
            }
        });
    }
</script>