<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplier.js"></script>
<script type="text/javascript">
	
function addManDIV(){
	
	$('#saveManInfoForm')[0].reset();
	layer.open({ 
		type : 1,
		title : '添加联系人信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '550px', '400px' ],
		content :$('#addModal')
	});

	
	
}
function ImpManDIV(){
	
	layer.open({ 
		type : 1,
		title : '导入联系人信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '800px', '400px' ],
		content :$('#impModal')
	});
}

</script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="toEditSupplier.htm?id=${supplierId}&operType=${operType}">基本信息</a></li>
			<li><a
				href="toBusinessInfo.htm?supplierId=${supplierId}&operType=${operType}">结算信息</a></li>
			<li><a href="javascript:void(0)" class="selected">联系人</a></li>
			<li><a
				href="toFolderList.htm?id=${supplierId}&supplierType=${supplierType}&operType=${operType}">图片</a></li>

			
			<li class="clear"></li>
		</ul>
		<div class="p_container_sub" id="tab3">
			<c:if test="${operType==1}">
				<div class="searchRow">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 80%">
							<button class="button button-primary button-small" type="button"
								onclick="ImpManDIV()">导入</button>
							<button class="button button-primary button-small" type="button"
								onclick="addManDIV()">新增</button>
						</div>
						<div class="clear"></div>
					</dd>
				</div>
			</c:if>
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>

					<div class="dd_right" style="width: 80%">
						<table cellspacing="0" cellpadding="0" class="w_table">
							<thead>
								<tr>
									<th width="10%">姓名</th>
									<th width="10%">称谓</th>
									<th width="10%">性别</th>
									<th width="10%">部门</th>
									<th width="10%">职位</th>
									<th width="10%">手机</th>
									<th width="10%">座机</th>
									<th width="10%">传真</th>
									<c:if test="${operType==1}">
										<th width="20%">操作</th>
									</c:if>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${manList}" var="man">
									<tr>
										<td>${man.name }</td>
										<td>${man.nameShort }</td>
										<td><c:if test="${man.gender==1}">男</c:if> <c:if
												test="${man.gender==2}">女</c:if></td>
										<td>${man.department }</td>
										<td>${man.position }</td>
										<td>${man.mobile }</td>
										<td>${man.tel }</td>
										<td>${man.fax }</td>
										<c:if test="${operType==1}">
											<td><a href="javascript:void(0);" class="def"
												onclick="toEditMan(${man.id})">修改</a> <a
												href="javascript:void(0);" class="def"
												onclick="delPrivateMan(${supplierId},${man.id})">删除</a></td>
										</c:if>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</div>
	</div>


	<!-- 联系人增加弹出层开始 -->


	<div id="addModal" style="display: none">
		<form class="definewidth m20" id="saveManInfoForm">
			<input type="hidden" name="supplierId" value="${supplierId}" />
			<dl class="p_paragraph_content">

				<div>
					<div class="dd_left">姓名</div>
					<div class="dd_right">
						<input type="text" name="name" class="IptText301" />
					</div>
					<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">称谓</div>
						<div class="dd_right">
							<input type="text" name="nameShort" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">性别</div>
						<div class="dd_right">
							<input type="radio" name="gender" value="1" checked="checked">男</input><input
								type="radio" name="gender" value="2">女</input>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">出生日期</div>
						<div class="dd_right">
							<input type="text" name="birthDate" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">部门</div>
						<div class="dd_right">
							<input type="text" name="department" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">职位</div>
						<div class="dd_right">
							<input type="text" name="position" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">手机</div>
						<div class="dd_right">
							<input type="text" name="mobile" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">QQ</div>
						<div class="dd_right">
							<input type="text" name="qq" maxlength="14" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">微信</div>
						<div class="dd_right">
							<input type="text" name="wechat" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">邮箱</div>
						<div class="dd_right">
							<input type="text" name="email" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">传真</div>
						<div class="dd_right">
							<input type="text" name="fax" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">座机</div>
						<div class="dd_right">
							<input type="text" name="tel" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">备注</div>
						<div class="dd_right">
							<input type="text" name="note" class="IptText301" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left"></div>
						<div class="dd_right">
							<button type="submit" class="button button-primary button-small">提交</button>
						</div>
						<div class="clear"></div>
					</dd>
			</dl>

		</form>
	</div>
	<!-- 联系人增加弹出层结束 -->




	<!-- 联系人编辑弹出层开始 -->
	<div id="editModal" style="display: none">
		<form class="definewidth m20" id="editManInfoForm">
			<input type="hidden" name="id" id="manId" value="" /> <input
				type="hidden" name="supplierId" value="${supplierId}" />

			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">姓名</div>
					<div class="dd_right">
						<input type="text" name="name" id="manName" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">称谓</div>
					<div class="dd_right">
						<input type="text" name="nameShort" class="IptText301"
							id="manNameShort" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">性别</div>
					<div class="dd_right">
						<input type="radio" name="gender" value="1">男</input><input
							type="radio" name="gender" value="2">女</input>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">出生日期</div>
					<div class="dd_right">
						<input type="text" name="birthDate" id="manBirthDate"
							class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">部门</div>
					<div class="dd_right">
						<input type="text" name="department" class="IptText301"
							id="manDepartment" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">职位</div>
					<div class="dd_right">
						<input type="text" name="position" class="IptText301"
							id="manPosition" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">手机</div>
					<div class="dd_right">
						<input type="text" name="mobile" class="IptText301" id="manMobile" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">QQ</div>
					<div class="dd_right">
						<input type="text" name="qq" class="IptText301" id="manQQ" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">微信</div>
					<div class="dd_right">
						<input type="text" name="wechat" class="IptText301" id="manWechat" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">邮箱</div>
					<div class="dd_right">
						<input type="text" name="email" class="IptText301" id="manEmail" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">传真</div>
					<div class="dd_right">
						<input type="text" name="fax" class="IptText301" id="manFax" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">座机</div>
					<div class="dd_right">
						<input type="text" name="tel" class="IptText301" id="manTel" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">备注</div>
					<div class="dd_right">
						<input type="text" name="note" class="IptText301"  id="manNote"/>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit" class="button button-primary button-small">提交</button>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>
	<!-- 联系人编辑弹出层结束 -->


	<!-- 导入联系人弹出层开始 -->


	<div id="impModal" style="display: none" class="p_container">
		<input type="hidden" name="supplierId" value="${supplierId}" />
		<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="7%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<tr>
				<td></td>
				<td>姓名<i class="w_table_split"></i></td>
				<td>称谓<i class="w_table_split"></i></td>
				<td>性别<i class="w_table_split"></i></td>
				<td>部门<i class="w_table_split"></i></td>
				<td>职位<i class="w_table_split"></i></td>
				<td>手机<i class="w_table_split"></i></td>
				<td>座机<i class="w_table_split"></i></td>
				<td>传真</td>
			</tr>
			<tbody>
				<c:if test="${fn:length(allManList)==0 }">
					<tr>
						<td colspan="9">暂无可用联系人信息</td>
					</tr>
				</c:if>
				<c:if test="${fn:length(allManList)!=0 }">
					<c:forEach items="${allManList}" var="man" varStatus="index">
						<tr>
							<td><input type="checkbox" name="manChecked"
								value="${man.id}" /></td>
							<td>${man.name }</td>
							<td>${man.nameShort }</td>
							<td><c:if test="${man.gender==1}">男</c:if> <c:if
									test="${man.gender==2}">女</c:if></td>
							<td>${man.department}</td>
							<td>${man.position}</td>
							<td>${man.mobile}</td>
							<td>${man.tel}</td>
							<td>${man.fax}</td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
		</table>
		<br />
		<div class="dd_right">
			<button type="button" class="button button-primary button-small"
				onclick="impBtn(${supplierId});">提交</button>
		</div>
	</div>
	<!-- 导入联系人弹出层结束 -->

</body>
</html>