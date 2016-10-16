<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="en">
<head>
	<%@ include file="../../../include/top.jsp"%>
	<title>登录页</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	
	
</head>

<body>

	 <div id="login-center">    
			 <c:if test="${not empty errMsg}">
				<h2 id="error" class="alert alert-error">${errMsg}</h2>
			</c:if>
            <form id="loginform" class="form-vertical" action="login" method="post">
                        <div >
                           	 用户名：<input type="text" placeholder="请输入用户名" id="loginName" name="loginName"  />
                        </div>
                        <div >
                                                                    密码：&nbsp;<input type="password" placeholder="请输入密码" id="password" name="password"/>
                        </div>
                        <div >
                    <input type="button"  class="btn btn-success" onclick="login();" value="登录"> </input>
                    </div>
            </form>
        </div>
	
	<script type="text/javascript">
	      function login(){
	    	  var username = $("#loginName").val();
	    	  var password = $("#password").val();
	    	  if(username == ""){
	    		  $.warn("请输入用户名");
	    		  return false;
	    	  }
	    	  if(password == ""){
	    		  $.warn("请输入密码");
	    		  return false;
	    	  }
	    	  $("#loginform").submit();
	      }
	</script>
	
	
</body>
</html>
