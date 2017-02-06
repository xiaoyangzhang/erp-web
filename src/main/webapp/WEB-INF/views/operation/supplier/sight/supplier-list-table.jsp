<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 <%@ include file="../../../../include/path.jsp" %>

 <dl class="p_paragraph_content">
	    		<dd>
    			 <div class="pl-10 pr-10" >
                     <table cellspacing="0" cellpadding="0" class="w_table" > 
		             	<col width="5%" /><col width="15%" /><col width="6%" /><col width="5%" /><col width="15%" />
		             	<col width="15%" /><col width="8%" /><col width="5%" /><col width="5%" /><col width="12%" /><col width="5%" />
			             <thead>
			             	<tr>
			             		<th>序号<i class="w_table_split"></i></th>
			             		<th>团号<i class="w_table_split"></i></th>
			             		<th>出发日期<i class="w_table_split"></i></th>
			             		<th>类别<i class="w_table_split"></i></th>
			             		<th>产品名称<i class="w_table_split"></i></th>
			             		<th>组团社<i class="w_table_split"></i></th>
			             		<th>人数<i class="w_table_split"></i></th>
			             		<th>计调员<i class="w_table_split"></i></th>
			             		<th>状态<i class="w_table_split"></i></th>
			             		<!-- <th>订单数<i class="w_table_split"></i></th>
			             		<th>总金额<i class="w_table_split"></i></th> -->
			             		<th>景点<i class="w_table_split"></i></th>
			             		<th>操作</th>
			             	</tr>
			             </thead>
			             <tbody> 
			              <c:forEach items="${pageBean.result}" var="groupInfo" varStatus="status">
			              	  <tr> 
			                  	  <td class="serialnum">
				                  		<div class="serialnum_btn" groupId="${groupInfo.groupId}" ></div>
				                  		${status.index+1}
				                  		<%-- <input type="hidden" value="${ supplierType}"  id="supplierType"/> --%>
				                  		
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
				                  <td><c:if test='${groupInfo.groupMode  <1}'>散客</c:if><c:if test='${groupInfo.groupMode > 0}'>团队</c:if></td>
				                  <td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
				                  <td style="text-align: left">${groupInfo.supplierName}</td>
				                  
				                   <td><c:if test="${not empty groupInfo.adultCount }">${groupInfo.adultCount}大</c:if>
				                  <c:if test="${not empty groupInfo.childCount }">${groupInfo.childCount}小</c:if>
				                  <c:if test="${not empty groupInfo.guideCount }">${groupInfo.guideCount}陪</c:if></td> 
				                  <td>${groupInfo.operatorName}</td>
				                  <td>${groupInfo.groupStatus}</td>
				                  <%-- <td>${groupInfo.count}</td>
				                  <td style="text-align: left">
				                  	
				                  	<c:choose>
				                  		<c:when test="${groupInfo.price eq null }">0</c:when>
				                  		<c:otherwise>
				                  		
				                  <fmt:formatNumber value="${groupInfo.price }" type="currency" pattern="#.##"/></td>
				                  		</c:otherwise>
				                  	</c:choose>
				                  	
				                  <td > --%>
				                  	<td style="text-align: left">
				                  <c:if test="${groupInfo.bookSupplierName!=null }">
				                  ${fn:replace(groupInfo.bookSupplierName,',','</br>') }
				                  	 
				                  	</c:if>
				                  </td> 
				                  	<td>
				                  	<c:if test="${groupInfo.groupState eq 1}">
				                  			<c:if test="${optMap['EDIT'] }">
				                  			<a class="def" href="javascript:void(0)" onclick="newWindow('新增门票订单','<%=staticPath %>/booking/toAddSight?groupId=${groupInfo.groupId }&isShow=${isShow }')">新增</a>
				                  			</c:if>
				                  		</c:if>
				                  </td>
				               </tr>
			              </c:forEach>
			             
			             </tbody>
	          		 </table>
    			 </div>
				 <div class="clear"></div>
	    		</dd>
            </dl>
        <div class="row">
	<jsp:include page="/WEB-INF/include/page.jsp">
		<jsp:param value="${pageBean.page }" name="p"/>
		<jsp:param value="${pageBean.totalPage }" name="tp" />
		<jsp:param value="${pageBean.pageSize }" name="ps" />
		<jsp:param value="${pageBean.totalCount }" name="tn" />
	</jsp:include>
</div>
<script type="text/javascript">
$(document).ready(function () {
	$(".serialnum div").bind("click", function(){
		divExpand(this, $(this).attr("groupId"),$("#supplierType").val());
	});
	
});
    
 var divExpand = function (btnObj, groupID,supplierType) {
        //切换 (展开/收缩)小图标
        var objId = $(btnObj).attr("id"); 
        var cssName = $(btnObj).attr("class") == "serialnum_btn" ? "serialnum_btn2" : "serialnum_btn";
        $(btnObj).attr("class", cssName);

        //收起来
        if (cssName == "serialnum_btn") {
            $("#td_" + groupID).parent().slideUp().remove();
            return;
        }

      	//展开 
        var trContainer = '<tr ><td colspan="12" id="td_'+groupID+'">'+        
        +'</td></tr>';
        $(btnObj).closest("tr").after(trContainer);
        vTrObj = $("#td_" + groupID).slideDown();
        

        //开始读数据
        //loadGroupElementAjax(vTrObj, groupID);
        loadData("td_"+groupID,groupID,supplierType);
    }
 
 
 function loadData(containerId, groupId, supplierType){
	 
	 var isShow = "${isShow}";
	 $("#"+containerId).load("sightBookingInfo.htm?groupId="+groupId+"&isShow="+isShow);
	 
 }
 </script>