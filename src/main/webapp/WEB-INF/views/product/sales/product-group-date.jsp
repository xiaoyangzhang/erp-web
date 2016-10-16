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
		<div class="kehu">
            <div class="brand mt-10 mb-5" style="margin:10px 0;width:1040px;">
                <div class="khlist" style="width:961px;">
                    <ul>
                        <c:forEach items="${productGroupSuppliers}" var="supplier">
                            <li group-id="${supplier.id}" class="supplier_name">${supplier.name}</li>
                        </c:forEach>
                    </ul>
                </div>

                <p id="priceGroupMore" class="more fr mt-5 mr-10"><a href="javascript:void(0);" class="blue pr-20 zhankai"><b>更多客户</b></a></p>
                <div class="clear"></div>
            </div>
        </div>
      <div class="rilicontainer" style="margin-top:10px;margin-left:8px;margin-right:8px;">
          <div id="divLeft" style="float:left; "></div>
          <div id="divRight" style="float: right; "></div>
          <div class="clear"></div>
      </div>
</div>
<script type="text/html" id="divshadowHtml">
	<div class='div-shadow'></div>
	<div class='div-content'>
		<div class='con-head'>
			<span class='con-head-title'>请确认</span>
			<span class='closediv'></span>
		</div>
		<div class='con-body'>
			<p class="btn"><a href="javascript:goOrder(1);" class="button button-primary button-small">确认订单</a></p>
			<p class="btn"><a href="javascript:goOrder(0);" title="预留${reserve_hour}小时， 或库存小于${reserve_count}位后取消订单&#10;${reserve_remark}" class="button button-primary button-small">预留订单</a></p>
		</div>
	</div>
</script>
</body>
<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/js/zlDate/zlDate.css"/>
<script src="<%=staticPath%>/assets/js/zlDate/zlDate.js"></script>
<script src="<%=staticPath%>/assets/js/web-js/product/product_group_date.js"></script>
<script type="text/javascript">
    var path = '<%=path%>';
	var isReserve = ${isReserve};
</script>
<style>
	.div-shadow{
		position: absolute;
		top: 0%;
		left: 0%;
		width: 100%;
		height: 100%;
		background-color: black;
		z-index:99999998;
		-moz-opacity: 0.6;
		opacity:.20;
		filter: alpha(opacity=20);
	}
	.div-content {
		position: absolute;
		top: 20%;
		left: 40%;
		width: 300px;
		min-height: 200px;
		border: 1px solid lightblue;
		background-color: white;
		z-index:99999999;
		overflow: auto;
		text-align:center;
	}
	.div-content .con-head{
		height: 35px;
		line-height: 35px;
		background: #eaeaea;
		overflow: hidden;
	}
	.div-content .con-body{
		padding: 20px;
	}
	.div-content .con-head .con-head-title{
		padding: 0 10px;
		color: #333;				
	}
	.div-content .con-head .closediv{
		float: right;
		width: 14px;
		height: 14px;
		margin: 10px 10px 0 0;
		background: url(<%=staticPath%>/assets/js/layer/skin/default/xubox_ico0.png) no-repeat -31px -7px;	
		cursor: pointer;			
	}
	.div-content .btn{
		margin:10px auto 20px auto;
	}
</style>
</html>
