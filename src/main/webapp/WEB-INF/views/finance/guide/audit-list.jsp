<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导游报账审核</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
$(function() {
	function setData(){
		var curDate=new Date();
		var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
		 $("#startMin").val(startTime);
		var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
	     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
	     var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
	     $("#startMax").val(endTime);			
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
			<input type="hidden" name="sl" value="fin.selectGuideAuditListPage" />
			<input type="hidden" name="rp" value="finance/guide/audit-list-table" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">出团日期:</li>
						<li><input name="start_min" type="text" id="startMin" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~<input name="start_max" type="text" class="Wdate" id="startMax"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="text">团号:</li>
						<li><input name="group_code" type="text" /></li>
						<li class="text">产品名称:</li>
						<li><input name="product_name" type="text" /></li>
						<li class="clear" />
					<!-- </ul>
					<ul> -->
						<li class="text">部门:</li>
		    			<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" />	    				
		    			<li class="text">计调:</li>
		    			<li><input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
						<li class="text">导游:</li>
						<li><input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showList();" name="guide_name" id="guide_name" type="text" /></li>
						<li class="text">状态:</li>
						<li><select name="state_finance" class="w-100bi">
								<option value="">全部</option>
								<option value="0">未审核</option>
								<option value="1">已审核</option>
						</select></li>
						<li class="clear" />
						<li class="text"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询"></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
	function audit(billId){
		
		YM.post("auditGuideBill.do",{billId:billId},function(result){
			eval("var obj = "+ result);
			if(obj.success){
	 			$.success(obj.msg);
	 			searchBtn();
			}else{
				$.error(obj.msg);	
			}
		});
	}
	
	function delAudit(billId){
		
		YM.post("delAuditGuideBill.do",{billId:billId},function(){
			$.success("取消审核成功");
			searchBtn();
		});
	}


	function queryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);

		var options = {
			url : "auditList.do",
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