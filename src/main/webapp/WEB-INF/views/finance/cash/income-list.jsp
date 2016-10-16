<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款记录</title>
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
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
	<div class="p_container">
		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="pay_direct" value="1" />
			<input type="hidden" name="sl" value="fin.selectCashRecordListPage" />
			<input type="hidden" name="rp" value="finance/cash/income-list-table" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">收款日期:</li>
						<li><input name="date_start" id="dateStart" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~<input name="date_end" id="dateEnd" type="text" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="text">商家名称:</li>
						<li><input name="supplier_name" type="text" /></li>
						<li class="text">单据号:</li>
						<li><input name="pay_code" type="text" /></li>
						<li class="clear" />

					<!-- </ul>
					<ul> -->
						<li class="text">我方银行:</li>
						<li><select name="left_bank" class="w-100bi">
								<option value="">请选择</option>
								<c:forEach items="${bizAccountList}" var="item">
									<option value="${item.bankName}" bank_account="${item.bankAccount}" account_name="${item.accountName}">${item.bankName}</option>
								</c:forEach>
						</select></li>
						<li class="text">支付方式:</li>
						<li><select name="pay_type">
								<option value="" selected="selected">全部</option>
								<c:forEach items="${payTypeList}" var="item">
									<option value="${item.value}">${item.value}</option>
								</c:forEach>
						</select></li>
						
						<li class="text">操作员:</li>
						<li><input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showList();" name="user_name" id="user_name" type="text" /></li>
						<li class="clear" />
						<li class="text"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
						<input type="button" id="btnPayAdd" onclick="toIncomeAdd()" class="button button-primary button-small" value="新增收款"></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
	<div id="driverDiv"></div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
	function queryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);

		var options = {
			url : "../common/queryListPage.htm",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#driverDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#queryForm").ajaxSubmit(options);
	}
	
	function toIncomeAdd(){
		newWindow('新增收款', '<%=staticPath%>/finance/incomeAdd.htm');
	}
	
	function toIncomeEdit(id){
		newWindow('修改收款', '<%=staticPath%>/finance/incomeAdd.htm?payId='+ id);
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
	
	function searchBtn() {
		queryList(1, $("#pageSize").val());
	}
	
	$(function() {
		queryList();
	});
	
	$(function() {
		 $("#user_name").autocomplete({
			  source: function( request, response ) {
				  var name=encodeURIComponent(request.term);
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
		 $('#user_name').trigger(e);
		}
</script>
</html>