<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	//用于获取动态请求的相对路径
	String ctx = request.getContextPath();
	//用于静态资源文件
String staticPath = request.getContextPath();
%>
<script type="text/javascript">
    var ctx = "<%=ctx %>";
    // author: daixiaoman time:2016-11-30   防止全局命名被覆盖掉 默认赋值  "/yihg-erp-web"  路径配置
    var yihg_erp_web_config = {
        "ctxPath":ctx,
        "yihg_erp_user_token":"${userSession.userToken}"
    };
</script>