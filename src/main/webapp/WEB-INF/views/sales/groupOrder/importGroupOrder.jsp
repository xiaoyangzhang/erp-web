<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>导入团订单</title>
    <%@ include file="../../../include/top.jsp" %>
    <style type="text/css">
        .Wdate {
            width: 95px;
        }
    </style>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
<div class="p_container">
    <div class="p_container_sub pl-10 pr-10">
        <dl class="p_paragraph_content">
            <form id="transferOrderForm" method="post">
                <input id="pageSize" name="pageSize" value="${page.pageSize}" type="hidden"/>
                <input id="page" name="page" value="${page.page}" type="hidden"/>
                
                <dd class="inl-bl">
                    <div class="dd_left">
                       <select name="dateType">
                            <option value="1">出团日期</option>
                            <option value="2">输单日期</option>
                        </select>
                    </div>
                    <div class="dd_right grey">
                        <input class="Wdate" id="startTime" name="startTime"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text"/>
                        <input class="Wdate" id="endTime" name="endTime"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text"/>
                    </div>
                    <div class="clear"></div>
                </dd>
                <dd class="inl-bl">
                    <div class="dd_right">
                        <a class="button button-primary button-small" type="button"
                           onclick="searchBtn();">查询</a>
                    </div>
                    <div class="clear"></div>
                </dd>
            </form>
        </dl>
        <dl class="p_paragraph_content">
            <dd>
                <div id="content"></div>
            </dd>
        </dl>
    </div>
</div>
</body>

<script type="text/javascript">
    $(function () {
        /**
         * 分页查询
         */
        $("#startTime").val($.currentMonthFirstDay());
        $("#endTime").val($.currentMonthFirstDay());
        
        queryList();
        
    });
    
    
    /**
     * 分页查询
     * @param page
     * @param pageSize
     */
    function queryList(page, pageSize) {
        if (!page || page < 1) {
            page = 1;
        }
        
        $("#page").val(page);
        $("#pageSize").val(pageSize);
        
        var options = {
            url: "../groupOrder/importGroupOrderTable.do",
            type: "post",
            dataType: "html",
            success: function (data) {
                $("#content").html(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.error("服务忙，请稍后再试");
            }
        };
        
        $("#transferOrderForm").ajaxSubmit(options);
    }
    
    function searchBtn() {
        var pageSize = $("#pageSize").val();
        queryList(1, pageSize);
    }
</script>
</html>
