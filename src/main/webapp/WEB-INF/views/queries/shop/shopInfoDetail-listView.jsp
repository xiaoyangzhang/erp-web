<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../../../include/path.jsp" %>


<table cellspacing="0" cellpadding="0" class="w_table" >
<col width="7%" /><col width="7%" /><col width="7%" /><col width="7%" />
<col width="7%" /><col width="18%" /><col width="7%" /><col width="7%" /><col width="5%" /><col width="5%" /><col width="7%" />
	<thead>
	<tr>
		<th>序号<i class="w_table_split"></i></th>
		<th>团号<i class="w_table_split"></i></th>
		<th>计调<i class="w_table_split"></i></th>
		<th>导管<i class="w_table_split"></i></th>
		<th>导游<i class="w_table_split"></i></th>
		<th>购物店名称<i class="w_table_split"></i></th>
		<th>进店日期<i class="w_table_split"></i></th>
		<th>进店人数<i class="w_table_split"></i></th>
		<th>客源地<i class="w_table_split"></i></th>
		<th>返款单价<i class="w_table_split"></i></th>
		<th>返款合计<i class="w_table_split"></i></th>
		<th>计划销售</th>
		<th>实际销售</th>
		<th>差额/完成率</th>
		<th>人均购物</th>
		<th>返款金额</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach items="${page.result}" var="shopInfo" varStatus="status">
		<tr>
			<td class="serialnum">
				<div class="serialnum_btn" id="${shopInfo.id}"></div>
					${status.index+1}
			</td>
			<td>
			 <c:choose>
				                  		<c:when test="${shopInfo.groupMode > 0}">
				                  		
				                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/tourGroup/toAddTourGroupOrder.htm?groupId=${shopInfo.groupId }&operType=0')">${shopInfo.groupCode}</a></td> 
				                  		</c:when>
				                  		<c:otherwise>
								 <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/groupOrder/toFitEdit.htm?groupId=${shopInfo.groupId}&operType=0')">${shopInfo.groupCode}</a></td> 
				                  		
				                  		</c:otherwise>
				                  	</c:choose>
				                  	
			
			
			</td>
			<td>${shopInfo.operatorName}</td>
			<td>${shopInfo.userName}</td>
			<td>${shopInfo.guideName}</td>
			<td>${shopInfo.supplierName}</td>
			<td><fmt:formatDate value="${shopInfo.shopDate}" pattern="yyyy-MM-dd"/></td>
			<td>${shopInfo.personNum}</td>
			<td>
			<c:if test="${ shopInfo.groupOrders[0].orderType eq 1}">
			${shopInfo.groupOrders[0].provinceName}${shopInfo.groupOrders[0].cityName}
			</c:if>
			</td>
			<td><fmt:formatNumber type="number"  value="${shopInfo.personRepayPrice*shopInfo.personNum}" pattern="0.00#" /></td>
			<td><fmt:formatNumber type="number"  value="${shopInfo.personRepayPrice}" pattern="0.00#" /></td>
			<td><fmt:formatNumber type="number"  value="${shopInfo.jhSales}" pattern="0.00#" /></td>
			<td><fmt:formatNumber type="number"  value="${shopInfo.totalFace}" pattern="0.00#" /></td>
			<td><fmt:formatNumber type="number"  value="${shopInfo.totalFace-shopInfo.jhSales}" pattern="0.00#" /><br>
				<c:if test="${shopInfo.jhSales!='0.0000'}">
					<fmt:formatNumber type="number"  value="${shopInfo.totalFace/shopInfo.jhSales*100}" pattern="0.00#" />%
				</c:if>
				<c:if test="${shopInfo.jhSales=='0.0000'}">
	          					<fmt:formatNumber type="number" value="0" pattern="0.00#" />%
	          				</c:if>
			</td>
			<td>
			<c:choose>
			<c:when test="${shopInfo.personNum ne 0 and shopInfo.totalFace ne 0.0000 }">
			<fmt:formatNumber type="number"  value="${shopInfo.totalFace/shopInfo.personNum}" pattern="#.##" /></c:when>
			<c:otherwise><fmt:formatNumber type="number" value="0" pattern="#.##" /></c:otherwise>
			</c:choose>
			</td>
			<td><fmt:formatNumber type="number"  value="${shopInfo.totalRepay}" pattern="0.00#" /></td>

		</tr>
	</c:forEach>
	</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">


	$(".serialnum div").bind("click", function(){

		divExpand(this, $(this).attr("id"));
	});
	var divExpand = function (btnObj, id) {
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
		var trContainer = '<tr ><td colspan="12" id="td_'+id+'">'+

				+'</td></tr>';
		$(btnObj).closest("tr").after(trContainer);
		vTrObj = $("#td_" + id).slideDown();


		//开始读数据
		//loadGroupElementAjax(vTrObj, groupID);
		loadData("td_"+id,id);
	}
	function loadData(containerId,id){
		$("#"+containerId).load("shopDetailList.htm?id="+id);

	}

</script>
		