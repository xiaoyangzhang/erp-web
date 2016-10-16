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
    <title>新增产品_价格设置</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link href="<%=ctx %>/assets/css/product/product_price.css" rel="stylesheet"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_price.js"></script>
</head>
<body>
<div class="p_container">
    <%-- <ul class="w_tab">        
	    	<li><a href="../price/list.htm?productId=${productId }" class="selected">价格设置</a></li>
        <li class="clear"></li>
    </ul> --%>
    <div class="p_container_sub" id="tab1">
        <p class="p_paragraph_title"><b>价格组列表</b></p>
        <a href="addprice_list.htm?groupId=${groupId }&productId=${productId }"
           class="button button-primary button-rounded button-small mt-20 ml-20">+ 新增 / 编辑团期</a>
        <a href="javascript:void(0)" id="batch_delete" class="blue ml-20">批量删除</a>
        <a href="javascript:void(0)" onclick="copyPrice(${productId },${groupId })"
           class="button button-primary button-rounded button-small mt-20 ml-20">复制团期</a>
        <a href="product_limit.html" class="button button-caution button-rounded button-small ml-50"
           style="display: none;">买卖限制设置</a>
        <a href="../price/list.htm?productId=${productId }" class="button button-primary button-rounded button-small ml-50">返回</a>
        <dl class="p_paragraph_content">
            <dd>
                <div class="dd_right" style="width:80%">
                    <ul class="priceCalandar_List">
                        <li class="li_year">
                            <input type="button" value="" class="left"><label class="year">2015</label><input
                                type="button" value="" class="right">
                        </li>
                        <li><a href="#" lang="1" class="on">1</a></li>
                        <li><a href="#" lang="2">2</a></li>
                        <li><a href="#" lang="3">3</a></li>
                        <li><a href="#" lang="4">4</a></li>
                        <li><a href="#" lang="5">5</a></li>
                        <li><a href="#" lang="6">6</a></li>
                        <li><a href="#" lang="7">7</a></li>
                        <li><a href="#" lang="8">8</a></li>
                        <li><a href="#" lang="9">9</a></li>
                        <li><a href="#" lang="10">10</a></li>
                        <li><a href="#" lang="11">11</a></li>
                        <li><a href="#" lang="12">12</a></li>
                    </ul>
                    <table cellspacing="0" cellpadding="0" class="w_table ml-20" border="1">
                        <col width="3%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <col width="11%"/>
                        <tbody>
                        <tr>
                            <td rowspan="2"><input type="checkbox" id="tbChk" /></td>
                            <td rowspan="2" id="current_month"></td>
                            <td colspan="3">建议售价</td>
                            <td colspan="3">结算价</td>
                            <td rowspan="2">截止报名</td>
                            <td rowspan="2">操作</td>
                        </tr>
                        <tr class="trHead">
                            <td>成人价</td>
                            <td>儿童价</td>
                            <td>单间差</td>
                            <td>成人价</td>
                            <td>儿童价</td>
                            <td>单间差</td>
                        </tr>

                        </tbody>
                    </table>
                </div>
                <div class="clear"></div>
            </dd>
        </dl>

        <p class="p_paragraph_title"><b>可选项目</b></p>
        <a href="javascript:void(0)" id="addExtra" class="button button-primary button-rounded button-small mt-20 ml-20">+ 添加</a>
        <dl class="p_paragraph_content">
            <dd>
                <div class="dd_right" style="width:80%">
                    <table cellspacing="0" cellpadding="0" border="1" class="w_table ml-20">
                        <col width="10%"/>
                        <col width="30%"/>
                        <col width="15%"/>
                        <col width="15%"/>
                        <col width="15%"/>
                        <col width="15%"/>
                        <thead>
                        <tr>
                            <th>序号</th>
                            <th>项目</th>
                            <th>备注</th>
                            <th>单价</th>
                            <th>成本价</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="extra_table">
                        <c:forEach items="${productGroupExtraItems}" var="extra" varStatus="s">
                            <tr>
                                <td>${s.index + 1}</td>
                                <td>${extra.itemName}</td>
                                <td>${extra.remark}</td>
                                <td>${extra.priceSale}</td>
                                <td>${extra.priceCost}</td>
                                <td>
                                    <a id-value="${extra.id}" class="def extra_edit" href="javascript:void(0)">修改</a>
                                    <a id-value="${extra.id}" class="def extra_delete" href="javascript:void(0)">删除</a>
                                </td>
                            </tr>
                        </c:forEach>

                        <%--<tr>--%>
                            <%--<td>2</td>--%>
                            <%--<td>安吉乐酒店内60分钟按摩一次</td>--%>
                            <%--<td>这是一条备注</td>--%>
                            <%--<td>998</td>--%>
                            <%--<td></td>--%>
                            <%--<td>--%>
                                <%--<a class="mr-10 blue" href="#">修改</a>--%>
                                <%--<a class="mr-10 blue" href="#">删除</a>--%>
                            <%--</td>--%>
                        <%--</tr>--%>
                        </tbody>
                    </table>
                </div>
                <div class="clear"></div>
            </dd>
        </dl>

    </div>

</div>
<!-- end -->

</body>
<script type="text/javascript">
    var path = '<%=path%>';
    var groupId = '${groupId }';
    var productId ='${productId }';
    var extraList = [];
    $(document).ready(function () {
        $.ajax({
            type: "post",
            cache: false,
            url: path + "/productInfo/price/extraDic.do",
            dataType: 'json',
            async: false,
            success: function (data) {
                extraList = data;
            },
            error: function (data) {
                $.error('请求失败');
            }
        });
    });

    function copyPrice(productId,groupId){
    	showInfo("复制价格","400px","250px","<%=ctx%>/productInfo/price/copyPrice.htm?groupId="+groupId);
    }
    
    function showInfo(title,width,height,url){
     	layer.open({ 
     		type : 2,
     		title : title,
     		shadeClose : true,
     		shade : 0.5,
     		area : [width,height],
     		content : url
     	});
     }
</script>
</html>
