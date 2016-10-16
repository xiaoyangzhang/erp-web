<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../../../include/path.jsp" %>


<table cellspacing="0" cellpadding="0" class="w_table" > 
		             	<col width="4%" /><col width="12%" /><col width="5%" /><col width="5%" /><col width="5%" />
		             	<col width="15%" /><col width="15%" /><col width="5%" /><col width="5%" /><col width="5%" /><col width="15%" /><col width="8%" />
			             <thead>
			             	<tr>
			             		<th>序号<i class="w_table_split"></i></th>
			             		<th>团号<i class="w_table_split"></i></th>
			             		<th>出发日期<i class="w_table_split"></i></th>
			             		<th>散团日期<i class="w_table_split"></i></th>
			             		<th>类别<i class="w_table_split"></i></th>
			             		<th>产品名称<i class="w_table_split"></i></th>
			             		<th>组团社<i class="w_table_split"></i></th>
			             		<th>人数<i class="w_table_split"></i></th>
			             		<th>计调<i class="w_table_split"></i></th>
			             		<th>状态<i class="w_table_split"></i></th>
			             		<th >导游安排<i class="w_table_split"></i></th>
			             		<!-- <th>订单数<i class="w_table_split"></i></th> -->
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
				                  <td><fmt:formatDate value="${groupInfo.dateEnd}" pattern="yyyy-MM-dd"/> </td> 
				                  <td><c:if test='${groupInfo.groupMode  <1}'>散客</c:if><c:if test='${groupInfo.groupMode > 0}'>团队</c:if></td>
				                  <td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
				                  <td style="text-align: left">${groupInfo.supplierName}</td> 
				                  <td>${groupInfo.adultCount}大 ${groupInfo.childCount}小 ${groupInfo.guideCount}陪</td> 
				                  <td>${groupInfo.operatorName}</td>
				                  <td>${groupInfo.groupStatus}</td>
				                   <td style="text-align: left">
				                   	<c:if test="${not empty groupInfo.bookSupplierName }">
				                   		 
										 <c:forEach items="${groupInfo.bookSupplierName }" var="guide" varStatus="st">
									 	<c:choose>
									 		<c:when test="${groupInfo.bookSupplierIdArr[st.index]!=null }">
									 		
											<a onclick="newWindow('导游档案','<%=staticPath %>/supplier/guideDetail.htm?id=${groupInfo.bookSupplierIdArr[st.index]}')"
											 href="javascript:void(0);">${guide }</a>
									 		</c:when>
									 		<c:otherwise>${guide }</c:otherwise>
									 	</c:choose>
										 		</c:forEach>
				                   	</c:if>
				                  </td>
				                 <%--  <td>${groupInfo.count}</td> --%>
				                 
				                  <td>
				                  <c:if test="${groupInfo.groupState eq 1}">
				                  
				                  	<c:if test="${optMap['EDIT'] }">
				                  	<a class="def" href="javascript:void(0)" onclick="newWindow('安排导游','<%=staticPath %>/bookingGuide/guideDetailListView.htm?groupId=${groupInfo.groupId }')">安排导游</a>
				                  	</c:if>
				                  	
				                  </c:if>  
				                  	<a class="def" href="javascript:void(0)" onclick="newWindow('查看导游','<%=staticPath %>/bookingGuide/toGuideDetailListView.htm?groupId=${groupInfo.groupId }')">查看</a>
				                  </td>
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
     var trContainer = '<tr ><td colspan="11" id="td_'+groupID+'">'+
   
    +'</td></tr>';
    $(btnObj).closest("tr").after(trContainer);
    vTrObj = $("#td_" + groupID).slideDown();
    
	
    //开始读数据
    //loadGroupElementAjax(vTrObj, groupID);
    loadData("td_"+groupID,groupID);
} 
function loadData(containerId,groupID){
	 $("#"+containerId).load("guideDetailList.htm?groupId="+groupID);
}
</script>
		