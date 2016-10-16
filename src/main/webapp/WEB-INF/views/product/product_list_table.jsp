<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="4%"/>
    <col width="4%" />
    <col width="12%"/>
    <col />

    <col width="6%"/>
    <col width="6%"/>
    <col width="6%"/>
    <col width="7%"/>
    <thead>
    <tr>
    
        <th>序号<i class="w_table_split"></i></th>
         <th>ID<i class="w_table_split"></i></th>
        <th>产品编号<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>

        <th>操作员<i class="w_table_split"></i></th>
        <th>计调<i class="w_table_split"></i></th>
        <th>状态<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.result}" var="productInfo" varStatus="status">
        <tr id="${productInfo.id }">
            <td>${status.count}</td>
			<td>${productInfo.id}</td>
            <td>${productInfo.code }</td>
            <td style="text-align:left"> 【${productInfo.brandName }】${productInfo.nameCity }</td>
            <td>${productInfo.creatorName }</td>            
            <td>${productInfo.operatorName }</td>            
            <td>
            	<c:if test="${productInfo.state==2 }"><span class="log_action insert">已上架</span></c:if>
            	<c:if test="${productInfo.state!=2 }"><span class="log_action delete">未上架</span></c:if>
            </td>            
            <td>
            	<a href="javascript:void(0)"
                   <c:if test="${priceMode == 'GROUP_ANGENCY' }">
                   	onclick="newWindow('产品详情', '<%=path%>/productSales/detail.htm?id=${productInfo.id }')"
                   </c:if>
                   <c:if test="${priceMode == 'LOCAL_ANGENCY' }">
                   	onclick="newWindow('产品详情', '<%=path%>/productSales/info.htm?id=${productInfo.id }')"
                   </c:if>
                   class="def">预览</a>
                <c:if test="${optMap['EDIT'] }">
	                <a href="javascript:void(0)" onclick="dataRight(this,'${productInfo.id }')" class="def">权限</a>
                    <a href="javascript:void(0)" onclick="newWindow('编辑产品-${productInfo.nameCity}', '<%=path%>/productInfo/edit.htm?productId=${productInfo.id }')" class="def">编辑</a>
                </c:if>
                &nbsp;<a href="javascript:void(0)" onclick="delProduct(${productInfo.id})" class="def">删除</a>
                <%-- <a href="download.htm?productId=${productInfo.id }" class="def">打印</a> --%>
                <a href="javascript:void(0)" class="def"  id="preview" onclick="toPreview(${productInfo.id })" >导出</a>
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
	function toPreview(productId){
		window.open("<%=path %>/productInfo/productInfoPreview.htm?productId="+productId+"&preview=1");
	}
</script>