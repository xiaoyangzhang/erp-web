<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>产品明细</title>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/product/product_detail.css"/>
</head>
<body>
<div class="mainbody">
    <div class="bodytop">
        <h2>【${productInfoVo.productInfo.brandName}】<span>${productInfoVo.productInfo.nameCity}</span></h2>
		<input type="hidden" id="productId" value="${productInfoVo.productInfo.id }" />
        <div class="banner">
            <ul id="banner_list">
            	<c:if test="${empty productInfoVo.productAttachments }">
            		<li><img src="<%=ctx%>/assets/img/default_product_cover.jpg"/></li>
            	</c:if>
            	<c:if test="${!empty  productInfoVo.productAttachments }">
                <c:forEach items="${productInfoVo.productAttachments}" var="imgs">
                    <li><img src="${config.images200Url }${cf:thumbnail(imgs.path,'200x200')}"/></li>
                </c:forEach>
				</c:if>
            </ul>
            <ol id="banner_btn">
                <c:forEach items="${productInfoVo.productAttachments}" varStatus="s">
                    <li <c:if test="${s.first}">class="sel"</c:if>>${s.index + 1}</li>
                </c:forEach>
            </ol>
        </div>
        <div class="jianjie">
            <p>产品编号<span>${productInfoVo.productInfo.code}</span> <c:if test="${not empty productInfoVo.attachments }"><a style="float: right;" href="javascript:void(0)" onclick="openDownloadLayer()">附件下载</a></c:if></p>

            <p>旅游天数<span>${productInfoVo.productInfo.travelDays}天</span></p>

            <p><b>产品特色</b><c:if test="${fn:trim(productRemark.productFeature) != ''}"><span><a class="more_detail" >更多</a></span></c:if> </p>
            <div class="cpts rich_text expand_text">
                ${productRemark.productFeature}
            </div>

            <p><b>收客注意事项</b><span><c:if test="${fn:trim(productRemark.guestNote) != ''}"><a class="more_detail" >更多</a></span></c:if></p>
            <div class="zysx rich_text expand_text">
                ${productRemark.guestNote}
            </div>
        </div>
    </div>

    <div class="zhong" id="divContent">
        <ul>
            <li><a class="d_tab selected" jump-to="tabPrice" href="javascript:void(0)" >日期和报价</a></li>
            <li><a class="d_tab" jump-to="tabDay" href="javascript:void(0)" >详细行程</a></li>
            <li><a class="d_tab" jump-to="tabRemark" href="javascript:void(0)" >备注信息</a></li>
        </ul>
        <div class="clear"></div>
    </div>

    <div class="day d_content" style="display: none;" id="tabDay">

        <div class="nav_container">
            <ul class="w_remarksNav">
                <c:forEach items="${productRouteVo.productRoteDayVoList}" var="dayVo" varStatus="s">
                    <li <c:if test="${s.first}">class="on"</c:if>><a day-num="${dayVo.productRoute.dayNum}" class="daysLabel" href="#day${s.index + 1}"></a></li>
                </c:forEach>
            </ul>
        </div>

        <div class="rdaycontainer">
            <c:forEach items="${productRouteVo.productRoteDayVoList}" var="dayVo" varStatus="s">
                <div id="day${s.index + 1}" class="rday">
                    <div class="oneday">
                        <div class="one">
                            <img src="<%=ctx%>/assets/css/product/img/day.png"/>

                            <p day-num="${dayVo.productRoute.dayNum}" class="daysLabel"></p>

                        </div>
                        <div class="two">
                            <img src="<%=ctx%>/assets/css/product/img/feiji.png"/>

                            <p class="trafficFont">
                                <c:forEach items="${dayVo.productRouteTrafficList}" var="traffic">
                                    <span class="rote_tanslate"><label class = "diqu_txt">${traffic.cityDeparture}</label>
                                        <c:choose>
                                            <c:when test="${traffic.typeId == 1}">
                                                <img src = "<%=ctx%>/assets/img/plane.png" class = "city_img"/>
                                            </c:when>
                                            <c:when test="${traffic.typeId == 2}">
                                                <img src = "<%=ctx%>/assets/img/train.png" class = "city_img"/>
                                            </c:when>
                                            <c:when test="${traffic.typeId == 3}">
                                                <img src = "<%=ctx%>/assets/img/bus.png" class = "city_img"/>
                                            </c:when>
                                            <c:when test="${traffic.typeId == 4}">
                                                <img src = "<%=ctx%>/assets/img/ship.png" class = "city_img"/>
                                            </c:when>
                                        </c:choose>
                                    <label><c:if test="${not empty traffic.miles and not empty traffic.duration}">
                                            (${traffic.miles}km,
                                            ${traffic.duration}h)
                                        </c:if>
                                        <c:if test="${not empty traffic.miles and empty traffic.duration}">
                                            (${traffic.miles}km)
                                        </c:if>
                                        <c:if test="${empty traffic.miles and not empty traffic.duration}">
                                            (${traffic.duration}h)
                                        </c:if>
                                    </label>
                                    <label class = "diqu_txt">${traffic.cityArrival}</label></span>
                                </c:forEach>
                            </p>
                            <p class="rich_text">${dayVo.productRoute.routeDesp}</p>
                        </div>
                        <div class="three">
                            <img src="<%=ctx%>/assets/css/product/img/food.png"/>

                            <p><span>早餐</span>
                                <span>
                                    ${dayVo.productRoute.breakfast}
                                </span>
                            </p>

                            <p><span>午餐</span>
                                <span>
                                    ${dayVo.productRoute.lunch}
                                </span>
                                <%--<a href="#">赵府酒店正餐</a>--%>
                            </p>

                            <p><span>晚餐</span>
                                <span>
                                    ${dayVo.productRoute.supper}
                                </span>
                                <%--<a href="#">赵府酒店正餐</a>--%>
                            </p>
                        </div>
                        <div class="four">
                            <img src="<%=ctx%>/assets/css/product/img/jiudian.png"/>
                            <p>
                                <c:set var="hotelCount" value="0" />
                                <c:forEach items="${dayVo.productOptionsSupplierList}" var="scenic">
                                    <c:if test="${scenic.supplierType eq 3}"><c:set var="hotelCount" value="${hotelCount + 1}" /><span>${scenic.supplierName}</span></c:if>
                                </c:forEach>
                                <c:if test="${hotelCount eq 0}"><span>${dayVo.productRoute.hotelName}</span></c:if>
                            </p>
                        </div>
                        <div class="five">
                            <img src="<%=ctx%>/assets/css/product/img/jingdian.png"/>

                            <p>
                                <c:forEach items="${dayVo.productOptionsSupplierList}" var="scenic">
                                    <c:if test="${scenic.supplierType eq 5}"><span>${scenic.supplierName}</span></c:if>
                                </c:forEach>
                            </p>
                        </div>
                        <div class="six">
                            <div class="dengpao">
                                <img src="<%=ctx%>/assets/css/product/img/dengpao.png"/>

                                <p class="rich_text">${dayVo.productRoute.routeTip}</p>
                            </div>
                            <ul>
                                <c:forEach items="${dayVo.productAttachments}" var="img" varStatus="s">
                                    <li <c:if test="${!s.end}">class="mr-15"</c:if>><img src="${config.images200Url }${cf:thumbnail(img.path,'200x200')}"/>
                                        <p></p>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <div class="clear"></div>

        </div>


    </div>

    <div class="pri d_content" id="tabPrice">
        <div class="kehu">
            <div class="brand mt-10 mb-5">
                <div class="khlist">
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

        <div class="rilicontainer">
            <div id="divLeft" style="float:left; "></div>
            <div id="divRight" style="float: right; "></div>
            <div class="clear"></div>
        </div>

    </div>

    <div class="d_content" style="display: none;" id="tabRemark">
        <div class="beizhu">
            <div class="list">
                <h4><span>包含项目</span></h4>
                <p class="rich_text">${productRemark.itemInclude}</p>
            </div>
            <div class="list">
                <h4><span>不包含项目</span></h4>
                <p class="rich_text">${productRemark.itemExclude}</p>
            </div>
            <div class="list">
                <h4><span>注意事项</span></h4>
                <p class="rich_text">${productRemark.attention}</p>
            </div>
            <div class="list">
                <h4><span>温馨提示</span></h4>
                <p class="rich_text">${productRemark.warmTip}</p>
            </div>
            <div class="list">
                <h4><span>收客注意事项</span></h4>
                <p class="rich_text">${productRemark.guestNote}</p>
            </div>
            <div class="list">
                <h4><span>产品特色</span></h4>
                <p class="rich_text">${productRemark.productFeature}</p>
            </div>
            <div class="list">
                <h4><span>儿童安排</span></h4>
                <p class="rich_text">${productRemark.childPlan}</p>
            </div>
            <div class="list">
                <h4><span>购物安排</span></h4>
                <p class="rich_text">${productRemark.shoppingPlan}</p>
            </div>
            <div class="list">
                <h4><span>其他事项</span></h4>
                <p class="rich_text">${productRemark.itemOther}</p>
            </div>
            <div class="list">
                <h4><span>服务标准</span></h4>
                <p class="rich_text">${productRemark.serveLevel}</p>
            </div>
        </div>
    </div>
    <div id="download_layer" style="display: none;">
        <c:if test="${not empty productInfoVo.attachments }">
            <c:forEach items="${productInfoVo.attachments}" var="attachment" varStatus="s">
                <p style="margin: 5px; text-align: center; font-size: 15px;"><a href="javascript:void(0)" onclick="downloadFile('${config.imgServerUrl}${attachment.path}','${attachment.name}');">${attachment.name}</a></p>
            </c:forEach>
        </c:if>
    </div>
