<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>资源列表</title>
	<%@ include file="../../include/top.jsp" %>
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
				url: "<%=staticPath %>/resTraffic/resourceList_table.do",
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

		function searchBtn() {
			queryList(1, $("#pageSize").val());
		}
		

		$(function () {
			queryList();
		});
		
		function  addBtn(){
			newWindow('新增资源','resTraffic/addResource.htm');
		}
		
		
</SCRIPT>
</head>
<body>
<div class="p_container" id=aaaa>
		<form id="queryForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${pageBean.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${pageBean.pageSize }"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" >日期</li>
						<li>
							<input name="startMin" id="startMin" type="text" value="" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="startMax" type="text" value="" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
			
						<li class="text">类型</li>
						<li>
							<select name="resMethod" id="resMethod" >
								<option value="AIR">飞机</option>
								<option value="TRAIN">火车</option>
								<option value="car">汽车</option>
							</select>
						</li>
						
							<li class="text">状态</li>
						<li>
							<select name=state id="state" >
								<option value="1">上架</option>
								<option value="0">下架</option>
								<option value="">所有</option>
							</select>
						</li>
						
							<li class="text" >名称</li>
						<li><input type="text" name="resName"/></li>
						
						
						<li class="text" style="width:35px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
							<button type="button" class="button button-primary button-small" onclick="addBtn()">新增</button>
						</li>
							<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>
	
<%-- <div id="show"style="display: none; margin: 50px 50px;">
 		<dd>
			<div class="dd_left">类别：</div> 
			<div class="dd_right"  id="a"><input type="radio" name="type" value="numStock" checked="checked"/><label for="numStock"><span>库存</span></label> <input type="radio" name="type" value="numDisable" /> <label for="numDisable"><span>机动位</span></label>
			</div>
			<div class="clear"></div>
		</dd>  
		<dd>
			<div class="dd_left">调整：</div> 
			<div class="dd_right" id="b"><input type="radio" name="numType" value="add" checked="checked"/><label for="add"><span>增加</span></label> <input type="radio" name="numType" value="minus" /> <label for="minus"><span>减少 </span></label>
			</div>
			<div class="clear"></div>
		</dd>  
		<dd>
			<div class="dd_left">数量：</div> 
			<div class="dd_right"><input type="text" name="num" value="${0}"></div>
			<div class="clear"></div>
		</dd>
		<button type="button" onclick="stockChange_submit()"  class="button button-primary button-small" style="margin-left:100px">确定</button>
</div> --%>
<div id="stateModal" style="display: none">
		<input type="hidden" name="id" id="modalResId" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">状态:</div>
				<div class="dd_right">
					<select name="State" id="modalResState">
						<option value="0">下架</option>
						<option value="1">上架</option>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="button" class="button button-primary button-small" onclick="stateChange_submit()">确定</button>
		</div>
</div>
<input type="hidden" id="modalResId" value="0" />
<input type="hidden" id="modalResState" value="" />
<script type="text/javascript">

function stockChange_show(id){
	/* $("#modalResId").val(resId); */
	/* layer.open({
		type : 1,
		title : '设置库存/机动位',
		shadeClose : true,
		shade : 0.5,
		area: ['400px', '350px'],	
		content: $("#show").show()
	}); */
	layer.open({
		type : 2,
		title : '机位库存状态',
		shadeClose : true,
		shade : 0.5,
		area: ['720px', '460px'],
		content: '<%=staticPath%>/resTraffic/toUpdateResNumStockChange.htm?id='+id
	});
}

function stockChange_submit(){
	var type = $('#a input[name="type"]:checked ').val(),
	 	  numType = $('#b input[name="numType"]:checked ').val(),
	      num=$("input[name='num']").val(),
	      resId=$("#modalResId").val();
	if(num==0||num==""){
		$.warn("请设置库存或机动位！");
	}else{
		$.ajax({
        type: "post",
        url : "../resTraffic/change.do",
        data:"type=" + type + "&numType="+numType+"&num="+num+"&resId="+resId,
        success: function (data) {
        	$.success('操作成功',function(){
				layer.closeAll();
				queryList($("#page").val(), $("#pageSize").val()); // 刷新页面
			});
      		
		},
		error: function () {
			$.error('设置失败');
		}
		});
	}
}


function stateChange_show(resId,state){
	$("#modalResId").val(resId);
	$("#modalResState").val(state);
	setOptionState(state);
	layer.open({
		type : 1,
		title : '上架/下架',
		shadeClose : true,
		shade : 0.5,
		area : ['350px','210px'],
		content : $('#stateModal')
	});
	
}
function setOptionState(state){
	var sltState = document.getElementById("modalResState");
	while (sltState.firstChild) {
		sltState.removeChild(sltState.firstChild); 
	}
	if(state==0){
		var option1 = new Option("上架", "1");
		document.getElementById("modalResState").options.add(option1);
	}else if(state==1){
		var option2 = new Option("下架","0");
		document.getElementById("modalResState").options.add(option2);
	}
}
function stateChange_submit(){
	var resId=$("#modalResId").val();
	var state=$("#modalResState").val();
	$.getJSON("../resTraffic/changeResState.do?id="+ resId +"&state="+state, function(data) {
		if (data.success) {
			$.success('操作成功',function(){
				reloadPage(); // 刷新页面
			});
			
		}
	});
}
function reloadPage(){
	$.success('操作成功',function(){
		layer.closeAll();
		queryList($("#page").val(), $("#pageSize").val()); // 刷新页面
	});
	
}

</script>	
</body>
</html>