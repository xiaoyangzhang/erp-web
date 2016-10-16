<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../../../include/path.jsp" %>

<table cellspacing="0" cellpadding="0" class="w_table" >
	<col width="3%" /><col width="14%" /><col width="8%" /><col width="4%" /><col width="15%" />
	<col width="13%" /><col width="7%" /><col width="7%" /><col width="6%" /><col width="5%" /><col width="5%" />
	<col width="3%" /><col width="10%" />
	<thead>
	<tr>
		<th>序号<i class="w_table_split"></i></th>
		<th>团号<i class="w_table_split"></i></th>
		<th>出发日期<i class="w_table_split"></i></th>
		<th>类别<i class="w_table_split"></i></th>
		<th>产品名称<i class="w_table_split"></i></th>
		<th>组团社<i class="w_table_split"></i></th>
		<th>导管<i class="w_table_split"></i></th>
		<th>导游<i class="w_table_split"></i></th>
		<th>人数<i class="w_table_split"></i></th>
		<th>计调<i class="w_table_split"></i></th>
		<th>状态<i class="w_table_split"></i></th>
		<th>订单数<i class="w_table_split"></i></th>
		<th>操作</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach items="${page.result}" var="groupInfo" varStatus="status">
		<tr>
			<td class="serialnum">
				<div class="serialnum_btn" groupId="${groupInfo.groupId}"></div>
					${status.index+1}
			</td>
			<td style="text-align: left;" >
              	<c:if test="${groupInfo.groupMode>0}">
              		<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td> 
				</c:if>
				<c:if test="${groupInfo.groupMode<=0}">
					<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td>
				</c:if>
			</td>
			<td><fmt:formatDate value="${groupInfo.dateStart}" pattern="yyyy-MM-dd"/> </td>
			<td><c:if test='${groupInfo.groupMode  <1}'>散客</c:if><c:if test='${groupInfo.groupMode > 0}'>团队</c:if></td>
			<td style="text-align: left;" >【${groupInfo.productBrandName}】${groupInfo.productName}</td>
			<td style="text-align: left;">${groupInfo.supplierName}</td>
			<td style="text-align: left;">
				${groupInfo.userNames }
			</td>
			<td style="text-align: left;">
				${groupInfo.guideNames }
			</td>
			<td><%-- ${groupInfo.personCount} --%>
				${groupInfo.adultCount}大 ${groupInfo.childCount}小${groupInfo.guideCount}陪
			</td>
			<td>${groupInfo.operatorName}</td>
			<td>${groupInfo.groupStatus}</td>
			<td>${groupInfo.count}</td>
			<td><c:if test="${groupInfo.groupState ne 0 }">
				<a class="def" href="javascript:void(0)" onclick="newWindow('新增购物','<%=staticPath %>/bookingFinanceShop/toAddShop.htm?groupId=${groupInfo.groupId }&type=1')">新增</a>
				</c:if>
				<a class="def" href="javascript:void(0)" onclick="newWindow('查看购物','<%=staticPath %>/bookingFinanceShop/bookingShopView.htm?groupId=${groupInfo.groupId }&type=0')">查看</a>
				<c:if test="${groupInfo.groupState ne 0 }">
				<a class="def" href="javascript:void(0)" onclick="newWindow('佣金发放录入','<%=staticPath %>/finance/guide/addCommission.htm?groupId=${groupInfo.groupId }')">发放佣金</a>
				<a class="def" href="javascript:void(0)" onclick="newWindow('佣金扣除录入','<%=staticPath %>/finance/guide/addCommissionDeduction.htm?groupId=${groupInfo.groupId }')">扣除佣金</a>
				</c:if>
			</td>
		</tr>
		<c:set var="sum_adultCount" value="${sum_adultCount+groupInfo.adultCount }" />
		<c:set var="sum_childCount" value="${sum_childCount+groupInfo.childCount }" />
		<c:set var="sum_guideCount" value="${sum_guideCount+groupInfo.guideCount }" />
		<c:set var="sum_count" value="${sum_count+groupInfo.count }" />
	</c:forEach>
		<tr>
			<td colspan="8">合计：</td>
			<td>${sum_adultCount}大 ${sum_childCount}小${sum_guideCount}陪</td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_count}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="8">总合计：</td>
			<td>${bookingGroup.adultCount}大 ${bookingGroup.childCount}小${bookingGroup.guideCount}陪</td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${bookingGroup.count}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
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

		divExpand(this, $(this).attr("groupId"));
	});
	var divExpand = function (btnObj, groupID) {
		//切换 (展开/收缩)小图标
		var cssName = $(btnObj).attr("class") == "serialnum_btn" ? "serialnum_btn2" : "serialnum_btn";
		$(btnObj).attr("class", cssName);

		//收起来
		if (cssName == "serialnum_btn") {
			$("#td_" + groupID).parent().slideUp().remove();
			return;
		}else{
			//如果已经加载过数据则不再重复请求，直接展开
			if($("#td_" + groupID).length>0){
				$("#td_" + groupID).parent().slideDown().show();
				return;
			}
		}

		//展开 
		var trContainer = '<tr ><td colspan="12" id="td_'+groupID+'">'+

				+'</td></tr>';
		$(btnObj).closest("tr").after(trContainer);
		vTrObj = $("#td_" + groupID).slideDown();


		//开始读数据
		//loadGroupElementAjax(vTrObj, groupID);
		loadData("td_"+groupID,groupID);
	}
	function loadData(containerId,groupID){
		$("#"+containerId).load("shopDetailList.htm?groupId="+groupID);

	}

</script>
		