<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>购物审核</title>
	<%@ include file="../../../include/top.jsp"%>
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
	 });
	</script>
</head>
<body>
    <div class="p_container" >
    
   <%--  <ul class="w_tab">
		<li><a href="settleCommissionList.htm?stateCommission=0" ${reqpm.stateCommission eq 0 ?'class="selected"':'' }>未报账</a></li>
		<li><a href="settleCommissionList.htm?stateCommission=2" ${reqpm.stateCommission eq 2 ?'class="selected"':'' }>已报账</a></li>
		<li class="clear"></li>
	</ul> --%>
    
    <form id="queryForm">
			
			<input type="hidden" name="status" value="1" />	
			<input type="hidden" name="stateSeal" value="0" />	
			<%-- <input type="hidden" name="stateCommission" value="${reqpm.stateCommission }"/> --%>
			<input type="hidden" name="page" id="page" value="1"/>
			<input type="hidden" name="pageSize" id="pageSize" value="10"/>
	    	<div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl pl-10">
	    			<div class="dd_right">						
	    				<div class="dd_left">团日期：</div>
						<input type="text" id="startMin" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="startMax" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号：</div>
	    			<div class="dd_right">
	    				<input type="text" name="groupCode" id="" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称：</div>
	    			<div class="dd_right">
	    				<input type="text" name="productName" id="productName" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">部门:</div>
	    			<div class="dd_right">
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden"/>	    				
	    			</div>
	    			<div class="dd_left">计调:</div>
	    			<div class="dd_right">
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
	    			</div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">项目：</div>
	    			<div class="dd_right">
	    				<input type="text" stag="typeValues" value="" readonly="readonly" onclick="showProjectType()"/>
						<input name="commProjectTypeCodes" stag="typeCodes" value="" type="hidden" />
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" id="guideId" name="guideId" />
	    				<input type="text" id="guideName" name="guideName" value="" ></div>
					<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">状态：</div> 
	    			<div class="dd_right">
	    				<select id="stateCommission" name="stateCommission">
	    					<option value="">全部</option>
	    					<option value="0">未报账</option>
	    					<option value="2">已报账</option>
	    				</select>
					<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	 
	    			</div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    </div>
	  </form>
    </div>
    <div class="p_container" id="pay_comm_div" style="display: none">
			<form class="form-horizontal" id="payForm">
				<input type="hidden" name="commissionIds" id="commissionIds"/>
				<input type="hidden" name="groupId" id="groupId"/>
				<input type="hidden" name="guideId" id="guideId2"/>
				
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">年月日:</div>
						<div class="dd_right">
							<input type="text" id="payDate" name="payDate" readonly="readonly" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 300px"/>
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
							<select name="leftBank" class="w-100bi" onchange="bankSelectRelation(this,'left');">
								<option value="">请选择</option>
								<c:forEach items="${bizAccountList}" var="item">
									<option value="${item.bankName}" bank_account="${item.bankAccount}" account_name="${item.accountName}">
										${item.bankName}
									</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">开户行:</div>
						<div class="dd_right">
							<input type="text" id="leftBankOpen" name="leftBankOpen" id="" class="w-100bi" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">户名:</div>
						<div class="dd_right">
							<input type="text" id="leftBankHolder" name="leftBankHolder" id="" class="w-100bi" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">金额:</div>
						<div class="dd_right">
							<label id="payCash" class="w-100bi" style="display:inline-block;width: 300px" ></label>
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
    <div id="tableDiv"></div>
    <div id="popDiv"></div>   
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
    <%@ include file="/WEB-INF/views/component/comm/project_type_multi.jsp" %>             
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/finance/querySettleCommissionDeduction.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#queryForm").ajaxSubmit(options);	
}

function showRecord(o) {
	
	var data = {};
	data.groupId = o.groupId;
	data.guideId = o.guideId;
	data.payDirect = 0;
	data.sl = "fin.selectCommDeductionCashRecordList";
	data.rp = "finance/record/pay-record-list-table";
	$("#popDiv").load("<%=path%>/common/queryList.htm", data);
	
	layer.open({
		type : 1,
		title : '付款记录',
		closeBtn : false,
		area : [ '1000px', '500px' ],
		shadeClose : false,
		content : $("#popDiv"),
		btn : ['取消'],
		yes : function(index) {
			layer.close(index);
		}
	});
}

function checkAll(ckbox) {
	if ($(ckbox).attr("checked")) {
		$("input[name='audit_id']").attr('checked', 'checked');
	} else {
		$("input[name='audit_id']").removeAttr("checked");
	}
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

function showPayForm(commIds, payTotal, groupId, guideId){
	
	$("#commissionIds").val(commIds);
	$("#groupId").val(groupId);
	$("#guideId2").val(guideId);
	var curDate=new Date();
	$("#payDate").val(curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+curDate.getDate());
	
	if(payTotal){
		$("#payCash").html(payTotal.substring(0, payTotal.indexOf(".")+3));	
	}
	layer.open({
		type : 1,
		title : '佣金付款',
		closeBtn : false,
		area : [ '600px', '430px' ],
		shadeClose : false,
		content : $('#pay_comm_div'),
		btn : [ '付款', '取消' ],
		yes : function(index) {
			commPay(index);
		},
		cancel : function(index) {
			clearLayerPayMsg();
			layer.close(index);
		}
	});
}

function clearLayerPayMsg(){
	
	$("#pay_comm_div :input").each(function(){
		if($(this).attr("name") != "payDate"){
			$(this).val("");	
		}
	});
}

function commPay(index){
	$("#payForm").validate({
		rules : {
			'payDate' : {
				required : true
			}
		},
		messages : {
			'payDate' : {
				required : "请输入日期"
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
			YM.post("<%=path%>/finance/guide/payCommDeductionBill.do",YM.getFormData("payForm"),function(){
				$.success("付款成功");
				queryList();
				clearLayerPayMsg();
				layer.close(index);
			});
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	$("#payForm").submit();	
}

//银行选择级联
function bankSelectRelation(obj,type){
	var o = $(obj),selectedOption = o.find("option:selected");
	var bank_account = selectedOption.attr("bank_account"),account_name = selectedOption.attr("account_name");
	$("#"+type+"BankOpen").val(bank_account || '');
	$("#"+type+"BankHolder").val(account_name || '');
}

function searchBtn() {
	queryList();
}

$(function(){
	queryList();
});

</script>
</html>
