<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
	<style type="text/css">
	 .black_tab thead tr th{border:1px solid #000;background:none;}
	  .black_tab tbody tr td{border:1px solid #000;}
	</style>
</head>
<body>
<div id="printDiv">
<!--startprint1-->
	<div class="p_container" >
		<form id="queryForm">
			<h1  style="font-size: 20px; " align="center">导游佣金表</h1>
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
	
			<div class="p_container_sub" >
				<table style="font-size: 10px;"  id="commissionTable" cellspacing="0" cellpadding="0" <c:if test="${reqpm.isPrint eq true}"> class="w_table black_tab" </c:if> <c:if test="${reqpm.isPrint ne true}"> class="w_table" </c:if>>
					<tr>
						<td width="10%">团号：</td>
						<td  width="40%">${tourGroup.groupCode}</td>
						<td width="10%">人数：</td>
						<td width="40%">${tourGroup.totalAdult}大 ${tourGroup.totalChild}小${tourGroup.totalGuide}陪</td>
					</tr>
					<tr>
						<td>电话：</td>
						<td>${supplierGuide.mobile}</td>
						<td>银行账号：</td>
						<td>${supplierGuide.bankAccount}</td>
					</tr>
				</table>
				</br>
				<c:if test="${reqpm.isPrint ne true}">
					<select id="guideId" name="guideId" style="width:5%">
						<c:forEach items="${guideList}" var="guide" >
							<option value="${guide.guideId }" 
								<c:if test="${reqpm.guideId eq guide.guideId}">selected="selected"</c:if>
							>${guide.guideName }</option>
						</c:forEach>
					</select>
			    	<div class="searchRow" style="padding:25px;text-align:right;">
		    	</c:if>
		    	</div>
	        </div>
		</form>		
	</div>
	<div>
		<form>
			<input id="groupId" value="${reqpm.groupId}" type="hidden" />
			<table style="font-size: 10px;"  id="commissionTable" cellspacing="0" cellpadding="0" <c:if test="${reqpm.isPrint eq true}"> class="w_table black_tab" </c:if> <c:if test="${reqpm.isPrint ne true}"> class="w_table" </c:if>>
				<col width="5%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>导游<i class="w_table_split"></i></th>
						<th>项目<i class="w_table_split"></i></th>
						<th>类型<i class="w_table_split"></i></th>
						<th>发放金额<i class="w_table_split"></i></th>
						<th>扣除金额<i class="w_table_split"></i></th>
						<th>状态<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:set var="aa" value="0"></c:set>
					<c:forEach items="${financeCommissions}" var="com" varStatus="status">
					<c:set var="aa" value="${aa +1 }"></c:set>
					<c:set var="paid" value="false"></c:set>
					<c:set var="disabledCss" value=""></c:set>
					<c:set var="inputDisabled" value=""></c:set>
					<c:if test="${not empty com.total}">	
						<c:if test="${com.total.compareTo(com.totalCash) eq 0}">
							<c:set var="paid" value="true"></c:set>
							<c:set var="disabledCss" value="bgcolor='#E3E3E3'"></c:set>
							<c:set var="inputDisabled" value="disabled='disabled'"></c:set>		
						</c:if>
					</c:if>
					
					<tr>
						<td class="serialnum" ${disabledCss }>${status.index+1}</td>
						<td ${disabledCss }>
							${com.guideName }
						</td>
						<td ${disabledCss }>
							<c:forEach items="${dicInfoList}" var="dicInfo">
								<c:if test="${dicInfo.code eq com.commissionType}">${dicInfo.value }</c:if>
							</c:forEach>
						</td>
						<td ${disabledCss }>
							<input type="radio" name="cashType${status.index}" value="发放" ${inputDisabled } <c:if test="${com.total > 0}">checked="checked"</c:if>>发放</input>
						</td>
						<c:if test="${com.total > 0}">
							<td ${disabledCss }>
								<c:set var="total" value="${fn:replace(com.total,'-', '')}" />
								<fmt:formatNumber value="${total}" pattern="#.##"/>
							</td>
							<td ${disabledCss }>0</td>
						</c:if>
						<c:if test="${com.total <= 0}">
							<td ${disabledCss }>0</td>
							<td ${disabledCss }>
								<c:set var="total" value="${fn:replace(com.total,'-', '')}" />
								<fmt:formatNumber value="${total}" pattern="#.##"/>
							</td>
						</c:if>
						<td ${disabledCss }>
							<c:if test="${paid eq false}">未结算</c:if>
							<c:if test="${paid eq true}">已结算</c:if>
						</td>
					</tr>
					<c:if test="${com.total > 0}">
						<c:set var="fafang_total" value="${fafang_total+com.total}" />
					</c:if>
					<c:if test="${com.total <= 0}">
						<c:set var="kouchu_total" value="${kouchu_total+com.total}" />
					</c:if>
					</c:forEach>
					
					<c:forEach items="${financeCommissionDeductions}" var="com" varStatus="status">
					<c:set var="aa" value="${aa +1 }"></c:set>
					<c:set var="paid" value="false"></c:set>
					<c:set var="disabledCss" value=""></c:set>
					<c:set var="inputDisabled" value=""></c:set>
					<c:if test="${not empty com.total}">	
						<c:if test="${com.total.compareTo(com.totalCash) eq 0}">
							<c:set var="paid" value="true"></c:set>
							<c:set var="disabledCss" value="bgcolor='#E3E3E3'"></c:set>
							<c:set var="inputDisabled" value="disabled='disabled'"></c:set>		
						</c:if>
					</c:if>
					
					<tr>
						<td class="serialnum" ${disabledCss }>${status.index+1}</td>
						<td ${disabledCss }>
							${com.guideName }
						</td>
						<td ${disabledCss }>
							<c:forEach items="${dicInfoList2}" var="dicInfo">
								<c:if test="${dicInfo.code eq com.commissionType}">${dicInfo.value }</c:if>
							</c:forEach>
						</td>
						<td ${disabledCss }>
							<input type="radio" name="cashType${status.index}" value="扣除" ${inputDisabled } <c:if test="${com.total > 0}">checked="checked"</c:if>>扣除</input>
						</td>
						<c:if test="${com.total > 0}">
							<td ${disabledCss }>
								<c:set var="total" value="${fn:replace(com.total,'-', '')}" />
								<fmt:formatNumber value="${total}" pattern="#.##"/>
							</td>
							<td ${disabledCss }>0</td>
						</c:if>
						<c:if test="${com.total <= 0}">
							<td ${disabledCss }>0</td>
							<td ${disabledCss }>
								<c:set var="total" value="${fn:replace(com.total,'-', '')}" />
								<fmt:formatNumber value="${total}" pattern="#.##"/>
							</td>
						</c:if>
						<td ${disabledCss }>
							<c:if test="${paid eq false}">未结算</c:if>
							<c:if test="${paid eq true}">已结算</c:if>
						</td>
					</tr>
					<c:if test="${com.total > 0}">
						<c:set var="fafang_total" value="${fafang_total+com.total}" />
					</c:if>
					<c:if test="${com.total <= 0}">
						<c:set var="kouchu_total" value="${kouchu_total+com.total}" />
					</c:if>
					</c:forEach>
					
					<tr>
						<td colspan="4" style="text-align:right;">合计：</td>
						<td><fmt:formatNumber value="${fafang_total}" pattern="#.##" type="currency"/></td>
						<c:set var="total_kouchu" value="${fn:replace(kouchu_total,'-', '')}" />
						<td><fmt:formatNumber value="${total_kouchu}" pattern="#.##" type="currency"/></td>
						<td></td>
					</tr>
					<tr>
						<td colspan="4" style="text-align:right;">实发金额：</td>
						<td colspan="2"><fmt:formatNumber value="${fafang_total+kouchu_total}" pattern="#.##" type="currency"/></td>
						<td></td>
					</tr>
					<tr>
						<td colspan="7" >${printMsg }</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<!--endprint1-->
	<div style="text-align: center;margin-top:40px;">
 		<a href="<%=staticPath %>/finance/guide/addCommission2.htm?groupId=${reqpm.groupId}&isPrint=true&guideId=${reqpm.guideId}" target="_blank"  class="button button-primary button-small">打印</a>&nbsp;&nbsp;&nbsp;	
		<a onclick="closeWindow()" class="button button-primary button-small">关闭</a>
	</div>
</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

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
	
	$("#guideId").change(function(){
		var guideId=$("#guideId").val();
		var groupId=$("#groupId").val();
		newWindow('打印','<%=staticPath %>/finance/guide/addCommission2.htm?groupId='+groupId+'&guideId='+guideId);
	});
	
})();


</script>
</html>