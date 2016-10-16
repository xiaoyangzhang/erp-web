<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="x-ua-compatible" content="IE=7" />
<title>散客订单管理</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/js/web-js/sales/region_dlg.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/individuaGroups.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/changeAddShow.js"></script>	
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/cities.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/jquery.autocomplete.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/card/card.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/card/region-card-data.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
<script type="text/javascript">

$(function() {
	$(this).find("input[id='supplierCode'],input[id='receiveMode']").removeAttr("onblur").blur(function(){
		$.getJSON("editSupplierAndReceiveMode.do?supplierCode="+$("#supplierCode").val()+"&receiveMode=" + $("#receiveMode").val()+"&orderId="+$("#orderId").val(), function(data) {
			if (data.success) {
				$.success('修改成功') ;
			} else {
				$.error(data.msg);
				window.location = window.location ;
			}
		});
	});

});

function selectContact(id,supplierId){
	if(supplierId==''){
		$.error('请先选择组团社');
		return
	}
	var win;
	layer.open({ 
		type : 2,
		title : '选择联系人',
		closeBtn : false,
		area : [ '550px', '450px' ],
		shadeClose : false,
		content : '../component/contactMan.htm?supplierId='+supplierId,//参数为供应商id
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//manArr返回的是联系人对象的数组
			var arr = win.getChkedContact();    				
			if(arr.length==0){
				$.error('请选择联系人')
				return false;
			}
			
			for(var i=0;i<arr.length;i++){
				console.log("id:"+arr[i].id+",name:"+arr[i].name+",tel:"+arr[i].tel+",mobile:"+arr[i].mobile+",fax:"+arr[i].fax);
				$.getJSON("editGroupOrderContMan.do?conId="+arr[i].id+"&id=" + id, function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							window.location = window.location;
						});
					} else {
						$.error(data.msg);
					}
					
				});
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}


function selectUser(id,num){
	var win;
	layer.open({ 
		type : 2,
		title : '选择人员',
		closeBtn : false,
		area : [ '400px', '500px' ],
		shadeClose : true,
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.error('请选择人员') ;
				return false;
			}
			
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				
				$.getJSON("editGroupOrder.do?employeeId="+userArr[i].id+"&id=" + id+"&num="+num, function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							window.location = window.location;
						});
					} else {
						$.error(data.msg);
					}
					
				});
				
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

function editServiceStandard(){
	layer.open({
		type : 1,
		title : '服务标准',
		shadeClose : true,
		shade : 0.5,
		area : [ '600px', '400px' ],
		content : $('#editServiceStandard')
	});
	
}

function editSourceInfo(){
	layer.open({
		type : 1,
		title : '客源信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '600px', '400px' ],
		content : $('#editSourceInfo')
	});
	
}

