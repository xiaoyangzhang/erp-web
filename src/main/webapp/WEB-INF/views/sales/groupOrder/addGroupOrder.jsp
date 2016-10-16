<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%	String base = request.getContextPath(); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>增加散客团</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/individuaGroups.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/card/native-info.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/card/card.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/card/region-card-data.js"></script>
	<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>

<script type="text/javascript">
	var win;
	function selectSelfSupplier() {
		win = layer.open({
			type : 1,
			title : '组团社信息',
			shadeClose : true,
			shade : 0.5,
			area : [ '500px', '300px' ],
			content : $('#selectSupplier')
		});
	}	
	
	function selectSupplierBtn() {
		var info = $("input[name='supplierChecked']:checked").val().split(",");
		$("#supplierId").val(info[0]);
		$("#supplierName").val(info[1]);
		if(info[2]!=-1){
			$("#allowNum").val(info[2]);
		}
		layer.close(win);
	}
	
	/** * 选择组团社 */
	function selectSupplier(){
		layer.openSupplierLayer({
			title : '选择组团社',
			content : getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选组团社");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}

	var win2;
	function inputRemark(i){
		$("#remarkInputIndex").val(i);
		$("#textRemarkInput").val($("input[name='groupOrderGuestList["+i+"].remark']").val());
		win2 = layer.open({
			type : 1, title : '输入备注', shadeClose : true, shade : 0.5,	area : [ '500px', '300px' ],
			content : $('#divRemarkInput')
		});
	}
	function setRemark(i, text){
		$("input[name='groupOrderGuestList["+i+"].remark']").val(text);
		var remarkText = text;
		if (remarkText && remarkText.length>10){
			remarkText = remarkText.substr(0,8)+"...";
		}
		$("#remarkText"+i).html(remarkText);
	}
$(function(){
	$("#btnSaveRemark").click(function(){
		var i=$("#remarkInputIndex").val();
		setRemark(i, $("#textRemarkInput").val());
		layer.close(win2);
		return false;
	});
});
</script>
</head>
<body>
<div id="divRemarkInput" style="display:none;">
<input type="hidden" id="remarkInputIndex"/>
<textarea style="width:450px; height:200px; margin:10px;" id="textRemarkInput" placeholder="输入备注"></textarea>
<a id="btnSaveRemark" class="button button-primary button-small" style="margin-left:10px;" href="javascript:void();">保存</a>
</div>
	<h2>
		【${productInfo.brandName}】${productInfo.nameCity }
	</h2>
	<div class="p_container_sub" id="tab1">
		<input id="allowNum" value="${allowNum }" type="hidden" />
		<form id="saveOrderForm">
			<p class="p_paragraph_title">
				<b>预定信息</b>
			</p>
			<dl class="p_paragraph_content">

				<dd>
					<div class="dd_left">
						<i class="red">* </i>产品简称
					</div>
					<div class="dd_right">
						<input type="hidden" name="groupOrder.productId"
							value="${productInfo.id }" /> <input type="hidden"
							name="groupOrder.productBrandId" value="${productInfo.brandId }" />
						<input type="hidden" name="priceId" value="${priceId}" />
						<input type="hidden" name="priceGroupId" value="${groupId}" /> <input
							type="hidden" name="groupOrder.productBrandName"
							value="${productInfo.brandName }" /> <input type="hidden"
							name="groupOrder.productName"
							value="${productInfo.nameCity }" />
						<input type="hidden" name="groupOrder.state" value="1" /> <input
							type="hidden" name="groupOrder.orderType" value="0" /> <input
							type="text" name="groupOrder.productShortName" class="IptText300"
							placeholder="产品简称"
							value="${productInfo.nameCity }">
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">发团日期</div>
					<div class="dd_right">
						<input type="hidden" name="groupOrder.departureDate"
							class="IptText300"
							value='<fmt:formatDate value="${groupPrice.groupDate }" pattern="yyyy-MM-dd"/>' />
						<fmt:formatDate value="${groupPrice.groupDate }"
							pattern="yyyy-MM-dd" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">客源类别</div>
					<div class="dd_right">
						<input type="hidden" name="groupOrder.sourceTypeName" class="IptText300"  id="sourceTypeName" />
						<select name="groupOrder.sourceTypeId" id="sourceTypeCode">
							<option value="-1">请选择</option>
							<c:forEach items="${sourceTypeList }" var="source">
								<option value="${source.id }">${source.value}</option>
							</c:forEach>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">客源地</div>
					<div class="dd_right">
						<input type="hidden" name="groupOrder.provinceName" class="IptText300" id="provinceName"  />
						<input type="hidden" name="groupOrder.cityName" class="IptText300" id="cityName"  />
						<select name="groupOrder.provinceId" id="provinceCode">
							<option value="-1">请选择省</option>
							<c:forEach items="${allProvince }" var="province">
								<option value="${province.id }">${province.name}</option>
							</c:forEach>
						</select>
						<select name="groupOrder.cityId" id="cityCode">
							<option value="-1">请选择市</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"><i class="red">* </i>销售</div>
					<div class="dd_right">
						<input name="groupOrder.saleOperatorName" type="text"
							class="IptText300" value="${curUser.name}" readonly="readonly" />
						<input type="hidden" name="groupOrder.saleOperatorId"
							value="${curUser.employeeId }" /> <a href="javascript:void(0)"
							onclick="selectUser();">请选择</a>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"><i class="red">* </i>组团社</div>
					<div class="dd_right">
						<input name="groupOrder.supplierId" id="supplierId" type="hidden" />
						<input name="groupOrder.supplierType" id="supplierType" type="hidden" />
						<input type="text" id="supplierName" name="groupOrder.supplierName" class="IptText300" /> 
						<c:if test="${productGroup.groupSetting==0 }">
							<a  href="javascript:void(0)" onclick="selectSelfSupplier();">请选择</a>
						</c:if>
						<c:if test="${productGroup.groupSetting==1 }">
							<a  href="javascript:void(0)" onclick="selectSupplier();">请选择</a>
						</c:if>
						
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">组团社团号</div>
					<div class="dd_right">
						<input type="text" name="groupOrder.supplierCode"
							class="IptText300" placeholder="组团社团号" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"><i class="red">* </i>组团社联系人</div>
					<div class="dd_right">
						<input type="text" name="groupOrder.contactName"
							class="IptText100" placeholder="姓名" /> <input type="text"
							name="groupOrder.contactTel" class="IptText100" placeholder="电话" />
						<input type="text" name="groupOrder.contactMobile"
							class="IptText100" placeholder="手机" /> <input type="text"
							name="groupOrder.contactFax" class="IptText100" placeholder="传真" />
						<a href="javascript:void(0)" onclick="selectContact();">请选择</a>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"><i class="red">* </i>接站牌内容</div>
					<div class="dd_right">
						<input type="text" name="groupOrder.receiveMode" class="IptText300" placeholder="接站牌内容" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">客人名单</div>
					<div class="dd_right">
						<a href="javascript:void(0)" class="button button-primary button-small" onclick="batchInput()">录入客人名单</a>
						<input type="hidden" name="groupOrder.numAdult"/><input type="hidden" name="groupOrder.numChild"/>
						&nbsp;&nbsp;&nbsp;&nbsp;人数：<span id="spanGuestNum">0大0小</span>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<table cellspacing="0" cellpadding="0" class="w_table" id="personTable" style="min-width:850px;">
							<thead>
								<tr>
									<th width="60px;">姓名<i class="w_table_split"></i></th>
									<th width="75px;">证件类型<i class="w_table_split"></i></th>
									<th width="140px;">证件号<i class="w_table_split"></i></th>
									<th width="60px;">成人<i class="w_table_split"></i></th>
									<th width="50px;">性别<i class="w_table_split"></i></th>
									<th width="42px;">年龄<i class="w_table_split"></i></th>
									<th width="50px;">籍贯<i class="w_table_split"></i></th>
									<th width="102px;">手机号<i class="w_table_split"></i></th>
									<th width="90px;">职业<i class="w_table_split"></i></th>
									<th width="60px;">单房差<i class="w_table_split"></i></th>
									<th width="50px;">领队<i class="w_table_split"></i></th>
									<th width="70px;">备注<i class="w_table_split"></i></th>
								</tr>
							</thead>
							<tbody id="numAdult">
							</tbody>
							<tbody id="numChild">
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">服务标准</div>
					<div class="dd_right">
						<textarea class="w_textarea" name="groupOrder.serviceStandard"
							placeholder="服务标准">${productRemark.itemInclude }${productRemark.itemExclude }</textarea>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">备注</div>
					<div class="dd_right">
						<textarea class="w_textarea" name="groupOrder.remark"
							placeholder="备注"></textarea>
					</div>
					<div class="clear"></div>
				</dd>

			</dl>
			<p class="p_paragraph_title">
				<b>可选项目预订</b>
			</p>
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<table cellspacing="0" cellpadding="0" class="w_table">
							<thead>
								<tr>
									<th>序号<i class="w_table_split"></i></th>
									<th>项目<i class="w_table_split"></i></th>
									<th>备注<i class="w_table_split"></i></th>
									<th>单价<i class="w_table_split"></i></th>
									<th>成本价<i class="w_table_split"></i></th>
									<th>数量<i class="w_table_split"></i></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${grouplist }" var="group" varStatus="i">
									<tr>
										<td>1</td>
										<td><input name="groupOrderPriceList[${i.index }].itemId"
											type="hidden" value="${group.itemId }" /><input
											name="groupOrderPriceList[${i.index }].itemName"
											value="${group.itemName }" type="hidden" class="IptText200" />${group.itemName }</td>
										<td><input name="groupOrderPriceList[${i.index }].remark"
											type="hidden" class="IptText200" value="${group.remark }" />${group.remark}</td>
										<td><input
											name="groupOrderPriceList[${i.index }].unitPrice"
											type="hidden" class="IptText100" value="${group.priceSale }" />${group.priceSale }<input
											name="groupOrderPriceList[${i.index }].numTimes"
											type="hidden" value="1" class="IptText100" /></td>
										<td><input
											name="groupOrderPriceList[${i.index }].primeCost"
											value="${group.priceCost }" type="hidden" />${group.priceCost }</td>
										<td><input
											name="groupOrderPriceList[${i.index }].numPerson" type="text"
											class="IptText100" value="1" /></td>
									</tr>
								</c:forEach>
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
							<button type="submit" class="button button-primary button-small">保存</button>
						</div>
					</dd>
				</dl>
			</div>
		</form>
	</div>
<table style="display:none;">
	<tr id="guestTemplate" style="display:none;">
	<td><input name="groupOrderGuestList[$index].name" type="hidden"/>
		<span id="guestName$index"></span></td>
	<td><select name="groupOrderGuestList[$index].certificateTypeId" style="width:75px;" onchange="updateIDCardTip($index)">
		<c:forEach items="${zjlxList}" var="zjlx"><option value="${zjlx.id}">${zjlx.value}</option></c:forEach> 
		</select></td>
	<td><input type="hidden" name="groupOrderGuestList[$index].certificateNum"/>
		<span id="certificateNum$index"></span><br/><span id="certificateNumWarn$index" style="color:red;"></span></td>
	<td><select name="groupOrderGuestList[$index].type" onchange="updateGuestNum();">
		<option value="1">成人</option><option value="2">儿童</option>
		</select></td>
	<td><select name="groupOrderGuestList[$index].gender">
		<option value="-1">&nbsp;</option><option value="1">男</option><option value="0">女</option>
		</select></td>
	<td><input name="groupOrderGuestList[$index].age" type="text" size="1"><span id="guestAge$index"></span></td>
	<td><input name="groupOrderGuestList[$index].nativePlace" type="text" size="2"><span id="guestNativePlace$index"></span></td>
	<td><input name="groupOrderGuestList[$index].mobile" type="text" size="12" placeholder="手机"></td>
	<td><input name="groupOrderGuestList[$index].career" type="text" size="10" placeholder="职业"></td>
	<td><select name="groupOrderGuestList[$index].isSingleRoom" class="valid">
		<option value="0">否</option><option value="1">是</option>
		</select></td>
	<td><select name="groupOrderGuestList[$index].isLeader" class="valid">
		<option value="0">否</option><option value="1">是</option>
	</select></td>
	<td><input name="groupOrderGuestList[$index].remark" type="hidden">
		<span id="remarkText$index"></span>
		<a href="javascript:inputRemark($index);">备注</a></td>
	</tr>
</table>

	<div style="display: none;margin-top:20px;margin-left: 10px;" id="batchInput">
		<textarea class="l_textarea" name="batchInputText" value=""
			id="batchInputText" placeholder="姓名,证件号码,手机号" style="width: 600px;height:250px;"></textarea>
		<div style="margin-top:10px;">
			<a href="javascript:void(0);" onclick="toSubmit()"
				class="button button-primary button-small">保存</a> <span><i
				class="red">按照上面格式填写后提交即可，回车换行添加多人信息 </i></span>
		</div>
	</div>

<script type="text/javascript">
	var index;
	var existingGuests = []; // 已经显示在列表中的客人名单
	//var guests = []; // [{name:"张三", code:"110108199001011011"}, {}, ...]
	function batchInput() {
		if($("#supplierId").val()==''){ $.warn("请先选择组团社");return ;} 
		index = layer.open({
			type : 1,
			title : '客人名单录入（格式：姓名，证件号码，手机号）',
			shadeClose : true,
			shade : 0.5,
			area : [ '700px', '400px' ],
			content : $('#batchInput')
		});
	}
	/* 读取已经编辑的用户信息 */
	function readExistingGuests(){
		var i=0; existingGuests=[];
		while($("input[name='groupOrderGuestList["+i+"].name']").length>0){
			var guest = {
				"name": $("input[name='groupOrderGuestList["+i+"].name']").val() ,
				 "code": $("input[name='groupOrderGuestList["+i+"].certificateNum']").val(), 
				 "certificateTypeId":$("select[name='groupOrderGuestList["+i+"].certificateTypeId']").val(), 
				 "type":$("select[name='groupOrderGuestList["+i+"].type']").val(), 
				 "gender":$("select[name='groupOrderGuestList["+i+"].gender']").val(), 
				 "age":$("input[name='groupOrderGuestList["+i+"].age']").val(), 
				 "nativePlace":$("input[name='groupOrderGuestList["+i+"].nativePlace']").val(), 
				 "mobile":$("input[name='groupOrderGuestList["+i+"].mobile']").val(), 
				 "remark":$("input[name='groupOrderGuestList["+i+"].remark']").val(), 
				 "isSingleRoom":$("select[name='groupOrderGuestList["+i+"].isSingleRoom']").val(), 
				 "isLeader":$("select[name='groupOrderGuestList["+i+"].isLeader']").val(), 
				 "career":$("input[name='groupOrderGuestList["+i+"].career']").val()
			};
			existingGuests.push(guest);
			i++;
		}
	}
	function checkBatchInput(){
		var text = $("#batchInputText").val();
		var guests=[];
		text=text.replace(/ /g, "");
		var strs = text.split("\n");
		for(var i=0; i<strs.length; i++){
			var lineNum = i+1;
			if (strs[i]==""){
				continue;
			}
			strs[i] = $.trim(strs[i]);
			strs[i] = strs[i].replace(/\r/g, ",").replace(/，/g, ",").replace(/。/g, ",");
			
			var items=strs[i].split(',');
			if (items.length<2){
				$.error("第" + lineNum.toString() + "行输入格式不对"); 
				guests=[]; return false;
			}
			for (i2 in guests){
				if (items[1]==guests[i2].code){
					$.error("第" + lineNum.toString() + "行证件号码重复");
					guests=[]; return false;
				}
			}
			var tmpGuest = {"name":items[0], "code":items[1]};
			if (items[2]){tmpGuest["mobile"]=items[2];}
			guests.push(tmpGuest);
		}
		if (guests.length==0) {
			$.info("输入信息为空");
			return false;
		}
		if ($("#allowNum").val() < guests.length) {
			$.warn("当前录入人数大于团允许人数！");
			return false;
		}
		return guests;
	}

	/* testGuests = [{"name":"刘康康", "code":"110101199811014472", "certificateTypeId":127, "type":2, "gender":1, "age":4, 
					"nativePlace":"许昌", "mobile":"13344445555", "remark":"好吃懒做", "isSingleRoom":1, "isLeader":1, career:"幼儿园"},
	              {"name":"汪老师", "code":"110101198310013768", "mobile":"13303740908"}]; */
	function showGuest(arrGuest){
		$("#numAdult").html("");
		var html = $("#guestTemplate").html();
		for (var i in arrGuest){
			var guest = arrGuest[i];
			
			var newTr=html;
			newTr=newTr.replace(/\\$index/g, i);
			$("#numAdult").append("<tr>"+newTr+"</tr>");
			$("#guestName"+i).html(guest.name);
			$("input[name='groupOrderGuestList["+i+"].name']").val(guest.name);
			$("#certificateNum"+i).html(guest.code);
			$("input[name='groupOrderGuestList["+i+"].certificateNum']").val(guest.code);
			if (guest.certificateTypeId){
				$("select[name='groupOrderGuestList["+i+"].certificateTypeId']").val(guest.certificateTypeId);
			}
			var certifiType = $("select[name='groupOrderGuestList["+i+"].certificateTypeId'] option:selected").html();
			var card=$.parseIDCard(guest.code);
			if (certifiType=="身份证" && card.tip==''){ // 是身份证
				if (card.age && card.age<12){
					$("select[name='groupOrderGuestList["+i+"].type']").val(2);
				}
				if (card.gender=="女"){
					$("select[name='groupOrderGuestList["+i+"].gender']").val(0);
				}else if(card.gender=="男"){
					$("select[name='groupOrderGuestList["+i+"].gender']").val(1);
				}
				$("input[name='groupOrderGuestList["+i+"].age']").val(card.age);
				//$("#guestAge"+i).html(card.age);
				$("input[name='groupOrderGuestList["+i+"].nativePlace']").val(card.birthPlace);
	 			if(i==0){
				
				if($("#provinceName").val()=='' && card.birthPlace!=''){
					var nativeinfo = new nativeInfo(card.birthPlace);
		    		var proinfo = eval("("+ nativeinfo.province()+")" ); 
		    
		    		$("#provinceName").val(proinfo.proname);
		    		$("#provinceCode").val(proinfo.proid);
				}
			}
				//$("#guestNativePlace"+i).html(card.birthPlace);
			}else { // 不是身份证
				if (certifiType=="身份证"){
					$("#certificateNumWarn"+i).html(card.tip);
				}
				$("input[name='groupOrderGuestList["+i+"].age']").val(guest.age);
				$("input[name='groupOrderGuestList["+i+"].nativePlace']").val(guest.nativePlace);
				$("select[name='groupOrderGuestList["+i+"].gender']").val(guest.gender);
				$("select[name='groupOrderGuestList["+i+"].type']").val(guest.type);
			}
			$("input[name='groupOrderGuestList["+i+"].career']").val(guest.career);
			$("select[name='groupOrderGuestList["+i+"].isSingleRoom']").val(guest.isSingleRoom);
			$("select[name='groupOrderGuestList["+i+"].isLeader']").val(guest.isLeader);
			$("input[name='groupOrderGuestList["+i+"].mobile']").val(guest.mobile);
			setRemark(i, guest.remark);
		}
		updateGuestNum();
		if (arrGuest.length>0){
			updateReceiveMode(arrGuest[0].name);
		}
	}
	
	function updateGuestNum(){
		var i=0; numAdult=0; var numChild=0;
		while($("select[name='groupOrderGuestList["+i+"].type']").length>0){
			if ($("select[name='groupOrderGuestList["+i+"].type']").val()==1){
				numAdult++;
			}else if ($("select[name='groupOrderGuestList["+i+"].type']").val()==2){
				numChild++;
			}
			i++;
		}
		$("#spanGuestNum").html(numAdult+"大"+numChild+"小");
		$("input[name='groupOrder.numAdult']").val(numAdult);
		$("input[name='groupOrder.numChild']").val(numChild);
	}
	function updateIDCardTip(i){
		var certifiType = $("select[name='groupOrderGuestList["+i+"].certificateTypeId'] option:selected").html();
		if (certifiType=="身份证"){
			var code=$("input[name='groupOrderGuestList["+i+"].certificateNum']").val();
			var card=$.parseIDCard(code);
			if (card.tip!=""){
				$("#certificateNumWarn"+i).html(card.tip);
			}
		}else {
			$("#certificateNumWarn"+i).html("");
		}
	}
	function updateReceiveMode(receiveMode){
		if ($("input[name='groupOrder.receiveMode']").val()==""){
			$("input[name='groupOrder.receiveMode']").val(receiveMode);
		}
	}
	
	function toSubmit() {
		
		var guests = checkBatchInput();
		if (!guests){return false;}
		readExistingGuests();
		if (existingGuests.length>0){
			for (var i in guests){
				for (var j in existingGuests){
					eg = existingGuests[j];
					if (guests[i].code==eg.code){
						var tmpName = guests[i].name;
						guests[i]=eg;
						guests[i].name=tmpName;
					}
				}
			}
		}
		showGuest(guests);
		layer.close(index);
		return ;
	}
	function checkGuestList(){
		var i=0; var findNull=false;
		while($("select[name='groupOrderGuestList["+i+"].gender']").length>0){
			if ($("select[name='groupOrderGuestList["+i+"].gender']").val()<0){
				findNull=true;
			}
			if ($("select[name='groupOrderGuestList["+i+"].age']").val()==""){
				findNull=true;
			}
			i++;
		}
		if (findNull){
			$.warn("请输入客人性别和年龄"); 
			return false;
		}
		return true;
	}
	
$("document").ready(function(){
	$("#saveOrderForm").submit(function(){
		return checkGuestList();
	});
});
	
</script>
</body>
<div id="selectSupplier" style="display: none">
	<dl class="p_paragraph_content">
		<div class="searchRow">
			<dd>
				<table cellspacing="0" cellpadding="0" class="w_table">
					<thead>
						<tr>
							<th></th>
							<th>序号<i class="w_table_split"></i></th>
							<th>名称<i class="w_table_split"></i></th>
							<th>区域<i class="w_table_split"></i></th>
							<th>库存<i class="w_table_split"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${fn:length(groupSuppliersList)==0 }">
							<tr>
								<td colspan="5">暂无可用组团社信息</td>
							</tr>
						</c:if>
						<c:if test="${fn:length(groupSuppliersList)!=0 }">
							<c:forEach items="${groupSuppliersList}" var="groupSupplier"
								varStatus="index">
								<tr>
									<td><input type="radio" name="supplierChecked" onclick="selectSupplierBtn();"
										value="${groupSupplier.supplierId},${groupSupplier.supplierName},${groupSupplier.stock }" /></td>
									<td>${index.count }</td>
									<td>${groupSupplier.supplierName }</td>
									<td>${groupSupplier.province}${groupSupplier.city}${groupSupplier.area}${groupSupplier.town}</td>
									<td><c:if test="${groupSupplier.stock==-1}">未分配</c:if><c:if test="${groupSupplier.stock!=-1}">${groupSupplier.stock}</c:if></td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
		</dd>
		</div>
	</dl>
</div>
<script type="text/javascript">
	var supplierType = 1;
	$(function(){
       var param = "";
       <c:if test="${productGroup.groupSetting==1 }">
       	JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType="+supplierType, param, "supplierId", customerTicketCallback, 1);
	   </c:if>
   });
   function customerTicketCallback(event, value) {
       
   } 
</script>
</html>