<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>导游列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>
  <div class="p_container" >
      <div id="tabContainer">        
        <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="useroom_tab pl-20 pr-20">
	    				<table cellspacing="0" cellpadding="0" border="1" class="w_table">
	    					<col width="5%"/><col width="3%"/><col width="10%"/><col width="10%"/><col width="5%"/>
	    					<col width="30%"/><col width="5%"/><col width="8%"/><col width="8%"/><col width="8%"/><col width="8%"/>
	    					<thead>
	    						<tr>
	    							<th><input type="checkbox" name="checkAll" id="checkAll" value="" /></th>
	    							<th>序号</th>
	    							<th>订单号</th>
	    							<th>商家名称</th>
	    							<th>方式</th>
	    							<th>明细</th>
	    							<th>计调</th>
	    							<th>应付</th>
	    							<th>已付</th>
	    							<th>未付</th>
	    							<th>报账金额</th>
	    							
	    						</tr>	
	    					</thead>
	    					<tbody>
	    					 <c:forEach items="${list}" var="list" varStatus="status">
		    						<tr>
		    							<td><input type="checkbox" name="subBox" class="finance_check" id="" value="${status.index+1}" /></td>
		    							<td>${status.index+1}</td>
			    						<td>${list.bookingNo }</td>
			    						<td>${list.supplierName }</td>
			    						<td>${list.cashType }</i></td>
			    						<td>
			    							 <c:forEach items="${list.supplierDetail}" var="supplierDetail" >
			    							 	${supplierDetail }<br>
			    							 </c:forEach>
			    						</td>
			    						<td>${list.operatorName }</td>
			    						<td><fmt:formatNumber value="${list.total }" type="number" pattern="#.##"/></td>
			    						<td>
			    						<c:choose>
			          						<c:when test="${list.totalCash eq null  }">0.00</c:when>
			          						<c:otherwise><fmt:formatNumber value="${list.totalCash }" type="number" pattern="#.##"/></c:otherwise>
			          					</c:choose>
			    						</td>
			    						<td><fmt:formatNumber value="${list.total-list.totalCash }" type="number" pattern="#.##"/></td>
			    						<td id="${status.index+1}">
				    						<input type="hidden" name="bookingIdLink" value="${list.id }"/>
				    						<input type="hidden" name="groupId" value="${list.groupId }"/>
				    						<input type="hidden" name="supplierType" value="${list.supplierType }"/>
				    						<input type="hidden" name="bookingId" value="${financeGuide.bookingId }"/>
				    						<input type="text" name="total"/>
			    						</td>
		    						</tr>
	    						</c:forEach>
	    						
	    					</tbody>
	    				</table>
	    				
	    			</div>
			    </dd>
			    <dd>
			    </dd>
	    	</dl>
	    	
        </div>
       
      </div><!--#tabContainer结束-->
    </div>  

</body>
<script type="text/javascript">
$(function() {
    $("#checkAll").click(function() {
         $('input[name="subBox"]').attr("checked",this.checked); 
     });
     var $subBox = $("input[name='subBox']");
     $subBox.click(function(){
         $("#checkAll").attr("checked",$subBox.length == $("input[name='subBox']:checked").length ? true : false);
     });

 });
function getSupplierList(){
	var arr = new Array();
	  
	 $('.finance_check').each(function(){
		 if(this.checked){
	    	 var $td = $(this).parent().siblings('td:last');
	    		var bookingIdLink = $td.find('input[name="bookingIdLink"]').val();
	    		var groupId = $td.find('input[name="groupId"]').val();
	    		var supplierType = $td.find('input[name="supplierType"]').val();
	    		var bookingId = $td.find('input[name="bookingId"]').val();
	    		var total = $td.find('input[name="total"]').val();
	    		arr.push({"bookingIdLink":bookingIdLink,"groupId":groupId,"supplierType":supplierType,"bookingId":bookingId,"total":total});
		 }

	 });
	
	 return arr;
}
</script>
</html>
