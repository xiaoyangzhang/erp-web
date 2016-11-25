<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String path = request.getContextPath();
%>
<script src="<%=path%>/assets/js/web-js/sales/airTicketResource.js"></script>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<%--<th style="width:10%">团号<i class="w_table_split"></i></th>--%>
			<th style="width: 6%">发团日期<i class="w_table_split"></i></th>
			<th style="width: 15%">推送商家<i class="w_table_split"></i></th>
			<th style="width: 5%">联系人<i class="w_table_split"></i></th>
			<th style="width: 5%">联系电话<i class="w_table_split"></i></th>
			<th style="width: 7%">人数<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<%--<th style="width:7%">创建时间<i class="w_table_split"></i></th>--%>
			<th style="width: 7%">操作<i class="w_table_split"></i> <a class="button button-rounded button-tinier" href="javascript:showImportSetting();">导入</a>
			</th>
		</tr>
	</thead>
	<tbody id="orderItems">
		<c:forEach items="${page.result}" var="gl" varStatus="v">
			<tr>
				<td>${v.count}</td>
				<%--<td style="text-align: left;"></td>--%>
				<td>${gl.departureDate}</td>
				<td>${gl.pushSupplierName}</td>
				<td>${gl.contactName}</td>
				<td>${gl.contactMobile}</td>
				<td>${gl.numAdult}大${gl.numChild}小${gl.numGuide}陪</td>
				<td style="text-align: left;">【${gl.productBrandName}】${gl.productName}</td>
				<%--<td>${gl.createTime}</td>--%>
				<td id="${gl.id}"><c:if test="${gl.state==0}">
						<input type="checkbox" onclick="selectChecked(this,'${gl.pushSupplierName}');" />
					</c:if> <c:if test="${gl.state!=0}">已导入</c:if></td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<div id="importSetting" style="display: none;">
	<form>
		<table>
			<tr>
				<td>销售计调 :</td>
				<td><input id="saleOperatorId" type="hidden" value="${curUser.employeeId}" /> <input id="saleOperatorName" value="${curUser.name}" readonly type="text"> <a href="javascript:void(0);" onclick="selectUser(1)">修改</a></td>
			</tr>
			<tr>
				<td>操作计调:</td>
				<td><input id="operatorId" type="hidden" value="${curUser.employeeId}"> <input id="operatorName" readonly value="${curUser.name}" type="text"> <a href="javascript:void(0);" onclick="selectUser(2)">修改</a></td>
			</tr>
			<tr>
				<td>客户名称：</td>
				<td><input id="supplierId" type="hidden" value="" /> <input id="supplierName" type="hidden" value="" /> <input class="IptText300" id="supplierName_t" type="text" value="" /> <a href="javascript:void(0);" onclick="selectSupplier();">请选择</a></td>
			</tr>
			<tr>
				<td>订单类型：</td>
				<td>散客：<input name="orderType" type="radio" value="0" checked /> 团队：<input name="orderType" type="radio" value="1" />
				</td>
			</tr>
		</table>
	</form>
</div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">
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
                //userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name）
                // ，mobile（手机）,phone（电话）,fax（传真）
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
            //参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
            content: getContextPath() + '/component/supplierList.htm?supplierType=1',
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
    
    var nameStr = "";
    var nameCount = 0;
    function selectChecked(obj, name) {
        if (obj.checked) {
            if (nameStr == "") {
                nameStr = name;
                nameCount++;
            }
            
            if (nameStr != name) {
                layer.alert("推送商家必须相同！");
                obj.checked = false;
            }
        } else {
            if (nameCount > 0) {
                nameCount--;
            }
        }
        
        if (nameCount == 0) {
            nameStr = "";
        }
    }
    
    function showImportSetting() {
        var items = $("#orderItems");
        var itemsChecked = items.find("input[type='checkbox']");
        var dataArray = [];
        itemsChecked.each(function () {
            if ($(this).attr("checked")) {
                dataArray.push($(this).parent().attr("id"));
            }
        });
        
        if (dataArray.length) {
            var $saleOperatorId = $("#saleOperatorId");
            var $saleOperatorName = $("#saleOperatorName");
            var $operatorId = $("#operatorId");
            var $operatorName = $("#operatorName");
            var $supplierId = $("#supplierId");
            var $supplierName = $("#supplierName");
            var $supplierName_t = $("#supplierName_t");
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
                        alert('请选择客户名称！');
                        return false;
                    }
                    
                    // 提交导入
                    $.ajax({
                        url: "<%=path%>/groupOrder/saveTransferOrder.do",
                        data: {
                            "orderIds": dataArray,
                            "saleOperatorId": $saleOperatorId.val(),
                            "saleOperatorName": $saleOperatorName.val(),
                            "operatorId": $operatorId.val(),
                            "operatorName": $operatorName.val(),
                            "supplierId": $supplierId.val(),
                            "supplierName": $supplierName.val(),
                            "orderType":$('input:radio[name=orderType]:checked').val()
                        },
                        dataType: "json",
                        type: "POST",
                        success: function (data) {
                        	layer.alert(data.msg);
                            
                            layer.close(index);
                            
                            searchBtn();
                            
                            // 清空选择
                            $supplierId.val('');
                            $supplierName.val('');
                            $supplierName_t.val('');
                        }
                    });
                },
                cancel: function (index) {
                    layer.close(index);
                }
            });
        } else {
            layer.alert("请选择要导入的数据！");
        }
        
    }
</script>