<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String staticPath = request.getContextPath();
%>
<style type="">
	#addVerifyForm p{
		padding:10px;
	}
	#addVerifyForm label{
		display:inline-block;
		width:100px;
	}
	
	#addVerifyForm span{
		display:inline-block;
		width:200px;
	}
</style>
<div class="p_container">
	<form id="addVerifyForm">
		<p>
			<textarea rows="13" cols="80" id="replyMsg"  name="replyMsg"></textarea>
		</p>
		
	</form>
</div>

<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

</script>