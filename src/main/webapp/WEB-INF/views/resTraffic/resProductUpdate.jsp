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
<title>价格修改页面</title>
<%@ include file="../../include/top.jsp"%>
<style type="text/css">
	.input_w{
		width: 85%;
	}
	.input_pn{
		width: 85%;
	}
</style>
</head>
<body >
	<div class="p_container">
<!-- table  start -->
		<form id="updateTfcResProduct">
			<dl class="p_paragraph_content">
				<dd>
				<div class="pl-10 pr-10" style="padding-bottom: 1%;">
					<table class="w_table">
						<col  />
						<col width="4%" />
						<col width="4%" />
						<col width="7%" />
						<col width="7%" />
						
						<col width="7%" />
						<col width="7%" />
						<col width="7%" />
						<col width="7%" />
						<col width="7%" />
						<col width="7%" />
						<col width="7%" />
						
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						
						<col width="6%" />
						<col width="6%" />
						<thead>
							<tr>
								<th rowspan="2">产品名称<i class="w_table_split"></i></th>
								<th rowspan="2">库存<i class="w_table_split"></i></th>
								<th rowspan="2">已售<i class="w_table_split"></i></th>
								<th colspan="9">价格设置<i class="w_table_split"></i></th>
								<!-- <th colspan="4">成人价<i class="w_table_split"></i></th> -->
								<th rowspan="2">预留时长(分)<i class="w_table_split"></i></th>
								<th rowspan="2">取消下限<i class="w_table_split"></i></th>
							</tr>
							<tr>
								<th>规格<i class="w_table_split"></i></th>
								<!-- <th style="display: none;">成本价<i class="w_table_split"></i></th> -->
								<th>建议零售价<i class="w_table_split"></i></th>
								<th>同行返款<i class="w_table_split"></i></th>
								<th>代理返款<i class="w_table_split"></i></th>
								<th>最低定金<i class="w_table_split"></i></th>
								
								<th>房<i class="w_table_split"></i></th>
								<th>机票<i class="w_table_split"></i></th>
								<th>接送<i class="w_table_split"></i></th>
								<th>其他<i class="w_table_split"></i></th>
							</tr>
						</thead>
						<tbody>
								<td rowspan="3">
									<input type="hidden" id="productId" name="productCode" value="${resProductBean.productCode }"/>
									<input type="hidden" id="pid" name="id" value="${resProductBean.id}"/>
									<input type="hidden" id="m_res_id" name="resId" value="${resProductBean.resId}"/>
									<input type="hidden" name="numSold" value="${resProductBean.numSold}"/>
									<input type="hidden" name="userId" value="${resProductBean.userId}"/>
									<input type="hidden" name="userName" value="${resProductBean.userName}"/>
									<c:choose>
										<c:when test="${resProductBean.numSold>0 }">
											<input readonly="readonly" class="input_pn" id="productName_id" type="text" name="productName" value="${resProductBean.productName }"/>
										</c:when>
										<c:otherwise>
											<input readonly="readonly" class="input_pn" id="productName_id" type="text" name="productName" value="${resProductBean.productName }"/>
											<a href="javascript:void(0)" onclick="selectProductNameLine('${resProductBean.resId}');">选择</a>
										</c:otherwise>
									</c:choose>
								</td>
								<td rowspan="3">
									<input type="hidden" name="numStock" value="${resProductBean.numStock }"/>
									${resProductBean.numStock }
								</td>
								<td rowspan="3">
									${resProductBean.numSold }
								</td>
								<td>成人价</td>
								<td style="display: none;"><input class="input_w" type="text"  name="adultCostPrice" value="<fmt:formatNumber value="${resProductBean.adultCostPrice }"  type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text" name="adultSuggestPrice" value="<fmt:formatNumber value="${resProductBean.adultSuggestPrice }" type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text" name="adultSamePay" value="<fmt:formatNumber value="${resProductBean.adultSamePay }" type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text" name="adultProxyPay" value="<fmt:formatNumber value="${resProductBean.adultProxyPay }" type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text"  name="adultMinDeposit" value="<fmt:formatNumber value="${resProductBean.adultMinDeposit }" type="currency" pattern="#.##"/>"/>
								</td>
								
								<td><input class="input_w" type="text"  name="adultCostHotel" value="<fmt:formatNumber value="${resProductBean.adultCostHotel }" type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text"  name="adultCostTicket" value="<fmt:formatNumber value="${resProductBean.adultCostTicket }" type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text"  name="adultCostJs" value="<fmt:formatNumber value="${resProductBean.adultCostJs }" type="currency" pattern="#.##"/>"/>
								</td>
								<td><input class="input_w" type="text"  name="adultCostOther" value="<fmt:formatNumber value="${resProductBean.adultCostOther }" type="currency" pattern="#.##"/>"/>
								</td>
								<td rowspan="3">
									<input class="input_w" type="text" name="reserveTime" value="${resProductBean.reserveTime }"/>
									<%-- <fmt:parseDate value="${fn:replace(resProductBean.reserveTime, ':00.0', ':00')}" pattern="yyyy-MM-dd HH:mm:ss" var="date1"></fmt:parseDate>   --%>
									<%-- <input class="input_w" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"  type="text" name="reserveTime" value="<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date1}" />"/> --%>
								</td>
								<td rowspan="3">
									<input class="input_w" type="text" name="reserveStockLimit" value="${resProductBean.reserveStockLimit  }"/>
								</td>
							</tr>
							<tr>
								<td>儿童价<br/>(2岁以上)</td>
								<td  style="display: none;"><input class="input_w" type="text" name="childCostPrice" value="<fmt:formatNumber value="${resProductBean.childCostPrice }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childSuggestPrice" value="<fmt:formatNumber value="${resProductBean.childSuggestPrice }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childSamePay" value="<fmt:formatNumber value="${resProductBean.childSamePay }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childProxyPay" value="<fmt:formatNumber value="${resProductBean.childProxyPay }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childMinDeposit" value="<fmt:formatNumber value="${resProductBean.childMinDeposit }" type="currency" pattern="#.##"/>"/></td>
								
								<td><input class="input_w" type="text" name="childCostHotel" value="<fmt:formatNumber value="${resProductBean.childCostHotel }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childCostTicket" value="<fmt:formatNumber value="${resProductBean.childCostTicket }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childCostJs" value="<fmt:formatNumber value="${resProductBean.childCostJs }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="childCostOther" value="<fmt:formatNumber value="${resProductBean.childCostOther }" type="currency" pattern="#.##"/>"/></td>
							</tr>
							<tr>
								<td>婴儿价<br/>(0~2岁)</td>
								<td  style="display: none;"><input class="input_w" type="text" name="babyCostPrice" value="<fmt:formatNumber value="${resProductBean.babyCostPrice }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="babySuggestPrice" value="<fmt:formatNumber value="${resProductBean.babySuggestPrice }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="babySamePay" value="<fmt:formatNumber value="${resProductBean.babySamePay }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="badyProxyPay" value="<fmt:formatNumber value="${resProductBean.badyProxyPay }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="badyMinDeposit" value="<fmt:formatNumber value="${resProductBean.badyMinDeposit }" type="currency" pattern="#.##"/>"/></td>
								
								<td><input class="input_w" type="text" name="babyCostHotel" value="<fmt:formatNumber value="${resProductBean.babyCostHotel }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="babyCostTicket" value="<fmt:formatNumber value="${resProductBean.babyCostTicket }" type="currency" pattern="#.##"/>"/></td>
								<<td><input class="input_w" type="text" name="babyCostJs" value="<fmt:formatNumber value="${resProductBean.babyCostJs }" type="currency" pattern="#.##"/>"/></td>
								<td><input class="input_w" type="text" name="babyCostOther" value="<fmt:formatNumber value="${resProductBean.babyCostOther }" type="currency" pattern="#.##"/>"/></td>
							</tr>
						</tbody>
					</table>
				</div>
			</dd>
			<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
				<button type="submit" class="button button-primary button-small">确定</button>
				<button type="button" onclick="resProLogBtn()" class="button button-primary button-small">日志</button>
				<button type="button" onclick="closeModefyProduct();" class="button button-primary button-small">关闭</button>
			</div>
		</dl>
	</form>
