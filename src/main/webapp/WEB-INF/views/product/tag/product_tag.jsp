<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../../include/top.jsp" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>标签属性</title>
    <link href="<%=ctx%>/assets/css/product/product_label.css" rel="stylesheet"/>

    <script type="application/javascript">
        $(function () {
            var path = '<%=path%>';
            var tagForm = $('#product_tag');

            tagForm.validate({
                errorElement: 'div',
                errorClass: 'help-block',
                focusInvalid: true,
                rules: {},
                messages: {},
                submitHandler: function (form) {
                    var checks = tagForm.find('input:checkbox:checked');
                    var data = [];
                    checks.each(function (e) {
                        var select = this.value;
                        var span = $(this).parent().children('label').text();
                        var type = $(this).parent().prev().val();
                        data.push({"tagType": type, "tagId": select, "tagName": span});
                    });
                    $.ajax({
                        type: "post",
                        cache: false,
                        url: path + "/productInfo/tag/save.do",
                        data: {productTagVo: JSON.stringify({productId: ${productId}, productTags: data})},
                        dataType: "json",
                        success: function (data) {

                            if (data.success) {
                                $.success('操作成功');
                            } else {
                                $.error('操作失败');
                            }
                        },
                        error: function (data) {
                            $.error('请求失败');
                        }
                    });
                },
                success: function (e) {

                }
            });
        });
    </script>
</head>
<body>
<div class="p_container">
    <ul class="w_tab">
        <li><a href="<%=ctx %>/productInfo/edit.htm?productId=${productId}">基本信息</a></li>
        <%--<li><a href="<%=ctx %>/productInfo/route/view.htm?productId=${productId}">行程列表</a></li>--%>
        <li><a href="<%=ctx %>/productInfo/tag/view.htm?productId=${productId}" class="selected">标签属性</a></li>
        <li><a href="<%=ctx %>/productInfo/remark/view.htm?productId=${productId}">备注信息</a></li>
        <%--<li><a href="<%=ctx %>/productInfo/price/list.htm?productId=${productId }">价格设置</a></li>--%>
        <li class="clear"></li>
    </ul>
    <div class="p_container_sub">
        <form id="product_tag" class="form-horizontal" onsubmit="return false;" action="" method="post">
            <div class="w_biaoqianBox">
                <table cellspacing="0" cellpadding="0" class="w_tableLabel">
                    <col width="140px"/>
                    <tbody>
                    <tr>
                        <td><b>线路主题</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${lineThemeList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>线路等级</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${lineLevelList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>参团方式</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${attendMethodList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>酒店星级</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${hotelLevelList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>天数</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${daysPeriodList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>价格区间</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${priceRangeList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>出境目的地</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${exitDestinationList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                     <tr>
                        <td><b>国内目的地</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${domesticDestinationList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>类别</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${typeList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="w_btnSaveBox"><input type="submit" value="保存" class="btn_save"></div>
        </form>
    </div>
</div>
</body>
</html>