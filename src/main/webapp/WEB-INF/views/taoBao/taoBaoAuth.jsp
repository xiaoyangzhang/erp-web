<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>淘宝授权</title>
    <script type="text/javascript">
        var authClient = "+${authClient}+";
        window.location.href = "https://oauth.taobao.com/authorize?state=0&response_type=code&client_id=23181518&redirect_uri=http://121.41.173.162:30000/yihg-top-api/pages/oauth/taobao/callback.jsp?authClient=" + authClient;
        //window.location.href = "https://oauth.taobao.com/authorize?state=0&response_type=code&client_id=23181518&redirect_uri=http://localhost:8080/yihg-top-api/pages/oauth/taobao/callback.jsp?authClient=" + authClient;
        
    </script>
</html>