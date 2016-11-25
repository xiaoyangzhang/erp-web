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
    <title>消息信息</title>
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
                    
                    <li class="text">信息类型</li>
                    <li>
                        <select name="msgType">
                            <option value="0" <c:if test="${msgType == 0}">selected</c:if>>
                                公告
                            </option>
                            <option value="1" <c:if test="${msgType == 1}">selected</c:if>>
                                业务
                            </option>
                        </select>
                    </li>
                    
                    <li class="text">消息标题</li>
                    <li><input type="text" name="msgTitle"/></li>
                    
                    <li class="text">状态</li>
                    <li>
                        <select name="status">
                            <option value="-1">全部</option>
                            <option value="0" selected>未读</option>
                            <option value="1">已读</option>
                        </select>
                    </li>
                    
                    <li class="text" style="width: 100px;">消息发送人</li>
                    <li><input type="text" name="operatorName"/></li>
                    
                    <li class="text" style="width: 100px;">
                        <button type="button" class="button button-primary button-small"
                                onclick="searchBtn()">搜索
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
            url: "<%=staticPath%>/msgInfo/showMsgListTable.htm",
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
    
    function readMsg(id) {
        $.ajax({
            type : "post",
            url : "<%=staticPath%>/msgInfo/modifyStatus.do",
            data : {
            	midId : id
            },
            dataType : "json",
            success : function(data){
                if(data.success){
                	searchBtn();
                }
            },
            error : function(data,msg){
            	layer.msg(msg);
            }
        });
    }

    function showMsgView(id,mid) {
        parent.layer.open({ 
            type : 2,
            title : '消息详细',
            closeBtn : false,
            area : [ '400px', '300px' ],
            shadeClose : true,
            content : '<%=staticPath%>/msgInfo/showMsgDetail.htm?mid='+mid,
            btn: ['关闭'],
            cancel: function(index){
                layer.close(index);
            },
            end: function() {
                readMsg(id);
            }
        });

    }
    
    function showDetail(orderId) {
        newWindow('查看订单', 'taobao/toEditTaobaoOrder.htm?id='+orderId+'&see=1');
        
        parent.layer.closeAll();
    }
    
    $(function () {
        queryList();
    });
</script>
</body>
</html>