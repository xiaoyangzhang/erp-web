<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="4%"/>
    <col width="6%"/>
    <col width="12%"/>
    <col width="45%"/>
    <col width="7%"/>
    <col width="7%"/>
    <col width="7%"/>
    <col width="7%"/>
    <col width="5%"/>
    <thead>
    <tr>
    
        <th>序号<i class="w_table_split"></i></th>
         <th>ID<i class="w_table_split"></i></th>
        <th>产品编号<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>来源<i class="w_table_split"></i></th>
        <th>操作员<i class="w_table_split"></i></th>
        <th>计调<i class="w_table_split"></i></th>
        <th>状态<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody class="wtbodys">
    <c:forEach items="${page.result}" var="productInfo" varStatus="status">
        <tr id="${productInfo.id }">
            <td>${status.count}</td>
            <td>${productInfo.id}</td>
            <td>${productInfo.code }</td>
            <td style="text-align:left"> 【${productInfo.brandName }】${productInfo.nameCity }</td>
            <td><c:if test="${productInfo.sourceType==0 }"><span class="log_action insert">自有</span></c:if>
            	<c:if test="${productInfo.sourceType==1 }"><span class="log_action normal">采购</span></c:if>
            </td>  
            <td>${productInfo.creatorName }</td>            
            <td>${productInfo.operatorName }</td>
            <td>
            	<c:if test="${productInfo.state==2 }"><span class="log_action insert">已上架</span></c:if>
            	<c:if test="${productInfo.state!=2 }"><span class="log_action delete">未上架</span></c:if>
            </td>
            <td>
				<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
                    	<a href="javascript:void(0)" class="def aEditRight" onclick="newWindow('编辑产品-${productInfo.id}', '<%=path%>/productInfo/edit.htm?productId=${productInfo.id }')" >编辑</a>
                    	<a href="javascript:void(0)" class="def aEditRight" onclick="newWindow('产品价格组', '<%=path%>/productInfo/price/list.htm?productId=${productInfo.id }')">价格</a>
	                   <c:if test="${productInfo.state== 1 or productInfo.state== 3}">
                    	<a href="javascript:void(0)" onclick="upState(${productInfo.id})" class="def aEditRight">上架</a>
                       </c:if>
                    	<c:if test="${productInfo.state==2}">
                    	<a href="javascript:void(0)" onclick="downState(${productInfo.id})" class="def aEditRight">下架</a>
                    	</c:if>
                		<a href="javascript:void(0)" onclick="delProduct(${productInfo.id})" class="def aEditRight">删除</a>
                	
						<a href="javascript:void(0)"
                   			<c:if test="${priceMode == 'GROUP_ANGENCY' }"> onclick="newWindow('产品详情', '<%=path%>/productSales/detail.htm?id=${productInfo.id }')"</c:if>
                   			<c:if test="${priceMode == 'LOCAL_ANGENCY' }"> onclick="newWindow('产品详情', '<%=path%>/productSales/info.htm?id=${productInfo.id }')" </c:if>
                   		class="def">预览</a> 
						<a href="javascript:void(0)" class="def"  id="preview" onclick="toPreview(${productInfo.id })" > 导出</a>
					</div>
				</div>
				            
            	
                
	                
                
                
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
		$(".aEditRight").css("display", ($("#optEdit").val() == "true"?"":"none"));
	});
	

	function toPreview(productId){
		window.open("productInfoPreview.htm?productId="+productId+"&preview=1");
	}

</script>