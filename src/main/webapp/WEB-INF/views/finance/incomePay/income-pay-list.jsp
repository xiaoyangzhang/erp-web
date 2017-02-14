<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款处理</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#dateStart").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#dateEnd").val(endTime);			
 		}
 		setData();
 });
     </script>
</head>
<body>
	<div class="p_container">
		<form id="queryIncomePayForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="payDirect" value="1" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">收款日期:</li>
						<li>
							<input name="dateStart" id="dateStart" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
							~
							<input name="dateEnd" id="dateEnd" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">商家名称:</li>
						<li><input name="supplierName" type="text" /></li>
						<li class="clear" />
						
						<li class="text">支付方式:</li>
						<li><select name="payType">
								<option value="" selected="selected">全部</option>
								<c:forEach items="${payTypeList}" var="item">
									<option value="${item.value}">${item.value}</option>
								</c:forEach>
						</select></li>
						
						<li class="text">操作员:</li>
						<li><input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showList();" name="userName" id="userName" type="text" /></li>
						<li class="clear" />
						<li class="text"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
						<input type="button" id="btnPayAdd" onclick="toIncomePayAdd()" class="button button-primary button-small" value="新增收款"></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
	<div id="incomePayDiv"></div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

/* Table查询数据展示 */
function queryList(page, pagesize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);

	var options = {
		url : "../financePay/incomePayRecordListTable.do",
		type : "post",
		dataType : "html",
		success : function(data) {
			$("#incomePayDiv").html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			$.error("服务忙，请稍后再试");
		}
	}
	$("#queryIncomePayForm").ajaxSubmit(options);
}
/* 点击查询事件 */
function searchBtn() {
	queryList(1, $("#pageSize").val());
}

/* 页面加载时就刷新数据 */
$(function() {
	queryList();
});

$(function() {
	 $("#userName").autocomplete({
		  source: function( request, response ) {
			 /*  var name=encodeURIComponent(request.term);
			  alert("name="+name); */
			  $.ajax({
				  type : "get",
				  url : "<%=staticPath %>/finance/getUserNameList.do",
				  data : {
					  name : name
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {
								  label : v.user_name,
								  value : v.user_name
							  }
						  }));
					  }
				  },
				  error : function(data,msg){
				  }
			  });
		  },
		  focus: function(event, ui) {
			    $(".adress_input_box li.result").removeClass("selected");
			    $("#ui-active-menuitem")
			        .closest("li")
			        .addClass("selected");
			},
		  minLength : 0,
		  autoFocus : true,
		  delay : 300
	});
	 
});

function showList(){
	var e = $.Event('keydown');
	e.keyCode = 40; // DOWN
	$('#userName').trigger(e);
}

/* 新增收付款 */
function toIncomePayAdd(){
	newWindow('新增收款', '<%=staticPath%>/financePay/incomePayAdd.htm');
}

/* 修改收款 */
function toIncomeEdit(id){
	newWindow('修改收款', '<%=staticPath%>/financePay/incomePayAdd.htm?payId='+ id);
}

function deleteIncome(oid){
	YM.post("deleteFinancePay.do",{"id":oid},function(data){
		
		data = $.parseJSON(data);
		if(data.success == true){
			window.location.reload();
		}else{
			$.error(data.msg);
		}
	});
}
</script>
</html>