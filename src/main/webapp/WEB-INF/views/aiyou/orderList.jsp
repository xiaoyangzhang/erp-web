<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>爱游订单列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <script src="<%=staticPath %>/assets/js/web-js/sales/airTicketResource.js"></script>
    <style>
        .searchRow li.text {
            margin-right: 3px;
        }

        .searchRow li.seperator {
            width: 20px;
        }

        .searchRow li input {
            width: 90px;
        }

        #importSetting p {
            line-height: 26px;
            padding: 5px;
        }

        button.disable {
            background-color: #d7d7d7 !important;
            color: #f0f0f0 !important;
        }
    </style>
</head>
<body>
<div class="p_container">
    <!-- 过滤栏   START -->
    <div class="p_container_sub">
        <div class="searchRow">
            <form id="searchResourceForm">
                <ul>
                    <li style="width:60px;">发团日期:</li>
                    <li><input name="startDate" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                               value="${startDate }"/>
                        —
                        <input name="endDate" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                               value="${endDate }"/>
                    </li>

                    <li class="text">地接社：</li>
                    <li>
                        <select id="code">
                            <option value="KMLSLXS" <c:if test="${code=='KMLSLXS' }">selected</c:if>>昆明乐途旅行社有限公司
                            </option>
                            <option value="YNYMGJLYGMZX" <c:if test="${code=='YNYMGJLYGMZX' }">selected</c:if>>
                                公民中心签证部
                            </option>
                            <option value="SCZHB" <c:if test="${code=='SCZHB' }">selected</c:if>>爱游市场综合部</option>
                        </select>
                    </li>
                    <li class="text">平台来源：</li>
                    <li>
                        <select id="port">
                            <option value="AY" <c:if test="${port=='AY' }">selected</c:if>>爱游</option>
                            <option value="YM" <c:if test="${port=='YM' }">selected</c:if>>怡美</option>
                            <option value="JY" <c:if test="${port=='JY' }">selected</c:if>> 景怡</option>
                            <option value="TX" <c:if test="${port=='TX' }">selected</c:if>>天翔</option>
                            <option value="OUTSIDE" <c:if test="${port=='OUTSIDE' }">selected</c:if>>出境</option>
                        </select>
                    </li>
                    <li class="text">团号：</li>
                    <li>
                        <input id="group_num" type="text" value="${groupNum}"/>
                    </li>
                    <li style="margin-left:20px;">
                        <a href="javascript:searchBtn();" class="button button-primary button-small">查询</a>
                    </li>
                    <li class="clear"></li>
                </ul>
            </form>
        </div>
    </div>
    <!-- 过滤栏  END  -->

    <!-- 列表 START -->
    <div id="orderList">
        <table cellspacing="0" cellpadding="0" class="w_table" style="min-width:980px;">
            <thead>
            <tr>
                <th width="150">爱游团号<i class="w_table_split"></i></th>
                <th width="90">发团日期<i class="w_table_split"></i></th>
                <th width="500">爱游产品名称<i class="w_table_split"></i></th>
                <th width="50">来源<i class="w_table_split"></i></th>
                <th width="80">联系人<i class="w_table_split"></i></th>
                <th width="100">人数<i class="w_table_split"></i></th>
                <th width="80">操作<i class="w_table_split"></i>
                    <a class="button button-rounded button-tinier"
                       href="javascript:showImportSetting('${order.group_id}','${order.supplierCode}', '${order.date}', '${order.adult_num}大<c:if test="${order.child_num>0}">${order.child_num}小</c:if>', ${order.adult_num+order.child_num}, '${order.product_name}')">导入</a>
                </th>
            </tr>
            </thead>
            <tbody id="orderItems">
            <c:forEach items="${aiyouOrderList}" var="order" varStatus="status">
                <tr id="${order.group_id}">
                    <td>${order.group_num}</td>
                    <td>${order.date}</td>
                    <td>${order.product_name}</td>
                    <td>${order.supplierCode}</td>
                    <td>${order.reseller_contact_name }</td>
                    <td>${order.adult_num}大<c:if test="${order.child_num>0}">${order.child_num}小</c:if></td>
                    <td>
                        <c:if test="${order.isImport!=1}">
                            <input type="checkbox"/>
                        </c:if>
                        <c:if test="${order.isImport==1}">已导入</c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="importSetting" style="display:none;">
        <form>
            <table>
                <tr>
                    <td>销售计调 :</td>
                    <td>
                        <input id="saleOperatorId"
                               type="hidden" value="${curUser.employeeId}"/>
                        <input id="saleOperatorName" value="${curUser.name}" readonly
                               type="text">
                        <a href="javascript:void(0);" onclick="selectUser(1)">修改</a>
                    </td>
                </tr>
                <tr>
                    <td>操作计调:</td>
                    <td>
                        <input id="operatorId" type="hidden" value="${curUser.employeeId}">
                        <input id="operatorName" readonly value="${curUser.name}"
                               type="text">
                        <a href="javascript:void(0);" onclick="selectUser(2)">修改</a>
                    </td>
                </tr>
                <tr>
                    <td>组团社名称：</td>
                    <td>
                        <input id="supplierId" type="hidden" value=""/>
                        <input id="supplierName" type="hidden" value=""/>
                        <input class="IptText300" id="supplierName_t" type="text" value=""/>
                        <a href="javascript:void(0)" onclick="selectSupplier();">请选择</a>
                    </td>
                </tr>
                <tr>
                    <td>产品名称：</td>
                    <td>
                        <input id="productBrandId" type="hidden" value=""/>
                        <input id="productBrandName" type="text" value=""/>
                        ~
                        <input id="productId" type="hidden" value=""/>
                        <input id="productName" type="text" value=""
                               style="width: 300px"/>
                        <a href="javascript:void(0);" onclick="importRoute();">选择产品</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
