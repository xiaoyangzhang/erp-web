<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>已绑定产品信息</title>
<%@ include file="../../include/top.jsp"%>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">

			<!-- table  start -->
			<dl class="p_paragraph_content">
					
				
				<dd class="inl-bl">
					<div ><label style="color: red;">该资源已绑定的产品信息：</label></div>
					<div >
							<button type="button" onclick="selectAllChkBtn();" class="button button-primary button-rounded button-small">全选</button>
							<button type="button" onclick="adjustPriceBtn();" class="button button-primary button-rounded button-small">批量调整价格</button>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<input type="hidden" name=resId id="res_id" value="${resId}" />
					<c:forEach items="${resProList }" var="res" varStatus="v">
						
						<input type="hidden" name=resId id="res_id" value="${res.resId}" />
						<input type="hidden" name="id" id="res_pro_id" value="${res.id}" />
						<input type="hidden" name="numSold" id="num_sold_id" value="${res.numSold}" />
						<input type="hidden" id="user_id" type="text" name="userId" value="${res.userId}"/>
						<input type="hidden" id="user_name_id" type="text" name="userName" value="${res.userName}"/>
						<input type="hidden" id="time_update_id" type="text" name="timeUpdate" value="${res.timeUpdate}"/>
						<input type="hidden" id="time_create_id" type="text" name="timeCreate" value="${res.timeCreate}"/>
						
						<div class="pl-10 pr-10" style="padding-bottom: 1%;">
							<table cellspacing="0" cellpadding="0" class="w_table">


								<col width="4%" />
								<col  />
								<col width="6%" />
								<col width="6%" />
								
								<col width="8%" />
								<col width="7%" />
								<col width="7%" />
								<col width="7%" />
								<col width="7%" />
								<col width="7%" />
								
								<col width="8%" />
								<col width="6%" />

								<col width="5%" />

								<thead>
									<tr>
										<th rowspan="2"></th>
										<th rowspan="2">产品名称<i class="w_table_split"></i></th>
										<th rowspan="2">库存<i class="w_table_split"></i></th>
										<th rowspan="2">已售<i class="w_table_split"></i></th>
										
										<th colspan="6">价格设置<i class="w_table_split"></i></th>

										<th rowspan="2">最长预留<br/>时长<i class="w_table_split"></i></th>
										<th rowspan="2">取消库存<br/>下限<i class="w_table_split"></i></th>
										<th rowspan="2">操作<i class="w_table_split"></i></th>
									</tr>
									<tr>
										<th>规格<i class="w_table_split"></i></th>
										<th>成本价<i class="w_table_split"></i></th>
										<th>建议零售价<i class="w_table_split"></i></th>
										<th>同行返款<i class="w_table_split"></i></th>
										<th>代理返款<i class="w_table_split"></i></th>
										<th>最低定金<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td rowspan="3">
											<input type="checkbox" name="resProid" id="chkAll" value="${res.id }" />
										</td>
										<td rowspan="3" hidden>${res.productCode }</td>
										<td rowspan="3">${res.productName }</td>
										<td rowspan="3">${res.numStock }</td>
										<td rowspan="3">${res.numSold }</td>
											<td>成人价</td>
											<td><fmt:formatNumber value="${res.adultCostPrice }"  type="currency" pattern="#.00#"/></td>
											<fmt:formatNumber value="${res.adultSuggestPrice }" var="adultSuggestPrice" type="currency" pattern="#.00#"/>
											<td>${adultSuggestPrice }</td>
											<fmt:formatNumber value="${res.adultSamePay }" var="adultSamePay" type="currency" pattern="#.00#"/>
											<td>${adultSamePay }</td>
											<fmt:formatNumber value="${res.adultProxyPay }" var="adultProxyPay" type="currency" pattern="#.00#"/>
											<td>${adultProxyPay }</td>
											<fmt:formatNumber value="${res.adultMinDeposit }" var="adultMinDeposit" type="currency" pattern="#.00#"/>
											<td>${adultMinDeposit }
										</td>
										<td rowspan="3">
											${res.reserveTime }
											<%-- <fmt:parseDate value="${fn:replace(res.reserveTime, ':00.0', ':00')}" pattern="yyyy-MM-dd HH:mm:ss" var="date1"></fmt:parseDate>   --%>
							            	<%-- <fmt:formatDate pattern="yyyy-MM-dd" value="${date1}" /><br/>
							            	<fmt:formatDate pattern="HH:mm:ss" value="${date1}" /> --%>
										</td>
										<td rowspan="3">${res.reserveStockLimit }</td>
										<td rowspan="3">
											<div class="tab-operate">
											<a href="####" class="btn-show">操作<span class="caret"></span></a>
											<div class="btn-hide" id="asd">
												<a href="javascript:void(0)" onclick="resProModifyBtn(${res.id });">修改</a>
												<a href="javascript:void(0)" onclick="resProLogBtn(${res.id },'traffic_res_product', 'product');">日志</a>
												<c:if test="${res.numSold == '0'}">
													<a  href="javascript:void(0)" onclick="resProDeleteBtn(${res.id });">删除</a>
												</c:if>
											</div>
											</div>
										</td>
									</tr>
									<tr>
										<td>儿童价</td>
										<fmt:formatNumber value="${res.childCostPrice }" var="childCostPrice" type="currency" pattern="#.00#"/>
										<td>${childCostPrice } </td>
										<fmt:formatNumber value="${res.childSuggestPrice }" var="childSuggestPrice" type="currency" pattern="#.00#"/>
										<td>${childSuggestPrice } </td>
										<fmt:formatNumber value="${res.childSamePay }" var="childSamePay" type="currency" pattern="#.00#"/>
										<td>${childSamePay } </td>
										<fmt:formatNumber value="${res.childProxyPay }" var="childProxyPay" type="currency" pattern="#.00#"/>
										<td>${childProxyPay } </td>
										<fmt:formatNumber value="${res.childMinDeposit }" var="childMinDeposit" type="currency" pattern="#.00#"/>
										<td>${childMinDeposit } </td>

									</tr>
									<tr>
										<td>婴儿价</td>
										<fmt:formatNumber value="${res.babyCostPrice }" var="babyCostPrice" type="currency" pattern="#.00#"/>
										<td>${babyCostPrice } </td>
										<fmt:formatNumber value="${res.babySuggestPrice }" var="babySuggestPrice" type="currency" pattern="#.00#"/>
										<td>${babySuggestPrice } </td>
										<fmt:formatNumber value="${res.babySamePay }" var="babySamePay" type="currency" pattern="#.00#"/>
										<td>${babySamePay } </td>
										<fmt:formatNumber value="${res.badyProxyPay }" var="badyProxyPay" type="currency" pattern="#.00#"/>
										<td>${badyProxyPay} </td>
										<fmt:formatNumber value="${res.badyMinDeposit }" var="badyMinDeposit" type="currency" pattern="#.00#"/>
										<td>${badyMinDeposit } </td>

									</tr>
								</tbody>
							</table>
						</div>
					</c:forEach>
					<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
						<button type="button" onclick="addProductBindingBtn();"  class="button button-primary button-rounded button-small">增加一个产品</button>
						
						<button type="button" onclick="resProLogBtn(${resId},'traffic_res_product', 'res');"  class="button button-primary button-rounded button-small">日志</button>
						<button type="button" onclick="javascript:location.reload()"  class="button button-primary button-rounded button-small">刷新</button>
						<button type="button" onclick="javascript:closeWindow()"  class="button button-primary button-rounded button-small">关闭</button>
					</div>
				</dd>
			</dl>
		</div>
	</div>
