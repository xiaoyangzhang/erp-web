<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>订单出票</title>
	<%@ include file="../../include/top.jsp" %>
</head>
<body>	
<div class="searchRow">
<h1><font size="5" face="arial">请选择要进行出票操作的游客名单</font></h1>
<button type="button" class="button button-primary button-small" onclick="ticketed()">出票</button>
</div>
	<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 3%"><input type="checkbox" id="ckAll"><i class="w_table_split"></i></th>
    		<th style="width: 3%">序号<i class="w_table_split"></i></th>
    		<th style="width: 9%">团号<i class="w_table_split"></i></th>
			<th style="width: 5%">姓名<i class="w_table_split"></i></th>
			<th style="width: 5%">性别<i class="w_table_split"></i></th>
			<th style="width: 5%">年龄<i class="w_table_split"></i></th>
			<th style="width: 15%">籍贯<i class="w_table_split"></i></th>
			<th style="width: 5%">类别<i class="w_table_split"></i></th>
			<th style="width: 15%">身份证号码<i class="w_table_split"></i></th>
			<th style="width: 10%">手机号码<i class="w_table_split"></i></th>
			<th style="width: 15%">出票时间<i class="w_table_split"></i></th>
			<th style="width: 10%">操作人<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 		 	<c:forEach items="${list}" var="orders" varStatus="v">
		 <tr <c:if test="${empty orders.ticketTime}">style="color:red"</c:if>>
		 		<td><input type="checkbox" name="guestId" value="${orders.id }"  lang="${orders.groupId}" age="${orders.age}" <c:if test="${!empty orders.ticketTime}">disabled="disabled"  </c:if>/></td>
				 <td>${v.count}</td>
				 <td>${orders.groupCode}</td>
				<td>${orders.name}</td>
				<td><c:if test="${orders.gender==0}">女</c:if>
						<c:if test="${orders.gender==1}">男</c:if></td>
				<td>${orders.age}</td>
				<td>${orders.nativePlace}</td>
				<td><c:if test="${orders.type==1}">成人</c:if>
						<c:if test="${orders.type==2}">儿童</c:if>
						<c:if test="${orders.type==3}">全陪</c:if></td>
				<td>${orders.certificateNum}</td>
				<td>${orders.mobile}</td>
				<td>${orders.ticketTime}</td>
				<td>${orders.userName} </td>
				</tr> 
		</c:forEach> 
      </tbody>
</table>
<input type="hidden" name="resId" id="resId" value="${resId }" />
<script type="text/javascript">
function detailsStocklog(obj,resId,adjustTime){
/*   	layerInd = layer.open({
		type : 2,
		title : '资源销售日明细',
		shadeClose : true,
		shade : 0.5,
		area: ['600px', '400px'],
		content: 'detailsStocklog.do?resId='+resId+ "&adjustTime=" + adjustTime
	});  */
}

$(function(){
	  $("#ckAll").live("click",function(){
			 $("input[name='guestId']:enabled").prop("checked", this.checked);
	  });
	  $("input[name='guestId']").live("click",function() {
	    var $subs = $("input[name='guestId']");
	    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
	  });
	
});

function ticketed(){
	   var id ="", num=0, adultNum=0, childNum=0, babyNum=0, groupId = "", isDouble = false;
	    $("input[name='guestId']").each(function(){
		   if ($(this).prop("checked") || $(this).attr("checked")){
			   if (groupId == "")
				   groupId = $(this).attr("lang");
			   else 
				   if (groupId != $(this).attr("lang")){
					   $.error("请选择相同的团号！");
					   isDouble = true;
				   }
			   id = id + $(this).val()+",";  
			   num=num+1;
			  if($(this).attr("age")>12){
				  adultNum=adultNum+1;}
			  if($(this).attr("age")>3&& $(this).attr("age")<13){
				  childNum=childNum+1;}
			  if($(this).attr("age")<4){
				  babyNum=babyNum+1;}
		   }
	   });
	if (isDouble || num==0) return;
	var resId = $("input[name='resId']").val();
	newWindow("出票信息","resTraffic/addTicket.do?resId="+resId+ "&guestIds=" + id+ "&num=" + num+ "&groupId=" + groupId+ "&adultNum=" + adultNum+ "&childNum=" + childNum+ "&babyNum=" + babyNum);
}

</script>
</body>
</html>