<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>购物佣金</title>
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
	    				
	    				<div class="ml-30">
	    				    <table cellspacing="0" cellpadding="0" class="w_table">
	    				    	<col width="3%" />
								<col width="10%" />
								<col width="10%" />
								<col width="10%" />
								<thead>
									<tr>
										<th>序号<i class="w_table_split"></i></th>
										<th>佣金类型<i class="w_table_split"></i></th>
										<th>发放佣金<i class="w_table_split"></i></th>
										<th>扣除佣金<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${financeCommissionList}" var="flist" varStatus="status">
										<tr>
											<td>${status.index+1}</td>
											<c:forEach items="${dicInfoList}" var="dic">
												<c:if test="${flist.commissionType==dic.code}">
													<td>${dic.value}</td>
												</c:if>
											</c:forEach>
											 <c:if test="${flist.total>0}">
													<td ${borderCss } ><fmt:formatNumber value="${flist.total }" pattern="#.##"/></td>
													<td></td>
													<c:set var="totalAdd" value="${totalAdd+flist.total}" />
											</c:if>
											<c:if test="${flist.total<0}">
													<c:set var="totalDele" value="${fn:replace(flist.total,'-', '')}" />
													<td></td>
													<td ${borderCss } ><fmt:formatNumber value="${totalDele}" pattern="#.##"/></td>
													<c:set var="totalD" value="${totalD+totalDele}" />
											</c:if>  
										</tr>
									</c:forEach>
									<tr>
		    							<td colspan="2">合计</td>
			    						<td ><fmt:formatNumber value="${totalAdd }" type="number" pattern="0.00"/></td>
			    						<td ><fmt:formatNumber value="${totalD }" type="number" pattern="0.00"/></td>
	    							</tr>
								</tbody>
							</table>
	    					
	    				</div>
	    			</div>
			    </dd>
			    <dd>
			    	<div class="" style="text-align: center;">
			    		 <b>订单总额：<fmt:formatNumber value="${count }" type="number" pattern="0.00"/></b><br />
			    		<div class="btn mt-30">
			    			<a href="finance.htm?bookingId=${financeGuide.bookingId }&groupId=${financeGuide.groupId}" class="button button-rounded button-primary button-small mr-20">返回</a>
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


function delFinance(id){
	$.confirm("确认删除吗？",function(){
		  $.post("delFinance.do",{id:id},function(data){
		   		if(data.success){
		   			$.info('删除成功！');
		   		 location.reload();
		   		}else{
		   			$.info(data.msg);
		   		}
		  },"json");
},function(){
	  $.info('取消删除！');
});
}


</script>
</html>
