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
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" style="width:40px;">日期:</li>
						<li><input name="start_min" type="text" id="startMin" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~
							<input name="start_max" type="text" class="Wdate" id="startMax" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="text">团号:</li>
						<li><input name="group_code" type="text" /></li>
						<li class="text">付款人:</li>
						<li><input name="user_name" type="text" /></li>
						<li class="text">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">计调:</li>
						<li>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	  
						</li>
						<li class="text">付款方式:</li>
						<li><input name="pay_type" type="text" /></li>
						<li class="text">导游:</li>
						<li><input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showList();" name="guide_name" id="guide_name" type="text" /></li>
						<li class="text" style="width:100px;"></li>
						<li class="text" style="width:40px;">类型:</li>
						<li>
							<select name="type" class="w-100bi">
								<option value ="">全部</option>
								<option value ="1">佣金报账</option>
								<option value ="2">导游报账</option>
							</select>
						</li>
						<li class="text" style="width:40px;"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询"></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<div id="popDetailTableDiv"></div>
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
			url : "<%=staticPath %>/finance/guide/payRecordListPage.do",
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
	
	function deletePay(id){
		
		$.confirm("确认删除吗？", function () {
			$.get("<%=staticPath%>/finance/guide/deletePay.do?payId="+id , function(){
				$.success("删除成功");
				queryList();
			});
        }, function () {

        });
	}
	
	/**
	* 删除佣金付款记录
	*/
	function deleteCommPay(id, isDeduction){
		
		$.confirm("确认删除吗？", function () {
			var url = "";
			if("TRUE" == isDeduction){
				url = "<%=staticPath%>/finance/guide/deletePayCommDeduction.do?payId="+id;
			}else{
				url = "<%=staticPath%>/finance/guide/deleteCommPay.do?payId="+id;
			}
			
			$.get(url , function(){
				$.success("删除成功");
				queryList();
			});
        }, function () {

        });
	}
	
	/**
	 * 页面选择部分调用函数(多选)
	 */
	function selectUserMuti(num){
		var width = window.screen.width ;
		var height = window.screen.height ;
		var wh = (width/1920*650).toFixed(0) ;
		var hh = (height/1080*500).toFixed(0) ;
		wh = wh+"px" ;
		hh = hh+"px" ;
		var lh = (width/1920*400).toFixed(0) ;
		var th = (height/1080*100).toFixed(0) ;
		lh = lh+"px" ;
		th = th+"px" ;
		var win=0;
		layer.open({ 
			type : 2,
			title : '选择人员',
			shadeClose : true,
			shade : 0.5,
			offset : [th,lh],
			area : [wh,hh],
			content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				var userArr = win.getUserList();   
				
				$("#saleOperatorIds").val("");
				$("#saleOperatorName").val("");
				for(var i=0;i<userArr.length;i++){
					console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
					if(i==userArr.length-1){
						$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
						$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
					}else{
						$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
						$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
					}
				}
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}

	/**
	 * 重置查询条件
	 */
	function multiReset(){
		$("#saleOperatorName").val("");
		$("#saleOperatorIds").val("");
		
	}  
	
	function showDetail(payId, type, isDeduction) {
		
		var data = {};
		data.payId = payId;
		data.type = type;
		if('TRUE' == isDeduction){
			data.isDeduction = true;	
		}else{
			data.isDeduction = false;
		}
		 
		$("#popDetailTableDiv").load("<%=staticPath%>/finance/guide/payRecordDetails.htm", data);
		
		layer.open({
			type : 1,
			title : '付款明细',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#popDetailTableDiv"),
			btn : ['取消' ],
			yes : function(index) {
				layer.close(index);
			}
		});
	}
	
	function searchBtn() {
		queryList(1, $("#pageSize").val());
	}
	
	$(function() {
		queryList();
	});
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</html>