<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>派单</title>
    
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/finance/finance.css"/>
</head>
<body>
    <div class="p_container" >
    <form id="distributeBillForm">

				<input type="hidden" id="groupId" name="groupId" value="${reqpm.id}"/>
				<input type="hidden" id="guideId" name="guideId" value="${reqpm.guideId}"/>
				<input type="hidden"  name="type" value="distribute"/>
	     <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="w-1100 pt-20 pl-20">
	    			<div class="dan_header">
	    				<div class="h_grey mt-15 mb-10 ml-135 mr-135">
	    					<div>
	    						<div class="n_left">申请人：</div>
	    						<div class="n_right">${applicant}(计调)</div>
	    						<div class="clear"></div>
	    					</div>	    							    					
	    					<div>
	    						<div class="n_left">申请时间：</div>
	    						<div class="n_right"><fmt:formatDate value="${appliTime}" pattern="yyyy-MM-dd HH:mm"/></div>
	    						<div class="clear"></div>
	    					</div>
	    				</div>
	    				<div class="h_blue">
	    					<div>
	    						<div class="n_left">领单人：</div>
	    						<div class="n_right">${guideName}(导游)</div>
	    						<div class="clear"></div>
	    					</div>	    							    					
	    					<div>
	    						<div class="n_left">领单时间：</div>
	    						<div class="n_right"><fmt:formatDate value="${nowDate}" pattern="yyyy-MM-dd HH:mm"/></div>
	    						<div class="clear"></div>
	    					</div>
	    				</div>
	    				<div class="clear"></div>
	    				<div class="grey_bor">
	    					<div class="bg_grey1"></div>
		    				<div class="bg_blue2"></div>
	    				</div>	    				
	    			</div>
	    		</dd>	    		
	    		<dd class="w-1100 pt-20 pl-20">
	    			<div class="dan_b">
	    				<div class="g_num"><b>团号：${reqpm.groupCode}</b></div>
	    				
	    				
	    				<c:forEach items="${financeBillDetailList}" var="item" >
	    				<div class="tk_con">
	    				<input type="hidden" name="id" value="${item.id }">
	    					<div class="tk_l pt-40 pb-40">
		    					<c:forEach items="${billTypeList}" var="dicBill">
									<c:if test="${dicBill.code eq item.bill_type}">
										<p class="p3" style="width:80px"><b>${dicBill.value}</b></p>
									</c:if>
								</c:forEach>
	    					</div>
	    					<div class="tk_r">
	    						<ul class="mt-15">
	    							<li class="w-50"><span class="tag-h bg-b">申请</span></li>
	    							<li class="w-160">
	    								<div class="n_left">数量：</div>
	    								<div class="n_right">${item.num }</div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-300">
	    								&nbsp;
	    							</li>
	    							<li class="w-400">
	    								<div class="n_left">备注：</div>
	    								<div class="n_right"><input type="text" readonly="readonly"  id="" value="${item.remark }" class="w-300"/></div>
	    								<div class="clear"></div>
	    							</li>
	    							<div class="clear"></div>
	    						</ul>
	    						<ul>
	    							<li class="w-50"><span class="tag-h bg-y">领单</span></li>
	    							<li class="w-160">
	    								<div class="n_left">领单数量：</div>
	    								<div class="n_right">
	    									<input type="text" name="receivedNum" id="" value="${item.num }" class="w-50"/>
	    								</div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-300">
	    								<div class="n_left">单据号：</div>
	    								<div class="n_right">
	    									<input type="text" name="billNumReceive" id="" value="${item.bill_num_receive }" class="w-200"/>
	    								</div>
	    								<div class="clear"></div>
	    							</li>
	    							<li class="w-400">
	    								<div class="n_left">备注：</div>
	    								<div class="n_right">
	    									<input type="text" name="remarkReceive" id="" value="${item.remark_receive }" class="w-300"/>
	    								</div>
	    								<div class="clear"></div>
	    							</li>
	    							<div class="clear"></div>
	    						</ul>	    							    						
	    					</div>
	    					<div class="clear"></div>
	    				</div>
	    				</c:forEach>
	    				
	    				<div class="dan_btn mt-30">
	    					<a  onclick="save()" class="button  button-primary button-small mr-20" >确定派单</a>
	    					<a href="javascript:closeWindow()" class="button button-rounded button-action button-small">取消</a>
	    				</div>
	    			</div>
	    		</dd>
	    	</dl>
	    	           
	    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>  
</body>
<%-- <script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script> --%>
<script type="text/javascript">
function save(){

$("#distributeBillForm").validate({
	rules:{
		'billNumReceive' : {required : true }
	},
	errorPlacement : function(error, element) { // 指定错误信息位置
		if (element.is(':radio') || element.is(':checkbox')
				|| element.is(':input')) { // 如果是radio或checkbox
			var eid = element.attr('name'); // 获取元素的name属性
			error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
		} else {
			error.insertAfter(element);
		}
	},
	submitHandler : function(form) {
		arrPost = YM.getFormData("distributeBillForm");
		arrPost['billList'] = JSON.stringify(getLegValues());
		
		YM.post("saveDistributeBill.do", arrPost, function(){
			$.success("操作成功");
			setTimeout(closeWd,"500");
		});
	}
});
function closeWd(){
	closeWindow();
}
$("#distributeBillForm").submit();

}

function getLegValues(){
	var legArr = [];
	$(".tk_con").each(function(){
		var sepObj = {};
		sepObj.id = $(this).find("input[name=id]").val();
		sepObj.receivedNum = $(this).find("input[name=receivedNum]").val();
		sepObj.billNumReceive = $(this).find("input[name=billNumReceive]").val();
		sepObj.remarkReceive = $(this).find("input[name=remarkReceive]").val();
		
		legArr[legArr.length] = sepObj;
	});
	return legArr;
}

</script>
</html>
