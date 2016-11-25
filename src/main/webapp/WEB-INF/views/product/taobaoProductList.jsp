<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>爱游【产品列表】</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    
    <style>
        .searchRow li.text {
            width: 80px;
            text-align: right;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="p_container">
    <form id="searchProductForm">
	<div class="p_container_sub">
			<div class="searchRow">
                <input type="hidden" id="searchPage" name="page" value=""/>
                <input type="hidden" id="searchPageSize" name="pageSize" value=""/>
                <ul>
                <ul >
					<li class="text">自编码:</li>
                    <li ><input name="outerId" type="text"/>
                    </li>
                    <li class="text">产品名称:</li>
                    <li>
                        <input type="text" name="title"/>
                    </li>
                    <li class="text">
                        <button type="button" onclick="searchBtn()"
                                class="button button-primary button-small">查询
                        </button>
                          </li>
                        <c:if test="${optMap['EDIT'] }">
                         <li class="text">
                            <a href="javascript:void(0)"
                               onclick="newWindow('新增产品', '<%=path%>/productInfo/add.htm')"
                               class="button button-primary button-small">新增</a></li>
                        </c:if>
                        <li class="text">
                        <button class="button button-primary button-small" type="button"
                                onclick="syncProduct();">同步淘宝上架的商品
                        </button> 
                    <input type="hidden" id="optEdit" value="${optMap['EDIT'] }"/>
                    </li>
                    <li class="clear"/>
           </ul>
			</div>
	</div>
	</form>
	
	<dl class="p_paragraph_content">
            <div id="productDiv">
            
            </div>
</dl>

</div>

<div id="taobao" style="display: none">
<select id="authClient">
    <option value="AY">爱游</option>
    <option value="YM">怡美</option>
    <option value="JY">景怡</option>
    <option value="TX">天翔</option>
    <option value="OUTSIDE">出境</option>
</select>
</div>
</body>
<script type="text/javascript">
    $(document).ready(function () {
        queryList();
    });
    
    function queryList(page, pageSize) {
        $("#searchPageSize").val(pageSize);
        $("#searchPage").val(page);
        var options = {
            url: "taobaoProductList_table.do",
            type: "post",
            dataType: "html",
            success: function (data) {
                $("#productDiv").html(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.error("服务忙，请稍后再试");
            }
        };
        $("#searchProductForm").ajaxSubmit(options);
    }
    
    function searchBtn() {
        var pageSize = $("#searchPageSize").val();
        
        queryList(1, pageSize);
    }
    
    /**
    * 同步淘宝产品
    **/
    function syncProduct() {
        layer.open({
            type: 1,
            title: '选择淘宝店铺',
            closeBtn: false,
            area: ['300px', '200px'],
            shadeClose: false,
            content: $("#taobao"),
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url: "syncProducts.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        authClient: $("#authClient").val()
                    },
                    success: function (data) {
                        if (data.success) {
                            alert("同步成功");
                        }
                        else {
                            alert("同步失败");
                        }

                        //一般设定yes回调，必须进行手工关闭
                        layer.close(index);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器忙，请稍候再试");
                    }
                });
            }, cancel: function (index) {
                layer.close(index);
            }
        });
    }
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

</html>
