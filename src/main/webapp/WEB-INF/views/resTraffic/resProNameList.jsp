<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>产品列表</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>

</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<div class="searchRow">
				<form id="searchProductForm">
					<dd class="inl-bl">
						<div class="dd_left">产品编号：</div>
						<div class="dd_right">
							<input name="code" type="text" class="w-100" /> <input
								type="hidden" name="state" value="${state }" /> <input
								type="hidden" id="searchPage" name="page" value="" /> <input
								type="hidden" id="searchPageSize" name="pageSize" value="" />
						</div>
						<div class="clear"></div>
					</dd>

					<dd class="inl-bl">
						<div class="dd_left">产品名称：</div>
						<div class="dd_right">
							<select class="select160" name="brandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select> <input type="text" name="productName" />
						</div>
						<div class="clear"></div>
					</dd>

					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();"
								class="button button-primary button-small">查询</button>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</div>
			<div id="productDiv">
				<%-- <jsp:include page="product_list_table.jsp"></jsp:include>		 --%>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		queryList();
	});
	$("#provinceCode").change(
			function() {
				var s = "<option value=''>请选择市</option>";
				var val = this.options[this.selectedIndex].value;
				if (val !== '') {
					$.getJSON("../basic/getRegion.do?id=" + val,
							function(data) {
								data = eval(data);
								$.each(data, function(i, item) {
									s += "<option value='" + item.id + "'>"
											+ item.name + "</option>";
								});
								$("#cityCode").html(s);
							});
				} else {
					$("#cityCode").html(s);
				}
			});

	function queryList(page, pageSize) {
		if (!page || page < 1) {
			page = 1;
		}
		if (!pageSize || pageSize < 1) {
			pageSize = 10;
		}
		$("#searchPageSize").val(pageSize);
		$("#searchPage").val(page);
		var options = {
			url : "<%=path%>/resTraffic/productList.do",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#productDiv").html(data);
				$(':checkbox[name=cb]').each(function() {
					$(this).click(function() {
						if ($(this).attr('checked')) {
							$(':checkbox[name=cb]').removeAttr('checked');
							$(this).attr('checked', 'checked');
							window.parent.$("#productId").val($(this).val());
						}
					});
				});
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.layerMsg("服务忙，请稍后再试", {
					icon : 1,
					time : 1000
				});
			}
		};
		$("#searchProductForm").ajaxSubmit(options);
	}
	function searchBtn() {
		queryList();
	}
</script>
</html>
