<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>组团中心-产品列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    
     <style>
		 .searchRow li.text {
			 width: 80px;
			 text-align: right;
			 margin-right: 10px;
		 }
	 </style>
</head>
<body>
  <div class="p_container" >
		
        <div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="searchProductForm">
				<input type="hidden" id="searchPage" name="page" value=""/>
				<input type="hidden" id="searchPageSize" name="pageSize" value=""/>
				<dd class="inl-bl">
						<div class="dd_left">状态：</div>
						<div class="dd_right grey">
							<select class="select160" name="state">
								
								<option value="">全部</option>
								<option value="1">待上架</option>
								<option value="2">已上架</option>
							</select>
						</div>
						<div class="clear"></div>
				</dd>
				<dd class="inl-bl">
						<div class="dd_left">产品编号:</div>
						<div class="dd_right grey">
							<input name="code" type="text"/>
						</div>
						<div class="clear"></div>
				</dd>
				
				<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<select class="select160" name="brandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select>
							<input type="text" name="productName"/>							
						</div>
						<div class="clear"></div>
				</dd>
				
				<dd class="inl-bl">
	    			<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    			<div class="dd_right">
	    				计调:
	    				<input type="text" name="operatorName" id="operatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="operatorIds" id="operatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    		</dd>
				
				<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<c:if test="${optMap['EDIT'] }">
								<a href="javascript:void(0)" onclick="newWindow('新增产品', '<%=path%>/productInfo/add.htm')" class="button button-primary button-small">新增</a>
							</c:if>
						</div>
						<input type="hidden" id="optEdit" value="${optMap['EDIT'] }"/>
						<div class="clear"></div>
				</dd>			
				</form>
				</dl>
				<dl class="p_paragraph_content">
	    	<div id="productDiv">
			
			</div>
			</dl>
        </div>

    </div>
    
  
</body>
<script type="text/javascript">
$(document).ready(function(){
	queryList();
});


		
function queryList(page,pageSize) {
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"productZTList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#productDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchProductForm").ajaxSubmit(options);	
}
function searchBtn() {
	var pageSize=$("#searchPageSize").val();
	queryList(1,pageSize);
}

/**删除产品**/
function delProduct(id){	
		$.confirm("确认删除此产品吗？",function(){
				  $.post("upState.do",{state:-1,id:id},function(data){
				   		if(data.success){
				   			$.success('删除成功！', function(){
                                queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
							});
//				   			$("#"+id).remove();
				   			
				   		}else{
				   			$.info(data.msg);
				   		}
				  },"json");
		},function(){
			  $.info('取消删除！');
			
		});
	
}


/**上架**/
function upState(id) {
    $.confirm("确认上架此产品吗？", function () {
        $.post("upState.do", {state: 2, id: id}, function (data) {
            if (data.success) {
                $.success('上架成功！', function () {
                    queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
                });

            } else {
                $.info(data.msg);
            }
        }, "json");
    }, function () {
        $.info('取消上架！');

    });

}

/**下架**/
function downState(id) {
    $.confirm("确认下架此产品吗？", function () {
        $.post("upState.do", {state: 3, id: id}, function (data) {
            if (data.success) {
                $.success('下架成功！', function () {
                    queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
                });
            } else {
                $.info(data.msg);
            }
        }, "json");
    }, function () {
        $.info('取消下架！');

    });

}
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

</html>
