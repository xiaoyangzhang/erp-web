<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导游结算</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
$(function() {
	var vars={
			 dateFrom : $.currentMonthFirstDay(),
		 	dateTo : $.currentMonthLastDay()
		 	};
		 	$("#startMin").val(vars.dateFrom);
		 	 $("#startMax").val(vars.dateTo );	

 
});
</script>
</head>
<body>
	<div class="p_container">
	
	
		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">出团日期:</li>
						<li><input name="start_min" type="text" id="startMin" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~<input name="start_max" id="startMax" type="text" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="text">团号:</li>
						<li><input name="group_code" type="text" /></li>
						<li class="text">导游:</li>
						<li><input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showList();" name="guide_name" id="guide_name" type="text" /></li>
						<li class="clear" />
							<li class="text">部门:</li>
			    				<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
								<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
			    			<li class="text">计调:</li>
			    				<li><input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
								<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
						<li class="text">状态:</li>
		    			<li>
		    				<select name="state_booking" id="state_booking">
		    					<option value="">全部</option>
		    					<option value="2">未报账</option>
		    					<option value="3">已报账</option>
		    				</select>
		    			</li>
			    			
						<li class="clear" />
						<li class="text"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询"></li>
					</ul>
				</div>
			</div>
		</form>
		<div class="p_container" id="pay_div" style="display: none">
			<form class="form-horizontal" id="payForm">
				<input type="hidden" name="bookingGuideId" id="bookingGuideId"/>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">第:</div>
						<div class="dd_right">
							<input type="text" name="payCode" class="w-120" style="width: 300px"/> 号
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">年月日:</div>
						<div class="dd_right">
							<input type="text" name="payDate" readonly="readonly" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">付款方式:</div>
						<div class="dd_right">
							<select name="payType" class="w-100bi" style="width: 300px">
								<c:forEach items="${payTypeList}" var="item">
									<option value="${item.value}">${item.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">银行:</div>
						<div class="dd_right">
							<select name="leftBank" id="leftBank" class="w-100bi" style="width: 300px">
								<option value="">请选择</option>
								<c:forEach items="${bankList }" var="bank">
									<option value="${bank.id }">${bank.value }</option>
								</c:forEach>
							</select>
						
							<%-- <select name="leftBank"  onchange="bankSelectRelation(this,'left');" style="width: 300px">
							<option value="">请选择</option>
							<c:forEach items="${bizAccountList}" var="item">
								<option value="${item.bankName}" bank_account="${item.bankAccount}" account_name="${item.accountName}">${item.bankName}</option>
							</c:forEach>
							</select> --%>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">开户行:</div>
						<div class="dd_right">
							<input type="text" name="leftBankOpen" id="" class="w-100bi" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">户名:</div>
						<div class="dd_right">
							<input type="text" name="leftBankHolder" id="" class="w-100bi" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">摘要:</div>
						<div class="dd_right">
							<textarea name="remark" rows="3" style="width: 300px"></textarea>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
			</form>
		</div>
	</div>
	
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
	<div id="tableDiv"></div>
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
			url : "<%=staticPath%>/finance/guide/querySettleListPage.htm",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#tableDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#queryForm").ajaxSubmit(options);
	}

	function showPayForm(bookId){
		$("#bookingGuideId").val(bookId);
		layer.open({
			type : 1,
			title : '导游付款',
			closeBtn : false,
			area : [ '600px', '350px' ],
			shadeClose : false,
			content : $('#pay_div'),
			btn : [ '付款', '取消' ],
			yes : function(index) {
				guidePay(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}
	
	function guidePay(index){
		$("#payForm").validate({
			rules : {
				'payDate' : {
					required : true
				},
				'payCode' : {
					required : true
				}
			},
			messages : {
				'payDate' : {
					required : "请输入日期"
				},
				'payCode' : {
					required : "请输入单据号"
				}
			},
			errorPlacement : function(error, element) { // 指定错误信息位置
				debugger
				if (element.is(':radio') || element.is(':checkbox')
						|| element.is(':input')) { // 如果是radio或checkbox
					var eid = element.attr('name'); // 获取元素的name属性
					error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
				} else {
					error.insertAfter(element);
				}
			},
			submitHandler : function(form) {
				YM.post("payGuideBill.do",YM.getFormData("payForm"),function(){
					$.success("付款成功");
					searchBtn();
					layer.close(index);
				});
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
		$("#payForm").submit();	
	}
	
	function searchBtn() {
		queryList(1, $("#pageSize").val());
	}
	
	$(function() {
		queryList();
	});
	
	$(function() {
		 $("#guide_name").autocomplete({
			  source: function( request, response ) {
				  var name=encodeURIComponent(request.term);
				  $.ajax({
					  type : "get",
					  url : "<%=staticPath %>/finance/guide/getGuideNameList.do",
					  data : {
						  name : name
					  },
					  dataType : "json",
					  success : function(data){
						  if(data && data.success == 'true'){
							  response($.map(data.result,function(v){
								  return {
									  label : v.guide_name,
									  value : v.guide_name
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
		 $('#guide_name').trigger(e);
		}
</script>
</html>