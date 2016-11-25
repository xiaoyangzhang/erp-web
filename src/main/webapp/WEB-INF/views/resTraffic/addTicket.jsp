<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>新增订单</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<%
	String path = ctx;
%>

<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
<style type="text/css">
	.dn{display:none;}
	.textarea-w200-h50{height:50px;width:80%;margin-top:4px;}
	.input-w80{width:70%;}
	.fontBold{font-weight:bold;}
	.select-w80{width:80%;}
</style>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub" id="tab1">
			<div id="groupbookingSupplierDetails">
            </div> 
			<form id="bookingForm" action="" method="post">
				<input type="hidden" name="groupId" id="groupId" value="${groupId }" />
				<c:if test="${orderId!=null}"><input type="hidden" name="orderId" id="orderId" value="${orderId }" /></c:if>
				<input type="hidden" name="bookingId" id="bookingId" value="${bookingId }" />
				<input type="hidden" name="stateBooking" id="stateBooking" value="${supplier.stateBooking }" />
				<input type="hidden" name="flag" id="flag" value="${flag }" />
				<input type="hidden" name="guestIds" id="guestIds" value="${guestIds }" />
				<input type="hidden" name="supplierType" id="supplierType"
					value="${supplierType }" />
					<input type="hidden" name="stateFinance" id="stateFinance" value="${supplier.stateFinance }" />
				<p class="p_paragraph_title">
					<b>机票</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<i class="red">* </i>供应商名称：
						</div>
						<div class="dd_right">
							<input type="text" name="supplierName" id="supplierName"
								value="${supplier.supplierName }" class="IptText300"/>
							<input type="hidden" name="supplierId" id="supplierId"
								value="${supplier.supplierId }" /> <input type="button" class="button button-primary button-small"
								value="选择" onclick="selectAir()" id="air"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">联系方式：</div>
						<div class="dd_right">
							<p class="pb-5">
							<p class="pb-5">
								<input type="text" id="contact" placeholder="联系人" name="contact"
									class="IptText60" value="${supplier.contact }" >
								<input type="text" id="contactTel" placeholder="电话"
									name="contactTel" class="IptText60"
									value="${supplier.contactTel }" > <input
									type="text" id="contactMobile" name="contactMoblie"
									placeholder="手机" class="IptText60"
									value="${supplier.contactMobile }" > <input
									type="text" id="contactFax" name="contactFax" placeholder="传真"
									class="IptText60" value="${supplier.contactFax }" >
								<input type="button" value="选择" class="button button-primary button-small" onclick="selectContact()" id="contact1" />
							</p>
							</p>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">结算方式：</div>
						<div class="dd_right">
							<select name="cashType" id="cashType">
								
								<c:choose>
									
								<c:when test="${empty supplier.cashType }">
								<c:forEach items="${cashTypes }" var="type">
									<c:set var="isSelected" value="" />
									<c:if test="${type.value eq '公司现付'}">
										<c:set var="isSelected" value="selected='selected'" />	
									</c:if>
									<option value="${type.value }" id="${type.id }" ${isSelected} >${type.value }</option>									
								</c:forEach>
								</c:when>
								<c:otherwise >
									<c:forEach items="${cashTypes }" var="type">
										<option <c:if test="${supplier.cashType eq type.value }">selected</c:if>  >${type.value }</option>
									</c:forEach>
								</c:otherwise>
								</c:choose>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					
					<dd>
						<div class="dd_left">备注：</div>
						<div class="dd_right">
							<textarea rows="5" cols="30" id="remark" name="remark"
								value="${supplier.remark }">${supplier.remark }</textarea>
						</div>
						<div class="clear"></div>
					</dd>

				</dl>
				<p class="p_paragraph_title">
					<b>价格信息</b>
				</p>
				<dl class="p_paragraph_content" style="margin-left: 20px">
					<dd>

						<div class="dd_right" >
							<table cellspacing="0" cellpadding="0" class="w_table" id="priceTable">
								<col width="11%" />
								<col width="11%" />
								<col width="33%" />
								<col width="8%" />
								<col width="9%" />
								<col width="9%" />
								<col width="9%" />
								<col width="9%" />
								
								<thead>
									<tr>
										<th>票类别<i class="w_table_split"></i></th>
										
										<th>开始日期<i class="w_table_split"></i></th>
										<th>交通信息<i class="w_table_split"></i></th>
										<th>类型<i class="w_table_split"></i></th>
										<th>成本价<i class="w_table_split"></i></th>
										<th>数量<i class="w_table_split"></i></th>
										<th>免去数<i class="w_table_split"></i></th>
										<th>金额<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody id="airTblTr">
											<tr>
												<td><input type="text" name="bookingSupplierDetails[0].type1Name" id="type1Name"  value="${trafficRes.resName }"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].itemDate" id="itemDate" class="input-w80 Wdate" value="${trafficRes.dateStart}"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].ticketFlight" size="50" value="${trafficRes.lineInfo }"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].itemBrief"  value="成人"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].itemPrice"  id="price"   value="<fmt:formatNumber value="${trafficRes.costPrice}" pattern="#.##"/>"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].itemNum"  id="num"  value="${adultNum}"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].itemNumMinus"  id="numMinus" value="0"/></td>
												<td><input type="text" name="bookingSupplierDetails[0].itemTotal" id="total" onblur="limitInput();" value="<fmt:formatNumber value="${adultNum*trafficRes.costPrice}" pattern="#.##"/>"/></td>
											</tr>
											<tr>
												<td><input type="text" name="bookingSupplierDetails[1].type1Name" id="type1Name"  value="${trafficRes.resName }"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].itemDate" id="itemDate" class="input-w80 Wdate" value="${trafficRes.dateStart}"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].ticketFlight" size="50" value="${trafficRes.lineInfo }"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].itemBrief" value="儿童"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].itemPrice"  id="price1"   value="<fmt:formatNumber value="${trafficRes.childPrice}" pattern="#.##"/>"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].itemNum"  id="num1"  value="${childNum}"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].itemNumMinus"  id="numMinus1" value="0"/></td>
												<td><input type="text" name="bookingSupplierDetails[1].itemTotal" id="total1" onblur="limitInput();" value="<fmt:formatNumber value="${childNum*trafficRes.childPrice}" pattern="#.##"/>"/></td>
											</tr>
											<tr>
												<td><input type="text" name="bookingSupplierDetails[2].type1Name" id="type1Name"  value="${trafficRes.resName }"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].itemDate" id="itemDate" class="input-w80 Wdate" value="${trafficRes.dateStart}"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].ticketFlight" size="50" value="${trafficRes.lineInfo }"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].itemBrief"  value="婴儿"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].itemPrice"  id="price2"   value="<fmt:formatNumber value="${trafficRes.babyPrice}" pattern="#.##"/>"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].itemNum"  id="num2"  value="${babyNum}"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].itemNumMinus"  id="numMinus2" value="0"/></td>
												<td><input type="text" name="bookingSupplierDetails[2].itemTotal" id="total2" onblur="limitInput();" value="<fmt:formatNumber value="${babyNum*trafficRes.babyPrice}" pattern="#.##"/>"/></td>
											</tr>
											<tr>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td>合计</td>
											<td><input type="text" name="total" id="sumTotal" value="<fmt:formatNumber value="${adultNum*trafficRes.costPrice+childNum*trafficRes.childPrice+babyNum*trafficRes.babyPrice}" pattern="#.##"/>"/></td>
											</tr>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
							<%-- <c:if test="${optMap['EDIT'] }"> --%>
									<button type="submit"
										class="button button-primary button-small">保存</button>
									&nbsp;&nbsp;
								<%-- </c:if> --%>	<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
							</div>

						</dd>
					</dl>
				</div>
			</form>
			
		</div>
	</div>	
