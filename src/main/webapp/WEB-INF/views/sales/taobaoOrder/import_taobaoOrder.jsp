<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>淘宝订单</title>
	<%@ include file="../../../include/top.jsp" %>
	<script type="text/javascript" src="<%=staticPath %>/assets/js/moment.js"></script>
	<SCRIPT type="text/javascript">
		$(function () {
			//$("#startMin").val(moment().format("YYYY-MM-DD"));
			//$("#startMax").val(moment().add(7, 'day').format("YYYY-MM-DD"));

			//queryList();
		});
	
		function queryList(page, pagesize) {
			if (!page || page < 1) {
				page = 1;
			}
			if (!pagesize || pagesize < 15) {
				pagesize = 15;
			}
			$("#page").val(page);
			$("#pageSize").val(pagesize);

			var options = {
				url: "<%=staticPath %>/taobao/import_taobaoOrder_table.htm",
				type: "post",
				dataType: "html",
			success: function (data) {
					$("#tableDiv").html(data);
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert("服务忙，请稍后再试");
				}
			}
			$("#queryForm").ajaxSubmit(options);
		}

		function searchBtn() {
			queryList(1, $("#pageSize").val());
		}
		
		function sureBtn() {
			var items = $("#tbody");
	        var itemsChecked = items.find("input[type='checkbox']");
			var retVal = [];
			itemsChecked.each(function(){
					if ($(this).prop("checked")){
						retVal.push($(this).val())
					}
			});
			// console.log(retVal);

			parent.loadTaobaoData(retVal); 
			
			//console.log(retVal);
	/* 		var Ids = taobaoIdAry.join(',');
			parent.loadTaobaoData(Ids); 
			 */
			
			var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
			parent.layer.close(index);
		}

		$(function () {
			queryList();
		});
		
		$(function(){
			  $("#ckAll").live("click",function(){
					 $("input[name='orderId']:enabled").prop("checked", this.checked);
			  });
			  $("input[name='orderId']").live("click",function() {
			    var $subs = $("input[name='orderId']");
			    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
			  });
		});
</SCRIPT>
<!-- <SCRIPT type="text/javascript">
	$(function(){
		var id = $("#test tr").val();
		alert("id="+id)
	})

	</SCRIPT> -->
</head>
<body>
<div class="p_container">
		<form id="queryForm">
			<input type="hidden" name="page" id="page"  value="${page.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"  value="${page.pageSize}" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" style="width:100px;">订单日期</li>
						<li>
							<input name="startMin" id="startMin" type="text" value="${start_min }" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="startMax" type="text" value="${start_max }" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
						
						<li class="text">订单号</li>
						<li><input type="text" name="tid"/></li>
						
						<li class="text">旺旺号</li>
						<li><input type="text" name="buyerNick"/></li>
						
						<li class="text">店铺</li>
						<li>
							<select name="myStoreId"> 
								<c:if test="${optMap_AY}"><option value="AY">爱游</option></c:if>
								<c:if test="${optMap_YM}"><option value="YM">怡美</option></c:if>
								<c:if test="${optMap_JY}"><option value="JY">景怡</option></c:if>
								<c:if test="${optMap_TX}"><option value="TX">天翔</option></c:if>
								<c:if test="${optMap_OUTSIDE}"><option value="OUTSIDE">出境店</option></c:if>
							</select>
						</li>
						
							<li class="text">状态</li>
						<li>
							<select name="myState">
								<option value="NEW">未组单</option>
								<option value="CONFIRM">已组单</option>
								<option value="CANCEL">废弃</option>	
								<option value="BEYOND">超出库存</option>
							</select>
						</li>
						
							<li class="text"style="width:100px;">产品名称</li>
						<li><input type="text" name="title"/></li>
						
						
						<li class="text" style="width:40px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
						</li>
						<li class="clear"/>
						<li class="text" style="width:40px;"></li>
						<li>
							 <button type="button" class="button button-primary button-small" onclick="sureBtn()">确定</button>
						</li>
							<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
</div>
</body>
</html>