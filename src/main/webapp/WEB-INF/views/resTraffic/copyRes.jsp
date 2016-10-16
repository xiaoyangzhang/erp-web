<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>产品明细</title>
    <%@ include file="/WEB-INF/include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/js/zlDate/zlDate.css"/>
	<script src="<%=staticPath%>/assets/js/zlDate/zlDate.js"></script>
	<script src="<%=staticPath%>/assets/js/moment.js"></script>
</head>
<body>
<div class="mainbody"> 
	<input type="hidden" name="resId" id="resId" value="${resId}" /> 
      <div class="rilicontainer" style="margin-top:10px;margin-left:8px;margin-right:8px;">
          <div id="divLeft" ></div>
          <div class="clear"></div>
      </div>
      <div  style=" margin-left: auto; margin-right: auto;width:64px">
      <input type="button"  value="确定" onclick="setReturn()" class="button button-primary button-small"  />
      </div>
</div>



<script type="text/javascript">
$(document).ready(function() {
    initCalandar();   
});

function initCalandar() {	
   	$("#divLeft").priceCalandar({
   		callbackFunc: "processData"
   	});
}

function processData(container, year, month) {
	var today = moment(new Date()).date();
	$("#"+container).find("td[date!='']").each(function(){
		var tdDate = moment($(this).attr("date")).date();
		//console.log(tdDate+","+today);
		//if (tdDate >today){
			$(this).attr("class", "on");
			$(this).on("click", function(){
				tdClick(this);
			})
		//}else{
			//$(this).attr("class", "disable");
		//}
	});
}

function tdClick(obj){
	var isSelect = $(obj).attr("class");
	if (isSelect.indexOf("select") != -1)
		$(obj).removeClass("select").addClass("on").find("a").removeClass("white");
	else
		$(obj).addClass("select").removeClass("on").find("a").addClass("white");
}
    
function setReturn(){
	var resId=$("#resId").val();
	var dateAry = [];
	$("td[class*='select']").each(function(){
		dateAry.push($(this).attr("date"));
	});
	if (dateAry.length > 0){
			$.ajax({
		        type: "post",
		        url : "../resTraffic/sureCopy.do",
		        data:"dateAry=" +dateAry.join(",")+"&resId="+$("#resId").val(),
		    	success: function (data) {
		    		parent.reloadPage();
					
				},
				error: function () {
					alert("复制失败");
				}
			});
	}
	//此调调用父页面
}

</script>
</body>
</html>
