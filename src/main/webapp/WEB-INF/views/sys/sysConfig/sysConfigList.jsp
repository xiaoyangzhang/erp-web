<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>系统配置</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body style="margin: 0 auto">

	<div id="breadcrumbs" class="breadcrumbs">
		<script type="text/javascript">
			try {
				ace.settings.check('breadcrumbs', 'fixed')
			} catch (e) {
			}
		</script>
		<ul class="breadcrumb">
			<li>
				<i class="icon-home home-icon"></i>
				系统配置>>新增
			</li>
		</ul>
	</div>

	<div class="row">
		<div class="col-sm-6">
			<div id="sample-table-2_length" class="dataTables_length">			
				<button class="btn btn-primary" id="btnAdd" onclick="add()">新增系统配置</button>
			</div>
		</div>
	</div>
	
	<div class="table-responsive">
		<table id="sample-table-1"
			class="table table-striped table-bordered table-hover">
			<thead>
				<tr>					
					<th>名称</th>
					<th>编码</th>
					<th>是否主系统</th>
					<th>是否web共用</th>
					<th>域名</th>
					<th>创建时间</th>
					<th>操作</th>
				</tr>
			</thead>

			<tbody>
				<c:forEach var="sys" items="${list }" >
					<tr>
						<td>${sys.name }</td>
						<td>${sys.code }</td>
						<td>
							<c:choose>
								<c:when test="${sys.isParent}">是
  								</c:when>
   								<c:otherwise>否
  								 </c:otherwise>
  							</c:choose>
  						</td>
						<td>
							<c:choose>
								<c:when test="${sys.isPublic}">是
  								</c:when>
   								<c:otherwise>否
  								 </c:otherwise>
  							</c:choose>
  						</td>
						<td>${sys.domainName }</td>
						<td>${sys.createTime }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
	</div>


</body>
</html>

