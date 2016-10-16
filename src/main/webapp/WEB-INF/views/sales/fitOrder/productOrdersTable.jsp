<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp" %>
<table class="w_table" style="margin-left: 0px">
	<colgroup> 
		<col width="5%"/>
		<col width="10%"/>
		<col width="44%"/>
		<col width="7%"/>
		<col width="7%"/>
		<col width="7%"/>
		<col width="10%"/>
		<col width="10%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>订单数<i class="w_table_split"></i></th>
			<th>成人<i class="w_table_split"></i></th>
			<th>儿童<i class="w_table_split"></i></th>
			<th>合计金额<i class="w_table_split"></i></th>
			<th>平均金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${orders}" var="gl" varStatus="v">
       		<tr>
       			<td class="serialnum">
       				<div class="serialnum_btn" id="${v.count}" productId="${gl.productId}" departureDate="${gl.departureDate}"></div>
       				${v.count}
       			</td>
       			<td>${gl.departureDate }</td>
       			<td style="text-align: left">【${gl.productBrandName}】${gl.productName }</td>
       			<td>${gl.totalOrderNum }</td>
       			<td>${gl.totalNumAdult }</td>
       			<td>${gl.totalNumChild }</td>
       			<td>
       				<c:if test="${gl.totalOrderIncome!=''}">
       					<fmt:formatNumber type="percent" value="${gl.totalOrderIncome}" pattern="#.##"></fmt:formatNumber>
       				</c:if>
       			</td>
       			<td>
       				<c:if test="${gl.totalOrderIncome!=''}">
	       				<c:if test="${gl.totalNumAdult+gl.totalNumChild!=0}">
	       					<fmt:formatNumber type="percent" value="${gl.totalOrderIncome/(gl.totalNumAdult+gl.totalNumChild)}" pattern="#.##"></fmt:formatNumber>
	       				</c:if>
	       			</c:if>
       			</td>
         	</tr>
         	<div id="htmlCon">
				
			</div>
			
         	<c:set var="sum_adult" value="${sum_adult+gl.totalNumAdult}" />
			<c:set var="sum_child" value="${sum_child+gl.totalNumChild}" />
			<c:set var="sum_order" value="${sum_order+gl.totalOrderNum}" />
			<c:set var="sum_total" value="${sum_total+gl.totalOrderIncome}" />
       	</c:forEach>
	</tbody>
		<tr>
			<td></td>
			<td></td>
			<td style="text-align: right">当前页合计：</td>
			<td>${sum_order}</td>
			<td>${sum_adult}</td>
			<td>${sum_child}</td>
			<td>
				<c:if test="${sum_total!=''}">
					<fmt:formatNumber type="percent" value="${sum_total}" pattern="#.##"></fmt:formatNumber>
				</c:if>
			<td>
				<c:if test="${sum_total!=''}">
					<c:if test="${(sum_adult+sum_child+sum_guide)!=0 and (sum_adult+sum_child+sum_guide)!='' }">
						<fmt:formatNumber type="percent" value="${sum_total/(sum_adult+sum_child+sum_guide)}" pattern="#.##"></fmt:formatNumber>
					</c:if>
				</c:if>
			</td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td style="text-align: right">总合计：</td>
			<td>${totalOrder}</td>
			<td>${totalAdult}</td>
			<td>${totalChild}</td>
			<td>
				<c:if test="${totalSum!=''}">
					<fmt:formatNumber type="percent" value="${totalSum}" pattern="#.##"></fmt:formatNumber>
				</c:if>
			<td>
				<c:if test="${totalSum!=''}">
					<c:if test="${(totalAdult+totalChild)!=0 and (totalAdult+totalChild)!='' }">
						<fmt:formatNumber type="percent" value="${totalSum/(totalAdult+totalChild)}" pattern="#.##"></fmt:formatNumber>
					</c:if>
				</c:if>
			</td>
		</tr>
	
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">
$(".serialnum div").bind("click", function(){
	divExpand(this, $(this).attr("id"),$(this).attr("productId"),$(this).attr("departureDate"));
});
var divExpand = function (btnObj,id,productId,departureDate) {
    //切换 (展开/收缩)小图标
    var cssName = $(btnObj).attr("class") == "serialnum_btn" ? "serialnum_btn2" : "serialnum_btn";
    $(btnObj).attr("class", cssName);
    //收起来
    if (cssName == "serialnum_btn") {
        $("#td_" + id).parent().slideUp().remove();
        return;
    }else{
    	//如果已经加载过数据则不再重复请求，直接展开
    	if($("#td_" + id).length>0){
    		$("#td_" + id).parent().slideDown().show();
    		return;
    	}
    }

    //展开 
     var trContainer = '<tr ><td style="padding: 8px 8px"  colspan="8" id="td_'+id+'">'+
   
    +'</td></tr>';
    $(btnObj).closest("tr").after(trContainer);
    vTrObj = $("#td_" + id).slideDown();
    //开始读数据
    //loadGroupElementAjax(vTrObj, groupID);
    loadData("td_"+id,productId,departureDate);
}
function loadData(containerId,productId,departureDate){
	$("#"+containerId).load("../groupOrder/getFitOrderListData.do?productId="+productId+"&departureDate="+departureDate);
}
</script>