</div>
</body>

<script type="text/javascript">

/**
 * 保存修改
 */
$("#updateTfcResProduct").validate({
	submitHandler : function(form) {
		var options = {
			url : "<%=path%>/resTraffic/toSaveResProduct.do",
			type : "post",
			dataType : "json",
			success : function(data) {
				
					if (data.success) {
						//刷新页面
						$.success('提交成功！', function(){
							location.reload();
						});
						
					} else {
						$.error(data.msg);
					}
			},
			error : function(XMLHttpRequest, textStatus,
							 errorThrown) {
				$.error('服务器忙，稍后再试');
			}
		};

		$(form).ajaxSubmit(options);
	},
	invalidHandler : function(form, validator) { // 不通过回调
		return false;
	}
})


/**
 * 选择产品
 */
function selectProductNameLine(obj) {
    var win;
    layer.open({
        type: 2,
        title: '选择产品名称',
        shadeClose: true,
        shade: 0.5,
        area: ['800px', '500px'],
        content: '<%=path%>/resTraffic/list.htm?state=2',
        btn: ['确定', '取消'],
        success: function (layero, index) {
            win = window[layero.find('iframe')[0]['name']];
        },
        yes: function (index) {
            layer.close(index);
            /**
             * 给基本信息赋值
             */
            $.getJSON('<%=path%>/resTraffic/getProductInfo.do?resId='+obj+'+&productId=' + $("#productId").val(), function (data) {
            	if (data.productIdCount==0) {
            		$("#productName_id").val(data.info.nameCity);
            	}else{
					$.error('该产品名称已经存在，不能重复添加！');
				}
            });
        }, cancel: function (index) {
            layer.close(index);
        }
    });
}


function closeModefyProduct(){
	closeWindow();
}
function resProLogBtn() {
	showInfo("库存日志","950px","550px","<%=path%>/basic/singleList.htm?tableName=traffic_res_product&tableId=" + $("#pid").val());
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
