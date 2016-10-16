<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>供应商协议列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <script type="text/javascript">
        var path = '<%=path%>';
        /**
         * 分页查询
         */
        function queryList(page, pageSize) {
            if (!page || page < 1) {
                page = 1;
            }
            $("#searchPage").val(page);
            $("#searchPageSize").val(pageSize);
            $("#queryForm").submit();
        }
        function searchBtn(){
            $("#searchPage").val(1);
            $("#queryForm").submit();

        }

    </script>
</head>
<body>
<div class="p_container">
	<div class="p_container_sub">
		<div class="searchRow">
			<form id="queryForm"  action="<%=path%>/contract/list.htm" method="post">
		        <input type="hidden" name="page" value="${supplierInfo.page}" id="searchPage" />
		        <input type="hidden" name="pageSize" value="${supplierInfo.pageSize}" id="searchPageSize" />
		        <%-- <input type="hidden" name="flag" value="${flag}" id="flag" /> --%>
		        <ul>
		       		 <li class="text">
		       		 	<label class="control-label" for="name">名称/法人：</label>
		       		 </li>
		       		 <li>
		       		 	 <input id="name" type="text" placeholder="名称/法人" name="nameFull" value="${page.parameter.nameFull}" />
		       		 </li>
		       		 
		       		 <li class="text">
		       		 	<label class="control-label" for="name">类型：</label>
		       		 </li>
		       		 <li>
		       		 	  <select id="type" name="supplierType">
		                    <option value="" <c:if test="${ page.parameter.supplierType eq null}">selected="selected"</c:if>>全部</option>
		                    <option value="1" <c:if test="${ page.parameter.supplierType eq 1}">selected="selected"</c:if>>组团社</option>
		                    <option value="2" <c:if test="${ page.parameter.supplierType eq 2}">selected="selected"</c:if>>餐厅</option>
		                    <option value="3" <c:if test="${ page.parameter.supplierType eq 3}">selected="selected"</c:if>>酒店</option>
		                    <option value="4" <c:if test="${ page.parameter.supplierType eq 4}">selected="selected"</c:if>>车队</option>
		                    <option value="5" <c:if test="${ page.parameter.supplierType eq 5}">selected="selected"</c:if>>景区</option>
		                    <option value="6" <c:if test="${ page.parameter.supplierType eq 6}">selected="selected"</c:if>>购物</option>
		                    <option value="7"  <c:if test="${ page.parameter.supplierType eq 7}">selected="selected"</c:if>>娱乐</option>
		                    <option value="9" <c:if test="${ page.parameter.supplierType eq 9}">selected="selected"</c:if>>机票</option>
		                    <option value="10" <c:if test="${ page.parameter.supplierType eq 10}">selected="selected"</c:if>>火车票</option>
		                    <option value="12" <c:if test="${ page.parameter.supplierType eq 12}">selected="selected"</c:if>>其他</option>
		                    <option value="15" <c:if test="${ page.parameter.supplierType eq 15}">selected="selected"</c:if>>保险</option>
		                    <option value="16" <c:if test="${ page.parameter.supplierType eq 16}">selected="selected"</c:if>>地接社</option>
		                    <option value="120" <c:if test="${ page.parameter.supplierType eq 120}">selected="selected"</c:if>>其他收入</option>
		                    <option value="121" <c:if test="${ page.parameter.supplierType eq 121}">selected="selected"</c:if>>其他支出</option>
		                   
		                    <%-- <c:forEach items="${supplierTypeMap}" var="type">
		                        <option value="${type.key}" <c:if test="${type.key == page.parameter.supplierType}">selected="selected"</c:if>>${type.value}</option>
		                    </c:forEach> --%>
		                  </select>
		       		 </li>
		       		 
		       		 <li class="text">
		       		 	<label class="control-label" for="name">状态：</label>
		       		 </li>
		       		 <li>
		       		 	<select name="signedState">
		                    <option value="">全部</option>
		                    <c:forEach items="${supplierStateMap}" var="type">
		                        <option value="${type.key}" <c:if test="${type.key == page.parameter.signedState}">selected="selected"</c:if>>${type.value}</option>
		                    </c:forEach>
		                </select>
		       		 </li>
		       		 
		       		 <li class="text">
		       		 	<label class="control-label" for="name">区域：</label>
		       		 </li>
                    <li>
                    <select name="provinceId" id="provinceCode" class="input-small">
                        <option value="">请选择省</option>
                        <c:forEach items="${allProvince}" var="province">
                            <option value="${province.id }" <c:if test="${province.id==supplierInfo.provinceId }">selected="selected"</c:if>>${province.name }</option>
                        </c:forEach>
                    </select>
                    <select name="cityId" id="cityCode" class="input-small">
                        <option value="">请选择市</option>
                        <c:forEach items="${cityList }" var="city">
                            <option value="${city.id }"  <c:if test="${city.id==supplierInfo.cityId }">selected="selected"</c:if> >${city.name }</option>
                        </c:forEach>
                    </select>
                    <select name="areaId" id="areaCode" class="input-small">
                        <option value="">请选择区县</option>
                        <c:forEach items="${areaList }" var="area">
                            <option value="${area.id }"  <c:if test="${area.id==supplierInfo.areaId }">selected="selected"</c:if> >${area.name }</option>
                        </c:forEach>
                    </select>
                    <%--</li>--%>
		       		 	 <%--<input type="text" name="provinceName" placeholder="省" value="${page.parameter.provinceName}" />--%>
		                 <%--&nbsp;<input type="text" name="cityName" placeholder="市/区/州" value="${page.parameter.cityName}" />--%>
		                 <%--&nbsp;<input type="text" name="areaName" placeholder="县" value="${page.parameter.areaName}" />--%>
		       		 <%--</li>--%>
		       		 </li>
		       		 <li class="clear" />
					 <li class="text"></li>
					 <li>
					 	<button type="submit" class="button button-primary button-small" id="searchTitle" onclick="searchBtn();">
							查询
						</button>
					 </li>
	        	</ul>
	    	</form>
		</div>
    
    <table id="table" class="w_table">
        <thead>
        <tr>
            <th>序号<i class="w_table_split"></i></th>
            <th>名称<i class="w_table_split"></i></th>
            <th>类型<i class="w_table_split"></i></th>
            <th>法人<i class="w_table_split"></i></th>
            <th>地址<i class="w_table_split"></i></th>
            <th>状态<i class="w_table_split"></i></th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="supplier" items="${page.result}" varStatus="status">
            <tr>
                <td>${status.index + 1}</td>
                <td>${supplier.nameFull}</td>
                <td>${supplierTypeMap[supplier.supplierType]}</td>
                <td>${supplier.lawPerson}</td>
                <td>${supplier.provinceName}&nbsp;${supplier.cityName}&nbsp;${supplier.areaName}&nbsp;${supplier.townName}&nbsp;${supplier.address}</td>
                <td><c:choose><c:when test="${supplier.signedState == 0}">未签订</c:when><c:otherwise>已签订</c:otherwise></c:choose></td>
                <td><a class="def" onclick="newWindow('协议详情', '<%=path%>/contract/${supplier.id}/${flag }/view-list.htm')" href="javascript:void(0);" >查看</a>
                    &nbsp;<a class="def" onclick="newWindow('新增协议', '<%=path%>/contract/${supplier.id}/add.htm')" href="javascript:void(0);">新增</a></td>
                <%--href="<%=path%>/contract/${supplier.id}/view-list.htm"--%>
            </tr>
        </c:forEach>
        </tbody>
    </table>
   <jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${page.page }" name="p" />
				<jsp:param value="${page.totalPage }" name="tp" />
				<jsp:param value="${page.pageSize }" name="ps" />
				<jsp:param value="${page.totalCount }" name="tn" />
	</jsp:include>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $("#provinceCode").change(
                function() {
                    var s = "<option value=''>请选择市</option>";
                    var val = this.options[this.selectedIndex].value;
                    if(val !== ''){
                        $.getJSON("../basic/getRegion.do?id="
                                + val, function(data) {
                            data = eval(data);
                            $.each(data, function(i, item) {
                                s += "<option value='" + item.id + "'>" + item.name
                                        + "</option>";
                            });
                            $("#cityCode").html(s);
                        });
                    }else{
                        $("#cityCode").html(s);
                    }
                    $("#areaCode").html("<option value=''>请选择区县</option>");
                    $("#townCode").html("<option value=''>请选择街道</option>");

//                    $("#cityCode").html("<option value=''>请选择市</option>");
//                    $("#areaCode").html("<option value=''>请选择区县</option>");
//                    $("#townCode").html("<option value=''>请选择街道</option>");
//                    $.getJSON("../basic/getRegion.do?id="
//                            + $("#provinceCode").val(), function(data) {
//                        data = eval(data);
//                        var s = "<option value=''>请选择市</option>";
//                        $.each(data, function(i, item) {
//                            s += "<option value='" + item.id + "'>" + item.name
//                                    + "</option>";
//                        });
//                        $("#cityCode").html(s);
//
//                    });

                });

        $("#cityCode").change(
                function() {

                    var s = "<option value=''>请选择区县</option>";
                    var val = this.options[this.selectedIndex].value;
                    if(val !== ''){
                        $.getJSON("../basic/getRegion.do?id="
                                + val, function(data) {
                            data = eval(data);
                            $.each(data, function(i, item) {
                                s += "<option value='" + item.id + "'>" + item.name
                                        + "</option>";
                            });
                            $("#areaCode").html(s);
                        });
                    }else{
                        $("#areaCode").html(s);
                    }

                    $("#townCode").html("<option value=''>请选择街道</option>");

//                    $.getJSON("../basic/getRegion.do?id=" + $("#cityCode").val(),
//                            function(data) {
//                                data = eval(data);
//                                var s = "<option value=''>请选择区县</option>";
//                                $.each(data, function(i, item) {
//                                    s += "<option value='" + item.id + "'>"
//                                            + item.name + "</option>";
//                                });
//                                $("#areaCode").html(s);
//
//                            });

                });
        $("#areaCode").change(
                function() {

                    var s = "<option value=''>请选择街道</option>";
                    var val = this.options[this.selectedIndex].value;
                    if(val !== ''){
                        $.getJSON("../basic/getRegion.do?id="
                                + val, function(data) {
                            data = eval(data);
                            $.each(data, function(i, item) {
                                s += "<option value='" + item.id + "'>" + item.name
                                        + "</option>";
                            });
                            $("#townCode").html(s);
                        });
                    }else{
                        $("#townCode").html(s);
                    }

//                    $("#townCode").html("<option value=''>请选择街道</option>");
//                    $.getJSON("../basic/getRegion.do?id=" + $("#areaCode").val(),
//                            function(data) {
//                                data = eval(data);
//                                var s = "<option value=''>请选择街道</option>";
//                                $.each(data, function(i, item) {
//                                    s += "<option value='" + item.id + "'>"
//                                            + item.name + "</option>";
//                                });
//                                $("#townCode").html(s);
//
//                            });
                });
    });
</script>
</body>
</html>
