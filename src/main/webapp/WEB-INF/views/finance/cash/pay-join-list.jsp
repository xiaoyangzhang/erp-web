<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>选择供应商</title>
	<%@ include file="../../../include/top.jsp" %>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	<SCRIPT type="text/javascript">

		function checkAll(ckbox) {
			if ($(ckbox).attr("checked")) {
				$("input[type='checkbox']").each(function () {
					if (!$(this).attr("disabled") && $(this).attr('id') != 'cbAmounts') {
						$(this).attr("checked", 'checked');
					}
				});
			} else {
				$("input[type='checkbox']").removeAttr("checked");
			}
			$("input[type='checkbox']").trigger("onchange");
		}

		function chk(obj, id, name) {
			var itemAmounts = $(obj).parent().parent().find("label[id='itemAmounts']");

			if ($(obj).is(':checked')) {
				$("#ulSel").append("<li sid='" + id + "'>" + name + "<span class='pop_check_del'></span></li>");

				// 下账金额
				if (itemAmounts.html() == 0) {
					itemAmounts.html($(obj).parent().parent().find("input[name='itemBalance']").val());
				}

				bindEvent();
			} else {
				liRemove(id);
				itemAmounts.html(0); // 单行未选中 下账金额修改为0
			}

			calcuCheckSum();
		}

		function bindEvent() {
			$("#ulSel").find(".pop_check_del").each(function () {
				$(this).unbind("click").bind("click", function () {
					var sid = $(this).parent().attr("sid");
					//删除li
					$(this).parent().remove();
					//table中checkbox取消选中
					chkboxRemove(sid);
				})
			})
		}

		function calcuCheckSum() {
			var checkSumTotal = 0;
			$("input[name='itemTotal']").each(function (i, o) {
				var checkBox = $(o).parent().parent().find("input[type='checkbox']");
				if ($(checkBox).attr('checked')) {
					checkSumTotal += parseFloat(o.value);
				}
			});

			$("#checkSumTotal").text(checkSumTotal);

			var checkSumTotalCash = 0;
			$("input[name='itemTotalCash']").each(function (i, o) {
				var checkBox = $(o).parent().parent().find("input[type='checkbox']");
				if ($(checkBox).is(':checked')) {
					checkSumTotalCash += parseFloat(o.value);
				}
			});
			$("#checkSumTotalCash").text(checkSumTotalCash);

			var checkSumBalance = 0;
			$("input[name='itemBalance']").each(function (i, o) {
				var checkBox = $(o).parent().parent().find("input[type='checkbox']");
				if ($(checkBox).is(':checked')) {
					checkSumBalance += parseFloat(o.value);
				}
			});
			$("#checkSumBalance").html(Math.round(parseFloat(checkSumBalance) * 100) / 100);

			// 下账金额合计
			var checkSumAmounts = 0;
			$("label[id='itemAmounts']").each(function (i, o) {
				var checkBox = $(o).parent().parent().find("input[type='checkbox']");
				if ($(checkBox).is(':checked')) {
					checkSumAmounts += parseFloat(o.innerHTML);
				}
			});
			$("#checkSumAmounts").html(Math.round(parseFloat(checkSumAmounts) * 100) / 100);
			$("#sumAmounts").html(Math.round(parseFloat(checkSumAmounts) * 100) / 100);
		}

		function chkboxRemove(id) {
			$(".w_table").find("input[type='checkbox'][sid='" + id + "']").removeAttr("checked");
		}

		function liRemove(id) {
			$("#ulSel").find("li[sid='" + id + "']").remove();
		}

		function getChecked() {
			var arr = [];
			$("#ulSel").find("li").each(function () {
				arr.push($(this).attr("sid"));
			})
			return arr;
		}

		function queryList(page, pagesize) {
			if (!page || page < 1) {
				page = 1;
			}
			if (!pagesize || pagesize < 5) {
				pagesize = 5;
			}
			$("#page").val(page);
			$("#pageSize").val(pagesize);

			var options = {
				url: "../common/queryListPage.htm",
				type: "post",
				dataType: "html",
				success: function (data) {
					$("#tableDiv").html(data);
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					$.error("服务忙，请稍后再试");
				}
			}
			$("#queryForm").ajaxSubmit(options);
		}

		$(function () {
			function setData() {
				var curDate = new Date();
				var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
				$("#startMin").val(startTime);
				var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
				var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
				var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
				$("#startMax").val(endTime);
			}

			setData();
//queryList();


		});

		function searchBtn() {
			queryList(1, $("#pageSize").val());
		}

		$(function () {
			queryList();
		});

		function getAmountsValue() {
			var dataObj = [];

			$('#tbObj tr').each(function () {
				var checkboxObj = $(this).find("input[type='checkbox']");
				var itemAmountsObj = $(this).find("label[id='itemAmounts']");

				if (checkboxObj.is(':checked')) {
					var data = {};
					data.sid = checkboxObj.attr('sid');
					data.itemAmounts = itemAmountsObj.html();
					dataObj.push(data);
				}
			});
			return dataObj;
		}
	</SCRIPT>
</head>
<body>
<div class="p_container">
	<div id="divCenter" style="float:left;width:800px;height:400px;">
		<form id="queryForm">
			<input type="hidden" name="page" id="page"/>
			<input type="hidden" name="pageSize" id="pageSize"/>
			<input type="hidden" name="sl" value="fin.selectPayListPage"/>
			<input type="hidden" name="rp" value="finance/cash/pay-join-list-table"/>

			<input type="hidden" name="supplierId" value="${reqpm.supplierId}"/>
			<input type="hidden" name="supType" value="${reqpm.supType}"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" style="width:100px;">
							<select name="dateType">
								<option value="groupDate">团出发日期</option>
								<option value="orderDate">订单日期</option>
							</select>
						</li>
						<li>
							<input name="startMin" id="startMin" type="text" value="${start_min }" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="startMax" type="text" value="${start_max }" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
						<li class="text">团号</li>
						<li>
						<li><input type="text" name="groupCode"/></li>
						<li class="text">部门</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames" value=""
							       readonly="readonly" onclick="showOrg()"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden"/>
						</li>
						<li class="text" style="width:100px;">计调</li>
						<li>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value=""
							       readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden"/>
						</li>
						<li class="text">状态</li>
						<li>
							<select name="payState">
								<option value="unPaid">未下账</option>
								<option value="paid">已下账</option>
							</select>
						</li>
						<li class="text">审核</li>
						<li>
							<select name="stateFinance">
								<option value="">请选择</option>
								<option value="1">已审核</option>
								<option value="0">未审核</option>
							</select>
						</li>
						<li class="text" style="width:10px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn();">搜索
							</button>
						</li>
						<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>
	<div id="divRight" style="float: left; width: 100px;height:400px;">
		<h2>已选择：</h2>
		<div class="clear"></div>
		<ul id="ulSel"></ul>
	</div>
</div>
</body>
</html>