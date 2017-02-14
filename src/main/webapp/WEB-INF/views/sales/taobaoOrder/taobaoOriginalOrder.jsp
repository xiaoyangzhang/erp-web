<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>淘宝原始单</title>
    <%@ include file="../../../include/top.jsp" %>
    <SCRIPT type="text/javascript">
       /*  $(function () {
            function setData() {
                var curDate = new Date();
                var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
                $("#startMin").val(startTime);
                var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
                var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
                var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
                $("#startMax").val(endTime);
                var today = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + curDate.getDate();
                //$("#today").val(today);
                //$("#today1").val(today);
                
                $("#startTime").val(today);
                $("#endTime").val(today);
                
            }
            
            setData();
        }); */
        
        
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
                url: "<%=staticPath%>/taobao/taobaoOriginalOrder_table.htm",
                type: "get",
                dataType: "html",
                success: function (data) {
                    $("#tableDiv").html(data);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("服务忙，请稍后再试");
                }
            }
            $("#queryForm").ajaxSubmit(options);
        }
        
        function searchBtn() {
            queryList(1, $("#pageSize").val());
        }
        
        $(function () {
            queryList();
        });
        
        function cancelBtn() {
            var idss = $("input[name='idss']:checked").serialize();
            if (idss == "") {
                alert("请选择订单");
            } else {
                $.ajax({
                    type: "post",
                    url: "../taobao/updateCancel.do",
                    data: idss,
                    success: function (data) {
                        alert("废弃成功");
                        searchBtn()
                    },
                    error: function () {
                        alert("废弃失败");
                    }
                });
            }
        }
        
        function newBtn() {
            var idss = $("input[name='idss']:checked").serialize();
            if (idss == "") {
                alert("请选择订单");
            } else {
                $.ajax({
                    type: "post",
                    url: "../taobao/updateNew.do",
                    data: idss,
                    success: function (data) {
                        alert("还原成功");
                        searchBtn()
                    },
                    error: function () {
                        alert("还原失败");
                    }
                });
            }
        }
        
        var index;
        function synchBtn() {
            var loadIndex = layer.load(1, {shade: [0.5,'#fff']});

            var type = $("input[type='radio']:checked").val();
            var tid = $("#stid").val();
            if (type == "time") {
                $.ajax({
                    type: "post",
                    url: "../taobao/synchroByTime.do",
                    data: "startTime=" + $("#startTime").val() + "&endTime="
                    + $("#endTime").val() + "&authClient="
                    + $("#authClient").val()+"&startTimeHour="
                    + $("#startTimeHour").val(),
                    success: function (data) {
                        alert("同步成功");
                        searchBtn();
                        layer.close(index);
                        layer.close(loadIndex);
                    },
                    error: function () {
                        alert("同步失败");
                        layer.close(index);
                        layer.close(loadIndex);
                    }
                });
            } else {
                $.ajax({
                    type: "post",
                    url: "../taobao/synchroByTid.do",
                    data: "tid=" + tid + "&authClient=" + $("#authClient").val(),
                    success: function (data) {
                        alert("同步成功");
                        searchBtn();
                        layer.close(index);
                        layer.close(loadIndex);
                    },
                    error: function () {
                        alert("同步失败");
                        layer.close(index);
                        layer.close(loadIndex);
                    }
                });
            }
        }
        
        function synBtn() {
        	index = layer.open({
                type: 1,
                title: '同步原始单',
                shadeClose: true,
                shade: 0.5,
                area: ['300px', '300px'],
                content: $("#show").show(),
                end: function() {
                    $("#stid").val('');
                }
            });
        }
        
        function toExcel(){
        	$("#toExcelId").attr("href","toOriginalExcel.do?startMin="+$("#startMin").val()
        			+"&startMax="+$("#startMax").val()
        			+"&tid="+$("#tid").val()
        			+"&buyerNick="+$("#buyerNick").val()
        			+"&myState="+$("#myState").val()
        			+"&isBrushSingle="+$("#isBrushSingle").val()
        			+"&title="+$("#title").val()
        			+"&outerIid="+$("#outerIid").val()
        			+"&authClient="+$("#authClient").val()
        			+"&page="+$("#orderPage").val()
        			+"&pageSize="+$("#orderPageSize").val());
        }
    </SCRIPT>