</body>

<script>

    /**
     * 选择产品
     */
    function importRoute() {

        var win;
        layer.open({
            type: 2,
            title: '导入行程',
            shadeClose: true,
            shade: 0.5,
            area: ['680px', '480px'],
            content: '../route/list.htm?state=2',
            btn: ['确定', '取消'],
            success: function (layero, index) {
                win = window[layero.find('iframe')[0]['name']];
            },
            yes: function (index) {
                layer.close(index);
                /**
                 * 给基本信息赋值
                 */
                $.getJSON('../productInfo/getProductInfo.do?productId=' + $("#productId").val(), function (data) {
                    $("#productBrandId").val(data.brandId);
                    $("#productBrandName").val(data.brandName);
                    $("#productName").val(data.nameCity);
                });
            }, cancel: function (index) {
                layer.close(index);
            }
        });
    }

    var supplierNameComplete = {
        source: function (request, response) {
            var keyword = request.term;
            $.ajax({
                type: "post",
                url: "<%=path%>/tourGroup/getSupplierName",
                data: {
                    supplierType: 1,
                    keyword: keyword
                },
                dataType: "json",
                success: function (data) {
                    if (data && data.success == 'true') {
                        response($.map(data.result, function (v) {
                            return {label: v.nameFull, id: v.id};
                        }));
                    }
                },
                error: function (data, msg) {
                }
            });
        },
        focus: function (event, ui) {
        },
        minLength: 0,
        delay: 300

    };

    $(function () {
        //组团社
        supplierNameComplete.select = function (event, v) {
            $("#supplierName").val(v.item.label);
            $("#supplierName_t").val(v.item.label);
            $("#supplierId").val(v.item.id);
        };
        $("#supplierName").autocomplete(supplierNameComplete);
        $("#supplierName").click(function () {
            $(this).trigger(eKeyDown);
        });
        $("#supplierName_t").autocomplete(supplierNameComplete);
        $("#supplierName_t").click(function () {
            $(this).trigger(eKeyDown);
        });
    });

    function showImportSetting() {
        var items = $("#orderItems");
        var itemsChecked = items.find("input[type='checkbox']");
        var dataArray = [];
        itemsChecked.each(function () {
            if ($(this).attr("checked")) {
                dataArray.push($(this).parent().parent().attr("id"));
            }
        });

        var $code = $("#code");
        var $port = $("#port");
        var $saleOperatorId = $("#saleOperatorId");
        var $saleOperatorName = $("#saleOperatorName");
        var $operatorId = $("#operatorId");
        var $operatorName = $("#operatorName");
        var $supplierId = $("#supplierId");
        var $supplierName = $("#supplierName");
        var $supplierName_t = $('#supplierName_t');
        var $productBrandId = $('#productBrandId');
        var $productBrandName = $('#productBrandName');
        var $productId = $('#productId');
        var $productName = $('#productName');

        if (dataArray.length) {
            layer.open({
                type: 1,
                title: '导入订单',
                closeBtn: false,
                area: ['600px', '300px'],
                shadeClose: false,
                content: $('#importSetting'),
                btn: ['确认', '取消'],
                yes: function (index) {

                    if ($supplierName_t.val() == '') {
                        alert('请选择组团社！');
                        return;
                    }

                    if ($productBrandName.val() == '' || $productName.val() == '') {
                        alert('请选择产品！');
                        return;
                    }

                    // 提交导入
                    $.ajax({
                        url: "<%=path%>/aiyou/saveAiYouData.do",
                        data: {
                            "code": $code.val(),
                            "port": $port.val(),
                            "bIds": dataArray,
                            "saleOperatorId": $saleOperatorId.val(),
                            "saleOperatorName": $saleOperatorName.val(),
                            "operatorId": $operatorId.val(),
                            "operatorName": $operatorName.val(),
                            "supplierId": $supplierId.val(),
                            "supplierName": $supplierName.val(),
                            "productBrandId": $productBrandId.val(),
                            "productBrandName": $productBrandName.val(),
                            "productId": $productId.val(),
                            "productName": $productName.val()
                        },
                        dataType: "json",
                        type: "POST",
                        success: function (data) {
                            alert(data.msg);

                            layer.close(index);

                            searchBtn();

                            // 清空选择
                             $supplierId.val('');
                             $supplierName.val('');
                             $supplierName_t.val('');
                             $productBrandId.val('');
                             $productBrandName.val('');
                             $productId.val('');
                             $productName.val('');
                        }
                    });
                },
                cancel: function (index) {
                    layer.close(index);
                }
            });
        } else {
            alert("请选择要导入的数据！");
        }
    }

    function searchBtn() {
        var startDate = $("input[name='startDate']").val();
        var endDate = $("input[name='endDate']").val();
        var code = $("#code").val();
        var port = $("#port").val();
        var groupNum = $("#group_num").val();
        window.location.href = "<%=path%>/aiyou/toAiYouOrderList.htm?code=" + code
                + "&port=" + port + "&startDate=" + startDate + "&endDate=" + endDate + "&groupNum=" + groupNum;
    }

    /**
     * 页面选择部分调用函数(单选)
     */
    function selectUser(num) {
        var win = 0;
        layer.open({
            type: 2,
            title: '选择人员',
            shadeClose: true,
            shade: 0.5,
            area: ['400px', '470px'],
            content: '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
            btn: ['确定', '取消'],
            success: function (layero, index) {
                win = window[layero.find('iframe')[0]['name']];
            },
            yes: function (index) {
                //userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
                var userArr = win.getUserList();
                if (userArr.length == 0) {
                    $.warn("请选择人员");
                    return false;
                }
                //销售计调
                if (num == 1) {
                    $("#saleOperatorId").val(userArr[0].id);
                    $("#saleOperatorName").val(userArr[0].name);
                }
                //操作计调
                if (num == 2) {
                    $("#operatorId").val(userArr[0].id);
                    $("#operatorName").val(userArr[0].name);
                }
                //一般设定yes回调，必须进行手工关闭
                layer.close(index);
            }, cancel: function (index) {
                layer.close(index);
            }
        });
    }
    /** * 选择组团社 */
    function selectSupplier() {
        layer.openSupplierLayer({
            title: '选择组团社',
            content: getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
            callback: function (arr) {
                if (arr.length == 0) {
                    $.warn("请选组团社");
                    return false;
                }
                $("#supplierName").val(arr[0].name);
                $("#supplierName_t").val(arr[0].name);
                $("#supplierId").val(arr[0].id);
            }
        });
    }
</script>
</html>