<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>月报表统计</title>
	<%@ include file="../../../include/top.jsp" %>
</head>
<body>

<div class="p_container" id=aaaa>
		<form id="queryForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${pageBean.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${pageBean.pageSize }"/>
			<%-- <input type="hidden" name="authClient" id="authClient" value="${authClient}"/> --%>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">
							<select name="dateType" id="dateType">
								<option value="1">出团日期</option>
								<option value="2">离团日期</option>
							</select>
						</li>
						<li>
							<input name="startTime" id="startMin" type="text" value="${startMin}" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="endTime" id="startMax" type="text" value="${startMax}" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
					
						<li class="text" >团号：</li>
						<li><input type="text" name="groupCode"/></li>
					
					<li class="text" >客人信息：</li>
						<li><input type="text" name="receiveMode"/></li>
						
					<li class="text" >品牌名称：</li>
						<li><input type="text" name="productBrandName"/></li>
						<li class="clear"></li>
						
							<li class="text" >产品名称：</li>
						<li><input type="text" name="productName"/></li>
						<li class="clear"></li>
						</ul>
						<ul>
						<li class="text">商家名称：</li>
						<li><input type="text" name="supplierName"/></li>
						
						<li class="text">部门：</li>
						<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" style="width: 205px;"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	</li>    				
						<li class="text">
							<select name="operType" id="operType">
							<option value="2" <c:if test="${groupOrder.operType==2 }">selected="selected"</c:if>>客服</option>
								<option value="1" <c:if test="${groupOrder.operType==1 }">selected="selected"</c:if>>计调</option>
						</select></li>
						<li >
	    				<input type="text" name="operatorName" id="operatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="operatorIds" id="operatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
							</li>
							
							
						<li class="text">团队类别：</li>
						<li>
							<select name="groupMode" style="width: 61px;">
								<option value="1">团队</option>
							</select>
						</li>	
						<li class="text"></li>
						<li class="text">地接社名称：</li>
						<li><input type="text" name="deliveryName"/></li>
						<li class="text"></li>
						</ul>
						<ul>
						
						<li class="text">业务类型：</li>
							<li>
							<input type="text" id="dicNames" readonly="readonly"  onclick="commonDicDlg()"/> 
							<input type="hidden" name="orderNo" id="dicIds"  />
							</li>
							
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
						&nbsp;
							<button type="button" class="button button-primary button-small" onclick="toExportWord()">导出EXCEL</button>
						</li>
						<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>
<SCRIPT type="text/javascript">
function commonDicDlg() {
	$.dicItemDlg('SALES_TEAM_TYPE','dicNames','dicIds');
}

		function setData() {
			var curDate = new Date();
			var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
			$("#startMin").val(startTime);
			var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
			var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
			var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
			$("#startMax").val(endTime);
			var today=curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-"+curDate.getDate();
			//$("#today").val(today);
			//$("#today1").val(today);
			
			$("#startTime").val(today);
			$("#endTime").val(today);
		}
		
		function queryList(page, pagesize) {
			if (!page || page < 1) {
				page = 1;
			}
			$("#page").val(page);
			$("#pageSize").val(pagesize);

			var options = {
				url: "<%=staticPath %>/taobao/monthlyReportStatistics_table.do",
				type: "post",
				dataType: "html",
				success: function (data) {
					$("#tableDiv").html(data);
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert("服务忙，请稍后再试");
				}
			};
			$("#queryForm").ajaxSubmit(options);
		}

		function searchBtn() {
			queryList(1, $("#pageSize").val());
		}
		

		$(function () {
			setData();
			queryList();
		});
		
</SCRIPT>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
</body>

</html>