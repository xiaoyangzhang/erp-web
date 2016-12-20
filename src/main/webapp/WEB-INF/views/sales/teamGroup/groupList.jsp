<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String path = request.getContextPath();
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>团队列表</title>
    <%@ include file="../../../include/top.jsp" %>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>

    <link rel="stylesheet" href="<%=ctx%>/assets/js/jqgrid/css/ui.jqgrid.css">
    <script src="<%=ctx%>/assets/js/jqgrid/js/i18n/grid.locale-cn.js"></script>
    <script src="<%=ctx%>/assets/js/jqgrid/js/jquery.jqGrid.min.js"></script>


</head>
<body>

<div class="p_container">
    <form method="post" id="tourGroupForm">
        <div class="p_container_sub">
            <div class="searchRow">
                <input type="hidden" name="page" id="page"　value="${pageBean.page }"/>
                <input type="hidden" name="pageSize" id="pageSize"　value="${pageBean.pageSize }"/>
                <ul>
                    <li class="text">
                        <select name="dateType" id="dateType">
                            <option value="1">出团日期</option>
                            <option value="2">输单日期</option>
                        </select>
                    </li>
                    <li><input type="text" id="tourGroupStartTime" name="startTime" class="Wdate"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=""/>~
                        <input type="text" id="tourGroupEndTime" name="endTime" class="Wdate"
                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=""/></li>
                    <li class="text"> 团号:</li>
                    <li><input type="text" name="tourGroup.groupCode" id="tourGroupGroupCode"
                               value="${groupOrder.tourGroup.groupCode}"/></li>
                    <li class="text"> 组团社:</li>
                    <li><input type="text" name="supplierName" id="supplierName" value="${groupOrder.supplierName}"/>
                    </li>
                    <li class="text"> 客源地:</li>
                    <li><select name="provinceId" id="provinceCode">
                        <option value="-1">请选择省</option>
                        <c:forEach items="${allProvince }" var="province">
                            <option value="${province.id }" <c:if
                                    test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
                        </c:forEach>
                    </select>
                        <select name="cityId" id="cityCode">
                            <option value="-1">请选择市</option>
                            <c:forEach items="${allCity }" var="city">
                                <option value="${city.id }" <c:if
                                        test="${groupOrder.cityId==city.id  }"> selected="selected" </c:if>>${city.name }</option>
                            </c:forEach>
                        </select>
                        <select name="sourceTypeId" id="sourceTypeId">
                            <option value="-1">客源类别</option>
                            <c:forEach items="${sourceTypeList }" var="source">
                                <option value="${source.id }">${source.value}</option>
                            </c:forEach>
                        </select>
                    </li>
                    <li class="clear"/>
                </ul>

                <ul>
                    <li class="text"> 部门:</li>
                    <li>
                        <input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }"
                               readonly="readonly" onclick="showOrg()" style="width:181px;"/>
                    </li>
                    <li class="text">
                        <select name="operType" id="operType">
                            <option value="1" <c:if test="${groupOrder.operType==1 }">selected="selected"</c:if>>销售
                            </option>
                            <option value="2" <c:if test="${groupOrder.operType==2 }">selected="selected"</c:if>>计调
                            </option>
                            <option value="3" <c:if test="${groupOrder.operType==3 }">selected="selected"</c:if>>输单
                            </option>
                        </select>
                    </li>
                    <li>
                        <input type="text" name="saleOperatorName" id="saleOperatorName"
                               value="${groupOrder.saleOperatorName}" stag="userNames" readonly="readonly"
                               onclick="showUser()"/>
                        <input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden"
                               value="${groupOrder.saleOperatorIds}"/>
                        <input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden"
                               value=""/>
                    </li>
                    <li class="text"> 产品:</li>
                    <li>
                        <input type="text" name="tourGroup.productName" id="tourGroupProductName"
                               value="${groupOrder.tourGroup.productName}"/>
                    </li>
                    <li class="text">状态:</li>
                    <li>
                        <select name="tourState" id="tourState">
                            <option value="">团状态</option>
                            <option value="0">未确认</option>
                            <option value="1">已确认</option>
                            <option value="2">已废弃</option>
                            <option value="3">已审核</option>
                            <option value="4">已封存</option>
                        </select>
                        <select name="orderLockState" id="orderLockState">
                            <option value="">锁单状态</option>
                            <option value="1">已锁单</option>
                            <option value="0">未锁单</option>
                        </select>
                    </li>
                    <li class="text"></li>
                    <li>
                        <button type="button" onclick="searchBtn()" class="button button-primary button-small">查询
                        </button>
                        <button type="button" class="button button-primary button-small"
                                onclick="newWindow('新增团订单','teamGroup/toAddTeamGroupInfo.htm')">新增
                        </button>
                    <li class="clear"/>
                </ul>
            </div>
        </div>
    </form>
</div>

<%--<dl class="p_paragraph_content">
	<div id="content"></div>
</dl>--%>

<!-- JqGrid  -->
<div class="p_container">
    <div class="jqGrid_guest">
        <table id="groupProfitTable"></table>
        <div id="groupProfitPage"></div>
    </div>
</div>

<script src="<%=ctx%>/assets/js/moment.js"></script>
<script src="<%=ctx%>/assets/js/accounting.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
<!-- 改变状态 -->
<div id="stateModal" style="display: none">
    <input type="hidden" name="id" id="modalgroupId" />
    <dl class="p_paragraph_content">
        <dd>
            <div class="dd_left">状态:</div>
            <div class="dd_right">
                <select name="groupState" id="modalGroupState">
                    <option value="0">未确认</option>
                    <option value="1">已确认</option>
                    <option value="2">废弃</option>
                </select>
            </div>
            <div class="clear"></div>
        </dd>
    </dl>
    <div class="w_btnSaveBox" style="text-align: center;">
        <button type="button" class="button button-primary button-small" onclick="editOrderGroupInfo()">确定</button>
    </div>
</div>
<div id="exportWord" style="display: none;text-align: center;margin-top: 10px">
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="saleOrder" class="button button-primary button-small">确认单</a>
    </div>
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="saleCharge" class="button button-primary button-small">结算单</a>
    </div>
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="saleOrderNoRoute" class="button button-primary button-small">确认单-无行程</a>
    </div>
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="saleChargeNoRoute" class="button button-primary button-small">结算单-无行程</a>
    </div>
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="tddyd" class="button button-primary button-small">导游行程单</a>
    </div>
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="guestNames" class="button button-primary button-small">客人名单</a>
    </div>
    <div style="margin-top: 10px">
        <a href="" target="_blank" id="ykyjfkd" class="button button-primary button-small">游客反馈意见单</a>
    </div>
</div>
</html>
