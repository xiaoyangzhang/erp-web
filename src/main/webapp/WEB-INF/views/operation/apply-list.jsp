<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>领单申请</title>
	<%@ include file="../../include/path.jsp"%>
	<style type="text/css">
	 .black_tab thead tr th{border:1px solid #000;background:none;}
	  .black_tab tbody tr td{border:1px solid #000;}
	</style>
</head>
<body>
<div id="printDiv">
<!--startprint1-->	
	<div class="p_container" >
		<form id="queryForm">
			<h1  style="font-size: 20px; margin-left: 450px;">导游领单表</h1>
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
	
			<div class="p_container_sub" >
		    	<div class="searchRow" style="padding:0 5px;">
	                <ul style="border: 1px ;">
	                    <li class="text">导游:</li>
	                    <li>${reqpm.guideName}</li>
	                    <c:if test="${reqpm.isApplyOrUpdate ne 'APPLIED'}">
	                     	<li class="text">团号:</li>
							<li>${reqpm.groupCode }&nbsp;&nbsp;</li>
						</c:if>
					</ul>
					<ul style="border: 1px;">
	                    <c:if test="${reqpm.isApplyOrUpdate ne 'APPLIED'}">
							<li class="text">申请人:</li>
							<li>${applicant}&nbsp;&nbsp;</li>
							<li class="text">申请时间：</li>
		                    <li><fmt:formatDate value="${appliTime}" pattern="yyyy-MM-dd HH:mm"/></li>
						</c:if>
						<c:if test="${empty reqpm.isApplyOrUpdate }">
							<div class="searchRow" style="padding:2px;text-align:right; ">
					    		<c:if test="${reqpm.isPrint ne true}">
					    			<a href="applyPrint.htm?guideName=${reqpm.guideName}&isPrint=true&guideId=${reqpm.guideId}&groupId=${reqpm.groupId}&groupCode=${reqpm.groupCode }&isAdd=false" target="_blank">打印</a>
					    		</c:if>
					    		
					    	</div>
						</c:if>
						<li class="clear"/>
					</ul>
		    	</div>
		    	<c:if test="${not empty reqpm.isApplyOrUpdate }">
		    	<div class="searchRow" style="padding:2 5px;text-align:right;">
		    		<button type="button" onclick="addRow();" class="button button-primary button-rounded button-small">新增</button>
		    	</div>
		    	</c:if>
	        </div>
		</form>		
	</div>
		<div id="guideDiv">
		<form>
			<input id="groupId" value="${reqpm.groupId}" type="hidden" />
			<input id="guideId" value="${reqpm.guideId}" type="hidden" />
			<table id="applyTable" cellspacing="0" cellpadding="0" <c:if test="${reqpm.isPrint eq true}"> class="w_table black_tab" </c:if> <c:if test="${reqpm.isPrint ne true}"> class="w_table" </c:if>>
				<col width="5%" />
				<col width="25%" />
				<col width="20%" />
				<c:if test="${empty reqpm.isApplyOrUpdate }">
					<col width="20%" />
					<col width="20%" />
				</c:if>
				<c:if test="${not empty reqpm.isApplyOrUpdate }">
					<col width="30%" />
					<col width="10%" />
				</c:if>
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>单据类型<i class="w_table_split"></i></th>
						<th>数量<i class="w_table_split"></i></th>
						<c:if test="${empty reqpm.isApplyOrUpdate }">
							<th>单据号<i class="w_table_split"></i></th>
							<th>备注<i class="w_table_split"></i></th>
						</c:if>
						<c:if test="${not empty reqpm.isApplyOrUpdate }">
						<th>备注<i class="w_table_split"></i></th>
						<th>操作<i class="w_table_split"></i></th>
						</c:if>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${financeBillDetailList}" var="item" varStatus="status">
						
						<tr>
							<td class="serialnum">
								<div class="serialnum_btn"></div> ${status.index+1}
							</td>
							
							<c:if test="${empty reqpm.isApplyOrUpdate }">
								<td>
									<c:forEach items="${billTypeList}" var="bill">
										<c:if test="${bill.code eq item.bill_type}">
											${bill.value}
										</c:if>
									</c:forEach>
								</td>
								<td>${item.num }</td>
								<td>${item.bill_num_receive }</td>
								<td>${item.remark }</td>
							</c:if>
							<c:if test="${not empty reqpm.isApplyOrUpdate }">
								<td>
									<select id="billType" name="billType" style="width:98%" >
										<option value="">请选择</option>
										
										<c:forEach items="${billTypeList}" var="bill">
											<option value="${bill.code}"
												<c:if test="${item.bill_type == bill.code }"> selected="selected"</c:if>
											>${bill.value}</option>
										</c:forEach>
									</select>
							    </td>
								<td><input type="text" name="num" value="${item.num }" style="width:98%" /><input type="hidden" name="id" notids="${item.id }" value="${item.id }" /></td>
								<td><input type="text" name="remark" value="${item.remark }" style="width:98%" /> </td>
								<td><a class="button button-rounded button-tinier" onclick="delRow(this);">删除</a></td>
							</c:if>
						</tr>
					</c:forEach>
					
				</tbody>
			</table>
		</form>
		</div>
		<!--endprint1-->
</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
$("#btnQuery").on("click",function(){
	queryApplyList(1,10);
});

function queryApplyList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 10;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"guideList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#guideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}	  
    }
    $("#queryForm").ajaxSubmit(options);	
}

