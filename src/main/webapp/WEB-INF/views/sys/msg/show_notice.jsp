<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>公告信息</title>
    <%@ include file="../../../include/top.jsp" %>
</head>
<body>
<div class="p_container">
    <form id="queryForm">
        <input id="page" name="page" type="hidden" value="${page.page}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="p_container_sub">
            <div class="searchRow">
                <ul>
                    <li class="text" style="width: 35px;">日期</li>
                    <li>
                        <input class="Wdate" name="startTime" type="text"
                               value="${startTime}" style="width: 90px;"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> ~
                        <input class="Wdate" name="endTime" type="text"
                               value="${endTime}" style="width: 90px;"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                    </li>
                    <li class="text">公告标题</li>
                    <li><input type="text" name="msgTitle"/></li>
                    <li class="text" style="width: 100px;">
                        <button type="button" class="button button-primary button-small"
                                onclick="saveMsg();">发布公告
                        </button>
                    </li>
                    <li class="text" style="width: 70px;">
                        <button type="button" class="button button-primary button-small"
                                onclick="searchBtn();">搜索
                        </button>
                    </li>
                </ul>
            </div>
        </div>
    </form>
    <div id="tableDiv"></div>
</div>
<script type="text/javascript">
    function queryList(page, pagesize) {
        if (!page || page < 1) {
            page = 1;
        }
        if (!pagesize || pagesize < 15) {
            pagesize = 15;
        }
        $("#page").val(page);
        $("#pageSize").val(pagesize);
        
        var options = {
            url: "<%=staticPath%>/msgInfo/showNoticeListTable.htm",
            type: "post",
            dataType: "html",
            success: function (data) {
                $("#tableDiv").html(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                layer.alert("服务忙，请稍后再试");
            }
        };
        $("#queryForm").ajaxSubmit(options);
    }
    
    function searchBtn() {
        queryList(1, $("#pageSize").val());
    }

    function showNoticeView(mid) {
        parent.layer.open({ 
            type : 2,
            title : '公告详细',
            closeBtn : false,
            area : [ '800px', '600px' ],
            shadeClose : true,
            content : '<%=staticPath%>/msgInfo/showMsgDetail.htm?mid='+mid,
            btn: ['关闭'],
            cancel: function(index){
                layer.close(index);
            }
        });

    }

    function saveMsg() {
        var msg_title;
        var msg_info;
        var operatorName;
        var operatorIds;
        var orderId;
        layer.open({ 
            type : 2,
            title : '发送消息',
            closeBtn : false,
            area : [ '450px', '470px' ],
            shadeClose : true,
            content : '../msgInfo/showMsg.htm',
            btn: ['确定', '取消'],
            success:function(layero, index){
                win = window[layero.find('iframe')[0]['name']];
                
                msg_title = win.$("#msg_title");
                msg_info = win.$("#msg_info");
                operatorName = win.$("#operatorName");
                operatorIds = win.$("#operatorIds");
                
                msg_title.val($("#groupOrder_receiveMode").val());
                orderId = $("#orderId");
            },
            yes: function(index){
                if(msg_title.val() == "") {
                    layer.msg("消息标题不能为空！");
                    return;
                } else if (msg_info.val() == "") {
                    layer.msg("消息内容不能为空！");
                    return;
                } else if (operatorName.val() == "") {
                    layer.msg("接收人员不能为空！");
                    return;
                }
                
                $.post(
                        "../msgInfo/sendMsg.do", 
                        {
                            orderId: orderId.val(),
                            title: msg_title.val(),
                            info: msg_info.val() ,
                            ids: operatorIds.val(),
                            names: operatorName.val(),
                            msgType: 0
                        }, function(data){
                            if(data.success){
                                layer.msg("发送成功！");
                            }else{
                                layer.msg("发送失败！");
                            }
                        },
                "json");
                layer.close(index);
                searchBtn();
            },cancel: function(index){
                layer.close(index);
            }
        });
       
    }
    
    $(function () {
        queryList();
    });
</script>
</body>
</html>