</div>
<div id="modeSelect" style="display: none; text-align: center; margin-top: 10px">
	<div style="margin-top: 10px">
		<a href="javascript:void(0)" onclick="goOrder(1)" id="confirmOrder"
			class="button button-primary button-small">确认订单</a>
		<br/>
	</div>
	<div style="margin-top: 30px">
		<a href="javascript:void(0)" onclick="goOrder(0)" id="reserveOrder" title="预留${reserve_hour}小时， 或库存小于${reserve_count}位后取消订单&#10;${reserve_remark}"
			class="button button-primary button-small">预留订单</a>
		<br/>
	</div>
</div>

</body>
<link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/js/zlDate/zlDate.css"/>
<script src="<%=ctx%>/assets/js/zlDate/zlDate.js"></script>
<script src="<%=ctx%>/assets/js/jquery.idTabs.min.js" type="text/javascript"></script>
<script src="<%=ctx%>/assets/js/jquery.autoScroll.js" type="text/javascript"></script>
<script src="<%=ctx%>/assets/js/web-js/product/product_detail.js"></script>
<script type="text/javascript">
    var path = '<%=path%>';
    var isReserve = ${isReserve};
    $(function(){

        $('.more_detail').on('click', function(){
            var text = $(this).parent().prev().html();
            var content = $(this).parent().parent().next().html();
            layer.open({
                type : 1,
                title : text,
                area : [ '550px', '300px' ],
                content : '<html><body><div class="p_container"><div class="p_container_sub"><dl class="p_paragraph_content"><dd><div class="dd_right" style="margin:0px 20px">'+content+'</div><div class="clear"></div></dd></dl></div></div></body></html>'
            });
        });

        //banner轮播图
        var cur=0;
        var $li=$("#banner_list li");
        var $btn=$("#banner_btn li");

        $li.eq(cur).fadeIn(800);
        play();

        $btn.hover(function(){
            clearTimeout(auto);
            $(this).addClass("sel").siblings().removeClass("sel");
            var index=$(this).index();
            $li.eq(index).fadeIn(800).siblings().hide();
        },function(){
            var index=$(this).index();
            cur=index;
            auto=setTimeout(play,3000);
        });

        function play(){
            $btn.eq(cur).addClass("sel").siblings().removeClass("sel");
            $li.eq(cur).fadeIn(800).siblings().hide();
            cur++;
            cur=cur>=$li.length?0:cur;
            auto=setTimeout(play,3000);
        }
    });


    (function(){
        $('.daysLabel').each(function(i){
            $(this).html('第' + new ChineseNumeric($(this).attr('day-num')).print() + '天');
        });
        $('.rich_text').each(function(){
            $(this).html($(this).html().replace(/\n/g,'<br/>'));
        });
//        $('.expand_text').each(function(){
//            var html = $(this).html();
//            if(html.length > 100){
//                $(this).html(html.substring(0,100) + '...');
//            }
//
//        });
    })();
</script>
</html>
