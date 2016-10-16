<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>打印预览</title>
	<%@ include file="../../../include/path.jsp"%>
	<style type="text/css">
	 .black_tab thead tr th{border:1px solid #000;background:none;}
	  .black_tab tbody tr td{border:1px solid #000;}
	</style>
</head>
<body>
<div id="printDiv">
<!--startprint1-->	
	<div class="p_container" >
		<h1 align="center"  style="font-size: 20px;">导游领单表</h1>
		<table  cellspacing="0" cellpadding="0" class="w_table black_tab" style="font-size: 14px;font-weight: bold" align="center">
			<col width="100px;" />
			<col width="400px;" />
			<col width="100px;" />
			<col width="200px;" />
		  <tbody>
			<tr height="28px;">
					<td align="right">团号：</td>
					<td>${reqpm.groupCode }</td>
					<td align="right">导游：</td>
					<td>${guideName}</td>
				</tr>
				<tr height="28px;">
					<td align="right">人数：</td>
					<td>${tour.totalAdult }大${tour.totalChild }小${tour.totalGuide }陪</td>
					<td align="right">计调：</td>
					<td>${tour.operatorName}</td>
				</tr>
				<tr height="28px;">
					<td align="right">产品名称：</td>
					<td colspan="3">【${tour.productBrandName}】${tour.productName}</td>
				</tr>
			</tbody>
		</table>
	
		<br/>
		
		<table  cellspacing="0" cellpadding="0" class="w_table black_tab" style="font-size: 12px;font-weight: bold" align="center">
			<col width="100px;" />
			<col width="200px;" />
			<col width="100px;" />
			<col width="300px;" />
			<col width="300px;" />
			<thead>
				<tr height="28px;">
					<th>序号<i class="w_table_split"></i></th>
					<th>单据类型<i class="w_table_split"></i></th>
					<th>数量<i class="w_table_split"></i></th>
					<th>单据号<i class="w_table_split"></i></th>
					<th>备注<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<tbody>
					<c:forEach items="${financeBillDetailList}" var="item" varStatus="status">
						
						<tr height="28px;">
							<td align="center" class="serialnum">
								<div class="serialnum_btn"></div> ${status.index+1}
							</td>
							<td>
								<c:forEach items="${billTypeList}" var="bill">
									<c:if test="${bill.code eq item.bill_type}">
										${bill.value}
									</c:if>
								</c:forEach>
							</td>
							<td align="center">${item.num }</td>
							<td>${item.bill_num_receive }</td>
							<td>${item.remark }</td>
						</tr>
					</c:forEach>
					
				</tbody>
			</table>
			<div class="dan_btn mt-30" align="center">
   				<c:if test="${reqpm.isPrint ne true}">
	    			<a class="button  button-primary button-small mr-20" href="<%=staticPath%>/booking/applyPrint.htm?guideName=${reqpm.guideName}&isPrint=true&guideId=${reqpm.guideId}&groupId=${reqpm.groupId}&groupCode=${reqpm.groupCode }&isAdd=false&isPrint=true" target="_blank">打印</a>
  						<a href="javascript:closeWindow()" class="button  button-primary button-small mr-20" >关闭</a>
	    		</c:if>
 			</div>
	</div>
		<!--endprint1-->
</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

$(function() {
	var isAdd = "${reqpm.isAdd}";
	if(isAdd == "true"){
		var trHtml = getRowHtml(0);
		$("#applyTable tbody").html(trHtml);	
	}
});


(function(){
	var isPrint = "${reqpm.isPrint}";
	if(isPrint){
		var oper=1;
		bdhtml=window.document.body.innerHTML;//获取当前页的html代码
		sprnstr="<!--startprint"+oper+"-->";//设置打印开始区域
		eprnstr="<!--endprint"+oper+"-->";//设置打印结束区域
		prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)+18); //从开始代码向后取html
		
		prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html
		window.document.body.innerHTML=prnhtml;
		window.print(); 
	}
	
})();

</script>
</html>