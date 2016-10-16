<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>对账单</title>
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
		<ul class="w_tab">
			<li><a href="searchList.htm?supplierType=1"  <c:if test="${'1' == supplierType}"> class="selected"</c:if>>组团社ff</a></li>
			<li><a href="searchList.htm?supplierType=16"  <c:if test="${'16' == supplierType}"> class="selected"</c:if>>地接社</a></li>
			<li><a href="searchList.htm?supplierType=2"  <c:if test="${'2' == supplierType}"> class="selected"</c:if>>餐厅</a></li>
			<li><a href="searchList.htm?supplierType=3" <c:if test="${'3' == supplierType}"> class="selected"</c:if>>酒店</a></li>
			<li><a href="searchList.htm?supplierType=4" <c:if test="${'4' == supplierType}"> class="selected"</c:if>>车辆</a></li>
			<li><a href="searchList.htm?supplierType=5" <c:if test="${'5' == supplierType}"> class="selected"</c:if>>门票</a></li>
			<li><a href="searchList.htm?supplierType=7" <c:if test="${'7' == supplierType}"> class="selected"</c:if>>娱乐</a></li>
			<li><a href="searchList.htm?supplierType=15" <c:if test="${'15' == supplierType}"> class="selected"</c:if>>保险</a></li>
			<li><a href="searchList.htm?supplierType=9" <c:if test="${'9' == supplierType}"> class="selected"</c:if>>机票</a></li>
			<li><a href="searchList.htm?supplierType=10" <c:if test="${'10' == supplierType}"> class="selected"</c:if>>火车票</a></li>
			<li><a href="searchList.htm?supplierType=120" <c:if test="${'120' == supplierType}"> class="selected"</c:if>>其他收入</a></li>
			<li><a href="searchList.htm?supplierType=121" <c:if test="${'121' == supplierType}"> class="selected"</c:if>>其他支出</a></li>
			<li class="clear"></li>
		</ul>

		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="supplierType" id="supplierType"  value="${supplierType}" />
			<input type="hidden" name="sl" value="fin.selectVerifySearchListPage" />
			<input type="hidden" name="rp" value="finance/verify/search-list-table" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">团日期:</li>
						<li><input name="start_min" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~<input name="start_max" id="startMax" type="text" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="text">团号:</li>
						<li><input name="group_code" type="text" class="w-200"/></li>
						<li class="text">接站牌:</li>
						<li><input name="booking_no" type="text" class="w-200"/></li>
						<li class="text">产品:</li>
						<li><input name="product_name" type="text" class="w-200"/></li>
					</ul>
					<ul>
						<c:if test="${'1' == supplierType}">
							<li class="text">组团社:</li>
						</c:if>
						<c:if test="${'16' == supplierType}">
							<li class="text">地接社:</li>
						</c:if>
						<c:if test="${'1' != supplierType && '16' != supplierType}">
							<li class="text">商家名称:</li>
						</c:if>
						<li><input name="supplier_name" type="text" style="width:180px;"/></li>
						<li class="text">部门:</li>
		    			<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
		    			<li class="text">计调:</li>
		    			<li><input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    	
						<li class="text" style="width:215px;">状态:</li>
						<li><select name="status" class="w-100bi">
								<option value="">全部</option>
								<option value="1">已对账</option>
								<option value="0">未对账</option>
						</select></li>
						<li class="text" style="width:178px;"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询"></li>
					</ul>
				</div>
			</div>
		</form>
	<div id="tableDiv"></div>
	<div id="popDiv" style="display: none" class="searchRow">
		<div id="popTableDiv"></div>
	</div>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
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
			url : "searchList.do",
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
			area : [wh,hh],
			content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				var userArr = win.getUserList();   
				
				$("#operator_id").val("");
				$("#operator_name").val("");
				for(var i=0;i<userArr.length;i++){
					console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
					if(i==userArr.length-1){
						$("#operator_name").val($("#operator_name").val()+userArr[i].name);
						$("#operator_id").val($("#operator_id").val()+userArr[i].id);
					}else{
						$("#operator_name").val($("#operator_name").val()+userArr[i].name+",");
						$("#operator_id").val($("#operator_id").val()+userArr[i].id+",");
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
		$("#operator_name").val("");
		$("#operator_id").val("");
		
	}
	
	
	function totalDetail(bookingId) {
		var supId=$("#supplierType").val();
		if(!bookingId){
			return;
		}
		
		var data = {};
		data.supplierType = supId;
		data.bookingId = bookingId;
		data.mode = 0;
		data.sl = "fin.selectAmountDetailOrderListPage";
		data.rp = "finance/verify/amountDetailListTable";
		$("#popTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '金额详细信息',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#popDiv"),
			btn : [ '确定', '取消' ],
			yes : function(index) {

				//一般设定yes回调，必须进行手工关闭
				layer.close(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}
	
</script>
</html>