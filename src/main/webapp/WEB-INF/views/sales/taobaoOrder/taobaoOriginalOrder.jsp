<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>淘宝原始单</title>
	<%@ include file="../../../include/top.jsp" %>
	<SCRIPT type="text/javascript">
		$(function () {
			function setData() {
				var curDate = new Date();
				var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
				$("#startMin").val(startTime);
				var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
				var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
				var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
				$("#startMax").val(endTime);
				var today=curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-"+curDate.getDate();
				$("#today").val(today);
				$("#today1").val(today);
				
				$("#startTime").val(today);
				$("#endTime").val(today);

			}
			setData();
//queryList();
		});
	
		
		function queryList(page, pagesize) {
			if (!page || page < 1) {
				page = 1;
			}
			$("#page").val(page);
			$("#pageSize").val(pagesize);

			var options = {
				url: "<%=staticPath %>/taobao/taobaoOriginalOrder_table.do",
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
		

		$(function () {
			queryList();
		});
		

		
		function cancelBtn() {
			var idss = $("input[name='idss']:checked").serialize();
			console.log(idss);
			if(idss==""){
				alert("请选择订单");
			}else{
			$.ajax({
	            type: "post",
	            url : "../taobao/updateCancel.do",
	            data: idss,
	        	success: function (data) {
	        		alert("废弃成功");
	        		searchBtn()
				},
				error: function () {
					alert("废弃失败");
				}
			});}
		}
		
		function newBtn() {
			var idss = $("input[name='idss']:checked").serialize();
			console.log(idss);
			if(idss==""){
				alert("请选择订单");
			}else{
			$.ajax({
	            type: "post",
	            url : "../taobao/updateNew.do",
	            data: idss,
	            success: function (data) {
	        		alert("还原成功");
	        		searchBtn()
				},
				error: function () {
					alert("还原失败");
				}
			});}
		}
		
			function synchBtn(){
			var type =$("input[type='radio']:checked").val();	
			var tid=$("#stid").val()
			console.log(type);
			if (type=="time") {
				$.ajax({
		            type: "post",
		            url : "../taobao/synchroByTime.do",
		            data:"startTime=" +$("#startTime").val() + "&endTime="+$("#endTime").val()+ "&authClient="+$("#authClient").val(),
		            success: function (data) {
		        		alert("同步成功");
		        		searchBtn()
					},
					error: function () {
						alert("同步失败");
					}
				}); 
			}else {
			$.ajax({
	          type: "post",
	          url : "../taobao/synchroByTid.do",
	          data:"tid=" + tid + "&authClient="+$("#authClient").val(),
	          success: function (data) {
	        		alert("同步成功");
	        		searchBtn()
				},
				error: function () {
					alert("同步失败");
				}
			});}
		}
		
		function synBtn(){
			layer.open({
				type : 1,
				title : '编辑数据权限',
				shadeClose : true,
				shade : 0.5,
				area: ['300px', '300px'],	
				content: $("#show").show()
			});
		}
		
		
</SCRIPT>
</head>
<body>
<div class="p_container" id=aaaa>
		<form id="queryForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${page.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${page.pageSize }"/>
			<%-- <input type="hidden" name="authClient" id="authClient" value="${authClient}"/> --%>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" style="">订单日期</li>
						<li>
							<input name="startMin" id="today" type="text" value="${start_min}" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="today1" type="text" value="${start_max}" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
						
						<li class="text">订单号</li>
						<li><input type="text" name="tid"/></li>
						
						<li class="text">旺旺号</li>
						<li><input type="text" name="buyerNick" style="width:100px"/></li>
					
						<li class="text">状态</li>
						<li>
							<select name="myState">
								<option value="NEW">未组单</option>
								<option value="CONFIRM">已组单</option>
								<option value="CANCEL">废弃</option>	
							</select>
						</li>
						<li class="text" >产品名称</li>
						<li><input type="text" name="title"/></li>
						<li class="text" >店铺</li>
						<li><select id="authClient" name="authClient"> 
								<c:if test="${optMap_AY}"><option value="AY">爱游</option></c:if>
								<c:if test="${optMap_YM}"><option value="YM">怡美</option></c:if>
								<c:if test="${optMap_JY}"><option value="JY">景怡</option></c:if>
								<c:if test="${optMap_TX}"><option value="TX">天翔</option></c:if>
								<c:if test="${optMap_OUTSIDE}"><option value="OUTSIDE">出境店</option></c:if>
							</select></li>
						
						<li class="text" style="width:35px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
							 <button id="btnOK" type="button" class="button button-primary button-small" onclick="synBtn()">同步</button>
							 <button id="btnOK" type="button" class="button button-primary button-small" onclick="cancelBtn()">废弃</button>
							 <button id="btnOK" type="button" class="button button-primary button-small" onclick="newBtn()">还原</button>
						</li>
							<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
		<div id="show"style="display: none; margin: 50px 50px;">
						<dd class="inl-bl">
						<input type="radio" name="type" value="time" />
						<label for="time"><span>按日期段: </span></label>
						<div class="dd_right grey">
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							至
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<br>
					<dd class="inl-bl">
					<input type="radio" name="type" value="stid" />
						<label for="stid"><span>按订单号: </span></label>
						<div class="dd_right grey">
							<input name="stid" id="stid" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
							<br>
							<button type="button" onclick="synchBtn()">开始同步</button>
			
	</div>
	
	</div>

</body>
</html>