<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	
<%
	int pageIndex = Integer.parseInt(request.getParameter("p"));
	int pageSize = Integer.parseInt(request.getParameter("ps"));
	int totalPage = Integer.parseInt(request.getParameter("tp"));
	int totalCount = 0;
	if(request.getParameter("tn")!=null){
		totalCount = Integer.parseInt(request.getParameter("tn"));		
	}
	String fnQuery, divId;
	fnQuery = request.getParameter("fnQuery");
	divId = request.getParameter("divId");
	if (fnQuery==null || fnQuery.equals("")){fnQuery="queryList";}
	if (divId==null || divId.equals("")){divId="pagination";}
%>
<div class="searchFooter">
	<div class="sp sp_skin" id="<%=divId%>">
		<!--上一页，首页  -->
		<span class="ptotal">总共<label><%=totalCount%></label>条，当前页数：<label><%=pageIndex%>/<%=totalPage%></label></span>
		<%if (pageIndex != 1) { %>
			<a href='javascript:<%=fnQuery%>(1,<%=pageSize %>)' title='首页'>&lt;&lt;</a>
			<a href='javascript:<%=fnQuery%>(<%=(pageIndex - 1) %>,<%=pageSize %>)' title='上一页'>&lt;</a>
		<%}else{ %>
			<a class="disable" href='javascript:void(0);' title='首页'>&lt;&lt;</a>
			<a class="disable" href='javascript:void(0);' title='上一页'>&lt;</a>
		<%} %>
		<!--页码  -->
		<%if (totalPage != 1) {
	  			int startNum = pageIndex - 3 <= 1 ? 1
	  					: pageIndex - 3;
	  			int endNum = pageIndex + 3 >= totalPage ? totalPage : pageIndex + 3;
	  			if (startNum > 1) { %>
	  		<a class="disable" href='javascript:void(0);'>...</a>	
	  	<% }
		  		for (int i = startNum; i <= endNum; i++) {
		  			if (i == pageIndex) {%>
		  	<a class="disable" href='javascript:void(0);' class='number curr' title='<%=i %>'><%=i %></a>
		<%}else { %>  	
		  		<a href='javascript:<%=fnQuery%>(<%=i %>,<%=pageSize %>)' class='number' title='<%=i %>'><%=i %></a>
		<%}
		  		}
		  			if (endNum < totalPage) { %> 		
		  		<a href='javascript:void(0);'>...</a>
		<%}
		  		}else{ %>  		
		  		<a href='javascript:void(0);' class='number curr' title='1'>1</a>
		<!--下一页，末页  -->
		<%}
	  		if (pageIndex < totalPage) { %>
	  		<a href='javascript:<%=fnQuery%>(<%=(pageIndex+1) %>,<%=pageSize %>)' title='下一页'>&gt;</a>
	  		<a href='javascript:<%=fnQuery%>(<%=(totalPage) %> ,<%=pageSize%>)'	title='末页'>&gt;&gt;</a>
	  	<%}else{ %>	
		  	<a class="disable" href='javascript:void(0);' title='下一页'>&gt;</a>
		  	<a class="disable" href='javascript:void(0);' title='末页'>&gt;&gt;</a>
		<%} %>
		<span class="ptotal"> <label>每页显示</label>
			<%-- <input type="number" id="NumberPageSize" value="<%=pageSize %>" min="1" onkeyup="this.value=this.value.replace(/\D/, '');"> --%>
			<select id="NumberPageSize" >
				 <option <%if(pageSize==15){ %> selected="selected"<%} %>>15</option>
				<option <%if(pageSize==25) {%> selected="selected"<%} %>>25</option>
				<option <%if(pageSize==50) {%> selected="selected"<%} %>>50</option>
				<option <%if(pageSize==100) {%> selected="selected"<%} %>>100</option>
				<option <%if(pageSize==200) {%> selected="selected"<%} %>>200</option>
				<option <%if(pageSize==500) {%> selected="selected"<%} %>>500</option> 
				
			</select>
			<label>条</label>
			<a href='javascript:bef<%=fnQuery%>()' title='GO'>GO</a>
		</span>
	</div>
	
	
	<script type="text/javascript">
		function bef<%=fnQuery%>(){
			var pageSize = $("#<%=divId%> #NumberPageSize").val();
			if(pageSize==0){
				pageSize=10;
			}
			<%=fnQuery%>(1,pageSize);
		}
	</script>
</div>