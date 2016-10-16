<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>结算单</title>
<%@ include file="../../../include/top.jsp"%>
	<script type="text/javascript">
	
	$(function() {
		var vars={
   			 dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
   		 	$("#consultDateFrom").val(vars.dateFrom);
   		 	 $("#consultDateTo").val(vars.dateTo );	
		queryList();
});
	function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		//$("#infoSourceName").val($("#infoSourceId option:selected").text());
		//$("#intentionDestName").val($("#intentionDestId option:selected").text());
		var options = {
				url:"../consult/consultGuestList.do",
				type:"post",
				/*async:true,*/
				dataType:"html",
				
				success:function(data){
					$("#tableDiv").html(data);
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					$.error("服务忙，请稍后再试");
				}
		};
		$("#form").ajaxSubmit(options);	
		
	}
	</script>
		<%-- <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %> --%>
	
</head>
<body>
	<div class="p_container">
		
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" value="${page.page }" />
			<input type="hidden" name="pageSize" id="pageSize" value="${page.pageSize }" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">咨询日期</li>
					<li><input id="consultDateFrom" name="consultDateFrom" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						~<input id="consultDateTo" name="consultDateTo" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
					</li>
					<li class="text">姓名</li>
					<li><input id="name"  name="name" type="text"/></li>
					<li class="text">电话</li>
					<li><input id="phone"  name="phone" type="text" style="width: 100px" /></li>
					<li class="text">咨询主题</li>
					<li><input id="topic"  name="topic" type="text" style="width: 200px" /></li>
					
					<li class="text">意向游玩</li>
					<li>
		  				<select id="intentionDestId" name="intentionDestId">
							<option value="" >全部</option>
							<c:forEach items="${intentionDestList }" var="idl">
							<option value="${idl.id }">${idl.value }</option>
							
							</c:forEach>
						</select>
						<input type="hidden" id="intentionDestName" name="intentionDestName" value=""/>
					</li>
					<li class="clear"/>
					<li class="text">信息渠道</li>
					<li>
		  				<select id="infoSourceId" name="infoSourceId">
							<option value="" >全部</option>
							<c:forEach items="${infoSourceList }" var="isl">
							<option value="${isl.id }">${isl.value }</option>
							</c:forEach>
						</select>
						<input type="hidden" id="infoSourceName" name="infoSourceName" value=""/>
					</li>
					<li class="clear"/>
					<li class="text">状态</li>
					<li>
		  				<select id="state" name="state">
							<option value="" >全部</option>
							<option value="1">跟进中</option>
							<option value="2">已成团</option>
							<option value="3">结束</option>
						</select>
					</li>
					<li class="clear"/>
					<li class="text">接待人</li>
					<li><input id="receiverName"  name="receiverName" type="text" style="width: 100px" /></li>
					<li class="text">跟进人</li>
					<li><input id="followerName"  name="followerName" type="text" style="width: 100px" /></li>
					 	<li><button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
					 	<button onclick="addConsult()" type="button"  class="button button-primary button-small">新增咨询</button>
					 </li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<script type="text/javascript">
	$("#btnQuery").click(function(){
		queryList(1,$("#pageSize").val());
	})
	
	function addConsult(){
			newWindow("新增咨询登记","<%=ctx%>/consult/addConsult.htm");
		}
	//查看跟进信息
	function viewConsultInfo(guestId){
		newWindow("查看咨询登记","<%=ctx%>/consult/viewConsult.htm?guestId="+guestId);
	}
	//跟进咨询
	function followConsult(guestId){
		newWindow("跟进咨询登记","<%=ctx%>/consult/followConsult.htm?guestId="+guestId);
	}
	//删除咨询记录
	function del(guestId){
		if(window.confirm("确定要删除吗？")){
			$.ajax({
				url:"delConsultGuest.do",
				type:"post",
				dataType:"json",
				data:{
					guestId:guestId
				},
				success:function(data){
					if(data.success){
						$.success("删除成功");
						queryList($("#page").val(),$("#pageSize").val());
					
					}
				},
				error:function(data,msg){
					$.error("删除失败，请稍后再试");
				}
			});
		}
		
	}
	</script>
</body>
</html>