</head>
<body>
<div class="p_container" id=aaaa>
    <form id="queryForm" 　method="post">
        <input type="hidden" name="page" id="page" value="${page.page }"/>
        <input type="hidden" name="pageSize" id="pageSize" value="${page.pageSize }"/>
        <%-- <input type="hidden" name="authClient" id="authClient" value="${authClient}"/> --%>
        <div class="p_container_sub">
            <div class="searchRow">
                <ul>
                    <li class="text" style="">订单日期</li>
                    <li>
                        <input name="startMin" id="startMin" type="text" value="${startMin}"
                               style="width: 140px;" class="Wdate"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/> ~ <input
                            name="startMax" id="startMax" type="text" value="${startMax}"
                            style="width: 140px;" class="Wdate"
                            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/></li>
                    <li class="text">订单号</li>
                    <li><input type="text" name="tid" id="tid"/></li>
                    
                    <li class="text">旺旺号</li>
                    <li><input type="text" name="buyerNick" id="buyerNick" style="width: 100px"/></li>
                    
                    <li class="text">状态</li>
                    <li><select name="myState" id="myState">
                        <option value="NEW">未组单</option>
                        <option value="CONFIRM">已组单</option>
                        <option value="CANCEL">废弃</option>
                        <option value="BEYOND">超出库存</option>
                        <option value="">全部</option>
                    </select></li>
                    <li class="text">产品名称</li>
                   <li><input type="text" name="title" id="title"/></li>
                     <li class="text">自编码</li>
                    <li><input type="text" name="outerIid" id="outerIid" value="${outerIid}"/></li>
                    
                       <li class="text">特单状态</li>
                    <li><select name="isBrushSingle" id="isBrushSingle">
                        <option value=""  <c:if test="${isBrushSingle==''}">selected </c:if>>全部</option>
                        <option value="1" <c:if test="${isBrushSingle=='1'}">selected </c:if>>淘宝</option>
                        <option value="0" <c:if test="${isBrushSingle=='0'}">selected </c:if>>正常下单</option>
                    </select></li>
                    
                    <li class="text">店铺</li>
                    <li><select id="authClient" name="authClient">
                     <c:if test="${optMap_AY}">
                            <option value="AY" <c:if test="${myStoreId=='AY'}">selected </c:if>>爱游</option>
                        </c:if>
                        <c:if test="${optMap_YM}">
                            <option value="YM"<c:if test="${myStoreId=='YM'}">selected </c:if>>怡美</option>
                        </c:if>
                        <c:if test="${optMap_JY}">
                            <option value="JY"<c:if test="${myStoreId=='JY'}">selected </c:if>>景怡</option>
                        </c:if>
                        <c:if test="${optMap_TX}">
                            <option value="TX"<c:if test="${myStoreId=='TX'}">selected </c:if>>天翔</option>
                        </c:if>
                        <c:if test="${optMap_OUTSIDE}">
                            <option value="OUTSIDE"<c:if test="${myStoreId=='OUTSIDE'}">selected </c:if>>出境店</option>
                        </c:if>
                    </select></li>
                    
                    <li class="text" style="width: 35px;"></li>
                    <li>
                        <button type="button" class="button button-primary button-small"
                                onclick="searchBtn()">搜索
                        </button>
                        <button id="btnOK" type="button" class="button button-primary button-small"
                                onclick="synBtn()">同步
                        </button>
                        <button id="btnOK" type="button" class="button button-primary button-small"
                                onclick="cancelBtn()">废弃
                        </button>
                        <button id="btnOK" type="button" class="button button-primary button-small"
                                onclick="newBtn()">还原
                        </button>
                        <a href="javascript:void(0);" id="toExcelId" target="_blank" onclick="toExcel()" class="button button-primary button-small">导出到Excel</a>
                    </li>
                    <li class="clear"/>
                </ul>
            </div>
        </div>
    </form>
    <div id="tableDiv"></div>
    <div id="show" style="display: none; margin: 50px 50px;">
        <dd class="inl-bl">
            <input type="radio" name="type" value="time" checked/> 
            <label for="time"><span>按日期： </span></label>
            <div>
                <input id="startTime" name="startTime" type="text" class="Wdate"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                
                 <!-- 至 <input name="endTime"  id="endTime"  type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> -->
                 <!-- <select id="startTimeHour" name="startTimeHour">
                            <option value=" 00:00:00- 05:59:59">0点－6点</option>
                            <option value=" 06:00:00- 11:59:59">6点－12点</option>
                            <option value=" 12:00:00- 17:59:59">12点－18点</option>
                             <option value=" 18:00:00- 23:59:59">18点－24点</option>
                             <option value=" 00:00:00- 23:59:59">全天</option>
                            </select> -->
            </div>
            <div class="clear"></div>
        </dd>
        <br>
        <dd class="inl-bl">
            <input type="radio" name="type" value="stid"/> <label
                for="stid"><span>按订单号: </span></label>
            <div class="dd_right grey">
                <input id="stid" name="stid" type="text"/>
            </div>
            <div class="clear"></div>
        </dd>
        <br>

        <button type="button" onclick="synchBtn()" class="button button-primary button-small">开始同步</button>
    
    </div>

</div>
</body>
</html>