</body>
<script type="text/html" id="airRow">
<tr>
	<td>
	<input type="hidden" name="bookingSupplierDetailsId"/>
	<select  name="type1Id" class="select-w80">
		<c:forEach items="${airTypes}" var="t1" varStatus="vs">
			<option value="${t1.id }">${t1.value }</option>
		</c:forEach>
	</select></td>
	<td><input type="text" class='input-w80' name="itemDate"  class="Wdate"/></td>
	<td><input type="text" class='input-w80' name="ticketDeparture" /></td>
	<td><input type="text" class='input-w80' name="ticketArrival" /></td>
	<td><input type="text" class='input-w80' name="ticketFlight" /></td>
	<td><input type="text" class='input-w80' name="itemPrice"  value="0"/></td>
	<td><input type="text" class='input-w80' name="itemNum"  value="0"/></td>
	<td><input type="text" class='input-w80'  name="itemNumMinus" value="0"></td>
	<td><input type="text" class='input-w80' name="itemTotal" value="0" readonly="readonly"></td>
	<td><a name="del" href="javascript:void(0)">删除</a></td>
</tr>

</script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/utils/float-calculate.js"></script>

<script type="text/javascript">
function selectAir(){
	layer.openSupplierLayer({
		title : '选择机票',
		content : '<%=ctx%>/component/supplierList.htm?supplierType=9',
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选择商家 ");
				return false;
			}
			
			/*for(var i=0;i<arr.length;i++){
				console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
			}*/
			$("#supplierName").val(arr[0].name);
			$("#supplierId").val(arr[0].id);
	    }
	});
}

function selectContact(){
	/**
	 * 先选择供应商，再根据供应商id选择联系人 
	 */
	var win=0;
	var supplierId = $("#supplierId").val().trim() ;
	if(supplierId==""){
		layer.msg("请先选择商家");
	}else{
		layer.open({ 
			type : 2,
			title : '选择联系人',
			closeBtn : false,
			area : [ '550px', '450px' ],
			shadeClose : false,
			content : '<%=ctx%>/component/contactMan.htm?supplierId='
					+ supplierId,//参数为供应商id
			btn : [ '确定', '取消' ],
			success : function(layero, index) {
				win = window[layero.find('iframe')[0]['name']];
			},
			yes : function(index) {
				//manArr返回的是联系人对象的数组
				var arr = win.getChkedContact();
				if (arr.length == 0) {
					$.warn("请选择联系人");
					return false;
				}
				$("#contact").val(arr[0].name);
				$("#contactMobile").val(arr[0].mobile);
				$("#contactTel").val(arr[0].tel);
				$("#contactFax").val(arr[0].fax);
				//一般设定yes回调，必须进行手工关闭
				layer.close(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}
}

var path = '<%=path%>';
$("#bookingForm").validate({
	submitHandler : function(form) {
				var options = {
					url : "saveBooking.do",
					type : "post",
					dataType : "json",
					success : function(data) {

						if (data.success) {
							$.success('操作成功', function(){
								closeWindow();
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
		});
		
		function limitInput(){
		var	total = $("input[name='bookingSupplierDetails[0].itemTotal']").val(),
				total1 = $("input[name='bookingSupplierDetails[1].itemTotal']").val(),
				total2 = $("input[name='bookingSupplierDetails[2].itemTotal']").val();
	document.getElementById("sumTotal").value=parseInt(total)+parseInt(total1)+parseInt(total2);
		}
</script>
</html>
