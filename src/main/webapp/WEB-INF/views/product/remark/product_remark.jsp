<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>备注信息</title>
    <%@ include file="../../../include/top.jsp" %>
    <link href="<%=ctx %>/assets/css/product/product_label.css" rel="stylesheet"/>
    <link href="<%=ctx %>/assets/css/buttons.css" rel="stylesheet"/>
</head>
<body>
<div class="p_container">
    <ul class="w_tab">
        <li><a href="<%=ctx %>/productInfo/edit.htm?productId=${productId}">基本信息</a></li>
        <%--<li><a href="<%=ctx %>/productInfo/route/view.htm?productId=${productId}">行程列表</a></li>--%>
        <li><a href="<%=ctx %>/productInfo/tag/view.htm?productId=${productId}">标签属性</a></li>
        <li><a href="<%=ctx %>/productInfo/remark/view.htm?productId=${productId}" class="selected">备注信息</a></li>
        <%--<li><a href="<%=ctx %>/productInfo/price/list.htm?productId=${productId }">价格设置</a></li>--%>
        <li class="clear"></li>
    </ul>
    <div id="remark" class="p_container_sub">
        <form id="queryForm" class="form-horizontal" action="<%=path%>/productInfo/remark/save.do" method="post">
            <input type="hidden" name="id" value="${productRemark.id}"/>
            <input type="hidden" name="productId" value="${productId}"/>

            <div class="w_remarksBox">
                <ul class="fixBarNav mt-15 ml-30">
                    <li class="on"><a href="#remarks1" lang="1">收客注意事项</a></li>
                    <li><a href="#remarks2" lang="2">产品特色</a></li>
                    <li><a href="#remarks3" lang="3">包含项目</a></li>
                    <li><a href="#remarks4" lang="4">不包含项目</a></li>
                    <li><a href="#remarks5" lang="5">儿童安排</a></li>
                    <li><a href="#remarks6" lang="6">购物安排</a></li>
                    <li><a href="#remarks7" lang="7">自费项目</a></li>
                    <li><a href="#remarks8" lang="8">赠送项目</a></li>
                    <li><a href="#remarks9" lang="9">用餐说明</a></li>
                    <li><a href="#remarks10" lang="10">酒店及备选</a></li>
                    <li><a href="#remarks11" lang="11">用车说明</a></li>
                    <li><a href="#remarks12" lang="12">导游说明</a></li>
                    <li><a href="#remarks13" lang="13">保险说明</a></li>
                    <li><a href="#remarks14" lang="14">门票说明</a></li>
                    <li><a href="#remarks15" lang="15">退改规则</a></li>
                    <li><a href="#remarks16" lang="16">预约规则</a></li>
                    <li><a href="#remarks17" lang="17">签证信息</a></li>
                    <li><a href="#remarks18" lang="18">注意事项</a></li>
                    <!-- <li><a href="#remarks11" lang="11">温馨提示</a></li>
                    <li><a href="#remarks13" lang="13">服务标准</a></li> -->
                </ul>
                <dl class="w_remarksMain fixNav_Content">
                    <dt id="remarks1"><b>收客注意事项</b></dt>
                    <dd>
                        <textarea id="guestNote" class="w_textarea"
                                  name="guestNote">${productRemark.guestNote}</textarea>
                    </dd>
                    <dt id="remarks2"><b>产品特色</b></dt>
                    <dd>
                        <textarea id="productFeature" class="w_textarea"
                                  name="productFeature">${productRemark.productFeature}</textarea>
                    </dd>
                    <dt id="remarks3"><b>包含项目</b></dt>
                    <dd>
                        <textarea id="itemInclude" class="w_textarea"
                                  name="itemInclude">${productRemark.itemInclude}</textarea>
                    </dd>
                    <dt id="remarks4"><b>不包含项目</b></dt>
                    <dd>
                        <textarea id="itemExclude" class="w_textarea"
                                  name="itemExclude">${productRemark.itemExclude}</textarea>
                    </dd>
                    <dt id="remarks5"><b>儿童安排</b></dt>
                    <dd>
                        <textarea id="childPlan" class="w_textarea"
                                  name="childPlan">${productRemark.childPlan}</textarea>
                    </dd>
                    <dt id="remarks6"><b>购物安排</b></dt>
                    <dd>
                        <textarea id="shoppingPlan" class="w_textarea"
                                  name="shoppingPlan">${productRemark.shoppingPlan}</textarea>
                    </dd>
                    <dt id="remarks7"><b>自费项目</b></dt>
                    <dd>
                        <textarea id="itemCharge" class="w_textarea"
                                  name="itemCharge">${productRemark.itemCharge}</textarea>
                    </dd>
                    <dt id="remarks8"><b>赠送项目</b></dt>
                    <dd>
                        <textarea id="itemFree" class="w_textarea" name="itemFree">${productRemark.itemFree}</textarea>
                    </dd>
                    <dt id="remarks9"><b>用餐说明</b></dt>
                    <dd>
                        <textarea id="eatNote" class="w_textarea" name="eatNote">${productRemark.eatNote}</textarea>
                    </dd>
                    <dt id="remarks10"><b>酒店及备选</b></dt>
                    <dd>
                        <textarea id="itemOther" class="w_textarea" name="itemOther">${productRemark.itemOther}</textarea>
                    </dd>
                    <dt id="remarks11"><b>用车说明</b></dt>
                    <dd>
                        <textarea id="carNote" class="w_textarea" name="carNote">${productRemark.carNote}</textarea>
                    </dd>
                    <dt id="remarks12"><b>导游说明</b></dt>
                    <dd>
                        <textarea id="guideNote" class="w_textarea" name="guideNote">${productRemark.guideNote}</textarea>
                    </dd>
                    <dt id="remarks13"><b>保险说明</b></dt>
                    <dd>
                        <textarea id="insuranceNote" class="w_textarea" name="insuranceNote">${productRemark.insuranceNote}</textarea>
                    </dd>
                    <dt id="remarks14"><b>门票说明</b></dt>
                    <dd>
                        <textarea id="sightNote" class="w_textarea" name="sightNote">${productRemark.sightNote}</textarea>
                    </dd>
                    <dt id="remarks15"><b>退改规则</b></dt>
                    <dd>
                        <textarea id="refundRule" class="w_textarea" name="refundRule">${productRemark.refundRule}</textarea>
                    </dd>
                    <dt id="remarks16"><b>预约规则</b></dt>
                    <dd>
                        <textarea id="appointRule" class="w_textarea" name="appointRule">${productRemark.appointRule}</textarea>
                    </dd>
                    <dt id="remarks17"><b>签证信息</b></dt>
                    <dd>
                        <textarea id="passort" class="w_textarea" name="passort">${productRemark.passort}</textarea>
                    </dd>
                    <dt id="remarks18"><b>注意事项</b></dt>
                    <dd>
                        <textarea id="attention" class="w_textarea"
                                  name="attention">${productRemark.attention}</textarea>
                    </dd>
                   <%--  <dt id="remarks10"><b>其他事项</b></dt>
                    <dd>
                        <textarea id="itemOther" class="w_textarea"
                                  name="itemOther">${productRemark.itemOther}</textarea>
                    </dd>
                    <dt id="remarks12"><b>签证信息</b></dt>
                    <dd>
                        <textarea id="passort" class="w_textarea" name="passort">${productRemark.passort}</textarea>
                    </dd>
                    <dt id="remarks13"><b>服务标准</b></dt>
                    <dd>
                        <textarea id="serveLevel" class="w_textarea" name="serveLevel">${productRemark.serveLevel}</textarea>
                    </dd> --%>
                </dl>
            </div>
            <div class="w_btnSaveBox"><input type="button" id="saveBtn" value="保存" class="btn_save"></div>
        </form>
    </div>
</div>
<script src="<%=ctx%>/assets/js/jquery.autoTextarea.js"></script>
<script src="<%=ctx%>/assets/js/jquery.autoScroll.js"></script>
<script type="text/javascript">
    $(function () {
        //左侧滚动条
        $("#fixBarNav").autoScroll();

        $("textarea").click(function () {
            var id = $(this).parent().prev().attr("id");
            $(".fixBarNav a[href='#" + id + "']").parent().addClass("on").siblings().removeClass("on");
        });

        $('#saveBtn').on('click', function(){
            $(this).unbind('click');
            $.success('操作成功', function(){
                $('#queryForm').submit();
            });
        });

    });
</script>
</body>
</html>