<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="3%"/>
    <col width="10%"/>
    <col width="20%"/>
   <%--  <col width="10%"/>
    <col width="10%"/> --%>
    <col width="5%"/>
    <col width="5%"/>
    <col width="7%"/>
    <thead>
    <tr>
        <th >序号<i class="w_table_split"></i></th>
        <th >产品编号<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
       <!--  <th style="width:8%">目的地<i class="w_table_split"></i></th>
        <th style="width:6%">价格状态<i class="w_table_split"></i></th>
        <th style="width:8%">线路类型<i class="w_table_split"></i></th> -->
        <th >操作员<i class="w_table_split"></i></th>
        <th >计调<i class="w_table_split"></i></th>
        <th >操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.result}" var="productInfo" varStatus="status">
        <tr id="${productInfo.id }">
            <td>${status.count }</td>
            <td>${productInfo.code }</td>
            <td style="text-align:left">
                【${productInfo.brandName }】${productInfo.nameCity }</td>
           <%--  <td>${productInfo.destProvinceName }/${productInfo.destCityName }</td>
            <td>${priceStateMap[productInfo.id]}</td>
            <td><c:choose><c:when test="${productInfo.type eq 1}">国内长线</c:when><c:when
                    test="${productInfo.type eq 2}">周边短线</c:when><c:when
                    test="${productInfo.type eq 3}">出境线路</c:when></c:choose></td> --%>
            <td>${productInfo.creatorName }</td>
            <td>${productInfo.operatorName }</td>
            <td>
                <a href="javascript:void(0)"
                   <c:if test="${priceMode == 'GROUP_ANGENCY' }">
                   	onclick="newWindow('产品详情', '<%=path%>/productSales/detail.htm?id=${productInfo.id }')"
                   </c:if>
                   <c:if test="${priceMode == 'LOCAL_ANGENCY' }">
                   	onclick="newWindow('产品详情', '<%=path%>/productSales/info.htm?id=${productInfo.id }')"
                   </c:if>
                   class="def">预览</a>
                    <c:if test="${productInfo.state== 1}">
                    	<a href="javascript:void(0)" onclick="upState(${productInfo.id})" class="def">上架</a>
                    </c:if>
                    <c:if test="${productInfo.state==2}">
                    	<a href="javascript:void(0)" onclick="downState(${productInfo.id})" class="def">下架</a>
                    </c:if>
                    <c:if test="${productInfo.state==3}">
                    	<a href="javascript:void(0)" onclick="upState(${productInfo.id})" class="def">上架</a>&nbsp;</c:if>
                <a href="javascript:void(0)" class="def"  id="preview" onclick="toPreview(${productInfo.id })" >
											导出</a>
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
		fixHeader();
	})
</script>