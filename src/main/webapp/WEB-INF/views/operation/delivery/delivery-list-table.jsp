<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/path.jsp"%>
    <table cellspacing="0" cellpadding="0" class="w_table" > 
	<col width="5%" /><col width="10%" /><col width="8%" /><col width="5%" /><col width="" />
	<col width="15%" /><col width="5%" /><col width="5%" /><col width="8%" /><col width="5%" />
	<col width="5%" /><c:if test="${optMap['EDIT'] }"><col width="5%" /></c:if>
          <thead>
          	<tr>
          		<th>序号<i class="w_table_split"></i></th>
          		<th>团号<i class="w_table_split"></i></th>
          		<th>出发日期<i class="w_table_split"></i></th>
          		<th>类别<i class="w_table_split"></i></th>
          		<th>产品名称<i class="w_table_split"></i></th>
          		<th>组团社<i class="w_table_split"></i></th>
          		<!-- <th>下接社<i class="w_table_split"></i></th> -->
          		<th>人数<i class="w_table_split"></i></th>
          		<th>计调<i class="w_table_split"></i></th>
          		<th>状态<i class="w_table_split"></i></th>
          		<th>订单数<i class="w_table_split"></i></th>
          		<th>总金额<i class="w_table_split"></i></th> 
          		<c:if test="${optMap['EDIT'] }">         		
          		<th>操作</th>
          		</c:if>
          	</tr>
          </thead>
          <tbody> 
          	<c:forEach items="${pageBean.result}" var="groupInfo" varStatus="status">
             <tr> 
	              <td class="serialnum">
	              	<div class="serialnum_btn" groupId="${groupInfo.groupId }"></div>
	                ${status.count }	                	
	              </td>
	              <td style="text-align: left">
	              <c:choose>
                  		<c:when test="${groupInfo.groupMode < 1}">
                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','<%=ctx %>/fitGroup/toFitGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td>
                  		</c:when>
                  		<c:otherwise>
				 			<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=ctx %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${groupInfo.groupId }&operType=0')">${groupInfo.groupCode}</a></td> 
                  		</c:otherwise>
                  	</c:choose>
	              </td> 
                  <td><fmt:formatDate value="${groupInfo.dateStart}" pattern="yyyy-MM-dd"/> </td> 
                  <td><c:if test='${groupInfo.groupMode < 1}'>散客</c:if><c:if test='${groupInfo.groupMode > 0}'>团队</c:if></td>
                  <td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
                  <td style="text-align: left">${groupInfo.supplierName}</td> 
                  <td>${groupInfo.adultCount}大${groupInfo.childCount}小${groupInfo.guideCount}陪</td> 
                  <td>${groupInfo.operatorName}</td>
                  <td>${groupInfo.groupStatus}</td>
                  <td>${groupInfo.count}</td>
                  <td><fmt:formatNumber value="${groupInfo.price}" pattern="#.##" type="currency"/></td>
                  <c:if test="${optMap['EDIT'] }">
	                  <td>
	                  	<c:if test="${groupInfo.groupState eq 1 }">
	               			<a class="def"  href="javascript:void(0)" onclick="newWindow('新增下接社','<%=staticPath %>/booking/delivery.htm?gid=${groupInfo.groupId }')">新增</a>
	                  	</c:if>
	                  </td>
                  </c:if>                  
             </tr>
             <c:set var="sum_adult" value="${sum_adult+groupInfo.adultCount }" />
             <c:set var="sum_child" value="${sum_child+groupInfo.childCount }" />
             <c:set var="sum_guide" value="${sum_guide+groupInfo.guideCount }" />
             <c:set var="sum_order_cnt" value="${sum_order_cnt+groupInfo.count }" />
             <c:set var="sum_price" value="${sum_price+groupInfo.price }" />
          </c:forEach>
          <tr>
          	<td colspan="6" style="text-align:right;">合计</td>
          	<td>${sum_adult }大${sum_child }小${sum_guide }陪</td>
          	<td></td>
          	<td></td>
          	<td>${sum_order_cnt }</td>
          	<td><fmt:formatNumber value="${sum_price}" pattern="#.##" type="currency"/></td>
          	<td></td>
          </tr>
   	</tbody>
</table>
<div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">
	$(function(){
		$(".serialnum div").bind("click", function(){
			divExpand(this, $(this).attr("groupId"));
		});
		
		var divExpand = function (btnObj, groupID) {
	        //切换 (展开/收缩)小图标
	        var cssName = $(btnObj).attr("class") == "serialnum_btn" ? "serialnum_btn2" : "serialnum_btn";
	        $(btnObj).attr("class", cssName);
	        //收起来
	        if (cssName == "serialnum_btn") {
	            $("#td_" + groupID).parent().slideUp().hide();
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
	 
		 function loadData(containerId,gid){
			 $("#"+containerId).load("deliveryBookingList.htm?gid="+gid);
		 }
	})
	
</script>
