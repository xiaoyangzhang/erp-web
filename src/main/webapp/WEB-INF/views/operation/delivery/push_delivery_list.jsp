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
    <title>地接社订单推送列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
    <script type="text/javascript">
        $(function () {
            var vars = {dateFrom: $.currentMonthFirstDay(), dateTo: $.currentMonthLastDay()};
            $("#groupDateStart").val(vars.dateFrom);
            $("#groupDateEnd").val(vars.dateTo);
        });
    </script>
</head>
<body>
<div class="p_container">
    <div id="tabContainer">
        <div class="p_container_sub" id="list_search">
            <dl class="p_paragraph_content">
                <form id="queryForm">
                    <input type="hidden" id="searchPage" name="page"/>
                    <input type="hidden" id="searchPageSize" name="pageSize"/>
                    <input type="hidden" id="supplierType" name="supplierType" value="${supplierType }"/>
                    <input type="hidden" id="selectDate" name="selectDate" value="0">
                    <dd class="inl-bl">
                        <div class="dd_left">出团日期:</div>
                        <div class="dd_right grey">
                            <input type="text" id="groupDateStart" name="startTime" class="Wdate"
                                   onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=""/> —
                            <input type="text" id="groupDateEnd" name="endTime" class="Wdate"
                                   onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=""/>
                        </div>

                    </dd>
                    <dd class="inl-bl">
                        <div class="dd_left">团号:</div>
                        <div class="dd_right grey">
                            <input type="text" name="groupCode" id="" value="" class="w-200"/>
                        </div>

                    </dd>
                    <dd class="inl-bl">
                        <div class="dd_left">状态:</div>
                        <div class="dd_right grey">
                            <select class="select160" name="pushStatus">
                                <option value="-1">全部</option>
                                <option value="0">未推送</option>
                                <option value="1">已推送</option>

                            </select>
                        </div>
                        <div class="clear"></div>
                    </dd>
                    <dd class="inl-bl">
                        <div class="dd_right">
                            <button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索
                            </button>
                        </div>
                        <div class="clear"></div>
                    </dd>
                </form>
            </dl>

            <dl class="p_paragraph_content">
                <dd>
                    <div class="pl-10 pr-10" id="tableDiv">

                    </div>
                </dd>
            </dl>
        </div>


    </div><!--#tabContainer结束-->
</div>

<div id="plat" style="display: none">
    推送方：
    <select id="platAuth">
        <c:forEach items="${platAuth}" var="pa">
            <option value="${pa.appKey},${pa.appSecret}">${pa.platName}</option>
        </c:forEach>
    </select>
</div>

<script type="text/html" id="contactScript">
          	 	
</script>


<script type="text/javascript">
    $(document).ready(function () {
        queryList();
        $("#tabContainer").idTabs();
    });

    function queryList(page, pageSize) {
        if (!page || page < 1) {
            page = 1;
        }
        $("#searchPageSize").val(pageSize);
        $("#searchPage").val(page);
        var options = {
            url: "pushDeliveryListTable.do",
            type: "post",
            dataType: "html",
            success: function (data) {
                $("#tableDiv").html(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.error("服务忙，请稍后再试");
            }
        };
        $("#queryForm").ajaxSubmit(options);
    }

    function searchBtn() {
        var pageSize = $("#searchPageSize").val();
        queryList(1, pageSize);
    }

    /**
     * 页面选择部分调用函数(多选)
     */
    function selectUserMuti(num) {
        var width = window.screen.width;
        var height = window.screen.height;
        var wh = (width / 1920 * 650).toFixed(0);
        var hh = (height / 1080 * 500).toFixed(0);
        wh = wh + "px";
        hh = hh + "px";
        var lh = (width / 1920 * 400).toFixed(0);
        var th = (height / 1080 * 100).toFixed(0);
        lh = lh + "px";
        th = th + "px";
        var win = 0;
        layer.open({
            type: 2,
            title: '选择人员',
            shadeClose: true,
            shade: 0.5,
            offset: [th, lh],
            area: [wh, hh],
            content: '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
            btn: ['确定', '取消'],
            success: function (layero, index) {
                win = window[layero.find('iframe')[0]['name']];
            },
            yes: function (index) {
                var userArr = win.getUserList();

                $("#saleOperatorIds").val("");
                $("#saleOperatorName").val("");
                for (var i = 0; i < userArr.length; i++) {
                    console.log("id:" + userArr[i].id + ",name:" + userArr[i].name + ",pos:" + userArr[i].pos + ",mobile:" + userArr[i].mobile + ",phone:" + userArr[i].phone + ",fax:" + userArr[i].fax);
                    if (i == userArr.length - 1) {
                        $("#saleOperatorName").val($("#saleOperatorName").val() + userArr[i].name);
                        $("#saleOperatorIds").val($("#saleOperatorIds").val() + userArr[i].id);
                    } else {
                        $("#saleOperatorName").val($("#saleOperatorName").val() + userArr[i].name + ",");
                        $("#saleOperatorIds").val($("#saleOperatorIds").val() + userArr[i].id + ",");
                    }
                }
                layer.close(index);
            }, cancel: function (index) {
                layer.close(index);
            }
        });
    }

    /**
     * 重置查询条件
     */
    function multiReset() {
        $("#saleOperatorName").val("");
        $("#saleOperatorIds").val("");

    }

    function push(groupId, bookingId, toAppKey) {
        var loadIndex = layer.load(1, {shade: [0.5, '#fff']});

        var $platAuth = $("#platAuth");
        var paStr = $platAuth.val().split(",");

        layer.open({
            type: 1,
            title: '选择平台',
            shadeClose: true,
            shade: 0.5,
            area: ['300px', '200px'],
            content: $("#plat"),
            btn: ['确定', '取消'],
            yes: function (index) {

                $.ajax({
                    type: "post",
                    url: "../booking/pushRemoteSave.do",
                    data: {
                        "groupId": groupId,
                        "bookingId": bookingId,
                        "fromAppKey": paStr[0],
                        "fromSecretKey": paStr[1],
                        "toAppKey": toAppKey
                    },
                    dataType: "json",
                    success: function (data) {
                        if(data.success) {
                            layer.alert("推送成功");
                            searchBtn();
                        } else {
                            layer.alert("推送失败");
                        }
                    },
                    error: function () {
                        layer.alert("推送失败");
                    }
                });
                layer.close(index);
                layer.close(loadIndex);
            }, cancel: function (index) {
                layer.close(index);
            }
        });
    }
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</body>
</html>
