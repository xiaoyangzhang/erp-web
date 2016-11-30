<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	<div class="p_container">
		<!-- 检索  -->
		<form action="listEmployee" method="post" name="employeeForm" id="employeeForm">
			<input name="page" type="hidden" id="page" value="${empList.page}">
			<input name="pageSize" type="hidden" id="pageSize" value="">
			<input name="orgId" type="hidden" id="orgId" value="${p.orgId}">
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">用户名</li>
						<li><input id="Text1" name="loginName" type="text" value="${p.loginName }" /></li>						
						<li class="text">姓名</li>
						<li><input id="name" name="name" type="text" value="${p.name }" /></li>						
						<li class="text">手机号</li>
						<li><input id="mobile" name="mobile" type="text" value="${p.mobile }" /></li>						
						<li class="text">状态</li>
						<li><select name="status" id="status" class="select160">
								<option value="1" <c:if test="${p.status == 1 }">selected</c:if>>正常</option>
								<option value="0" <c:if test="${p.status == 0 }">selected</c:if>>停用</option>
						</select></li>
						<li>&nbsp;<button class="button button-primary button-small" onclick="search();" title="检索">查询</button> 
							<button class="button button-primary button-small" onclick="newWindow('新增用户信息','<%=ctx %>/employee/editEmployee?orgId=${p.orgId }')">新增</button></li>
						<li class="clear" />
					</ul>
				</div>

			</div>
			<!-- 检索  -->


			<table cellspacing="0" cellpadding="0" class="w_table">
				<colgroup>
					<col width="4%" />
					<col width="4%" />
					<col  />
					<col width="10%" />
					<col width="10%" />
					<col width="6%" />
					<col width="10%" />
					<col width="20%" />
					<col width="6%" /> 
					<col width="15%" />
				</colgroup>
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>用户ID<i class="w_table_split"></i></th>
						<th>部门<i class="w_table_split"></i></th>
						<th>用户名<i class="w_table_split"></i></th>
						<th>姓名<i class="w_table_split"></i></th>
						<th>性别<i class="w_table_split"></i></th>
						<th>手机号<i class="w_table_split"></i></th>
						<th>角色<i class="w_table_split"></i></th>
						<th>状态<i class="w_table_split"></i></th>
						<th>操作</th>
					</tr>
				</thead>

				<tbody>

					<!-- 开始循环 -->
					<c:choose>
						<c:when test="${not empty empList.result}">
							<c:forEach items="${empList.result}" var="emp" varStatus="vs">
								<tr>
									<td class='center' style="width: 30px;">${vs.index+1}</td>
									<td>${emp.employeeId}</td>
									<td>${emp.orgName}</td>
									<td>${emp.loginName}</td>
									<td>${emp.name}</td>
									<td><c:if test="${emp.gender == 1 }">男</c:if> <c:if
											test="${emp.gender == 0 }">女</c:if></td>
									<td>${emp.mobile}</td>
									<td>${emp.roleName}</td>
									<td class="center">
									 	<c:if test="${emp.status == 1 }"><span class="log_action insert">有效</span></c:if>
										<c:if test="${emp.status == 0 }"><span class="log_action delete">停用</span></c:if>
									</td>
								<%--	<td class="center"><c:if test="${emp.isSuper == 0}">普通用户</c:if>
										<c:if test="${emp.isSuper == 1}">管理员</c:if></td> --%>
									<td class="center">
										<div class='hidden-phone visible-desktop btn-group'>
											<a class="def" title="编辑" href="javascript:void(0)"  onclick="newWindow('编辑用户信息','<%=staticPath %>/employee/editEmployee?employeeId=${emp.employeeId }')">编辑</a> 
											<a class="def" title="数据权限" href="#" onclick="viewUser('${emp.employeeId}')">数据权限</a>
											<a class="def" title="修改密码" href="#" onclick="editPass('${emp.employeeId}','${emp.name}')">改密码</a>
											<c:if test="${emp.isSuper != 1 }">
												<a class="def" title="删除" href="#"
													onclick="delEmp('${emp.employeeId}','${emp.name }');">删除</a>										
											</c:if>
										</div>
									</td>
								</tr>

							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr class="main_info">
								<td colspan="100" class="center">没有相关数据</td>
							</tr>
						</c:otherwise>
					</c:choose>


				</tbody>
			</table>
			
			<jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${p.page }" name="p" />
				<jsp:param value="${empList.totalPage }" name="tp" />
				<jsp:param value="${p.pageSize }" name="ps" />
				<jsp:param value="${empList.totalCount }" name="tn" />
			</jsp:include>
		</form>

	</div>
	<!-- <div style="float:left;width:200px;left:10px;position:absolute;top:20px;"  style="display :none">
			<ul id="treeArea" class="ztree"></ul>
		</div> -->

	<script type="text/javascript">
	
	
	//给弹出框赋值
	function editPass(id,name){	
		layer.open({
		    type: 2,
		    title: '修改密码',
		    skin: 'layui-layer-rim', //加上边框
		    area: ['480px', '260px'], //宽高
		  //  offset:['20px','50px'],
		    content: "resetPwd.htm?id="+id,
		    //btn: ['确定', '取消'],
			/* success:function(layero, index){
				//win = window[layero.find('iframe')[0]['name']];
				$.success("修改成功");
			}, */
			/* yes: function(index){
				//orgArr返回的是org对象的数组
				var orgArr = win.getOrgList();    				
				if(orgArr.length==0){
					$.warn("请选择组织结构");
					return false;
				}
				
				//for(var i=0;i<orgArr.length;i++){
					//console.log("id:"+orgArr[i].id+",name:"+orgArr[i].name);
				//}
				$("#orgId").val(orgArr[0].id);
				$("#orgName").val(orgArr[0].name);
				//一般设定yes回调，必须进行手工关闭
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    } */
		});	
	}		
		//检索
		function search(page){
			if (!page || page < 1) {
				page = 1;
			}
			$("#page").val(page);
			//queryList();
			$("#employeeForm").submit();
		}
		function queryList(page,pageSize) {
			if (!page || page < 1) {
				page = 1;
			}
			$("#page").val(page);			
			$("#pageSize").val(pageSize);
			$("#employeeForm").submit();
		}
		
		
		//删除
		function delEmp(employeeId,msg){
			
			$.confirm("确定要删除["+msg+"]吗?", function() {
				$.post("delEmployee", { employeeId: employeeId},
					   function(data){
					     if(data.success){
					    	 $.success("删除成功",function(){
					    		 location.reload();
					    	 }) 
					     }else{
					    	 $.error("删除失败");
					     }
					   },"json");					
				}
			);
		}
		//数据查看
		function viewUser(employeeId){
			var win;
    		layer.open({ 
    			type : 2,
    			title : '选择人员',
    			closeBtn : false,
    			area : [ '400px', '490px' ],
    			shadeClose : false,
    			content : 'orgUserDateRightTree.htm?employeeId='+employeeId,
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){    				
    				var userArr = win.getUserList();
    				if(userArr.length==0){
    					$.info("请选择人员");
    					return false;
    				}
    				//console.log(userArr);
    				submitOrgUser(userArr,employeeId);
    				 //一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
		}
		function submitOrgUser(userArr,employeeId){
			$.ajax({
					url:"<%=ctx%>/employee/saveOrgUser.do",
					dataType:"json",
					type:"post",
					data:{
						userArr:JSON.stringify(userArr),
						employeeId:employeeId
					},
					success:function(data){
						if(data.success){
							$.info("操作成功");
						}
						else{
							$.info("操作失败");
						}
					},
					error:function(){
						$.info("服务器忙，请稍候再试");
					}
			});
		//	$("#mainForm").ajaxSubmit(options);
		}
	<%-- 	//批量操作
		function makeAll(msg){
			bootbox.setDefaults({locale:"zh_CN"});
			bootbox.confirm(msg, function(result) {
				if(result) {
					var str = '';
					for(var i=0;i < document.getElementsByName('ids').length;i++)
					{
						  if(document.getElementsByName('ids')[i].checked){
						  	if(str=='') str += document.getElementsByName('ids')[i].id;
						  	else str += ';' + document.getElementsByName('ids')[i].id;

						  }
					}
					if(str==''){
						
					    bootbox.dialog({  
			                message: "您没有选择任何内容",  
			                title: "提示",  
			                buttons: {  
			                    Cancel: {  
			                        label: "关闭",  
			                        className: "btn-small btn-success",  
			                        callback: function () {  
			                         
			                        }  
			                    } 
			                }  
			            }); 
						$("#zcheckbox").tips({
							side:3,
				            msg:'点这里全选',
				            bg:'#AE81FF',
				            time:8
				        });
						
						return;
					}else{
						if(msg == '确定要删除选中的数据吗?'){
							
							$.ajax({
								type: "POST",
								url: '<%=basePath%>
		happuser/deleteAllU.do?tm='
																+ new Date()
																		.getTime(),
														data : {
															USER_IDS : str
														},
														dataType : 'json',
														//beforeSend: validateData,
														cache : false,
														success : function(data) {
															$
																	.each(
																			data.list,
																			function(
																					i,
																					list) {

																			});
														}
													});
										}

									}
								}
							});
		} --%>
	</script>



</body>
</html>