function editRemark(){
	layer.open({
		type : 1,
		title : '备注',
		shadeClose : true,
		shade : 0.5,
		area : [ '600px', '400px' ],
		content : $('#editRemark')
	});
	
}
	$(function(){
$(".pp").toggle(function() {
	$("#bbb").show();
}, function() {
	$("#bbb").hide();
});
	});
	
	function saveTrans() {
		
		// 订单id
		var orderId = ${groupOrder.id};
		var arr = [];
		var str = $("#bit").val();
		if (str == "" || str == null) {
			$.warn("输入信息为空");
			return false;
		}
		var strs = new Array();
		strs = str.split("\n");
		
		for (var i = 0; i < strs.length; i++) {
			if (strs[i] != "") {
				var infos = new Array();
				var va = strs[i].toString().replace("\n", "").replace(/，/g,
						",").replace(/。/g, ",");
				infos = va.split(",");
				if (infos.length != 5&&infos.length!=3) {
					$.warn("第" + eval(i + 1) + "行输入格式有误！");
					return false ;
				}
				if(infos.length==5){
					arr.push(infos[0] + "," + infos[1] + ","
							+ infos[2] + "," + infos[3] +","+infos[4]+","
							+orderId);
				}
				if(infos.length==3){
					arr.push(infos[0] + "," + infos[1] + ","+infos[2]+","
							+orderId);
				}
				
			}
		}
		
		jQuery.ajax({
			url : "../seatInCoach/batchInput.htm",
			type : "post",
			async : false,
			data : {
				"userArray" : arr
			},
			dataType : "json",
			success : function(data) {
				if (data.success) {
					$.success('操作成功');
					window.location = window.location;
				} else {
					$.warn(data.msg);
					window.location = window.location;
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error(textStatus);
				window.location = window.location;
			}
		});
	}
	
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/sales/template/orderTemplate.jsp"%>
	<div id="editSourceInfo" style="display: none">
		<form action="editGroupOrderText.do" method="post">
			<dl class="p_paragraph_content">

				<div class="searchRow">
					<dd>
						<div class="dd_left">客源类型:</div>
						<div class="dd_right">
							<input name="id" type="hidden" value="${groupOrder.id }" /> <input
								type="hidden" name="sourceTypeName" class="IptText300"
								id="sourceTypeName" value="${groupOrder.sourceTypeName }" /> <select
								name="sourceTypeId" id="sourceTypeCode">
								<option value="-1">请选择</option>
								<c:forEach items="${sourceTypeList }" var="source">
									<option value="${source.id }"
										<c:if test="${groupOrder.sourceTypeId==source.id  }"> selected="selected" </c:if>>${source.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">客源地:</div>
						<div class="dd_right">
							<input type="hidden" name="provinceName" class="IptText300"
								id="provinceName" value="${groupOrder.provinceName }" /> <input
								type="hidden" name="cityName" class="IptText300" id="cityName"
								value="${groupOrder.cityName }" /> <select name="provinceId"
								id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }"
										<c:if test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
							</select> <select name="cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
									<option value="${city.id }"
										<c:if test="${groupOrder.cityId==city.id  }"> selected="selected" </c:if>>${city.name }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
				</div>

			</dl>
			<div class="w_btnSaveBox" style="text-align: center;">
				<button type="submit" class="button button-primary button-small">保存</button>
			</div>
		</form>
	</div>



	<div id="editServiceStandard" style="display: none">
		<form action="editGroupOrderText.do" method="post">
			<dl class="p_paragraph_content">

				<div class="searchRow">
					<dd>
						<div class="dd_left">服务标准:</div>
						<div class="dd_right">
							<input name="id" type="hidden" value="${groupOrder.id }" />
							<textarea class="w_textarea" style="width: 350px"
								name="serviceStandard">${groupOrder.serviceStandard }</textarea>
						</div>
						<div class="clear"></div>
					</dd>
				</div>

			</dl>
			<div class="w_btnSaveBox" style="text-align: center;">
				<button type="submit" class="button button-primary button-small">保存</button>
			</div>
		</form>
	</div>




	<div id="editRemark" style="display: none">
		<form action="editGroupOrderText.do" method="post">
			<dl class="p_paragraph_content">
				<div class="searchRow">
					<dd>
						<div class="dd_left">备注:</div>
						<div class="dd_right">
							<input name="id" type="hidden" value="${groupOrder.id }" />
							<textarea class="w_textarea" style="width: 350px" name="remark">${groupOrder.remark }</textarea>
						</div>
						<div class="clear"></div>
					</dd>
				</div>

			</dl>
			<div class="w_btnSaveBox" style="text-align: center;">
				<button type="submit" class="button button-primary button-small">保存</button>
			</div>
		</form>
	</div>
	<h5>订单号：${groupOrder.orderNo}</h5>
	<div class="p_container_sub" id="tab1">
		<p class="p_paragraph_title">
			<b>订单信息</b>
		</p>
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">产品名称:</div>
				<div class="dd_right">【${groupOrder.productBrandName }】${groupOrder.productName }</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">产品简称:</div>
				<div class="dd_right">${groupOrder.productShortName }</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">天数:</div>
				<div class="dd_right">${productInfo.travelDays}</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">发团日期:</div>
				<div class="dd_right">${groupOrder.departureDate}</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">客源类型:</div>
				<div class="dd_right">${groupOrder.sourceTypeName}
					<c:if test="${groupOrder.stateFinance!=1}">
						<a href="javascript:void(0)" onclick="editSourceInfo()">变更</a>
					</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">客源地:</div>
				<div class="dd_right">${groupOrder.provinceName}${groupOrder.cityName}
					<c:if test="${groupOrder.stateFinance!=1}">
						<a href="javascript:void(0)" onclick="editSourceInfo()">变更</a>
					</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">人数:</div>
				<div class="dd_right">${groupOrder.numAdult }大
					${groupOrder.numChild }小</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">销售:</div>
				<div class="dd_right">
					${saleEmployeePo.name } ${saleEmployeePo.mobile }
					${saleEmployeePo.phone } ${saleEmployeePo.fax }
					<c:if test="${groupOrder.stateFinance!=1}">
						<a href="javascript:void(0)"
							onclick="selectUser(${groupOrder.id},1)">变更</a>
					</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">计调:</div>
				<div class="dd_right">${operaEmployeePo.name }
					${operaEmployeePo.mobile } ${operaEmployeePo.phone }
					${operaEmployeePo.fax }<a href="javascript:void(0)"
							onclick="selectUser(${groupOrder.id},2)">变更</a></div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">组团社:</div>
				<div class="dd_right">${supplierInfo.nameFull }</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">组团社联系人:</div>
				<div class="dd_right">
					${groupOrder.contactName } ${groupOrder.contactMobile }
					${groupOrder.contactTel } ${groupOrder.contactFax }
					<c:if test="${groupOrder.stateFinance!=1}">
						<a href="javascript:void(0)"
							onclick="selectContact(${groupOrder.id},${supplierInfo.id})">变更</a>
					</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<input type="hidden" name="" id="orderId" value="${groupOrder.id}" />
			<dd>
				<div class="dd_left">组团社团号:</div>
				<div class="dd_right">
					
					<input type="text" name="" id="supplierCode" value="${groupOrder.supplierCode }" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">接站牌内容:</div>
				<div class="dd_right">
					<input type="text" name="" id="receiveMode" value="${groupOrder.receiveMode }" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">服务标准:</div>
				<div class="dd_right">
					<textarea class="w_textarea" readonly="readonly">${groupOrder.serviceStandard }</textarea>
					<c:if test="${groupOrder.stateFinance!=1}">
						<a href="javascript:void(0)" onclick="editServiceStandard()">变更</a>
					</c:if>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">备注:</div>
				<div class="dd_right">
					<textarea class="w_textarea" readonly="readonly">${groupOrder.remark }</textarea>
					<c:if test="${groupOrder.stateFinance!=1}">
						<a href="javascript:void(0)" onclick="editRemark()">变更</a>
					</c:if>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>

		
		<p class="p_paragraph_title">
			<b>价格列表</b>
		</p>
		<dl class="p_paragraph_content">
			<c:if test="${groupOrder.stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<!-- 						<button type="button" class="button button-primary button-small" -->
						<!-- 							onclick="toAddCost(0);">添加新价格</button> -->
						<button type="button" class="button button-primary button-small"
							onclick="addPrice(0,'newPrice');">添加新价格</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%" id="newPriceDiv">
				<form id="newPriceDataForm">
				<table cellspacing="0" cellpadding="0" class="w_table">
						<thead>
							<tr>
								<th width="5%">序号<i class="w_table_split"></i></th>
								<th width="10%">项目<i class="w_table_split"></i></th>
								<th width="20%">备注<i class="w_table_split"></i></th>
								<th width="15%">单价<i class="w_table_split"></i></th>
								<th width="15%">次数<i class="w_table_split"></i></th>
								<th width="10%">人数<i class="w_table_split"></i></th>
								<th width="10%">金额<i class="w_table_split"></i></th>
								<c:if test="${groupOrder.stateFinance!=1}">
									<th width="15%">操作<i class="w_table_split"></i></th>
								</c:if>
							</tr>
						</thead>
						
						<c:forEach items="${costList }" var="cost" varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td>${cost.itemName }</td>
								<td style="text-align: left;">${cost.remark}</td>
								<td>${cost.unitPrice}</td>
								<td>${cost.numTimes}</td>
								<td>${cost.numPerson}</td>
								<td>${cost.totalPrice }</td>
								<c:if test="${cost.priceLockState!=1}">
									<c:if test="${groupOrder.stateFinance!=1}">
										<td><a href="javascript:void(0);"
											onclick="toEditCost(${cost.id});" class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a
											href="javascript:void(0);" onclick="delOrderPrice(${cost.id})"
											class="def">删除</a></td>
									</c:if>
								</c:if>
							</tr>
						</c:forEach>
						<tbody id="newPriceData">
						</tbody>
							<tr id="newPriceBtnState" style="display: none">
								<td colspan="7" ></td>
								<td>
									<button type="submit" class="button button-primary button-small" >保存</button>
								</td>
							</tr>
						
						<tr>
							<td> <td>
							<td></td>
							<td></td>
							<td></td>
							<td>合计：</td>
							<td style="font-weight: 600">${income}</td>
							<c:if test="${groupOrder.stateFinance!=1}">
								<td></td>
							</c:if>
						</tr>
						
					</table>
					</form>
				</div>
				<div class="clear"></div>
			</dd>
			<c:if test="${groupOrder.stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
<!-- 						<button type="button" class="button button-primary button-small" -->
<!-- 							onclick="toAddCost(1);">添加成本</button> -->
							<button type="button" class="button button-primary button-small"
							onclick="addPrice(1,'newCost');">添加新成本</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
				<form id="newCostDataForm">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="5%">序号<i class="w_table_split"></i></th>
								<th width="10%">项目<i class="w_table_split"></i></th>
								<th width="20%">备注<i class="w_table_split"></i></th>
								<th width="15%">成本单价<i class="w_table_split"></i></th>
								<th width="10%">次数<i class="w_table_split"></i></th>
								<th width="10%">人数<i class="w_table_split"></i></th>
								<th width="15%">金额<i class="w_table_split"></i></th>
								<c:if test="${groupOrder.stateFinance!=1}">
									<th width="15%">操作<i class="w_table_split"></i></th>
								</c:if>
							</tr>
						</thead>
						<c:forEach items="${budgetList }" var="budget" varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td>${budget.itemName }</td>
								<td style="text-align: left;">${budget.remark}</td>
								<td>${budget.unitPrice}</td>
								<td>${budget.numTimes}</td>
								<td>${budget.numPerson}</td>
								<td>${budget.totalPrice }</td>
								<c:if test="${budget.priceLockState!=1}">
								<c:if test="${groupOrder.stateFinance!=1}">
									<td><a href="javascript:void(0);"
										onclick="toEditCost(${budget.id});" class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a
										href="javascript:void(0);"
										onclick="delOrderPrice(${budget.id})" class="def">删除</a></td>
								</c:if></c:if>
							</tr>
						</c:forEach>
							<tbody id="newCostData">
								
								
								
							</tbody>
						<tr id="newCostBtnState" style="display: none">
							<td colspan="7" ></td>
							<td>
									<button type="submit" class="button button-primary button-small">保存</button>
							</td>
						</tr>
						<tr>
							<td>合计：</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td style="font-weight: 600">${budget}
							
							</th>
							<c:if test="${groupOrder.stateFinance!=1}">
								<td></td>
							</c:if>
						</tr>
					</table>
					</form>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<p class="p_paragraph_title">
			<b>接送信息列表</b>
		</p>
		
		<dl class="p_paragraph_content">
			<c:if test="${groupOrder.stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button type="button" class="button button-primary button-small"
							onclick="addTran('newTransport');">添加接送信息</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
				<form id="newTransportDataForm">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="5%">序号<i class="w_table_split"></i></th>
								<th width="10%">线路类型<i class="w_table_split"></i></th>
								<th width="5%">接送方式<i class="w_table_split"></i></th>
								<th width="10%">交通方式<i class="w_table_split"></i></th>
								<th width="10%">出发城市<i class="w_table_split"></i></th>
								<th width="10%">到达城市<i class="w_table_split"></i></th>
								<th width="10%">班次<i class="w_table_split"></i></th>
								<th width="10%">出发日期<i class="w_table_split"></i></th>
								<th width="10%">出发时间<i class="w_table_split"></i></th>
								<th width="10%">备注<i class="w_table_split"></i></th>
								<c:if test="${groupOrder.stateFinance!=1}">
								<th width="10%">操作<i class="w_table_split"></i></th>
								</c:if>
							</tr>
						</thead>
						<c:forEach items="${transportList }" var="transport"
							varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td><c:if test="${transport.sourceType==0 }">省内交通</c:if> <c:if
										test="${transport.sourceType==1 }">省外交通</c:if></td>
								<td><c:if test="${transport.type==0 }">接</c:if> <c:if
										test="${transport.type==1 }">送</c:if></td>
								<td><c:forEach items="${jtfsList}" var="jtfs">
										<c:if test="${jtfs.id==transport.method }">${jtfs.value }</c:if>
									</c:forEach></td>
								<td>${transport.departureCity}</td>
								<td>${transport.arrivalCity}</td>
								<td>${transport.classNo}</td>
								<td><fmt:formatDate value="${transport.departureDate}" pattern="yyyy-MM-dd"/></td>
								<td>${transport.departureTime}</td>
								<td>${transport.destination}</td>
								<c:if test="${groupOrder.stateFinance!=1}">
									<td><a href="javascript:void(0);"
										onclick="toEditTransport(${transport.id})" class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a
										href="javascript:void(0);"
										onclick="delTransport(${transport.id})" class="def">删除</a></td>
								</c:if>
							</tr>
						</c:forEach>
							<tbody id="newTransportData">
							</tbody>
							<tr id="newTransportBtnState" style="display: none">
								<td colspan="10" ></td>
								<td>
									<button type="submit" class="button button-primary button-small" >保存</button>
								</td>
							</tr>
					</table>
					</form>
				</div>
				<div class="clear"></div>

			</dd>
			<c:if test="${groupOrder.stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<a href="javascript:void(0)" class="pp">批量录入</a>
					
					<div id="bbb" style="display: none;">
						<div>
							<textarea class="l_textarea" value="" id="bit"
									placeholder="出发日期,出发时间,航班号,出发城市,到达城市"
									style="width: 600px; height: 250px"></textarea>
						</div>
						<div style="margin-top: 20px;">
							<a href="javascript:void(0);" onclick="saveTrans()"
									class="button button-primary button-small">保存</a> <span>
								<i class="red"> 按照上面格式填写后保存即可，回车换行添加多个接送信息 </i>
							</span>
						</div>
					</div>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
		</dl>
		<p class="p_paragraph_title">
			<b>计调需求列表</b>
		</p>

		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<p class="p_paragraph_title">
						<b>酒店</b>
					</p>
					<dl class="p_paragraph_content">
						<c:if test="${groupOrder.stateFinance!=1}">
							<dd>
								<div class="dd_left">
									<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
								</div>
								<div class="dd_right" style="width: 80%">
									<button type="button"
										class="button button-primary button-small"
										onclick="toAddRest()">新增</button>
								</div>
								<div class="clear"></div>
							</dd>
						</c:if>
						<dd>
							<div class="dd_left">
								<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
							</div>
							<div class="dd_right" style="width: 80%">
								<table cellspacing="0" cellpadding="0" class="w_table"
									id="personTable">
									<thead>
										<tr>
											<th width="5%">序号<i class="w_table_split"></i></th>
											<!-- 											<th  width="10%">日期<i class="w_table_split"></i></th> -->
											<!-- 											<th  width="10%">区域<i class="w_table_split"></i></th> -->
											<th width="10%">星级<i class="w_table_split"></i></th>
											<th width="10%">单人间<i class="w_table_split"></i></th>
											<th width="10%">三人间<i class="w_table_split"></i></th>
											<th width="10%">标准间<i class="w_table_split"></i></th>
											<th width="10%">陪房<i class="w_table_split"></i></th>
											<th width="10%">加床<i class="w_table_split"></i></th>
											<th width="20%">备注<i class="w_table_split"></i></th>
											<c:if test="${groupOrder.stateFinance!=1}">
												<th width="15%">操作<i class="w_table_split"></i></th>
											</c:if>
										</tr>
									</thead>
									<c:forEach items="${restaurantList }" var="restaurant"
										varStatus="index">
										<tr>
											<td>${index.count }</td>
											<%-- 											<td>${restaurant.requireDate }</td> --%>
											<%-- 											<td>${restaurant.area}</td> --%>
											<td><c:forEach items="${jdxjList}" var="jdxj">
													<c:if test="${jdxj.id==restaurant.hotelLevel}">${jdxj.value}</c:if>
												</c:forEach></td>
											<td>${restaurant.countSingleRoom}</td>
											<td>${restaurant.countTripleRoom}</td>
											<td>${restaurant.countDoubleRoom}</td>
											<td>${restaurant.peiFang}</td>
											<td>${restaurant.extraBed}</td>
											<td style="text-align: left;">${restaurant.remark}</td>
											<c:if test="${groupOrder.stateFinance!=1}">
												<td><a href="javascript:void(0);"
													onclick="toEditRest(${restaurant.id})" class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a
													href="javascript:void(0);"
													onclick="delTransfer(${restaurant.id})" class="def">删除</a></td>
											</c:if>
										</tr>
									</c:forEach>
								</table>
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<!-- 					<p class="p_paragraph_title"> --> <!-- 						<b>机票</b> -->
					<!-- 					</p> -->
					<!-- 					<dl class="p_paragraph_content"> -->
					<%-- 						<c:if test="${groupOrder.stateFinance!=1}"> --%>
					<!-- 							<dd> -->
					<!-- 								<div class="dd_left"> -->
					<!-- 									<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span> -->
					<!-- 								</div> -->
					<!-- 								<div class="dd_right" style="width: 80%"> -->
					<!-- 									<button type="button" -->
					<!-- 										class="button button-primary button-small" -->
					<!-- 										onclick="toAddAirticket()">新增</button> -->
					<!-- 								</div> -->
					<!-- 								<div class="clear"></div> -->
					<!-- 							</dd> -->
					<%-- 						</c:if> --%>
					<!-- 						<dd> -->
					<!-- 							<div class="dd_left"> -->
					<!-- 								<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span> -->
					<!-- 							</div> -->
					<!-- 							<div class="dd_right" style="width: 80%"> -->
					<!-- 								<table cellspacing="0" cellpadding="0" class="w_table" -->
					<!-- 									id="personTable"> -->
					<!-- 									<thead> -->
					<!-- 										<tr> -->
					<!-- 											<th width="5%">序号<i class="w_table_split"></i></th> -->
					<!-- 											<th width="15%">日期<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">班次<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">出发城市<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">到达城市<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">数量<i class="w_table_split"></i></th> -->
					<!-- 											<th width="25%">备注<i class="w_table_split"></i></th> -->
					<%-- 											<c:if test="${groupOrder.stateFinance!=1}"> --%>
					<!-- 												<th width="15%">操作<i class="w_table_split"></i></th> -->
					<%-- 											</c:if> --%>
					<!-- 										</tr> -->
					<!-- 									</thead> -->
					<%-- 									<c:forEach items="${airticketagentList }" var="airticketagent" --%>
					<%-- 										varStatus="index"> --%>
					<!-- 										<tr> -->
					<%-- 											<td>${index.count }</td> --%>
					<%-- 											<td>${airticketagent.requireDate }</td> --%>
					<%-- 											<td>${airticketagent.classNo}</td> --%>
					<%-- 											<td>${airticketagent.cityDeparture}</td> --%>
					<%-- 											<td>${airticketagent.cityArrival}</td> --%>
					<%-- 											<td>${airticketagent.countRequire}</td> --%>
					<%-- 											<td style="text-align: left;">${airticketagent.remark}</td> --%>
					<%-- 											<c:if test="${groupOrder.stateFinance!=1}"> --%>
					<!-- 												<td><a href="javascript:void(0);" -->
					<%-- 													onclick="toEditAirticket(${airticketagent.id})" class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a --%>
					<!-- 													href="javascript:void(0);" -->
					<%-- 													onclick="delTransfer(${airticketagent.id})" class="def">删除</a></td> --%>
					<%-- 											</c:if> --%>
					<!-- 										</tr> -->
					<%-- 									</c:forEach> --%>
					<!-- 								</table> -->
					<!-- 							</div> -->
					<!-- 							<div class="clear"></div> -->
					<!-- 						</dd> -->
					<!-- 					</dl> -->
					<!-- 					<p class="p_paragraph_title"> -->
					<!-- 						<b>火车票</b> -->
					<!-- 					</p> -->
					<!-- 					<dl class="p_paragraph_content"> -->
					<%-- 						<c:if test="${groupOrder.stateFinance!=1}"> --%>
					<!-- 							<dd> -->
					<!-- 								<div class="dd_left"> -->
					<!-- 									<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span> -->
					<!-- 								</div> -->
					<!-- 								<div class="dd_right" style="width: 80%"> -->
					<!-- 									<button type="button" -->
					<!-- 										class="button button-primary button-small" -->
					<!-- 										onclick="toAddTrainticket()">新增</button> -->
					<!-- 								</div> -->
					<!-- 								<div class="clear"></div> -->
					<!-- 							</dd> -->
					<%-- 						</c:if> --%>
					<!-- 						<dd> -->
					<!-- 							<div class="dd_left"> -->
					<!-- 								<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span> -->
					<!-- 							</div> -->
					<!-- 							<div class="dd_right" style="width: 80%"> -->
					<!-- 								<table cellspacing="0" cellpadding="0" class="w_table" -->
					<!-- 									id="personTable"> -->
					<!-- 									<thead> -->
					<!-- 										<tr> -->
					<!-- 											<th width="5%">序号<i class="w_table_split"></i></th> -->
					<!-- 											<th width="15%">日期<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">车次<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">出发地<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">目的地<i class="w_table_split"></i></th> -->
					<!-- 											<th width="10%">数量<i class="w_table_split"></i></th> -->
					<!-- 											<th width="25%">摘要<i class="w_table_split"></i></th> -->
					<%-- 											<c:if test="${groupOrder.stateFinance!=1}"> --%>
					<!-- 												<th width="15%">操作<i class="w_table_split"></i></th> -->
					<%-- 											</c:if> --%>
					<!-- 										</tr> -->
					<!-- 									</thead> -->
					<%-- 									<c:forEach items="${trainticketagentList }" --%>
					<%-- 										var="trainticketagent" varStatus="index"> --%>
					<!-- 										<tr> -->
					<%-- 											<td>${index.count }</td> --%>
					<%-- 											<td>${trainticketagent.requireDate }</td> --%>
					<%-- 											<td>${trainticketagent.classNo}</td> --%>
					<%-- 											<td>${trainticketagent.cityDeparture}</td> --%>
					<%-- 											<td>${trainticketagent.cityArrival}</td> --%>
					<%-- 											<td>${trainticketagent.countRequire}</td> --%>
					<%-- 											<td style="text-align: left;">${trainticketagent.remark}</td> --%>
					<%-- 											<c:if test="${groupOrder.stateFinance!=1}"> --%>
					<!-- 												<td><a href="javascript:void(0);" -->
					<%-- 													onclick="toEditTrainticket(${trainticketagent.id})" --%>
					<!-- 													class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a -->
					<!-- 													href="javascript:void(0);" -->
					<%-- 													onclick="delTransfer(${trainticketagent.id})" class="def">删除</a></td> --%>
					<%-- 											</c:if> --%>
					<!-- 										</tr> -->
					<%-- 									</c:forEach> --%>
					<!-- 								</table> -->
					<!-- 							</div> -->
					<!-- 							<div class="clear"></div> -->
					<!-- 						</dd> -->
					<!-- 					</dl> -->

				
							</div>
				<div class="clear"></div>
			</dd>

		</dl>
		<p class="p_paragraph_title">
			<b>客人名单</b>
		</p>
		<dl class="p_paragraph_content">
			<c:if test="${groupOrder.stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;<input type="hidden" value="${allowNum}" id="allowNum" /></span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button type="button" class="button button-primary button-small"
							onclick="toAddGuest()">新增客人</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>

			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i></span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="5%">序号<i class="w_table_split"></i></th>
								<th width="5%">姓名<i class="w_table_split"></i></th>
								<th width="5%">性别<i class="w_table_split"></i></th>
								<th width="5%">年龄<i class="w_table_split"></i></th>
								<th width="10%">籍贯<i class="w_table_split"></i></th>
								<th width="5%">职业<i class="w_table_split"></i></th>
								<th width="5%">类别<i class="w_table_split"></i></th>
								<th width="5%">证件类型<i class="w_table_split"></i></th>
								<th width="12%">证件号码<i class="w_table_split"></i></th>
								<th width="8%">手机号码<i class="w_table_split"></i></th>
								<th width="5%">是否单房<i class="w_table_split"></i></th>
								<th width="5%">是否领队<i class="w_table_split"></i></th>
								<th width="15%">备注<i class="w_table_split"></i></th>
								<c:if test="${groupOrder.stateFinance!=1}">
									<th width="10%">操作<i class="w_table_split"></i></th>
								</c:if>
							</tr>
						</thead>
						<c:forEach items="${guestList }" var="guest" varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td><c:if test="${guest.historyNum>1}">
										${guest.name}
										<a class="button button-tinier button-plus"
											onclick="showHistory('${guest.certificateNum}',${guest.orderId})" style="color:red;">${guest.historyNum}</a>
									</c:if> <c:if test="${guest.historyNum<=1}">
										${guest.name}
									</c:if></td>
								<td><c:if test="${guest.gender==1 }">男</c:if> <c:if
										test="${guest.gender==0 }">女</c:if></td>

								<td>${guest.age}</td>
								<td>${guest.nativePlace}</td>
								<td>${guest.career}</td>
								<td><c:if test="${guest.type==1 }">成人</c:if> <c:if
										test="${guest.type==2  }">儿童</c:if></td>

								<td><c:forEach items="${zjlxList}" var="zjlx">
										<c:if test="${zjlx.id==guest.certificateTypeId }">${zjlx.value }</c:if>
									</c:forEach></td>

								<td>${guest.certificateNum}</td>
								<td>${guest.mobile}</td>
								<td><c:if test="${guest.isSingleRoom==0 }">否</c:if> <c:if
										test="${guest.isSingleRoom==1 }">是</c:if></td>
								<td><c:if test="${guest.isLeader==0 }">否</c:if> <c:if
										test="${guest.isLeader==1 }">是</c:if></td>
								<td style="text-align: left;">${guest.remark}</td>
								<c:if test="${groupOrder.stateFinance!=1}">
									<td>
									<c:if test="${guest.editType}">
									<a href="javascript:void(0);"
										onclick="toEditGuest(${guest.id})" class="def">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a
										href="javascript:void(0);" onclick="delGuest(${guest.id})"
										class="def">删除</a>
									</c:if>
										</td>
								</c:if>
							</tr>
						</c:forEach>

					</table>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
	</div>
	<jsp:include page="groupOrderInclude.jsp"></jsp:include>
</body>
</html>
<script type="text/javascript">
/**
 * 显示客人的历史参团记录
 * @param guestCertificateNum
 */
function showHistory(guestCertificateNum,orderId){
	layer.open({
		type : 2,
		title : '参团历史信息',
		shadeClose : true,
		shade : 0.5,
        area : ['800px','500px'],
        content : "../guest/getGuestOrderInfo.htm?guestCertificateNum="+guestCertificateNum+"&orderId="+orderId
	});
}
</script>