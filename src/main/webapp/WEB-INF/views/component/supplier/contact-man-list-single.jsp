<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择供应商</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx %>/assets/css/component/supplier-select.css" rel="stylesheet" type="text/css">
<SCRIPT type="text/javascript">
function chkMan(obj,cid,name,tel,mobile,fax){
	if($(obj).is(':checked')){
		$("#ulSel").html("<li cid='"+cid+"' cname='"+name+"' ctel='"+tel+"' cmobile='"+mobile+"' cfax='"+fax+"'>"+name+"<span class='pop_check_del'></span></li>");
		bindEvent();
	}
}

function bindEvent(){
	$("#ulSel").find(".pop_check_del").each(function(){
		$(this).unbind("click").bind("click",function(){
			var cid = $(this).parent().attr("cid");
			//删除li
			$(this).parent().remove();
			//table中checkbox取消选中
			radioRemove(cid);
		})
	})
}

function radioRemove(cid){
	$(".w_table").find("input:radio[cid='"+cid+"']").removeAttr("checked");
}

function getChkedContact(){
	var manArr = new Array();
	$("#ulSel").find("li").each(function(){
		var id = $(this).attr("cid");
		var name = $(this).attr("cname");
		var tel = $(this).attr("ctel");
		var mobile = $(this).attr("cmobile");
		var fax = $(this).attr("cfax"); 
		manArr.push({id:id,name:name,tel:tel,mobile:mobile,fax:fax});
	})
	return manArr;
}

</SCRIPT>
</head>
<body>	
	<div class="p_container" >		
		<div id="divCenter" class="component_div">
			<div id="contactManDiv">
				<table class="w_table">
					<colgroup>
						<col width="8%">
						<col width="14%">
						<col width="25%">
						<col width="25%">
						<col width="28%">
				    </colgroup>
					<thead>
						<tr>	
							<th>&nbsp;<i class="w_table_split"></i></th>
							<th>联系人<i class="w_table_split"></i></th>					
							<th>手机号<i class="w_table_split"></i></th>					
							<th>座机号<i class="w_table_split"></i></th>					
							<th>传真<i class="w_table_split"></i></th>
						</tr>
					</thead>
					<c:forEach items="${manList}" var="man"
						varStatus="status">
						<tr>
							<td><input name="radio" type="radio" onclick="chkMan(this,${man.id},'${man.name}','${man.tel}','${man.mobile}','${man.fax}')" cid="${man.id}"/></td>
							<td>${man.name}</td>					
							<td>${man.mobile }</td>					
							<td>${man.tel }</td>					
							<td>${man.fax }</td>
						</tr>
				
					</c:forEach>
				</table>					
			</div>
		</div>
		<div id="divRight" class="component_right">
			<h2>已选择：</h2>
			<div class="clear"></div>
			<ul id="ulSel">
			
			</ul>
		</div>
	</div>
</body>
</html>