<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<c:choose>
	<c:when test="${resource.id!=null && resource.id!=''}">
		<c:set var="pageRefer" value="edit" />
	</c:when>
	<c:otherwise>
		<c:set var="pageRefer" value="add" />
	</c:otherwise>
</c:choose>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<style>
.button-plus{width:50px;}
.airLineInfo {line-height:14px; }
.airLineText{width:40px;}
.inputTime {width:60px;}
</style>
<script src="<%=staticPath %>/assets/js/jquery-ui/jquery.tooltip.js"></script>
<script type="text/javascript">
	//保存
	function save(){
		$("#saveAirTicketResourceForm").validate({
			rules:{
				'startDate' : {required : true },
				'depDate' : {required : true },
				'airCode' : {required : true },
				'depCity' : {required : true },
				'arrCity' : {required : true },
				'ticketSupplier' : {required : true },
				//'ticketOrderNum' : {required : true },
				'totalNumber' : {required : true },
				'buyPrice' : {required : true },
				'price' : {required : true },
				'endIssueTime': {required: true}
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
				$("input[name='depCityFirst']").val($("input[name='depCity']:first").val());
				$("input[name='depDateFirst']").val($("input[name='depDate']:first").val());
				if (!checkTime()){return false;}
				arrPost = YM.getFormData("saveAirTicketResourceForm");
				arrPost['legList'] = JSON.stringify(getLegValues());
				if ($("input[name='radioLineName']:checked").val()=="choose"){
					arrPost['lineName']=$("#chooseLineName").val();
				}else {
					arrPost['lineName']=$("#inputLineName").val();
				}
				YM.post("save.do", arrPost, function(){
					$.success("操作成功");
					 window.setTimeout(function(){
						 if("${pageRefer}" == "edit"){
							 refreshWindow("机票资源${resource.resourceNumber }", "<%=path%>/airticket/resource/edit.htm?id=${resource.id }");
						 }else if("${pageRefer}" == "add"){
							 refreshWindow("新增机票资源", "<%=path%>/airticket/resource/add.htm");
						 }
					 }, 1000);
				});
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
		$("#saveAirTicketResourceForm").submit();
	}

	//循环返回航段行
	function getLegValues(){
		var legArr = [];
		$(".second").each(function(){
			var sepObj = {};
			sepObj.depDate = $(this).find("input[name=depDate]").val();
			sepObj.depCity = $(this).find("input[name=depCity]").val();
			sepObj.arrCity = $(this).find("input[name=arrCity]").val();
			sepObj.airCode = $(this).find("input[name=airCode]").val();
			sepObj.depTime = $(this).find("input[name=depTimeHid]").val();
			sepObj.arrTime = $(this).find("input[name=arrTimeHid]").val();
			if(sepObj.depDate && sepObj.depCity && sepObj.arrCity && sepObj.airCode){
				legArr[legArr.length] = sepObj;
			}
		});
		return legArr;
	}
	
$(function(){
	addAirInfoComplete();
	$(".inputTime").tooltip();
});

function addAirInfoComplete(){
	$("input[name='depDate']").blur(function(){getDepTime($(this));});
	$("input[name='airCode']").change(function(){getDepTime($(this));});
	$("input[name='arrCity']").change(function(){getDepTime($(this));});
	$("input[name='depCity']").change(function(){getDepTime($(this));});
}

function getDepTime(obj){
	var depDate = obj.parent().find("input[name='depDate']").val();
	var airCode = obj.parent().find("input[name='airCode']").val();
	var depCity = obj.parent().find("input[name='depCity']").val();
	var arrCity = obj.parent().find("input[name='arrCity']").val();
	if (airCode.length!=6 && airCode.length!=7){
		return ;
	}
	if (depDate && airCode && depCity && arrCity){
		var airLineURL = "<%=path%>/airticket/resource/getAirLine.do?date="+depDate+"&airCode="+airCode+"&depCity="+depCity+"&arrCity="+arrCity;
		$.getJSON(airLineURL, callBackAirInfo(obj));
	}
}
function callBackAirInfo(obj){
	return function(data){
		if ((data.result!=200)){
			obj.parent().find(".airLineInfoMsg").html(data.message);
			//obj.parent().find("input[name='depTime']").val("");
			//obj.parent().find("input[name='arrTime']").val("");
			return;
		}
		obj.parent().find(".airLineInfoMsg").html("");
		obj.parent().find("input[name='depTime']").val(data.depTime);
		obj.parent().find("input[name='arrTime']").val(data.arrTime);
	};
}
function deleteLine(){
	var lineName = $("#chooseLineName").val();
	if (!lineName){alert("请先选择航线。"); return false;}
	if (!confirm("确认删除此航线信息："+lineName+"？")){
		return false;
	}
	$.getJSON("deleteLine.do?lineName="+lineName, function(data){
		$.success("操作成功");
		window.setTimeout(function(){
			if("${pageRefer}" == "edit"){
				refreshWindow("机票资源${resource.resourceNumber }", "<%=path%>/airticket/resource/edit.htm?id=${resource.id }");
			}else if("${pageRefer}" == "add"){
				refreshWindow("新增机票资源", "<%=path%>/airticket/resource/add.htm");
			}
		}, 1000);
	});
}

//复制航段行
function addLineListener(e){
	if($(e.target).text().trim() == "＋"){
		var line = $(".second :last"),copyElem = line.clone();
		line.after(copyElem);
		$(".second :last input").each(function(){$(this).val("");});
		$(".second :last .airLineInfoMsg").html("");
		$(".second :last input[name='depDate']").attr("placeholder", "航班日期");
		$(e.target).text('-');
		$(".second :last").find("a").bind("click",function(e){
			addLineListener(e);
		});
		$(".second :last").find("input[name='depDate']").blur(function(){getDepTime($(this));});
		$(".second :last").find("input[name='airCode']").change(function(){getDepTime($(this));});
		$(".second :last").find("input[name='arrCity']").change(function(){getDepTime($(this));});
		$(".second :last").find("input[name='depCity']").change(function(){getDepTime($(this));});
		$(".second :last .inputTime").tooltip();
	}else{
		$(e.target).parents("dd:first").remove();
	}
}

//选择机票供应商
function selectAir(){
	var type=9;
	if($("#rb_type_train").attr("checked")){
		type=10;
	}
	layer.openSupplierLayer({
		title : '选择机票',
		content : '<%=path%>/component/supplierList.htm?supplierType='+type,
		callback: function(arr){
			if(arr.length==0){ $.warn("请选择商家 "); return false;}
			$("input[name='ticketSupplier']").val(arr[0].name);
			$("input[name='ticketSupplierId']").val(arr[0].id);
	    }
	});
}

function loadLegs(lineName){
	$(".second :last input").each(function(){$(this).val("");});
	$(".second :last input[name='depDate']").attr("placeholder", "航班日期");
	var line = $(".second :last"), lineElem = line.clone();
	var pos = $("#ddSaveTemplate");
	if (lineName==""){
		$(".second").remove();
		pos.before(lineElem);
		$(".second a").click(function(e){addLineListener(e);});
	}else {
		$.getJSON("getLineTemplates.do?templateName="+lineName, function(legs){
			$(".second").remove();
			for(var i in legs){
				leg=legs[i];
				pos.before(lineElem.clone());
				if (i!=0){
					$(".second :last input[name='depDate']").attr("placeholder", "+"+leg['date_offset']+'天');
				}
				$(".second :last input[name='airCode']").val(leg['air_code']);
				$(".second :last input[name='depCity']").val(leg['dep_city']);
				$(".second :last input[name='arrCity']").val(leg['arr_city']);
			}
			$(".second :first input[name='depDate']").attr("onclick", "WdatePicker({dateFmt:'yyyy-MM-dd', onpicked:updateDates})");
			$(".second a").text('-');
			$(".second:last a").text('＋');
			$(".second a").click(function(e){addLineListener(e);});
			addAirInfoComplete();
		});
	}
}
function updateDates(){
	startDay = $(".second:first input[name='depDate']").val();
	$(".second input[name='depDate']").each(function(){
		var p=$(this).attr('placeholder');
		var offset = p.match(/\d+/); 
		if (offset!=null){
			$(this).val(addDays(startDay, offset));
		}
		getDepTime($(this));
	});
	$(".second :first input[name='depDate']").attr("onclick", "WdatePicker({dateFmt:'yyyy-MM-dd'})");
}

// curDay加N天，
function addDays(curDay, n){
	n=Number(n);
	patten = new RegExp(/\d+-\d+-\d+/);
	if (!patten.test(curDay)){return '';}
	arr = curDay.split('-');
	var newdt = new Date(Number(arr[0]),Number(arr[1])-1,Number(arr[2])+n); 
	MM = ("00"+(newdt.getMonth()+1)).substr(-2);
	dd = ("00"+(newdt.getDate())).substr(-2);
    repnewdt = newdt.getFullYear() + "-" + MM + "-" + dd;  
    return repnewdt;
}

function checkTime(){
	var ret = true;
	$(".second").each(function(){ret = checkTimeUnder($(this));});
	return ret;
}
function checkTimeUnder(obj){
	var depTime = obj.find("input[name='depTime']").val();
	var arrTime = obj.find("input[name='arrTime']").val();
	var patten = new RegExp(/\d+:\d+/);
	if (!patten.test(depTime)){$.warn("请输入正确的起飞时间"); obj.find("input[name='depTime']").focus(); return false;}
	if (!patten.test(depTime)){$.warn("请输入正确的到达时间"); obj.find("input[name='arrTime']").focus(); return false;}
	var arrDep = depTime.split(':');
	var arrArr = arrTime.split(':');
	if (arrDep[0]>24 || arrDep[1]>60){$.warn("请输入正确的起飞时间"); obj.find("input[name='depTime']").focus(); return false;}
	if (arrArr[0]>24 || arrArr[1]>60){$.warn("请输入正确的到达时间"); obj.find("input[name='arrTime']").focus(); return false;}
	var depDate = obj.find("input[name='depDate']").val();
	obj.find("input[name='depTimeHid']").val(depDate + " " + depTime);
	if (arrArr[0]<arrDep[0] ){ // 如果到达时间早于起飞时间，则到达日期+1
		var arrDate = addDays(depDate, 1);
		obj.find("input[name='arrTimeHid']").val(arrDate + " " + arrTime);
	}else{
		obj.find("input[name='arrTimeHid']").val(depDate + " " + arrTime);
	}
	return true;
}
	
	//仓位类型
	$("document").ready(function(){
		<c:if test="${resource.po.type eq 'TRAIN'}">
		$("#rb_type_train").attr("checked", "checked");
		</c:if>
		$("select[name='seatType']").val("${resource.po.seatType }");
		$("#chooseLineName").val("${resource.po.lineName}");
		if ($("#chooseLineName").val()==''){
			$("#inputLineName").val("${resource.po.lineName}");
		}
		//航段"+"增加事件
		$(".second a").click(function(e){ addLineListener(e); });
		$("input[name='radioLineName']").change(function(){
			if ($(this).val()=="choose"){
				$("#chooseLineName").attr("disabled", false);
				$("#inputLineName").attr("disabled", "disabled");
				loadLegs($("#chooseLineName").val());
				$("#aDeleteLine").css("display","inline");
			}else {
				$("#chooseLineName").attr("disabled", "disabled");
				$("#inputLineName").attr("disabled", false);
				$("#aDeleteLine").css("display","none");
			}
		});
		$("#chooseLineName").change(function(){
			loadLegs($("#chooseLineName").val());
		});
		
		if ($("#inputLineName").val()!=''){
			$("input[name='radioLineName'][value='input']").attr("checked", "checked");
			$("#chooseLineName").attr("disabled", "disabled");
			$("#inputLineName").attr("disabled", false);
			$("#aDeleteLine").css("display","none");
		}else {
			$("input[name='radioLineName'][value='choose']").attr("checked", "checked");
			$("#chooseLineName").attr("disabled", false);
			$("#inputLineName").attr("disabled", "disabled");
			$("#aDeleteLine").css("display","inline");
		}
	});


/* 核对航班详细信息 */
function checkAirLineDetail(obj){
	
}
</script>
</head>
<body>
<div class="p_container" >
	   	<form id="saveAirTicketResourceForm" method="post">
	   	<input type="hidden" name="id" value="${resource.id}"/>
	    <div class="p_container_sub" id="tab1">
	    	<p class="p_paragraph_title"><b>基本信息</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">资源类型</div> 
	    			<div class="dd_right"><input type="radio" id="rb_type_air" name="type" value="AIR" checked="checked"/><label for="rb_type_air">机票</label> &nbsp;&nbsp;&nbsp;&nbsp;
	    				<input type="radio" id="rb_type_train" name="type" value="TRAIN"/><label for="rb_type_train">火车票</label></div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>采购单号</div> 
	    			<div class="dd_right"><input type="text" name="resourceNumber" class="IptText300" placeholder="系统自动产生" disabled='disabled' value="${resource.resourceNumber}"></div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">行程</div> 
	    			<div class="dd_right">
	    			开始日期：<input type="text" name="startDate" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"  value="${resource.startDate}"><i class="red">* </i>
	    			&nbsp;&nbsp;&nbsp;&nbsp;结束日期：<input type="text" name="endDate"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${resource.endDate}">
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>航线名称</div> 
	    			<div class="dd_right">
	    			<input type="radio" name="radioLineName" id="lineName1" value="choose"/><label for="lineName1">选择航线：</label>
	    			<select id="chooseLineName"><option></option>
	    			<c:forEach items="${templateNames}" var="name" varStatus="status">
	    			<option value="${name }">${name }</option>
	    			</c:forEach>
	    			</select>
	    			&nbsp;&nbsp;&nbsp;
	    			<input type="radio" name="radioLineName" id="lineName2" value="input"/><label for="lineName2">录入新航线：</label>
	    			<input type="text" id="inputLineName" class="IptText300" >
	    			</div>
					<div class="clear"></div>
					<input type="hidden" name="depCityFirst"/>
		    		<input type="hidden" name="depDateFirst"/>
	    		</dd> 
	    		<c:if test="${pageRefer eq 'add'}">
	    		<dd class="second">
	    			<div class="dd_left">航段</div>
	    			<div class="dd_right div_legs" id="divDepDate">
	    			<input type="text" name="depDate" placeholder="航班日期" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
	    			<input type="text" name="airCode" style="width:70px;" maxlength="8" placeholder="航班号" />
					<input type="text" name="depCity" style="width:70px;" placeholder="出发" /> -
					<input type="text" name="arrCity" style="width:70px;" placeholder="到达"/> 
					<span style="width:8px;">&nbsp;</span>
					<input type="text" name="depTime" placeholder="起飞时间" maxlength="5" class="inputTime" title="格式HH:mm，例如08:45" /> -
					<input type="text" name="arrTime" placeholder="到达时间" maxlength="5" class="inputTime" title="格式HH:mm，例如08:45" />
					<input type="hidden" name="depTimeHid"/><input type="hidden" name="arrTimeHid"/>
	    			<a class="button button-tinier button-plus" style="">＋</a>
					<br/><span class="airLineInfoMsg"></span>
	    			<div class="airLineInfo"></div>
	    			</div>
					<div class="clear"></div>
		    	</dd>
	    		</c:if>
	    		<c:if test="${pageRefer eq 'edit'}">
	    			<c:forEach items="${legList}" var="item" varStatus="status">
		    			<dd class="second">
			    			<div class="dd_left">航段</div>
			    			<div class="dd_right div_legs" id="divDepDate">
			    			<input type="text" name="depDate" placeholder="航班日期" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" 
			    					value="<fmt:formatDate value="${item.depDate}" pattern="yyyy-MM-dd" />"/>
			    			<input type="text" name="airCode" style="width:70px;" maxlength="8" placeholder="航班号" value="${item.airCode}"/>
							<input type="text" name="depCity" style="width:70px;" placeholder="出发" value="${item.depCity}"/> -
							<input type="text" name="arrCity" style="width:70px;" placeholder="到达" value="${item.arrCity}"/>
							<span style="width:8px;">&nbsp;</span>
							<input type="text" name="depTime" placeholder="起飞时间" maxlength="5" class="inputTime" 
									value="<fmt:formatDate value="${item.depTime}" pattern="HH:mm" />"/> -
							<input type="text" name="arrTime" placeholder="到达时间" maxlength="5" class="inputTime" 
									value="<fmt:formatDate value="${item.arrTime}" pattern="HH:mm" />"/>
							<input type="hidden" name="depTimeHid"/><input type="hidden" name="arrTimeHid"/>
			    			<a class="button button-tinier button-plus">
			    				<c:if test="${status.last}">＋</c:if>
			    				<c:if test="${!status.last}">-</c:if>
			    			</a>
			    			<br/><span class="airLineInfoMsg"></span>
			    			</div>
							<div class="clear"></div>
		    			</dd> 		
	    			</c:forEach>
	    		</c:if>
	    		<dd id="ddSaveTemplate">
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
	    				<input type="checkbox" id="saveTemplate" name="saveTemplate" checked="checked" value="save"/><label for="saveTemplate">保存航线信息</label>
	    				&nbsp;&nbsp;&nbsp;&nbsp;<a id="aDeleteLine" href="javascript:deleteLine();">删除航线信息</a>
					</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd id="ddTicketSupplier">
	    			<div class="dd_left"><i class="red">* </i>机票供应商</div> 
	    			<div class="dd_right"><!-- 
	    			<p class="pb-5">
	    			<select class="select160"  name="ticketSupplierId" id="brandId">
		    			<option value="">选择供应商</option>
	    			</select>
	    			</p> -->
	    			<input type="text" name="ticketSupplier" value="${resource.po.ticketSupplier }" class="IptText300" readOnly="readonly" />
					<input type="hidden" name="ticketSupplierId" value="${resource.ticketSupplierId }" />
					<input type="button" class="button button-primary button-small" value="选择" onclick="selectAir()" id="air"/>
	    			</div>
					<div class="clear"></div>
	    		</dd>
<!--     		<dd>
	    			<div class="dd_left">联系方式</div> 
	    			<div class="dd_right" id="divContact">
	    				<input type="text" name="contact" class="IptText60" placeholder="联系人" value="${resource.po.contact}"/>&nbsp;
	    				<input type="text" name="contactTel" class="IptText60" placeholder="电话" value="${resource.po.contactTel}"/>&nbsp;
	    				<input type="text" name="contactMobile"  class="IptText60" placeholder="手机" value="${resource.po.contactMobile}"/>&nbsp;
	    				<input type="text" name="contactFax" class="IptText60"  placeholder="传真" value="${resource.po.contactFax}"/>&nbsp;
	    				<input type="button" value="选择" class="button button-primary button-small" onclick="selectContact()" id="contact1" />
	    			</div>
					<div class="clear"></div>
	    		</dd>-->
	    		<dd>
	    			<div class="dd_left">订单号</div> 
	    			<div class="dd_right"><input type="text" name="ticketOrderNum" value="${resource.ticketOrderNum}" class="IptText60"></div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>采购数量</div> 
	    			<div class="dd_right"><input type="text" name="totalNumber" value="${resource.totalNumber}" class="IptText60">张<!-- <i class="grey ml-10">例：牛人爆款升级，最高减600.</i> --></div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>单价</div> 
	    			<div class="dd_right">
	    				<input type="text" placeholder="采购价" name="buyPrice" value="${resource.po.buyPrice}" class="IptText60">元
	    				<input type="text" placeholder="销售价" name="price" value="${resource.price}" class="IptText60">元
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">预付押金</div> 
	    			<div class="dd_right"><input type="text" name="advancedDeposit" value="${resource.advancedDeposit}" class="IptText60">元</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>最晚出票时间</div> 
	    			<div class="dd_right"><input type="text" name="endIssueTime" style="width:150px;" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"
	    				value="${resource.endIssueTime}"></div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">备注</div> 
	    			<div class="dd_right"><textarea name="comment" style="width:400px; height:120px;">${resource.comment}</textarea></div>
					<div class="clear"></div>
	    		</dd> 

	    	</dl>
	    </div>
	    <button  onclick="save()" class="button button-primary button-small" >保存</button>
	    <a href="javascript:closeWindow()" class="button button-small">关闭</a>
        </form>	
</div>
<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
</body>
</html>