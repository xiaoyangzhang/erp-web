<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	//用于获取动态请求的相对路径
	String ctx = request.getContextPath();
	//用于静态资源文件
	String staticPath = request.getContextPath();
%>
<script type="text/javascript">
	var ctx = "<%=ctx %>";
</script>