var region = new Region('<%=ctx%>',"provinceId","cityId");
region.init();

function getRowHtml(index){
	var arr = [];
	arr.push('<tr>');
		arr.push('<td class="serialnum">');
			arr.push('<div class="serialnum_btn"></div>' + parseInt(index+1));
		arr.push('</td>');
		arr.push('<td>');
			arr.push('<select id="billType" name="billType" style="width:98%" >');
				arr.push('<option value="">请选择</option>');
				<c:forEach items="${billTypeList}" var="bill">	
					arr.push('<option value="${bill.code}">${bill.value}</option>');
				</c:forEach>
			arr.push('</select>');
		arr.push('</td>');
		arr.push('<td><input type="text" name="num" value=""/ style="width:98%" ></td>');
		arr.push('<td><input type="text" name="remark" value=""/ style="width:98%" ></td>');
		arr.push('<td><a class="button button-rounded button-tinier" onclick="delRow(this);">删除</a></td>');
	arr.push('</tr>');
	return arr.join("");
}

function addRow(){
	var trArr = $("#applyTable tbody tr");
	var serialNum = trArr.length;
	
	var trHtml = getRowHtml(serialNum);
	if(serialNum == 0){
		$("#applyTable tbody").html(trHtml);	
	}else{
		$("#applyTable tbody tr").last().after(trHtml);
	}
}

function delRow(obj){
	$(obj).parent().parent().remove();

	var index = 1;
	$("#applyTable tbody tr").each(function(){
		var firstTd = $(this).children(":first");
		firstTd.html('<div class="serialnum_btn" ></div>' + index);
		index ++;
	});
}

function verifyApplyList(){
	
	var flag = true;
	var trArr = $("#applyTable tbody tr");
	if(!trArr){
		return flag;
	}
	
	for(var i = 0; i < trArr.length; i++){
		
		var inputs = $(trArr[i]).find("input,select");
		for(var j = 0; j < inputs.length; j++){
			var item = inputs[j];
			if($(item).attr("name") == "remark"){
				continue;
			}
			
			if($(item).val()){
				$(item).css("border-color", "#e7eff1");
				
				var reg = /^[1-9]+[0-9]*]*$/;
				if($(item).attr("name") == "num" && !reg.test($(item).val())){
					$(item).css("border-color", "red");
					flag = false;		
				}
			}else{
				$(item).css("border-color", "red");
				flag = false;	
			}
		}
	}
	
	return flag;
}

function getApplyList(){
	
	var data = [];
	var notIds = [];
	$("#applyTable tbody tr").each(function(){

		var obj = [];
		var inputs = $(this).find("input,select");
		for(var i = 0; i < inputs.length; i++){
			var item = inputs[i];
			var id = $(item).attr("notids");
			if(id){
				notIds.push(id);	
			}
			
			obj.push('\"'+ $(item).attr("name") +'\":\"'+ $(item).val()+'\"');
		}
		data.push("{"+obj.join(",")+"}");
		
	});
	var content = '{"groupId":"'+ $("#groupId").val() +'","guideId":"'+ $("#guideId").val() +'","notIds":"'+ notIds.join(",") +'", "list":['+ data.join(",") + ']}';
	return content;
}

$(function() {
	var isAdd = "${reqpm.isAdd}";
	if(isAdd == "true"){
		var trHtml = getRowHtml(0);
		$("#applyTable tbody").html(trHtml);	
	}
});


(function(){
	var isPrint = "${reqpm.isPrint}";
	if(isPrint){
		var oper=1;
		bdhtml=window.document.body.innerHTML;//获取当前页的html代码
		sprnstr="<!--startprint"+oper+"-->";//设置打印开始区域
		eprnstr="<!--endprint"+oper+"-->";//设置打印结束区域
		prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)+18); //从开始代码向后取html
		
		prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html
		window.document.body.innerHTML=prnhtml;
		window.print(); 
	}
	
})();

</script>
</html>