</body>
<script type="text/javascript">
/* 全选 */
function selectAllChkBtn(){
	if ($(":checkbox").attr("checked") != "checked") {
    	$(":checkbox").attr("checked", "checked");
 	}
	else {
    	$(":checkbox").removeAttr("checked");
	}

}

function adjustPriceBtn(){	
	
	//获取选中的id
	var setId = "";
	$("input[name=resProid]").each(function() {  
        if ($(this).attr("checked")) {  
            setId += $(this).val() + ",";  
        }  
    });
	if (!setId){ 
		alert("请先选择需要调整的产品信息！");
	}else{
		layer.open({
			type : 2,
			title : '批量调价',
			shadeClose : true,
			shade : 0.5,
			area: ['460px', '220px'],
			content: '<%=path%>/resTraffic/toAdjustProPrice.do?resId=${resId}&id='+setId
		
		});
		
	}
	
	
	
}

function addProductBindingBtn() {
	var res_id = $("#res_id").val();
	var res_pro_id = $("#res_pro_id").val();
	$.ajax({
		type : "post",
		data:{resId:res_id,productId:res_pro_id},
		url : "<%=path%>/resTraffic/insertTrafficProBinding.do",
		dataType : "json",
		success : function(data) {
			location.reload();
		},
		error : function() {
			alert('对不起失败了');
		}
	});

}

/* 修改 */
function resProModifyBtn(pid) {
	newWindow('修改产品信息','<%=path%>/resTraffic/toUpdateResProduct.do?resId='+pid)
} 

/* 删除 */
function resProDeleteBtn(pid) {
	
	
	$.confirm("确认删除吗？",function(){
		  $.post("deleteResProduct.do",{id:pid},function(data){
		   		if(data.success == 1){
		   			$.success('删除成功！', function(){
		   				//刷新页面
						location.reload();
					});			   			
		   		}else{
		   			$.info(data.msg);
		   		}
		  },"json");
	},function(){
	  $.info('取消删除！');

	});
}

/* 日志 */
function resProLogBtn(pid, tableName, viewType) {
	var tbField = viewType == "product"?"tableId":"tableParentId";
	
	showInfo("库存日志","950px","550px","<%=path%>/basic/singleList.htm?tableName=" + tableName + "&"+tbField+"=" + pid);
}
function showInfo(title,width,height,url){
 	layer.open({ 
 		type : 2,
 		title : title,
 		shadeClose : true,
 		shade : 0.5, 		
 		area : [width,height],
 		content : url
 	});
 }
</script>
</html>
