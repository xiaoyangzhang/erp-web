<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../../../include/top.jsp" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>行程</title>
    <link href="<%=ctx%>/assets/css/product/product_rote.css" rel="stylesheet"/>
    <script type="text/javascript" src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>
<div class="p_container">
    <div class="p_container_sub">
        <form id="routeForm" method="post" >
            <input type="hidden" name="productId" value="${productId}" />
            <p class="p_paragraph_title"><b>行程明细</b></p>
            <div>
                <div class="dd_left"><i class="red">* </i>天数</div>
                <div class="dd_right"><input id="daysCount" type="text" class="IptText60" disabled /></div>
                <div class="clear"></div>
            </div>
            <div class = "content1">
                <div id="divTab" class="position_relative">
                    <div class="w_DayBox">
                        <ul class="tab" id="dayUL">
                        </ul>
                        <button type="button" class="proAdd_btn" >增加</button>
                    </div>
                    <div id="tabCon">
                    
                    </div>
                    <div class = "con_btn">
                        <button class="con_btn1" type="submit" >保存</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<div id="imgTemp" style="display: none">
   <span class="ulImg">
       <img src="$src" alt="$name"><i class="icon_del" style="display: none;" id="delImg"></i>
       <input type="hidden" name="productRoteDayVoList[$index].productAttachments[$cindex].name" value="$name" />
       <input type="hidden" name="productRoteDayVoList[$index].productAttachments[$cindex].path" value="$path" />
       <input type="hidden" name="productRoteDayVoList[$index].productAttachments[$cindex].type" value="1" />
       <input type="hidden" name="productRoteDayVoList[$index].productAttachments[$cindex].objType" value="2" />
   </span>
</div>
<script type="text/html" id="dayRowHtml">
    <div class = "content_all">
        <dl class="p_paragraph_content">
            <dd>
                <div class="dd_left">交通</div>
                <div class="dd_right TrafficBtns" id="trafficSpan">
                    <span class="trafficDetails"></span>
                    <label class = "blue_txt2 btnPop">选择交通</label>
                </div>
                <div class="clear"></div>
            </dd>
            <dd>
                <div class="dd_left">用餐</div>
                <div class="dd_right">
                    <div class="mb-10"><label>早餐</label>&nbsp;
                        <input id="productRoteDayVoList[$index].productRoute.breakfast" type="text" name="productRoteDayVoList[$index].productRoute.breakfast" class="IptText300"></div>
                    <div class="mb-10"><label>午餐</label>&nbsp;
                        <input id="productRoteDayVoList[$index].productRoute.lunch" type="text" name="productRoteDayVoList[$index].productRoute.lunch" class="IptText300"></div>
                    <div class="mb-10"><label>晚餐</label>&nbsp;
                        <input id="productRoteDayVoList[$index].productRoute.supper" type="text" name="productRoteDayVoList[$index].productRoute.supper" class="IptText300"></div>
                </div>
                <div class="clear"></div>
            </dd>
            <dd>
                <div class="dd_left">住宿</div>
                <div class="dd_right hotelBtns">
                        <span class="hotelDetails">
                            <input type="hidden" name="productRoteDayVoList[$index].productRoute.hotelId" value="0" class="IptText300">
                            <input type="text" name="productRoteDayVoList[$index].productRoute.hotelName" class="IptText300">
                        </span>
                </div>
                <div class="clear"></div>
            </dd>
            <dd>
                <div class="dd_left">行程描述</div>
                <textarea name="productRoteDayVoList[$index].productRoute.routeDesp"></textarea>
                <div class="clear"></div>
            </dd>
            <dd>
                <div class="dd_left">温馨提示</div>
                <textarea name="productRoteDayVoList[$index].productRoute.routeTip"></textarea>
                <div class="clear"></div>
            </dd>
            <dd>
                <div class="dd_left">商家列表</div> <label class = "blue_txt2 btnOptionSupplier" >选择商家</label>
                <br /><br />
                <div class="dd_right" style="width:80%;margin-left:6%" >
                    <table cellspacing="0" cellpadding="0" class="w_table" >
                        <col width="15%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="10%" />
                        <thead>
                        <tr>
                            <th>类别<i class="w_table_split"></i></th>
                            <th>名称<i class="w_table_split"></i></th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
                <div class="clear"></div>
            </dd>
            <dd>
                <div class="dd_left">图片集</div>
                <div class="dd_right addImg" >

                </div>
                <label onclick="selectAttachment(this)" class="ulImgBtn"></label>
                <div class="clear"></div>
            </dd>

        </dl>
    </div>
</script>
<script type="text/javascript">
    var path = '<%=path%>';
</script>
<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_route_add.js"></script>
</body>
</html>