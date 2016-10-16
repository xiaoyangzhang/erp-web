<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>产品明细</title>
    <%@ include file="/WEB-INF/include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/product/product_detail.css"/>
</head>
<body>
<div class="mainbody"> 
	<input type="hidden" name="productId" id="productId" value="${productId }" /> 
      <div class="rilicontainer" style="margin-top:10px;margin-left:8px;margin-right:8px;">
          <div id="divLeft" style="float:left; "></div>
          <div id="divRight" style="float: right; "></div>
          <div class="clear"></div>
      </div>
</div>
</body>
<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/js/zlDate/zlDate.css"/>
<script src="<%=staticPath%>/assets/js/zlDate/zlDate.js"></script>
<script src="<%=staticPath%>/assets/js/web-js/product/product_group_date_plus.js"></script>
<script type="text/javascript">
    var path = '<%=path%>';
</script>
</html>
