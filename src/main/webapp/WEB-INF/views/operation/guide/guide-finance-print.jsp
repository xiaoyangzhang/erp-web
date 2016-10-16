<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
   	<style type="text/css">
	 .black_tab thead tr th{border:1px solid #000;background:none;}
	  .black_tab tbody tr td{border:1px solid #000;}
	</style>
</head>
<body>
<!--startprint1-->
	<div align="center"><font size=5>导游报账单</font> </div>
    <div class="p_container" >
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
   				<dd>
   					<div class="dd_left">团号：</div>
   					<div class="dd_right">${group.groupCode}</div>
   					<div class="dd_left">带团人数：</div>
   					<div class="dd_right">${group.totalAdult+group.totalChild+group.totalGuide}</div>
   					<div class="dd_left">导游：</div>
   					<div class="dd_right">${guideName }&nbsp;&nbsp;${guideTel }</div>
   					 <div class="dd_left">银行账号：</div>
   					<div class="dd_right">${ bankAccount}</div>
   					<div class="clear"></div>
   				</dd>
	    	</dl>
	    </div>
    </div> 
    <table cellspacing="0" cellpadding="0" <c:if test="${reqpm.isPrint eq true}"> class="w_table black_tab" </c:if> <c:if test="${reqpm.isPrint ne true}"> class="w_table" </c:if>>
	<col width="7%" />
	<col width="10%" />
	<col width="50%" />
	<col width="10%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>类别<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>明细<i class="w_table_split"></i></th>
			<th>支出<i class="w_table_split"></i></th>
			<th>交回<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${map}" var="item" varStatus="status">
		<c:if test="${!empty item.value}">
			<tr>
			<c:forEach items="${supplierTypeMap}" var="attr">
				<c:if test="${attr.key==item.key}">
					<td>${attr.value}</td>
				</c:if>
			</c:forEach>
				<td colspan="4">
					<c:if test="${not empty item.value}">
					<table cellspacing="0" cellpadding="0" class="w_table" style="border-top:0px;">
						<col width="10%" />
						<col width="50%" />
						<col width="10%" />
						<col width="10%" />
						<tbody>
							<c:forEach items="${item.value}" var="bill" varStatus="status">
								<c:if test="${fn:length(item.value) == status.index + 1}">
									<c:set var="borderCss"  value="style=\"border-bottom:0px;\"" />
								</c:if>
							<tr>
								<td ${borderCss } >${bill.supplierName }</td>
								<td> 
	    							<c:forEach items="${bill.supplierDetail}" var="supplierDetail" >
	    							 	${supplierDetail }<br>
	    							 </c:forEach>
	    						</td>
	    						<c:if test="${item.key!=120}">
									<td ${borderCss } ><fmt:formatNumber value="${bill.ftotal }" pattern="#.##"/></td>
									<td ${borderCss } ></td>
									<c:set var="sumZC" value="${sumZC+bill.ftotal}" />
	    						</c:if>
	    						<c:if test="${item.key==120}">
									<td ${borderCss } ></td>
									<td ${borderCss } ><fmt:formatNumber value="${bill.ftotal }" pattern="#.##"/></td>
									<c:set var="sumJH" value="${sumJH+bill.ftotal}" />
	    						</c:if>
							<tr>
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
			</tr>
		</c:if>
		</c:forEach>
		<%-- <tr>
			<td>购物佣金</td>
			<td></td>
			<td colspan="3">
				<table cellspacing="0" cellpadding="0" class="w_table" style="border-top:0px;">
					<col width="50%" />
					<col width="10%" />
					<col width="10%" />
					<tbody>
						<c:forEach items="${financeCommissionList}" var="flist" varStatus="status">
							<c:if test="${fn:length(financeCommissionList) == status.index + 1}">
								<c:set var="borderCss"  value="style=\"border-bottom:0px;\"" />
							</c:if>
							<tr>
								<c:forEach items="${dicInfoList}" var="dic">
									<c:if test="${flist.commissionType==dic.code}">
										<td>${dic.value}</td>
									</c:if>
								</c:forEach>
	    						 <c:if test="${flist.total>0}">
										<td ${borderCss } ><fmt:formatNumber value="${flist.total }" pattern="#.##"/></td>
										<td></td>
										<c:set var="sumZC" value="${sumZC+flist.total}" />
								</c:if>
								<c:if test="${flist.total<0}">
										<c:set var="totalDele" value="${fn:replace(flist.total,'-', '')}" />
										<td></td>
										<td ${borderCss } ><fmt:formatNumber value="${totalDele}" pattern="#.##"/></td>
										<c:set var="sumJH" value="${sumJH+totalDele}" />
								</c:if>  
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</td>
		</tr> --%>
		<tr>
			<td></td>
			<td></td>
			<td>合计</td>
			<td><fmt:formatNumber value="${sumZC}" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumJH}" pattern="#.##"/></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td>报账金额</td>
			<td colspan="2"><fmt:formatNumber value="${sumZC-sumJH}" pattern="#.##"/></td>
		</tr>
	</tbody>
</table>
<table style="width: 100%;">
			<tr>
				<td>打印人：${printName}&nbsp;&nbsp; 打印时间：${printTime}
						</td>
			</tr>
		</table>
<!--endprint1-->
<script type="text/javascript">
(function(){
	var oper=1;
	bdhtml=window.document.body.innerHTML;//获取当前页的html代码
	sprnstr="<!--startprint"+oper+"-->";//设置打印开始区域
	eprnstr="<!--endprint"+oper+"-->";//设置打印结束区域
	prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)+18); //从开始代码向后取html
	
	prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html
	window.document.body.innerHTML=prnhtml;
	window.print(); 
})();
</script>
</body>
</html>
