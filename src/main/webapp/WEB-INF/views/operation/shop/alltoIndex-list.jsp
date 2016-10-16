<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>

</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub">
	    <p class="p_paragraph_title"><b>团组信息</b><a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a></p>
            <dl class="p_paragraph_content w-1100">
            	<table cellspacing="0" cellpadding="0" class="w_table  tab_guide ml-20">
	    					<col width="20%"/><col width="15%"/>
	    					<thead>
	    						<th>应收团款<i class="w_table_split"></i></th>
	    						<th>预算成本<i class="w_table_split"></i></th>
	    						<th>成人数<i class="w_table_split"></i></th>
	    						<th>预计利润<i class="w_table_split"></i></th>
	    						<th>预计人利润<i class="w_table_split"></i></th>
	    						
	    					</thead>
	    					<tbody>
	    						<tr>
	    							<td><fmt:formatNumber value="${tourGroupInfo.incomeIncome}" pattern="0.00" type="number"/></td>
	    							<td><fmt:formatNumber value="${tourGroupInfo.costTotalPrice}" pattern="0.00" type="number"/></td>
	    							<td>${tourGroupInfo.totalAdult}</td>
	    							<td><fmt:formatNumber value="${tourGroupInfo.profit}" pattern="0.00" type="number"/></td>
	    							<td><fmt:formatNumber value="${tourGroupInfo.totalProfit}" pattern="0.00" type="number"/></td>
	    						</tr>
	    					</tbody>
	    					</table>
            </dl>
	    	<p class="p_paragraph_title"><b>分配指标</b></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20 w-1100">
	    				<table cellspacing="0" cellpadding="0" class="w_table  tab_guide">
	    					<col width="5%"/><col width="15%"/><col width="10%"/><col width="10%"/><col width="10%"/>
	    					<col width="10%"/><col width="10%"/><col width="15%"/><col width="15%"/>
	    					<thead>
	    						<th>序号<i class="w_table_split"></i></th>
	    						<th>购物店<i class="w_table_split"></i></th>
	    						<th>进店日期<i class="w_table_split"></i></th>
	    						<th>导游<i class="w_table_split"></i></th>
	    						<th>进店人数<i class="w_table_split"></i></th>
	    						<th>预计人均消费金额<i class="w_table_split"></i></th>
	    						<th>总消费金额<i class="w_table_split"></i></th>
	    						<th>备注<i class="w_table_split"></i></th>
	    						
	    						<th>操作<i class="w_table_split"></i></th>
	    						
	    						
	    					</thead>
	    					  <c:forEach items="${shoplist}" var="shop" varStatus="status">
		    					<tr>
		    						<td>
		    							${status.count }
		    						</td>
		    						<td>
		    							${shop.supplierName }
		    						</td>
		    						<td> 
		    							${fn:substring(shop.shopDate, 0, 10)}
		    						</td>
		    						<td>
		    							${shop.guideName }
		    						</td>
		    						<td>
		    							${tourGroupInfo.totalAdult}
		    						</td>
		    						<td>
		    						<c:if test="${not empty shop.personBuyAvg }">
		    							<fmt:formatNumber type="number" value="${shop.personBuyAvg } " pattern="0.00#" />
		    						</c:if>
		    						<c:if test="${empty shop.personBuyAvg}">
		    							0.00
		    						</c:if>
		    						</td>
		    						<td>
		    						<c:if test="${not empty shop.personBuyAvg}">
		    							<fmt:formatNumber type="number" value="${shop.personBuyAvg*tourGroupInfo.totalAdult } " pattern="0.00#" />
		    						</c:if>
		    						<c:if test="${empty shop.personBuyAvg}">
		    							0.00
		    						</c:if>
		    						</td>
		    						<td>
		    							${shop.remark }
		    						</td>
		    						<td>
		    						
		    							<c:if test="${view eq 1 }">
		    								<a href="#" onclick='editShop("${shop.id }","${shop.personBuyAvg }","${shop.remark }")' class="def">设置预计人均消费</a>
		    							</c:if>
		    						</td>
		    						
		    					</tr>
		    				</c:forEach>	
	    				</table>
	    			</div>
	    		</dd>
	    		
	    	</dl>
	    	<div id="groupDetail">
            	
            </div> 
        </div>
       
    </div>
        <!-- 设置预计人均消费金额弹出层        开始 -->
<div id="addPModal" style="display: none">
	<form class="definewidth m20" id="editShop">
		<dl class="p_paragraph_content">
			
			<dd>
				<div class="dd_left">金额:</div>
				<div class="dd_right">
					<input class="IptText200" type="text" id="personBuyAvg" name="personBuyAvg" />
					<input type="hidden" id="id" name="id">
					<input type="hidden" id="groupId" name="groupId" value="${groupId }">
					<input type="hidden" name="personNum" value="${tourGroupInfo.totalAdult}">
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">备注:</div>
				<div class="dd_right">
					<textarea rows="6" cols="35" name="remark" id="remark">
						
					</textarea>
				</div>
				
			</dd>
		</dl>
		
	</form>
</div>
<!-- end -->
</body>
<script type="text/javascript">


//弹出一个页面层
	function editShop(id,personBuyAvg,remark){
		$("#id").val(id);
		if(personBuyAvg){
			var pointPos = personBuyAvg.indexOf(".");
			personBuyAvg = personBuyAvg.substring(0, pointPos+3);	
		}else{
			personBuyAvg = "0.00";
		}
		$("#personBuyAvg").val(personBuyAvg);
		$("#remark").val(remark);
	    layer.open({
	        type: 1,
	        title :'设置预计人均消费金额',
	        area: [ '550px', '250px' ],
	        shadeClose: false, //点击遮罩关闭
	        content: $('#addPModal'),
	        btn: ['确定', '取消'],
	        yes: function(index){
	        	$("#editShop").submit();
				//一般设定yes回调，必须进行手工关闭
		       /*  layer.close(index);  */
		    },cancel: function(index){
		    	layer.close(index);
		    }
	    });
};
$("#groupDetail").load("<%=path %>/booking/groupDetail.htm?gid=${groupId }");
$(function(){
	$("#editShop").validate(
			{
				rules:{
					'personBuyAvg' : {
						required : true,
						isDouble:true
					}
					/* 'remark' : {
						required : true
					} */
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					var options = {
						url : "saveShop.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									
 									location.href = "toBookingShopView.htm?groupId=${groupId}&type=0";
								});
								 
							} else {
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});

	
	
});
</script>
</html>
