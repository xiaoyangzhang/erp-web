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
	    					<col width="5%"/><col width="10%"/><col width="10%"/><col width="5%"/><col width=""/>
	    					<col width="10%"/><col width="8%"/><col width="8%"/><col width="8%"/><col width="8%"/><col width="10%"/>
	    					<thead>
	    						<tr>
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
		    						<th>操作</th>	    							
	    						</tr>	
	    					</thead>
	    					<tbody>
	    					 <c:forEach items="${list}" var="list" varStatus="status">
		    						<tr id="${list.fid }">
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
			    						<td>
			    							<c:if test="${!empty list.total }">
				    							<fmt:formatNumber value="${list.total }" type="number" pattern="#.##"/>
				    						</c:if>
				    						<c:if test="${empty list.total }">
				    							0
				    						</c:if>
			    						</td>
			    						<td>
				    						<c:if test="${!empty list.totalCash }">
				    							<fmt:formatNumber value="${list.totalCash }" type="number" pattern="#.##"/>
				    						</c:if>
				    						<c:if test="${empty list.totalCash }">
				    							0
				    						</c:if>
			    						</td>
			    						<td><fmt:formatNumber value="${list.total-list.totalCash }" type="number" pattern="#.##"/></td>
			    						<td><fmt:formatNumber value="${list.ftotal }" type="number" pattern="#.##"/></td>
			    						<td>
				    						<c:if test="${stateBooking ne 3 }">
												<a href="#" onclick="delFinance(${list.groupId }, ${list.id },${financeGuide.bookingId})" class="def">删除</a>
											</c:if>
										</td>
		    						</tr>
		    						<c:set var="sum_total" value="${sum_total+list.total}" />
		    						<c:set var="sum_totalCash" value="${sum_totalCash+list.totalCash}" />
		    						<c:set var="sum_ftotal" value="${sum_ftotal+list.ftotal}" />
	    						</c:forEach>
	    						<tr>
	    							<td colspan="6">合计:</td>
		    						<td><fmt:formatNumber value="${sum_total }" type="number" pattern="#.##"/></td>
		    						<td><fmt:formatNumber value="${sum_totalCash }" type="number" pattern="#.##"/></td>
		    						<td><fmt:formatNumber value="${sum_total-sum_totalCash }" type="number" pattern="#.##"/></td>
		    						<td><fmt:formatNumber value="${sum_ftotal }" type="number" pattern="#.##"/></td>
		    						<td></td>
	    						</tr>
	    					</tbody>
	    				</table>
	    				<div class="ml-30">
			    				
	    					<c:if test="${stateBooking ne 3 }">
	    					<c:choose>
								    <c:when test="${financeGuide.supplierType eq 5}"><a class="button button-primary button-rounded button-small mt-20 mb-20" onclick="imp()">关联</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 3}"><a class="button button-primary button-rounded button-small mt-20 mb-20" onclick="imp()">关联</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 2}"><a class="button button-primary button-rounded button-small mt-20 mb-20" onclick="imp()">关联</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 4}"><a class="button button-primary button-rounded button-small mt-20 mb-20" onclick="imp()">关联</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 120}"><a class="button button-primary button-rounded button-small mt-20 mb-20" onclick="imp()">关联</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 121}"><a class="button button-primary button-rounded button-small mt-20 mb-20" onclick="imp()">关联</a></c:when>							   
							</c:choose>
	    					<c:choose>		
								    <c:when test="${financeGuide.supplierType eq 5}"><a class="button button-primary button-rounded button-small mt-20 mb-20" href="javascript:void(0)"  onclick="newWindow('新增景点门票','<%=ctx %>/booking/toAddSight?groupId=${financeGuide.groupId}')">新增景点门票</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 3}"><a class="button button-primary button-rounded button-small mt-20 mb-20" href="javascript:void(0)"  onclick="newWindow('新增用房','<%=ctx %>/booking/toAddHotel?groupId=${financeGuide.groupId}')">新增用房</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 2}"><a class="button button-primary button-rounded button-small mt-20 mb-20" href="javascript:void(0)"  onclick="newWindow('新增用餐','<%=ctx %>/booking/toAddEat?groupId=${financeGuide.groupId}')">新增用餐</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 4}"><a class="button button-primary button-rounded button-small mt-20 mb-20" href="javascript:void(0)"  onclick="newWindow('新增用车','<%=ctx %>/booking/toAddCar?groupId=${financeGuide.groupId}')">新增用车</a></c:when>
								    <c:when test="${financeGuide.supplierType eq 120}"><a class="button button-primary button-rounded button-small mt-20 mb-20" href="javascript:void(0)"  onclick="newWindow('新增其他收入','<%=ctx %>/booking/editIncome.htm?groupId=${financeGuide.groupId}')">新增其他收入</a></c:when>
									<c:when test="${financeGuide.supplierType eq 121}"><a class="button button-primary button-rounded button-small mt-20 mb-20" href="javascript:void(0)" onclick="newWindow('新增其他支出','<%=ctx %>/booking/editOutcome.htm?groupId=${financeGuide.groupId}')">新增其他支出</a></c:when>							   
							</c:choose>
							</c:if>
	    				</div>
	    			</div>
			    </dd>
			    <dd>
			    	<div class="" style="text-align: center;">
			    		<b>报账金额：<fmt:formatNumber value="${count }" type="number" pattern="#.##"/></b><br />
			    		<div class="btn mt-30">
			    			<a href="finance.htm?bookingId=${financeGuide.bookingId }&groupId=${financeGuide.groupId}&fromfin=${reqpm.fromfin}" class="button button-rounded button-primary button-small mr-20">返回</a>
			    		</div>
			    		
			    	</div>
			    </dd>
	    	</dl>
	    	
        </div>
       
      </div><!--#tabContainer结束-->
    </div>  

</body>
<script type="text/javascript">
function imp(){
	var win;
	layer.open({ 
		type : 2,
		title : '请选择',
		closeBtn : false,
		area : [ '1080px', '620px' ],
		shadeClose : false,
		content :'getFinanceSupplierView.htm?id=1&groupId=${financeGuide.groupId}&bookingId=${financeGuide.bookingId}&supplierType=${financeGuide.supplierType}',
		//content : 'getFinanceSupplierView.htm?financeGuide=${financeGuide}',	
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//orgArr返回的是org对象的数组
			var arr = win.getSupplierList(); 
			for (var i = 0; i < arr.length; i++) {
				if(arr[i].total==''){$.warn("请填写报账金额");return false;}
				
			}
			if(arr.length==0){
				$.warn("请选择");
				return false;
			}
			$.ajax({
				 url :"financeSave.do",
			    type :"POST", 
			    dataType:"json",
			    data:{data:JSON.stringify(arr)},
			    success : function(data) {
			    	  if (data.success) {
			    		 $.success('操作成功',function(){
			    			 location.reload();
						});
                        
                     } else {
                   	  layer.alert(data.msg, {
								icon : 5
							});
                     }
			    },
			error:function(e){
				layer.alert('操作失败', {
					icon : 5
				});
			    }
			});
		
		
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}


function delFinance(groupId, bookingIdLink, bookingId){
	$.confirm("确认删除吗？",function(){
		  $.post("delFinance.do",{groupId:groupId, bookingIdLink:bookingIdLink, bookingId:bookingId},function(data){
		   		if(data.success){
		   			$.success('删除成功！');
		   		 location.reload();
		   		}else{
		   			$.error(data.msg);
		   		}
		  },"json");
},function(){
	  $.info('取消删除！');
});
}


</script>
</html>
